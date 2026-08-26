# Library Reuse Index

## Priority

1. Custom library blocks (highest priority)
2. Toolbox KB blocks

## Policy

- Always use custom library blocks when available.
- Never fall back to built-in primitives if the same block exists in a declared library.
- Only use built-in blocks when NO equivalent exists in any declared library after searching this index.
- Do not invent custom block names.
- If uncertain, inspect the relevant category page or ask the user.

## Libraries

- Battery

Common blocks: [common.md](common.md) (13 of 55 blocks)

## Categories

- [Cell balancing](cell-balancing.md) — 1 blocks; Cell balancing algorithms for equalizing SOC across series cells
- [Current management](current-management.md) — 4 blocks; Charging and discharging current control and limiting algorithms
- [State estimation](state-estimation.md) — 22 blocks; State of charge, energy, health, and capacity estimation algorithms
- [Protection](protection.md) — 5 blocks; Battery protection monitoring for voltage, current, temperature, and contacts
- [Thermal management](thermal-management.md) — 2 blocks; Thermal management control algorithms for cooling and heating
- [Cell models](cell-models.md) — 5 blocks; Simscape physical battery and supercapacitor cell models
- [Connectors](connectors.md) — 1 blocks; Multi-cell electrical and thermal array connectors
- [Cyclers](cyclers.md) — 3 blocks; Battery test equipment models (chargers, dischargers, cyclers)
- [Fuel cell](fuel-cell.md) — 2 blocks; Fuel cell stack models for hydrogen powertrain simulation
- [Hil](hil.md) — 3 blocks; Hardware-in-the-loop interfaces for BMS testing
- [Passive components](passive-components.md) — 1 blocks; Passive electrical component models (impedance, state-space)
- [Thermal components](thermal-components.md) — 6 blocks; Simscape thermal components for pack cooling simulation
