# DOTINIT MULTIFARMING SYSTEM

A complete farming system for FiveM supporting multiple crops, processing,
selling, shops, and secure location-based interactions.

Built with support for ox_target, qb-target, and modern inventory systems.

## Features

- Multi-crop farming system (Apple, Orange, Strawberry, etc.)
- Picking system with tool requirement
- Processing system (raw → processed items)
- Selling system with payouts
- Shop system (buy tools)
- Blip support for all locations
- Secure location-based checks (anti-exploit)
- Prop-based or target-based farming
- Emotes integration
- Webhook logging support

## Supported Frameworks

- ```ox_inventory``` / ```qb-inventory```
- ```ox_target``` / ```qb-target```

## Core Configuration

Located in main config:
```lua
Config.Target = "ox"        -- qb / ox
Config.Inventory = "ox"     -- qb / ox
```
## Security System
```lua
Config.Security = {
    enforceLocations = true,
    processRadius = 10.0,
    sellRadius = 5.0,
    buyRadius = 5.0,
    pickRadius = 5.0
}
```
- Prevents players from exploiting actions outside valid zones
- Highly recommended to keep enabled

## Blip Locations

Includes farms and utility locations:

- Strawberry Farm
- Lemon Farm
- Blueberry Farm
- Orange Farm
- Pumpkin Farm
- Tomato Farm
- Grape Farm
- Apple Farm

Each blip is configurable with:
- sprite
- color
- scale
- coordinates

## Processing System (processing.lua)

Convert raw crops into processed items.

### Example Conversions:

- Strawberry → Strawberry Box
- Blueberry → Blueberry Box
- Orange → Orange Juice
- Lemon → Lemon Juice
- Tomato → Tomato Ketchup
- Pumpkin → Pumpkin Pie
- Grapes → Grape Wine
- Apple → Apple Juice

### Settings:

- Processing time
- Required items
- Reward output
- Props (tables, boxes)
- Emotes

## Farming System (per crop configs)

Each crop has its own configuration.

### Example: Apple

- Required Tool: ```fruitpicker```
- Yield: 1–3 apples
- Respawn Time: 60 seconds
- Emote: mechanic5
- Multiple pick locations
- Optional prop system

### Features:

- Tool break chance
- Random item rewards
- Respawn system
- Target or prop interaction

## Shop System

Players can buy tools from shop NPC.

- Item: ```fruitpicker```
- Price: 50
- Ped-based interaction
- Includes blip

## Selling System

Players can sell the raw items as well as processed products.

### Features:

- Configurable prices
- Cash payouts
- Crop-based selling

## How It Works

1. Buy tool (fruitpicker)
2. Go to farm location
3. Pick crops
4. Process crops into products
5. Sell for profit

## Installation

1. Drag and drop into resources folder
2. Add to server.cfg:

   ensure ```di_multifarming```

3. Configure:
   - main config [core configuration and blips]
   - processing.lua [processing configuration]
   - crop configs [indiidual configs for crops. You can add your own farm. Ex - ```raspberry.lua```]
   - shop & sell configs [buying and seling items]

4. Add items to your inventory system

## Notes

- Keep Security enabled for anti-cheat protection
- Ensure item names match inventory
- ox_target is recommended for best performance
- Props are optional and configurable

# SUPPORT/ASSISTANCE

## Join 
**DOTINIT SCRIPTS** - https://discord.gg/52duTcAfx9