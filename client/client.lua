-- ============================================================
-- di_multifarming | client/client.lua
-- Framework : ESX-Legacy
-- Target    : ox_target
-- Inventory : ox_inventory
-- UI        : ox_lib
-- Emotes    : rpemotes
-- ============================================================

local ESX = exports['es_extended']:getSharedObject()

-- ============================================================
-- STATE TABLES
-- ============================================================

local spawnedProps      = {}  -- [key] = entityHandle
local activeZones       = {}  -- [key] = ox_target zone id
local pickedLocations   = {}  -- [key] = true  (on respawn cooldown, no interaction)
local pickingInProgress = {}  -- [key] = true  (currently picking, blocks double-trigger)
local spawnedPeds       = {}  -- list of ped entityHandles for cleanup
local processProps      = {}  -- list of process-area prop entityHandles

-- ============================================================
-- EMOTE HELPERS
-- ============================================================

local function playEmote(emoteName)
    if not emoteName or emoteName == '' then return end
    TriggerEvent('rpemotes:client:EmoteCommandFunc', emoteName)
end

local function stopEmote()
    -- 'c' is the rpemotes cancel shortcut
    TriggerEvent('rpemotes:client:EmoteCommandFunc', 'c')
end

-- ============================================================
-- PROP HELPERS
-- ============================================================

---Spawn a world object at coords, optionally frozen/invincible.
---@param model string  GTA prop model name
---@param coords vector3
---@param heading number|nil  entity heading (nil = keep default)
---@param freeze boolean  freeze + invincible + no collision
---@return number|nil  entity handle, or nil on failure
local function spawnProp(model, coords, heading, freeze)
    local hash = GetHashKey(model)
    if not IsModelValid(hash) then
        print(string.format('[di_multifarming] WARNING: Invalid prop model "%s"', model))
        return nil
    end
    lib.requestModel(model)
    local entity = CreateObject(hash, coords.x, coords.y, coords.z, false, false, false)
    if heading then
        SetEntityHeading(entity, heading)
    end
    PlaceObjectOnGroundProperly(entity)
    if freeze then
        FreezeEntityPosition(entity, true)
        SetEntityInvincible(entity, true)
        SetEntityCollision(entity, false, false)
    end
    SetModelAsNoLongerNeeded(hash)
    return entity
end

---Delete a tracked prop by its state key.
---@param key string
local function removeProp(key)
    local entity = spawnedProps[key]
    if entity and DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
    spawnedProps[key] = nil
end

-- ============================================================
-- SECURITY HELPER
-- ============================================================

---Returns true when the player is within radius of coords
---(or always true when enforceLocations = false).
---@param coords vector3
---@param radius number
---@return boolean
local function isNearLocation(coords, radius)
    if not Config.Security.enforceLocations then return true end
    return #(GetEntityCoords(PlayerPedId()) - coords) <= radius
end

-- ============================================================
-- BLIPS
-- ============================================================

local function createBlips()
    for name, blipData in pairs(Config.Blips) do
        if blipData.enable then
            local blip = AddBlipForCoord(blipData.location.x, blipData.location.y, blipData.location.z)
            SetBlipSprite(blip, blipData.sprite)
            SetBlipColour(blip, blipData.color)
            SetBlipScale(blip, blipData.scale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(blipData.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end

-- ============================================================
-- PED SPAWNING
-- ============================================================

---Create a frozen scenario ped at the given vector4 coords.
---@param model string  ped model name
---@param coords vector4
---@return number  ped entity handle
local function spawnScenarioPed(model, coords)
    lib.requestModel(model)
    local hash = GetHashKey(model)
    local ped  = CreatePed(4, hash, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetPedCanRagdoll(ped, false)
    SetModelAsNoLongerNeeded(hash)
    return ped
end

-- ============================================================
-- PROCESS ZONE
-- ============================================================

local function spawnProcessProps()
    local loc = Config.process.location

    if Config.process.prop and Config.process.prop.enabled then
        local cfg    = Config.process.prop
        local coords = vector3(loc.x + cfg.offset.x, loc.y + cfg.offset.y, loc.z + cfg.offset.z)
        local entity = spawnProp(cfg.model, coords, cfg.heading, true)
        if entity then
            processProps[#processProps + 1] = entity
        end
    end

    if Config.process.box and Config.process.box.enabled then
        local cfg    = Config.process.box
        local coords = vector3(loc.x + cfg.offset.x, loc.y + cfg.offset.y, loc.z + cfg.offset.z)
        local entity = spawnProp(cfg.model, coords, nil, true)
        if entity then
            processProps[#processProps + 1] = entity
        end
    end
end

local function openProcessMenu()
    local loc = Config.process.location
    if not isNearLocation(vector3(loc.x, loc.y, loc.z), Config.Security.processRadius) then
        lib.notify({ title = 'Farming', description = 'You are not close enough to the processing station.', type = 'error' })
        return
    end

    local menuOptions = {}

    for _, entry in ipairs(Config.process.crops) do
        -- or 0: ox_inventory:Search returns 0 for items not found, but guard against edge-case nil
        local haveCount  = exports.ox_inventory:Search('count', entry.input) or 0
        local canProcess = haveCount >= entry.required

        menuOptions[#menuOptions + 1] = {
            title       = entry.label,
            icon        = canProcess and 'fas fa-industry' or 'fas fa-times-circle',
            iconColor   = canProcess and '#4caf50' or '#f44336',
            description = string.format(
                'Requires: %dx %s  →  %dx %s  |  You have: %d',
                entry.required, entry.input, entry.reward, entry.output, haveCount
            ),
            disabled    = not canProcess,
            onSelect    = function()
                playEmote(Config.process.emote)

                local success = lib.progressBar({
                    duration     = Config.process.time * 1000,
                    label        = 'Processing ' .. entry.label .. '...',
                    useWhileDead = false,
                    canCancel    = true,
                    disable      = { car = true, move = true, combat = true },
                })

                stopEmote()

                if not success then
                    lib.notify({ title = 'Farming', description = 'Processing cancelled.', type = 'error' })
                    return
                end

                ESX.TriggerServerCallback('di_multifarming:processCrop', function(ok, msg)
                    lib.notify({ title = 'Processing', description = msg, type = ok and 'success' or 'error' })
                end, entry.cropType)
            end
        }
    end

    lib.registerContext({ id = 'di_process_menu', title = '🏭 Crop Processing', options = menuOptions })
    lib.showContext('di_process_menu')
end

local function registerProcessZone()
    spawnProcessProps()

    local loc = Config.process.location

    -- Process blip
    if Config.process.blip and Config.process.blip.enable then
        local blip = AddBlipForCoord(loc.x, loc.y, loc.z)
        SetBlipSprite(blip, Config.process.blip.sprite)
        SetBlipColour(blip, Config.process.blip.color)
        SetBlipScale(blip, Config.process.blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.process.blip.label)
        EndTextCommandSetBlipName(blip)
    end

    exports.ox_target:addSphereZone({
        coords  = vector3(loc.x, loc.y, loc.z),
        radius  = Config.Security.processRadius,
        debug   = false,
        options = {
            {
                name     = 'di_process_crops',
                icon     = 'fas fa-industry',
                label    = 'Process Crops',
                onSelect = function()
                    openProcessMenu()
                end
            }
        }
    })
end

-- ============================================================
-- SHOP SYSTEM
-- ============================================================

local function openShopMenu(shopLocationData)
    local menuOptions = {}

    for _, item in ipairs(shopLocationData.items) do
        local capturedItem = item
        menuOptions[#menuOptions + 1] = {
            title       = capturedItem.label,
            icon        = 'fas fa-shopping-cart',
            description = string.format('Price: $%d  |  %s', capturedItem.price, capturedItem.description or ''),
            onSelect    = function()
                ESX.TriggerServerCallback('di_multifarming:buyItem', function(ok, msg)
                    lib.notify({ title = 'Farm Shop', description = msg, type = ok and 'success' or 'error' })
                end, capturedItem.name)
            end
        }
    end

    lib.registerContext({ id = 'di_shop_menu', title = '🛒 Farm Shop', options = menuOptions })
    lib.showContext('di_shop_menu')
end

local function registerShopPeds()
    for i, shopData in ipairs(Config.Shop.Locations) do
        local coords = shopData.coords

        -- Optional blip
        if shopData.blip and shopData.blip.enable then
            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(blip, shopData.blip.sprite)
            SetBlipColour(blip, shopData.blip.color)
            SetBlipScale(blip, shopData.blip.scale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(shopData.blip.label)
            EndTextCommandSetBlipName(blip)
        end

        local ped = spawnScenarioPed(shopData.pedModel, coords)
        spawnedPeds[#spawnedPeds + 1] = ped

        local capturedShopData = shopData
        local capturedCoords   = vector3(coords.x, coords.y, coords.z)

        exports.ox_target:addLocalEntity(ped, {
            {
                name     = 'di_shop_' .. i,
                icon     = 'fas fa-store',
                label    = 'Browse Shop',
                distance = Config.Security.buyRadius,
                onSelect = function()
                    if not isNearLocation(capturedCoords, Config.Security.buyRadius + 2.0) then
                        lib.notify({ title = 'Farm Shop', description = 'You are too far away.', type = 'error' })
                        return
                    end
                    openShopMenu(capturedShopData)
                end
            }
        })
    end
end

-- ============================================================
-- SELL SYSTEM
-- ============================================================

---Build the list of items the player currently owns that appear in sellLocationData.
---@param sellLocationData table
---@return table  array of {name, label, count, price, payout}
local function buildSellableItems(sellLocationData)
    local results = {}
    for _, item in ipairs(sellLocationData.items) do
        -- or 0: guards against edge-case nil return from ox_inventory:Search
        local count = exports.ox_inventory:Search('count', item.name) or 0
        if count > 0 then
            results[#results + 1] = {
                name   = item.name,
                label  = item.label,
                count  = count,
                price  = item.price,
                payout = item.payout and item.payout.type or 'cash',
            }
        end
    end
    return results
end

local function openSellMenu(sellLocationData)
    local coords = vector3(sellLocationData.coords.x, sellLocationData.coords.y, sellLocationData.coords.z)
    if not isNearLocation(coords, Config.Security.sellRadius + 2.0) then
        lib.notify({ title = 'Farmer', description = 'You are too far away.', type = 'error' })
        return
    end

    local playerItems = buildSellableItems(sellLocationData)

    if #playerItems == 0 then
        lib.notify({ title = 'Farmer', description = 'You have no crops to sell.', type = 'error' })
        return
    end

    local menuOptions = {}

    -- Sell All button (when SellAll = true)
    if Config.Sell.SellAll then
        local totalEstimate  = 0
        local sellAllPayload = {}
        for _, item in ipairs(playerItems) do
            totalEstimate = totalEstimate + (item.count * item.price)
            sellAllPayload[#sellAllPayload + 1] = { name = item.name, count = item.count }
        end

        menuOptions[#menuOptions + 1] = {
            title       = '💰 Sell Everything',
            icon        = 'fas fa-dollar-sign',
            iconColor   = '#4caf50',
            description = string.format('Sell all items  |  Est. $%d', totalEstimate),
            onSelect    = function()
                ESX.TriggerServerCallback('di_multifarming:sellItems', function(ok, msg)
                    lib.notify({ title = 'Farmer', description = msg, type = ok and 'success' or 'error' })
                end, sellAllPayload)
            end
        }
    end

    -- Per-item options
    for _, item in ipairs(playerItems) do
        local capturedItem = item

        menuOptions[#menuOptions + 1] = {
            title       = capturedItem.label,
            icon        = 'fas fa-box-open',
            description = string.format(
                'Own: %d  |  $%d each  |  Total: ~$%d',
                capturedItem.count, capturedItem.price, capturedItem.count * capturedItem.price
            ),
            onSelect    = function()
                lib.registerContext({
                    id      = 'di_sell_amount_menu',
                    title   = 'Sell ' .. capturedItem.label,
                    options = {
                        {
                            title       = 'Sell 1',
                            icon        = 'fas fa-minus',
                            description = string.format('Earn $%d', capturedItem.price),
                            onSelect    = function()
                                ESX.TriggerServerCallback('di_multifarming:sellItems', function(ok, msg)
                                    lib.notify({ title = 'Farmer', description = msg, type = ok and 'success' or 'error' })
                                end, { { name = capturedItem.name, count = 1 } })
                            end
                        },
                        {
                            title       = string.format('Sell All  (%d)', capturedItem.count),
                            icon        = 'fas fa-check-double',
                            description = string.format('Earn ~$%d', capturedItem.count * capturedItem.price),
                            onSelect    = function()
                                ESX.TriggerServerCallback('di_multifarming:sellItems', function(ok, msg)
                                    lib.notify({ title = 'Farmer', description = msg, type = ok and 'success' or 'error' })
                                end, { { name = capturedItem.name, count = capturedItem.count } })
                            end
                        }
                    }
                })
                lib.showContext('di_sell_amount_menu')
            end
        }
    end

    lib.registerContext({ id = 'di_sell_menu', title = '🌾 Sell Crops', options = menuOptions })
    lib.showContext('di_sell_menu')
end

local function registerSellPeds()
    for i, sellData in ipairs(Config.Sell.Locations) do
        local coords = sellData.coords

        -- Optional blip
        if sellData.blip and sellData.blip.enable then
            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(blip, sellData.blip.sprite)
            SetBlipColour(blip, sellData.blip.color)
            SetBlipScale(blip, sellData.blip.scale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(sellData.blip.label)
            EndTextCommandSetBlipName(blip)
        end

        local ped = spawnScenarioPed(sellData.pedModel, coords)
        spawnedPeds[#spawnedPeds + 1] = ped

        local capturedSellData = sellData

        exports.ox_target:addLocalEntity(ped, {
            {
                name     = 'di_sell_' .. i,
                icon     = 'fas fa-hand-holding-usd',
                label    = 'Sell Crops',
                distance = Config.Security.sellRadius,
                onSelect = function()
                    openSellMenu(capturedSellData)
                end
            }
        })
    end
end

-- ============================================================
-- CROP PICKING SYSTEM
-- ============================================================

---Remove the ox_target zone for a given crop location key.
---@param key string
local function removeCropZone(key)
    local zoneId = activeZones[key]
    if zoneId then
        exports.ox_target:removeZone(zoneId)
        activeZones[key] = nil
    end
end

---Spawn the visual prop for a crop pick location (when useProp = true).
---@param cropName string
---@param crop table  crop config table
---@param locIndex number
---@param coords vector3
local function spawnCropProp(cropName, crop, locIndex, coords)
    if not crop.useProp then return end
    local key    = cropName .. '_' .. locIndex
    local entity = spawnProp(crop.prop, coords, nil, true)
    if entity then
        spawnedProps[key] = entity
    end
end

---Register the ox_target sphere zone for one pick location.
---Handles the full pick interaction flow via onSelect.
---@param cropName string
---@param crop table  crop config table
---@param locIndex number
---@param coords vector3
local function registerPickZone(cropName, crop, locIndex, coords)
    local key = cropName .. '_' .. locIndex

    local zoneId = exports.ox_target:addSphereZone({
        coords  = coords,
        radius  = Config.Security.pickRadius,
        debug   = false,
        options = {
            {
                name     = 'di_pick_' .. key,
                icon     = 'fas fa-seedling',
                label    = 'Pick ' .. cropName,
                onSelect = function()

                    -- 0. In-progress guard: prevents double-picking while awaiting the
                    --    server callback. A second onSelect can fire if the player
                    --    cancels the progress bar and immediately re-clicks before the
                    --    pickedLocations flag is set. This lock closes that window.
                    if pickingInProgress[key] then return end

                    -- 1. Security: distance sanity check
                    if not isNearLocation(coords, Config.Security.pickRadius + 2.0) then
                        lib.notify({ title = 'Farming', description = 'You are too far away.', type = 'error' })
                        return
                    end

                    -- 2. Cooldown guard (already picked, waiting for respawn)
                    if pickedLocations[key] then
                        lib.notify({ title = 'Farming', description = 'This spot is empty. Come back later.', type = 'warning' })
                        return
                    end

                    -- 3. Client-side tool pre-check (server re-validates authoritatively)
                    -- or 0: guards against edge-case nil return from ox_inventory:Search
                    local toolCount = exports.ox_inventory:Search('count', crop.requiredItem) or 0
                    if toolCount < 1 then
                        lib.notify({
                            title       = 'Farming',
                            description = string.format('You need a %s to harvest.', crop.requiredItem),
                            type        = 'error'
                        })
                        return
                    end

                    -- Acquire the in-progress lock before any async operation
                    pickingInProgress[key] = true

                    -- 4. Emote + progress bar
                    playEmote(crop.emote)

                    local success = lib.progressBar({
                        duration     = crop.time * 1000,
                        label        = string.format('Picking %s...', cropName),
                        useWhileDead = false,
                        canCancel    = true,
                        disable      = { car = true, move = true, combat = true },
                    })

                    stopEmote()

                    if not success then
                        pickingInProgress[key] = nil  -- Release lock on cancel
                        lib.notify({ title = 'Farming', description = 'Picking cancelled.', type = 'error' })
                        return
                    end

                    -- 5. Server callback (authoritative validation + reward)
                    ESX.TriggerServerCallback('di_multifarming:pickCrop', function(ok, msg)
                        pickingInProgress[key] = nil  -- Always release lock on callback return

                        if not ok then
                            lib.notify({ title = 'Farming', description = msg, type = 'error' })
                            return
                        end

                        lib.notify({ title = 'Farming', description = msg, type = 'success' })
                        pickedLocations[key] = true

                        -- Remove target zone based on removeOption
                        if crop.removeOption == 'both' or crop.removeOption == 'target' then
                            removeCropZone(key)
                        end

                        -- Remove prop based on removeOption
                        if crop.removeOption == 'both' and crop.useProp then
                            removeProp(key)
                        end

                        -- Respawn after configured delay
                        SetTimeout(crop.respawnTime * 1000, function()
                            pickedLocations[key] = nil
                            -- Re-register zone (only if it was removed)
                            if crop.removeOption == 'both' or crop.removeOption == 'target' then
                                registerPickZone(cropName, crop, locIndex, coords)
                            end
                            -- Re-spawn prop (only if it was removed)
                            if crop.removeOption == 'both' and crop.useProp then
                                spawnCropProp(cropName, crop, locIndex, coords)
                            end
                        end)
                    end, cropName, locIndex)

                end -- onSelect
            }
        }
    })

    activeZones[key] = zoneId
end

---Iterate all Config.Crops, spawn props, and register pick zones.
local function registerAllCrops()
    for cropName, crop in pairs(Config.Crops) do
        for locIndex, coords in ipairs(crop.pickLocations) do
            spawnCropProp(cropName, crop, locIndex, coords)
            registerPickZone(cropName, crop, locIndex, coords)
        end
    end
end

-- ============================================================
-- RESOURCE CLEANUP
-- ============================================================

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    -- Remove all tracked ox_target sphere zones
    for _, zoneId in pairs(activeZones) do
        exports.ox_target:removeZone(zoneId)
    end
    activeZones = {}

    -- Delete all spawned crop props
    for _, entity in pairs(spawnedProps) do
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end
    spawnedProps = {}

    -- Delete process-area props
    for _, entity in ipairs(processProps) do
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end
    processProps = {}

    -- Delete all NPCs
    for _, ped in ipairs(spawnedPeds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    spawnedPeds = {}

    -- Clear runtime state tables
    pickedLocations   = {}
    pickingInProgress = {}
end)

-- ============================================================
-- INIT
-- ============================================================

CreateThread(function()
    -- Allow world to initialise before spawning anything
    Wait(2000)

    createBlips()
    registerAllCrops()
    registerProcessZone()
    registerShopPeds()
    registerSellPeds()
end)