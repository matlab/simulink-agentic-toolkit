# Model Sanity Check — Part 1: Infrastructure

> Solver, plant configuration, transforms, data types, algebraic loops.
> Run after model is fully built, before first simulation.
> See [`model-sanity-check.md`](model-sanity-check.md) for when to run and execution pattern.
> **Next:** [`model-sanity-check-control.md`](model-sanity-check-control.md)

---

## 1. Solver and Model Configuration

### [STRICT] 1.1 Solver matches plant type
```matlab
solver = get_param(mdl, 'Solver');
has_simscape = ~isempty(find_system(mdl, 'FollowLinks','on', 'LookUnderMasks','all', 'BlockType','SimscapeBlock'));
plant_blks = [find_system(mdl,'SearchDepth',1,'RegExp','on','ReferenceBlock','.*Interior PMSM'); ...
              find_system(mdl,'SearchDepth',1,'RegExp','on','ReferenceBlock','.*Surface Mount PMSM')];
if has_simscape
    assert(contains(solver,'ode14x') || contains(solver,'ode23t'), ...
        'FAIL: Simscape plant requires implicit solver (ode14x/ode23t), got "%s"', solver);
elseif ~isempty(plant_blks)
    sim_type = get_param(plant_blks{1}, 'sim_type');
    if strcmp(sim_type, 'Discrete')
        assert(strcmp(solver,'FixedStepDiscrete'), ...
            'FAIL: Discrete MCB plant requires FixedStepDiscrete, got "%s"', solver);
    end
end
```

### [STRICT] 1.2 Plant sim_type is Discrete (MCB plants)
```matlab
% Applies to: Interior PMSM, Surface Mount PMSM, BLDC, Induction Motor
plant_names = find_system(mdl, 'SearchDepth', 1, 'BlockType', 'SubSystem');
for i = 1:numel(plant_names)
    try
        st = get_param(plant_names{i}, 'sim_type');
        assert(strcmp(st, 'Discrete'), ...
            'FAIL: %s sim_type="%s" — MUST be "Discrete"', get_param(plant_names{i},'Name'), st);
    catch ME
        if ~contains(ME.message, 'Invalid parameter')
            rethrow(ME);
        end
    end
end
```

### [STRICT] 1.3 FixedStep references Ts
```matlab
fs = get_param(mdl, 'FixedStep');
assert(contains(fs,'Ts') || ~isempty(str2double(fs)), ...
    'FAIL: FixedStep="%s" — should reference Ts or be a valid number', fs);
```

### [ADVISORY] 1.4 Diagnostics configured for debugging
```matlab
inputMsg = get_param(mdl, 'UnconnectedInputMsg');
if ~strcmp(inputMsg, 'error')
    warning('UnconnectedInputMsg="%s" — recommend "error" to catch wiring bugs', inputMsg);
end
```

### [ADVISORY] 1.5 StopTime reasonable for step response
```matlab
% 0.5–5s typical for speed control; >10s usually unnecessary; <0.1s too short for speed loop
```

---

## 2. Plant Block Configuration

### [STRICT] 2.1 P is pole pairs (all motor blocks)
```matlab
% Interior/Surface PMSM: P = pole pairs (e.g., 4 for an 8-pole motor)
% BLDC: p = pole pairs
% ACIM: P = pole pairs
for each plant block:
    P_val = evalin(mdlWks, get_param(blk, 'P'));
    assert(P_val <= 10, ...
        'FAIL: P=%d — likely poles not pole pairs (divide by 2)', P_val);
end
```

### [STRICT] 2.2 Plant Ts matches model sample time
```matlab
pmsm_Ts = get_param(plant_blk, 'Ts');
assert(contains(pmsm_Ts, 'Ts'), ...
    'FAIL: Plant Ts="%s" — should reference workspace Ts (or Ts/2 for multi-rate)', pmsm_Ts);
```

### [STRICT] 2.3 Motor parameters are non-default
```matlab
Rs_val = evalin(mdlWks, get_param(plant_blk, 'Rs'));
assert(Rs_val ~= 0.02, 'FAIL: Rs=0.02 (block default) — set actual motor value');
% Also check: Ldq not default [1.7e-3 3.2e-3], lambda_pm not default 0.2205
```

### [STRICT] 2.4 BLDC dual sim_type params (BLDC only)
```matlab
% BLDC requires BOTH SimType AND sim_type set to 'Discrete'
if is_bldc
    assert(strcmp(get_param(blk,'SimType'),'Discrete') && strcmp(get_param(blk,'sim_type'),'Discrete'), ...
        'FAIL: BLDC must have both SimType AND sim_type = "Discrete"');
end
```

### [STRICT] 2.5 ACIM impedance format (ACIM only)
```matlab
% Zs=[Rs, Lls] and Zr=[Rr, Llr] — NOT individual params
if is_acim
    Zs_str = get_param(blk, 'Zs');
    assert(contains(Zs_str, ','), 'FAIL: ACIM Zs must be vector [Rs, Lls], got "%s"', Zs_str);
end
```

### [ADVISORY] 2.6 lambda_pm > 0 (PMSM only)
```matlab
lpm = evalin(mdlWks, get_param(plant_blk, 'lambda_pm'));
assert(lpm > 0, 'lambda_pm=0 invalid (use 1e-6 for SynRM)');
```

### [ADVISORY] 2.7 port_config matches control mode
```matlab
% 'Torque' for closed-loop speed/torque control, 'Speed' for open-loop speed source
```

---

## 3. Transform Blocks

### [STRICT] 3.1 Park/InvPark ThetaInput = 'Electrical position'
```matlab
transform_blks = find_system(mdl, 'SearchDepth', 1, 'Type', 'Block');
for i = 1:numel(transform_blks)
    ref = get_param(transform_blks{i}, 'ReferenceBlock');
    if contains(ref, 'Park') || contains(ref, 'Clarke to Park') || contains(ref, 'Park to Clarke')
        try
            thetaInput = get_param(transform_blks{i}, 'ThetaInput');
            assert(strcmp(thetaInput, 'Electrical position'), ...
                'FAIL: %s ThetaInput="%s" — MUST be "Electrical position"', ...
                get_param(transform_blks{i},'Name'), thetaInput);
        catch ME
            if contains(ME.message, 'Invalid parameter'), continue; end
            rethrow(ME);
        end
    end
end
```

### [STRICT] 3.2 Park/InvPark has 3 input ports (not 4)
```matlab
% 4 ports = sin/cos mode (ThetaInput not applied correctly)
for each Park/InvPark block:
    ports = get_param(blk, 'Ports');
    assert(ports(1) == 3, ...
        'FAIL: %s has %d inputs (expect 3). ThetaInput param not applied → silent angle error.', name, ports(1));
end
```

### [STRICT] 3.3 AngleInput = 'Radians'
```matlab
for each Park/InvPark block:
    assert(strcmp(get_param(blk,'AngleInput'), 'Radians'), ...
        'FAIL: %s AngleInput must be "Radians"', name);
end
```

### [STRICT] 3.4 Clarke inputs are scalar (not vector)
```matlab
% Clarke must receive Ia, Ib as separate scalar connections on port 1 and port 2
% NOT a [Ia;Ib] vector on port 1
clarke_blk = find_system(mdl, 'SearchDepth', 1, 'Name', '*Clarke*');
% Verify: source of Clarke/u1 is a Demux output or single-signal source
```

### [ADVISORY] 3.5 AxisAlignment unchanged from default
```matlab
% Changing to 'Q-axis' swaps Id/Iq relative to PMSM convention. Flag only.
```

---

## 4. Data Types

### [STRICT] 4.1 DTC after plant outputs (all motor blocks)
```matlab
% y2 (currents) and y3 (speed) of PMSM/BLDC/ACIM are SINGLE precision
% Must have DataTypeConversion(double) before Sum/PI/Gain/Clarke
plant_blk = find_system(mdl, 'SearchDepth', 1, 'Name', 'PMSM');
if isempty(plant_blk), plant_blk = find_system(mdl, 'SearchDepth', 1, 'Name', 'BLDC'); end
if isempty(plant_blk), plant_blk = find_system(mdl, 'SearchDepth', 1, 'Name', 'ACIM'); end
% Trace y2, y3 destinations — first downstream block MUST be DTC
```

### [STRICT] 4.2 DTC after SMO/observer outputs
```matlab
% SMO, Flux Observer, EEMF outputs may be single precision
% Add DTC before Park/InvPark angle input
```

### [STRICT] 4.3 Six Step output DTC (BLDC only)
```matlab
% Six Step Commutation output is BOOLEAN
% Must add DTC(double) before any multiplication/gain
```

### [ADVISORY] 4.4 DefaultUnderspecifiedDataType = 'double'
```matlab
dtype = get_param(mdl, 'DefaultUnderspecifiedDataType');
if ~strcmp(dtype, 'double')
    warning('DefaultUnderspecifiedDataType="%s" — recommend "double" for simulation', dtype);
end
```

---

## 5. Algebraic Loop Prevention

### [STRICT] 5.1 Unit Delay between voltage output and plant input
```matlab
% Between InvClarke/FOC_CC/AVI output and PMSM.u2, there MUST be a Unit Delay
% Exception: if AVI is between control and PMSM, delay is optional (AVI breaks the loop)
plant_blk = [mdl '/PMSM'];
pc = get_param(plant_blk, 'PortConnectivity');
% Find source of voltage input port — must be UnitDelay or AVI
src_blk = get_param(pc(2).SrcBlock, 'BlockType');
assert(any(strcmp(src_blk, {'UnitDelay','Delay','SubSystem'})), ...
    'FAIL: Plant voltage input fed by %s — need Unit Delay or AVI for algebraic loop prevention', src_blk);
```

### [STRICT] 5.2 Delay in FW voltage feedback path
```matlab
% If field weakening uses |Vdq| = sqrt(Vd²+Vq²) → compare with Vmax,
% there MUST be a Unit Delay between Vdq computation and the FW sum block
```

### [STRICT] 5.3 Delay before SMO voltage inputs (FOC CC pattern)
```matlab
% FOC CC output → Delay → Demux/Clarke → SMO voltage ports
% Without delay: SMO angle → FOC CC → voltages → SMO = algebraic loop
```

### [ADVISORY] 5.4 Unit Delay SampleTime = Ts
```matlab
delay_blks = find_system(mdl, 'SearchDepth', 1, 'BlockType', 'UnitDelay');
for i = 1:numel(delay_blks)
    st = get_param(delay_blks{i}, 'SampleTime');
    if ~contains(st, 'Ts')
        warning('%s SampleTime="%s" — should typically be Ts', get_param(delay_blks{i},'Name'), st);
    end
end
```

---

> **Next:** [`model-sanity-check-control.md`](model-sanity-check-control.md) — PI controllers, speed loop physics, inverter path

----
Copyright 2026 The MathWorks, Inc.
----
