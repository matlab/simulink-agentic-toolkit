# Constraint Curves & Drive Characterization

> API reference for computing PMSM/SynRM operating envelopes, MTPA/FW/MTPV trajectories,
> and validating motor+inverter combinations before building models.

---

## Primary API: `mcb.PMSMCharacteristics`

Computes and optionally plots drive characteristics and constraint curves for PMSM drives.

### Syntax

```matlab
characteristics = mcb.PMSMCharacteristics(pmsm, inverter)
characteristics = mcb.PMSMCharacteristics(pmsm, inverter, Name=Value)
```

### Required Inputs

| Input | Type | Description |
|-------|------|-------------|
| `pmsm` | struct | Motor parameters: Rs, Ld, Lq, FluxPM, p, N_rated, I_rated |
| `inverter` | struct | Inverter parameters: V_dc (minimum required) |

### Name-Value Arguments

| Name | Default | Values | Description |
|------|---------|--------|-------------|
| `driveCharacteristics` | 0 | 0, 1, 2 | 0=no plot, 1=plot torque-speed, 2=plot+return data |
| `constraintCurves` | true | true/false | Plot id-iq constraint curves |
| `FWCMethod` | `'vclmt'` | `'vclmt'`, `'cvcp'`, `'cccp'`, `'none'` | Field weakening strategy |
| `voltageEquation` | `'actual'` | `'actual'`, `'approximate'` | Voltage equation complexity |
| `speed` | — | scalar (RPM) | Specific speed operating point to mark |
| `torque` | — | scalar (Nm) | Specific torque operating point to mark |
| `imax` | — | scalar (A) | Override max current (default: I_rated) |
| `idqExternal` | — | matrix | External id-iq trajectory to overlay |
| `opacity` | 1.0 | 0-1 | Plot opacity |

### FWC Method Selection

| Method | Full Name | Description |
|--------|-----------|-------------|
| `'vclmt'` | Voltage-Current Limited Maximum Torque | Standard — follows MTPA below base, FW above, MTPV at limit |
| `'cvcp'` | Constant Voltage Constant Power | Maintains constant voltage above base speed |
| `'cccp'` | Constant Current Constant Power | Maintains constant current magnitude |
| `'none'` | No FWC | MTPA only, no field weakening |

### Output Structure (19 fields, verified R2025+)

```matlab
chars = mcb.PMSMCharacteristics(pmsm, inverter, ...);

% Nested structs with .id and .iq subfields:
chars.current       % .id, .iq — current limit circle trajectory
chars.torque        % .id, .iq — constant torque loci
chars.mtpa          % .id, .iq — MTPA trajectory points
chars.voltage       % .id, .iq — voltage limit ellipse (at given speed)
chars.mtpv          % .id, .iq — MTPV trajectory (IPMSM only)

% Array data (full operating envelope):
chars.idArray       % id values across envelope
chars.iqArray       % iq values across envelope
chars.vdArray       % Vd voltage at each point
chars.vqArray       % Vq voltage at each point
chars.wArray        % Speed array (RPM)
chars.TArray        % Torque array (Nm)
chars.PArray        % Power array (W)

% Copies of inputs:
chars.pmsm          % Motor struct used
chars.inverter      % Inverter struct used
chars.FWCMethod     % FWC method used
chars.voltageEquation % Voltage equation used

% Operating point milestones (RPM):
chars.speed_milestone  % [2x1] key speed points in RPM: (1)=base, (2)=max
chars.id_milestone     % [1x2] id at milestone speeds
chars.iq_milestone     % [1x2] iq at milestone speeds
```

---

## Usage Examples

### 1. Validate Motor+Inverter Before Building Model

```matlab
% Define motor
pmsm.Rs = 1.39; pmsm.Ld = 5.8e-3; pmsm.Lq = 8.5e-3;
pmsm.FluxPM = 0.175; pmsm.p = 4; pmsm.I_rated = 4.0;
pmsm.N_rated = 2000; pmsm.J = 0.0004; pmsm.B = 0.001;

% Define inverter
inverter.V_dc = 310;

% Check: can this motor reach 3000 RPM?
chars = mcb.PMSMCharacteristics(pmsm, inverter, ...
    'driveCharacteristics', 2, ...
    'constraintCurves', true, ...
    'speed', 3000);

% speed_milestone is in RPM: (1)=base speed, (2)=max speed
fprintf('Base speed: %.0f RPM\n', chars.speed_milestone(1));
fprintf('Max speed: %.0f RPM\n', chars.speed_milestone(2));
% If speed_milestone(2) < 3000, need higher Vdc or different FWC strategy
```

### 2. Compare FWC Strategies

```matlab
% Plot with different methods
figure;
for method = ["vclmt", "cvcp", "cccp"]
    mcb.PMSMCharacteristics(pmsm, inverter, ...
        'FWCMethod', method, ...
        'driveCharacteristics', 1, ...
        'opacity', 0.6);
    hold on;
end
legend('VCLMT', 'CVCP', 'CCCP');
```

### 3. Quick Feasibility Check (No Plot)

```matlab
% Analytical maximum speed estimate
Vmax = inverter.V_dc / sqrt(3);  % Peak phase voltage
N_max_approx = Vmax / (pmsm.FluxPM * pmsm.p) * 30/pi;  % RPM
fprintf('Approximate max speed: %.0f RPM\n', N_max_approx);

% If speed_ref > 90% of N_max_approx, motor will saturate
```

---

## Key Design Rules

1. **Base speed** = speed where voltage saturates at rated current on MTPA trajectory
2. **Above base speed** = field weakening required (negative id injected)
3. **IPMSM (Ld != Lq)** can reach MTPV region; SPMSM (Ld = Lq) cannot
4. **Vdc validation**: `N_max ≈ Vmax/(FluxPM*p) * 30/pi` — if target speed > 90% of this, expect saturation
5. **Current circle**: operating point must stay within `sqrt(id^2 + iq^2) <= I_max`
6. **Voltage ellipse** shrinks with speed — intersection with current circle defines max torque at that speed

---

## Related MCB Examples

| Example | ID | Focus |
|---------|-----|-------|
| PMSM Constraint Curves | `mcb/PMSMConstraintCurvesAndTheirApplicationExample` | MTPA/FW/MTPV in id-iq plane |
| Drive Characteristics | `mcb/PMSMDriveCharacteristicsAndConstraintCurvesExample` | Torque-speed envelope |
| SynRM Curves | `mcb/SynRMConstraintCurvesAndTheirApplicationExample` | SynRM-specific (no FluxPM) |
| Reference Currents from Data | `mcb/DetermineRefCurrentsPMSMUsingTestDataExample` | LUT generation from dyno |

---

## Integration with Model Building

After characterization confirms feasibility:

1. **Below base speed only** → Use MTPA Control Reference, no FW needed
2. **Need field weakening** → Add +FW feature per `composition-rules.md`
3. **Deep FW (>2× base speed)** → Consider +OVM (overmodulation) for voltage extension
4. **Nonlinear motor (FEA data)** → Use LUT-based Control Reference with pre-computed trajectories from `mcb.generateMotorLUT(pmsm, inverter, 'idiqLUTs')`

---

## See Also

- `mcb.calcFOCGains` — PI gain computation
- `mcb.getPMSMParameters` — Load standard motor parameter sets
- `mcb.getInverterParameters` — Load standard inverter parameter sets
- `mcb.getPUSystemParameters` — Compute per-unit base values

----
Copyright 2026 The MathWorks, Inc.
----
