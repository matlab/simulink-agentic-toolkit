# Common Failure Modes

Diagnostic table for RF Blockset simulation errors and unexpected results.

## Build Errors

| Symptom | Cause | Fix |
|---------|-------|-----|
| "Each physical network must be connected to exactly one Solver Configuration block" | Configuration block not wired | Wire `Config.LConn1 <-> anyNetworkNode` |
| Block type resolves to wrong block (76% match) | Short name `"Configuration"` ambiguous | Use full path: `simrfV2util1/Configuration` |
| `PORT_NOT_FOUND` error | Using model_read aliases in model_edit | Use actual names: `LConn1`, `RConn1` |
| "Expected Resistance in CW source to be positive" | CW Source Power mode with Z0=0 | Set `Z0` to `"50"` |
| "Cannot close model initialized in Fast Restart" | Forgot `release(rfs)` | Call `release(rfs)` before any model operation |
| "Apply or cancel unapplied changes in `<mdl>/<block>` before running the simulation" | A block dialog was opened (often by a mask query) and holds uncommitted edits | `close_system([mdl '/' blockName])` on each block touched, then `save_system(mdl)` — `release(rfs)` alone does not clear it |
| "Specified s-parameters ... are not passive. The block does not simulate with noise" (warning) | The S-parameter block derives thermal noise from Bosma's equation, which defines the noise correlation matrix of a *passive* multiport only. Non-passive data (gain anywhere, or measurement artifacts) has no such solution, so the block drops its noise contribution | Expected, not an error — the block still simulates its full frequency response. Loss-derived noise is undefined for non-passive data, so there is nothing to recover; if that stage's noise matters, model it explicitly with a separate noise source or an amplifier NF |
| Modal dialog blocks execution | Existing .slx file or unsaved model | Delete .slx before `new_system`; use `close_system(m, 0)` |

## Zero or Wrong Output

| Symptom | Cause | Fix |
|---------|-------|-----|
| Zero output amplitude | Outport CarrierFreq=0 (sensing DC) | Set CarrierFreq to match signal carrier |
| Zero output amplitude | Frequency mismatch (Config/Source/Outport) | Align all carrier frequencies |
| Simulation runs but no workspace data | Missing Simulink Outport after RF Outport | Add `Outport` block, connect `rfout.y1 -> out.u1` |
| Gain wildly wrong (e.g., -3000 dB) | Connection error or frequency mismatch | Check topology with `model_read` |
| 6 dB gain drop after adding tap | Tap has `SensorType='Power'` or finite ZL | Use `'Ideal voltage'` with `ZL='Inf'` |

## Performance Issues

| Symptom | Cause | Fix |
|---------|-------|-----|
| Simulation hangs (>60s no output) | Default StopTime=10s at GHz carrier | Use `rfs(x)` or set StopTime explicitly |
| Simulation hangs after model edit | Used `sim(mdl)` instead of `rfs(x)` after editing | Use `rfs(x)` — it auto-sets StopTime from signal length |
| Very slow simulation | Too many harmonics or too fine StepSize | Reduce Harmonics first; leave StepSize at the `1/(8xBW)` default — lowering it below that costs in-band accuracy (next two rows) |
| Output is garbled / EVM ~100% | SampleTime != rate of the vector fed | Match them — but resample the waveform UP, don't lower `SampleTime` below the default `1/(8xBW)` |
| In-band response far steeper than the filters justify | `SampleTime` lowered to the waveform's native rate — no headroom between occupied band and solver Nyquist, band-edge content attenuated | Resample waveform up to leave headroom; cross-check vs analytic `sparameters` |
| Convergence failure (Newton) | Nonlinear circuit, too large StepSize | Reduce StopSize or increase MaxIter |

## Measurement Errors

| Symptom | Cause | Fix |
|---------|-------|-----|
| NF measurement NaN or unstable | Noise OFF, or BW too wide | Noise ON, BW < 1 kHz |
| IP3 too low or inconsistent | Input power too high (higher-order products) | Reduce power, sweep until converges |
| Testbench sim runs forever | Default StopTime='inf' | Set finite StopTime: `sim(setModelParameter(Simulink.SimulationInput(mdl), 'StopTime', '10e-6'))` |
| Power meter shows wrong dBm | Wrong ReferenceLoad on meter | Match to system Z0 (50 Ohm) |
| S-param testbench: S21 ~ -80 dB | Fin outside DUT passband | Set Fin to passband center |

## rfsystem Errors

| Symptom | Cause | Fix |
|---------|-------|-----|
| "Invalid Simulink object name" with rfantenna | rfsystem can't handle rfantenna at endpoints | Use `exportRFBlockset(b)` instead |
| Modifications lost on reload | .slx not saved alongside .mat | `save_system(rfs.ModelName)` before `save('ws.mat')` |
| rfsystem regenerates from scratch | .slx not on path when loading workspace | Keep .slx in same directory as .mat |
| Can't change Library property | Read-only after creation | Recreate: `rfs = rfsystem(b, Library='...')` |
| "File already exists" dialog | Wilkinson .s2p from prior creation | Delete `*Wilkinson*.s2p` before creating multi-chain |

## Simulink Path Errors

| Symptom | Cause | Fix |
|---------|-------|-----|
| Only half the signal (EVM ~100%) | DC output: extracting only one of I/Q ports | Check `yout.numElements`; combine I + jQ |
| Spectral images/aliasing | EnableInterpFilter OFF with rate mismatch | Set `EnableInterpFilter='on'` on Configuration |
| 3 dB discrepancy | NormalizeCarrierPower sqrt(2) factor | Account for RMS vs peak normalization |

## Quick Diagnostic Checklist

When simulation produces unexpected results:

1. **Check frequencies:** Config Tones, Source CarrierFreq, Outport CarrierFreq all aligned?
2. **Check connections:** `model_read` shows physical network connected to Configuration?
3. **Check power level:** Is input driving DUT into unexpected compression?
4. **Check noise:** Is noise ON/OFF appropriate for the measurement?
5. **Check SampleTime:** Does it match the waveform you're injecting, AND does that rate
   oversample the occupied bandwidth? Both conditions, not just the first. One comparison of
   output power against `b.TransducerGain(end)`, with a CW tone near the band edge (not at the
   carrier), settles it. Only if that disagrees is
   it worth re-running at a higher oversampling ratio to see whether the measurement moves.
6. **Check StopTime:** Is it reasonable for the carrier frequency?

----

Copyright 2026 The MathWorks, Inc.

----
