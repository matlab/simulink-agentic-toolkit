# Model Sanity Check

> Post-build verification for ALL motor control models (PMSM, BLDC, ACIM, sensorless).
> Run ONCE after model is fully built (blocks placed, connected, workspace populated) — BEFORE first simulation.

---

## When to Run

| Trigger | Action |
|---------|--------|
| **Model fully built** (all blocks + connections + workspace) | Run ALL checks (Parts 1-3) |
| **Major structural change** (new loop, replaced plant, added observer) | Re-run relevant Part |
| **Minor parameter tweak** (gain adjustment, speed ref change) | Do NOT re-run — only if simulation fails |
| **Post-simulation failure** (oscillation, zero torque, crash) | Use §16 Zero-Torque or relevant diagnostic |

---

## Check Files

| Part | File | Covers | Checks |
|------|------|--------|--------|
| 1 | [`model-sanity-check-infrastructure.md`](model-sanity-check-infrastructure.md) | Solver, plant config, transforms, data types, algebraic loops | §1-§6 |
| 2 | [`model-sanity-check-control.md`](model-sanity-check-control.md) | PI controllers, speed loop physics, inverter/modulation path | §7-§8 |
| 3 | [`model-sanity-check-domain.md`](model-sanity-check-domain.md) | Sensorless, ACIM, angle, connections, workspace, high-speed, current limits, diagnostics | §9-§18 |

---

## Severity Levels

1. **STRICT** — MUST pass. Fix before simulating. Violations cause errors or silent wrong results.
2. **ADVISORY** — Use judgment. Flag if suspicious, but don't block simulation.

---

## Execution Pattern

```matlab
%% Model Sanity Check — execute after build, before sim
mdl = 'YourModelName';
mdlWks = get_param(mdl, 'ModelWorkspace');
errors = {}; warnings = {};

% Detect model type and features
is_acim = ~isempty(find_system(mdl,'SearchDepth',1,'Name','ACIM'));
is_bldc = ~isempty(find_system(mdl,'SearchDepth',1,'Name','BLDC'));
is_synrm = false;  % Set true if pmsm.FluxPM < 1e-4 and Ld ~= Lq
has_smo = ~isempty(find_system(mdl,'SearchDepth',2,'Name','*SMO*'));
has_hfi = ~isempty(find_system(mdl,'SearchDepth',2,'Name','*HFI*'));
has_avi = ~isempty(find_system(mdl,'SearchDepth',1,'Name','*AVI*'));
has_fw = ~isempty(find_system(mdl,'SearchDepth',2,'Name','*FW*')) || ...
         ~isempty(find_system(mdl,'SearchDepth',2,'Name','*MTPA*'));
has_lut_ctrl_ref = ~isempty(find_system(mdl,'SearchDepth',2,'Name','*LUT*'));
has_encoder = ~isempty(find_system(mdl,'SearchDepth',1,'Name','*MechToElec*')) || ...
              contains(get_param([mdl '/BusSel'],'OutputSignals'), 'MtrElcPos');

% Run Parts 1-3 checks...
% Report summary
fprintf('\n=== SANITY CHECK ===\n');
fprintf('STRICT:   %d passed, %d FAILED\n', n_pass, numel(errors));
fprintf('ADVISORY: %d notes\n', numel(warnings));
```

---

## Quick Reference: Check Priority by Failure Impact

| Impact | Checks | Symptom if Skipped |
|--------|--------|-------------------|
| **Model won't run** | 1.1, 1.2, 2.4, 5.3, 6.1, 12.2, 12.4 | Solver error, algebraic loop, dimension mismatch |
| **Silent wrong results** | 2.1, 3.1, 3.2, 4.2, 4.3, 5.1, 8.1, 8.2, 9.1, 9.2, 10.1, 10.6, 11.1, 17.1 | Motor runs but wrong torque/speed/angle |
| **Oscillation/instability** | 4.4, 4.5, 4.8, 7.1, 7.2, 7.3, 7.6, 9.5, **18.1** | Speed oscillates, PI saturates, limit cycles. **18.1 is STRICT — Pattern A always fails for speed control** |
| **Zero torque / no motion** | 2.1 (P=0), 10.1 (ACIM id=0), 16.1, 17.1 | Motor energized but not rotating |
| **Hardware damage risk** | 7.4 (voltage), 15.1 (demag), 15.2 (overcurrent) | Demagnetization, inverter trip |
| **Degraded performance** | 7.5, 7.7, 13.4, 14.1, 17.4 | Slow response, noise, suboptimal but functional |

---

> Source rules: `critical-constraints.md`, `critical-constraints-domain.md`, `block-configurations*.md`,
> `validation-checks.md`, `composition-rules*.md`, `parameter-computation-motors.md`, `wiring-topologies-advanced.md`

----
Copyright 2026 The MathWorks, Inc.
----
