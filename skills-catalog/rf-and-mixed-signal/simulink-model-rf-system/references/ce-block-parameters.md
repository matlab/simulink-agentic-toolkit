# CE Block Parameters for Impairment Configuration

Exact parameter names for configuring impairments on Circuit Envelope blocks with `model_edit`
`configure`. All values are strings. `configure` applies parameters one at a time, in the order given, so a parameter
that depends on another goes after it (mode selectors such as
`Source_linear_gain` first).

## S-parameters block — Noise

The S-parameters block computes noise from **Bosma's theorem** (thermal noise of a passive network derived from its S-matrix). This requires the network to be passive. If S-param data is non-passive: noise is ignored and a warning appears. If a rational fit of passive data produces a non-passive model, the block internally attempts passivity enforcement and issues a warning.

The block's data check is stricter than `ispassive`. Data with a lossless point, where the largest singular value is exactly 1 (which `makepassive` leaves at 1), is still rejected with `DataNotPassive`, and noise stays off even though `AddNoise` shows on. To fix this, scale the S-matrix by about `(1-1e-6)`, write a new Touchstone file and load that. Confirm it with a model update: `DerivedNoiseNotPassive` (the fit's noise is repaired) or no warning means noise is simulated.

**No user-specified noise parameters** — noise is entirely determined by the S-matrix and temperature.

**Colored noise modeling:** Even when the S-param signal path uses a rational model (Time domain), colored noise is always modeled using FFT-based frequency-domain filters. The noise frequency grid is a union of constant log-scale points + the S-param data frequency points. Therefore, if high-frequency-resolution colored noise shaping is important (e.g., near a filter edge), the S-param data must contain enough frequency points in that region of interest.

---

## Amplifier (`simrfV2elements/Amplifier`)

**Which parameters are live.** `Source_linear_gain` selects how gain is specified (`Available power
gain`, `Open circuit voltage gain`, `Data source`, `Polynomial coefficients`, `AM/AM-AM/PM table`).
`DataSource`/`File` are used only with `Data source`. Every Amplifier carries the defaults
`DataSource='Data file'` and `File='unitygain.s2p'`, so finding them in a `MaskNames`/`MaskValues`
dump doesn't mean the block uses a file. With `Available power gain` (and the other non-data
sources), `Zin`/`Zout` set the port impedances. Read the controlling parameter's value
(`Source_linear_gain`); `MaskVisibilities` doesn't reliably track the active mode after a
change.

### Nonlinearity

| Parameter | Values | Notes |
|-----------|--------|-------|
| `Source_linear_gain` | `'Available power gain'` \| `'Open circuit voltage gain'` \| `'Data source'` \| `'Polynomial coefficients'` \| `'AM/AM-AM/PM table'` | Switches nonlinearity model |
| `linear_gain` | `'20'` | Gain in dB (when Available power gain) |
| `linear_gain_unit` | `'dB'` \| `'None'` | |
| `Poly_Coeffs` | `'[10, -0.01, 0.0001]'` | Polynomial coefficients (complex voltage) |
| `Source_Poly` | `'Even and odd order'` \| `'Odd order'` | **Critical**: controls polynomial order and which constraints are used |
| `AmAmAmPmTable` | `'[-30 -15 0; -20 -5 0.5; ...]'` | [Pin_dBm, Pout_dBm, Phase_deg] per row |
| `IPType` | `'Output'` \| `'Input'` | IP convention — applies to BOTH IP3 and P1dB |
| `IP2` | `'40'` | 2nd-order intercept point (dBm) |
| `IP3` | `'30'` | 3rd-order intercept point (dBm) |
| `P1dB` | `'20'` | 1-dB compression point (dBm) — follows IPType convention |
| `Psat` | `'25'` | Output saturation power (dBm) — always output-referred regardless of IPType |
| `Gcomp` | `'3'` | Gain compression at saturation (dBW, NOT dBm!) |
| `ConstS21NL` | `'on'` \| `'off'` | Use nonlinearity only near OpFreq |
| `OpFreq` | `'2.4e9'` | Operating frequency for NL extraction |

#### Source_Poly modes and polynomial fitting

The `Source_Poly` parameter controls which nonlinearity constraints participate in the internal polynomial fit:

- **`'Even and odd order'`**: Fits a **3rd-order** polynomial using only IP2 and IP3. P1dB, Psat, and Gcomp are ignored by the polynomial — they only act as runtime saturation clamps during simulation.
- **`'Odd order'`**: Fits a **5th-order** polynomial using IP3, P1dB, Psat, and Gcomp (all odd-order constraints). This creates a more realistic compression curve where P1dB can differ from the analytical IP3-only prediction.

**Key implication**: When `Source_Poly = 'Odd order'` and you set P1dB to a value lower than the analytical IP3-only P1dB (~OIP3 - 9.6 dB), the polynomial will show harder saturation than a pure 3rd-order model predicts. This is only visible in the built-in power characteristics plot — analytical calculations from IP3 alone will give the wrong compression point.

**Over-constraining warning**: Setting too many constraints simultaneously (IP3 + P1dB + Psat + Gcomp all finite) can require a 9th-order polynomial which may fail to fit. Keep some at `inf` to allow a successful fit. Rule of thumb: IP3 + P1dB works (5th order), IP3 + P1dB + Psat works (7th order), adding Gcomp too may fail.

#### IPType convention

The `IPType` parameter (`'Output'` or `'Input'`) applies to:
- **IP3**: OIP3 or IIP3
- **P1dB**: OP1dB or IP1dB (output or input 1-dB compression point)

It does NOT apply to:
- **Psat**: Always output-referred (output saturation power) regardless of IPType
- **Gcomp**: The gain compression at saturation — difference between linear gain extrapolation and actual output at saturation input power. Unit is **dBW** (effectively dB; choosing dBm would subtract an extra 30 dB)

#### Built-in power characteristics plot

The plot (`simrfV2plotpolynumerial`) shows two curves:
- **Amplifier Ideal**: Baseband polynomial evaluation (direct polynomial computation)
- **Amplifier C-E**: Passband Circuit Envelope model — what you'd measure in baseband if the passband curve flattened perfectly at saturation

These curves agree up to and including P1dB. They diverge AFTER saturation because the CE passband model handles saturation clipping differently (harmonic energy redistribution). All plotted values are baseband-equivalent powers.

**Reading Psat,out from the plot**: The output saturation power is where the curve flattens — `max(YData)` on each line object gives Psat,out for that curve. This value emerges from the polynomial fit and cannot be computed analytically from IP3 and P1dB alone. After generating the plot:
```matlab
fig = gcf; lines = findobj(fig, 'Type', 'Line');
for k = 1:numel(lines)
    psat_out = max(lines(k).YData);
    fprintf('%s: Psat,out = %.2f dBm\n', lines(k).DisplayName, psat_out);
end
```

### Noise

Unlike the S-parameters block (which derives noise from Bosma's theorem on passive networks), the Amplifier block requires explicit noise data — either from the .s2p file noise data section or from user-specified mask parameters.

| Parameter | Values | Notes |
|-----------|--------|-------|
| `AddNoise` | `'on'` \| `'off'` | Enable noise injection |
| `NoiseType` | `'Noise figure'` \| `'Spot noise data'` | Simple scalar NF or frequency-dependent 4-param model |
| `NF` | `'3'` | Noise figure in dB (when NoiseType = 'Noise figure') |
| `NoiseDist` | `'White'` \| `'Piece-wise linear'` \| `'Colored'` | Noise spectrum shape |
| `MinNF` | `'2'` | Minimum NF for spot noise model (dB) |
| `Gopt` | `'0.5+0.3j'` | Optimum source reflection coefficient (spot noise) |
| `RN` | `'10'` | Equivalent noise resistance in ohms (spot noise) |

### Dispersion / S-parameter Modeling Options

These params control how frequency-dependent behavior (from S-param data) is simulated in the time domain. Available on S-parameters block and Amplifier block (identical params). Antenna block uses `Imp` suffix. IMT Mixer has same core params plus separate noise dispersion.

**DataSource** — where the S-param data comes from:

| Parameter | Values | Notes |
|-----------|--------|-------|
| `DataSource` | `'Data file'` \| `'Network-parameters'` \| `'Rational model'` | |

- `'Data file'`: S-params from .s2p file. Auto-fits rational model if Time domain.
- `'Network-parameters'`: S/Y/Z matrices entered directly at frequency points.
- `'Rational model'`: Pre-computed Residues/Poles/DF (from `rationalfit`). No fitting needed.

**SparamRepresentation** — simulation algorithm:

| Parameter | Values | Notes |
|-----------|--------|-------|
| `SparamRepresentation` | `'Time domain'` \| `'Frequency domain'` | Core choice |

- `'Time domain'`: Converts S-params → rational model (poles/residues) → IIR filter. **Fast** but may ring or become unstable with poor fits. Use `FitTol`/`MaxPoles` to control.
- `'Frequency domain'`: Direct FFT-based multiplication each time step. **Always stable**, exact S-param shape preserved, but **slower**. `ImpulseLength` sets FFT size.

**Fitting control** (Time domain only):

| Parameter | Values | Notes |
|-----------|--------|-------|
| `FitTol` | `'0.01'` (default) | Rational fit tolerance. Lower = more poles = tighter fit but slower sim |
| `FitOpt` | `'Share poles by columns'` \| `'Share all poles'` \| `'Fit individually'` | Pole sharing between S-param matrix entries |
| `MaxPoles` | `'200'` | Cap on number of poles in rational model |

**Reading fit results from the mask dialog:**

After setting fit parameters and saving, the block computes a rational fit. The actual results (poles used, error achieved) are displayed as read-only text on the Modeling tab. Read them programmatically:

```matlab
blk = [mdl '/Sparams'];  % or Amplifier block
old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(blk);
dlg = simrfV2_find_dialog(blk);

nPoles = dlg.getWidgetValue('MaxNPoles');   % Number of poles actually used
actErr = dlg.getWidgetValue('ActErr');       % Relative error achieved (dB)
nFits  = dlg.getWidgetValue('NFits');       % Number of independent fits
cd(old);

fprintf('Poles: %s, Error: %s dB, Fits: %s\n', nPoles, actErr, nFits);
```

**Widget tags on the Modeling tab:**

| Tag | Meaning | Example |
|-----|---------|---------|
| `MaxNPoles` | Number of poles used in the fit | `10` |
| `ActErr` | Relative error achieved (dB) | `-165.51` |
| `NFits` | Number of independent fits | `1` |

**Use cases:**
- Verify fit converged (error < FitTol)
- Check if MaxPoles cap was hit (poles used = MaxPoles → may need increase)
- Iterative tightening: reduce FitTol, save, reopen, read ActErr to confirm improvement
- Automated quality gate: reject fit if `str2double(actErr) > threshold`

**Note:** Requires the dialog-safe workflow (set params → `save_system` → `open_system(blk)` → read). The fit is recomputed when the dialog opens with fresh parameters.

**Impulse response control:**

| Parameter | Values | Notes |
|-----------|--------|-------|
| `AutoImpulseLength` | `'on'` \| `'off'` | Auto-determine from data (default on) |
| `ImpulseLength` | `'100'` | Manual length when auto is off |
| `ImpulseLength_unit` | `'s'` \| `'ms'` \| `'us'` \| `'ns'` \| `'ps'` | |

**Phase modeling:**

| Parameter | Values | Notes |
|-----------|--------|-------|
| `MagModeling` | `'on'` \| `'off'` | `on` = magnitude only (ignores phase entirely). Inserts half the filter bin count as a fixed delay, but preserves the magnitude frequency shape. Use when phase data is corrupted or would require too many frequency points to capture correctly. Default `off` = full complex S(f). |

**Block UserData** (undocumented internal cache):

CE blocks store extra runtime data in `get_param(blk, 'UserData')` — a struct not exposed through mask parameters or SATK tools. Contents vary by block type but commonly include cached rational fit data (S-parameters, Amplifier, Antenna, Channel blocks) and solver configuration choices made automatically by the block (e.g., Configuration block stores computed tones/harmonics). Useful for quick diagnostics but may not always reflect current settings — treat as a hint, not ground truth. The plot (`simrfV2plotparam`) remains the authoritative source for fit quality assessment.

**Pre-computed rational model** (DataSource = 'Rational model'):

| Parameter | Values | Notes |
|-----------|--------|-------|
| `Residues` | matrix string | Residue matrix from rational fit |
| `Poles` | vector string | Pole vector from rational fit |
| `DF` | matrix string | Direct-feedthrough term |
| `isRationalObj` | `'on'`/`'off'` | Use rfmodel.rational object instead |
| `RationalObject` | `'rfRatObj'` | Workspace variable name |

---

### Dispersion parameter naming across blocks

| Block | Param prefix/suffix | Has FitOpt/MaxPoles? | Has MagModeling? | Notes |
|-------|-------------------|---------------------|-----------------|-------|
| S-parameters | (none) | Yes | Yes | Full dispersion control |
| Amplifier | (none) | Yes | Yes | + `NoiseAutoImpulseLength`, `NoiseImpulseLength` (separate noise impulse) |
| IMT Mixer | (none) for network data | Yes | Yes | Network data dispersion only. Noise is FFT-based (freq-domain only): `AutoImpulseLengthNoise`, `ImpulseLengthNoise` control FFT size, not rational fit |
| Antenna | `Imp` suffix | No | No | Only: `SparamRepresentationImp`, `FitTolImp`, `AutoImpulseLengthImp`, `ImpulseLengthImp` |
| Channel | `TX`/`Med`/`RX` suffix | No | No | Separate dispersion for Tx antenna, medium, Rx antenna paths |
| IQ Mod/Demod | `IR`/`CS`/`PN` suffix | — | — | These are impulse length for FFT-based filter/phase-noise processing, NOT rational-fit dispersion params. No `SparamRepresentation` or `FitTol` — the IR/CS filters are designed (Butterworth/Chebyshev), not fitted from data |

---

## Power Amplifier (`simrfV2elements/Power Amplifier`)

| Parameter | Values | Notes |
|-----------|--------|-------|
| `ModelType` | `'Memory polynomial'` \| `'Generalized Hammerstein'` \| `'Cross-Term Memory'` \| `'Cross-Term Hammerstein'` | PA model structure |
| `CoeffMatrix` | `'coeffs'` | Workspace variable name or matrix literal |
| `UnitDelay` | `'1e-6'` | Memory tap spacing (seconds) |
| `Rin` | `'50'` | Input resistance (ohms) |
| `Rout` | `'50'` | Output resistance (ohms) |

**CoefficientMatrix format:** [memoryDepth x polynomialDegree] complex matrix. Same format as `rf.PAmemory`.

---

## Switches and Signal-Driven Elements

Three blocks take a Simulink control input alongside their RF ports. Full parameter sets;
defaults shown are the library defaults.

**`simrfV2junction1/SPDT`** — `LConn1`(In), `RConn1`(Out1), `RConn2`(Out2), `Vctl` inport.
`simrfV2junction1/SPST` is identical minus `RConn2`.

| Parameter | Default | Values |
|-----------|---------|--------|
| `Vthres` | `'0'` | Control threshold. **`Vctl >= Vthres` selects `Out2`** |
| `Vthres_unit` | `'V'` | `V` \| `mV` \| `kV` |
| `CharType` | `'Resistance'` | `'Resistance'` \| `'Insertion loss'` — selects which pair below is active |
| `Ron` / `Roff` | `'10'` / `'1e6'` | Ohms (`Ron_unit`/`Roff_unit`: `Ohm`\|`kOhm`\|`MOhm`\|`GOhm`) |
| `Iloss` / `Iiso` | `'1'` / `'70'` | Insertion loss / isolation, both in **dB** |
| `LoadType` | `'Reflective'` | `'Absorptive'` \| `'Reflective'` |
| `Z0` | `'50'` | Port terminations, ohms (`Z0_unit` as above) |
| `InternalGrounding` | `'on'` | checkbox |

**Set `Vthres` between the two control levels.** The default `'0'` with a 0/1 control
selects `Out2` in *both* states, so the switch never moves and a mode toggle silently does
nothing. Use `Vthres='0.5'` for a 0/1 signal: `Vctl=0` → `Out1`, `Vctl=1` → `Out2`.

`LoadType='Reflective'` (the default) leaves the off throw unterminated and reads 0 dB
isolation; use `'Absorptive'` if leakage through an off switch has to be meaningful.
`CharType='Insertion loss'` with `Iloss`/`Iiso` gives realistic leakage; the default
`Resistance`/`Roff=1e6` pairing is effectively perfect isolation.

**`simrfV2elements/Variable\nAttenuator`** (newline in the name —
`sprintf('simrfV2elements/Variable\nAttenuator')`). `LConn1`(In), `RConn1`(Out), `Att` inport.

| Parameter | Default | Notes |
|-----------|---------|-------|
| `Attmin` / `Attmax` | `'0.001'` / `'1000'` | dB; the `Att` input is **clamped** to this range |
| `Zin` / `Zout` | `'50'` / `'50'` | ohms |
| `AddNoise` | `'on'` | checkbox |
| `InternalGrounding` | `'on'` | checkbox |

The `Att` **input is in dB** (positive = more loss) — drive it with the attenuation setting
directly, no conversion. A zero or negative input yields `Attmin`, never gain.

**`simrfV2elements/Variable\nPhase Shift`** (newline in the name).
`LConn1`(In), `RConn1`(Out), `Phase` inport.

| Parameter | Default | Values |
|-----------|---------|--------|
| `PhaseShift_unit` | `'deg'` | `'rad'` \| `'deg'` — the unit of the `Phase` **input** |
| `SparamZ0` | `'50'` | Reference impedances, ohms |
| `InternalGrounding` | `'on'` | checkbox |

There is no static phase parameter: the shift comes only from the `Phase` input, in
whichever unit `PhaseShift_unit` names. For *fixed* values use
`simrfV2elements/Phase Shift` or `simrfV2elements/Attenuator` (`Att`, default `'3'` dB)
instead — neither needs a driving signal.

---

## Mixer (`simrfV2elements/Mixer`)

| Parameter | Values | Notes |
|-----------|--------|-------|
| `Source_linear_gain` | `'Available power gain'` \| `'Polynomial coefficients'` | |
| `linear_gain` | `'-6'` | Conversion gain (dB) |
| `Poly_Coeffs` | `'[0.5, -0.001]'` | Polynomial nonlinearity |
| `Source_Poly` | `'Even and odd order'` \| `'Odd order'` | |
| `IPType` | `'Output'` \| `'Input'` | |
| `IP2`, `IP3`, `P1dB`, `Psat` | string | Same as Amplifier |
| `NF` | `'10'` | Noise figure (dB) |
| `ZLO` | `'50'` | LO port impedance |

**No phase noise on regular Mixer.** Use IMT Mixer for phase noise.

---

## IMT Mixer (`simrfV2elements/IMT\nMixer`)

Note: Block name has a newline: `sprintf('simrfV2elements/IMT\nMixer')`

### Spur table

| Parameter | Values | Notes |
|-----------|--------|-------|
| `UserSpurValues` | `'[99 99 -50 99; 99 0 -35 99; ...]'` | IMT spur matrix (dBc). 99 = suppressed |
| `UseDataFile` | `'on'` \| `'off'` | Load from file vs manual |
| `FileName` | `'mixer_data.s2p'` | Data file path |
| `FrequencyRF` | `'2.4e9'` | RF frequency for spur calc, Hz |
| `FrequencyLO` | `'2.0e9'` | LO frequency, Hz |
| `PowerRF` | `'-10'` | RF input power, dBm |
| `PowerLO` | `'10'` | LO drive power, dBm |
| `Rin` / `Rout` | `'50'` | Input / output impedance, ohm |
| `MixerType` | `'Upconverter'` \| `'Downconverter'` | Default is `'Upconverter'` -- set it explicitly for a receiver |
| `PowerOut` | `'-76'` | Nominal output power, dBm, at `PowerRF`; this pair sets conversion gain |

**Units are fixed on this block** -- frequencies in Hz, powers in dBm, impedances in ohm.
There is nothing to select, so the usual "always set the companion `_unit`" rule does not
apply here: pass the bare value, `{"FrequencyRF":"2.4e9","FrequencyLO":"2.4e9"}`.
(A name like `FrequencyLO_unit` does appear in `DialogParameters`, but it is not settable --
setting it errors, because there is no alternative unit to switch to.)

Gain on this block is expressed as `PowerRF` -> `PowerOut`, not a gain parameter, matching
the `mixerIMT` object's `ReferenceInputPower`/`NominalOutputPower`.

### Phase noise (unique to IMT Mixer among mixer blocks)

| Parameter | Values | Notes |
|-----------|--------|-------|
| `AddPhaseNoise` | `'on'` \| `'off'` | Enable LO phase noise |
| `PhaseNoiseOffset` | `'[1e3 1e4 1e5 1e6]'` | Offset frequencies (Hz) |
| `PhaseNoiseLevel` | `'[-80 -100 -120 -140]'` | dBc/Hz at each offset |

### Noise

| Parameter | Values | Notes |
|-----------|--------|-------|
| `AddNoise` | `'on'` \| `'off'` | |
| `NoiseType` | `'Noise figure'` \| `'Spot noise data'` | |
| `NF` | `'10'` | Simple NF model |
| `NoiseDistribution` | `'White'` \| `'Piece-wise linear'` \| `'Colored'` | |
| `MinNF`, `Gopt`, `RN` | string | Spot noise parameters |

### S-parameter / Network data

| Parameter | Values | Notes |
|-----------|--------|-------|
| `NetworkParameterType` | `'S-parameters'` \| `'Y-parameters'` \| `'Z-parameters'` | |
| `SParameters` | matrix string | Network parameter data |
| `NetworkParameterFrequencies` | vector string | Frequency points |
| `SparamRepresentation` | `'Time domain'` \| `'Frequency domain'` | |
| `FitTol` | `'0.01'` | |

---

## IQ Modulator (`simrfV2systems/IQ Modulator`)

### IQ Imbalance

| Parameter | Values | Notes |
|-----------|--------|-------|
| `GainMismatch` | `'0.5'` | I/Q amplitude difference |
| `GainMismatch_unit` | `'dB'` \| `'None'` | dB (default) or linear |
| `PhaseMismatch` | `'2'` | Quadrature error from ideal 90 deg |
| `PhaseMismatch_unit` | `'deg'` \| `'rad'` | |
| `Isolation` | `'30'` | LO-to-RF leakage; **default `inf`** = perfect isolation |
| `Isolation_unit` | `'dB'` \| `'None'` | |
| `NFloor` | `'-160'` | Noise floor (dBm/Hz) — IQ Mod only |

`Isolation` ships as `inf` on all four mixer blocks, i.e. no LO leakage and no DC offset.
That is the right setting for a build task: give it a finite value only when the task asks
for LO leakage or DC offset as a specification. It is an impairment you add deliberately,
not a knob to sweep to find out what it does.

### Phase noise

| Parameter | Values | Notes |
|-----------|--------|-------|
| `AddPhaseNoise` | `'on'` \| `'off'` | |
| `PhaseNoiseOffset` | `'[1e3 1e4 1e5 1e6]'` | Hz |
| `PhaseNoiseLevel` | `'[-80 -100 -120 -140]'` | dBc/Hz |
| `AutoImpulseLengthPN` | `'on'` \| `'off'` | |
| `ImpulseLengthPN` | `'500'` | |
| `ImpulseLength_unitPN` | `'ns'` | |

### Image-Reject filter (IR)

| Parameter | Values | Notes |
|-----------|--------|-------|
| `AddIRFilters` | `'on'` \| `'off'` | Enable/disable IR filter (IQ Mod) |
| `AddIRFilter` | `'on'` \| `'off'` | Same for IQ Demod/Modulator |
| `DesignMethodIR` | `'Ideal'` \| `'Butterworth'` \| `'Chebyshev'` \| `'InverseChebyshev'` | |
| `ResponseTypeIR` | `'Lowpass'` \| `'Highpass'` \| `'Bandpass'` \| `'Bandstop'` | |
| `ImplementationIR` | `'LC Tee'` \| `'LC Pi'` \| `'Transfer function'` | Physical vs TF |
| `ImplementationIdealIR` | `'Constant per carrier'` \| `'Frequency domain'` | When Ideal |
| `UseFilterOrderIR` | `'on'` \| `'off'` | `'off'` = minimum order from specs |
| `FilterOrderIR` | `'5'` | Only when `UseFilterOrderIR='on'` |
| `PassFreq_lp_unitIR` | `'Hz'` \| `'kHz'` \| `'MHz'` \| `'GHz'` | **Default after export: GHz** |
| `PassFreq_lpIR` | `'10'` | Passband edge (lowpass), in unit above |
| `StopFreq_lp_unitIR` | `'Hz'` \| `'kHz'` \| `'MHz'` \| `'GHz'` | **Default after export: GHz** |
| `StopFreq_lpIR` | `'30'` | Stopband edge (lowpass), in unit above |
| `PassAttenIR` | `'1'` | Passband ripple (dB) |
| `StopAttenIR` | `'40'` | Stopband attenuation (dB) |
| `RsrcIR` | `'50'` | Source impedance (ohm), LC Tee/Pi only |
| `RloadIR` | `'50'` | Load impedance (ohm), LC Tee/Pi only |

**Unit warning:** After `rfsystem` export, frequency unit defaults to GHz. Always set
`PassFreq_lp_unitIR`/`StopFreq_lp_unitIR` explicitly alongside the value. Using `'10e6'`
with default GHz unit means 10,000,000 GHz — causing "Filter order > 60" errors.

### Channel-Select filter (CS)

Same pattern as IR but with `CS` suffix: `AddCSFilter`, `DesignMethodCS`, `ResponseTypeCS`, `FilterOrderCS`, `PassFreq_lpCS`, `PassFreq_lp_unitCS`, `RsrcCS`, `RloadCS`, etc. Same GHz default unit warning applies.

### Nonlinearity

| Parameter | Values | Notes |
|-----------|--------|-------|
| `Source_linear_gain` | `'Available power gain'` \| `'Polynomial coefficients'` | |
| `Poly_Coeffs` | vector string | |
| `Source_Poly` | `'Even and odd order'` \| `'Odd order'` | |
| `IPType` | `'Output'` \| `'Input'` | |
| `IP2`, `IP3`, `P1dB`, `Psat`, `Gcomp` | string | Same as Amplifier |

---

## IQ Demodulator (`simrfV2systems/IQ Demodulator`)

Same as IQ Modulator except:
- `AddIRFilter` (not `AddIRFilters`)
- `AddCSFilters` (not `AddCSFilter`)
- Has `NF` instead of `NFloor`

---

## Modulator / Demodulator (`simrfV2systems/Modulator`, `simrfV2systems/Demodulator`)

### Impairments available

| Parameter | Values | Notes |
|-----------|--------|-------|
| `Isolation` | `'30'` | LO-to-RF leakage (dB); **default `inf`** = perfect isolation |
| `AddPhaseNoise` | `'on'` \| `'off'` | |
| `PhaseNoiseOffset` | vector string | |
| `PhaseNoiseLevel` | vector string | |
| `AddIRFilter` | `'on'` \| `'off'` | |
| `AddCSFilter` | `'on'` \| `'off'` | |

**NOT available on Modulator/Demodulator:** `GainMismatch`, `PhaseMismatch` (these are IQ-only concepts).

---

## CW Source (`simrfV2sources1/Continuous\nWave`)

Note: Block name has a newline: `sprintf('simrfV2sources1/Continuous\nWave')`

| Parameter | Values | Notes |
|-----------|--------|-------|
| `CWSourceType` | `'Power'` \| `'Ideal voltage'` \| `'Ideal current'` | Source type |
| `MagPower` | `'0'` | Output power |
| `MagPower_unit` | `'dBm'` \| `'W'` \| `'mW'` | |
| `CarrierFreq` | `'2.4e9'` | Carrier frequency |
| `CarrierFreq_unit` | `'Hz'` \| `'GHz'` | |
| `AddPhaseNoise` | `'on'` \| `'off'` | |
| `PhaseNoiseOffset` | `'[1e3 1e4 1e5 1e6]'` | Hz |
| `PhaseNoiseLevel` | `'[-80 -100 -120 -140]'` | dBc/Hz |

---

## Antenna (`simrfV2elements/Antenna`)

| Parameter | Values | Notes |
|-----------|--------|-------|
| `AntennaSource` | `'Isotropic radiator'` \| `'Antenna Designer'` \| `'Antenna object'` | |
| `AntennaObj` | `'myAntenna'` | Workspace variable name (when Antenna object) |
| `Gr` | `'5'` | Gain (when Isotropic) |
| `Gr_unit` | `'dBi'` \| `'None'` | |
| `Zin` | `'50'` | Input impedance |
| `InputIncWave` | `'on'` \| `'off'` | Enable receive port (2-pol incident wave) |
| `OutputRadWave` | `'on'` \| `'off'` | Enable transmit port (2-pol radiated wave) |
| `CarrierFreqInc` | `'5.8e9'` | Carrier for incident wave |
| `rArr` | `'[0 0]'` | Arrival direction [az, el] |
| `rArr_unit` | `'deg'` \| `'rad'` | |
| `CarrierFreqRad` | `'5.8e9'` | Carrier for radiated wave |
| `rDep` | `'[0 0]'` | Departure direction [az, el] |
| `rDep_unit` | `'deg'` \| `'rad'` | |
| `AddNoise` | `'on'` \| `'off'` | Antenna noise temperature |

---

## Channel (`simrfV2systems/Channel`)

| Parameter | Values | Notes |
|-----------|--------|-------|
| `ChannelSource` | `'Isotropic free-space'` \| `'Ray-tracing'` | Mode |
| `Gt` | `'3'` | Tx antenna gain (isotropic mode) |
| `Gr` | `'5'` | Rx antenna gain (isotropic mode) |
| `PathLoss` | `'100'` | Path loss in dB (isotropic mode) |
| `PathDelay` | `'1e-6'` | Propagation delay (isotropic mode) |
| `PathDelay_unit` | `'s'` \| `'us'` \| `'ns'` | |
| `txSite` | `'txSiteObj'` | Workspace variable name (ray-tracing mode) |
| `rxSite` | `'rxSiteObj'` | Workspace variable name (ray-tracing mode) |
| `propagationModel` | `'''raytracing'''` | Propagation model spec (ray-tracing mode) |
| `map` | `'''none'''` | 3D environment (ray-tracing mode) |
| `CarrierFreq` | `'5.8'` | Carrier frequency |
| `CarrierFreq_unit` | `'GHz'` | |
| `AddNoise` | `'on'` \| `'off'` | Channel thermal noise |

---

## Frequency-Domain Sizing and Performance

### S-parameter / Network-data Impulse Response

When `SparamRepresentation = 'Frequency domain'`, the block computes via FFT each time step. Key constraints:

| Constraint | Value | Behavior |
|-----------|-------|----------|
| Maximum bins | **2048** | Silently capped — values above 2048 are ignored without error |
| Bin quantization | **Power-of-2** | Internally rounds down to nearest pow2 (e.g., 1500 → 1024) |
| Total impulse duration | `bins × step_size` | `step_size` is the simulation time step from the **Configuration** block |

**Shared bin count:** All frequency-domain elements in the CE model share the same FFT size (determined by the maximum `ImpulseLength` specified across all blocks). If one element requests many bins, every frequency-domain element pays the computational cost. This is the primary performance lever for CE models with multiple freq-domain blocks.

**Practical guidance:**
- Start with `AutoImpulseLength = 'on'` and check simulation speed
- If too slow, manually reduce `ImpulseLength` on the element that doesn't need fine freq resolution
- If a filter has a long ring-down, it forces all elements to use many bins — consider switching that filter to `'Time domain'` (rational fit) instead

### Phase Noise FFT Sizing

Phase noise is always modeled using frequency-domain FFT filters, separate from the signal-path dispersion.

| Constraint | Value | Notes |
|-----------|-------|-------|
| Maximum bins | **65536** | Much higher limit than signal-path (2048) |
| Bin sharing | **Independent per source** | Each phase-noise source has its own FFT size (unlike signal-path which shares) |

**Performance tradeoff:** Phase-noise spectral skirts are typically very narrow around the carrier compared to the total simulation bandwidth. To resolve near-carrier phase noise (e.g., the 1 kHz offset point), the FFT must span enough bins that `1/total_duration` is small relative to the closest offset. This means:

- Near-carrier resolution requires many bins → slow simulation
- Far-from-carrier offsets (100 kHz+) are cheap to resolve
- **Start with small bin counts** and increase gradually while checking whether results change

**Example:** If step_size = 1 ns and you need to resolve 1 kHz offset:
- Need total duration ≥ 1/1kHz = 1 ms → bins = 1ms / 1ns = 1,000,000 — exceeds 65536 limit
- Resolution at 65536 bins with 1 ns step: 1/(65536×1ns) ≈ 15 kHz minimum resolvable offset
- To resolve 1 kHz: increase step_size (reduce bandwidth) or accept that closest offset won't be captured

---

## Gotchas

1. **Boolean values** are strings: `'on'` / `'off'`, not logical true/false
2. **Block names with newlines**: to *address* the block, a space works in place of the newline — `[mdl '/IMT Mixer']`, `[mdl '/Continuous Wave']` — in path-based MATLAB calls such as `get_param` (`model_edit` addresses blocks by ID). But `find_system` *returns* the newline form, so `strcmp`/`contains` against a space-form path you wrote yourself silently reports the block as absent. See `references/library-catalog.md` § Block Names with Embedded Newlines.
3. **Filter param plural logic**: `AddIRFilters` is plural on IQ Mod because there are 2 IR filters (one on each I and Q branch). `AddCSFilters` is plural on IQ Demod because there are 2 CS filters (one on each I and Q output branch). It's not inconsistency — it reflects the actual topology.
4. **Unit params**: Most numeric params have a companion `_unit` param. Always set both.
5. **Workspace variables**: `AntennaObj`, `txSite`, `rxSite`, `CoeffMatrix` take variable *names* as strings, not the values themselves.
6. **Polynomial Source_linear_gain**: Must set `Source_linear_gain` to `'Polynomial coefficients'` BEFORE `Poly_Coeffs` takes effect. Similarly, set to `'AM/AM-AM/PM table'` before `AmAmAmPmTable`.
7. **NFloor (IQ Modulator only)**: This is the output noise floor at RF frequency. The DC I/Q branches have thermal floor (-174 dBm/Hz); modulation up-converts this to RF. The `NFloor` param specifies the device's actual RF output noise floor. Setting any value other than -174 dBm/Hz means the device adds noise beyond thermal. Do not confuse with `NF` on IQ Demodulator which is conventional noise figure.
8. **ConstS21NL + OpFreq (Amplifier)**: Only meaningful when the block has BOTH frequency-dependent data (S-parameters) AND nonlinearity specified. Two modes:
   - `ConstS21NL = 'on'`: Flattens S21 to a constant over frequency (S11, S12, S22 remain freq-dependent). Nonlinearity is correct over the entire envelope bandwidth, but S21 accuracy is lost outside OpFreq.
   - `ConstS21NL = 'off'`: Keeps S21 frequency-dependent. Nonlinearity holds as specified only at OpFreq; at other frequencies the gain varies but NL compression doesn't track.
   - Noise always remains frequency-dependent regardless (small-signal assumption — noise doesn't shift the operating point).

----

Copyright 2026 The MathWorks, Inc.

----
