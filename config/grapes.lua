Config = Config or {}
Config.Crops = Config.Crops or {}  -- REQUIRED

Config.Crops["Grapes"] = {

    requiredItem = 'fruitpicker',          -- Tool needed to harvest (make more sense)
    breakChance = 0,                   -- % chance tool breaks
    item = 'grapes',                 -- Item given after picking
    amount = { min = 1, max = 3 }, -- random amount
    time = 10,                           -- Picking time in seconds
    respawnTime = 60,                   -- Plant respawn time
    prop = 'prop_tree_lficus_03',            -- Grapes plant object
    useProp = false,              -- make it true/false whatever you wanted
    removeOption = "both",        -- prop& target the use removeoption = "both or remove target use removeoption = "target"
    webhook = "grapes",                 -- Webhook name for logging  
    emote = "parkingmeter",  -- rpemotes animation name

    pickLocations = {
        vector3(-1909.61, 2107.25, 131.42),
        vector3(-1906.76, 2106.84, 132.47),
        vector3(-1903.78, 2106.41, 133.56),
        vector3(-1901.07, 2106.46, 134.38),
        vector3(-1898.31, 2106.08, 135.18),
        vector3(-1895.79, 2105.95, 135.79),
        vector3(-1892.79, 2105.77, 136.63),
        vector3(-1889.76, 2105.45, 137.14),
        vector3(-1884.27, 2104.88, 137.7),
        vector3(-1881.22, 2104.64, 138.08),
        vector3(-1875.33, 2104.28, 138.07),
        vector3(-1872.75, 2104.12, 137.86),

        vector3(-1867.7, 2108.15, 136.53),
        vector3(-1873.35, 2108.55, 136.68),
        vector3(-1879.08, 2108.96, 136.76),
        vector3(-1882.01, 2109.0, 136.55),
        vector3(-1887.35, 2109.51, 135.85),
        vector3(-1890.45, 2109.97, 135.4),
        vector3(-1893.4, 2110.15, 134.66),
        vector3(-1895.9, 2110.44, 133.99),
        vector3(-1898.67, 2110.66, 133.22),
        vector3(-1901.44, 2110.85, 132.43),
        vector3(-1907.16, 2111.22, 130.55),
        vector3(-1909.62, 2111.47, 129.65),

        vector3(-1908.9, 2116.04, 127.58),
        vector3(-1905.94, 2115.77, 129.0),
        vector3(-1903.27, 2115.69, 130.12),
        vector3(-1900.59, 2115.26, 130.91),
        vector3(-1898.08, 2115.01, 131.64),
        vector3(-1895.08, 2114.79, 132.43),
        vector3(-1892.14, 2114.63, 133.2),
        vector3(-1886.69, 2114.22, 134.19),
        vector3(-1883.54, 2113.91, 134.57),
        vector3(-1877.88, 2113.43, 135.18),
        vector3(-1875.24, 2113.17, 135.35),
        vector3(-1872.35, 2112.6, 135.21),
        vector3(-1866.27, 2112.31, 134.83),
        
    }
}
