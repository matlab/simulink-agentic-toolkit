# MCB Section Router

Load `COMMON-mcb.md` first, then navigate to the SKILL.md section matching the user's intent.

## Intent → Section Mapping

| User Intent | SKILL.md Section | Also See |
|---|---|---|
| New to MCB / what is FOC / learning | Designing Motor Control | — |
| What pattern for my application? | Designing Motor Control | — |
| Which features are compatible? | Designing Motor Control | — |
| Recommend architecture for [application] | Designing Motor Control | — |
| Build a new model (full spec given) | Building Motor Controller | Configuring MCB Blocks → Tuning Motor FOC Gains |
| Build a new model (vague spec) | Designing Motor Control first | then Building Motor Controller |
| Add feature (FW, GainSched, Protection) to existing | Building Motor Controller | Configuring MCB Blocks (for new blocks) |
| Wire / connect blocks | Building Motor Controller | — |
| Configure block mask parameters | Configuring MCB Blocks | — |
| Set motor parameters on blocks | Configuring MCB Blocks | — |
| Update motor data on existing model | Configuring MCB Blocks | — |
| Compute PI gains | Tuning Motor FOC Gains | — |
| Tune speed / current loop | Tuning Motor FOC Gains | — |
| Design IIR filter | Tuning Motor FOC Gains | — |
| Set up PU system | Tuning Motor FOC Gains | — |
| Generate LUT data (MTPA, FW, flux) | Importing Nonlinear Motor Data | — |
| Process FEA data / Motor-CAD export | Importing Nonlinear Motor Data | — |
| Validate / plot flux maps | Importing Nonlinear Motor Data | — |
| LUT extrapolation / divergence issue | Importing Nonlinear Motor Data | — |
| Add sensorless (SMO, HFI, EEMF) | Estimating Sensorless Motor Position | — |
| Configure I/F startup | Estimating Sensorless Motor Position | — |
| Tune handoff logic | Estimating Sensorless Motor Position | — |
| HFI + SMO hybrid | Estimating Sensorless Motor Position | — |
| Convert plant to Simscape | Building Motor Plant | Tuning Motor FOC Gains (re-tune after) |
| Use FEM-parameterized PMSM | Building Motor Plant | — |
| Upgrade to higher-fidelity plant | Building Motor Plant | — |
| Populate Simscape plant with data | Building Motor Plant | — |
| Error / model broken / overcurrent | Diagnosing Motor Control | — |
| Oscillation / unstable | Diagnosing Motor Control | — |
| Zero torque / motor doesn't move | Diagnosing Motor Control | — |
| Model diverges / NaN | Diagnosing Motor Control | — |
| Validate model before sim | Diagnosing Motor Control | — |
| Estimate motor parameters (Rs, Ld, Lq, FluxPM) | Estimating Motor Parameters | Tuning Motor FOC Gains |
| Motor commissioning from datasheet | Estimating Motor Parameters | — |
| Measure J (inertia) or B (friction) | Estimating Motor Parameters | — |
| End-to-end linear motor commissioning | See `references/workflows/wf-linear-motor-commissioning.md` | — |
| End-to-end nonlinear commissioning (FEA) | See `references/workflows/wf-nonlinear-motor-commissioning.md` | — |
| Add sensorless observer to existing model | See `references/workflows/wf-sensorless-observer-integration.md` | — |
| Compute motor operating envelope | See `references/workflows/wf-motor-characterization.md` | — |
| Virtual dyno test for LUT generation | See `references/workflows/wf-virtual-dyno-validation.md` | — |
| Which MCB API to use? | See `references/common/api-and-tooling.md` | — |
| Which MCP tool for this task? | See `references/common/tool-routing.md` | — |
| Code generation / embedded deployment | See SKILL.md Embedded Deployment section | — |

## Full Build Sequence (new model from scratch)

```
Estimating Motor Parameters (if params unknown)
  → Designing Motor Control
    → Building Motor Controller
      → Configuring MCB Blocks
        → Tuning Motor FOC Gains (linear motors)
        → Importing Nonlinear Motor Data (nonlinear motors)
          → Estimating Sensorless Motor Position (if sensorless)
            → simulate
              → Diagnosing Motor Control (if errors)
```

## End-to-End Workflows

| Workflow | File | Scope |
|---|---|---|
| Linear commissioning | `references/workflows/wf-linear-motor-commissioning.md` | Datasheet → full FOC (15 steps) |
| Nonlinear commissioning | `references/workflows/wf-nonlinear-motor-commissioning.md` | FEA/dyno → gain-scheduled FOC |
| Sensorless integration | `references/workflows/wf-sensorless-observer-integration.md` | Adding SMO/HFI to existing FOC |
| Motor characterization | `references/workflows/wf-motor-characterization.md` | Computing envelope via MCB APIs |
| Virtual dyno validation | `references/workflows/wf-virtual-dyno-validation.md` | Simscape dyno → flux LUTs |

## Rules

1. **Always load COMMON-mcb.md** before any skill — it has conventions that apply everywhere.
2. **One primary skill per task** — if a task spans multiple, load sequentially.
3. **If user provides complete spec**, skip Designing Motor Control and start with Building Motor Controller.
4. **If user has errors**, go directly to Diagnosing Motor Control regardless of what they were doing.
5. **Shared references** (`references/` directory) can be loaded by any section on demand.

----
Copyright 2026 The MathWorks, Inc.
----
