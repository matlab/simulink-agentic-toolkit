# Model Sanity Check — Part 2: Control Loops

> PI controllers, speed loop physics, inverter/modulation path.
> Run after model is fully built, before first simulation.
> See [`model-sanity-check.md`](model-sanity-check.md) for when to run and execution pattern.
> **Previous:** [`model-sanity-check-infrastructure.md`](model-sanity-check-infrastructure.md)
> **Next:** [`model-sanity-check-domain.md`](model-sanity-check-domain.md)

---

## 6. PI Controllers

### [STRICT] 6.1 1-input mode configured (all three params)
```matlab
pi_blks = find_system(mdl, 'SearchDepth', 1, 'ReferenceBlock', 'slpidlib/PID Controller');
for i = 1:numel(pi_blks)
    blk = pi_blks{i};
    name = get_param(blk, 'Name');
    assert(strcmp(get_param(blk,'ControllerParametersSource'),'internal'), 'FAIL: %s ControllerParametersSource != internal', name);
    assert(strcmp(get_param(blk,'ExternalReset'),'none'), 'FAIL: %s ExternalReset != none', name);
    assert(strcmp(get_param(blk,'InitialConditionSource'),'internal'), 'FAIL: %s InitialConditionSource != internal', name);
    % Verify single input port
    ports = get_param(blk, 'Ports');
    assert(ports(1) == 1, 'FAIL: %s has %d inputs (3-port mode active)', name, ports(1));
end
```

### [STRICT] 6.2 UseKiTs = 'on' (MCB convention)
```matlab
for each PI block:
    assert(strcmp(get_param(blk,'UseKiTs'), 'on'), ...
        'FAIL: %s UseKiTs must be "on" (I param = Ki*Ts)', name);
end
```

### [STRICT] 6.3 I parameter includes Ts multiplication
```matlab
for each PI block:
    I_str = get_param(blk, 'I');
    assert(contains(I_str, 'Ts'), ...
        'FAIL: %s I="%s" — with UseKiTs=on, I must include *Ts (e.g., "Ki_id * Ts")', name, I_str);
end
```

### [STRICT] 6.4 Speed PI SampleTime = Ts_speed (not inherited)
```matlab
% Speed PI runs at slower rate — must not inherit model Ts
spd_pi_names = {'PI_speed', 'PI_spd', 'SpeedPI'};
for each speed PI block found:
    st = get_param(blk, 'SampleTime');
    assert(~strcmp(st,'-1') && (contains(st,'speed') || contains(st,'spd')), ...
        'FAIL: Speed PI SampleTime="%s" — must be Ts_speed explicitly', st);
end
```

### [STRICT] 6.5 FOC CC PIConfig is non-zero (Pattern B only)
```matlab
% If using FOC CC block, port u5 carries [Kp_d; Ki_d*Ts; Kp_q; Ki_q*Ts]
% PIConfig = [0;0;0;0] → zero output → motor uncontrolled
foccc_blks = find_system(mdl, 'SearchDepth', 1, 'Name', '*FOC*');
% Check source of FOC CC port 5 — should reference non-zero workspace variables
```

### [ADVISORY] 6.6 Saturation limits set to physical bounds
```matlab
for each PI block:
    upper = get_param(blk, 'UpperSaturationLimit');
    % Current PI: ±Vmax; Speed PI: ±iq_sat or ±I_rated
    if strcmp(upper, 'inf')
        warning('%s has no upper saturation limit — risk of integrator windup', name);
    end
end
```

### [ADVISORY] 6.7 Standard PID (slpidlib) fully configured
```matlab
% If NOT using mcbcontrolslib path, verify ALL 8 params are set:
% Controller='PI', TimeDomain='Discrete-time', SampleTime, IntegratorMethod='Forward Euler',
% LimitOutput='on', Upper/LowerSaturationLimit, AntiWindupMode='clamping'
```

---

## 7. Speed Loop Physics


### [ADVISORY] 7.1 Speed units consistency
```matlab
% PMSM.y3 outputs rad/s. Speed ref should also be rad/s (or explicit conversion exists).
% Common trap: "52 rad/s" misread as "52 RPM" (actually = 500 RPM)
step_after = get_param([mdl '/SpdRef'], 'After');
if ~contains(step_after, 'rad') && ~contains(step_after, '2*pi')
    warning('Speed ref "%s" — verify units match PMSM.y3 (rad/s)', step_after);
end
```

---

## 8. Inverter and Modulation Path

### [STRICT] 8.1 V2D formula correct (when AVI present)
```matlab
% duty = Vabc/(2*Vmax) + 0.5  where Vmax = Vdc/sqrt(3)
% WRONG: duty = Vabc/Vdc + 0.5 (exceeds [0,1] at full modulation)
v2d_blks = find_system(mdl, 'SearchDepth', 1, 'Name', '*V2D*');
if ~isempty(v2d_blks)
    gain_str = get_param(v2d_blks{1}, 'Gain');
    assert(contains(gain_str,'sqrt(3)') || contains(gain_str,'Vmax') || contains(gain_str,'2*'), ...
        'FAIL: V2D Gain="%s" — must use 1/(2*Vmax) not 1/Vdc', gain_str);
end
```

### [STRICT] 8.2 No V2D when connecting directly to PMSM.u2
```matlab
% Pattern A (direct voltage): InvClarke → Mux → Delay → PMSM.u2 (expects VOLTS)
% V2D converts to duty [0,1] — WRONG for direct PMSM connection
has_avi = ~isempty(find_system(mdl, 'SearchDepth', 1, 'Name', '*AVI*'));
has_v2d = ~isempty(find_system(mdl, 'SearchDepth', 1, 'Name', '*V2D*'));
if has_v2d && ~has_avi
    error('FAIL: V2D present but no AVI — PMSM.u2 expects volts, not duty [0,1]');
end
```

### [STRICT] 8.3 AVI duty input is 3×1 vector
```matlab
% AVI expects [Da;Db;Dc] — 3×1 muxed vector on port 1
% Must have 3-input Mux before AVI (unless FOC CC provides vector output)
```

### [STRICT] 8.4 PWM Ref Gen inputs are per-unit
```matlab
% PWM Reference Generator expects Valpha/Vmax, Vbeta/Vmax on inputs
% Position port expects per-unit [0,1), NOT radians [0, 2*pi)
% Connecting raw volts/radians → wrong duty cycles → overcurrent
pwm_blks = find_system(mdl, 'SearchDepth', 1, 'Name', '*PWM*');
if ~isempty(pwm_blks)
    % Trace source — should have a Gain(1/Vmax) upstream for voltage
    % Position port source should have Gain(1/(2*pi)) upstream
end
```

### [ADVISORY] 8.5 AVI Vdc port connected
```matlab
% AVI port u2 = Vdc. Should be connected (not floating).
```

---

> **Next:** [`model-sanity-check-domain.md`](model-sanity-check-domain.md) — Sensorless, ACIM, angle, connections, workspace, diagnostics

----
Copyright 2026 The MathWorks, Inc.
----
