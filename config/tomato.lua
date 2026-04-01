Config = Config or {}
-- Config.Crops = Config.Crops or {}  -- REQUIRED

-- Config.Orange = {
Config.Crops["Tomato"] = {

    requiredItem = 'fruitpicker',          -- Tool needed to harvest (consistent with other crops)
    breakChance = 0,                   -- % chance tool breaks
    item = 'tomato',                    -- Item given after picking
    amount = { min = 1, max = 3 }, -- random amount
    time = 10,                           -- Picking time in seconds
    respawnTime = 60,                   -- Crop respawn time
    prop = 'prop_veg_crop_orange',      -- Orange bush/prop
    useProp = false,              -- use prop or not (optional, default false)
    removeOption = "both",              -- target or both (optional, default "both")
    webhook = "tomato",                 -- Webhook name for logging
    emote = "parkingmeter",  -- Use rpemotes "garden" like strawberry/blueberry

    pickLocations = {
        vector3(1828.1, 5045.61, 58.49),
        vector3(1829.25, 5046.61, 58.34),
        vector3(1831.33, 5048.35, 58.05),
        vector3(1832.47, 5049.35, 57.9),
        vector3(1833.59, 5050.27, 57.75),
        vector3(1831.92, 5040.35, 58.27),
        vector3(1832.92, 5041.28, 58.13),
        vector3(1833.73, 5042.0, 58.01),
        vector3(1835.06, 5043.08, 57.84),
        vector3(1836.21, 5044.05, 57.69),
        vector3(1837.31, 5044.99, 57.54),
        vector3(1838.23, 5033.61, 57.01),
        vector3(1839.55, 5034.71, 56.84),
        vector3(1840.33, 5035.45, 56.73),
        vector3(1841.75, 5036.59, 56.54),
        vector3(1842.81, 5037.57, 56.39),
        vector3(1843.9, 5038.53, 56.23),
        vector3(1842.22, 5028.53, 55.91),
        vector3(1843.36, 5029.6, 55.75),
        vector3(1844.27, 5030.28, 55.63),
        vector3(1845.47, 5031.4, 55.43),
        vector3(1846.69, 5032.44, 55.3),
        vector3(1847.73, 5033.33, 55.11),
        vector3(1846.96, 5023.97, 54.89),
        vector3(1848.23, 5025.06, 54.71),
        vector3(1849.02, 5025.75, 54.6),
        vector3(1850.32, 5026.86, 54.43),
        vector3(1851.48, 5027.81, 54.27),
        vector3(1852.61, 5028.79, 54.11),
        vector3(1858.28, 5021.56, 52.87),
        vector3(1859.54, 5022.62, 52.69),
        vector3(1860.36, 5023.32, 52.58),
        vector3(1861.71, 5024.46, 52.4),
        vector3(1862.88, 5025.48, 52.24),
        vector3(1863.87, 5026.35, 52.1),
        vector3(1874.71, 5027.22, 50.13),
        vector3(1875.92, 5028.26, 49.97),
        vector3(1876.8, 5029.01, 49.84),
        vector3(1878.11, 5030.11, 49.7),
        vector3(1879.23, 5031.04, 49.55),
        vector3(1880.42, 5032.06, 49.39),

        vector3(1935.99, 5079.36, 42.15),
        vector3(1937.22, 5080.41, 41.99),
        vector3(1938.05, 5081.12, 41.86),
        vector3(1939.43, 5082.27, 41.6),
        vector3(1940.56, 5083.27, 41.36),
        vector3(1941.64, 5084.2, 41.1),
        vector3(1931.23, 5083.83, 42.45),
        vector3(1932.41, 5084.84, 42.22),
        vector3(1933.21, 5085.46, 42.09),
        vector3(1934.58, 5086.63, 41.83),
        vector3(1935.72, 5087.61, 41.61),
        vector3(1936.74, 5088.54, 41.39),
        vector3(1924.71, 5090.44, 42.79),
        vector3(1925.81, 5091.41, 42.51),
        vector3(1926.73, 5092.16, 42.34),
        vector3(1927.92, 5093.23, 42.05),
        vector3(1929.06, 5094.13, 41.82),
        vector3(1930.16, 5095.17, 41.54),
        vector3(1921.32, 5095.9, 42.82),
        vector3(1922.49, 5096.94, 42.52),
        vector3(1923.31, 5097.66, 42.33),
        vector3(1924.67, 5098.83, 42.04),
        vector3(1925.77, 5099.78, 41.76),
        vector3(1926.81, 5100.69, 41.49),
        vector3(1917.19, 5101.02, 42.99),
        vector3(1918.33, 5102.0, 42.69),
        vector3(1919.17, 5102.77, 42.46),
        vector3(1920.42, 5103.84, 42.13),
        vector3(1921.6, 5104.82, 41.83),
        vector3(1922.64, 5105.78, 41.55),
        vector3(1903.5, 5101.53, 45.6),
        vector3(1904.63, 5102.57, 45.33),
        vector3(1905.54, 5103.29, 45.17),
        vector3(1906.84, 5104.42, 44.89),
        vector3(1907.98, 5105.38, 44.65),
        vector3(1909.01, 5106.26, 44.42),
        vector3(1891.38, 5099.72, 47.83),
        vector3(1892.68, 5100.78, 47.6),
        vector3(1893.56, 5101.54, 47.43),
        vector3(1894.83, 5102.63, 47.16),
        vector3(1895.96, 5103.57, 46.96),
        vector3(1897.1, 5104.53, 46.74)
    }
}
