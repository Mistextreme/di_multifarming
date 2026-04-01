-- ============================================================
-- di_multifarming | config/config.lua
-- Core configuration — framework / security / blips
-- ============================================================

Config = Config or {}

Config.Target    = "ox"   -- ox_target (ESX-Legacy stack)
Config.Inventory = "ox"   -- ox_inventory (ESX-Legacy stack)

-- Security settings: player must be near valid zone coordinates
-- when interacting. Set enforceLocations = false ONLY for testing.
Config.Security = {
    enforceLocations = true,
    processRadius    = 10.0,
    sellRadius       = 5.0,
    buyRadius        = 5.0,
    pickRadius       = 5.0,
}

Config.Blips = {
    Strawberry = {
        enable   = true,
        label    = "Strawberry Farm",
        sprite   = 1,
        color    = 1,
        scale    = 0.8,
        location = vector3(2304.61, 5133.77, 51.1)
    },

    Lemon = {
        enable   = true,
        label    = "Lemon Farm",
        sprite   = 1,
        color    = 24,
        scale    = 0.8,
        location = vector3(2018.79, 4891.53, 42.71)
    },

    Blueberry = {
        enable   = true,
        label    = "Blueberry Farm",
        sprite   = 1,
        color    = 50,
        scale    = 0.8,
        location = vector3(1947.02, 4793.34, 43.75)
    },

    Orange = {
        enable   = true,
        label    = "Orange Farm",
        sprite   = 1,
        color    = 17,
        scale    = 0.8,
        location = vector3(2381.56, 4719.94, 33.64)
    },

    Pumpkin = {
        enable   = true,
        label    = "Pumpkin Farm",
        sprite   = 1,
        color    = 5,
        scale    = 0.8,
        location = vector3(505.61, 6498.81, 29.73)
    },

    Tomato = {
        enable   = true,
        label    = "Tomato Farm",
        sprite   = 1,
        color    = 1,
        scale    = 0.8,
        location = vector3(1864.21, 5053.1, 52.27)
    },

    Grapes = {
        enable   = true,
        label    = "Grape Farm",
        sprite   = 1,
        color    = 2,
        scale    = 0.8,
        location = vector3(-1900.2, 2113.05, 130.43)
    },

    Apple = {
        enable   = true,
        label    = "Apple Farm",
        sprite   = 1,
        color    = 6,
        scale    = 0.8,
        location = vector3(356.91, 6513.81, 28.24)
    },
}