# Adjustable Merchant Gold for OpenMW

A configurable OpenMW Lua mod that multiplies merchant gold amounts for more convenient trading.

## Features

- **Configurable multiplier** (1-100x) through the OpenMW settings menu
- **Changes apply immediately** without restarting the game
- **Preserves merchant gold** changes from trading
- **Respects vanilla 24-hour** merchant restock timers
- **Works with all NPCs and creatures** that offer barter services
- **Lightweight** with negligible performance impact

## Requirements

- OpenMW 0.48 or later with Lua scripting support

## Installation

1. Extract this folder to your OpenMW data directory (e.g., `Documents/My Games/OpenMW/data/`)
2. Open your `openmw.cfg` file and add these lines:
   ```
   data="path/to/adjustable_merchant_gold_openmw"
   content=AdjustableMerchantGold.omwscripts
   ```
3. Launch OpenMW

## Configuration

1. Start or load a game
2. Open **Settings** → **Adjustable Merchant Gold**
3. Adjust the **Gold Multiplier** (default: 5)
4. Changes apply immediately to all active merchants

## How It Works

- When a merchant becomes active (enters a loaded cell), their barter gold is multiplied by your configured amount
- The mod tracks changes from trading, so selling items to merchants doesn't reset their gold
- When the engine restocks merchant gold after 24 in-game hours, the multiplier is reapplied
- Changing the multiplier mid-game adjusts all active merchants using a delta calculation that preserves their trading gains/losses

## Compatibility

- Safe to add or remove mid-playthrough
- Settings and merchant tracking data are saved with your game
- Should be compatible with most other mods

## Troubleshooting

If merchants don't have multiplied gold:
1. Check that the mod is enabled in `openmw.cfg`
2. Verify Lua scripting is enabled in OpenMW settings
3. Check the OpenMW log (`openmw.log`) for errors

## Version History

### 1.0.0
- Initial release
