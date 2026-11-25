---
name: simulink-model-rf-system
description: >
  Physics-based RF system simulation in Simulink with RF Blockset Circuit Envelope and
  Idealized Baseband, capturing multi-carrier interactions, impedance mismatch, and
  nonlinear mixing products that behavioral models miss. Export an rfbudget chain or
  measured S-parameters to a model, add impairments (noise, nonlinearity, phase noise, IQ
  mismatch) one at a time, verify each with Harmonic Balance testbenches and non-loading
  power taps, then drive with 5G/LTE/WLAN waveforms for EVM/ACLR/BER. Use when building
  RF models from budget specs or measured data, sweeping power for optimal back-off,
  finding the performance-limiting component, or comparing Circuit Envelope vs Idealized
  Baseband. Trigger: simrfV2, Configuration block, exportRFBlockset, exportTestbench,
  rfsystem, model_edit, RF Inport, RF Outport, S-parameter block, Amplifier, Mixer, IMT
  Mixer, Filter, Touchstone, noise figure, IQ imbalance, DPD, RF testbench, power meter,
  transducer gain, IP3, OIP3, IIP3, spectral regrowth, tall pole.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# RF Blockset Simulation in Simulink

Design, build, and validate RF systems using Circuit Envelope time-domain simulation.

## When to Use

**Top-down system design (budget specs to validated model)**
- Exporting an rfbudget chain to Simulink for time-domain simulation
- Progressively adding impairments to find the performance-limiting component ("tall pole")
- Verifying each impairment against analytical predictions (Friis, budget cascade)
- Driving the validated model with 5G/LTE/WLAN/radar waveforms for EVM/ACLR

**Bottom-up component validation (measured data to trusted model)**
- Building component models from Touchstone files or AM/AM measurements
- Validating model behavior against bench/datasheet in isolated testbenches
- Assembling validated components into a unified system model
- Confirming system-level metrics after integration

**In-system measurement and verification**
- Measuring gain, noise figure, IP3, S-parameters with testbench blocks
- Adding non-loading power taps at intermediate nodes
- Comparing Circuit Envelope vs Idealized Baseband simulation results
- Running power sweeps to find optimal operating point (back-off)

## When NOT to Use

- S-parameter analysis, rfbudget, matching networks (no Simulink) -- `matlab-model-rf`
- Antenna design and radiation patterns -- Antenna Toolbox
- SerDes link equalization (FFE, CTLE, DFE, IBIS-AMI) -- `matlab-model-serdes-systems`
- RF propagation (path loss, fading) -- Communications Toolbox

`matlab-*` skills need the MATLAB Agentic Toolkit installed.

## Must-Follow Rules

1. **Load the relevant reference before writing code.** Find your task in the Quick
   Reference table below and `Read` the listed file — it holds the exact library paths,
   parameter names, connection patterns, formulas, and diagnostic reasoning for that
   workflow, which are not derivable from general knowledge. Some key facts are inlined in
   the rules below, but the references hold the rest — including failure diagnostics you
   cannot guess. When a Quick Reference row flags something as non-obvious, read its file
   before coding.

2. **Use `rfsystem(b)` as the default build path.** It handles Configuration block
   wiring, port creation, sample rate, and StopTime automatically. When `rfsystem` cannot
   express the topology, export with `exportRFBlockset` and edit it with `model_edit`.

3. **Build and change model structure with the `model_edit` tool.** Add, connect, disconnect
   and replace blocks with `model_edit` operations; see `references/model-edit-operations.md`
   for the syntax and RF port names. If an operation fails, fix it from the error's
   suggestion; do not switch to `add_block` / `add_line`.

4. **Call `release(rfs)` before ANY model modification.** Before `model_edit`, `save_system`
   or `close_system` on an rfsystem model.

5. **Simulate an `rfsystem` model with `rfs(x)`, not `sim()`.** `sim()` defaults to
   StopTime=10s, hours at GHz carriers; `rfs(x)` sets it from the signal length. Testbench
   and exported models: `sim()` a `Simulink.SimulationInput` with finite StopTime (Rule 8).

6. **Use full library paths in `model_edit` `add_block`**, e.g. `simrfV2elements/Amplifier`, not
   `"Amplifier"`. Libraries: `simrfV2elements/`, `simrfV2util1/`, `simrfV2junction1/`,
   `simrfV2testbenches/`. Wrong paths are the #1 cause of failed adds — when in
   doubt, read `references/library-catalog.md`.

7. **One impairment at a time.** Add, measure, confirm impact, then proceed to the next.
   Never add multiple impairments simultaneously.

8. **Configure the testbench for the measurement type — this is the #1 measurement
   failure.** Each measurement needs specific noise, input power, and bandwidth settings;
   the defaults are wrong for most. Testbench blocks also default `StopTime` to `'inf'` —
   always set it finite before `sim()`.

   | Measurement | SimNoise | Input Power (`T_amp_dBm`) | Bandwidth (`Base_bw`) |
   |-------------|----------|---------------------------|-----------------------|
   | Gain | off (on usually fine) | low / linear (≤ −10 dBm) | default OK |
   | Noise Figure | **on** (required — the exception) | −20 to −30 dBm | **< 1 kHz** |
   | IP3 / IP2 | **off** (noise floor can bury the IMs) | low, avoid higher-order (≤ −20 dBm) | default OK |
   | S-Parameters | n/a | small (linear) | default OK |

   IQ-to-RF stimulus: in Gain, IP3 and the other standard modes, `IQMeasureStr` must drive
   I and Q in quadrature onto the desired sideband (`Q = -1j * I` when `Fout` = LO + `Fin`) —
   I only reads gain 6 dB low.

   IQ-specific measurements (noise **off**): **Sideband Suppression** drives I+Q itself
   (`IQMeasureStr` is hidden and has no effect); set `InjectionTypeStr` to the DUT's LO side —
   `'Low-side'` when LO < `Fout` (`Fout` = LO + `Fin`), `'High-side'` when LO > `Fout` —
   otherwise it compares the wrong pair of tones; **DC Offset / Image Rejection / Carrier
   Feedthrough** need `Base_bw` < 1 kHz.
   Full parameter tables, StopTime formula, and IP3 power-sweep procedure:
   `references/measure-testbench.md`.

9. **Hand off a system as .mat + .slx + demo script.** The model must be resimulatable
   from a clean MATLAB session without requiring the build script to run first.

## Top-Down Workflow

**Philosophy:** Start with a working system, break it realistically. The system always
simulates at the current fidelity level. Each step introduces one new degradation source,
letting you pinpoint exactly which impairment limits performance.

### Step 1: Build from Budget Specs

Create the RF chain with rfbudget and export to Simulink. The budget provides a
validation reference at every cascade stage.

```matlab
lna = amplifier(Name='LNA', Gain=15, NF=2, OIP3=20);
mix = modulator(Name='Mixer', Gain=-6, NF=10, OIP3=15, ...
    LO=2.4e9, ConverterType='Down');
ifamp = amplifier(Name='IF_Amp', Gain=20, NF=5, OIP3=30);
b = rfbudget([lna mix ifamp], 2.4e9, -30, 20e6);      % budget input: -30 dBm

rfs = rfsystem(b, ModelName='rx_topdown');
x = 0.001 * exp(1j*2*pi*1e6*(0:499)'/( 1/rfs.SampleTime));   % |x|^2 = 1e-6 W = -30 dBm
y = rfs(x);
fprintf('Gain: %.1f dB\n', 10*log10(rms(y)^2/rms(x)^2));
```

`[y1, ..., yN] = rfs(x)` returns one output per `Out%d`, in port order. Repurpose `Tx=N`
outputs (RF Outport sensors) as non-loading mid-chain taps; `rfs.SLOutputs = K` adds K bare
Simulink outputs. Keep the generated
`In%d`/`Out%d`/`Configuration%d` names -- rfsystem finds them by name. Full pattern:
`references/multi-port-models.md`.

See `references/build-from-budget.md` for export paths, multi-chain arrays, and model
persistence patterns.

### Step 2: Add Impairments One at a Time

Release the rfsystem, set the block parameters with a `model_edit` `configure` on
`rfs.ModelName` (block ID from `model_read`), re-simulate; `rfs(x)` uses the edited model.
Add each impairment independently so its system impact is isolated. Mixer phase noise
(JSON wrapped here; pass it on one line):

```json
[{"op":"configure","target":"<Mixer id>","params":{"AddPhaseNoise":"on",
  "PhaseNoiseOffset":"[1e3 1e4 1e5 1e6]","PhaseNoiseLevel":"[-80 -100 -120 -140]"}}]
```

Then `y_with_pn = rfs(x);`.

After each impairment: measure the affected metric. If it pushes below spec, this is
the tall pole -- allocate engineering effort here.

**Primary impairment reference:** `references/impairment-catalog.md` — contains
workflow recipes, parameter gotchas, and visualization code for all impairment types:
phase noise, IQ imbalance, polynomial nonlinearity, memory PA, mixer spur tables,
antenna patterns, filter redesign. **Read this file first for any impairment task.**

Verify configuration using the block's built-in visualization (phase noise spectrum,
power characteristics, filter response, IMT spur chart). These functions require a
non-trivial calling convention (private path, dialog handle) — **you will fail if you
guess the API; read the recipe first:**
- Calling convention + code snippet: `references/impairment-catalog.md` § "Built-in Visualization Functions"
- Raw parameter lists, per-function: `references/ce-block-plot-functions.md`

For filters inside system blocks (IQ Mod/Demod), see `references/filter-visualization.md`.

**Antenna block modes:** Switching from Isotropic to 'Antenna object' requires Antenna
Toolbox license. TX uses `CarrierFreqRad`/`rDep`, RX uses `CarrierFreqInc`/`rArr` --
never mix them. The antenna object must be **resonant/matched (S11 < −10 dB) at the
system LO frequency**, and `CarrierFreqInc`/`CarrierFreqRad` must equal that LO — a
mismatched antenna makes the model fail to simulate.

Unlike an Isotropic radiator (scalar signal), an antenna object receives/transmits a
3-D `[samples × carriers × 2]` signal (3rd dim = theta/phi polarization) — so switching
to one requires replacing the block's scalar wave source with a polarized `[N×C×2]`
source. See `references/antenna-wave-ports.md` for the Concatenate wiring.

### Step 3: Verify with Testbench or Power Tap

Use Harmonic Balance (StopTime=0) with testbench blocks for scalar metrics (gain, NF,
IP3). Use non-loading power taps for in-system monitoring: `SensorType='Ideal voltage'` is
what makes a tap non-loading (ZL is irrelevant for it); `'Power'` inserts a matched load. As
`model_edit` operations (node ID from `model_read`):

```json
[{"op":"add_block","type":"simrfV2util1/Outport","name":"Tap_Pre_PA","ref":"tap","params":
  {"SensorType":"Ideal voltage","CarrierFreq":"2.4","CarrierFreq_unit":"GHz"}},
 {"op":"add_block","type":"dspstat3/Power Meter","name":"Tap_Power_Meter","ref":"pm",
  "params":{"OutputPowerUnits":"dBm","ReferenceLoad":"50"}},
 {"op":"connect","target":"<node id>.RConn1 <-> #tap.LConn1"},
 {"op":"connect","target":"#tap.y1 -> #pm.u1"}]
```

See `references/measure-testbench.md` for exported testbench workflows and
`references/measure-power-tap.md` for the full tap pattern with validation.

### Step 4: Drive with Real Signals

Only after incremental validation confirms each impairment is correctly modeled.
Generate standard-compliant waveforms and measure system-level metrics.

```matlab
% Scale waveform to target input power
targetPower_dBm = -15;
currentPower_dBm = 10*log10(mean(abs(x).^2) / 1e-3);
x_scaled = x * 10^((targetPower_dBm - currentPower_dBm)/20);

% Simulate with settling padding
y = rfs([x_scaled; zeros(200,1)]);
y = y(201:end);
release(rfs);
```

See `references/simulate-with-signals.md` for waveform generation (5G/LTE/WLAN/radar),
EVM/ACLR/BER measurement, power sweeps, and multicarrier IMD analysis.

## Bottom-Up Workflow

**Philosophy:** Build trusted bricks, then assemble the wall. Each component is
validated in isolation against measured data before connecting into a larger system.

### Step 1: Build from Measured Data

Import Touchstone files or AM/AM curves, create isolated testbenches. Every measured file
gets this treatment, passive filters included: reading the file with `sparameters`/`rfparam`
checks the data, not the `nport` element the system will simulate.

```matlab
pa_element = nport('pa_measured.s2p');
b_pa = rfbudget(pa_element, 2.4e9, -10, 20e6);
exportTestbench(b_pa);  % Validate PA in isolation
```

See `references/build-from-data.md` for component testbenches and S-parameter import.

### Step 2: Validate Against Hardware

Run the isolated testbench, compare metrics against datasheet or bench measurements.
Adjust model parameters until simulation matches reality.

See `references/measure-testbench.md` for measurement configuration (gain, NF, IP3,
S-parameters) and convergence strategies.

### Step 3: Assemble Validated Components

Once all components are individually trusted, build the full system.

```matlab
lna = amplifier(Name='LNA', Gain=15, NF=2, OIP3=20);
pa = nport('pa_measured.s2p');
b_full = rfbudget([lna pa], 2.4e9, -30, 20e6);
rfs = rfsystem(b_full, ModelName='tx_validated');
```

To customize the exported model beyond a linear cascade (e.g., inserting couplers, splitters,
or taps between stages), read `references/model-edit-operations.md` — it has the junction
block port structure, break-and-reconnect recipe, and correct library paths. RF block names
and paths are non-obvious (e.g., `simrfV2junction1/Coupler`, not `simrfV2elements/...`).

For a **switched** topology (TR module, mode-selected chains), read
`references/tr-module-recipe.md` — it has the three-SPDT ring, the throw assignment, and the
parameters that make isolation and junction mismatch real. Switch / variable-attenuator /
variable-phase-shift mask names are tabulated in `references/ce-block-parameters.md`.

### Step 4: Verify System Meets Spec

Run full system simulation and check against requirements. If not meeting spec,
disable impairments one by one (tall-pole hunt in reverse) to find which component
interaction is the problem.

See `references/simulate-with-signals.md` for system-level metrics and CE vs IB
comparison workflow.

## Circuit Envelope vs Idealized Baseband

The Library choice is the fundamental efficiency decision (30-150x speed difference).

| Use CE When | Use IB When |
|-------------|-------------|
| Multi-carrier simulation | Single-carrier sufficient |
| Impedance mismatch matters | Well-matched (50 Ohm) |
| Harmonics/spurs needed | Only in-band behavior |
| Small system or short sim | Large array or long sim |
| You're unsure -- CE is always correct | Verified equivalent to CE |

**Progression:** CE first (validate) -> verify IB equivalence -> scale with IB.

To switch Library, recreate from rfbudget: `rfs = rfsystem(b, Library='IdealizedBaseband')`.
The Library property is read-only after creation.

See `references/ce-vs-idealized.md` for the detailed comparison and validation workflow.

## Quick Reference

Load the reference for your task before writing code — it has the calling conventions,
parameter names, and code patterns for that workflow.

| Task | Start Here | Reference |
|------|-----------|-----------|
| Build ANY RF system from specs (incl. IQ/quadrature/image-reject) | `rfsystem(b)` or `exportRFBlockset(b)` | `references/build-from-budget.md` |
| Build from Touchstone/measured data | `nport('file.s2p')` + `rfbudget` | `references/build-from-data.md` |
| Custom topology (feedback, branching) | `model_edit`; SPDT has 3 ports: LConn1 common, RConn1/RConn2 switched | `references/model-edit-operations.md` |
| Switched TX/RX (TR) module | Ring: TX and RX chains both reach the shared attenuator+phase-shifter path. Put TX on the SAME throw of all three SPDTs so ONE uninverted control drives them all; let the 50 Ω gateways terminate the throws (no dump resistors); set `Vthres` BETWEEN the control levels — the default `0` never switches | `references/tr-module-recipe.md` |
| Switch / variable attenuator / variable phase shift parameters | `Vthres`, `LoadType`, `Iloss`/`Iiso`; `Att` input in **dB**; `Phase` input unit from `PhaseShift_unit` | `references/ce-block-parameters.md` § Switches and Signal-Driven Elements |
| Add phase noise, IQ imbalance, nonlinearity | `model_edit` `configure` after `release(rfs)` | `references/impairment-catalog.md` |
| Measure gain, NF, IP3, IQ metrics with testbench blocks | `exportTestbench(b)` or add from `simrfV2testbenches/`; configure per Rule 8 table; IP3 needs an iterative power sweep (§ Option B) | `references/measure-testbench.md` |
| Measure S-parameters (extract to Touchstone) | `Fin` = passband center via `sparameters()`; increase `Nbins` (FFT length) for narrowband DUTs; StopTime = `(Nports+1)*Nbins/Base_bw` | `references/measure-testbench.md` |
| Non-loading power tap / interstage monitoring; wrong mid-chain gain reading | TWO-part fix: (1) `SensorType='Ideal voltage'` (non-loading; ZL irrelevant) — a `'Power'` sensor mid-chain silently loads the node; (2) its output is then **VOLTAGE, not power** — convert with `P=\|V\|²/R` (a `1/sqrt(50)` gain before `Linear to dBm`, or in post-proc), else off by ~17 dB. Both needed; you cannot guess this — read the ref | `references/measure-power-tap.md` |
| Drive with 5G/LTE/WLAN, measure EVM/ACLR | `rfs(x_scaled)` | `references/simulate-with-signals.md` |
| Multicarrier / IMD3 measurement | `rfs.OutputFrequency = [f1 f2 2*f1-f2]` | `references/simulate-with-signals.md` |
| Choose CE vs Idealized Baseband | Topology and fidelity check | `references/ce-vs-idealized.md` |
| Configuration block solver settings | StepSize, Tones, Harmonics, Noise | `references/configuration-block.md` |
| Block library paths and port names | Full path per block (Rule 6) | `references/library-catalog.md` |
| Dropdown (enum) values for Inport / Outport / Configuration / SPDT | Exact accepted strings, tabulated -- `SensorType`, `OutputFormat`, `SimulinkInputSignalType`, `SolverType`, `CharType`, `LoadType`; don't probe for them | `references/library-catalog.md` § Gateway Block Enumerated Values |
| Find and fix common simulation errors | Frequency mismatch, port errors | `references/common-failure-modes.md` |
| Full CE block parameter catalog | Every parameter name and value | `references/ce-block-parameters.md` |
| Built-in mask plot functions | `simrfV2plotparam`, `simrfV2plotfilter`, `simrfV2_plot_pn_chars`, `simrfV2dlg_mixerimt_plot`, `simrfV2expandblock` | `references/ce-block-plot-functions.md` |
| Waveform generation code templates | 5G NR, LTE, WLAN, Radar, custom | `references/waveform-generation.md` |
| Configuration solver tools (interactive) | Frequency plot, solver selection | `references/configuration-block-tools.md` |
| Output rate conversion and decimation | Solver rate to signal rate | `references/post-processing.md` |
| Antenna wave ports (InputIncWave, EIRP) | Polarized source, dimension reqs | `references/antenna-wave-ports.md` |
| Upgrade rfantenna to Channel block | txsite/rxsite, propagation models | `references/antenna-channel-upgrade.md` |
| IR/CS filter visualization inside blocks | Plot internal filter response | `references/filter-visualization.md` |
| Edit System (block decomposition) | `simrfV2expandblock` recipe | `references/edit-system-decomposition.md` |
| Outport signal extraction (Simulink path) | SensorType, dual I/Q, rate conversion | `references/outport-extraction.md` |
| Multi-port models (Tx=N, Rx=N, port swap) | Mid-chain taps, multi-input, exportRFBlockset | `references/multi-port-models.md` |
| Self-contained delivery package | .mat + .slx + demo script | `references/delivery-pattern.md` |
| Text projection of a built model (blocks, params, connections) | `PortConnectivity` dump -- branch-safe, unlike a line walk | `references/delivery-pattern.md` |

## Conventions

### Code Style
- Use `tiledlayout`/`nexttile` for multi-panel figures (not `subplot`)
- Label axes with units (GHz, dB, dBm) and include figure titles
- Name elements descriptively for readable topology (`'LNA'`, `'IF_Amp'`, `'PA'`)
- Use `clone()` for element reuse in rfbudget (same object cannot appear twice)
- Use `rfplot` for S-parameter plots (handles dB conversion)

### Script-First Workflow
Write design, analysis, and sweep code to `.m` files on disk; inline `evaluate_matlab_code` is
fine for quick one-off checks.

### Key Invariants (apply across all workflows)
- Configuration block must be physically wired (`LConn1 <->`) to the RF network
- Port names in `model_edit`: use `LConn1`, `RConn1` (not model_read aliases)
- Physical connections use `<->`, signal connections use `->`
- RF Outport needs a Simulink Outport connected to its signal output
- To enumerate what is wired to what, read `PortConnectivity` per block -- do NOT loop
  `find_system(...,'Type','Line')`. Physical lines branch at shared nodes and the child
  segments report `SrcBlockHandle <= 0`, so a line loop drops them. See
  `references/delivery-pattern.md` § Text Projection of a Model.
- A space substitutes for the newline when ADDRESSING a two-line block name
  (`'simrfV2elements/Variable Attenuator'` resolves fine) -- but `find_system` RETURNS the
  newline form, so `strcmp`/`contains` against a space-form path reports it as absent.
  Normalize with `strrep(name, newline, ' ')` before matching or printing.

### If Something Fails
- **Block path not found:** read `references/library-catalog.md` — names differ from common
  terminology (coupler is `simrfV2junction1/Coupler`, not `simrfV2elements/Directional
  Coupler`; testbenches are in `simrfV2testbenches/`, with the trailing 's').
- **Simulation hangs or seems infinitely slow:** testbench StopTime defaults to 'inf' (Rule 8).
  S-Parameter Testbench: `(NumOfPorts+1)*Nbins/Base_bw` (38.4 μs for 2-port defaults; see
  `references/measure-testbench.md` § Computing StopTime). For `rfsystem`, use `rfs(x)` (Rule 5).
- **Rerouting lines or adding/deleting/replacing blocks in an existing model** (e.g.
  changing what feeds a measurement block): use `model_edit`, which addresses blocks by stable
  ID; do NOT hand-trace lines by block name. See
  `references/model-edit-operations.md` § "Rerouting an Existing Signal Line".
- **S-parameter measurement shows garbage or extreme attenuation:** Two common
  causes: (1) `Fin` is outside the DUT passband -- if the DUT has a BPF, read its
  S2P file with `sparameters()` to find the passband center and set `Fin` there;
  (2) `Nbins` (FFT length) is too small for narrowband/dispersive DUTs -- increase
  it so the measurement window captures the full impulse response (`fft_size` is
  internal = `Nbins*OS`, don't set directly). See
  `references/measure-testbench.md` § S-Parameter Testbench Notes.
- **Testbench measurement wrong (gain, IP3, NF):** Wrong noise/power/bandwidth for the
  measurement type — see the Rule 8 table.

----

Copyright 2026 The MathWorks, Inc.

----
