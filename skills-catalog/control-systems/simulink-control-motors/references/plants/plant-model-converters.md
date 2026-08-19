# Plant Model Converters

> **Purpose:** Convert MCB PMSM data (pmsm struct + PMSMLUT) to formats required by
> Simscape Electrical, Powertrain Blockset (PTBS), and Simscape Motor & Drive blocks.

---

## Quick Conversion Map

| Target Block | Converter | Key API |
|---|---|---|
| Simscape FEM-Parameterized PMSM (2D) | [FEM 2D](#simscape-fem-2d) | Direct — no conversion needed |
| Simscape FEM-Parameterized PMSM (3D/dq0) | [FEM 3D](#simscape-fem-3d-dq0) | Flux linkage computation |
| PTBS Flux-Based PMSM | [PTBS Flux-Based](#ptbs-flux-based-pmsm) | `mcb.generateMotorLUT(pmsm, inverter, 'ifuncflux')` |
| PTBS Mapped Motor | [PTBS Mapped](#ptbs-mapped-motor) | `mcb.generateMotorLUT` + loss model |
| Simscape Motor & Drive (System Level) | [System Level](#simscape-motor--drive-system-level) | `mcb.PMSMCharacteristics` + loss model |
| Full Pipeline (all targets) | [Enriched Pipeline](#full-enriched-pipeline) | All of the above + voltage sweep + percent-torque |

---

## Reference Data

The converters require a `pmsm` struct with `PMSMLUT` field and an `inverter` struct.

**MCB installation reference data:**
```matlab
% Load reference PMSM data from Motor Control Blockset installation
mcbRoot = fileparts(which('mcb_pmsm_foc_sim'));
load(fullfile(mcbRoot, 'mcbpmsm.mat'), 'pmsm', 'inverter');
```

If the MCB example data is not on the path, use any `pmsm` struct that contains:
- `pmsm.Rs` — stator resistance (Ohm)
- `pmsm.p` — pole pairs
- `pmsm.J` — rotor inertia (kg·m²)
- `pmsm.B` — viscous friction (N·m·s)
- `pmsm.PMSMLUT.idVec` — d-axis current breakpoints (A), column vector `[nId×1]`
- `pmsm.PMSMLUT.iqVec` — q-axis current breakpoints (A), row vector `[1×nIq]`
- `pmsm.PMSMLUT.LdTable` — d-axis inductance table `[nId × nIq]` (H)
- `pmsm.PMSMLUT.LqTable` — q-axis inductance table `[nId × nIq]` (H)
- `pmsm.PMSMLUT.FluxPMTable` — PM flux linkage table `[nId × nIq]` (Wb)
- `pmsm.I_rated` — rated current (A), optional (fallback: `inverter.ISenseMax `)

And `inverter` struct:
- `inverter.V_dc` — DC bus voltage (V)
- `inverter.ISenseMax` — max sensed current (A)

---

## Simscape FEM 2D

### No Conversion Needed

MCB PMSMLUT format is **directly compatible** with the Simscape FEM-Parameterized PMSM (2D) block.

| MCB Field | Simscape Parameter | Dimensions |
|---|---|---|
| `pmsm.PMSMLUT.idVec` | `idVec` | `[nId × 1]` (column) |
| `pmsm.PMSMLUT.iqVec` | `iqVec` | `[1 × nIq]` (row) |
| `pmsm.PMSMLUT.LdTable` | `LdMatrix` | `[nId × nIq]` |
| `pmsm.PMSMLUT.LqTable` | `LqMatrix` | `[nId × nIq]` |
| `pmsm.PMSMLUT.FluxPMTable` | PM flux table | `[nId × nIq]` |

**Block setup:** The FEM-Parameterized PMSM block must be set to tabulated Ld/Lq parameterization before setting matrix data:
```matlab
set_param(blk, 'parameterization', 'ee.enum.fem_motor.parameterization.tabulatedLdLq');
```

Pass MCB data directly — no reshape, no transpose, no unit conversion. The block accepts both column and row vectors for breakpoints.

---

## Simscape FEM 3D (dq0)

### Purpose
Expand 2D flux tables over a rotor electrical angle dimension for the FEM-Parameterized PMSM 3D block (captures spatial harmonics / cogging torque).

### Inputs
| Variable | Dimensions | Units |
|---|---|---|
| `pmsm.PMSMLUT.idVec` | `[nId × 1]` (column) | A |
| `pmsm.PMSMLUT.iqVec` | `[1 × nIq]` (row) | A |
| `pmsm.PMSMLUT.LdTable` | `[nId × nIq]` | H |
| `pmsm.PMSMLUT.LqTable` | `[nId × nIq]` | H |
| `pmsm.PMSMLUT.FluxPMTable` | `[nId × nIq]` | Wb |
| `pmsm.p` | scalar | pole pairs |

### Outputs
| Variable | Dimensions | Units |
|---|---|---|
| `idVec` | `[1 × nId]` | A |
| `iqVec` | `[1 × nIq]` | A |
| `angDegVec` | `[1 × nAng]` | electrical degrees |
| `FluxDTable3d` | `[nId × nIq × nAng]` | Wb |
| `FluxQTable3d` | `[nId × nIq × nAng]` | Wb |
| `TorqueTable3d` | `[nId × nIq × nAng]` | N·m |

### Procedure

**Step 1: Define angle vector**
```matlab
angDegVec = [0, 15, 30, 45, 60, 75, 90];  % Electrical degrees
nAng = numel(angDegVec);
```

**Step 2: Compute flux linkage from inductance tables**

Critical: use `ndgrid` (NOT `meshgrid`) to preserve `[nId × nIq]` dimension order:
```matlab
[ID_grid, IQ_grid] = ndgrid(pmsm.PMSMLUT.idVec, pmsm.PMSMLUT.iqVec);
FluxDTable = pmsm.PMSMLUT.LdTable .* ID_grid + pmsm.PMSMLUT.FluxPMTable;
FluxQTable = pmsm.PMSMLUT.LqTable .* IQ_grid;
TorqueTable = 1.5 * pmsm.p * (FluxDTable .* IQ_grid - FluxQTable .* ID_grid);
```

**Why ndgrid:** `ndgrid` produces grids where dimension 1 = first vector (idVec) and dimension 2 = second vector (iqVec), matching the `[nId × nIq]` layout of LdTable/LqTable. `meshgrid` would swap dimensions, producing silently incorrect results.

**Flux linkage formulas:**
- `FluxD = Ld * Id + FluxPM` (d-axis flux = inductance × current + permanent magnet)
- `FluxQ = Lq * Iq` (q-axis flux = inductance × current, no PM contribution)
- `Torque = 1.5 * p * (FluxD * Iq - FluxQ * Id)` (electromagnetic torque from cross product of flux and current)

**Step 3: Replicate over angle dimension**
```matlab
FluxDTable3d = repmat(FluxDTable, [1, 1, nAng]);
FluxQTable3d = repmat(FluxQTable, [1, 1, nAng]);
TorqueTable3d = repmat(TorqueTable, [1, 1, nAng]);
```

**Why replicate:** Without FEA angle-resolved data, the tables are uniform over rotor position (no spatial harmonics). This produces a valid 3D dataset but won't capture cogging torque or torque ripple. Replace with angle-dependent FEA data when available.

---

## PTBS Flux-Based PMSM

### Purpose
Generate inverse flux maps: given (FluxD, FluxQ) → find (id, iq). Required by the Powertrain Blockset Flux-Based PMSM block.

### Inputs
| Variable | Dimensions | Units |
|---|---|---|
| `pmsm` | struct | MCB motor struct with PMSMLUT |
| `inverter` | struct | MCB inverter struct |

### Outputs
| Variable | Dimensions | Units |
|---|---|---|
| `data.FluxDVec` | `[1 × nFluxD]` | Wb |
| `data.FluxQVec` | `[1 × nFluxQ]` | Wb |
| `data.idTable` | `[nFluxD × nFluxQ]` | A |
| `data.iqTable` | `[nFluxD × nFluxQ]` | A |

### API Call
```matlab
data = mcb.generateMotorLUT(pmsm, inverter, 'ifuncflux');
```

This single call computes the inverse flux function. The MCB API handles the inversion internally.

### Validation
```matlab
assert(isvector(data.FluxDVec), 'FluxDVec must be a vector');
assert(isvector(data.FluxQVec), 'FluxQVec must be a vector');
assert(size(data.idTable, 1) == numel(data.FluxDVec), 'idTable rows must match FluxDVec length');
assert(size(data.idTable, 2) == numel(data.FluxQVec), 'idTable cols must match FluxQVec length');
```

### Block Configuration
```matlab
set_param(blk, ...
    'flux_d', 'data.FluxDVec', ...
    'flux_q', 'data.FluxQVec', ...
    'id', 'data.idTable', ...
    'iq', 'data.iqTable', ...
    'Rs', 'pmsm.Rs', ...
    'P', 'pmsm.p', ...
    'mechanical', '[pmsm.J, pmsm.B, 0]');
```

---

## PTBS Mapped Motor

### Purpose
Generate torque-speed envelope and loss maps for the PTBS Mapped Motor block.

### Inputs
| Variable | Dimensions | Units |
|---|---|---|
| `pmsm` | struct | MCB motor struct with PMSMLUT |
| `inverter` | struct | MCB inverter struct |

### Outputs
| Variable | Dimensions | Units | Notes |
|---|---|---|---|
| `data.w_t` | `[1 × 32]` | **rad/s** | Speed breakpoints (PTBS uses rad/s!) |
| `data.T_t` | `[1 × 32]` | N·m | Continuous torque envelope |
| `data.w_eff_bp` | `[1 × nSpeed]` | rad/s | Loss map speed breakpoints |
| `data.T_eff_bp` | `[1 × nTorque]` | N·m | Loss map torque breakpoints |
| `data.losses_table` | `[nSpeed × nTorque]` | W | Total loss (motor + inverter) |
| `data.efficiency` | `[nSpeed × nTorque]` | % | Efficiency map |

**Critical dimension note:** MCB's `generateMotorLUT` produces tables in `[nTorque × nSpeed]` format. PTBS expects `[nSpeed × nTorque]`. **Transpose is required.**

### Procedure

**Step 1: Compute torque-speed envelope**
```matlab
driveChar = mcb.PMSMCharacteristics(pmsm, inverter, ...
    'driveCharacteristics', 0, 'constraintCurves', 0);
driveChar.wArray(1) = 0;  % Fix NaN at zero speed

size_wgrid = 32;
wrpmVec = linspace(0, max(driveChar.wArray), size_wgrid);
Tenvelope = interp1(driveChar.wArray, driveChar.TArray, wrpmVec, 'linear', 0);
radpsVec = wrpmVec * pi / 30;  % Convert RPM → rad/s for PTBS
```

**Why `driveChar.wArray(1) = 0`:** The MCB API sometimes returns NaN for the first element (zero-speed singularity). Setting to 0 prevents NaN propagation in interpolation.

**Step 2: Generate id/iq LUT (positive torque only)**
```matlab
trefVec_pos = linspace(0, max(Tenvelope), 21);
pmsm_pos = pmsm;
pmsm_pos.PMSMLUT.trefVec = trefVec_pos;

seed.wrpmVec = wrpmVec;
seed.trefVec = trefVec_pos;
LUT = mcb.generateMotorLUT(pmsm_pos, inverter, 'idiqluts', seed, 'useTorquePercent', 0);
```

**Why positive torque only:** Loss maps are symmetric about zero torque (same copper loss for +T and -T). Computing only positive half saves computation; mirror for negative if needed.

**Step 3: Compute losses**

```matlab
% RMS current from peak dq currents
Irms = sqrt(LUT.idTable.^2 + LUT.iqTable.^2) / sqrt(2);
```
**Why `/ sqrt(2)`:** id and iq are peak values; RMS = peak / √2 for sinusoidal currents. Without this, losses would be 2× too high.

**Motor copper loss:**
```matlab
LossMotor = pmsm.Rs * 3 * Irms.^2;
```
**Why `* 3`:** Three phases, each with resistance Rs and current Irms.

**Inverter loss model:**
```matlab
% I_rated fallback
if isfield(pmsm, 'I_rated')
    I_rated = pmsm.I_rated;
else
    I_rated = inverter.ISenseMax / 2;  % ISenseMax is peak-to-peak ADC range
end

fixedLoss = 0.001 * inverter.V_dc * I_rated;
ks = 0.00205;    % Switching loss coefficient
kc1 = 0.333;    % Conduction loss linear coefficient
kc2 = 0.00133;  % Conduction loss quadratic coefficient
LossInv = fixedLoss + ks * inverter.V_dc * Irms + kc1 * Irms + kc2 * Irms.^2;
```

**Why `ISenseMax / 2`:** ISenseMax is the full ADC sensing range (bidirectional). Rated current is approximately half of this.

**Step 4: Transpose and assemble**
```matlab
LossTotal = (LossMotor + LossInv).';  % [nTorque × nSpeed] → [nSpeed × nTorque]
```

**Why transpose:** MCB produces `[nTorque × nSpeed]`. PTBS Mapped Motor block expects `[nSpeed × nTorque]`.

**Step 5: Efficiency map**
```matlab
lutRadpsVec = LUT.wrpmVec * pi / 30;
lutTrefVec = LUT.trefVec;
mechPower = lutRadpsVec(:) * abs(lutTrefVec(:))';  % [nSpeed × nTorque]
data.efficiency = 100 * mechPower ./ (mechPower + LossTotal);
data.efficiency(data.efficiency > 100 | isnan(data.efficiency)) = 0;
```

**Why clamp and NaN guard:** At zero speed, mechPower = 0, causing 0/0 = NaN. At very low loss points, numerical noise can produce >100%. Both are clamped to 0 to prevent downstream block errors.

**Note:** The standalone PTBS and Simscape converters use a single-line guard: `Eff(Eff > 100 | isnan(Eff)) = 0` (clamp everything invalid to 0). The full enriched pipeline uses a two-line guard that clamps >100 to 100 first, then <0/NaN to 0. Either approach is valid; the key requirement is no NaN or >100% values reach the block.

---

## Simscape Motor & Drive (System Level)

### Purpose
Generate torque-speed envelope, loss maps, and efficiency data for the Simscape Motor & Drive block.

### Block Path
```
ee_lib/Electromechanical/Motor & Drive (System Level)
```

### Key Difference from PTBS Mapped
**Simscape Motor & Drive uses RPM** (not rad/s) for the speed axis.

### Inputs
Same as PTBS Mapped Motor.

### Outputs
| Variable | Dimensions | Units | Notes |
|---|---|---|---|
| `data.w_t` | `[1 × 32]` | **RPM** | Speed breakpoints (NOT rad/s!) |
| `data.T_t` | `[1 × 32]` | N·m | Continuous torque envelope |
| `data.T_t_intermittent` | `[1 × 32]` | N·m | Peak/intermittent envelope (1.5× rated) |
| `data.torque_max` | scalar | N·m | Max torque at zero speed |
| `data.power_max` | scalar | W | Max power (at base speed) |
| `data.w_eff_vec` | `[1 × nSpeed]` | RPM | Loss map speed breakpoints |
| `data.T_eff_vec` | `[1 × nTorque]` | N·m | Loss map torque breakpoints |
| `data.losses_mat` | `[nSpeed × nTorque]` | W | Total loss |
| `data.efficiency_mat` | `[nSpeed × nTorque]` | % | Efficiency |

### Additional Steps (beyond PTBS Mapped)

**Intermittent envelope (peak torque at 1.5× rated current):**
```matlab
pmsm1 = pmsm;
pmsm1.I_rated = 1.5 * I_rated;
dcMax = mcb.PMSMCharacteristics(pmsm1, inverter, ...
    'driveCharacteristics', 0, 'constraintCurves', 0);
dcMax.wArray(1) = 0;
Tmaxenvelope = interp1(dcMax.wArray, dcMax.TArray, wrpmVec, 'linear', 0);
```

**Why 1.5×:** Intermittent rating is typically 150% of continuous for servo motors (thermal time constant allows short bursts).

**Power calculation:**
```matlab
data.power_max = driveChar.speed_milestone(1) * (pi/30) * Tenvelope(1);
```
`speed_milestone(1)` is the base speed (transition from constant-torque to constant-power region).

### Unit Convention Summary
| Block | Speed Unit | Torque Unit | Loss Table Orientation |
|---|---|---|---|
| PTBS Mapped Motor | rad/s | N·m | `[nSpeed × nTorque]` |
| Simscape Motor & Drive | RPM | N·m | `[nSpeed × nTorque]` |
| MCB generateMotorLUT output | RPM (wrpmVec) | N·m | `[nTorque × nSpeed]` — **must transpose!** |

---

## Full Enriched Pipeline

### Purpose
Single-pass computation of ALL data groups needed for every target block. Based on MCB Feature Workflow trackA4.

### Configuration Constants
```matlab
size_wgrid = 32;           % Speed breakpoints
size_tgrid = 21;           % Torque breakpoints (positive only)
size_tgrid_sym = 41;       % Symmetric torque grid (-Tmax to +Tmax)
size_tpct = 23;            % Percent-torque grid points
vdcFactors = [0.9, 1.1];  % Vdc sweep factors (±10% bus variation)
degCVec = [25, 75, 125];  % Temperature breakpoints (°C)
```

### Data Groups

#### Group CORE: Torque-Speed Envelope
Same as PTBS Mapped Step 1. Produces `wrpmVec`, `Tenvelope`, `Tmaxenvelope`, `speed_milestone`.

#### Group A: PTBS Flux-Based PMSM (inverse flux maps)
```matlab
dataFlux = mcb.generateMotorLUT(pmsm, inverter, 'ifuncflux');
```
Output: `dataFlux.FluxDVec`, `dataFlux.FluxQVec`, `dataFlux.idTable`, `dataFlux.iqTable`.

#### Group B: PTBS Flux-Based PM Controller
Requires:
- Positive-only id/iq LUT (transposed to `[nSpeed × nTorque]`)
- Negative-id flux data for controller FW region

```matlab
% Positive-only LUT
trefVec_pos = linspace(0, max(Tenvelope), size_tgrid);
pmsm_pos = pmsm;
pmsm_pos.PMSMLUT.trefVec = trefVec_pos;
seed_pos.wrpmVec = wrpmVec;
seed_pos.trefVec = trefVec_pos;
LUT_pos = mcb.generateMotorLUT(pmsm_pos, inverter, 'idiqluts', seed_pos, 'useTorquePercent', 0);

% Transpose for PTBS block format
idTableT = LUT_pos.idTable.';  % [nTorque × nSpeed] → [nSpeed × nTorque]
iqTableT = LUT_pos.iqTable.';
```

**Negative-id flux data (for field weakening region):**
```matlab
idVecFull = pmsm.PMSMLUT.idVec(:);
idNegMask = idVecFull <= 0;
idVecNeg = idVecFull(idNegMask)';
FluxDNeg = pmsm.PMSMLUT.FluxDTable(idNegMask, :);
FluxQNeg = pmsm.PMSMLUT.FluxQTable(idNegMask, :);
```

**Why filter id <= 0:** In field weakening, id is always negative (demagnetizing). The controller only needs the negative-id portion of the flux map.

#### Group C: 3D Voltage-Sweep LUTs
Computes id/iq tables at multiple DC bus voltages (for Vdc-adaptive control).

```matlab
vdcVec = vdcFactors * inverter.V_dc;  % e.g., [450, 550] for 500V bus

% Use 'idiqlutswt' mode for voltage-sweep-aware LUT
inv_1 = inverter;
inv_1.V_dc = vdcVec(1);
L1 = mcb.generateMotorLUT(pmsm, inv_1, 'idiqlutswt', baseLUT2d);
```

**Output dimensions:**
| Variable | Dimensions | Notes |
|---|---|---|
| `idTable3D_wtv` | `[nTorque × nSpeed × nVdc]` | MCB native orientation |
| `idTable3D_twv` | `[nSpeed × nTorque × nVdc]` | Transposed for PTBS |

Both orientations are stored because different blocks expect different layouts.

#### Group D: Percent-Torque LUTs
Torque reference as percentage of envelope (speed-dependent scaling).

```matlab
trefPctVec = linspace(-100, 100, size_tpct);

seed_pct.Tenvelope = Tenvelope;
seed_pct.wrpmVec = wrpmVec;
seed_pct.trefPctVec = trefPctVec;
LUT_pct = mcb.generateMotorLUT(pmsm, inverter, 'idiqluts', seed_pct, 'useTorquePercent', 1);
```

**Why percent-torque:** Some control architectures command torque as a percentage of the speed-dependent maximum. This ensures the motor always operates within its envelope regardless of speed.

**3D percent-torque (voltage sweep):**
```matlab
inv_1 = inverter;
inv_1.V_dc = vdcVec(1);
Lp1 = mcb.generateMotorLUT(pmsm, inv_1, 'idiqlutswt', LUT_pct, 'useTorquePercent', 1);
```

#### Group E: Simscape FEM 2D
No conversion — pass MCB PMSMLUT directly.

#### Group F: Simscape FEM 3D (dq0)
Same as [Simscape FEM 3D](#simscape-fem-3d-dq0) section above.

#### Groups G/H: Loss Maps (2D, 3D, 4D)

**Loss model** (same formulas as PTBS Mapped):
```matlab
Irms = sqrt(idLoss.^2 + iqLoss.^2) / sqrt(2);

% Inverter loss coefficients
invLoss.fixedLoss = 0.001 * inverter.V_dc * I_rated;
invLoss.ks  = 0.00205;   % Switching loss coefficient
invLoss.kc1 = 0.333;     % Conduction loss linear
invLoss.kc2 = 0.00133;   % Conduction loss quadratic

LossMotor = pmsm.Rs * 3 * Irms.^2;
LossInv = invLoss.fixedLoss + invLoss.ks * inverter.V_dc * Irms + ...
           invLoss.kc1 * Irms + invLoss.kc2 * Irms.^2;
LossTotal = (LossMotor + LossInv).';  % Transpose to [nSpeed × nTorque]
```

**Efficiency with guards:**
```matlab
mechPower = lutRadpsVec(:) * abs(lutTrefVec(:))';
EffTable = 100 * mechPower ./ (mechPower + LossTotal);
EffTable(EffTable > 100) = 100;
EffTable(EffTable < 0 | isnan(EffTable)) = 0;
```

**3D loss (temperature dimension):**
```matlab
degCVec = [25, 75, 125];
nTemp = numel(degCVec);
LossTbl3d = repmat(LossTotal, [1, 1, nTemp]);  % [nSpeed × nTorque × nTemp]
```
Replicated (no thermal model) — replace with temperature-dependent Rs for thermal accuracy.

**4D loss (temperature + voltage):**
```matlab
nV = numel(vdcVec);
LossTbl4d = repmat(LossTbl3d, [1, 1, 1, nV]);  % [nSpeed × nTorque × nTemp × nVdc]
```

**Simscape 3D variant (voltage, no temperature):**
```matlab
LossTbl3d_simscape = repmat(LossTotal, [1, 1, nV]);  % [nSpeed × nTorque × nVdc]
```

### Output Structure Map

```
enrichedPMSM
├── twenvelope
│   ├── wrpmVec          [1 × 32] RPM
│   ├── vdcVec           [1 × nVdc] V
│   └── speed_milestone  [1 × N] RPM
├── twenvelope1d
│   ├── Tenvelope        [1 × 32] N·m (continuous)
│   └── Tmaxenvelope     [1 × 32] N·m (intermittent)
├── fluxbasedpmsm (Group A)
│   ├── FluxDVec         [1 × nFluxD] Wb
│   ├── FluxQVec         [1 × nFluxQ] Wb
│   ├── idTable          [nFluxD × nFluxQ] A
│   └── iqTable          [nFluxD × nFluxQ] A
├── fluxbasedPMCtrl (Group B)
│   ├── idVecNeg         [1 × nIdNeg] A (≤ 0 only)
│   ├── FluxDNeg         [nIdNeg × nIq] Wb
│   ├── FluxQNeg         [nIdNeg × nIq] Wb
│   ├── wrpmVec          [1 × 32] RPM
│   ├── trefVec          [1 × 21] N·m
│   ├── idTableT         [nSpeed × nTorque] A (transposed!)
│   └── iqTableT         [nSpeed × nTorque] A (transposed!)
├── PMSMLUT3dwtv (Group C — MCB orientation)
│   ├── idTable          [nTorque × nSpeed × nVdc] A
│   └── iqTable          [nTorque × nSpeed × nVdc] A
├── PMSMLUT3dtwv (Group C — PTBS orientation)
│   ├── idTable          [nSpeed × nTorque × nVdc] A
│   └── iqTable          [nSpeed × nTorque × nVdc] A
├── PMSMLUTpct (Group D — 2D percent-torque)
│   ├── trefPctVec       [1 × 23] %
│   ├── idTable          [nPct × nSpeed] A
│   └── iqTable          [nPct × nSpeed] A
├── PMSMLUTpct3d (Group D — 3D percent-torque + voltage)
│   ├── idTable          [nPct × nSpeed × nVdc] A
│   └── iqTable          [nPct × nSpeed × nVdc] A
├── PMSMLUT (Groups E/F — Simscape FEM + symmetric MCB LUT)
│   ├── angDegVec        [1 × 7] deg
│   ├── FluxDTable       [nId × nIq] Wb
│   ├── FluxQTable       [nId × nIq] Wb
│   ├── TorqueTable      [nId × nIq] N·m
│   ├── FluxDTable3d     [nId × nIq × nAng] Wb
│   ├── FluxQTable3d     [nId × nIq × nAng] Wb
│   ├── TorqueTable3d    [nId × nIq × nAng] N·m
│   ├── trefVec          [1 × 41] N·m (symmetric)
│   ├── wrpmVec          [1 × 32] RPM
│   ├── vdcVec           [1 × nVdc] V
│   ├── idTable          [nTorque × nSpeed] A
│   └── iqTable          [nTorque × nSpeed] A
├── LossMap (Groups G/H — breakpoints)
│   ├── radpsVec         [1 × nSpeed] rad/s
│   ├── trefVec          [1 × nTorque] N·m
│   ├── degCVec          [1 × 3] °C
│   └── vdcVec           [1 × nVdc] V
├── LossMap2d
│   ├── LossTbl          [nSpeed × nTorque] W
│   └── EffTbl           [nSpeed × nTorque] %
├── LossMap3dptbs
│   └── LossTbl          [nSpeed × nTorque × nTemp] W
├── LossMap3dsimscape
│   └── LossTbl          [nSpeed × nTorque × nVdc] W
└── LossMap4dptbs
    └── LossTbl          [nSpeed × nTorque × nTemp × nVdc] W
```

---

## MCB API Reference (used by converters)

| Function | Mode | Purpose | Key Output Fields |
|---|---|---|---|
| `mcb.PMSMCharacteristics(pmsm, inv, 'driveCharacteristics', 0, 'constraintCurves', 0)` | — | Torque-speed envelope | `.wArray` (RPM), `.TArray` (N·m), `.speed_milestone` |
| `mcb.generateMotorLUT(pmsm, inv, 'ifuncflux')` | Inverse flux | Flux → current maps | `.FluxDVec`, `.FluxQVec`, `.idTable`, `.iqTable` |
| `mcb.generateMotorLUT(pmsm, inv, 'idiqluts', seed, 'useTorquePercent', 0)` | id/iq LUT | Torque/speed → optimal id,iq | `.idTable`, `.iqTable`, `.wrpmVec`, `.trefVec` |
| `mcb.generateMotorLUT(pmsm, inv, 'idiqluts', seed, 'useTorquePercent', 1)` | Percent LUT | %Torque/speed → id,iq | Same as above, tref in % |
| `mcb.generateMotorLUT(pmsm, inv, 'idiqlutswt', baseLUT)` | Voltage sweep | id/iq at different Vdc | `.idTable`, `.iqTable` (recomputed at new Vdc) |

### Seed Struct Fields
```matlab
seed.wrpmVec = [...];    % Speed breakpoints (RPM)
seed.trefVec = [...];    % Torque breakpoints (N·m or %)
seed.Tenvelope = [...];  % Only for percent-torque mode
seed.trefPctVec = [...]; % Only for percent-torque mode
```

---

## Dimension Convention Summary

| Source | Native Orientation | Target Block | Required Orientation | Action |
|---|---|---|---|---|
| MCB `generateMotorLUT` | `[nTorque × nSpeed]` | PTBS Mapped Motor | `[nSpeed × nTorque]` | **Transpose** |
| MCB `generateMotorLUT` | `[nTorque × nSpeed]` | Simscape Motor & Drive | `[nSpeed × nTorque]` | **Transpose** |
| MCB `generateMotorLUT` | `[nTorque × nSpeed]` | MCB LUT Reference | `[nTorque × nSpeed]` | None |
| MCB PMSMLUT tables | `[nId × nIq]` | Simscape FEM 2D | `[nId × nIq]` | None |
| MCB PMSMLUT tables | `[nId × nIq]` | Simscape FEM 3D | `[nId × nIq × nAng]` | Replicate dim 3 |
| `mcb.generateMotorLUT('ifuncflux')` | `[nFluxD × nFluxQ]` | PTBS Flux-Based | `[nFluxD × nFluxQ]` | None |

---

## Common Gotchas

1. **Speed units:** PTBS uses rad/s. Simscape Motor & Drive uses RPM. MCB API returns RPM. Always convert explicitly: `radps = rpm * pi / 30`.

2. **idVec orientation:** MCB stores `idVec` as a column vector `[nId×1]`, while `iqVec` is a row `[1×nIq]`. Both `ndgrid` and Simscape blocks accept either orientation, but be aware when indexing or constructing grids.

3. **LUT output grid size:** `mcb.generateMotorLUT` may return MORE speed points than the seed requested (e.g., 64 vs 32). Always use `LUT.wrpmVec` (the actual output grid) for downstream computations, not the seed vector.

2. **Transpose requirement:** MCB produces `[nTorque × nSpeed]`. PTBS and Simscape expect `[nSpeed × nTorque]`. A missing `.'` produces silently wrong results (axes swapped, no error).

3. **ndgrid vs meshgrid:** For flux computation from inductance tables, use `ndgrid` to preserve `[nId × nIq]` layout. `meshgrid` transposes the grid.

4. **NaN at zero speed:** `mcb.PMSMCharacteristics` may return NaN for `wArray(1)`. Always set `wArray(1) = 0` before interpolation.

5. **I_rated fallback:** Not all pmsm structs have `I_rated`. Use `inverter.ISenseMax / 2` as fallback (ISenseMax is bidirectional ADC range).

6. **Loss coefficients are empirical:** `ks=0.00205`, `kc1=0.333`, `kc2=0.00133` are generic inverter loss estimates. Replace with datasheet values for specific hardware.

7. **Replicated 3D/4D tables:** Temperature and angle dimensions are replicated (uniform) when FEA or thermal data isn't available. These are placeholder structures — replace individual slices with measured data when available.

8. **Efficiency guard conditions:** Always clamp >100% and NaN values to 0 after computing efficiency. Zero-speed and zero-torque entries will produce division artifacts.

----
Copyright 2026 The MathWorks, Inc.
----
