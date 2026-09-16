# foundation.moist_air.moist_air

Reference for writing components on `foundation.moist_air.moist_air` — a multi-species compressible gas mixture (dry air + water vapor + optional trace gas + optional entrained water droplets).

## Across / Through

- `A.p` — pressure (Pa), Across
- `A.T` — temperature (K), Across
- `A.x_w` — specific humidity (1), Across
- `A.x_g` — trace gas mass fraction (1), Across
- `A.r_d` — droplet mass ratio (1), Across
- `A.mdot` — mass flow rate (kg/s), Through
- `A.Phi` — energy flow rate (kW), Through
- `A.mdot_w` — water vapor mass flow rate (kg/s), Through
- `A.mdot_g` — trace gas mass flow rate (kg/s), Through
- `A.mdot_d` — droplet mass flow rate (kg/s), Through

A conserving port needs a `branches` line for **each** through variable:

```ssc
branches
    mdot   : A.mdot   -> B.mdot;
    Phi    : A.Phi    -> B.Phi;
    mdot_w : A.mdot_w -> B.mdot_w;
    mdot_g : A.mdot_g -> B.mdot_g;
    mdot_d : A.mdot_d -> B.mdot_d;
end
```

## Template

**Read the component template before writing anything.**

```matlab
type(which('simscape.template.moist_air.two_port_dynamic'))   % has internal fluid state
type(which('simscape.template.moist_air.two_port_steady'))    % no internal state (quasi-steady)
```

## Species-gating switches

Every property lookup and conservation term must branch on these domain-level enums:

| Switch | Type | Values | Effect |
|--------|------|--------|--------|
| `A.trace_gas_model` | `foundation.enum.trace_gas_model` | `none`, `track_fraction`, `track_properties` | Gate all trace-gas terms |
| `A.enable_droplets` | boolean | `true`, `false` | Gate all droplet terms |

## Node property surface (`A.<name>`)

### Grid axis

| Property | Notes |
|----------|-------|
| `A.T_TLU` | Temperature grid for all 1-D lookups |

### Per-species gas constants

| Property | Species | Unit |
|----------|---------|------|
| `A.R_a` | Dry air | J/(kg*K) |
| `A.R_w` | Water vapor | J/(kg*K) |
| `A.R_g` | Trace gas | J/(kg*K) |

### Thermodynamic properties (1-D tables on `A.T_TLU`)

| Property | Species | Notes |
|----------|---------|-------|
| `A.h_a_TLU` | Dry air | Specific enthalpy |
| `A.h_w_TLU` | Water vapor | Specific enthalpy |
| `A.h_g_TLU` | Trace gas | Specific enthalpy |
| `A.h_w_vap_TLU` | Water vapor | Enthalpy of vaporization |
| `A.cp_a_TLU` | Dry air | Specific heat |
| `A.cp_w_TLU` | Water vapor | Specific heat |
| `A.cp_g_TLU` | Trace gas | Specific heat |
| `A.cp_d_TLU` | Droplets | Specific heat (liquid water) |
| `A.int_dh_T_a_TLU` | Dry air | Entropy integrand |
| `A.int_dh_T_w_TLU` | Water vapor | Entropy integrand |
| `A.int_dh_T_g_TLU` | Trace gas | Entropy integrand |
| `A.int_dh_T_d_TLU` | Droplets | Entropy integrand |
| `A.log_p_ws_TLU` | Water vapor | Log saturation pressure |

### Transport properties (1-D tables on `A.T_TLU`)

| Property | Species | Notes |
|----------|---------|-------|
| `A.mu_a_TLU` | Dry air | Dynamic viscosity |
| `A.mu_w_TLU` | Water vapor | Dynamic viscosity |
| `A.mu_g_TLU` | Trace gas | Dynamic viscosity |
| `A.k_a_TLU` | Dry air | Thermal conductivity |
| `A.k_w_TLU` | Water vapor | Thermal conductivity |
| `A.k_g_TLU` | Trace gas | Thermal conductivity |
| `A.Pr_a_TLU` | Dry air | Prandtl number |
| `A.Pr_w_TLU` | Water vapor | Prandtl number |
| `A.Pr_g_TLU` | Trace gas | Prandtl number |
| `A.D_w` | Water vapor | Diffusivity in air (scalar) |
| `A.D_g` | Trace gas | Diffusivity in air (scalar) |

### Reference values

| Property | Meaning |
|----------|---------|
| `A.h_a_ref` | Dry air enthalpy at reference |
| `A.h_w_ref` | Water vapor enthalpy at reference |
| `A.h_g_ref` | Trace gas enthalpy at reference |
| `A.h_w_vap_ref` | Vaporization enthalpy at reference |
| `A.p_atm` | Atmospheric reference pressure |
| `A.T_atm` | Atmospheric reference temperature |

### Validity and bounds

| Property | Meaning |
|----------|---------|
| `A.p_min`, `A.p_max` | Valid pressure range for `assert` |
| `A.T_min`, `A.T_max` | Valid temperature range for `assert` |
| `A.properties_range_check` | `Action=` value for valid-region asserts |

## Property lookup patterns

### Species-gated intermediates

Gate optional species at the top of `equations`, then use the gated values everywhere downstream:

```ssc
x_g_used = if A.trace_gas_model == foundation.enum.trace_gas_model.none, 0 else x_g_I end;
r_d_used = if A.enable_droplets, r_d_I else 0 end;
```

### Mixture property pattern (enthalpy example)

One `tablelookup` per species, then blend with the domain helper:

```ssc
% Per-species enthalpy from 1-D tables
h_a_I = tablelookup(A.T_TLU, A.h_a_TLU, T_I, interpolation = linear, extrapolation = linear);
h_w_I = tablelookup(A.T_TLU, A.h_w_TLU, T_I, interpolation = linear, extrapolation = linear);
h_g_I = tablelookup(A.T_TLU, A.h_g_TLU, T_I, interpolation = linear, extrapolation = linear);

% Droplet enthalpy = liquid water (vapor enthalpy minus vaporization)
h_d_I = h_w_I - tablelookup(A.T_TLU, A.h_w_vap_TLU, T_I, interpolation = linear, extrapolation = linear);

% Blend gas-phase species, then add droplet contribution
h_I = foundation.moist_air.mixture_property(h_a_I, h_w_I, h_g_I, x_w_I, x_g_used, A.trace_gas_model) ...
    + r_d_used * h_d_I;
```

All per-species properties (`cp`, `mu`, `k`) follow this same structure — one lookup per species, then blend. Use `extrapolation = nearest` for `cp`, `mu`, `k`.

### Mixture gas constant and density

```ssc
% Mixture gas constant
R_I = foundation.moist_air.mixture_property(A.R_a, A.R_w, A.R_g, x_w_I, x_g_used, A.trace_gas_model);

% Density from ideal-gas law
rho_I = p_I / (R_I * T_I);
```

## Domain helpers

- `foundation.moist_air.mixture_property(C_a, C_w, C_g, x_w, x_g, trace_gas_model)` — blends per-species properties. Returns `(1-x_w)*C_a + x_w*C_w` when trace gas is `none`, else `(1-x_w-x_g)*C_a + x_w*C_w + x_g*C_g`. Use for `R`, `cp`, `h`, `mu`, `k`.
- `foundation.moist_air.dry_air_trace_gas_fraction(x_w, x_ag_min)` — protected `1 - x_w` with a floor.
- `foundation.moist_air.mass_fractions(...)` — resolves humidity-spec dropdown into initial mass fractions. Only needed by storage components with user-facing initial conditions.

## Conservation equations with `der(p_I)`, `der(T_I)`, `der(x_w_I)`, `der(x_g_I)`, `der(r_d_I)`

Five state variables require five conservation equations: total mass, energy, water vapor mass, trace gas mass, and droplet mass.

```ssc
% Mass balance
der(p_I) * dMdp + der(T_I) * dMdT + der(x_w_I) * dMdxw + der(x_g_I) * dMdxg + der(r_d_I) * dMdrd == mdot_net;

% Energy balance
der(p_I) * dUdp + der(T_I) * dUdT + der(x_w_I) * dUdxw + der(x_g_I) * dUdxg + der(r_d_I) * dUdrd == Phi_net + Q_H;

% Water vapor species balance
der(p_I) * dMwdp + der(T_I) * dMwdT + der(x_w_I) * dMwdxw + der(x_g_I) * dMwdxg + der(r_d_I) * dMwdrd == mdot_w_net;

% Trace gas species balance (gated)
der(p_I) * dMgdp + der(T_I) * dMgdT + der(x_w_I) * dMgdxw + der(x_g_I) * dMgdxg + der(r_d_I) * dMgdrd == mdot_g_net;

% Droplet mass balance (gated)
der(p_I) * dMddp + der(T_I) * dMddT + der(x_w_I) * dMddxw + der(x_g_I) * dMddxg + der(r_d_I) * dMddrd == mdot_d_net;
```

The partial derivatives form a 5x5 Jacobian of conserved quantities (total mass `M`, internal energy `U`, water mass `M_w`, trace gas mass `M_g`, droplet mass `M_d`) w.r.t. the 5 states. For an ideal-gas mixture at constant volume:

```ssc
% Total mass M = rho * V = p * V / (R * T)
dMdp  = volume * rho_I / p_I;
dMdT  = -volume * rho_I / T_I;
dMdxw = -volume * rho_I * (1/R_I) * dRdxw;
dMdxg = -volume * rho_I * (1/R_I) * dRdxg;
dMdrd = 0;
```

## Domain-specific idioms

**Port convection subcomponents.** Dynamic components use `port_convection` subcomponents to compute convective energy and species flows at each port based on flow direction.

**`trace_gas_model` has three levels.** When `track_fraction`, species mass is tracked but properties use a two-component blend. When `track_properties`, the trace gas has its own property tables (`*_g_TLU`) and participates in the mixture property calculation.

**Droplets ride on the gas.** Droplet mass ratio `r_d` is defined as `m_droplets / m_gas_mixture`, so total mass in a volume is `rho * V * (1 + r_d)`.

----

Copyright 2026 The MathWorks, Inc.

----
