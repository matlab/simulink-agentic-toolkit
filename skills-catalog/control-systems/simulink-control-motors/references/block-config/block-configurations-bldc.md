# BLDC Block Configuration Reference

> BLDC motor, six-step commutation, Hall sensors, and trapezoidal control.
> For PMSM/sinusoidal FOC blocks see `block-configurations.md`.

---

## BLDC Motor Block

**Path:** `mcblib/Control/Synchronous Machine/Electrical Systems/Motors/BLDC`
**Fallback:** `find_system('mcblib','SearchDepth',5,'Name','BLDC')`

### CRITICAL: Dual Parameter Trap

The BLDC block has TWO parameters for discrete mode. **Set BOTH:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| `SimType` | `'Discrete'` | GUI dropdown |
| `sim_type` | `'Discrete'` | Internal mask parameter (different name!) |
| `BlockSampleTime` | `'Ts'` | — |
| `P` | `'motor.p'` | Pole pairs |
| `Rs` | `'motor.Rs'` | Stator resistance |
| `Ld` | `'motor.Ld'` | d-axis inductance |
| `Lq` | `'motor.Lq'` | q-axis inductance |
| `Lambda` | `'motor.FluxPM'` | **'Lambda' not 'FluxPM'** |
| `J` | `'motor.J'` | Inertia |
| `B` | `'motor.B'` | Friction |
| `MechInput` | `'Torque'` | Mechanical load type |

Setting only `SimType` OR only `sim_type` causes partial discrete mode — solver mismatch with incorrect dynamics.

### Port Map

| Port | Dir | Signal | Notes |
|------|-----|--------|-------|
| u1 | In | Vabc (3×1) or gate signals | Depends on drive mode |
| u2 | In | Load torque (Nm) | — |
| y1 | Out | Info bus | Iabc, speed, position, torque, back-EMF |
| y2 | Out | Phase currents (single) | [Ia;Ib;Ic] |
| y3 | Out | Speed (single) | Mechanical rad/s |

---

## Six-Step Commutation Block

**Path:** `mcblib/Control/Synchronous Machine/Controllers/Six Step Commutation`

### Port Map

| Port | Dir | Signal | Notes |
|------|-----|--------|-------|
| u1 | In | Hall sector (integer 1-6) | From Hall decoder or LUT |
| u2 | In | Direction (1 or -1) | Forward/reverse |
| u3 | In | Duty cycle [0,1] | Speed command |
| y1 | Out | Gate signals (6×1) | **boolean output** |

### CRITICAL: Boolean→Double Conversion Required

Six-Step output is **boolean**. BLDC Inverter input requires **double**.

Add a Data Type Conversion block (`OutDataTypeStr='double'`) between Six-Step output and BLDC Inverter input. Without this: type propagation error or silent zero-current.

---

## Hall Sensor Blocks

### Hall Speed and Position

| Parameter | Notes |
|-----------|-------|
| `PolePairs` | Pole pairs |
| `ClkFreq` | Timer clock frequency (Hz) |
| `MinSpeed` | Minimum detectable speed (RPM) |
| `HallInterruptConfig` | `'Rising'`, `'Falling'`, `'Both'` |
| `Sequence` | Hall sequence table [6×1] — motor-specific |

### Hall Validity

Validates Hall transitions (rejects impossible sequences).

| Parameter | Notes |
|-----------|-------|
| `ValidTransitions` | 6×2 matrix of valid [from, to] sector pairs |
| `FaultAction` | `'Hold last valid'` or `'Output zero'` |

---

## Hall Simulation (Without Hardware)

To simulate Hall signals from motor position, use a 1-D Lookup Table:

- **Input:** electrical angle (rad) from BLDC motor info bus
- **Breakpoints:** `[0, π/3, 2π/3, π, 4π/3, 5π/3, 2π]`
- **Table:** `[5 4 6 2 3 1 5]` (standard 120° placement — verify per motor)
- **Interpolation:** `'Flat'` (nearest)

---

## Speed Control (Trapezoidal)

For BLDC speed control, the PI controller output becomes the duty cycle input to Six-Step:
- Saturate PI output to [0, 1] before feeding to Six-Step duty port
- No V2D conversion needed (duty is already normalized)

---

## Known Issues (R2025+)

- Bus dimension mismatches with BLDC + Six-Step + Inverter integration — use explicit Mux/Demux at interfaces
- Sensorless Six-Step back-EMF zero-crossing fails below ~5% rated speed — use forced commutation for startup
- If trapezoidal control isn't essential, sinusoidal FOC with PMSM block is more mature for simulation

---

## Common Mistakes

1. **Setting only SimType (not sim_type)** — partial discrete mode
2. **Missing Bool→Double DTC** — Six-Step output incompatible with inverter input
3. **Wrong Hall sequence** — motor spins backward or locks
4. **Using `FluxPM` instead of `Lambda`** — BLDC block uses `Lambda` for flux parameter name
5. **Duty > 1.0 without saturation** — causes gate driver faults

----
Copyright 2026 The MathWorks, Inc.
----
