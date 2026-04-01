Config = Config or {}
Config.Crops = Config.Crops or {}  -- REQUIRED

-- Config.Blueberry = {
Config.Crops["Blueberry"] = {

    requiredItem = 'fruitpicker',          -- Tool needed to harvest (make more sense)
    breakChance = 0,                   -- % chance tool breaks
    item = 'blueberry',                 -- Item given after picking
    amount = { min = 1, max = 3 }, -- random amount
    time = 10,                           -- Picking time in seconds
    respawnTime = 60,                   -- Plant respawn time
    prop = 'prop_plant_01b',            -- Blueberry plant object
    useProp = true,              -- use prop or not (optional, default true)
    removeOption = "both",              -- remove prop or target or both (optional, default "both")
    webhook = "blueberry",                 -- Webhook name for logging

    emote = "garden",  -- rpemotes animation name

    pickLocations = {
      vector3(1959.58, 4822.93, 43.01),
      vector3(1955.59, 4818.99, 42.85),
      vector3(1948.99, 4812.85, 42.85),
      vector3(1939.25, 4803.56, 42.88),
      vector3(1933.05, 4797.26, 42.7),

      vector3(1937.29, 4792.91, 42.56),
      vector3(1956.01, 4809.77, 42.78),
      vector3(1942.73, 4798.22, 42.76),
      vector3(1949.84, 4805.31, 42.88),
      vector3(1958.18, 4813.72, 42.71),
      vector3(1963.15, 4818.48, 42.73),
      
      vector3(1968.45, 4812.26, 42.39),
      vector3(1964.3, 4808.01, 42.47),
      vector3(1961.04, 4804.59, 42.51),
      vector3(1956.81, 4800.32, 42.54),
      vector3(1948.75, 4792.73, 42.59),
      vector3(1943.2, 4787.28, 42.45),

      vector3(1973.42, 4806.41, 41.98),
      vector3(1968.88, 4801.93, 42.1),
      vector3(1962.27, 4795.77, 42.2),
      vector3(1954.1, 4788.2, 42.3),
      vector3(1948.23, 4782.88, 42.26),

      vector3(1978.58, 4801.65, 41.74),
      vector3(1974.63, 4797.85, 41.75),
      vector3(1970.37, 4793.87, 41.81),
      vector3(1965.4, 4789.26, 41.91),
      vector3(1959.28, 4782.73, 41.9),
      vector3(1954.98, 4778.42, 41.88),
      vector3(1950.84, 4774.18, 41.83),

      vector3(1954.68, 4769.79, 41.6),
      vector3(1958.94, 4774.44, 41.5),
      vector3(1963.56, 4779.41, 41.51),
      vector3(1968.7, 4784.93, 41.58),
      vector3(1973.75, 4789.7, 41.6),
      vector3(1977.83, 4794.41, 41.62),
      vector3(1982.75, 4798.88, 41.55),

      vector3(1944.95, 4779.7, 42.16),
      vector3(1939.87, 4782.85, 42.43), 
      vector3(1934.65, 4788.69, 42.5),
      vector3(1929.89, 4793.1, 42.82)
    }
}
