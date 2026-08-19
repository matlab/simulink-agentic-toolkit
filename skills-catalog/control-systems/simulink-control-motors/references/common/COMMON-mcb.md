# COMMON-mcb — Shared Motor Control Conventions

> Load this file BEFORE any MCB sub-skill. These conventions apply to ALL motor control work.

---

## Tool Usage

| Task | Tool | Notes |
|------|------|-------|
| Add/connect/configure blocks | `model_edit` | Structural model changes |
| Inspect model structure | `model_read`, `model_overview` | Read-only |
| Query block parameters | `model_query_params` | Check current values |
| Compute gains, PU, LUTs | `evaluate_matlab_code` | Numerical computation |
| Simulate | `evaluate_matlab_code` | `sim(mdl)` |

See `references/common/tool-routing.md` for complete tool selection guidance.

---

## Critical Conventions

### PI Controller (1-Input Mode)
- Set ALL THREE: `ControllerParametersSource='internal'`, `ExternalReset='none'`, `InitialConditionSource='internal'`
- Ki×Ts convention: `'I'` parameter = Ki × Ts (set `UseKiTs='on'`)
- Omitting any of the three → block switches to 3/5-port mode, breaking wiring

### FOC Current Controller Block
- Port order: 1=[id*;iq*], 2=[Ia;Ib], 3=theta_e, 4=Vsat, 5=[Kp_d;KiTs_d;Kp_q;KiTs_q], 6=[Vmax;-Vmax;0;0], 7=Enable
- **Port 6 q-axis MUST be 0:** `[Vmax;-Vmax;0;0]` — non-zero q values cause silent motor drift
- Output is VOLTS — needs V2D conversion before AVI, OR connect directly to UnitDelay → PMSM

### Park / Inverse Park Transform
- Set `ThetaInput='Electrical position'`, `AngleInput='Radians'` for 3-input mode
- Port 3 = theta_e (radians, electrical)
- Omitting ThetaInput → silent 4-port mode (sin/cos inputs) → zero torque

### PMSM Plant Block
- Info bus (Out1): use `Bus Selector` with signal names, DONOT use `Selector` block
- Out2 (PhaseCurr) and Out3 (MtrSpd) are `single` — add DTC before double-precision blocks
- Algebraic loop: ALWAYS place Unit Delay on voltage path to plant

### Solver
- MCB discrete plants: `FixedStepDiscrete`, FixedStep = Ts
- Simscape plants: `ode14x` (implicit), FixedStep = Ts
- DONOT use continuous/variable-step solvers with MCB plants

### Control Reference Selection
| Motor | Block | Key Setting |
|---|---|---|
| IPMSM (lumped) | MTPA Control Reference | `VariantSelect='Interior PMSM'` |
| IPMSM (FEM/LUT) | LUT based PMSM Control Reference | Encodes MTPA+FW+MTPV, update `nonLinearityChoice` appropriately|
| SPMSM | MTPA Control Reference | `VariantSelect='Surface PMSM'` → id=0 |
| SynRM | LUT based SynRM Control Reference | update dqAxesDef appropriately |
| PMaSynRM | LUT based SynRM Control Reference | `motorType='PM-assisted synchronous reluctance motor'`, update dqAxesDef appropriately|
| ACIM | LUT based ACIM Control Reference | — |

---

## Block Type Resolution (model_edit)

Most MCB blocks resolve by **name** via SATK. Some require the full library path.

| Block | model_edit `type` | Resolves By Name? | Notes |
|---|---|---|---|
| Interior PMSM | — | **No** | Use `find_system('mcblib','SearchDepth',5,'Name','Interior PMSM')` |
| Surface Mount PMSM | — | **No** | Use `find_system('mcblib','SearchDepth',5,'Name','Surface Mount PMSM')` |
| IIR Filter | `"IIR Filter"` | Yes | Mask params: `VariantSelect`, `Filter_constant`, `Ts` |

**Fallback pattern** for blocks that fail name resolution:
```matlab
path = find_system('mcblib','SearchDepth',5,'Name','<BlockName>');
% Use path{1} with add_block in evaluate_matlab_code
```

---

## API Field Name Reference

### mcb.calcFOCGains output fields
```matlab
gains = mcb.calcFOCGains(pmsm, Ts, Ts_speed);
% Current loop: gains.Kp_id, gains.Ki_id, gains.Kp_i, gains.Ki_i
%   Kp_i / Ki_i = q-axis current gains (NOT "Kp_iq" / "Ki_iq")
%   Kp_id / Ki_id = d-axis current gains
% Speed loop: gains.Kp_speed, gains.Ki_speed
```
**Common mistake:** Accessing `gains.Kp_iq` — field does not exist. Use `gains.Kp_i`.

### pmsm struct — required fields for MCB APIs
| Field | Required By | Notes |
|---|---|---|
| `pmsm.N_base` | `mcb.getPUSystemParameters`, `mcb.computeSMOParameters` | Set `pmsm.N_base = pmsm.N_rated` if missing |
| `pmsm.p` | All MCB functions | Pole PAIRS (not poles) |
| `pmsm.Rs`, `Ld`, `Lq`, `FluxPM` | `mcb.calcFOCGains`, SMO config | Standard motor params |
| `pmsm.J`, `pmsm.B` | `mcb.calcFOCGains` (speed loop) | Inertia, friction |

### inverter struct — required fields
| Field | Required By | Notes |
|---|---|---|
| `inverter.V_dc` | Vmax computation, FW | DC bus voltage |
| `inverter.ISenseMax` | `mcb.getPUSystemParameters` | Current sensor max range (A). Set to `pmsm.I_rated * 2` if unknown |
| `inverter.R_board` | SMO accuracy (optional) | PCB trace resistance added to Rs |

### PMSM block mask parameters (actual names)
| Conceptual | Actual Mask Parameter | Format |
|---|---|---|
| Ld, Lq | `Ldq` | `'[pmsm.Ld, pmsm.Lq]'` (vector) |
| J, B | `mechanical` | `'[pmsm.J, pmsm.B]'` (vector) |
| Pole pairs | `P` | `'pmsm.p'` (scalar — pole PAIRS) |
| Stator resistance | `Rs` | `'pmsm.Rs'` (scalar) |
| Flux linkage | `FluxPM` | `'pmsm.FluxPM'` (scalar) |

### IIR Filter block mask parameters (actual names)
| Conceptual | Actual Mask Parameter | Valid Values |
|---|---|---|
| Filter type | `VariantSelect` | `'IIR'`, `'Moving Average'` |
| Time constant | `Filter_constant` | Scalar (e.g., `'0.01'`) |
| Sample time | `Ts` | `'Ts'` (workspace variable) |

---

## Guardrails

### Never
- Set PIConfig to `[0;0;0;0]` (clamps output to zero)
- Use `Selector` on PMSM Info bus (use `Bus Selector`)
- Connect vector [Ia;Ib] to Clarke (it expects 2 scalar ports)
- Feed radians to PWM Ref Gen theta port (expects per-unit [0,1))
- Skip Unit Delay on voltage path to plant
- Rebuild from scratch after 3 failures (see Diagnosing Motor Control section instead)

### Ask First
- Overriding `mcb.calcFOCGains` output with manual tuning
- Changing solver type from MCB defaults
- Using explicit solver with Simscape plants

---

## Shared References (catalog-level, any skill can load)

| File | Content |
|------|---------|
| `references/common/critical-constraints.md` | Rules 1-22: infrastructure constraints |
| `references/common/critical-constraints-domain.md` | Rules 23-36: domain-specific constraints |
| `references/common/api-and-tooling.md` | mcb.* API, cross-release compat, glossary |
| `references/common/tool-routing.md` | MCP tool selection: model_edit vs evaluate_matlab_code |

---

## Cross-Skill References

Skills can reference each other when the task spans multiple phases:

| From Section | Reference To | When |
|---|---|---|
| Designing Motor Control | Building Motor Controller | After design decision, proceed to build |
| Building Motor Controller | Configuring MCB Blocks | After wiring, configure mask params |
| Configuring MCB Blocks | Tuning FOC Gains | After config, compute gains |
| Any section | Diagnosing Motor Control | If errors occur during any phase |
| Building Motor Plant | Tuning FOC Gains | After plant swap, re-tune gains |

----
Copyright 2026 The MathWorks, Inc.
----
