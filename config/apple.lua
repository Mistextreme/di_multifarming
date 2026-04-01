Config = Config or {}
Config.Crops = Config.Crops or {}  -- REQUIRED

-- Config.Orange = {
Config.Crops["Apple"] = {

    requiredItem = 'fruitpicker',          -- Tool needed to harvest (consistent with other crops)
    breakChance = 0,                   -- % chance tool breaks
    item = 'apple',                    -- Item given after picking
    amount = { min = 1, max = 3 }, -- random amount
    time = 10,                           -- Picking time in seconds
    respawnTime = 60,                   -- Crop respawn time
    prop = 'prop_veg_crop_orange',      -- Orange bush/prop
    useProp = false,              -- use prop or not (optional, default false)
    removeOption = "both",        -- prop & target the use removeoption = "both or remove target use removeoption = "target"
    webhook = "apple",                 -- Webhook name for logging

    emote = "mechanic5",  -- Use rpemotes "garden" like strawberry/blueberry

    pickLocations = {
        vector3(378.11, 6505.87, 28.29),
        vector3(370.26, 6505.96, 28.68),
        vector3(363.27, 6505.78, 28.97),
        vector3(355.61, 6504.9, 28.78),
        vector3(347.96, 6505.36, 29.08),
        vector3(339.83, 6505.55, 28.77),
        vector3(331.04, 6505.71, 28.71),
        vector3(322.03, 6505.47, 29.37),

        vector3(321.93, 6517.29, 29.26),
        vector3(330.16, 6517.56, 29.27),
        vector3(338.71, 6517.15, 29.09),
        vector3(347.47, 6517.55, 28.93),
        vector3(355.26, 6517.22, 28.53),
        vector3(362.49, 6517.71, 28.39),
        vector3(369.84, 6517.58, 28.64),
        vector3(377.99, 6517.52, 28.67),

        vector3(369.49, 6531.64, 28.68),
        vector3(361.59, 6531.31, 28.73),
        vector3(353.95, 6530.76, 28.53),
        vector3(346.15, 6531.3, 29.06),
        vector3(338.76, 6531.17, 29.0),
        vector3(329.65, 6530.96, 28.75),
        vector3(321.98, 6531.12, 29.33)
    }
}
