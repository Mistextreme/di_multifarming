Config = Config or {}
-- Config.Crops = Config.Crops or {}  -- REQUIRED

-- Config.Orange = {
Config.Crops["Orange"] = {

    requiredItem = 'fruitpicker',          -- Tool needed to harvest (consistent with other crops)
    breakChance = 0,                   -- % chance tool breaks
    item = 'orange',                    -- Item given after picking
    amount = { min = 1, max = 3 }, -- random amount
    time = 10,                           -- Picking time in seconds
    respawnTime = 60,                   -- Crop respawn time
    prop = 'prop_veg_crop_orange',      -- Orange bush/prop
    useProp = false,              -- use prop or not (optional, default false)
    removeOption = "both",              -- Remove prop + target on harvest (recommended)
    webhook = "orange",                 -- Webhook name for logging

    emote = "mechanic5",  -- Use rpemotes "garden" like strawberry/blueberry

    pickLocations = {
        vector3(2324.52, 4746.7, 36.57),
        vector3(2325.76, 4761.6, 36.41),
        vector3(2327.64, 4770.7, 36.43),
        vector3(2339.3, 4767.25, 35.6),
        vector3(2343.61, 4755.86, 35.25),
        vector3(2339.42, 4741.38, 35.15),
        vector3(2350.33, 4734.14, 35.27),
        vector3(2367.08, 4751.21, 34.53),
        vector3(2374.56, 4735.23, 34.16),
        vector3(2364.93, 4729.86, 34.67),
        vector3(2359.34, 4723.91, 35.04),
        vector3(2366.76, 4716.02, 35.04),
        vector3(2386.84, 4724.31, 34.2),
        vector3(2386.84, 4736.38, 33.73),
        vector3(2383.1, 4713.0, 34.19),
        vector3(2381.63, 4700.78, 34.45),
        vector3(2402.37, 4717.31, 33.59),
        vector3(2402.19, 4717.3, 33.61),
        vector3(2412.65, 4707.41, 33.4),
        vector3(2423.87, 4697.9, 33.46),
        vector3(2443.42, 4672.41, 33.69),
        vector3(2434.57, 4678.72, 34.02),
        vector3(2422.42, 4686.6, 34.21),
        vector3(2404.33, 4703.93, 33.75),
        vector3(2389.79, 4691.25, 34.35),
        vector3(2401.6, 4688.42, 33.94),
        vector3(2406.94, 4677.01, 34.48),
        vector3(2419.71, 4674.17, 34.35),
        vector3(2423.96, 4658.64, 33.98),

        vector3(1838.95, 5040.26, 57.88),
        vector3(1854.19, 5023.08, 53.94),
    }
}
