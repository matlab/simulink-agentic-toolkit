# Solver Settings by Plant Type

## MCB Discrete Plant Blocks (Induction Motor, Interior PMSM, BLDC)

| Parameter | Value | Notes |
|---|---|---|
| Solver | `FixedStepDiscrete` | No continuous states |
| FixedStep | `Ts` (e.g., `5e-5`) | Matches control sample time |
| Plant block `sim_type` | `'Discrete'` | CRITICAL — must set explicitly |
| Plant block `Ts` | `'Ts'` | Must match solver step |
| BLDC `SimType` | `'Discrete'` | Different param name than PMSM |
| BLDC `BlockSampleTime` | `'Ts'` | BLDC requires this additional param |
| DefaultUnderspecifiedDataType | `'single'` | Matches embedded target |

## Simscape Plant (FEM-PMSM, Induction Machine Squirrel Cage)

| Parameter | Value | Notes |
|---|---|---|
| Solver | `ode14x` | CRITICAL — implicit solver required for DAE |
| FixedStep | `Ts/2` (e.g., `2.5e-5`) | Half control Ts for stability |
| Solver Configuration block | Required | One per Simscape network |
| Electrical Reference | Required | Ground for Simscape electrical |
| Mechanical Rotational Reference | Required | Ground for mechanical network |

### Why ode14x?
- Simscape creates DAE (differential-algebraic equations)
- Explicit solvers (ode4, ode1) cannot solve algebraic constraints
- `FixedStepDiscrete` has no continuous solver at all — fails immediately
- `ode14x` is implicit fixed-step (Newton iteration), handles stiff DAE

## Hybrid (MCB Controller + Simscape Plant)

| Parameter | Value | Notes |
|---|---|---|
| Solver | `ode14x` | Simscape plant dominates requirement |
| FixedStep | `Ts/2` | Half of controller Ts |
| Controller blocks | Set `SampleTime` explicitly | Don't rely on inherited |
| Rate Transition | Between continuous and discrete | If sample times differ |

## Model Configuration Checklist

```matlab
% Standard for all motor control models:
set_param(mdl, 'UnconnectedInputMsg', 'error');
set_param(mdl, 'UnconnectedOutputMsg', 'error');
set_param(mdl, 'UnconnectedLineMsg', 'error');

% For Simscape models additionally:
% - Add Solver Configuration block connected to Electrical Reference
% - Ensure all Simscape domains have a reference block
```

## Common Mistakes

| Mistake | Symptom | Fix |
|---|---|---|
| Using `ode4` with Simscape | "Cannot solve algebraic loop" | Switch to `ode14x` |
| `FixedStepDiscrete` with Simscape | Immediate error | Switch to `ode14x` |
| BLDC `SimType` left as `'Continuous'` | Solver error with FixedStepDiscrete | Set `SimType='Discrete'` |
| Missing `BlockSampleTime` on BLDC | Inherited sample time (-1), unpredictable | Set explicitly to `'Ts'` |
| FixedStep too large for Simscape | Divergence or inaccurate results | Use `Ts/2` or smaller |
| Missing Solver Configuration | "No solver configuration found" | Add and connect to reference |

----
Copyright 2026 The MathWorks, Inc.
----
