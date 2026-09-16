# foundation.thermal_liquid.thermal_liquid

Reference for writing components on `foundation.thermal_liquid.thermal_liquid` — an incompressible liquid domain where all properties come from 2-D table lookups on pressure and temperature.

## Across / Through

- `A.p` — pressure (MPa), Across
- `A.T` — temperature (K), Across
- `A.mdot` — mass flow rate (kg/s), Through
- `A.Phi` — energy flow rate (kW), Through

## Template

**Read the component template before writing anything.**

```matlab
type(which('simscape.template.thermal_liquid.two_port_dynamic'))   % has internal fluid state
type(which('simscape.template.thermal_liquid.two_port_steady'))    % no internal state (quasi-steady)
```

## Node property surface (`A.<name>`)

Every `thermal_liquid` node exposes fluid property tables injected by the Thermal Liquid Properties source block on the network.

### Grid axes

| Property | Size | Unit | Notes |
|----------|------|------|-------|
| `A.T_TLU` | 11x1 | K | Temperature vector |
| `A.p_TLU` | 1x12 | MPa | Pressure vector |

### Thermodynamic properties

All tables are indexed by `(A.T_TLU, A.p_TLU)`.

| Property | Unit | Meaning |
|----------|------|---------|
| `A.rho_TLU` | kg/m^3 | Density |
| `A.u_TLU` | kJ/kg | Specific internal energy |
| `A.cp_TLU` | kJ/(K*kg) | Specific heat at constant pressure |
| `A.beta_TLU` | GPa | Isothermal bulk modulus |
| `A.alpha_TLU` | 1/K | Isobaric thermal expansion coefficient |

### Transport properties

| Property | Unit | Meaning |
|----------|------|---------|
| `A.nu_TLU` | mm^2/s | Kinematic viscosity |
| `A.mu_TLU` | cP | Dynamic viscosity |
| `A.k_TLU` | mW/(K*m) | Thermal conductivity |
| `A.Pr_TLU` | 1 | Prandtl number |

### Validity and bounds

| Property | Meaning |
|----------|---------|
| `A.p_min`, `A.p_max`, `A.T_min`, `A.T_max` | Valid-range bounds for `assert` |
| `A.p_atm`, `A.T_atm` | Atmospheric reference conditions |
| `A.pT_region_flag` | enum `foundation.enum.pT_region_TL.{min_max, validity_matrix}` |
| `A.pT_validity_TLU` | 0/1 validity matrix |
| `A.properties_range_check` | `Action=` value for valid-region asserts |

### Air entrainment (use only if needed)

| Property | Unit | Meaning |
|----------|------|---------|
| `A.R_air` | kJ/(K*kg) | Specific gas constant of air |
| `A.air_fraction` | 1 | Volumetric fraction of entrained air at atmospheric conditions |
| `A.air_dissolution_model` | 1 | Air dissolution model flag |
| `A.p_crit` | MPa | Full dissolution pressure |
| `A.k_cv` | kg/(m*s) | Ratio of thermal conductivity to specific heat |
| `A.max_aspect_ratio` | 1 | Maximum component aspect ratio for thermal conduction |

## Property lookup pattern

All properties use the same 2-D `tablelookup` on the shared grid:

```ssc
rho_I == tablelookup(A.T_TLU, A.p_TLU, A.rho_TLU, T_I, p_I, interpolation = linear, extrapolation = linear);
u_I   == tablelookup(A.T_TLU, A.p_TLU, A.u_TLU,   T_I, p_I, interpolation = linear, extrapolation = linear);
cp_I   = tablelookup(A.T_TLU, A.p_TLU, A.cp_TLU,  T_I, p_I, interpolation = linear, extrapolation = linear);
```

Swap `A.<prop>_TLU` for the relevant property. Dynamic components evaluate at `(T_I, p_I)`. Steady components use port values `(A.T, A.p)` or `(B.T, B.p)`. Viscosity lookups typically use `extrapolation = nearest`.

Compute enthalpy algebraically:

```ssc
h_I = u_I + p_I/rho_I;
```

## Conservation equations with `der(p_I)` and `der(T_I)`

### Mass conservation

```ssc
(der(p_I)/beta_I - der(T_I)*alpha_I) * rho_I * volume == mdot_net;
```

### Energy conservation

```ssc
der(p_I)*dUdp + der(T_I)*dUdT == Phi_net + Q_H;
```

### Partial derivatives

The energy partials `dUdp` and `dUdT` (total internal energy w.r.t. `p` and `T` at constant volume):

```ssc
intermediates (Access = private, ExternalAccess = none)
    cp_I    = tablelookup(A.T_TLU, A.p_TLU, A.cp_TLU,    T_I, p_I, interpolation = linear, extrapolation = linear);
    beta_I  = tablelookup(A.T_TLU, A.p_TLU, A.beta_TLU,  T_I, p_I, interpolation = linear, extrapolation = linear);
    alpha_I = tablelookup(A.T_TLU, A.p_TLU, A.alpha_TLU, T_I, p_I, interpolation = linear, extrapolation = linear);

    dUdp = (rho_I * h_I / beta_I - T_I * alpha_I) * volume;
    dUdT = (cp_I - h_I * alpha_I) * rho_I * volume;
end
```

## Port convection subcomponents

Every port requires a `port_convection` subcomponent that computes energy convection. Declare one per port:

```ssc
components (ExternalAccess = none)
    convection_A = foundation.thermal_liquid.port_convection(flow_area = area_A, length_scale = sqrt(4*area_A/pi));
    convection_B = foundation.thermal_liquid.port_convection(flow_area = area_B, length_scale = sqrt(4*area_B/pi));
end

connections
    connect(A, convection_A.port);
    connect(B, convection_B.port);
end
```

Wire flow variables and internal energy to each convection component:

```ssc
equations
    convection_A.mdot == mdot_A;
    convection_A.Phi  == Phi_A;
    convection_A.u_I  == u_I;
    convection_B.mdot == mdot_B;
    convection_B.Phi  == Phi_B;
    convection_B.u_I  == u_I;
end
```

## pT validity check pattern

```ssc
let
    [indicator_pT_A, indicator_pT_B] = ...
        if A.pT_region_flag == foundation.enum.pT_region_TL.validity_matrix, ...
            tablelookup(A.T_TLU, A.p_TLU, A.pT_validity_TLU, A.T, A.p, interpolation = linear, extrapolation = linear); ...
            tablelookup(A.T_TLU, A.p_TLU, A.pT_validity_TLU, B.T, B.p, interpolation = linear, extrapolation = linear) ...
        else ...
            1; ...
            1 ...
        end;
in
    assert(indicator_pT_A > 0, Action = A.properties_range_check)
    assert(A.p >= A.p_min, Action = A.properties_range_check)
    assert(A.p <= A.p_max, Action = A.properties_range_check)
    assert(A.T >= A.T_min, Action = A.properties_range_check)
    assert(A.T <= A.T_max, Action = A.properties_range_check)
    assert(indicator_pT_B > 0, Action = A.properties_range_check)
    assert(B.p >= A.p_min, Action = A.properties_range_check)
    assert(B.p <= A.p_max, Action = A.properties_range_check)
    assert(B.T >= A.T_min, Action = A.properties_range_check)
    assert(B.T <= A.T_max, Action = A.properties_range_check)
end
```

For internal-volume validity checks, evaluate at `(T_I, p_I)` instead of port values.

----

Copyright 2026 The MathWorks, Inc.

----
