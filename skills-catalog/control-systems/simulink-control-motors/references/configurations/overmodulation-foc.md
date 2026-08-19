# Configuration: Overmodulation FOC

**Motor:** IPMSM (MCB Interior PMSM)
**Control:** Standard FOC + MCB Overmodulation block for deep field-weakening
**Use case:** Operation above base speed where modulation index exceeds linear SVM region

## Architecture
```
Speed_Ref (1.3x base) → Speed_PI → Tref → MTPA(FW internal) → id*/iq*
id*/iq* - id/iq → PI_d/PI_q → InvPark → [Vα;Vβ] → Mux[2] → OVM → Demux[2]
→ InvClarke → Mux[3] → UnitDelay → PMSM
```

## Overmodulation Block (`mcbovmlib/Overmodulation`)
| Parameter | Value | Notes |
|---|---|---|
| VoltageInputType | `'Alpha and beta'` | Input is Valphabeta[2] |
| Ports | In1=Vab[2], In2=Vdc | Out1=VabLim[2], Out2=Info |

- Separate library: `mcbovmlib` (not in main mcblib browser)
- OVM Mode I: 1.15 < MI ≤ 1.27 (clips hexagon boundary)
- OVM Mode II: 1.27 < MI ≤ 1.41 (holds at hexagon vertices → six-step)
- Internal fixed-point (sfix16_En17) — works with double/single signals
- Info bus output terminated (provides OVM mode status)
- Requires R2025+ or later

## Field Weakening
- Handled internally by MTPA block (receives speed at port 2)
- MTPA adjusts id*/iq* based on voltage limit at current speed
- N_base parameter = base_speed_rpm
- NO external FW PI loop needed — MTPA's internal FW is sufficient
- WARNING: External voltage-feedback FW loops cause startup instability

## Voltage Path (Direct — no Average-Value Inverter)
```
PI → InvPark(Vd,Vq,θe) → Mux[2] → OVM(Vab,Vdc) → Demux[2] → InvClarke → Mux[3] → UnitDelay → PMSM/2
```

## Speed Feedback
- PMSM/3 (MtrSpd) → IIR filter (50 Hz) → speed loop
- WARNING: MCB Speed Measurement block has overflow issues with high-pole-pair motors at high electrical frequency
- Angle: BusSel(MtrElcPos) from PMSM Info bus

## Default Motor
- IPMSM: p=4, Rs=0.36, Ld=3.5mH, Lq=8mH, FluxPM=0.1714
- High-speed: p=2, Rs=0.1, Ld=0.5mH, Lq=1mH, FluxPM=0.05, N_rated=12000
- Speed ref = 1.3x base speed (forces FW/OVM operation)

## Things to Avoid
- DO NOT add external FW PI loop with MTPA — causes startup instability (PI saturation at low speed)
- DO NOT use Speed Measurement block for high-pole motors — fixed-point overflow
- DO NOT expect tight tracking in OVM region — FW introduces steady-state ripple (relax to 5%)

## Pass Criteria
- Steady-state error < 5% (relaxed for FW region)
- Oscillation < 10%
- Motor reaches above-base-speed target

---
**Cross-references:** `wf-linear-motor-commissioning.md` Step 12, `wiring-topologies.md` § Pattern B

---
Copyright 2026 The MathWorks, Inc.
