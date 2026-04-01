Config = Config or {}

Config.Shop = {
    emote = "idle",
    Locations = {
        {
            pedModel = "a_m_m_farmer_01",
            coords = vector4(169.37, 6632.14, 30.52, 131.94),
            blip = {
                sprite = 605,
                enable = true,
                label = "Farm Shop",
                color = 2,
                scale = 0.8
            },
            items = {
                {
                    name = "fruitpicker",
                    label = "Fruit Picker",
                    price = 50,
                    description = "Used for picking fruits"
                }
            }
        }
    },

}


Config.Sell = {
    emote = "argue2",
    SellAll = true,
    Locations = {
        {
            pedModel = "a_m_m_farmer_01",
            coords =  vector4(166.37, 6632.14, 30.52, 131.94),
            blip = {
                sprite = 605,
                enable = true,
                label = "Farmer",
                color = 69,
                scale = 0.8
            },
            items = {
                {
                    cropType = "orange",
                    name = "orange",
                    label = "Orange",
                    price = 40,
                    payout = { type = "cash"}
                },
                {
                    cropType = "pumpkin",
                    name = "pumpkin",
                    label = "Pumpkin",
                    price = 55,
                    payout = { type = "cash"}
                },
                {
                    cropType = "apple",
                    name = "apple",
                    label = "Apple",
                    price = 40,
                    payout = { type = "cash"}
                },
                {
                    cropType = "tomato",
                    name = "tomato",
                    label = "Tomato",
                    price = 50,
                    payout = { type = "cash"}
                },
                {
                    cropType = "strawberry",
                    name = "strawberry",
                    label = "Strawberry",
                    price = 53,
                    payout = { type = "cash"}
                },
                {
                    cropType = "lemon",
                    name = "lemon",
                    label = "Lemon",
                    price = 46,
                    payout = { type = "cash"}
                },
                {
                    cropType = "blueberry",
                    name = "blueberry",
                    label = "Blueberry",
                    price = 44,
                    payout = { type = "cash"}
                },
                {
                    cropType = "grapes",
                    name = "grapes",
                    label = "Grapes",
                    price = 44,
                    payout = { type = "cash"}
                },

                -- Processed Items
                {
                    cropType = "strawberry",
                    name = "strawberrybox",
                    label = "Strawberry Box",
                    price = 710,
                    payout = { type = "cash" }
                },
                {
                    cropType = "blueberry",
                    name = "blueberrybox",
                    label = "Blueberry Box",
                    price = 620,
                    payout = { type = "cash" }
                },
                {
                    cropType = "lemon",
                    name = "lemonjuice",
                    label = "Lemon Juice",
                    price = 705,
                    payout = { type = "cash"}
                },
                {
                    cropType = "grapes",
                    name = "grapewine",
                    label = "Grape Wine",
                    price = 610,
                    payout = { type = "cash"}
                },
                {
                    cropType = "pumpkin",
                    name = "pumpkinpie",
                    label = "Pumpkin Pie",
                    price = 830,
                    payout = { type = "cash"}
                },
                {
                    cropType = "apple",
                    name = "applejuice",
                    label = "Apple Juice",
                    price = 550,
                    payout = { type = "cash"}
                },
                {
                    cropType = "orange",
                    name = "orangejuice",
                    label = "Orange Juice",
                    price = 620,
                    payout = { type = "cash"}
                },
                {
                    cropType = "tomato",
                    name = "tomatoketchup",
                    label = "Tomato Ketchup",
                    price = 700,
                    payout = { type = "cash"}
                },               

            }
        },
    },
}


