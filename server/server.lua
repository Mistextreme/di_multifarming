-- ============================================================
-- di_multifarming | server/server.lua
-- Framework : ESX-Legacy
-- Inventory : ox_inventory (server exports)
-- ============================================================

ESX = exports['es_extended']:getSharedObject()

-- ============================================================
-- WEBHOOK UTILITY
-- ============================================================

---Send a Discord embed to a configured webhook.
---@param webhookKey string  key in Config.Webhooks
---@param title string
---@param description string
---@param color number  decimal colour for Discord embed
---@param fields table  array of {name, value, inline}
local function sendWebhook(webhookKey, title, description, color, fields)
    local url = Config.Webhooks[webhookKey]
    if not url or url == '' then return end

    local payload = json.encode({
        username = 'DOTINIT Farming',
        embeds   = {
            {
                title       = title,
                description = description,
                color       = color or 3447003,
                fields      = fields or {},
                footer      = { text = os.date('%Y-%m-%d %H:%M:%S') }
            }
        }
    })

    PerformHttpRequest(url, function() end, 'POST', payload, { ['Content-Type'] = 'application/json' })
end

-- ============================================================
-- CONFIG LOOKUP HELPERS
-- ============================================================

---Find a processing entry by cropType string.
---@param cropType string
---@return table|nil
local function getProcessEntry(cropType)
    for _, entry in ipairs(Config.process.crops) do
        if entry.cropType == cropType then
            return entry
        end
    end
    return nil
end

---Find a shop item's price by item name.
---@param itemName string
---@return number|nil
local function getShopItem(itemName)
    for _, loc in ipairs(Config.Shop.Locations) do
        for _, item in ipairs(loc.items) do
            if item.name == itemName then
                return item.price
            end
        end
    end
    return nil
end

---Find a sell item's price and payout type by item name.
---@param itemName string
---@return number|nil price, string payoutType
local function getSellItem(itemName)
    for _, loc in ipairs(Config.Sell.Locations) do
        for _, item in ipairs(loc.items) do
            if item.name == itemName then
                local payoutType = (item.payout and item.payout.type) or 'cash'
                return item.price, payoutType
            end
        end
    end
    return nil, 'cash'
end

-- ============================================================
-- OX_INVENTORY SERVER HELPERS
-- ============================================================

---Return the count of an item in a player's ox_inventory.
---@param source number
---@param itemName string
---@return number
local function getItemCount(source, itemName)
    local count = exports.ox_inventory:GetItem(source, itemName, nil, true)
    return count or 0
end

---Remove items from a player's ox_inventory.
---@param source number
---@param itemName string
---@param count number
---@return boolean
local function removeItem(source, itemName, count)
    return exports.ox_inventory:RemoveItem(source, itemName, count)
end

---Add items to a player's ox_inventory.
---@param source number
---@param itemName string
---@param count number
---@return boolean
local function addItem(source, itemName, count)
    return exports.ox_inventory:AddItem(source, itemName, count)
end

-- ============================================================
-- CALLBACK: PICK CROP
-- ============================================================

ESX.RegisterServerCallback('di_multifarming:pickCrop', function(source, cb, cropName, locIndex)

    -- Validate crop config exists
    local crop = Config.Crops[cropName]
    if not crop then
        cb(false, 'Invalid crop.')
        return
    end

    -- Validate ESX player
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(false, 'Player not found.')
        return
    end

    -- Server-authoritative tool check
    local toolCount = getItemCount(source, crop.requiredItem)
    if toolCount < 1 then
        cb(false, string.format('You need a %s to harvest.', crop.requiredItem))
        return
    end

    -- Tool break chance
    if crop.breakChance and crop.breakChance > 0 then
        if math.random(1, 100) <= crop.breakChance then
            removeItem(source, crop.requiredItem, 1)
            cb(false, string.format('Your %s broke!', crop.requiredItem))
            return
        end
    end

    -- Calculate random yield
    local amount = math.random(crop.amount.min, crop.amount.max)

    -- Try to give item
    local success = addItem(source, crop.item, amount)
    if not success then
        cb(false, 'Your inventory is full.')
        return
    end

    -- Webhook log
    local playerName = GetPlayerName(source)
    sendWebhook(
        crop.webhook,
        '🌾 Crop Picked',
        string.format('**%s** harvested **%dx %s**', playerName, amount, crop.item),
        5763719,
        {
            { name = 'Player',   value = playerName,        inline = true },
            { name = 'Crop',     value = cropName,           inline = true },
            { name = 'Amount',   value = tostring(amount),   inline = true },
            { name = 'Location', value = tostring(locIndex), inline = true }
        }
    )

    cb(true, string.format('You picked %dx %s!', amount, crop.item))
end)

-- ============================================================
-- CALLBACK: PROCESS CROP
-- ============================================================

ESX.RegisterServerCallback('di_multifarming:processCrop', function(source, cb, cropType)

    -- Validate process entry
    local entry = getProcessEntry(cropType)
    if not entry then
        cb(false, 'Invalid crop type.')
        return
    end

    -- Validate ESX player
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(false, 'Player not found.')
        return
    end

    -- Check input inventory
    local inputCount = getItemCount(source, entry.input)
    if inputCount < entry.required then
        cb(false, string.format(
            'You need %dx %s. You only have %d.',
            entry.required, entry.input, inputCount
        ))
        return
    end

    -- Remove input items first
    local removed = removeItem(source, entry.input, entry.required)
    if not removed then
        cb(false, 'Failed to consume input items. Try again.')
        return
    end

    -- Give output item; refund input on failure
    local success = addItem(source, entry.output, entry.reward)
    if not success then
        addItem(source, entry.input, entry.required) -- refund
        cb(false, 'Your inventory is full. Processing refunded.')
        return
    end

    -- Webhook log
    local playerName = GetPlayerName(source)
    sendWebhook(
        'bulk_sell',
        '🏭 Crop Processed',
        string.format(
            '**%s** processed **%dx %s** → **%dx %s**',
            playerName, entry.required, entry.input, entry.reward, entry.output
        ),
        15844367,
        {
            { name = 'Player', value = playerName,                              inline = true },
            { name = 'Input',  value = entry.required .. 'x ' .. entry.input,  inline = true },
            { name = 'Output', value = entry.reward   .. 'x ' .. entry.output, inline = true }
        }
    )

    cb(true, string.format(
        'Processed %dx %s into %dx %s!',
        entry.required, entry.input, entry.reward, entry.output
    ))
end)

-- ============================================================
-- CALLBACK: BUY ITEM FROM SHOP
-- ============================================================

ESX.RegisterServerCallback('di_multifarming:buyItem', function(source, cb, itemName)

    -- Validate item against server-side config (prevents price manipulation)
    local price = getShopItem(itemName)
    if not price then
        cb(false, 'That item is not available in the shop.')
        return
    end

    -- Validate ESX player
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(false, 'Player not found.')
        return
    end

    -- Check cash balance
    local cash = xPlayer.getMoney()
    if cash < price then
        cb(false, string.format('You need $%d. You only have $%d.', price, cash))
        return
    end

    -- Deduct money then give item; refund on inventory full
    xPlayer.removeMoney(price)
    local success = addItem(source, itemName, 1)
    if not success then
        xPlayer.addMoney(price) -- refund
        cb(false, 'Your inventory is full.')
        return
    end

    -- Webhook log
    local playerName = GetPlayerName(source)
    sendWebhook(
        'buy',
        '🛒 Item Purchased',
        string.format('**%s** bought **1x %s** for **$%d**', playerName, itemName, price),
        3447003,
        {
            { name = 'Player', value = playerName,   inline = true },
            { name = 'Item',   value = itemName,     inline = true },
            { name = 'Price',  value = '$' .. price, inline = true }
        }
    )

    cb(true, string.format('Purchased 1x %s for $%d!', itemName, price))
end)

-- ============================================================
-- CALLBACK: SELL ITEMS
-- ============================================================
--
-- Expects itemsToSell = array of { name = string, count = number }
-- Server validates price, actual inventory count, and payout type.
-- ============================================================

ESX.RegisterServerCallback('di_multifarming:sellItems', function(source, cb, itemsToSell)

    -- Basic input validation
    if not itemsToSell or type(itemsToSell) ~= 'table' or #itemsToSell == 0 then
        cb(false, 'Nothing to sell.')
        return
    end

    -- Validate ESX player
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(false, 'Player not found.')
        return
    end

    local totalEarned = 0
    local cashEarned  = 0
    local bankEarned  = 0
    local logLines    = {}

    for _, entry in ipairs(itemsToSell) do
        local itemName     = entry.name
        local requestedQty = tonumber(entry.count) or 0

        if requestedQty <= 0 then goto continue end

        -- Server-side price lookup (client cannot tamper with pricing)
        local price, payoutType = getSellItem(itemName)
        if not price then goto continue end

        -- Clamp to actual inventory to prevent oversell exploits
        local actualQty  = getItemCount(source, itemName)
        local qtyToSell  = math.min(requestedQty, actualQty)
        if qtyToSell <= 0 then goto continue end

        -- Remove items from inventory
        local removed = removeItem(source, itemName, qtyToSell)
        if not removed then goto continue end

        -- Accumulate earnings by payout type
        local earned  = qtyToSell * price
        totalEarned   = totalEarned + earned
        if payoutType == 'bank' then
            bankEarned = bankEarned + earned
        else
            cashEarned = cashEarned + earned
        end

        logLines[#logLines + 1] = string.format('%dx %s ($%d)', qtyToSell, itemName, earned)

        ::continue::
    end

    if totalEarned <= 0 then
        cb(false, 'Could not sell any items. Check your inventory.')
        return
    end

    -- Pay the player per account type
    if cashEarned > 0 then xPlayer.addMoney(cashEarned) end
    if bankEarned > 0 then xPlayer.addAccountMoney('bank', bankEarned) end

    -- Webhook log
    local playerName = GetPlayerName(source)
    sendWebhook(
        'bulk_sell',
        '💰 Crops Sold',
        string.format(
            '**%s** sold crops for a total of **$%d**\n%s',
            playerName, totalEarned, table.concat(logLines, '\n')
        ),
        5763719,
        {
            { name = 'Player',       value = playerName,         inline = true },
            { name = 'Total Earned', value = '$' .. totalEarned, inline = true }
        }
    )

    cb(true, string.format('Sold for $%d!', totalEarned))
end)