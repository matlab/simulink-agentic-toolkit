# Model Sanity Check — Part 3: Domain-Specific

> Sensorless, ACIM, angle feedback, connections, workspace, high-speed, current limits, diagnostics.
> Run after model is fully built, before first simulation. Skip sections that don't apply.
> See [`model-sanity-check.md`](model-sanity-check.md) for when to run and execution pattern.
> **Previous:** [`model-sanity-check-control.md`](model-sanity-check-control.md)

---

## 9. Sensorless Observers (SMO / Flux Observer / EEMF)

### [STRICT] 9.1 Observer voltage inputs = command voltages
```matlab
% SMO/FO/EEMF u1,u2 = Valpha,Vbeta from InvPark (command), NOT from measured plant
% Trace source of observer ports 1,2 — must come from InvPark or FOC CC internal
```

### [STRICT] 9.2 SMO PerUnitSpeed == MaxApplicationSpeed
```matlab
if has_smo
    pus = get_param(smo_blk, 'PerUnitSpeed');
    mas = get_param(smo_blk, 'MaxApplicationSpeed');
    assert(strcmp(pus, mas), ...
        'FAIL: SMO PerUnitSpeed="%s" ≠ MaxApplicationSpeed="%s" → speed bias', pus, mas);
end
```

### [STRICT] 9.3 Observer DTC before arithmetic
```matlab
% SMO/FO/EEMF outputs may be single. DTC(double) before Park angle port.
```

### [STRICT] 9.4 I/f startup below transition speed
```matlab
% SMO fails below ~5% rated speed. Verify I/f or open-loop startup exists
% if observer is sole angle source.
if has_smo && ~has_encoder
    % Check for I-F Controller block or equivalent
end
```

### [STRICT] 9.5 SMO CutoffFreq exceeds 2× max electrical frequency
```matlab
% PLL cutoff must track max electrical frequency without phase lag
if has_smo
    fc_smo = evalin(mdlWks, get_param(smo_blk, 'CutoffFreq'));
    f_e_max = max_speed_rpm / 60 * pmsm.p;
    assert(fc_smo > 2 * f_e_max, ...
        'FAIL: SMO CutoffFreq=%.0f Hz but f_e_max=%.0f Hz — must be > 2×f_e_max', fc_smo, f_e_max);
end
```

### [STRICT] 9.6 HFI saliency requirement (Lq/Ld > 1.2)
```matlab
% HFI requires magnetic saliency to detect rotor position
if has_hfi
    saliency = pmsm.Lq / pmsm.Ld;
    assert(saliency > 1.2, ...
        'FAIL: Saliency ratio=%.2f (need >1.2 for HFI). Use SMO instead for SPMSM.', saliency);
end
```

### [ADVISORY] 9.7 SMO speed output verification
```matlab
% SMO port y2 (speed) may be unreliable in some releases.
% Prefer deriving speed from position derivative + LPF.
```

---

## 10. ACIM-Specific

### [STRICT] 10.1 id_ref is non-zero
```matlab
% ACIM RFOC requires magnetizing current. id_ref=0 → zero torque!
if is_acim
    id_ref_val = evalin(mdlWks, 'id_ref');
    assert(id_ref_val ~= 0, ...
        'FAIL: ACIM id_ref=0 — must provide magnetizing current (FluxPM/Lm)');
end
```

### [STRICT] 10.2 Slip angle integrated and wrapped
```matlab
% theta_e = integral(p*wm + we_slip) mod 2*pi
% Check for Discrete-Time Integrator with wrapping or mod block
```

### [STRICT] 10.3 Impedance parameters use correct convention
```matlab
% MCB ACIM: Zs=[Rs, Lls], Zr=[Rr, Llr] (vectors)
% Lls/Llr are LEAKAGE inductances, NOT total inductances
% Total: Ls = Lls + Lm
```

### [STRICT] 10.4 Simscape IM rotor cage grounded
```matlab
% Squirrel cage IM in Simscape: RConn3 must connect to Grounded Neutral (Three-Phase)
% Floating rotor → structural singularity error
```

### [STRICT] 10.5 LUT NmGrid symmetric for bidirectional operation
```matlab
% LUT Control Reference extrapolates outside grid → divergence for negative torque
if has_lut_ctrl_ref
    NmGrid = evalin(mdlWks, 'NmGrid');
    assert(min(NmGrid) < 0, ...
        'FAIL: NmGrid has no negative torque values — bidirectional operation will extrapolate');
    assert(abs(min(NmGrid) + max(NmGrid)) < 0.01 * max(NmGrid), ...
        'FAIL: NmGrid not symmetric — min=%.2f, max=%.2f', min(NmGrid), max(NmGrid));
end
```

### [STRICT] 10.6 LUT table dimensions match breakpoints
```matlab
% idTable must be [length(trefVec) × length(wrpmVec)]
if has_lut_ctrl_ref
    lut = evalin(mdlWks, 'PMSMLUT');
    expectedSize = [numel(lut.trefVec), numel(lut.wrpmVec)];
    assert(isequal(size(lut.idTable), expectedSize), ...
        'FAIL: idTable size [%s] ≠ expected [%s]', mat2str(size(lut.idTable)), mat2str(expectedSize));
    assert(isequal(size(lut.iqTable), expectedSize), ...
        'FAIL: iqTable size mismatch');
end
```

---

## 11. Angle Feedback Path

### [STRICT] 11.1 No double pole-pair multiplication
```matlab
busSel_signals = get_param([mdl '/BusSel'], 'OutputSignals');
hasMechToElec = ~isempty(find_system(mdl, 'SearchDepth', 1, 'Name', '*MechToElec*'));
if contains(busSel_signals, 'MtrElcPos') && hasMechToElec
    error('FAIL: MtrElcPos → MechToElec = double pole-pair multiplication!');
end
```

### [STRICT] 11.2 MechToElec NrPP matches plant P
```matlab
if hasMechToElec
    nrpp = get_param([mdl '/MechToElec'], 'NrPP');
    plant_P = get_param(plant_blk, 'P');
    assert(strcmp(nrpp, plant_P) || strcmp(nrpp, 'pmsm.p'), ...
        'FAIL: MechToElec NrPP="%s" vs Plant P="%s" — must match', nrpp, plant_P);
end
```

### [STRICT] 11.3 MechToElec MechOfstInputType = 'Specify via dialog'
```matlab
% Default 'Input port' adds unwanted second port
if hasMechToElec
    moit = get_param([mdl '/MechToElec'], 'MechOfstInputType');
    assert(strcmp(moit, 'Specify via dialog'), ...
        'FAIL: MechToElec MechOfstInputType="%s" — use "Specify via dialog" to avoid extra port', moit);
end
```

### [ADVISORY] 11.4 Angle source path is consistent
```matlab
% Valid patterns:
%   BusSel('MtrPos') → MechToElec → Park/InvPark (hardware emulation)
%   BusSel('MtrElcPos') → Park/InvPark directly (simulation shortcut)
%   Observer.y1 → DTC → Park/InvPark (sensorless)
% Flag if mixing approaches or neither connected.
```

---

## 12. Connection Topology

### [STRICT] 12.1 InvClarke → Mux(3) → Delay → PMSM (Pattern A)
```matlab
% For Pattern A (manual PI + transforms):
% InvClarke outputs 3 scalars (Va, Vb, Vc) — must Mux to 3×1 before plant
mux_blks = find_system(mdl, 'SearchDepth', 1, 'BlockType', 'Mux');
if ~isempty(mux_blks)
    for i = 1:numel(mux_blks)
        n = str2double(get_param(mux_blks{i}, 'Inputs'));
        if n == 3, found_3mux = true; end
    end
end
```

### [STRICT] 12.2 Bus Selector for info bus (never Selector)
```matlab
% PMSM/BLDC/ACIM output 1 is a bus object
% Using Selector block → "Power Accounting Bus Creator" error
% Must use Bus Selector with OutputSignals
```

### [STRICT] 12.3 Plant port order: u1=TL, u2=Voltage
```matlab
% Common mistake: connecting voltage to port 1 (torque)
% Verify: source of plant.u1 is a Constant(0) or load torque source
% Verify: source of plant.u2 is Delay_V or AVI output
```

### [STRICT] 12.4 FOC CC current input is 2-phase [Ia; Ib] (not 3-phase)
```matlab
% FOC CC port u2 expects [Ia; Ib] (2×1 vector), NOT [Ia;Ib;Ic]
% Feeding 3-phase → dimension mismatch error
foccc_blks = find_system(mdl, 'SearchDepth', 2, 'Name', '*FOC*Current*');
if ~isempty(foccc_blks)
    % Trace source of FOC CC port 2 — must be 2×1
end
```

### [ADVISORY] 12.5 Park output → PI wiring not swapped (id↔iq)
```matlab
% Park/y1 = Id → must feed PI_d measurement (not PI_q)
% Park/y2 = Iq → must feed PI_q measurement (not PI_d)
% Symptom of swap: both id and iq oscillate even at zero speed
```

### [ADVISORY] 12.6 No unconnected ports in final model
```matlab
% Compile model briefly to detect unconnected port warnings
% Or use find_system to detect blocks with zero source/dest
```

---

## 13. Workspace Completeness

### [STRICT] 13.1 All referenced variables exist in model workspace
```matlab
mdlWks = get_param(mdl, 'ModelWorkspace');
core_vars = {'Ts', 'Vmax', 'pmsm'};
speed_vars = {'Ts_speed', 'Kp_speed', 'Ki_speed', 'iq_sat', 'speed_ref_rad', 'IIR_coeff'};
current_vars = {'Kp_id', 'Ki_id', 'Kp_i', 'Ki_i'};
all_vars = [core_vars, speed_vars, current_vars];
for i = 1:numel(all_vars)
    assert(evalin(mdlWks, sprintf('exist(''%s'',''var'')', all_vars{i})), ...
        'FAIL: Workspace missing "%s"', all_vars{i});
end
```

### [STRICT] 13.2 Ts_speed > Ts and integer multiple
```matlab
Ts = evalin(mdlWks, 'Ts');
Ts_speed = evalin(mdlWks, 'Ts_speed');
assert(Ts_speed > Ts, 'FAIL: Ts_speed must be > Ts');
assert(abs(mod(Ts_speed, Ts)) < 1e-15, 'FAIL: Ts_speed must be integer multiple of Ts');
```

### [STRICT] 13.3 Motor struct has required fields
```matlab
pmsm = evalin(mdlWks, 'pmsm');
required = {'Rs','Ld','Lq','FluxPM','p','J','B','I_rated','N_rated','N_base'};
for i = 1:numel(required)
    assert(isfield(pmsm, required{i}), 'FAIL: pmsm.%s missing', required{i});
end
if is_acim
    acim = evalin(mdlWks, 'acim');
    acim_required = {'Rs','Rr','Lls','Llr','Lm','p','J','B'};
    for i = 1:numel(acim_required)
        assert(isfield(acim, acim_required{i}), 'FAIL: acim.%s missing', acim_required{i});
    end
end
```

### [ADVISORY] 13.4 Gains computed with SpdLoopFactor
```matlab
% Raw calcFOCGains speed gains are almost always too aggressive
Kp_speed = evalin(mdlWks, 'Kp_speed');
if Kp_speed > 5.0
    warning('Kp_speed=%.1f — unusually high. Was SpdLoopFactor used?', Kp_speed);
end
```

---

## 14. High-Speed Motor Checks

### [ADVISORY] 14.1 Electrical frequency vs current loop BW
```matlab
% f_e_max = N_max / 60 * p
% Current BW ≈ 1/(4*Ts) must be > 5× f_e_max
f_e_max = max_speed_rpm / 60 * pmsm.p;
BW_current = 1 / (4 * Ts);
if BW_current < 5 * f_e_max
    warning('f_e_max=%.0f Hz but current BW=%.0f Hz — may be inadequate above base speed', f_e_max, BW_current);
end
```

### [ADVISORY] 14.2 Demagnetization limit on id (FW operation)
```matlab
% id must never go below -FluxPM/Ld
id_demag = -pmsm.FluxPM / pmsm.Ld;
% Check if id saturation limit exists and is >= id_demag
```

---

## 15. Current Limiting

### [STRICT] 15.1 Demagnetization limit on id (FW models)
```matlab
% id must never go below -FluxPM/Ld — permanent magnet damage is irreversible
if has_fw
    id_demag = -pmsm.FluxPM / pmsm.Ld;
    id_sat_blks = find_system(mdl, 'SearchDepth', 2, 'Name', '*Sat*id*');
    if isempty(id_sat_blks)
        warning('FAIL: No id saturation found — demagnetization limit (%.1f A) not enforced', id_demag);
    end
end
```

### [ADVISORY] 15.2 DQ current circle constraint (iq limited by id)
```matlab
% Total current must not exceed I_max = I_rated * sqrt(2)
% Priority: preserve id (needed for FW), limit iq
% iq_max = sqrt(I_max^2 - id_ref^2)
% Flag if no current limiting exists in FW model
```

---

## 16. Zero-Torque Diagnostic

### [ADVISORY] 16.1 Zero-torque checklist (use when motor produces no torque)
```matlab
% Check in order:
% 1. FOC CC Enable signal = 1? (port u7 default may be 0)
% 2. Speed/torque reference non-zero after step time?
% 3. PMSM P > 0? (P=0 → no electrical frequency → no torque)
% 4. FluxPM/lambda_pm > 0? (SynRM: both id AND iq needed)
% 5. Inverter Vdc connected and non-zero?
% 6. Load torque not exceeding motor capability?
% 7. Solver is FixedStepDiscrete (not continuous with discrete blocks)?
% 8. Plant sim_type = 'Discrete'?
```

---

## 17. SynRM / Special Motor Checks

### [STRICT] 17.1 SynRM FluxPM must be non-zero (use 1e-6)
```matlab
% MCB blocks and mcb.calcFOCGains divide by FluxPM
% Setting FluxPM=0 → division by zero → Inf gains
if is_synrm
    lpm = evalin(mdlWks, 'pmsm.FluxPM');
    assert(lpm > 0, 'FAIL: SynRM FluxPM=0 — set to 1e-6 (near-zero, not exactly 0)');
end
```

### [STRICT] 17.2 SynRM speed gains must be manually tuned
```matlab
% mcb.calcFOCGains computes Kt from FluxPM → near-zero for SynRM → invalid speed gains
% Manual: Kt_synrm = 1.5*p*(Ld-Lq)*I_rated/sqrt(2); Kp = J*BW/Kt_synrm
if is_synrm
    Kp_speed = evalin(mdlWks, 'Kp_speed');
    if Kp_speed > 100
        warning('FAIL: Kp_speed=%.0f — likely invalid (calcFOCGains bad for SynRM). Tune manually.', Kp_speed);
    end
end
```

### [ADVISORY] 17.3 Simscape plant sign negation (generator convention)
```matlab
% Simscape FEM PMSM uses generator convention — negate BOTH speed AND angle
% speed_for_control = -simscape_speed
% theta_for_control = -simscape_theta * pmsm.p
% Omitting negation → positive feedback → immediate runaway
```

### [ADVISORY] 17.4 Position loop bandwidth separation
```matlab
% Position BW < Speed BW / 3 < Current BW / 10
% Exceeding this causes oscillation — inner loop can't track commands fast enough
```

---

## 18. Pattern Selection Warnings

### [STRICT] 18.1 Pattern A MUST NOT be used for closed-loop speed control
```matlab
% Pattern A (manual Park/InvPark + discrete PI) causes SUSTAINED OSCILLATION
% when used with MCB discrete PMSM in closed-loop speed control.
% This is NOT a tuning issue — it is a structural instability caused by the
% manual transform chain + Unit Delay creating feedback dynamics that the
% discrete PI cannot compensate for.
%
% MANDATORY: Use Pattern B (FOC CC block) or Pattern B-Simple for ALL
% closed-loop speed control applications.
%
% Pattern A is ONLY acceptable for:
%   - Open-loop voltage testing (no speed feedback)
%   - Current-mode control (no speed loop)
%   - Educational/demonstration (showing why FOC CC exists)
%
has_manual_park = ~isempty(find_system(mdl, 'SearchDepth', 1, 'Name', '*Park*'));
has_foccc = ~isempty(find_system(mdl, 'SearchDepth', 2, 'Name', '*FOC*'));
has_speed_loop = ~isempty(find_system(mdl, 'SearchDepth', 1, 'Name', '*Speed*PI*')) || ...
                 ~isempty(find_system(mdl, 'SearchDepth', 1, 'Name', '*PI_speed*')) || ...
                 ~isempty(find_system(mdl, 'SearchDepth', 1, 'Name', '*PI_spd*'));
if has_manual_park && ~has_foccc && has_speed_loop
    error('FAIL: Pattern A with speed loop — WILL oscillate. Use Pattern B (FOC CC block) or Pattern B-Simple.');
end
```

---

> **Back to index:** [`model-sanity-check.md`](model-sanity-check.md)

----
Copyright 2026 The MathWorks, Inc.
----
