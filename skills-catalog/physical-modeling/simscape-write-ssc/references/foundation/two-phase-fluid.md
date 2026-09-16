# foundation.two_phase_fluid.two_phase_fluid

Reference for writing components on `foundation.two_phase_fluid.two_phase_fluid` — a two-phase fluid domain where all properties come from 2-D table lookups indexed by normalized internal energy and pressure.

## Across / Through

- `A.p` — pressure (MPa), Across
- `A.u` — specific internal energy (kJ/kg), Across
- `A.mdot` — mass flow rate (kg/s), Through
- `A.Phi` — energy flow rate (kW), Through


## Template

**Read the component template before writing anything.**

```matlab
type(which('simscape.template.two_phase_fluid.two_port_dynamic'))   % has internal fluid state
type(which('simscape.template.two_phase_fluid.two_port_steady'))    % no internal state (quasi-steady)
```

## Node property surface (`A.<name>`)

There is no fidelity switching. All properties are obtained from 2-D table lookups.

### Grid axes

| Property | Size | Notes |
|----------|------|-------|
| `A.p_TLU` | 100x1 | Pressure axis shared by every table |
| `A.unorm_TLU` | 50x1 | Normalized internal energy axis (full range) |
| `A.unorm_liq_TLU` | 25x1 | Subcooled-liquid sub-grid |
| `A.unorm_mix_TLU` | 50x1 | Two-phase mixture sub-grid |
| `A.unorm_vap_TLU` | 25x1 | Superheated-vapor sub-grid |

### Thermodynamic properties (indexed by `(unorm, p)`)

| Property | Description |
|----------|-------------|
| `A.v_TLU` | Specific volume (m^3/kg) |
| `A.T_TLU` | Temperature (K) |
| `A.s_TLU` | Specific entropy (kJ/(K*kg)) |

### Transport properties (indexed by `(unorm, p)`)

| Property | Description |
|----------|-------------|
| `A.nu_TLU` | Kinematic viscosity (mm^2/s) |
| `A.k_TLU` | Thermal conductivity (W/(K*m)) |
| `A.Pr_TLU` | Prandtl number |

### Saturation curves (indexed by `p` alone)

| Property | Description |
|----------|-------------|
| `A.u_sat_liq_TLU` | Saturated liquid specific internal energy (kJ/kg) |
| `A.u_sat_vap_TLU` | Saturated vapor specific internal energy (kJ/kg) |

### Density partial derivatives (phase-specific sub-grids)

| Property | Grid | Unit |
|----------|------|------|
| `A.DrhoDp_liq_TLU` | `(unorm_liq_TLU, p_TLU)` | kg/(MPa*m^3) |
| `A.DrhoDp_mix_TLU` | `(unorm_mix_TLU, p_TLU)` | kg/(MPa*m^3) |
| `A.DrhoDp_vap_TLU` | `(unorm_vap_TLU, p_TLU)` | kg/(MPa*m^3) |
| `A.DrhoDu_liq_TLU` | `(unorm_liq_TLU, p_TLU)` | kg^2/(kJ*m^3) |
| `A.DrhoDu_mix_TLU` | `(unorm_mix_TLU, p_TLU)` | kg^2/(kJ*m^3) |
| `A.DrhoDu_vap_TLU` | `(unorm_vap_TLU, p_TLU)` | kg^2/(kJ*m^3) |

### Validity, bounds, and constants

| Property | Meaning |
|----------|---------|
| `A.p_min`, `A.p_max` | Valid pressure range for `assert` |
| `A.u_min`, `A.u_max` | Valid specific internal energy range for `assert` |
| `A.p_crit` | Critical pressure (above it, no two-phase region) |
| `A.p_atm` | Atmospheric pressure |
| `A.properties_range_check` | `Action=` value for valid-region asserts |
| `A.transition_range` | Smoothing width (in `unorm`) across phase boundaries |
| `A.q_rev` | Dynamic pressure threshold for flow reversal |
| `A.k_cv_liq`, `A.k_cv_vap` | Thermal conductivity / specific heat ratios for conduction |
| `A.max_aspect_ratio` | Maximum component aspect ratio for thermal conduction |

## Domain helpers

### `normalized_internal_energy` — state locator

Maps `(u, p)` to the normalized coordinate `unorm` used to index every `(unorm, p)` table:

```ssc
unorm_I = foundation.two_phase_fluid.normalized_internal_energy(u_I, p_I, ...
    A.u_min, A.u_max, A.p_TLU, A.u_sat_liq_TLU, A.u_sat_vap_TLU);
```

Interpretation of `unorm`:
- `unorm < 0` — subcooled liquid
- `unorm` in `[0, 1]` — two-phase mixture (vapor quality = `unorm`)
- `unorm > 1` — superheated vapor

### `internal_energy` — initial-condition resolver

Collapses the user's chosen initial-energy specification into a single `u_init_used`:

```ssc
parameters (Access = private)
    [u_init_used, unorm_init, T_min_init_, T_max_init_, h_min_init_, h_max_init_] = ...
        foundation.two_phase_fluid.internal_energy(p_init, T_init, ...
        x_init, alpha_init, h_init, u_init, energy_spec, 0, A.u_min, A.u_max, ...
        A.unorm_TLU, A.unorm_liq_TLU, A.unorm_vap_TLU, A.p_TLU, A.v_TLU, A.T_TLU, ...
        A.u_sat_liq_TLU, A.u_sat_vap_TLU);

    v_init = tablelookup(A.unorm_TLU, A.p_TLU, A.v_TLU, unorm_init, p_init, ...
        interpolation = linear, extrapolation = linear);
end
```

## Property lookup pattern

Compute `unorm` once, then look up all properties on the `(A.unorm_TLU, A.p_TLU)` grid:

```ssc
intermediates (Access = private, ExternalAccess = none)
    unorm_I = foundation.two_phase_fluid.normalized_internal_energy(u_I, p_I, ...
        A.u_min, A.u_max, A.p_TLU, A.u_sat_liq_TLU, A.u_sat_vap_TLU);
end

intermediates (Access = private)
    v_I = tablelookup(A.unorm_TLU, A.p_TLU, A.v_TLU, unorm_I, p_I, ...
        interpolation = linear, extrapolation = linear); % Specific volume
    T_I = tablelookup(A.unorm_TLU, A.p_TLU, A.T_TLU, unorm_I, p_I, ...
        interpolation = linear, extrapolation = linear); % Temperature
    x_I = simscape.function.limit(unorm_I, 0, 1, false); % Vapor quality
end
```

All thermodynamic and transport properties follow the same `tablelookup(A.unorm_TLU, A.p_TLU, A.<prop>_TLU, unorm_I, p_I, ...)` pattern.

## Conservation equations with `der(p_I)` and `der(u_I)`

Dynamic components use `p_I` and `u_I` as state variables. The mass and energy balance:

```ssc
% Mass conservation — integrate density to track mass
der(mass) == mdot_net;

% Pressure from density partial derivatives
(DrhoDp_I*der(p_I) + DrhoDu_I*der_u_I) * volume == mdot_net + correction;

% Energy conservation
mass*der(u_I) + mdot_net*u_I == Phi_net + Q_H;
```

Where `der_u_I` is the time derivative of `u_I` computed from energy conservation:

```ssc
der_u_I = (Phi_net + Q_H - mdot_net*u_I) / mass;
```

### Density partial derivatives with phase-specific tables

Each partial derivative has separate liquid, mixture, and vapor tables on their respective sub-grids:

```ssc
intermediates (Access = private, ExternalAccess = none)
    DrhoDp_liq_I = tablelookup(A.unorm_liq_TLU, A.p_TLU, A.DrhoDp_liq_TLU, unorm_I, p_I, interpolation = linear, extrapolation = linear);
    DrhoDp_vap_I = tablelookup(A.unorm_vap_TLU, A.p_TLU, A.DrhoDp_vap_TLU, unorm_I, p_I, interpolation = linear, extrapolation = linear);
    DrhoDp_mix_I = tablelookup(A.unorm_mix_TLU, A.p_TLU, A.DrhoDp_mix_TLU, unorm_I, p_I, interpolation = linear, extrapolation = linear);
    DrhoDu_liq_I = tablelookup(A.unorm_liq_TLU, A.p_TLU, A.DrhoDu_liq_TLU, unorm_I, p_I, interpolation = linear, extrapolation = linear);
    DrhoDu_vap_I = tablelookup(A.unorm_vap_TLU, A.p_TLU, A.DrhoDu_vap_TLU, unorm_I, p_I, interpolation = linear, extrapolation = linear);
    DrhoDu_mix_I = tablelookup(A.unorm_mix_TLU, A.p_TLU, A.DrhoDu_mix_TLU, unorm_I, p_I, interpolation = linear, extrapolation = linear);
end
```

### Mass tracking with correction term

Mass is tracked by integrating the continuity equation. A correction term compensates for numerical drift between the integrated density and the property-table density:

```ssc
variables (Access = protected, ExternalAccess = none)
    rho_continuity = {value = 1/v_init, priority = priority.high}; % Integrated density
end

intermediates (Access = private)
    mass = rho_continuity * volume;
    correction = (mass - volume/v_I) / time_constant;
end
```

## Port convection subcomponents

Dynamic and steady components both use internal `port_convection` subcomponents to compute energy convection at each port:

```ssc
components (ExternalAccess = none)
    convection_A = foundation.two_phase_fluid.port_convection(flow_area = area_A, length_scale = sqrt(4*area_A/pi));
end
connections
    connect(A, convection_A.port);
end
equations
    convection_A.mdot == mdot_A;
    convection_A.Phi  == Phi_A;
    convection_A.ht_I == u_I + p_I*v_I + (mdot_A*v_I/area_A)^2/2;
end
```

The `ht_I` assignment provides the internal total specific enthalpy (internal energy + flow work + kinetic energy) used by the convection component to determine the direction-dependent energy flow.

## Initial-energy specification (dynamic only)

Expose a `foundation.enum.energy_spec` dropdown to let users choose how initial energy is specified. Use conditional `ExternalAccess` to show only the relevant parameter:

```ssc
parameters
    energy_spec = foundation.enum.energy_spec.temperature; % Initial fluid energy specification
    %                                                        1 - temperature
    %                                                        2 - quality
    %                                                        3 - void_fraction
    %                                                        4 - enthalpy
    %                                                        5 - internal_energy
    p_init = {0.101325, 'MPa'}; % Initial pressure
end
parameters (ExternalAccess = none)
    T_init     = {293.15,   'K'    }; % Initial temperature
    x_init     = {0.5,      '1'    }; % Initial vapor quality
    alpha_init = {0.5,      '1'    }; % Initial vapor void fraction
    h_init     = {1500,     'kJ/kg'}; % Initial specific enthalpy
    u_init     = {1500,     'kJ/kg'}; % Initial specific internal energy
end
```

Then conditionally promote each and assert its validity:

```ssc
if energy_spec == foundation.enum.energy_spec.temperature
    annotations
        T_init : ExternalAccess = modify;
    end
    equations
        assert(T_init >= T_min_init)
        assert(T_init <= T_max_init)
    end
elseif energy_spec == foundation.enum.energy_spec.quality
    annotations
        x_init : ExternalAccess = modify;
    end
    equations
        assert(p_init < A.p_crit)
        assert(x_init >= 0)
        assert(x_init <= 1)
    end
elseif energy_spec == foundation.enum.energy_spec.void_fraction
    annotations
        alpha_init : ExternalAccess = modify;
    end
    equations
        assert(p_init < A.p_crit)
        assert(alpha_init >= 0)
        assert(alpha_init <= 1)
    end
elseif energy_spec == foundation.enum.energy_spec.enthalpy
    annotations
        h_init : ExternalAccess = modify;
    end
    equations
        assert(h_init >= h_min_init)
        assert(h_init <= h_max_init)
    end
else % internal_energy
    annotations
        u_init : ExternalAccess = modify;
    end
    equations
        assert(u_init >= A.u_min)
        assert(u_init <= A.u_max)
    end
end
```

The `quality` and `void_fraction` branches must assert `p_init < A.p_crit` because these specifications are only meaningful below the critical point.

----

Copyright 2026 The MathWorks, Inc.

----
