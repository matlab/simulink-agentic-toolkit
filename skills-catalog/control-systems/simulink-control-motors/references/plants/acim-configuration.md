# ACIM (Induction Motor) Configuration Reference

> Plant block parameters, slip calculation concept, and ACIM-specific control blocks.
> For PMSM plant blocks see `block-configurations-plants.md`.

---

## Induction Motor Block

**Path:** `mcblib/Control/Induction Machine/Electrical Systems/Motors/Induction Motor`
**Fallback:** `find_system('mcblib','SearchDepth',5,'Name','Induction Motor')`

### CRITICAL: Zs/Zr Use LEAKAGE Values, Not Total Inductances

| Parameter | Format | Meaning |
|-----------|--------|---------|
| `P` | scalar | Pole PAIRS |
| `Zs` | `'[Rs, Xls]'` | `[stator_resistance, stator_LEAKAGE_inductance]` — use `Ls - Lm` |
| `Zr` | `'[Rr, Xlr]'` | `[rotor_resistance, rotor_LEAKAGE_inductance]` — use `Lr - Lm` |
| `Lm` | scalar | Magnetizing inductance (H) — separate parameter |
| `mechanical` | `'[J, B, 0]'` | [Inertia, Friction, InitialSpeed] |
| `sim_type` | `'Discrete'` | Required for MCB discrete solver |
| `Ts` | `'Ts'` | Sample time |

**Common mistake:** Using total inductance `Ls` in `Zs` instead of leakage `Ls - Lm`. This double-counts the magnetizing path, producing ~2-3× current error and wrong torque.

### Port Map

| Port | Dir | Signal | Notes |
|------|-----|--------|-------|
| u1 | In | Vabc (3×1) | Voltage input |
| u2 | In | Load torque (Nm) | — |
| y1 | Out | Info bus | Stator/rotor currents, speed, torque, flux |
| y2 | Out | Phase currents (single) | [Ia;Ib;Ic] |
| y3 | Out | Mechanical speed (single) | rad/s |

---

## Slip Speed Calculation (Indirect RFOC)

For ACIM, the electrical angle θ_e is synthesized from measured speed + computed slip:

```
ω_slip = iq / (Tr × id_ref)       where Tr = Lr / Rr (rotor time constant)
ω_e = ω_m × p + ω_slip
θ_e = ∫ ω_e dt
```

### Key Design Rules

- **Denominator must be id_ref (constant), NOT id_meas** — at startup id_meas ≈ 0 → division by zero
- **Rotor time constant** Tr = Lr/Rr uses TOTAL Lr (not leakage)
- **Integrator wrapping** — add mod(θ, 2π) to prevent overflow after extended operation
- **id_ref** is typically set to `FluxRated / Lm` (magnetizing current for rated flux)

---

## ACIM LUT Control Reference

**Path:** `mcblib/Control/Induction Machine/Control Reference/LUT based ACIM Control Reference`

### Nonlinearity Modes (2 only — NOT 4 like PMSM)

| Mode | String |
|------|--------|
| 1 | `'Non-linear model with D,Q-flux linkage LUTs'` |
| 2 | `'Non-linear model with id and iq LUTs'` |

There is NO linear/lumped mode — ACIM always requires saturation data.

### Key Parameters

| Parameter | Notes |
|-----------|-------|
| `polePairs` | **lowercase** 'p' — different from PMSM block's uppercase `P` |
| `Llr` | LEAKAGE inductance only (Lr - Lm) |
| `Lm` | Magnetizing inductance |
| `FluxRated` | Rated rotor flux (Wb) — typically `Lm × I_magnetizing` |
| `useRotorSpeed` | `'Use rotor speed (ωₘ)'` or `'Use stator synchronous speed'` |
| `slipTable` | [nId × nIq] slip lookup for nonlinear operation |

---

## ACIM Motor Struct

`mcb.getACIMParameters(name)` may not exist in all releases. Manual definition:

```matlab
motor.Rs = 1.405;        % Stator resistance (Ohm)
motor.Rr = 1.395;        % Rotor resistance (Ohm)
motor.Ls = 0.178;        % Stator total inductance (H)
motor.Lr = 0.178;        % Rotor total inductance (H)
motor.Lm = 0.1722;       % Magnetizing inductance (H)
motor.p = 2;             % Pole pairs
motor.J = 0.0131;        % Inertia (kg.m^2)
motor.B = 0.0;           % Friction
motor.I_rated = 4.0;     % Rated current (A)
motor.N_rated = 1440;    % Rated speed (RPM)
motor.FluxRated = motor.Lm * (motor.I_rated * 0.7);
motor.Tr = motor.Lr / motor.Rr;  % Rotor time constant
```

---

## Common Mistakes

1. **Zs/Zr with total inductance** — must use LEAKAGE (Ls - Lm, Lr - Lm)
2. **Dividing by id_meas at startup** — use id_ref constant to avoid NaN
3. **Wrong Tr** — rotor time constant uses total Lr/Rr, NOT leakage
4. **No angle wrapping** — integrator overflows after extended operation → NaN
5. **polePairs (lowercase)** — ACIM block uses different capitalization than PMSM block

----
Copyright 2026 The MathWorks, Inc.
----
