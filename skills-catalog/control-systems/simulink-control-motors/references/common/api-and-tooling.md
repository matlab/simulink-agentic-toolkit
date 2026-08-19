# API, Tooling & Cross-Release Reference

> MCB API functions, release compatibility, block resolution, and terminology.

---

## mcb.* Package API (R2025a+)

| Function | Purpose | Key Outputs |
|----------|---------|-------------|
| `mcb.calcFOCGains(pmsm, Ts, Ts_spd)` | PI gains for current + speed loops | Kp_id, Ki_id, Kp_i, Ki_i, Kp_speed, Ki_speed |
| `mcb.getPUSystemParameters(pmsm, inv)` | Per-unit base values. **Requires `inv.ISenseMax`** | V_base, I_base, N_base, T_base, P_base |
| `mcb.computeSMOParameters(pmsm, Ts, PU)` | SMO filter design. **Requires `pmsm.N_base`, `PU.N_base`, `PU.V_base`** | BackEmfObsGain, CurrentObsGain, CutoffFreq |
| `mcb.generateMotorLUT(motor, inv, purpose)` | MTPA/FW/MTPV lookup tables | wrpmVec, NmGrid, idTable, iqTable |
| `mcb.getPMSMParameters(name)` | Motor parameter struct from database | Full pmsm struct |
| `mcb.getInverterParameters(name)` | Inverter config from database | V_dc, I_trip, ISenseMax |
| `mcb.getMotorBaseSpeed(pmsm, inv)` | Base speed (RPM) | Scalar |
| `mcb.PMSMRatedTorque(pmsm)` | Rated torque (Nm) | Scalar |
| `mcb.PMSMCharacteristics(pmsm, inv)` | Drive characteristic plots. R2025a+ `driveCharacteristics` option for inverter-aware plots | Figures |
| `mcb.getPIControllerParameters(motor, inv, PU, T_pwm, Ts, Ts_spd)` | Legacy PI tuning (**deprecated** — use calcFOCGains) | Kp, Ki |
| `mcb.updatePMSMLdLqFluxPM(pmsm, ParamTableData, id, iq, goLUT)` | Update PMSM Ld/Lq/FluxPM from LUT at operating point | Updated pmsm struct |
| `mcb.getSISystemParameters(pmsm)` | SI system params (V_base=1, I_base=1) | WARNING: NOT suitable for SMO — use getPUSystem instead |
| `mcb.PMSMMaxSpeed(pmsm, inv)` | Maximum speed | RPM |
| `mcb.PMSMSpeeds(pmsm, inv)` | Speed milestones | 2×1 vector: `[base_speed; max_speed]` in RPM — NOT two separate outputs, NOT a struct |
| `mcb.calcPMSMVdVq(pmsm, ParamTableData, id, iq, goLUT, we)` | Steady-state Vd/Vq/Vs (6 inputs, 3 outputs) | [Vd, Vq, Vs] |
| `mcb.getACIMParameters(name)` | ACIM parameter struct | Full acim struct |
| `mcb.ACIMCharacteristics(acim, inv)` | ACIM drive plots | Figures |
| `mcb.getProcessorParameters(name)` | Target MCU config. **WARNING: F28379D baud rate reports 12e6, actual is 5e6** | PWM freq, ADC config |
| `mcb.getMotorControlAnalysis(pmsm, inv, PU, PI_params, Ts, Ts_spd)` | Frequency-domain analysis plots (6 args, void output) | Plots only (no return) |
| `mcb.updateInverterParameters(motor, inv, target)` | Update inverter params for HW target | Modified inv |

### Return Struct Fields

These are the actual fields returned by key MCB API functions. Use these exact names — do not guess from motor/inverter conventions.

**`mcb.calcFOCGains(pmsm, Ts, Ts_speed)` returns:**
| Field | Meaning |
|-------|---------|
| `Kp_id` | d-axis current proportional gain |
| `Ki_id` | d-axis current integral gain (raw — NOT multiplied by Ts) |
| `Ti_id` | d-axis time constant |
| `Kp_i` | q-axis current proportional gain (same as Kp_id for SPMSM) |
| `Ki_i` | q-axis current integral gain (raw — NOT multiplied by Ts) |
| `Ti_i` | q-axis time constant |
| `Kp_speed` | Speed loop proportional gain |
| `Ki_speed` | Speed loop integral gain (raw — NOT multiplied by Ts_speed) |
| `Ti_speed` | Speed loop time constant |

Key notes:
- There is no `Kp_iq` field — use `Kp_i` for q-axis.
- Ki values are **raw** — you must multiply by the appropriate Ts before passing to MCB PI blocks (which use `UseKiTs='on'` convention): `Ki_id * Ts` for current PI, `Ki_speed * Ts_speed` for speed PI.
- For FOC CC port 5 (PIGains): pass `[Kp_id; Ki_id*Ts; Kp_i; Ki_i*Ts]`.

**`mcb.getPMSMParameters(name)` returns (16 fields):**
| Field | Unit | Note |
|-------|------|------|
| `model` | — | Motor model name string |
| `sn` | — | Serial number / identifier |
| `p` | — | Pole pairs (integer) |
| `Rs` | Ohm | Stator resistance |
| `Ld` | H | d-axis inductance |
| `Lq` | H | q-axis inductance |
| `J` | kg·m² | Rotor inertia |
| `B` | N·m·s | Viscous friction |
| `Ke` | V/krpm | Back-EMF constant |
| `Kt` | N·m/A | Torque constant |
| `I_rated` | A | Rated current |
| `N_max` | RPM | Maximum speed |
| `PositionOffset` | rad | Encoder offset |
| `QEPSlits` | — | Encoder slits per revolution |
| `FluxPM` | Wb | PM flux linkage |
| `T_rated` | N·m | Rated torque |

Note: Field is `model` (not `MotorName`). All inductances in H, flux in Wb — never milli units.

**`mcb.getInverterParameters(name)` returns (18 fields):**
| Field | Unit | Note |
|-------|------|------|
| `model` | — | Inverter model name |
| `sn` | — | Serial number |
| `V_dc` | V | DC bus voltage |
| `I_trip` | A | Overcurrent trip threshold |
| `Rds_on` | Ohm | FET on-resistance |
| `Rshunt` | Ohm | Current shunt resistance |
| `CtSensAOffset` | V | Phase A sensor offset |
| `CtSensBOffset` | V | Phase B sensor offset |
| `CtSensCOffset` | V | Phase C sensor offset |
| `ADCGain` | — | ADC scaling factor |
| `EnableLogic` | — | Gate driver enable polarity |
| `invertingAmp` | — | Amplifier inversion flag |
| `ISenseVref` | V | Sensor reference voltage |
| `ISenseVoltPerAmp` | V/A | Sensor gain |
| `ISenseMax` | A | Current sense full-scale range |
| `R_board` | Ohm | Board trace resistance |
| `CtSensOffsetMax` | V | Sensor offset max |
| `CtSensOffsetMin` | V | Sensor offset min |

Note: There is **no `I_max` field** — use `ISenseMax` for current limiting, `I_trip` for protection threshold.

**`mcb.getSISystemParameters` signature (R2025a+):**
- Modern: `mcb.getSISystemParameters(pmsm)` — takes 1 arg only (NOT 2)
- Legacy: `mcb_SetSISystem(pmsm)` — same 1-arg signature
- Returns: `V_base`, `I_base`, `N_base`, `T_base`, `P_base` (with underscores). `Lbase`/`Zbase` do NOT exist.
- **WARNING:** Do NOT use SI system params as 3rd arg to `mcb.computeSMOParameters` — it has `V_base=1` which produces incorrect (tiny) SMO gains. Use `mcb.getPUSystemParameters` instead.

**`mcb.PMSMCharacteristics` return value:**
- Returns a struct with 19 fields (NOT just figures): `current`, `torque`, `mtpa`, `voltage`, `mtpv` (nested with `.id`, `.iq`), `idArray`, `iqArray`, `vdArray`, `vqArray`, `wArray`, `TArray`, `PArray`, `pmsm`, `inverter`, `FWCMethod`, `voltageEquation`, `speed_milestone` (2×1: [base; max] RPM), `id_milestone`, `iq_milestone`
- With both flag args = 0, suppresses plots (scripting mode)

**`mcb.generateMotorLUT(motor, inv, purpose)` — all valid `purpose` strings:**

| Purpose | Description | Key Outputs |
|---------|-------------|-------------|
| `'idiqlutsinit'` | Initialize id/iq LUT computation | Setup struct |
| `'idiqluts'` | Compute MTPA/FW id-iq LUTs (most common) | idTable[nT×nSpd], iqTable, wrpmVec, trefVec |
| `'idiqlutstw'` | id-iq LUTs indexed by torque × speed | Same, different indexing |
| `'idiqlutswt'` | id-iq LUTs indexed by speed × torque | Transposed |
| `'idiq3dlutsinit'` | Initialize 3D LUT computation | Setup struct |
| `'idiq3dluts'` | 3D LUTs (id, iq, Vdc) | Adds voltage dimension |
| `'idiq3dlutstwv'` | 3D indexed by torque × speed × voltage | — |
| `'idiq3dlutswtv'` | 3D indexed by speed × torque × voltage | — |
| `'ifuncflux'` | id/iq from flux linkages (for PTBS data) | FluxDVec, FluxQVec, idTable, iqTable |
| `'idealfluxtables'` | Ideal flux tables from motor params | LdTable, LqTable, FluxPMTable |
| `'star2star'` | Convert star→star winding config | Transformed tables |
| `'star2delta'` | Convert star→delta winding config | Transformed tables |
| `'jmagfluxa2fluxdq'` | JMAG flux-A to flux-dq | Converted LUTs |
| `'jmagfluxfiles2fluxdq'` | JMAG files to flux-dq | Converted LUTs |
| `'jmagindfiles2inddq'` | JMAG inductance files to ind-dq | Converted LUTs |
| `'tforw'` | Torque forward map | Torque table |
| `'tnegforw'` | Negative torque forward map | Torque table |
| `'eesmirefluts'` | EESM (wound rotor) reference LUTs | Id/Iq/If tables |

**Common mode `'idiqluts'` output struct fields:**
- `idVec` [nId×1], `iqVec` [1×nIq], `wrpmVec` [1×nSpd], `trefVec` [1×nT]
- `idTable` [nT×nSpd], `iqTable` [nT×nSpd] — torque × speed indexed
- `LdTable`, `LqTable`, `FluxDTable`, `FluxQTable`, `FluxPMTable` — saturation data
- `method`, `FWCMethod`, `idqformat`

**CRITICAL:** Mode `'ifunccurrent'` does NOT exist. Use `'ifuncflux'` for flux-based PTBS data.

---

**Pre-R2025a:** The entire `mcb.*` package does not exist. ALL functions above are unavailable. Use legacy `mcb_*` functions (see Cross-Release API Migration below) or manual computation (`parameter-computation.md`).

---

## Cross-Release Block Resolution

### Ground Truth: Browse mcblib

**`mcblib` is the single source of truth for block availability in every MATLAB release.** The agent should browse `mcblib` via `model_edit` or `find_system('mcblib', ...)` to discover blocks — do NOT rely on hardcoded static lists. If a block exists in the user's installed `mcblib`, it is available; if not, it isn't.

### Finding MCB Blocks (Release-Proof Method)

With SATK `model_edit`, use the block's display name directly — the tool resolves the library path:
```json
{"op": "add_block", "type": "Sliding Mode Observer", "name": "SMO", "ref": "smo"}
```

Verify the full path for ambiguous names (SM vs IM).


**Legacy fallback** (if model_edit can't resolve): use `evaluate_matlab_code` with find_system:
```matlab
blks = find_system('mcblib', 'SearchDepth', 5, 'Name', 'PI Controller');
smBlk = blks(contains(blks, 'Synchronous'));
% Then use full path in model_edit: {"type": "<full_path_from_smBlk{1}>"}
```

### Disambiguating SM vs IM Blocks

15 blocks share names between Synchronous Machine and Induction Machine categories:

**Duplicate-name blocks:** Average-Value Inverter, Dead-Time Compensator, FOC Default Controller Gains, Field Oriented Control Autotuner, Field-Oriented Current Controller, Flux Observer, Mechanical Parameter Estimator, Mechanical to Electrical Position, PI Controller, Parameter Estimation Configurator, Position Compensation, Quadrature Decoder, Resolver Decoder, Rs Estimator, Speed Measurement, VbyF Controller

### Block Name Change (Only One, Ever)

| Old Name (R2020b–R2024a) | Current Name (R2024b+) |
|--------------------------|----------------------|
| Sine-Cosine Lookup | SinCos Embedded Optimized |

---

## Cross-Release API Migration

### mcb.* Package (R2025a+) vs Legacy mcb_* Functions

The `mcb.*` package was introduced in **R2025a**. Prior releases only have `mcb_*` legacy functions.

| Modern API (R2025a+) | Legacy Function (R2020b–R2024b) | Signature Differences |
|---|---|---|
| `mcb.getPMSMParameters(name)` | `mcb_SetPMSMMotorParameters(name)` | Same signature |
| `mcb.getInverterParameters(name)` | `mcb_SetInverterParameters(name)` | Same signature |
| `mcb.getProcessorParameters(name)` | `mcb_SetProcessorDetails(procName, targetName)` | Legacy takes 2 args |
| `mcb.getPUSystemParameters(pmsm, inv)` | `mcb_SetPUSystem(pmsm, inv)` | Same signature |
| `mcb.getSISystemParameters(pmsm)` | `mcb_SetSISystem(pmsm)` | Both take 1 arg (pmsm only). Returns V_base=1 |
| `mcb.getMotorBaseSpeed(pmsm, inv)` | `mcb_getBaseSpeed(pmsm, inv)` | Legacy has varargin (nargin=-3) |
| `mcb.calcFOCGains(motor, Ts, Ts_speed, NV...)` | `mcb_SetControllerParameters(motor, inverter, PU_System, T_pwm, Ts, Ts_speed, varargin)` | Legacy: 6 required + varargin, nargout=1 |
| `mcb.computeSMOParameters(pmsm, Ts, PU)` | `mcb_ComputeSMOParameters(pmsm, Ts, PU)` | Same signature |
| `mcb.getPIControllerParameters(pmsm, inv, Ts)` | `mcb_SetControllerParameters(...)` | Legacy has complex signature |
| `mcb.getACIMParameters(name)` | `mcb_SetACIMMotorParameters(name)` | Same signature |
| `mcb.PMSMCharacteristics(pmsm)` | `mcb_getCharacteristics(pmsm)` | Same signature |
| `mcb.ACIMCharacteristics(acim)` | `mcb_getCharacteristicsAcim(acim)` | Same signature |
| `mcb.getMotorControlAnalysis(pmsm, inv)` | `mcb_getControlAnalysis(pmsm, inverter, PU, Ts, Ts_speed, target)` | Legacy: 6 args, **nargout=0** (side-effect only, prints to console) |
| `mcb.updateInverterParameters(motor, inv, target)` | `mcb_updateInverterParameters(inv, NV...)` | Modern takes 3 positional args (motor, inverter, target). **Note:** Legacy introduced R2024a (not R2020b like others) |

**Standalone utilities** (no mcb.* equivalent):
- `mcb_vectorplot(Vabc, Vdq, theta)` — Plots space vectors in stationary and rotating reference frames
- `mcb_helpview(topic)` — Opens MCB documentation page

### mcb.calcFOCGains Signature Evolution

| Release | Signature | Notes |
|---|---|---|
| R2025a | `[PI, OLTF, CLTF] = mcb.calcFOCGains(motor, Ts, Ts_speed, NV...)` | inputParser. NV: DCurrLoopFactor, QCurrLoopFactor, SpdLoopFactor, SpdLPFltCoeff, CL/SL path delays, Base |
| R2025+ | Same as R2025a | No changes |
| R2026a | Same outputs, added `PositionObserver` NV param | inputParser still |
| R2025+ | Switched to `arguments` block; NV renamed: BandwidthCurrent, BandwidthSpeed, etc. | Breaking NV name change |

---

## Block Feature Changes Across Releases

Only blocks with **meaningful mask/port/behavior changes** are listed. For blocks not listed, behavior is stable since introduction.

### Field-Oriented Current Controller (FOC CC)

| Release | Change |
|---|---|
| R2020b | Initial: 5 inputs (IdqRef, IabMeas, theta_e, Vsat, Kp_KiTs), 2 outputs |
| R2022a | Added port 6 PIConfig[4] and port 7 Enable[1] → now 7in, 2out |
| R2024a | Added `SaturationMethod` mask param (circular/independent). Mask: AngleUnit, NumberOfLUTPoints, AxisAlignment, SaturationMethod, PWMMethod |
| R2024b | Same mask params confirmed stable |

### MTPA Control Reference

| Release | Change |
|---|---|
| R2020b | Initial: Interior PMSM and Surface PMSM variants |
| R2022a | Added variable voltage support via `Vdc_input_select` param |
| R2024a | Added `ilimit` param (default 7.1A — **must override!**). [2,2] ports. Full mask: VariantSelect, polePairs, Rs, Ld, Lq, FluxPM, ilimit, Vdc_input_select, V_dc, Units, N_base, I_base, T_base, V_base, N_base_disp, MTPAiterator, iterCount |

### Park Transform / Inverse Park Transform

| Release | Change |
|---|---|
| R2020b | 3 inputs (Ia/Ib/theta), 2 outputs. Name: "Park Transform" / "Inverse Park Transform" |
| R2024a | [4,2] ports. Mask: PhaseInput, AxisAlignment, ThetaInput, AngleInput, N_points. Set `ThetaInput=Electrical position` + `AngleInput=Radians` for 3-input mode |

### Clarke Transform

| Release | Change |
|---|---|
| R2020b | 2 scalar inputs (Ia, Ib), 2 outputs (Ialpha, Ibeta) |

### Sliding Mode Observer (SMO)

| Release | Change |
|---|---|
| R2022a | Initial: 5in (Va, Vb, Ia, Ib, Reset), 2out (theta_e, wm). Outputs are **single** precision |
| R2025a | Added `PerUnitSpeed` param (**MUST equal MaxApplicationSpeed**) |


### PMSM FeedForward Control

| Release | Change |
|---|---|
| R2022a | Initial: Linear model with lumped parameters |
| R2023a | Added Non-linear model variant |

### PWM Reference Generator

| Release | Change |
|---|---|
| R2020b | Initial: theta input is **per-unit [0,1)** NOT radians when input units are set to Per-Unit|

### Sensorless Six-Step Commutation

| Release | Change |
|---|---|
| R2025a | Initial release. 5in (StartDir, Vabc, Vdc, Duty, Enable), 4out (Duty6, wm, Info, ComStatus). Does NOT exist before R2025a |

### Overmodulation (Standalone)

| Release | Change |
|---|---|
| R2025+ | Initial release as standalone block. Prior: OVM only available internally within PWM Reference Generator (`LimitModulation` mask param). Params: VoltageInputType (alpha-beta / mag+pos), PositionUnit |

---

## Major Library Reorganizations

### R2024b: Math Transform Library Split
- SinCos renamed from "Sine-Cosine Lookup" to "SinCos Embedded Optimized"

### mcblib Browser Hierarchy Restructure
- Few blocks moved from shared libraries to dedicated single-purpose libraries, but the ground truth is mcblib. Get all the blocks from this library.


### Impact on Agent Workflow

- **Building new models**: Use `model_edit` with display names → SATK resolves the correct library path for the installed release. No impact from reorganizations.
- **Opening old models**: If `add_block` fails with a path error, the block may have moved. Use `find_system('mcblib', 'SearchDepth', 5, 'Name', '<BlockName>')` to find current path.
- **Checking feature availability**: If a mask param doesn't exist, the user may be on an older release (e.g., `SaturationMethod` on FOC CC requires R2024a+).
- **Future releases**: If a release is newer than this mapping, treat as latest known. Always verify with live `mcblib` browsing.

---

## Blocks Introduced After R2020b (Availability Gotchas)

Blocks that **do NOT exist** before a certain release — agent must check before attempting to use:

| Block | First Available | Notes |
|---|---|---|---|
| Sensorless Six-Step Commutation | R2025a | Block doesn't exist pre-R2025a |
| LUT based ACIM Control Reference | R2026a |  Block doesn't exist pre-R2026a |
| PWM Phase Shift | R2026a | Block doesn't exist pre-R2026a |
| Phase Current Extractor | R2026a | Block doesn't exist pre-R2026a |
| SOGI PLL | R2026a |  — |
| Overmodulation (standalone) | R2025+ | Prior: only internal to PWM Ref Gen |
| Quadrature Oscillator | R2024a (hidden) |  NOT in mcblib browser until R2026a |
| SpeedFeedforward | R2024a (hidden) | NOT in mcblib browser until R2026a |
| Extended EMF Observer | R2024a | [5,2] ports |
| Pulsating High Freq Observer | R2024a [4,4] ports. **Requires single-precision inputs** |
| I-F Controller | R2022b | — |
| BLDC (motor) | R2022b | Info bus has **8 fields** (vs PMSM 12-field bus) |
| BLDC Average-Value Inverter | R2022b | — |
| Dead-Time Compensator | R2023b | Was in `mcblib/Signal Management/` through R2025a |

### Host Serial Blocks (Library Shuffle)

**Agent guidance:** Always use `find_system('mcblib', 'Name', 'Host Serial Receive')` to resolve the correct path for the installed release.

### Park/Inverse Park Display Name Gotcha

In R2024b+, Park Transform is internally named `"Clarke to Park\nAngle Transform"` (with a literal newline `\n` in the display name). Similarly, Inverse Park is `"Park to Clarke\nAngle Transform"`. When using `model_edit`, use the browser name `"Park Transform"` / `"Inverse Park Transform"` (SATK resolves these), NOT the internal display name.

---

## Block Type Names for model_edit

Use display names with `model_edit` — SATK resolves the correct library path for the installed MATLAB version. Do NOT hardcode library paths (they change between releases).

| Block | `type` for model_edit | Ports | Notes |
|-------|----------------------|-------|-------|
| PI Controller (MCB) | `"mcbcontrolslib/PI Controller"` | [5,1] | Prefix needed — plain name gives slpidlib PID |
| Clarke Transform | `"Clarke Transform"` | [2,2] | 2 SCALAR inputs (Ia, Ib), not vector |
| Park Transform | `"Park Transform"` | [3,2] or [4,2] | Set ThetaInput=Electrical position + AngleInput=Radians for 3-input |
| Inverse Park | `"Inverse Park Transform"` | [3,2] or [4,2] | Same mask settings as Park |
| Inverse Clarke | `"Inverse Clarke Transform"` | [2,3] | 2in (Vα,Vβ) → 3out (Va,Vb,Vc) |
| Interior PMSM | `"Interior PMSM"` | [2,3] | In: TL, PhaseVolt[3]. Out: Info(12-bus), PhaseCurr[3], MtrSpd |
| Surface PMSM | `"Surface Mount PMSM"` | [2,3] | Same port structure as Interior PMSM |
| FOC CC | `"mcbfoclib/Field-Oriented Current Controller"` | [7,2] | Full path required — short name does NOT resolve |

**Note:** Paths may vary by release. Use `find_system` for reliable resolution.

### Plant Block Info Bus Differences

| Motor Block | Info Bus Fields | Key Difference |
|---|---|---|
| Interior PMSM / Surface Mount PMSM | 12 fields | Full electrical + mechanical state |
| BLDC | 8 fields | Fewer fields — different bus selector indexing |

---

## Glossary

### Motor Types
| Term | Full Name | Key Property |
|------|-----------|-------------|
| IPMSM | Interior PMSM | Ld != Lq, reluctance torque |
| SPMSM | Surface-mounted PMSM | Ld = Lq, id=0 optimal |
| ACIM | AC Induction Motor | Asynchronous, slip-based |
| BLDC | Brushless DC Motor | Trapezoidal back-EMF |
| SynRM | Synchronous Reluctance | No magnets, Ld >> Lq (default, can be changed)|
| PMaSynRM | PM_assisted Synchronous Reluctance | has magnets, Ld >> Lq (default, can be changed)|
| EESM | Electrically Excited SM | Wound field winding |

### Control Methods
| Term | Full Name |
|------|-----------|
| FOC | Field-Oriented Control |
| DTC | Direct Torque Control |
| V/F | Voltage-per-Frequency |
| RFOC | Rotor FOC (ACIM) |
| MTPA | Maximum Torque Per Ampere |
| MTPV | Maximum Torque Per Volt |
| FW/FWC | Field Weakening (Control) |
| MPC | Model Predictive Control |
| ADRC | Active Disturbance Rejection Control |

### Reference Frames
| Term | Description |
|------|-------------|
| d-axis | Direct axis — aligned with rotor flux |
| q-axis | Quadrature axis — 90° ahead, torque-producing |
| αβ | Stationary orthogonal (Clarke output) |
| abc | Three-phase stator frame |
| θ_e | Electrical angle = p × θ_mech |

### Key Parameters
| Symbol | Unit | Description |
|--------|------|-------------|
| Rs | Ω | Stator resistance |
| Ld, Lq | H | d/q-axis inductance |
| FluxPM (λ_pm) | Wb | PM flux linkage |
| p | — | Pole pairs |
| J | kg·m² | Rotor inertia |
| B (Bv) | N·m·s/rad | Viscous friction |
| Ts | s | Sample period |
| we (ω_e) | rad/s | Electrical speed |

### Sensorless & Estimation
| Term | Description |
|------|-------------|
| SMO | Sliding Mode Observer — back-EMF estimation |
| HFI | High-Frequency Injection — saliency at low speed |
| PLL | Phase-Locked Loop — angle extraction |
| IPD | Initial Position Detection — standstill |
| I-F | Current-Frequency open-loop startup |
| MRAS | Model Reference Adaptive System (ACIM) |

### PWM & Modulation
| Term | Description |
|------|-------------|
| SVM | Space Vector Modulation |
| SPWM | Sinusoidal PWM |
| DPWM | Discontinuous PWM (reduced switching) |
| OVM | Overmodulation (MI > 0.907) |
| MI | Modulation Index [0, 1] |

### MCB Conventions
| Convention | Explanation |
|-----------|-------------|
| Ki*Ts | PI blocks expect integral gain × sample time |
| rad/s(mechanical) for LUT speed input | MCB LUT Control Ref speed input in SI mode |
| [Ia; Ib] for FOC CC | 2-phase current vector, not 3 |
| θ_e in radians [0, 2π) | Throughout MCB |
| MaxApplicationSpeed in RPM | Always RPM regardless of SpeedUnit setting |

### Speed Unit Reference (Per Block)
| Block | Input/Output | Unit | Notes |
|-------|-------------|------|-------|
| Interior PMSM Out/3 | Output | rad/s (mechanical) | Single precision |
| Interior PMSM Bus `MtrSpd` | Output | rad/s (mechanical) | Same as Out/3 |
| MTPA Control Reference In/2 | Input | rad/s (mechanical) if units are 'SI Units' |input units are RPM/BaseSPEED_RPM if units are Per-Unit(PU) |
| LUT Control Reference In/2 | Input | rad/s (mechanical) if units are 'SI Units' | input units are RPM/BaseSPEED_RPM if units are Per-Unit(PU) |
| SMO Out/2 | Output | Depends on `SpeedUnit` | 'Radians/Sec', 'RPM', or 'Per unit' |
| SMO `MaxApplicationSpeed` | Parameter | RPM | Always RPM regardless of SpeedUnit |
| Speed Measurement | Output | Configurable | Set via mask |
| IIR Filter (speed path) | Pass-through | Same as input | No unit conversion |
| Speed PI `SampleTime` | — | Must use Ts_speed | NOT model Ts |

### Data Format Terms
| Format | Dimensions | Used By |
|--------|-----------|---------|
| 'tw' | [nTorque × nSpeed] | MCB LUT Control Ref (default) |
| 'twv' | [nTorque × nSpeed × nVdc] | MCB 3D LUTs |
| 'wtv' | [nSpeed × nTorque × nVdc] | Simscape PMSM Current Ref Gen |

### LUT Data Orientation
| Field | Size | Row Axis | Column Axis |
|-------|------|----------|-------------|
| `idTable` | [nTorque × nSpeed] | `trefVec` (Nm) | `wrpmVec` (RPM) |
| `iqTable` | [nTorque × nSpeed] | `trefVec` (Nm) | `wrpmVec` (RPM) |
| `LdTable` (GainSched) | [nId × nIq] | `idVec` (A) | `iqVec` (A) |
| `LqTable` (GainSched) | [nId × nIq] | `idVec` (A) | `iqVec` (A) |

**Example:** For `trefVec` length 21 and `wrpmVec` length 64 → `idTable` is [21 × 64].

---

## Control Reference Selection Rule

```
Motor Type?
├── IPMSM (Ld != Lq, has magnets)
│   ├── Lumped params only → MTPA Control Reference (VariantSelect='Interior PMSM')
│   └── Has FEM/LUT data   → LUT based PMSM Control Reference
├── SPMSM (Ld = Lq, has magnets)
│   └── Any → MTPA Control Reference (VariantSelect='Surface PMSM') → id*=0
├── SynRM (Ld != Lq, NO magnets)
│   └── Any → LUT based SynRM Control Reference
├── PMaSynRM (Ld != Lq, has magnets)
│   └── Any → LUT based SynRM Control Reference, select appropriate motor type from the mask.
├── ACIM (induction motor)
│   └── Any → LUT based ACIM Control Reference
└── EESM (wound field)
    └── Custom (no standard MCB block)
```

---

## API-to-Block Workflow (Complete)

Use the functions mcb.getPMSMParameters and mcb.getInverterParameters along with mcb.getPUSystemParameters to create default variables. Then compute PI gains using mcb.calcFOCGains. Set Vmax as PU_System.V_baseand IIR_coeff as 2*pi*50*Ts / (1 + 2*pi*50*Ts). Then use these values onto the block masks. 


----
Copyright 2026 The MathWorks, Inc.
----
