# Configuration Block Settings

The Configuration block manages the CE solver. It MUST be physically wired to the network.

## Key Parameters

| Parameter | Default | Purpose |
|-----------|---------|---------|
| `Tones` | Auto-detected | Carrier frequencies for the network |
| `Harmonics` | `[1]` per tone | Harmonic orders to track |
| `AutoFreq` | `'on'` | Auto-detect carriers from sources |
| `StepSize` | Auto | Solver time step (determines output rate) |
| `AddNoise` | `'on'` | Master noise switch for all blocks |
| `Temperature` | `290` K | Physical temperature for kT noise |
| `SolverType` | `'Auto'` | Integration scheme (NDF2 or Trapezoidal) |
| `RelTol` | `1e-3` | Newton solver relative tolerance |
| `AbsTol` | `1e-6` | Newton solver absolute tolerance |
| `MaxIter` | `10` | Newton iterations per step |
| `EnableInterpFilter` | `'on'` | Polyphase FIR at Inport boundary |
| `SmallSignalApprox` | `'off'` | Linearize after initial HB solution |

## AutoFreq and Simulation Frequencies

Default `AutoFreq="on"` detects carriers from the sources and picks harmonics automatically; keep it
unless simulation is too slow. In chains with several mixers and nonlinear stages (e.g. a
superheterodyne receiver) it can create a large number of simulation frequencies, and simulation
time grows with that number.

**When a simulation is too slow** for the waveform length you need:
1. Keep the result of a short run with `AutoFreq="on"` (EVM, spectrum or IM levels) as the reference.
2. Set `AutoFreq="off"` with explicit `Tones` and `Harmonics` (one value per tone: higher on the
   carrier driving nonlinear stages, `1` on weak tones); check the count with `Totalfreqs`
   (`references/configuration-block-tools.md`).
3. Re-run the short simulation; if it matches the reference, use the reduced set for the long run.

In a purely linear system the harmonic settings don't matter.

## StepSize and Signal Bandwidth

```
StepSize = 1 / (oversample x bandwidth)
```

| Scenario | StepSize | Example |
|----------|----------|---------|
| Fast check | 1/(4xBW) | 20 MHz BW -> 1/80e6 |
| Production | 1/(8xBW) | 20 MHz BW -> 1/160e6 |
| Wideband | 1/(4xBW) min | 100 MHz BW -> 1/400e6 |

The NDF2 scheme requires 1/(8xBW) for artifact-free results. Start with 1/(4xBW) for
initial testing.

## Tones and Harmonics

The union of Tones x Harmonics must include all Inport, CW source, and Outport frequencies.

**Linear systems:** Harmonics only matter for nonlinear components. Linear systems simulate
only required frequencies regardless of Harmonics setting.

**Start minimal:** Harmonics=[1]. Increase only if results change (indicating significant
harmonic content). Each additional harmonic multiplies computation.

## Noise Configuration

`AddNoise` is a **master switch** -- when `'off'`, no block adds noise regardless of
individual settings.

| Measurement | Noise Setting |
|-------------|--------------|
| EVM (isolating distortion) | OFF |
| ACLR (spectral regrowth) | OFF |
| BER (depends on SNR) | ON |
| Sensitivity | ON |
| Noise Figure testbench | ON (required) |

## Input Interpolation Filter

`EnableInterpFilter` (on Configuration block, not Inport) inserts a polyphase FIR when
input signal rate differs from 1/StepSize.

**Constraints:**
- Solver-to-input ratio must be exactly 2, 4, 6, or 8
- Limited to single Inport block
- Adds group delay (account for in EVM alignment)

**Disable when:** Input already resampled to match StepSize, or multiple Inports needed.

## Small-Signal Approximation

Solves nonlinear system once (HB), then linearizes for remaining time steps. Valid when
signal variations are small around operating point.

With `model_edit` `configure` on the Configuration block (ID from `model_read`). `configure` applies parameters one at a time, in the order given, so a parameter
that depends on another goes after it:
set `SimFreqs` BEFORE `AllSimFreqs` -- `AllSimFreqs='off'` with the default empty `SimFreqs`
fails mask initialization. `SimFreqs` must include all Inport/Outport CarrierFreq.

```json
[{"op":"configure","target":"<Configuration id>","params":{"SmallSignalApprox":"on",
  "SimFreqs":"[2.4e9]","SimFreqs_unit":"Hz","AllSimFreqs":"off"}}]
```

## Simulation Duration

**Never leave default StopTime (10 s) on CE models.** CE at GHz carriers with harmonics
means billions of steps at 10 s.

| Signal Type | Typical Duration |
|-------------|-----------------|
| CW verification | 1-10 us |
| 5G NR slot (15 kHz SCS) | 1 ms |
| 5G NR slot (30 kHz SCS) | 500 us |
| LTE subframe | 1 ms |
| WLAN HE-SU | 60-200 us |
| Radar pulse | pulse width + guard |

**Best practice:** Use `rfs(x)` instead of `sim(model)` -- simulation length equals
input vector length, naturally bounded.

## Signal Normalization

`NormalizeCarrierPower` (default `'on'`): Signals are normalized to RMS power (x sqrt(2))
entering RF domain, divided by sqrt(2) leaving. At DC carriers (CarrierFreq=0), no
normalization.

## Finding the Configuration Block Programmatically

`model_read` lists it (`BlockType: Configuration`); configure it by ID, e.g.
`{"op":"configure","target":"<Configuration id>","params":{"AddNoise":"off"}}`. In MATLAB
code: `configBlk = find_system(mdl, 'SearchDepth', 2, 'MaskType', 'Configuration');`

## Simulink Solver vs CE Fixed Time Grid

Both `rfsystem` export and RF Blockset model creation configure Simulink with a
**variable-step solver** (Auto). Do not change this to fixed-step -- fixed-step
requires all sample times to be manually aligned (integer multiples), which is fragile.

The CE domain's `StepSize` defines a fixed time grid for the RF network. The
variable-step solver hits every CE step point, and output from CE Outport blocks is
uniformly sampled at `1/StepSize`. Simulink handles rate transitions at domain
boundaries automatically.

**Rate transition at Inport boundary:** When input signal rate differs from `1/StepSize`,
Simulink performs a rate transition. Without `EnableInterpFilter`, this is a discrete
resampling (sample-and-hold) -- creates spectral images and aliasing artifacts.

## SolverType and Newton Convergence

`SolverType` (default: Auto) selects the CE integration scheme:
- **NDF2** -- most robust for stiff nonlinear circuits (PAs, mixers); requires the
  `1/(8*BW)` StepSize guard band
- **Trapezoidal** -- less damping but can ring

Newton tolerances (defaults: `RelTol=1e-3`, `AbsTol=1e-6`, `MaxIter=10`) work for most
behavioral RF. Only tighten if you see nonlinearity-related numerical artifacts:
- Convergence failure -> reduce StepSize or increase MaxIter
- Spectral edge artifacts -> switch from Trapezoidal to NDF2

## Signal Normalization and Framing

**`NormalizeCarrierPower`** (default `'on'`): Signals entering/leaving the RF domain
are normalized to RMS power (multiplied by sqrt(2) entering, divided by sqrt(2)
leaving). At DC carriers (`CarrierFreq = 0`) there is no normalization.

**Caution with IQ Mod/Demod:** I and Q ports receive DC (peak power), but RF output
carries RMS power. This sqrt(2) asymmetry can cause apparent 3 dB discrepancies.

**`SamplesPerFrame`** (default 1, max 1024): For interfacing with Communications
Toolbox frame-based blocks. The CE solver does not significantly accelerate with frames.

## EnableInterpFilter Constraints

- Solver-to-input rate ratio must be exactly 2, 4, 6, or 8
- Limited to a single Inport block
- Filter adds group delay — shown on the mask (`Filter delay (in samples): ...`) and also
  queryable programmatically after the model compiles:
  `feval(mdl,[],[],[],'compile'); d = get_param(cfgBlk,'UserData').FilterDelay; feval(mdl,[],[],[],'term');`
  (`d` is in SOLVER-rate samples). Note it only reports a non-zero value once the interp filter is
  actually engaged (input rate ≠ solver rate at a valid 2/4/6/8 ratio).
- Account for this delay when aligning output with reference waveforms for EVM. See
  `post-processing.md` ("Time Alignment") — a bulk cross-correlation alignment plus a quick
  decimation-phase search handles it; you do not need to read `FilterDelay` explicitly for a
  first-pass measurement.

**Disable when:** Input already resampled to match `1/StepSize` externally, or
multiple Inport blocks needed.

**Port rates vs solver rate:** rfsystem exports also set explicit sample times on the top-level
Simulink In/Out ports, independent of the solver `StepSize`. Feeding the input (Interpolate flag)
and extracting the output (sample-and-hold rate transition) each have gotchas — see
`references/simulate-with-signals.md` (input) and `references/post-processing.md` (output).

## Gotchas (duplicated here for convenience)

- **Never leave default StopTime (10 s).** CE at GHz carriers with harmonics = billions
  of steps at 10 s. Use `rfs(x)` (bounded by input length) or set StopTime explicitly.
  Typical: CW 1-10 us, 5G slot 1 ms, WLAN 60-200 us.
- **Configuration block must be wired.** `Config.LConn1 <-> anyNetworkNode`. Not wired ->
  build error "Each physical network must be connected to exactly one Solver Configuration."
- **AutoFreq ON (default): keep it unless simulation is too slow.** In multi-mixer chains it can
  create many simulation frequencies; reduce `Tones` / `Harmonics` after a short validation run
  (see "AutoFreq and Simulation Frequencies").
- **AddNoise is a master switch.** When 'off', NO block in the domain adds noise.
  Must be 'on' for NF measurement. Should be 'off' for EVM/ACLR (isolating distortion).
- **EnableInterpFilter ratio constraint.** Solver-to-input ratio must be exactly 2, 4, 6,
  or 8. Other ratios -> error or unexpected interpolation behavior.
- **Mid-circuit observation.** If adding Outport blocks for debugging, use
  `SensorType='Ideal voltage'` with `ZL='Inf'`. A Power sensor adds shunt resistance
  that changes circuit impedance at that node.

----

Copyright 2026 The MathWorks, Inc.

----
