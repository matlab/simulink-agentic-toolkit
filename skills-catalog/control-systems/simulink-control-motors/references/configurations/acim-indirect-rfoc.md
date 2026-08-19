# Configuration: ACIM Indirect Rotor-Field-Oriented Control

**Motor:** ACIM (MCB Induction Motor block)
**Control:** Indirect RFOC using dedicated MCB blocks for slip estimation and current references
**Use case:** Industrial drives requiring precise speed/torque control of induction motors

## Architecture (Using MCB Blocks)
```
Speed_Ref → Speed_PI → Tref → ACIM Control Reference → id*/iq*
                                    ↑ (flux_ref, speed)
id*/iq* → PI_d/PI_q → InvPark(θe) → InvClarke → V2D → Inverter → IM
θe ← ACIM Slip Speed Estimator (id_ref, iq_ref, speed_meas, motor_params)
```

## Key MCB Blocks for ACIM

### ACIM Slip Speed Estimator
- **Purpose:** Computes slip frequency and integrates to produce θe
- **Inputs:** id_ref, iq_ref, measured speed (ωm)
- **Output:** Electrical angle θe for Park/InvPark transforms
- **Key params:** Rotor time constant Tr=Lr/Rr, pole pairs
- **Why use it:** Encapsulates `ωslip = iq/(Tr*id)` and `θe = ∫(p*ωm + ωslip)` — no manual integrator needed

### ACIM Control Reference
- **Purpose:** Computes optimal id*/iq* from torque reference
- **Inputs:** Tref (from speed PI), flux reference
- **Outputs:** id_ref, iq_ref
- **Why use it:** Handles magnetizing current (id_ref = FluxRotor/Lm) and torque current (iq_ref = f(Tref)) internally

### ACIM Feed Forward Control (Optional)
- **Purpose:** Voltage decoupling feed-forward for better dynamic response
- **Inputs:** id, iq, ωe, motor params
- **Outputs:** Vd_ff, Vq_ff (add to PI outputs)

### ACIM Torque Estimator (Optional)
- **Purpose:** Estimates electromagnetic torque from measured currents
- **Inputs:** id, iq, motor params
- **Output:** Torque estimate (for monitoring or torque-mode control)

### LUT based ACIM Control Reference (Nonlinear ACIM)
- **Purpose:** Lookup-table-based id*/iq* for efficiency optimization
- **Use when:** ACIM has significant saturation or loss-minimization is needed

## Block Configuration

### MCB Induction Motor
| Parameter | Value | Notes |
|---|---|---|
| sim_type | `'Discrete'` | |
| Ts | Sample time | |
| P | Pole pairs | |
| Zs | `[Rs, Lls]` | LEAKAGE inductance (not total) |
| Zr | `[Rr, Llr]` | LEAKAGE inductance (not total) |
| Lm | Magnetizing inductance | |
| mechanical | `[J, B, 0]` | |
| port_config | `'Torque'` | |

### Parameter Conversion (If datasheet gives reactances)
```matlab
% If datasheet gives Xs, Xr, Xm at rated frequency f_rated:
Ls = Xs / (2*pi*f_rated);  Lr = Xr / (2*pi*f_rated);  Lm = Xm / (2*pi*f_rated);
Lls = Ls - Lm;  Llr = Lr - Lm;  % MCB uses LEAKAGE only
```

## Speed Loop Gains
- Use `mcb.calcFOCGains` with reduced SpdLoopFactor (0.3–0.5) for ACIM
- If calcFOCGains doesn't support ACIM directly, see `gain-formulas.md` § ACIM fallback

## Voltage Path
```
PI_d/PI_q outputs (Vd, Vq) + FeedForward → InvPark(θe) → InvClarke → V2D → Avg-Value Inverter → IM
```

## Default Motor
- p=2, Rs=1.2Ω, Rr=0.8Ω, Ls=Lr=0.18H, Lm=0.14H
- V_rated=230V, f_rated=50Hz, Vdc=340V

## Things to Avoid
- DO NOT manually implement slip integration — use ACIM Slip Speed Estimator block
- DO NOT use encoder angle directly — ACIM needs slip-computed θe (even with speed sensor)
- DO NOT confuse Ls (total) with Lls (leakage) — IM block uses LEAKAGE
- DO NOT use PMSM MTPA/LUT Reference blocks for ACIM — different torque equation
- DO NOT forget Tr (rotor time constant) temperature dependence in production systems

---
**Cross-references:** `wiring-topologies-advanced.md` § ACIM, `gain-formulas.md` § ACIM Current Loop

----
Copyright 2026 The MathWorks, Inc.
----
