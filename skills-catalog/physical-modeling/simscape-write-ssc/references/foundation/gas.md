# foundation.gas.gas

Reference for writing components on `foundation.gas.gas` — a compressible gas domain supporting three fidelity levels in a single component.

## Across / Through

- `A.p` — pressure (MPa), Across
- `A.T` — temperature (K), Across
- `A.mdot` — mass flow rate (kg/s), Through
- `A.Phi` — energy flow rate (kW), Through

## Template

**Read the component template before writing anything.**

```matlab
type(which('simscape.template.gas.two_port_dynamic'))   % has internal fluid state
type(which('simscape.template.gas.two_port_steady'))    % no internal state (quasi-steady)
```

## Gas fidelity (`A.gas_spec`)

Every property lookup branches on `A.gas_spec`:

| Arm | Enum | How properties are obtained |
|-----|------|---------------------------|
| Perfect | `foundation.enum.gas_spec.perfect_gas` | Scalar reference values (`*_ref`) + analytical formulas |
| Semiperfect | `foundation.enum.gas_spec.semiperfect_gas` | 1-D tables indexed by `A.T_TLU1` (temperature only) |
| Real | `foundation.enum.gas_spec.real_gas` | 2-D tables indexed by `(A.T_TLU2, A.p_TLU2)` or log-space `(A.log_T_TLU2, A.log_p_TLU2)` |

One component must handle all three arms unless design has specified otherwise.

## Node property surface (`A.<name>`)

### Grid axes

| Property | Used by | Notes |
|----------|---------|-------|
| `A.T_TLU1`, `A.log_T_TLU1` | semiperfect 1-D lookups | T and log(T) grids |
| `A.T_TLU2`, `A.p_TLU2` | real-gas linear-space 2-D lookups | |
| `A.log_T_TLU2`, `A.log_p_TLU2` | real-gas log-space 2-D lookups | |

### Thermodynamic properties

| Property | Perfect | Semiperfect | Real |
|----------|---------|-------------|------|
| Gas constant | `A.R` | `A.R` | `A.R` |
| Compressibility | `A.Z` | `A.Z` | — (folded into tables) |
| Specific heat (cp) | `A.cp_ref` | `A.cp_TLU1` | `A.cp_TLU2` |
| Specific heat (cv) | `A.cv_ref` | `A.cv_TLU1` | `A.cv_TLU2` |
| Specific enthalpy | `A.h_ref`, `A.T_ref` | `A.h_TLU1` | `A.h_TLU2` |
| Density | `A.log_ZR` (analytical) | `A.log_ZR` (analytical) | `A.log_rho_TLU2` |
| Entropy | analytical | `A.int_dh_T_TLU1` | `A.s_TLU2` |
| Log-space density unit | `A.rho_unit` | `A.rho_unit` | `A.rho_unit` |
| Log-space conversions | `A.p_unit`, `A.T_unit` | `A.p_unit`, `A.T_unit` | `A.p_unit`, `A.T_unit` |

### Transport properties

| Property | Perfect | Semiperfect | Real |
|----------|---------|-------------|------|
| Dynamic viscosity | `A.mu_ref` | `A.mu_TLU1` | `A.mu_TLU2` |
| Thermal conductivity | `A.k_ref` | `A.k_TLU1` | `A.k_TLU2` |
| Prandtl number | `A.Pr_ref` | `A.Pr_TLU1` | `A.Pr_TLU2` |
| Speed of sound | analytical | `A.a_TLU1` | `A.a_TLU2` |

### Density derivative tables (real gas only)

| Property | Lookup space | Notes |
|----------|-------------|-------|
| `A.log_drho_dp_TLU2` | log-space | `exp(...)* A.drho_dp_unit` |
| `A.log_drho_dT_TLU2` | log-space | `-exp(...)* A.drho_dT_unit` (table stores magnitude, negate result) |
| `A.drhou_dp_TLU2` | linear-space | Direct lookup, no `exp` |
| `A.drhou_dT_TLU2` | linear-space | Direct lookup, no `exp` |

### Validity and bounds

| Property | Meaning |
|----------|---------|
| `A.p_min`, `A.p_max`, `A.T_min`, `A.T_max` | Valid-range bounds for `assert` |
| `A.p_atm`, `A.T_atm` | Atmospheric reference conditions |
| `A.pT_region_flag` | enum `foundation.enum.pT_region_G.{min_max, validity_matrix}` |
| `A.pT_validity_TLU2` | 0/1 validity matrix (real gas only) |
| `A.properties_range_check` | `Action=` value for valid-region asserts |

## Property lookup patterns

### Standard three-arm pattern (enthalpy example)

```ssc
h_I = ...
    if A.gas_spec == foundation.enum.gas_spec.perfect_gas, ...
        A.h_ref + A.cp_ref*(T_I - A.T_ref) ...
    elseif A.gas_spec == foundation.enum.gas_spec.semiperfect_gas, ...
        tablelookup(A.T_TLU1, A.h_TLU1, T_I, interpolation = linear, extrapolation = linear) ...
    else ... % real_gas
        tablelookup(A.T_TLU2, A.p_TLU2, A.h_TLU2, T_I, p_I, interpolation = linear, extrapolation = linear) ...
    end;
```

All linear-space properties (`cp`, `cv`, `h`, `mu`, `k`, `Pr`, speed of sound) follow this same structure — swap `*_ref`, `*_TLU1`, `*_TLU2` for the relevant property. Perfect-gas speed of sound is analytical: `sqrt(A.cp_ref / A.cv_ref * A.Z * A.R * T_I)`.

### Log-space density

Density is stored in log-space. Compute log coordinates first:

```ssc
log_T = simscape.function.logProtected(T_I / A.T_unit, 1);
log_p = simscape.function.logProtected(p_I / A.p_unit, 1);
```

Then:
- Perfect/semiperfect: `rho_I = exp(log_p - A.log_ZR - log_T) * A.rho_unit`
- Real: `rho_I = exp(tablelookup(A.log_T_TLU2, A.log_p_TLU2, A.log_rho_TLU2, log_T, log_p, interpolation = linear, extrapolation = linear)) * A.rho_unit`

### Real-gas density derivatives

```ssc
drho_dp_I =  exp(tablelookup(A.log_T_TLU2, A.log_p_TLU2, A.log_drho_dp_TLU2, log_T_I, log_p_I, interpolation = linear, extrapolation = linear)) * A.drho_dp_unit;
drho_dT_I = -exp(tablelookup(A.log_T_TLU2, A.log_p_TLU2, A.log_drho_dT_TLU2, log_T_I, log_p_I, interpolation = linear, extrapolation = linear)) * A.drho_dT_unit;

drhou_dp_I = tablelookup(A.T_TLU2, A.p_TLU2, A.drhou_dp_TLU2, T_I, p_I, interpolation = linear, extrapolation = linear);
drhou_dT_I = tablelookup(A.T_TLU2, A.p_TLU2, A.drhou_dT_TLU2, T_I, p_I, interpolation = linear, extrapolation = linear);
```

## Conservation equations with `der(p_I)` and `der(T_I)`

When mass or energy balance requires time derivatives of pressure and temperature:

```ssc
der(p_I)*dMdp + der(T_I)*dMdT == mdot_net;
der(p_I)*dUdp + der(T_I)*dUdT == Phi_net + Q_H;
```

The partial derivatives `dMdp`, `dMdT`, `dUdp`, `dUdT` (total mass and internal energy w.r.t. `p` and `T` at constant volume):

```ssc
[dMdp, dMdT, dUdp, dUdT] = ...
    if A.gas_spec ~= foundation.enum.gas_spec.real_gas, ...
        volume * rho_I / p_I; ...
        -volume * rho_I / T_I; ...
        volume * (h_I / (A.Z * A.R * T_I) - 1); ...
        volume * rho_I * (cp_I - h_I/T_I) ...
    else ...
        volume * drho_dp_I; ...
        volume * drho_dT_I; ...
        volume * drhou_dp_I; ...
        volume * drhou_dT_I ...
    end;
```

----

Copyright 2026 The MathWorks, Inc.

----
