Config = Config or {}
Config.Crops = Config.Crops or {}  -- REQUIRED

Config.Crops["Lemon"] = {

    requiredItem = 'fruitpicker',          -- Tool needed to harvest (make more sense)
    breakChance = 0,                   -- % chance tool breaks
    item = 'lemon',                 -- Item given after picking
    amount = { min = 1, max = 3 }, -- random amount
    time = 10,                           -- Picking time in seconds
    respawnTime = 60,                   -- Plant respawn time
    prop = 'prop_tree_birch_04',            -- Lemon plant object
    useProp = true,              -- make it true/false whatever you wanted
    removeOption = "target",              -- Remove prop + target after picking
    webhook = "lemon",                 -- Webhook name for logging  
    emote = "knock2",  -- rpemotes animation name

    pickLocations = {
        vector3(1982.81, 4902.3, 41.68),
        vector3(1986.54, 4898.67, 41.63),
        vector3(1991.06, 4894.07, 41.65),
        vector3(1997.2, 4888.09, 41.68),
        vector3(2003.75, 4881.64, 41.69),
        vector3(1988.92, 4905.09, 41.65),
        vector3(1992.76, 4901.33, 41.7),
        vector3(1998.1, 4895.83, 41.69),
        vector3(2004.39, 4889.58, 41.69),
        vector3(2013.02, 4889.95, 41.69),
        vector3(2006.03, 4896.79, 41.71),
        vector3(1999.8, 4902.5, 41.69),
        vector3(1991.41, 4911.12, 41.7),
        vector3(2013.91, 4897.21, 41.63),
        vector3(2006.88, 4904.0, 41.66),
        vector3(2000.19, 4910.78, 41.68),
        vector3(1999.75, 4919.79, 41.72),
        vector3(2007.53, 4911.69, 41.68),
        vector3(2013.89, 4905.46, 41.67),
        vector3(2021.85, 4897.99, 41.71),
        vector3(2023.05, 4905.3, 41.65),
        vector3(2014.6, 4913.28, 41.67),
        vector3(2007.94, 4919.93, 41.68),
        vector3(2010.51, 4877.77, 41.7),
        vector3(2018.2, 4870.31, 41.65),
        vector3(2024.74, 4863.7, 41.66),
        vector3(2032.65, 4855.79, 41.68),
        vector3(2033.44, 4863.54, 41.63),
        vector3(2025.75, 4871.54, 41.66),
        vector3(2018.6, 4878.8, 41.68),
        vector3(2019.31, 4886.49, 41.65),
        vector3(2025.76, 4879.97, 41.69),
        vector3(2033.58, 4872.4, 41.66),
        vector3(2041.23, 4864.63, 41.66),
        vector3(2041.9, 4872.5, 41.66),
        vector3(2033.06, 4881.18, 41.68),
        vector3(2026.87, 4887.46, 41.67),
        vector3(2028.17, 4894.74, 41.69),
        vector3(2037.16, 4885.72, 41.68),
        vector3(2045.81, 4876.83, 41.67),
        vector3(2053.98, 4877.03, 41.67),
        vector3(2045.41, 4885.87, 41.68),
        vector3(2038.07, 4892.89, 41.68),
        vector3(2034.02, 4900.14, 41.66)
        
    }
}
