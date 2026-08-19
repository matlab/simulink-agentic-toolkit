# PMSMLUT Structure & FEA Data Import

> Reference for nonlinear motor data format, FEA import pipeline, and validation.
> For gain scheduling workflow, see `workflows/wf-nonlinear-motor-commissioning.md`.
> For model configuration, see `configurations/nonlinear-gain-scheduled.md`.

---

## PMSMLUT Structure (MCB Standard Format)

```matlab
pmsm.PMSMLUT.idVec       % [nId x 1] d-axis current breakpoints (A), negative-to-zero
pmsm.PMSMLUT.iqVec       % [1 x nIq] q-axis current breakpoints (A), zero-to-positive
pmsm.PMSMLUT.LdTable     % [nId x nIq] d-axis inductance (H) — f(id, iq)
pmsm.PMSMLUT.LqTable     % [nId x nIq] q-axis inductance (H) — f(id, iq)
pmsm.PMSMLUT.FluxPMTable % [nId x nIq] PM flux linkage (Wb) — f(id, iq)
```

**Convention**: Tables indexed as `Table(id_index, iq_index)` = `[nId x nIq]`.
- `idVec` is column vector (negative-to-zero for IPMSM)
- `iqVec` is row vector (zero-to-positive)

### Control Reference LUT Fields (for LUT Control Reference block)

```matlab
pmsm.PMSMLUT.trefVec     % [1 x nT] torque reference breakpoints (Nm or PU)
pmsm.PMSMLUT.wrpmVec     % [1 x nW] speed breakpoints (RPM or PU)
pmsm.PMSMLUT.idTable     % [nT x nW] optimal id* at each (torque, speed) point
pmsm.PMSMLUT.iqTable     % [nT x nW] optimal iq* at each (torque, speed) point
```

---

## FEA Data Import Pipeline

### Step 1: Load FEA Export

FEA tools (JMAG, ANSYS Maxwell, MotorCAD) export flux linkage maps.

```matlab
% Typical FEA export: CSV with [id, iq, psi_d, psi_q, torque]
data = readmatrix('fea_export.csv');
id_raw = data(:,1); iq_raw = data(:,2);
psi_d_raw = data(:,3); psi_q_raw = data(:,4);

% Reshape to grid
idVec = unique(id_raw);  % Column vector
iqVec = unique(iq_raw)'; % Row vector
nId = numel(idVec); nIq = numel(iqVec);
psi_d = reshape(psi_d_raw, nId, nIq);  % [nId x nIq]
psi_q = reshape(psi_q_raw, nId, nIq);
```

### Step 2: Convert Flux Linkage to Inductance

```matlab
[ID_grid, IQ_grid] = ndgrid(idVec, iqVec);  % [nId x nIq]

% PM flux linkage (from zero-current intercept)
% At id=0, iq=0: psi_d = FluxPM (since psi_d = Ld*id + FluxPM)
FluxPM0 = psi_d(idVec==0, iqVec==0);  % Scalar — PM flux at no load

% Simple approach: assume FluxPM ≈ constant across operating range
% (For highly saturated motors, FluxPM varies — use mcb.generateMotorLUT instead)
FluxPMTable = FluxPM0 * ones(nId, nIq);

% Apparent inductance (with constant FluxPM assumption):
LdTable = (psi_d - FluxPMTable) ./ ID_grid;
LqTable = psi_q ./ IQ_grid;

% Handle singularities at id=0 or iq=0
idx_id0 = find(idVec==0);
idx_iq0 = find(iqVec==0);
if ~isempty(idx_id0) && idx_id0 > 1
    % Use point adjacent to zero (one step into negative id)
    LdTable(idx_id0, :) = (psi_d(idx_id0-1,:) - FluxPM0) / idVec(idx_id0-1);
end
if ~isempty(idx_iq0) && idx_iq0 < nIq
    % Use point adjacent to zero (one step into positive iq)
    LqTable(:, idx_iq0) = psi_q(:, idx_iq0+1) / iqVec(idx_iq0+1);
end
```

**Note:** For production-quality FEA import, use `mcb.generateMotorLUT` which handles the FluxPM extraction internally. The manual approach above is for understanding or when the API is unavailable.

### Step 3: Validate

```matlab
assert(issorted(idVec), 'idVec must be sorted ascending');
assert(issorted(iqVec), 'iqVec must be sorted ascending');
assert(isequal(size(LdTable), [nId, nIq]), 'LdTable size mismatch');
assert(all(LdTable(:) > 0 & LdTable(:) < 1), 'Ld out of range [0,1] H');
assert(all(LqTable(:) > 0 & LqTable(:) < 1), 'Lq out of range [0,1] H');
```

---

## Apparent vs Incremental Inductance

| Type | Formula | Use |
|------|---------|-----|
| **Apparent** | `L_app = psi / i` | Torque computation, PMSMLUT tables, flux linkage |
| **Incremental** | `L_inc = dpsi / di` | **PI controller tuning** (plant transfer function) |

At heavy saturation: `L_inc << L_app` — using apparent L gives wrong PI bandwidth.

---

## MCB API for LUT Generation

```matlab
% Primary API — generates MTPA/FW/MTPV trajectories:
outSt = mcb.generateMotorLUT(pmsm, inverter, "idiqLUTs");
% Purpose strings (verified R2025+): "idiqLUTs", "idiqLUTsinit", "idiq3dLUTs",
%   "idiq3dLUTsinit", "Star2Star", "Star2Delta"
% Output: outSt with id/iq reference tables

% Operating-point linearization (for PI tuning at specific point):
pmsm_op = mcb.updatePMSMLdLqFluxPM(pmsm, pmsm.PMSMLUT, id_op, iq_op, 1);
PI = mcb.calcFOCGains(pmsm_op, Ts, Ts_speed);
```

---

## MCB Interior PMSM Block Configuration (Nonlinear Mode)

```matlab
set_param(blk, 'nonLinearityChoice', 'Non-linear model with Ld, Lq, and FluxPM LUTs');
set_param(blk, 'idVec', 'pmsm.PMSMLUT.idVec');
set_param(blk, 'iqVec', 'pmsm.PMSMLUT.iqVec');
set_param(blk, 'LdTable', 'pmsm.PMSMLUT.LdTable');
set_param(blk, 'LqTable', 'pmsm.PMSMLUT.LqTable');
set_param(blk, 'FluxPMTable', 'pmsm.PMSMLUT.FluxPMTable');
```

---

## SynRM / PMASynRM Notes

- **SynRM**: FluxPM=0, torque from reluctance only (`Te = 1.5*p*(Ld-Lq)*id*iq`)
- Set `FluxPMTable = zeros(nId, nIq)` or `pmsm.FluxPM = 1e-6` (avoid exact 0)
- `mcb.generateMotorLUT` may fail for pure SynRM (Ld > Lq) — see `wf-nonlinear-motor-commissioning.md` for manual workaround
- HFI works well for SynRM (high saliency); back-EMF observers fail at low speed

---

## Common Mistakes

1. **Table orientation**: MCB expects `[nId x nIq]` — rows=id, cols=iq. FEA tools may export transposed.
2. **Singularity at zero current**: `L = psi/i` undefined at `i=0`. Extrapolate or use linear value.
3. **Using apparent L for PI tuning**: Must use incremental L for correct bandwidth.
4. **Cross-saturation ignored**: FluxPMTable varies with BOTH id AND iq in saturated machines.
5. **Wrong units**: FEA may export mH or mWb — MCB needs H and Wb.

---

## See Also

- `workflows/wf-nonlinear-motor-commissioning.md` — full pipeline from FEA to running model
- `configurations/nonlinear-gain-scheduled.md` — model architecture for gain scheduling
- `shared/gain-formulas.md` § Gain Scheduling LUTs — incremental inductance PI formulas
- MCB example: `PMSMGainSchedulingExample` (mcb-ex93682944)

----
Copyright 2026 The MathWorks, Inc.
----
