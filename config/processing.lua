Config = Config or {}

Config.process = {
    location =vector3(427.69, 6476.39, 27.80),
    time = 10,
    emote = "type3",
    prop = {
        enabled = true,
        model = "prop_table_08",
        offset = vector3(0.0, 0.0, 0.0),
        heading = 140.0
    },
      box = {
        enabled = true, -- set false if you don't want box
        model = "prop_cs_cardbox_01",
        offset = vector3(0.0, 0.0, 0.85)
    },

    crops = {
        {
            cropType = "strawberry",
            input = "strawberry",
            output = "strawberrybox",
            label = "Strawberries",
            required = 10,
            reward = 1
        },
        {
            cropType = "blueberry",
            input = "blueberry",
            output = "blueberrybox",
            label = "Blueberries",
            required = 10,
            reward = 1
        },
        {
            cropType = "orange",
            input = "orange",
            output = "orangejuice",
            label = "Oranges",
            required = 10,
            reward = 1
        },
        {
            cropType = "lemon",
            input = "lemon",
            output = "lemonjuice",
            label = "Lemons",
            required = 10,
            reward = 1
        },
        {
            cropType = "tomato",
            input = "tomato",
            output = "tomatoketchup",
            label = "Tomatoes",
            required = 10,
            reward = 1
        },
        {
            cropType = "pumpkin",
            input = "pumpkin",
            output = "pumpkinpie",
            label = "Pumpkins",
            required = 10,
            reward = 1
        },
        {
            cropType = "grapes",
            input = "grapes",
            output = "grapewine",
            label = "Grapes",
            required = 10,
            reward = 1
        },
        {
            cropType = "apple",
            input = "apple",
            output = "applejuice",
            label = "Apples",
            required = 10,
            reward = 1
        }
    },

    blip = {
        sprite = 478,
        enable = true,
        label = "Crop Processing",
        color = 46,
        scale = 0.8
    }
}