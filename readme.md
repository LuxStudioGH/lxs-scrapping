# LuxStudio Scrapping

A modular, high-performance vehicle scrapping script for **qb-core/qbox** using **ox_lib**, **ox_target**, and **ox_inventory**.

Players obtain contracts to locate abandoned car wrecks across San Andreas, harvest valuable parts via skill checks, and sell them to shady bob.

---

## 📋 Dependencies

Ensure you have the following installed:

- qbx_core (or qb-core)  
- ox_lib  
- ox_target  
- ox_inventory  
- rpemotes (or rpemotes-reborn)

---

## 🛠️ Installation

### 1. Item Configuration

Add the following to your `ox_inventory/data/items.lua`:

```lua
['alternator'] = { label = 'Alternator', weight = 2000, stack = true, close = true },
['battery'] = { label = 'Car Battery', weight = 3500, stack = true, close = true },
['brakes'] = { label = 'Brake Pads', weight = 1500, stack = true, close = true },
['engine'] = { label = 'Engine Block', weight = 35000, stack = true, close = true },
['foglights'] = { label = 'Fog Lights', weight = 800, stack = true, close = true },
['fueltank'] = { label = 'Fuel Tank', weight = 12000, stack = true, close = true },
['headlights'] = { label = 'Headlight Assembly', weight = 2000, stack = true, close = true },
['radiator'] = { label = 'Radiator', weight = 6000, stack = true, close = true },
['steeringwheel'] = { label = 'Steering Wheel', weight = 2500, stack = true, close = true },
['suspension'] = { label = 'Suspension Strut', weight = 7000, stack = true, close = true },
['transmission'] = { label = 'Transmission', weight = 28000, stack = true, close = true },
['windscreen'] = { label = 'Windscreen Glass', weight = 10000, stack = true, close = true },
['tyre'] = { label = 'Vehicle Tyre', weight = 5000, stack = true, close = true },
```

---

## 🛡️ Support

If you need any support for anything, feel free to join my Discord!:
- https://discord.gg/ZHwpYBXUPZ
