# RF Impairment Catalog

Add realistic impairments to Circuit Envelope models with `model_edit` `configure` after `release(rfs)`.
Each impairment is added independently so its system impact can be measured in isolation.

## General Pattern

1. `release(rfs);` -- REQUIRED: Fast Restart locks non-tunable params.
2. `model_edit` `configure` on `rfs.ModelName` (block ID from `model_read`; pass the JSON on one
   line). The JSON snippets below are this operation; it applies parameters one at a time, in the order given, so a parameter
that depends on another goes after it.
3. `save_system(rfs.ModelName); y = rfs(x);` -- re-initializes with the new params.

```json
[{"op":"configure","target":"<block id>","params":{"ParamName":"value"}}]
```

If no rfsystem object exists (model loaded via `load_system` only), configure it directly.

## 1. Phase Noise

**Available on:** CW Source, Modulator, IQ Modulator, IQ Demodulator, IMT Mixer

```json
[{"op":"configure","target":"<Mixer id>","params":{"AddPhaseNoise":"on",
  "PhaseNoiseOffset":"[1e3 1e4 1e5 1e6]","PhaseNoiseLevel":"[-80 -100 -120 -140]"}}]
```

**NOT available on:** Amplifier, Mixer (simrfV2elements/Mixer), Filter. Phase noise enters
through source or modulator blocks only.

**Typical VCO values (2.4 GHz):** -80/-100/-120/-140 dBc/Hz at 1k/10k/100k/1M Hz offsets.

**Verifying phase noise fidelity (no simulation needed):**

The block's built-in `simrfV2_plot_pn_chars` shows the solver's actual FIR filter
response overlaid against your specified profile. Set all params (`configure`, as above)
and save BEFORE opening the dialog:

```matlab
save_system(mdl);

% Open dialog and plot
old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(blk);
simrfV2_plot_pn_chars(simrfV2_find_dialog(blk).getDialogSource);
cd(old);
% xlabel includes "Resolution=XXX Hz" (actual solver resolution)
exportgraphics(gcf, fullfile(tempdir, 'ce_phase_noise.png'), 'Resolution', 150);
```

## 2. IQ Imbalance

**Available on:** IQ Modulator, IQ Demodulator

`GainMismatch` (dB between I and Q), `PhaseMismatch` (degrees from 90), `Isolation`
(LO-to-RF leakage, dB -> DC offset):

```json
[{"op":"configure","target":"<IQDemod id>","params":{"GainMismatch":"1","PhaseMismatch":"3",
  "Isolation":"25"}}]
```

**Internal parameter readback:** after the model compiles (one `model_query_params` call with
`compile` = `true`), the block's mask workspace contains compiled internal parameters. Read them
with `model_resolve_params`, e.g. expressions `["iqDemodParams.MixerI.Gain", "iqDemodParams.MixerQ.Gain"]`
(per-path gain in dB; Q differs by `GainMismatch`: 3.01 and 4.01 for `GainMismatch` = 1).
`["iqDemodParams"]` lists the fields (`MixerI`, `MixerQ`, `R_IsolationI`, `R_IsolationQ`, `LO`,
`PhaseShifter`).

## 3. PA Nonlinearity

### Option A: Polynomial (memoryless)

Two `configure` operations, the mode first (`Poly_Coeffs` = `[c1, c3, c5]`; before R2026b
also set `"Source_Poly":"Odd order"` in the second):

```json
[{"op":"configure","target":"<PA id>","params":{"Source_linear_gain":"Polynomial coefficients"}},
 {"op":"configure","target":"<PA id>","params":{"Poly_Coeffs":"[10, -0.01, 0.0001]"}}]
```

**R2026b:** `Source_Poly` parameter removed. Set odd-order directly.

**Visualization limitation:** The mask "Plot Power Characteristics" button
(`simrfV2plotpolynumerial`) is NOT available for Polynomial or AM/PM table modes --
only for IP3 mode. For polynomial mode, compute the power sweep analytically:

```matlab
coeffs = str2num(get_param([mdl '/PA'], 'Poly_Coeffs')); %#ok<ST2NM>
Pin_dBm = -50:0.5:30;
Vin = sqrt(2 * 10.^((Pin_dBm-30)/10) * 50);
A_out = coeffs(1)*Vin;
if numel(coeffs)>=2, A_out = A_out + (3/4)*coeffs(2)*Vin.^3; end
if numel(coeffs)>=3, A_out = A_out + (10/16)*coeffs(3)*Vin.^5; end
Pout_dBm = 10*log10(A_out.^2/(2*50)*1000);
plot(Pin_dBm, Pout_dBm - Pin_dBm); xlabel('Pin (dBm)'); ylabel('Gain (dB)');
exportgraphics(gcf, fullfile(tempdir, 'ce_pa_power_char.png'), 'Resolution', 150);
```

### Option B: AM/AM + AM/PM Table (on rfbudget amplifier)

```matlab
% Set at rfbudget level (before export)
pa = amplifier(Name='PA', Model='ampm', ...
    AMPMTable=[-30 -15 0; -20 -5 0.5; -10 4 2; 0 10 5; 5 12 10]);
```

### Option C: Power Amplifier Block (memory polynomial)

Replace the Amplifier with a Power Amplifier with one `model_edit` `replace_block`, which
keeps the connections (`CoeffMatrix` names a `[memoryDepth x polynomialDegree]` workspace
variable):

```json
[{"op":"replace_block","target":"<PA id>","type":"simrfV2elements/Power Amplifier",
  "params":{"CoeffMatrix":"coeffs","Rin":"50","Rout":"50"}}]
```

## 4. Mixer Spur Table (IMT)

**Available on:** IMT Mixer (`simrfV2elements/IMT Mixer`)

IMT matrix: Rows = RF harmonics (0,1,2,...), Cols = LO harmonics (0,1,2,...).
Values = suppression in dB (all >= 0). Position (2,2) = desired output = 0.

```matlab
% From datasheet: 2x1 at -35 dBc, 1x2 at -40 dBc
imt = [99  99  99  99  99;    % 0xRF
       99   0  40  99  99;    % 1xRF: 1x1=0(desired), 1x2=40
       99  35  50  99  99;    % 2xRF: 2x1=35, 2x2=50
       99  45  99  99  99;    % 3xRF: 3x1=45
       99  99  99  99  99];   % 4xRF
```

Configure `UserSpurValues` with the matrix as a string (`mat2str(imt)`):

```json
[{"op":"configure","target":"<IMTMixer id>","params":{"UserSpurValues":
  "[99 99 99 99 99;99 0 40 99 99;99 35 50 99 99;99 45 99 99 99;99 99 99 99 99]"}}]
```

Convert datasheet dBc to suppression: `-35 dBc` -> `35`.

**Key insight for commensurate RF/LO:** When `fRF/fLO` is a ratio of small integers
(e.g., 4:3), different (m,n) products produce the same output frequency. The total
interference is the **linear power sum** (not dB sum). Only the built-in plot reveals
which products overlap.

### IMT Spur Visualization and Extraction

`simrfV2dlg_mixerimt_plot` creates a frequency-resolved Stem plot showing where each
spur product lands at its actual output frequency. Each non-suppressed product appears
TWICE -- once for the lower sideband (`|m*fRF - n*fLO|`) and once for the upper
sideband (`m*fRF + n*fLO`). The figure has 2 Stem objects: red (spurs + desired image)
and blue (desired IF).

```matlab
% Invoke built-in IMT spur plot
blk = [mdl '/IMTMixer'];
old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(blk);
pause(0.5);
dlg = simrfV2_find_dialog(blk);
simrfV2dlg_mixerimt_plot(blk, dlg);
cd(old);

% Read spur frequencies and levels from Stem data
fig = findall(0, 'Name', blk);
stems = findobj(fig, 'Type', 'Stem');
spurStem = stems(strcmp(get(stems, 'Color'), 'r') | ...
    cellfun(@(c) isequal(c, [1 0 0]), get(stems, 'Color')));
freqs = get(spurStem, 'XData');   % GHz
levels = get(spurStem, 'YData');  % dBc

% Identify overlapping products (same frequency, multiple stems)
[uniqueF, ~, ic] = unique(round(freqs, 3));
for k = 1:numel(uniqueF)
    mask = ic == k;
    if sum(mask) > 1
        individual = levels(mask);
        totalPower = 10*log10(sum(10.^(individual/10)));
        fprintf('Overlap at %.2f GHz: [%s] dBc -> total %.1f dBc\n', ...
            uniqueF(k), num2str(individual), totalPower);
    end
end
```

## 5. Antenna Pattern and Polarization

**Available on:** Antenna block (`simrfV2elements/Antenna`)

```matlab
% Design antenna at operating frequency
patchAnt = design(patchMicrostrip, 2.4e9);
sparameters(patchAnt, 2.4e9);  % MUST analyze before block use
assignin('base', 'patchAnt', patchAnt);
```

Attach it to the receive antenna:

```json
[{"op":"configure","target":"<RxAnt id>","params":{"AntennaSource":"Antenna object",
  "AntennaObj":"patchAnt","CarrierFreqInc":"2.4","CarrierFreqInc_unit":"GHz",
  "rArr":"[45 30]","rArr_unit":"deg"}}]
```

**Critical:** Design frequency must match system LO. Analyze antenna before block use.

**Direction params are completely separate:**
- Transmitter: `CarrierFreqRad` + `rDep` (radiation/departure)
- Receiver: `CarrierFreqInc` + `rArr` (incidence/arrival)

## 6. Filter Redesign (IR/CS)

Replace ideal internal filters in IQ Mod/Demod with designed implementations:

```json
[{"op":"configure","target":"<IQDemod id>","params":{"AddIRFilter":"on",
  "ResponseTypeIR":"Lowpass","DesignMethodIR":"Butterworth","ImplementationIR":"LC Tee",
  "PassFreq_lp_unitIR":"MHz","PassFreq_lpIR":"25","StopFreq_lp_unitIR":"MHz",
  "StopFreq_lpIR":"50"}}]
```

**Filter param plurality:** IQ Mod has `AddIRFilters` (plural); IQ Demod has `AddIRFilter`
(singular). Check which block you're configuring.

## 7. Dispersion / Modeling Options

**Available on:** any block with S-parameter data.

- `SparamRepresentation = 'Time domain'` (default): rational-fit IIR, fast but can ring
- `SparamRepresentation = 'Frequency domain'`: FFT-based, always stable, slower
- `MagModeling = 'on'`: ignores phase, models only |S(f)|

Max impulse bins: 2048 (shared across all blocks, must be power of 2).

## Key Gotchas

- **`_unit` companion parameters:** Always check for `<param>_unit`. Default units are
  often non-obvious (e.g., frequency defaults to GHz after export, not Hz).
- **Mode-switch params first:** Set `Source_linear_gain` to `'Polynomial coefficients'`
  BEFORE setting `Poly_Coeffs`.
- **IP3 parameter is `'IP3'`** -- not `'OIP3'` or `'IIP3'`. Reference direction controlled
  by `IPType` (`'Output'` or `'Input'`).
- **Boolean params are strings:** `'on'`/`'off'`
- **Workspace variables as strings:** `AntennaObj`, `CoeffMatrix` take variable NAME as string.

## Built-in Visualization

All require: `open_system(blk)` first, then `cd` to private directory:

```matlab
open_system(blk);
old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
dlg = simrfV2_find_dialog(blk);
```

| Function | Call | Purpose |
|----------|------|---------|
| `simrfV2_plot_pn_chars` | `fn(dlg.getDialogSource)` | Phase noise filter response |
| `simrfV2plotparam` | `fn(blk, dlg)` | S-parameter fit |
| `simrfV2plotpolynumerial` | `fn(blk, dlg)` | PA power characteristics |
| `simrfV2plotfilter` | `fn(blk, dlg)` | Filter frequency response |
| `simrfV2dlg_mixerimt_plot` | `fn(blk, dlg)` | IMT spur chart |

### Amplifier S-parameter Fit Visualization

`simrfV2plotparam` creates a figure named with the block path. Lines have DisplayNames
like `"dB(S_{2,1} fit)"` (rational fit) and `"dB(S_{2,1})"` (original data).

```matlab
blk = [mdl '/LNA'];
open_system(blk);
old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
dlg = simrfV2_find_dialog(blk);
simrfV2plotparam(blk, dlg);
cd(old);

% Extract line data
fig = findall(0, 'Name', blk);
lines = findall(fig, 'Type', 'line');
for k = 1:numel(lines)
    dn = get(lines(k), 'DisplayName');  % e.g., "dB(S_{2,1} fit)"
    xdata = get(lines(k), 'XData');     % GHz
    ydata = get(lines(k), 'YData');     % dB
end
```

**Critical:** The block does not use `rationalfit` internally. Do not use `rationalfit`
to reproduce or verify the block's fit — re-invoke `simrfV2plotparam` after changing
`MaxPoles`/`FitTol` to see the actual result.

**Note:** S2P file parameter is `'File'` (not `FileName`). For files with noise data,
set `'NoiseType'` to `'Spot noise data'`.

## Gotchas (duplicated here for convenience)

- **release(rfs) BEFORE configure.** Fast Restart locks non-tunable parameters while
  rfsystem is initialized. Always `release(rfs)` before ANY model edit.
- **Mode-switch params FIRST.** Set `Source_linear_gain` to `'Polynomial coefficients'`
  BEFORE setting `Poly_Coeffs` (a separate, earlier `configure` operation). Wrong order ->
  parameter silently ignored.
- **`_unit` companion parameters.** Default frequency is often GHz (not Hz) after export.
  Setting `'10e6'` without changing unit from GHz -> 10,000,000 GHz. Always check the
  `<param>_unit` companion (`model_query_params`) and set unit explicitly alongside value.
- **IP3 parameter is `'IP3'`** -- not `'OIP3'` or `'IIP3'`. Direction is controlled by
  `IPType` (`'Output'` or `'Input'`).
- **Antenna object must be analyzed before block use.** After `design()`, call
  `sparameters(antObj, freq)` or similar. Without analysis, mask fails with
  "Antenna object is either newly-created or has changed."
- **Mid-circuit power observation.** If you add an Outport to verify impairment effect,
  use `SensorType='Ideal voltage'` with `ZL='Inf'`. A Power sensor (ZL=50) mid-circuit
  adds a shunt load that changes the gain/impedance of the entire chain.
- **Phase noise bins shared constraint.** S-param impulse max 2048 bins (power of 2,
  shared across ALL blocks). One element requesting many bins slows the entire model.

----

Copyright 2026 The MathWorks, Inc.

----
