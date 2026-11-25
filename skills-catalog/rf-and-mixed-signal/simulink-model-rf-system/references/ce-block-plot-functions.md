# CE Block Plot Functions (Visual Verification)

Built-in mask plot functions for visually verifying impairment configuration.
Block parameter tables live in `ce-block-parameters.md`.

---

**Access pattern** (functions are in a private folder — must `cd` there):

```matlab
blk = [mdl '/PA'];  % full block path
old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(blk);  % required: ensures mask dialog is open
simrfV2plotpolynumerial(blk, simrfV2_find_dialog(blk));
cd(old);

% Capture the figure for inspection
fig = gcf;
tmpFile = fullfile(tempdir, 'ce_power_char.png');
exportgraphics(fig, tmpFile, 'Resolution', 150);
```

**CRITICAL: Dialog-safe workflow for mask plots:**

The mask dialog "owns" block parameters while open. If a parameter changes while the dialog is open, the plot function will refuse with: *"Changes to dialog parameter X exists. Press Apply and try again."*

**Correct sequence:**
1. Set ALL parameters with `model_edit` `configure` (with dialog CLOSED)
2. Call `save_system(mdl)`
3. THEN call `open_system(blk)` — dialog opens with saved values
4. Call the plot function — works because dialog has no pending changes
5. Read/capture the plot

**Wrong sequence (causes error):**
1. `open_system(blk)` — dialog opens
2. Change a parameter — marks dialog dirty
3. Call plot function — ERROR: "Press Apply and try again"

**If you need to change params after seeing a plot:**
1. Close the mask dialog: `close(simrfV2_find_dialog(blk))` or close model and reopen
2. Then `configure` → `save_system` → `open_system(blk)` → plot again

**Notes:**
- `open_system(blk)` must be called first — opens the mask dialog (required for `simrfV2_find_dialog`)
- `simrfV2_find_dialog(blk)` reliably finds the correct dialog handle by searching on block name
- After calling the plot function, use `gcf` + `exportgraphics` to capture, then read the PNG

### `simrfV2plotpolynumerial` — Power Characteristics (Amplifier, Mixer)

Plots the nonlinearity curve: Pin vs Pout and gain compression.

**Supported modes:** Only available when `Source_linear_gain = 'IP3'` (the default mode). The "Plot Power Characteristics" button does NOT appear on the mask dialog — and the function is NOT supported — for:
- `Source_linear_gain = 'Polynomial coefficients'`
- `Source_linear_gain = 'AM/AM-AM/PM table'`

The same limitation applies to the IB (Idealized Baseband) Amplifier's `SectionGroup1_Action1` button.

**If you need power characteristics for Polynomial or AM/PM modes**, compute them analytically:
```matlab
% Manual power sweep for polynomial mode
coeffStr = get_param(blk, 'Poly_Coeffs');
coeffs = str2num(coeffStr); %#ok<ST2NM>
Pin_dBm = -50:0.5:30;
Pin_W = 10.^((Pin_dBm - 30) / 10);
Vin = sqrt(2 * Pin_W * 50);
% Odd-order polynomial: y = c1*x + c3*x*|x|^2 + c5*x*|x|^4
A_out = coeffs(1)*Vin;
if numel(coeffs) >= 2, A_out = A_out + (3/4)*coeffs(2)*Vin.^3; end
if numel(coeffs) >= 3, A_out = A_out + (10/16)*coeffs(3)*Vin.^5; end
Pout_dBm = 10*log10(A_out.^2 / (2*50) * 1000);
Gain_dB = Pout_dBm - Pin_dBm;
plot(Pin_dBm, Gain_dB); xlabel('Pin (dBm)'); ylabel('Gain (dB)');
exportgraphics(gcf, fullfile(tempdir, 'ce_pa_power_char.png'), 'Resolution', 150);
```

**Interpreting the axes (IP3 mode only):**
- All powers are **baseband equivalent** (nonlinear properties are measured in baseband, except IP2)
- **Pin** = Available source power (P_avs): measured assuming Z_source = conj(Z_in) of the amplifier
- **Pout** = Available power from network (P_avn): power delivered to Z_load = conj(Z_out) of the amplifier
- **Gain** in the curve = **Maximum available gain** (Ga,max) — conjugate match at both ports
- Reference: "More About" section of the `powergain` documentation (`doc powergain`)

**Use cases (IP3 mode):**
- Confirm IP3 extraction matches the linear+cubic intersection
- Validate that gain at small signal matches the specified `linear_gain`
- Check P1dB and Psat values

### `simrfV2plotparam` — S-parameter & Noise Figure Visualization (Amplifier, S-parameters)

Plots individual S-parameter entries vs frequency, and NF when noise data is available. When the block uses `'Time domain'` modeling, the plot overlays the rational fit against the original data — essential for verifying fit quality.

**Invocation:**
```matlab
blk = [mdl '/LNA'];  % full block path
old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(blk);
simrfV2plotparam(blk, simrfV2_find_dialog(blk));
cd(old);

fig = gcf;
exportgraphics(fig, fullfile(tempdir, 'ce_sparam_viz.png'), 'Resolution', 150);
```

**Visualization tab parameters** (configure what gets plotted before calling):

| Parameter | Values | Notes |
|-----------|--------|-------|
| `SourceFreq` | `'Extracted from data source'` \| `'User-specified'` | Frequency range source |
| `PlotFreq` | `'[1e9:1e6:3e9]'` | Frequency vector (when User-specified) |
| `PlotFreq_unit` | `'Hz'` \| `'kHz'` \| `'MHz'` \| `'GHz'` | |
| `PlotType` | `'X-Y plane'` \| `'Polar plane'` \| `'Z Smith chart'` \| `'Y Smith chart'` \| `'ZY Smith chart'` | Plot format |
| `YParam1` | `'S(1,1)'` \| `'S(1,2)'` \| `'S(2,1)'` \| `'S(2,2)'` \| `'NF'` | First parameter to plot |
| `YFormat1` | `'Magnitude (dB)'` \| `'Magnitude (linear)'` \| `'Angle (degrees)'` \| `'Real'` \| `'Imaginary'` | Display format |
| `YParam2` | `'None'` \| `'S(1,1)'` \| ... \| `'NF'` | Second parameter (dual-axis) |
| `YFormat2` | same as YFormat1 | |
| `YOption` | `'Linear'` \| `'Logarithmic'` | Y-axis scale (X-Y plane only) |
| `XOption` | `'Linear'` \| `'Logarithmic'` | X-axis scale (X-Y plane only) |

**Notes:**
- `NF` option for `YParam1`/`YParam2` appears dynamically only when the block has noise data (from .s2p file noise section or spot noise parameters)
- When `SparamRepresentation = 'Time domain'`: plot shows **both** original data points and the rational fit curve — use this to visually verify fit quality before simulation
- When `SparamRepresentation = 'Frequency domain'`: plot shows the data as-is (no fitting involved)
- Set `YParam1`/`YParam2` (`model_edit` `configure`) before calling `simrfV2plotparam` to control what appears

**Use cases:**
- Verify rational fit tracks the data (especially near band edges and resonances)
- Check if `FitTol`/`MaxPoles` need adjustment (visible as fit deviation from data)
- Confirm NF vs frequency shape matches expectations
- Validate S21 gain flatness across band of interest
- Inspect S11/S22 matching quality at design frequency

### `simrfV2_plot_pn_chars` — Phase Noise Spectrum (CW Source, Modulator, IQ Mod/Demod)

Plots the phase noise profile (dBc/Hz vs offset frequency) showing both the specified data points and the FFT-based impulse response representation that will actually be used in simulation. Critical for verifying near-carrier resolution.

**Available on:** CW Source, Modulator, Demodulator, IQ Modulator, IQ Demodulator, IMT Mixer — any block with `AddPhaseNoise` parameter.

**Invocation** (note: different argument pattern — uses `.getDialogSource`):
```matlab
blk = [mdl '/LO'];  % full block path
old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(blk);
simrfV2_plot_pn_chars(simrfV2_find_dialog(blk).getDialogSource);
cd(old);

fig = gcf;
exportgraphics(fig, fullfile(tempdir, 'ce_phase_noise.png'), 'Resolution', 150);
```

**What the plot shows:**
- **Specified data:** The discrete offset/level points from `PhaseNoiseOffset` and `PhaseNoiseLevel`
- **FFT representation:** The actual impulse-response-based model that will run in simulation
- **Deviation near carrier:** Where the FFT approximation diverges from specified data due to insufficient bin count

**Use cases:**
- Verify that the FFT impulse response captures the phase noise skirt correctly
- Determine if `ImpulseLengthPN` (bin count) is sufficient for near-carrier accuracy
- Identify the closest offset frequency that is actually resolved (below this, the FFT cannot represent the skirt)
- Justify increasing bin count: if the FFT curve deviates from specified data at offsets that matter for the application (e.g., EVM-critical near-carrier region), increase bins
- Validate phase noise data entry (check for typos in offset/level vectors)

**Relationship to bin count sizing:**
- The plot directly shows the tradeoff described in `ce-block-parameters.md` section "Phase Noise FFT Sizing"
- If the FFT curve flattens or deviates below a certain offset → that offset is not resolved
- Increasing `ImpulseLengthPN` extends resolution to closer offsets but slows simulation

### `simrfV2dlg_mixerimt_plot` — IMT Spur Power Diagram (IMT Mixer)

Plots the power level on each spur (m×fRF + n×fLO products), showing the IMT matrix entries as power levels relative to the expected output. The dominant spur (where the desired signal appears) is shown in blue.

**Available on:** IMT Mixer block only.

**Invocation** (simpler pattern — no `cd` to private needed, no dialog handle):
```matlab
blk = [mdl '/IMT Mixer'];  % full block path
open_system(blk);
simrfV2dlg_mixerimt_plot(blk);

fig = gcf;
exportgraphics(fig, fullfile(tempdir, 'ce_imt_spurs.png'), 'Resolution', 150);
```

**Plot-control parameters** (affect only the visualization, not simulation):

| Parameter | Values | Notes |
|-----------|--------|-------|
| `PowerOut` | `'0'` | Expected signal power at the dominant spur (dBm). IMT table values are relative to this. |
| `MixerType` | string | Mixer topology — determines which spur is the dominant (desired) output, shown in blue |

**What the plot shows:**
- Each bar = one m×n spur product, with absolute power = `PowerOut` + IMT(m,n) dBc
- **Blue bar** = dominant/desired spur (determined by `MixerType`)
- Other bars show spurious products at their relative power levels
- Spurs at 99 dBc (suppressed) are not shown

**Use cases:**
- Verify spur table entry after transcribing from a mixer datasheet
- Identify which spurs are closest in power to the desired output (worst offenders)
- Check that the correct spur is identified as dominant for the chosen mixer topology
- Communicate spur landscape visually when evaluating mixer selection

### `simrfV2plotfilter` — Filter Frequency/Time Response (CE Filter)

Plots the designed filter's frequency response (voltage transfer, phase delay, group delay) or time response (impulse, step). Useful for verifying filter design meets spec before simulation.

**Available on:** Filter block (`simrfV2elements/Filter`)

**Invocation:**
```matlab
blk = [mdl '/BPF'];  % full block path
old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(blk);
simrfV2plotfilter(blk, simrfV2_find_dialog(blk));
cd(old);

fig = gcf;
exportgraphics(fig, fullfile(tempdir, 'ce_filter_response.png'), 'Resolution', 150);
```

**Visualization parameters** (configure before calling):

| Parameter | Values | Notes |
|-----------|--------|-------|
| `PlotFuncLeft` | `'Voltage transfer'` \| `'Phase delay'` \| `'Group delay'` \| `'Impulse response'` \| `'Step Response'` | Left Y-axis plot type |
| `PlotLeftForm` | `'Magnitude (dB)'` \| `'Magnitude (linear)'` \| `'Angle (degrees)'` \| `'Real'` \| `'Imaginary'` | Left Y-axis format |
| `PlotRightOnVT` | `'None'` \| `'Voltage transfer'` \| `'Phase delay'` \| `'Group delay'` | Right Y-axis (when left = Voltage transfer) |
| `PlotRightNoTD` | `'None'` \| `'Voltage transfer'` \| `'Group delay'` | Right Y-axis (when left = Phase delay) |
| `PlotRightNoGD` | `'None'` \| `'Voltage transfer'` \| `'Phase delay'` | Right Y-axis (when left = Group delay) |
| `PlotRightNoIR` | `'None'` \| `'Step response'` | Right Y-axis (when left = Impulse response) |
| `PlotRightNoSR` | `'None'` \| `'Impluse Response'` | Right Y-axis (when left = Step Response) |
| `PlotRightForm` | same as `PlotLeftForm` | Right Y-axis format |
| `FreqPoints` | `'logspace(0,10,101)'` | Frequency evaluation vector (for freq-domain plots) |
| `Freq_unit` | `'Hz'` \| `'kHz'` \| `'MHz'` \| `'GHz'` | |
| `TimePoints` | `'linspace(0,1,1e6+1)'` | Time evaluation vector (for time-domain plots) |
| `Time_unit` | `'s'` \| `'ms'` \| `'us'` \| `'ns'` | |
| `XaxisScale` | `'Linear'` \| `'Logarithmic'` | |
| `YaxisScale` | `'Linear'` \| `'Logarithmic'` | |

**Notes:**
- The right Y-axis parameter name changes dynamically based on left Y-axis selection (prevents duplicate selections)
- Time-domain plots (Impulse/Step) use `TimePoints`; frequency-domain plots use `FreqPoints`
- Dual-axis mode allows simultaneous magnitude + group delay, or impulse + step response

**Use cases:**
- Verify passband ripple and stopband attenuation meet spec
- Check group delay flatness across signal bandwidth
- Inspect impulse/step response for ringing (indicates potential convergence issues in CE simulation)
- Compare designed filter response against requirements before committing to simulation

---

### `simrfV2expandblock` — Edit/Expand System (all simrfV2systems blocks)

Decomposes a system-level block (IQ Modulator, IQ Demodulator, Modulator, Demodulator, Channel) into its constituent components for per-element manipulation.

**Available on:** All blocks in `simrfV2systems` library.

**Problem:** This function calls `questdlg` which creates a modal dialog that blocks execution. **Solution:** Temporarily shadow `questdlg` with an auto-answering function.

**Invocation (bypassing modal dialog):**
```matlab
blk = [mdl '/IQMod'];  % full block path

% Shadow questdlg to auto-answer (choose 'Edit System' or 'Expand System')
tmpDir = fullfile(tempdir, 'questdlg_override');
if ~exist(tmpDir, 'dir'); mkdir(tmpDir); end
fid = fopen(fullfile(tmpDir, 'questdlg.m'), 'w');
fprintf(fid, 'function answer = questdlg(varargin)\nanswer = ''Edit System'';\nend\n');
fclose(fid);
addpath(tmpDir);

% Invoke the expand function
old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(blk);
simrfV2expandblock(blk, simrfV2_find_dialog(blk));
cd(old);

% Restore questdlg
rmpath(tmpDir);
delete(fullfile(tmpDir, 'questdlg.m'));
rmdir(tmpDir);
```

**Two modes:**

| Answer | Effect | Result |
|--------|--------|--------|
| `'Edit System'` | Exposes internals inside the subsystem boundary | Block remains as a subsystem; internals (LO, MixerI, MixerQ, filters, etc.) are now accessible inside it. Mask is removed but subsystem persists. |
| `'Expand System'` | Breaks the subsystem open and places components at the parent level | Original block is deleted; its components appear as siblings at the parent scope. Connections are preserved. |

**Note:** The operation is irreversible — save a backup before editing.

**Use cases:**
- Replace internal mixer with a different nonlinearity model
- Insert additional filtering between internal stages
- Access individual I/Q branch components for asymmetric impairment modeling
- Top-down design: create from rfbudget → export → Edit System → customize internals

**Typical internal topologies:**

| System Block | Internal Components |
|-------------|-------------------|
| IQ Modulator | LO, MixerI, MixerQ, PhaseShifter, RI, RQ, Rout, SignalCombiner, Gnd |
| IQ Demodulator | LO, MixerI, MixerQ, PhaseShifter, RI, RQ, filters (IR/CS), Gnd |
| Channel | Tx Antenna, Medium, Rx Antenna |

### Channel Block Edit (Expert)

The Channel block (`simrfV2systems/Channel`) uses a **different command** than the other system blocks:

```matlab
blk = [mdl '/Channel'];

% Shadow questdlg (same modal dialog bypass)
tmpDir = fullfile(tempdir, 'questdlg_override');
if ~exist(tmpDir, 'dir'); mkdir(tmpDir); end
fid = fopen(fullfile(tmpDir, 'questdlg.m'), 'w');
fprintf(fid, 'function answer = questdlg(varargin)\nanswer = ''Edit System'';\nend\n');
fclose(fid);
addpath(tmpDir);

simrfV2channel(blk, 'simrfEditSys');

rmpath(tmpDir);
delete(fullfile(tmpDir, 'questdlg.m'));
rmdir(tmpDir);
```

After editing, three internal blocks are exposed:

1. **Transmitting Antenna** — handles Tx antenna pattern, polarization, EIRP
2. **Medium** — applies path loss, phase shift, delay from propagation rays (becomes fully unlinked and user-modifiable)
3. **Receiving Antenna** — handles Rx antenna pattern, polarization mismatch

**Parameter translation:** Run `edit simrfV2_channel_params.m` to see how Channel mask parameters map to internal block settings. After edit, workspace variables replace the nested structure fields.

**Post-edit capabilities:**
- Modify Medium block arbitrarily (add multipath taps, custom fading, frequency-selective loss)
- Replace internal Antenna blocks with custom antenna objects
- Insert blocks between Antenna and Medium (e.g., radome loss, near-field coupling)

**Visualization — Site Viewer:**
```matlab
blk = [mdl '/Channel'];
simrfV2channel(blk, 'simrfViewSite');
```
Opens `siteviewer` with the map, txsite/rxsite locations, and propagation paths — shows the exact geometric scenario. Capture with:
```matlab
fig = gcf;  % or use siteviewer handle
exportgraphics(fig, fullfile(tempdir, 'ce_channel_site.png'), 'Resolution', 150);
```

**Reference:** "Edit Channel Block" in the Algorithms section of the RF Blockset Channel block documentation

---

### Idealized Baseband (IB) Block Plots

IB blocks use a different invocation mechanism — System Object mask button callbacks rather than private CE functions.

**Access pattern:**
```matlab
blk = [mdl '/BlockName'];  % full block path
matlab.system.ui.ImplementSystemObjectUsingMask.buttonCallback( ...
    get_param(blk, 'Handle'), '<SectionGroupN_ActionM>');

fig = gcf;
exportgraphics(fig, fullfile(tempdir, 'ib_plot.png'), 'Resolution', 150);
```

**IB Plot Button Catalog:**

| Block | Button ID | Plot | Notes |
|-------|-----------|------|-------|
| Amplifier | `SectionGroup1_Action1` | Power characteristics | Pin/Pout/compression (same as CE `simrfV2plotpolynumerial`). **Only for IP3 mode** — not available for Polynomial or AM/PM table modes. |
| Mixer | `SectionGroup2_Action1` | Power characteristics | Pin/Pout/compression — **IB Mixer has this; CE Mixer does not** |
| Mixer | `SectionGroup3_Action1` | Phase noise spectrum | Similar to CE `simrfV2_plot_pn_chars` |
| S-parameters | `SectionGroup3_Action1` | S-param visualization | S-params vs freq, rational fit overlay (same as CE `simrfV2plotparam`) |
| Filter | `SectionGroup3_Action1` | Filter response | Freq/time response (same as CE `simrfV2plotfilter`) |

**Key differences from CE:**
- In IB, the Mixer block has both power curve and phase noise plots. In CE, only the Amplifier has power curve visualization — CE Mixer and Mod/Demod blocks do not.
- **Phase noise modeling differs between IB and CE:**
  - **IB with single data point:** Uses an IIR filter with a linear-in-dB slope of **10 dBc/Hz per decade**, passing through the specified point. This produces a realistic 1/f-like phase noise roll-off from one measurement.
  - **CE with single data point:** Uses FFT filter with **flat (zero slope)** phase noise — the level is constant at the specified dBc/Hz across all offsets. Multiple points required for shaped spectrum in CE.
  - **Multiple data points:** Both IB and CE interpolate between the specified offset/level pairs, but IB uses IIR filter while CE always uses FFT filter.


----

Copyright 2026 The MathWorks, Inc.

----
