
# Model Validation Checks

> Pre-simulation validation functions and post-simulation steady-state checks.
> For error diagnosis and auto-fix scripts see `auto_fix/ERROR_PATTERNS.md`.
> For recovery from partial builds see `recovery-protocol.md`.

---

## Pre-Simulation Validation Functions

### 1. Solver Configuration

```matlab
function assert_solver_valid(mdl)
    solver = get_param(mdl, 'Solver');
    assert(strcmp(solver, 'FixedStepDiscrete'), ...
        'Solver must be FixedStepDiscrete, got: %s', solver);
    Ts = str2double(get_param(mdl, 'FixedStep'));
    assert(Ts > 0 && Ts <= 1e-4, ...
        'FixedStep must be in (0, 1e-4], got: %g', Ts);
    fprintf('OK: Solver=%s, Ts=%g s (%.0f kHz)\n', solver, Ts, 1/Ts/1e3);
end
```

**Exception:** Simscape plants require `ode14x` (implicit solver), not FixedStepDiscrete.

### 2. Sample Time Consistency

```matlab
function check_sample_times(mdl)
    blocks = find_system(mdl, 'Type', 'Block');
    for k = 1:numel(blocks)
        ts = get_param(blocks{k}, 'CompiledSampleTime');
        if ts(1) == inf
            warning('Block "%s" has Ts=inf (should be -1 for inherited)', blocks{k});
        end
    end
end
```

### 3. PI Gain Sanity Check

```matlab
function assert_pi_gains_sane(PI_params, Ts, Ts_speed)
    % Current loop BW check (Modulus Optimum targets 1/(2*Ts))
    BW_max = 1/(2*Ts) * 1.05;  % 5% margin
    BW_d = PI_params.Kp_id / PI_params.Ti_id;
    assert(BW_d <= BW_max, 'Current BW (%.0f) exceeds Nyquist limit (%.0f)', BW_d, BW_max);

    % Ki*Ts must be non-zero
    assert(PI_params.Ki_id * Ts > 0, 'Ki_id*Ts is zero — no integral action');
    assert(PI_params.Ki_i  * Ts > 0, 'Ki_i*Ts is zero — no integral action');
    assert(PI_params.Ki_speed * Ts_speed > 0, 'Ki_speed*Ts_speed is zero');

    % Speed BW must be < Current BW / 5
    BW_speed = PI_params.Kp_speed / PI_params.Ti_speed;
    assert(BW_speed < BW_d / 5, ...
        'Speed BW (%.0f) must be < Current BW / 5 (%.0f)', BW_speed, BW_d/5);
    fprintf('OK: Current BW=%.0f, Speed BW=%.0f (ratio=%.1f)\n', ...
        BW_d, BW_speed, BW_d/BW_speed);
end
```

### 4. Voltage Margin Check

```matlab
function assert_voltage_margin(pmsm, inverter, speed_rpm, id, iq)
    we = speed_rpm * pi/30 * pmsm.p;
    pmsm_op = mcb.updatePMSMLdLqFluxPM(pmsm, pmsm.PMSMLUT, id, iq, 1);
    Vd = pmsm.Rs * id - we * pmsm_op.Lq * iq;
    Vq = pmsm.Rs * iq + we * (pmsm_op.Ld * id + pmsm_op.FluxPM);
    Vmag = sqrt(Vd^2 + Vq^2);
    Vmax = inverter.V_dc / sqrt(3);
    margin_pct = (1 - Vmag/Vmax) * 100;
    assert(margin_pct > 0, ...
        'Voltage saturated! Vmag=%.1f V > Vmax=%.1f V at %d RPM', Vmag, Vmax, speed_rpm);
    fprintf('OK: Vmag=%.1f V, Vmax=%.1f V, margin=%.1f%%\n', Vmag, Vmax, margin_pct);
end
```

### 5. LUT Dimension Validation

```matlab
function assert_lut_dimensions(pmsm)
    lut = pmsm.PMSMLUT;
    % Inductance tables: [nId x nIq]
    expectedSize = [numel(lut.idVec), numel(lut.iqVec)];
    assert(isequal(size(lut.LdTable), expectedSize), ...
        'LdTable size [%s] ~= expected [%s]', mat2str(size(lut.LdTable)), mat2str(expectedSize));
    assert(isequal(size(lut.LqTable), expectedSize), 'LqTable size mismatch');
    assert(isequal(size(lut.FluxPMTable), expectedSize), 'FluxPMTable size mismatch');

    % Reference tables: [nTorque x nSpeed]
    refSize = [numel(lut.trefVec), numel(lut.wrpmVec)];
    assert(isequal(size(lut.idTable), refSize), ...
        'idTable size [%s] ~= expected [%s]', mat2str(size(lut.idTable)), mat2str(refSize));
    assert(isequal(size(lut.iqTable), refSize), 'iqTable size mismatch');
    fprintf('OK: LUT dims — inductance [%dx%d], reference [%dx%d]\n', ...
        expectedSize(1), expectedSize(2), refSize(1), refSize(2));
end
```

### 6. Post-Simulation Steady-State Check

```matlab
function assert_steady_state(logsout, tol)
    id_ref = logsout.get('id_ref').Values;
    id_meas = logsout.get('id_meas').Values;
    N = numel(id_ref.Data);
    tail = round(0.8*N):N;
    err_id = mean(abs(id_ref.Data(tail) - id_meas.Data(tail)));
    assert(err_id < tol, 'id tracking error %.3f A exceeds tolerance %.3f A', err_id, tol);

    iq_ref = logsout.get('iq_ref').Values;
    iq_meas = logsout.get('iq_meas').Values;
    err_iq = mean(abs(iq_ref.Data(tail) - iq_meas.Data(tail)));
    assert(err_iq < tol, 'iq tracking error %.3f A exceeds tolerance %.3f A', err_iq, tol);
    fprintf('OK: Steady-state errors — id: %.4f A, iq: %.4f A (tol: %.3f A)\n', ...
        err_id, err_iq, tol);
end
```

---

## Quick Pre-Sim Validation Script

```matlab
%% Run all pre-simulation checks
mdl = 'my_foc_model';
load('mcbpmsm.mat', 'pmsm', 'inverter');
Ts = 5e-5; Ts_speed = 10*Ts;

assert_solver_valid(mdl);
assert_lut_dimensions(pmsm);
PI_params = mcb.calcFOCGains(pmsm, Ts, Ts_speed);
assert_pi_gains_sane(PI_params, Ts, Ts_speed);
assert_voltage_margin(pmsm, inverter, 3000, -50, 200);  % check at operating point
fprintf('\n=== All pre-simulation checks PASSED ===\n');
```

---

## Sensorless-Specific Checks

### SMO Convergence Diagnostic

```matlab
% SMO checklist (check in order):
% 1. Speed > 10% rated? (SMO needs back-EMF)
% 2. Rs accurate at operating temperature?
% 3. LPF cutoff appropriate? Rule: fc > 2 * f_electrical_max
% 4. PLL bandwidth reasonable? Rule: wn = 0.1 * (2*pi*f_pwm)
saliency_ratio = pmsm.Lq / pmsm.Ld;
fprintf('Saliency ratio: %.2f (HFI needs > 1.2)\n', saliency_ratio);
```

### HFI Requirements

- Motor MUST have saliency: `Lq/Ld > 1.2` (use SMO for SPMSM)
- HFI blocks require **single precision** inputs (NOT double)
- HFI injection frequency: 500-2000 Hz (above current BW, below PWM/2)

---

## Zero-Torque Diagnostic Checklist

Check in order when motor produces no torque:
1. Enable signal on FOC CC = 1? (default may be 0)
2. Speed/torque reference non-zero? (check after t=step_time)
3. PMSM pole pairs (`P`) correct? (P=0 → no torque)
4. PMSM FluxPM/lambda_pm > 0? (for SynRM: both id AND iq needed)
5. Inverter Vdc connected and non-zero?
6. Load torque not exceeding motor capability?
7. Solver is FixedStepDiscrete (not continuous with discrete blocks)?

---

## Swapped id/iq Diagnostic

**Symptom**: Oscillation in both id and iq, unstable even at low speed.

**Verification method**: Step id_ref alone → only id should respond (iq constant). If both oscillate, connections are swapped.

```json
[
  {"op": "connect", "target": "Park.y1 -> PI_d.u2"},
  {"op": "connect", "target": "Park.y2 -> PI_q.u2"}
]
```
Park output port 1 = Id → PI_d measurement port, Park output port 2 = Iq → PI_q measurement port.

---

## Common Mistakes Quick Reference

| Mistake | Symptom | Fix |
|---------|---------|-----|
| Raw Ki instead of Ki*Ts | No SS tracking | `Ki_block = Ki * Ts` |
| Speed in RPM at LUT port | Wrong torque ref | Convert: `speed_rpm * pi/30` |
| 3-phase input to FOC CC | Dimension error | Use only `[Ia; Ib]` (2 phases) |
| Wrong solver | Sim crash | Use `FixedStepDiscrete` |
| Missing Ts in model | Random sample times | Set `FixedStep = '5e-5'` |
| PTBS speed in RPM | Wrong envelope | PTBS uses rad/s internally |
| Simscape speed not negated | Runs backwards | Multiply speed AND angle by -1 |
| Continuous solver with MCB | Algebraic loops | Switch to discrete |

---

> See also: `auto_fix/ERROR_PATTERNS.md` (89 categorized error patterns with fixes)

----
Copyright 2026 The MathWorks, Inc.
----
