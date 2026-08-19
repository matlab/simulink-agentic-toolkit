---
name: simulink-control-motors
description: "Build motor control solutions using Motor Control Blockset for PMSM, induction motors, BLDC, and SynRM. Implement field oriented control, sensorless FOC, six-step control, speed control, current control, and torque control. Configure SVPWM, flux weakening, MTPA, MTPV, control of non-linear motors, inverter control, and motor parameter estimation. Compose motor drive models, tune gains, and generate embedded code."
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Simulink Control Motors — Motor Control Blockset Skill

Build motor control solutions using Motor Control Blockset (MCB): characterize motors, select control algorithms (FOC, DTC, six-step, V/f), compose Simulink models, tune gains, configure sensorless estimation, and generate code for embedded targets.

## When to Use

- User explicitly requests motor control assistance or asks to load this skill
- User works with Motor Control Blockset or motor drive design
- Building, tuning, debugging, or designing motor control systems
- User mentions PMSM, BLDC, induction motor, SynRM, FOC, sensorless, six-step, SVPWM, flux weakening, MTPA, MTPV

## When NOT to Use

- General Simulink modeling work that does not involve motor control
- Simple factual questions about motors (no model building needed)

## Dependencies

- **Required**: Motor Control Blockset, Simulink
- **Optional**: Embedded Coder, Simscape Electrical, Powertrain Blockset

---

## How This Skill Works

1. **Read `references/common/COMMON-mcb.md`** (shared conventions — always load first)
2. **Read `references/common/ROUTER-mcb.md`** for block routing and resolution rules
3. **Identify user intent** using the routing table below
4. **Follow the matching section** — each section points to detailed reference files
5. **Consult `references/configurations/`** for non-FOC architectures (DTC, six-step, V/f, BLDC, ACIM)
6. **Use `references/common/mcb-examples.md`** for official MCB example references

---

## Intent Routing

| User Intent | Section | Key Reference |
|---|---|---|
| New to MCB / learning | [Designing](#designing-motor-control) | `references/design/beginner-path.md` |
| What pattern for my application? | [Designing](#designing-motor-control) | `references/design/application-catalog.md` |
| Build a new model | [Building](#building-motor-controller) | `references/wiring/wiring-topologies.md` |
| Configure block parameters | [Configuring](#configuring-mcb-blocks) | `references/block-config/block-configurations.md` |
| Compute PI gains / tune | [Tuning](#tuning-motor-foc-gains) | `references/common/detailed-workflows.md` § Tuning |
| Generate LUT / FEA data | [Nonlinear Data](#importing-nonlinear-motor-data) | `references/common/detailed-workflows.md` § Importing |
| Add sensorless (SMO, HFI) | [Sensorless](#estimating-sensorless-motor-position) | `references/common/detailed-workflows.md` § Sensorless |
| Estimate Rs, Ld, Lq, J | [Parameters](#estimating-motor-parameters) | `references/common/detailed-workflows.md` § Estimating |
| Convert plant (MCB→Simscape) | [Plant](#building-motor-plant) | `references/common/detailed-workflows.md` § Plant |
| Model errors / doesn't move | [Diagnosing](#diagnosing-motor-control) | `references/common/detailed-workflows.md` § Diagnosing |
| End-to-end workflow | — | `references/workflows/` directory |

---

## Quick Decision

- **User describes an application** → [Designing](#designing-motor-control)
- **User says "build"** → [Building](#building-motor-controller)
- **User has an error** → [Diagnosing](#diagnosing-motor-control)
- **User wants to tune gains** → [Tuning](#tuning-motor-foc-gains)
- **User has FEA/LUT data** → [Nonlinear Data](#importing-nonlinear-motor-data)
- **User wants sensorless** → [Sensorless](#estimating-sensorless-motor-position)
- **User wants Simscape plant** → [Plant](#building-motor-plant)

---

# Designing Motor Control

*Recommends control strategies, selects patterns, evaluates feature compatibility.*

**Load:** `references/design/beginner-path.md` for enquiry protocol and learning paths.

1. Detect mode (Learn / Select / Validate / Enquiry) — see `references/design/beginner-path.md`
2. Search `references/design/application-catalog.md` by user's keywords → get Pattern + Features
3. Validate combination against `references/design/composition-rules-combining.md`
4. Review architecture details in `references/design/architecture-patterns.md`

**Critical rules:**
- NEVER recommend Pattern A for speed control (structural instability with MCB discrete plant)
- NEVER recommend Sensorless Six-Step + BLDC AVI together
- Pattern B is the DEFAULT for standard speed-controlled FOC

**Output:** basePattern + features + motorType + controlMode → carry to Building section.

---

# Building Motor Controller

*Constructs complete models using wiring topologies, composition rules, and model_edit.*

### Step 1: Check for a Dedicated Configuration

**BEFORE using generic wiring tables**, check `references/configurations/` for a matching file:

| Architecture | Configuration File |
|---|---|
| ACIM Indirect RFOC | `references/configurations/acim-indirect-rfoc.md` |
| ACIM Simscape RFOC | `references/configurations/acim-simscape-rfoc.md` |
| ACIM V/f Open-Loop | `references/configurations/acim-vf-openloop.md` |
| BLDC Hall Six-Step | `references/configurations/bldc-hall-sixstep.md` |
| BLDC Sensorless BEMF | `references/configurations/bldc-sensorless-bemf.md` |
| DTC (SVPWM) | `references/configurations/dtc-svpwm-pmsm.md` |
| Nonlinear Gain-Scheduled | `references/configurations/nonlinear-gain-scheduled.md` |
| Position Cascade FOC | `references/configurations/position-cascade-foc.md` |
| Overmodulation FOC | `references/configurations/overmodulation-foc.md` |
| HFI+SMO Hybrid | `references/configurations/hfi-smo-hybrid.md` |
| Dual Motor Sync | `references/configurations/dual-motor-sync.md` |
| Wind Turbine PMSG | `references/configurations/wind-turbine-pmsg.md` |
| ADRC Speed | `references/configurations/adrc-speed.md` |
| Backstepping Speed | `references/configurations/backstepping-speed.md` |
| Deadbeat Current | `references/configurations/deadbeat-current.md` |
| Sliding Mode Speed | `references/configurations/sliding-mode-speed.md` |

**If a config file exists:** follow it directly. **Otherwise:** proceed to Step 2.

### Step 2: Generic FOC Wiring

| Pattern | Document |
|---|---|
| A, A+FF, A+PWM, B, B-Simple, C | `references/wiring/wiring-topologies.md` |
| D, E, F, G, H | `references/wiring/wiring-topologies-advanced.md` |

### Step 3: Add Features

- Core (FW, SMO, GainSched, FF, Position, I/f): `references/wiring/composition-rules.md`
- Infrastructure (Protection, PWM, Multi-Rate): `references/wiring/composition-rules-infrastructure.md`
- Integration (Logging, Speed Profiles): `references/wiring/composition-rules-integration.md`

### Step 4: Set Structural Config

- PI: `ControllerParametersSource='internal'`, `ExternalReset='none'`, `InitialConditionSource='internal'`
- Park: `ThetaInput='Electrical position'`, `AngleInput='Radians'`
- Unit Delay on voltage path to plant

**Key rules:**
- Always check `references/configurations/` FIRST
- Use wiring-topologies.md block lists verbatim (type strings are validated)
- Composition-rules operations are STRUCTURAL (affect port count) — do during wiring
- All structural changes go through model_edit

---

# Configuring MCB Blocks

*Sets mask parameters for 30+ MCB block types using motor datasheet values.*

**Reference files:**
- `references/block-config/block-configurations.md` — control blocks
- `references/plants/block-configurations-plants.md` — plant/sensor blocks
- `references/block-config/block-configurations-utility.md` — utility blocks
- `references/block-config/block-configurations-bldc.md` — BLDC blocks

**Critical configurations (must get right):**

| Block | Critical Setting | Wrong Default |
|---|---|---|
| FOC CC | Port 6 VLimits = `[Vmax;-Vmax;0;0]` | q-axis non-zero → drift |
| SMO | `PositionUnit='Radians'` | Default 'Degrees' → 57× error |
| Interior PMSM | `P` = pole pairs (not 2×p) | Double frequency → zero torque |
| LUT Control Ref | Hidden params: MTPA, FW enable | Defaults leave FW disabled |

**Key rules:**
- Mask param names ≠ motor struct fields — always check reference table
- Use `model_edit configure` for setting parameters
- Single-precision plant outputs need DTC blocks before double-precision control

---

# Tuning Motor FOC Gains

*Computes PI gains, IIR filters, and PU normalization.*

**Full workflow:** `references/common/detailed-workflows.md` § Tuning Motor FOC Gains

**Quick summary:** Use `mcb.calcFOCGains(pmsm, inverter, Ts, Ts_speed)` for all categories except Category A (kt/J > 10,000) which needs manual Ki_speed override. MCB uses Ki×Ts convention — never pass raw Ki.

**Reference files:** `references/tuning/parameter-computation.md`, `references/shared/gain-formulas.md`

---

# Importing Nonlinear Motor Data

*Generates and validates LUTs from FEA/measurement data.*

**Full workflow:** `references/common/detailed-workflows.md` § Importing Nonlinear Motor Data

**Quick summary:** Use `mcb.generateMotorLUT(pmsm, inverter, purpose)` with correct purpose string. Validate trefVec symmetry and FluxDTable first row = 0.

**Reference files:** `references/nonlinear-data/pmsmlut-structure.md`

---

# Building Motor Plant

*Converts between MCB ideal plants, Simscape, and FEM-parameterized models.*

**Full workflow:** `references/common/detailed-workflows.md` § Building Motor Plant

**Quick summary:** Solver must change to ode14x for Simscape. Add angle adapter Gain(1/(2*pi)). Gains need re-tuning after plant swap.

**Reference files:** `references/plants/plant-model-converters.md`, `references/plants/block-configurations-plants.md`

---

# Estimating Motor Parameters

*Commissioning workflows for Rs, Ld, Lq, FluxPM, J, B.*

**Full workflow:** `references/common/detailed-workflows.md` § Estimating Motor Parameters

**Quick summary:** Estimate in order: Rs → Ld/Lq → FluxPM → J/B. Motor must be stationary for Rs and Ld/Lq. Feed results into `mcb.calcFOCGains`.

**Reference files:** `references/estimation/estimation-procedures.md`, `references/estimation/estimation-to-tuning.md`

---

# Estimating Sensorless Motor Position

*Configures I/F startup, SMO, HFI, EEMF observers, and handoff logic.*

**Full workflow:** `references/common/detailed-workflows.md` § Estimating Sensorless Motor Position

**Quick summary:** SPM → SMO + I/F. IPM → HFI + SMO hybrid. ACIM → Flux Observer + I/F. Always set SMO PositionUnit='Radians'.

**Reference files:** `references/sensorless/sensorless-blocks.md`, `references/sensorless/hfi-scheduler.md`

---

# Diagnosing Motor Control

*Diagnoses errors, oscillations, zero-torque using structured checklists.*

**Full workflow:** `references/common/detailed-workflows.md` § Diagnosing Motor Control

**Quick summary:** Identify symptom → run matching checklist → apply fix from auto-fix-recipes → validate. Never rebuild from scratch.

**Reference files:** `references/diagnostics/auto_fix/ERROR_PATTERNS.md`, `references/diagnostics/auto_fix/auto-fix-recipes.md`, `references/diagnostics/model-sanity-check.md`

---

Copyright 2026 The MathWorks, Inc.
