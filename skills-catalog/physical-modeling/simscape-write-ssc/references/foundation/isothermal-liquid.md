# foundation.isothermal_liquid.isothermal_liquid

Reference for writing components on `foundation.isothermal_liquid.isothermal_liquid` — a pressure/mass-flow domain with no temperature state.

## Across / Through

- `A.p` — pressure (MPa), Across
- `A.mdot` — mass flow rate (kg/s), Through

## Template

**Read the component template before writing anything.**

Start from `assets/isothermal-liquid-two-port-dynamic.ssc`.

Drop the `p_I` state and its mass-balance ODE for a zero-storage two-port (orifice, valve, source). Drop port `B` for a one-port component.

## Node property surface (`A.<name>`)

**Never declare fluid-property parameters** (density, viscosity, bulk modulus). All fluid properties come from the domain node — either directly (`A.rho_L_atm`, `A.nu_atm`) or via helper functions (`mixture_density`, `mixture_bulk_modulus`).

### Fluid properties (opaque payload)

These fields are injected by the network's Isothermal Liquid Properties block. Pass them through to domain helper functions.

| Property | Markup | Unit |
|----------|--------|------|
| `A.bulk_modulus_model` | Isothermal bulk modulus model | enum |
| `A.air_dissolution_model` | Model air dissolution | enum |
| `A.rho_L_atm` | Liquid density at atmospheric pressure (no entrained air) | kg/m^3 |
| `A.beta_L_atm` | Liquid isothermal bulk modulus at atmospheric pressure (no entrained air) | Pa |
| `A.beta_gain` | Isothermal bulk modulus vs. pressure increase gain | 1 |
| `A.air_fraction` | Volumetric fraction of entrained air at atmospheric pressure | 1 |
| `A.rho_g_atm` | Gas (air) density at atmospheric condition | kg/m^3 |
| `A.polytropic_index` | Air polytropic index | 1 |
| `A.p_atm` | Atmospheric pressure | MPa |
| `A.p_crit` | Pressure at which all entrained air is dissolved | MPa |
| `A.p_min` | Minimum valid pressure | Pa |

### Directly used in component code

| Property | Meaning |
|----------|---------|
| `A.nu_atm` | Kinematic viscosity at atmospheric pressure (m^2/s). Used in orifice Reynolds-number calculations. |
| `A.properties_range_check` | Assert-action enum. Passed to `assert` as `Action = A.properties_range_check`. |

### Helper argument order

`mixture_density` and `mixture_density_derivative` take the full payload:

```
(p, A.bulk_modulus_model, A.air_dissolution_model, A.rho_L_atm, A.beta_L_atm, A.beta_gain, A.air_fraction, A.rho_g_atm, A.polytropic_index, A.p_atm, A.p_crit, A.p_min)
```

`mixture_bulk_modulus` omits density parameters (`rho_L_atm`, `rho_g_atm`):

```
(p, A.bulk_modulus_model, A.air_dissolution_model, A.beta_L_atm, A.beta_gain, A.air_fraction, A.polytropic_index, A.p_atm, A.p_crit, A.p_min)
```

## Property lookup pattern

Properties are obtained by calling domain helper functions. Pass a pressure and the opaque property payload. Use `A.p` (port pressure) or an internal state `p_I` depending on your component:

```ssc
intermediates (Access = private, ExternalAccess = none)
    rho = foundation.isothermal_liquid.mixture_density(p_I, ...
        A.bulk_modulus_model, A.air_dissolution_model, A.rho_L_atm, A.beta_L_atm, A.beta_gain, ...
        A.air_fraction, A.rho_g_atm, A.polytropic_index, A.p_atm, A.p_crit, A.p_min);

    drho_dp = foundation.isothermal_liquid.mixture_density_derivative(p_I, ...
        A.bulk_modulus_model, A.air_dissolution_model, A.rho_L_atm, A.beta_L_atm, A.beta_gain, ...
        A.air_fraction, A.rho_g_atm, A.polytropic_index, A.p_atm, A.p_crit, A.p_min);
end
```

Bulk modulus can be derived from the density helpers (`beta = rho / drho_dp`) or called directly:

```ssc
beta = foundation.isothermal_liquid.mixture_bulk_modulus(p_I, ...
    A.bulk_modulus_model, A.air_dissolution_model, A.beta_L_atm, A.beta_gain, ...
    A.air_fraction, A.polytropic_index, A.p_atm, A.p_crit, A.p_min);
```

## Conservation equation with `der(p_I)`

Dynamic components use a state variable `p_I` (pressure). The mass balance is:

```ssc
der(p_I) * drho_I_dp * volume == mdot_net;
```

where `mdot_net` is the algebraic sum of all port mass flow rates into the volume, `drho_I_dp` comes from `mixture_density_derivative`, and `volume` is the fluid volume (constant or time-varying).

For a two-port dynamic component, `mdot_net = mdot_A + mdot_B`. Connect internal pressure to ports with `A.p == p_I; B.p == p_I` (assuming no flow resistance to the volume).

----

Copyright 2026 The MathWorks, Inc.

----
