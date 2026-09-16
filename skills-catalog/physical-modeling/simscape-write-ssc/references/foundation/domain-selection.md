# Domain Selection

Pick the domain *before* writing equations. A conserving node's Across/Through variables come entirely from its domain, so a wrong choice silently produces wrong physics (or the wrong equation count) and forces a rewrite. Reference a domain by its full namespace path.

## Foundation Domain Table

| Domain | Namespace path | Across var(s) | Through var(s) | Pick when… | Notes |
|--------|----------------|---------------|----------------|-------------|-------|
| Electrical | `foundation.electrical.electrical` | v (voltage) | i (current) | Single-phase electrical circuits. | Domain params: `GMIN`, `Temperature`. |
| N-Phase Electrical | `foundation.electrical.<n>_phase`, `<n>` ∈ {`three`, `four`, `six`, `eight`, `twelve`, `fifteen`, `twenty_four`} | V (vector) | I (vector) | N-phase AC networks — pick the member matching your phase count. | One vector node per bus; phase count is fixed by the domain name. Same params as single-phase. |
| Magnetic | `foundation.magnetic.magnetic` | mmf | phi (flux) | Magnetic circuits, reluctance networks, transformer/motor cores. | Domain param: `mu0`. |
| Mechanical Translational | `foundation.mechanical.translational.translational` | v (velocity) | f (force) | General-purpose linear motion. | No domain params. |
| Mechanical Position-Based Translational | `foundation.translational.translational` | v, x (position) | f (force) | Linear motion with universal position tracking. | Carries extra Across `x` via domain equation `der(x) == v`. Introduced in R2024b. Params: `gravity`, `beta` (incline). |
| Mechanical Rotational | `foundation.mechanical.rotational.rotational` | w (ang. velocity) | t (torque) | General-purpose rotary motion. | No domain params. |
| Mechanical Angle-Based Rotational | `foundation.rotational.rotational` | w, theta (angle) | t (torque) | Rotary motion with universal angle tracking. | Carries extra Across `theta` via domain equation `der(theta) == w`. Introduced in R2024b. |
| Thermal | `foundation.thermal.thermal` | T (temperature) | Q (heat flow) | Pure heat transfer / thermal masses. | No domain params. |
| Isothermal Liquid | `foundation.isothermal_liquid.isothermal_liquid` | p (pressure) | mdot (mass flow) | See fluid rules below. | |
| Thermal Liquid | `foundation.thermal_liquid.thermal_liquid` | p, T | mdot, Phi (energy flow) | See fluid rules below. | |
| Two-Phase Fluid | `foundation.two_phase_fluid.two_phase_fluid` | p, u (spec. internal energy) | mdot, Phi | See fluid rules below. | |
| Gas | `foundation.gas.gas` | p, T | mdot, Phi | See fluid rules below. | |
| Moist Air | `foundation.moist_air.moist_air` | p, T, x_w, x_g, r_d | mdot, Phi, mdot_w, mdot_g, mdot_d | See fluid rules below. | |
| Hydraulic (deprecated) | `foundation.hydraulic.hydraulic` | p | q (volumetric flow, m³/s) | **Do not use.** | Deprecated since R2020a, will be removed. Replaced by **isothermal liquid**, which conserves mass flow (`mdot`) rather than volumetric flow. |

## Fluid Domain Selection

The fluid choice is the trickiest. Decide along four axes, in order:

1. **Does temperature / heat transfer matter?** No → the fluid can stay isothermal. Yes → you need an energy Through variable (Phi) and a thermal Across.
2. **Is the fluid compressible (a gas)?** Gas/vapor phases are compressible; liquids are treated as (nearly) incompressible.
3. **Single phase or two-phase?** Does the fluid boil/condense within the model?
4. **Multiple species / humidity?** Is water vapor, trace gas, or droplet content tracked separately?

| If the fluid is… | Heat transfer matters? | Domain |
|------------------|------------------------|--------|
| Liquid (hydraulic oil, water) | No — isothermal | Isothermal liquid |
| Liquid | Yes — thermal effects / temp-dependent props | Thermal liquid |
| Liquid **and** vapor of one substance (boils/condenses) | Yes (always) | Two-phase fluid |
| Single-species compressible gas (air, N2) | Yes (always) | Gas |
| Gas mixture with humidity / trace gas / droplets | Yes (always) | Moist air |

Decision rules:
- **Isothermal vs. thermal liquid:** choose isothermal_liquid (1 Across + 1 Through) when temperature is uniform and constant — it halves the equation count. Switch to thermal_liquid (2+2) the moment any component exchanges heat or a property depends on temperature.
- **Thermal liquid vs. two-phase:** stay single-phase (thermal_liquid) if the fluid never crosses saturation in the operating range. Use two_phase_fluid only when liquid↔vapor phase change is part of the physics (refrigeration cycles, boilers, evaporators).
- **Gas vs. two-phase:** gas is a single-species compressible fluid that stays gaseous; if it can condense to a liquid you want, use two-phase instead. Gas fidelity (perfect / semiperfect / real) is set by the `gas_spec` domain parameter.
- **Gas vs. moist air:** use gas for a single species. Use moist_air when you must track humidity (water vapor), condensed water droplets, or a trace/third gas species independently — moist_air carries extra species Across (x_w, x_g, r_d) and Through (mdot_w, mdot_g, mdot_d) variables for exactly this.
- Every fluid circuit needs a properties/settings source block (IL / TL / 2P / Gas / Moist Air) on each topologically distinct circuit; omitting it applies the domain default fluid (water, or dry air for gas/moist air). This is why fluid domains carry large property parameter sets — they are injected from that source component.

### Per-domain fluid references

Fluid components are the hardest to get idiomatically right. Before drafting one, read the reference for the specific domain — each lists the node's property surface (the `A.<name>` parameters injected by the properties/settings source) and a component template.

| Domain | Reference |
|--------|-----------|
| Gas | [`gas.md`](gas.md) |
| Isothermal liquid | [`isothermal-liquid.md`](isothermal-liquid.md) |
| Thermal liquid | [`thermal-liquid.md`](thermal-liquid.md) |
| Two-phase fluid | [`two-phase-fluid.md`](two-phase-fluid.md) |
| Moist air | [`moist-air.md`](moist-air.md) |

Non-fluid domains (electrical, mechanical, thermal) don't need a per-domain reference — their equations are simple enough that the Across/Through columns above are sufficient.

----

Copyright 2026 The MathWorks, Inc.

----
