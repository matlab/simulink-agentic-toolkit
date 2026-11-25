# Multi-Port Models and Programmable Exports

Strategies for creating RF models with multiple I/O ports for mid-chain observation,
multi-input injection, or custom signal routing.

## Decision Table

| Need | Best Approach | Section |
|------|--------------|---------|
| One or more mid-chain taps on an `rfsystem` model | `model_edit` tap + `rfs.SLOutputs` | Pattern D |
| N parallel copies of the chain (array, diversity TX) | `rfsystem(b, Tx=N)` | Pattern A |
| Multiple independent input injection | `rfsystem(b, Rx=N)` | Pattern B |
| Full control of source and sink routing | `exportRFBlockset(b)` + `model_edit` port swap | Pattern C |

**Default recommendation:** start from `rfsystem` (it wires the Configuration block, the
Inport/Outport pairs and the Simulink domain bridge), then make every structural change
with `model_edit`, addressing blocks by the IDs `model_read` returns.

## Pattern A: Tx=N Parallel Chains

`rfsystem(b, Tx=N)` creates N parallel copies of the chain behind a Wilkinson divider at
the input (a subsystem whose RF ports are named `p_1_x2B_`, `p_2_x2B_`, ...), each copy with
its own RF Outport + `Out%d` pair. Use it when you want N chains, not to get a mid-chain
tap: for taps, add them to a single chain (Pattern D). Note that a chain whose output is
at 0 Hz (LO equal to the RF carrier) builds an IQ demodulator, so each copy has two
outputs (I and Q) and `Tx=2` gives four.

`[y1, ..., yM] = rfs(x)` returns every output `rfs` manages, in port order: the `RFOutputs`
(RF Outport + `Out%d` pairs) plus `rfs.SLOutputs` bare Simulink `Out` ports. Outports
outside that count are ignored by `rfs(x)`; read those with `sim()` (see Pattern C).

## Pattern B: Rx=N for Multiple Input Injection

`rfsystem(b, Rx=N)` creates N parallel input chains with a Wilkinson Combiner at the
output. Each chain gets its own RF Inport + Simulink Inport pair.

### Calling Convention

```matlab
rfs = rfsystem(b, ModelName='rx_diversity', Rx=4);

% CORRECT: Separate arguments (one per input chain)
y = rfs(x1, x2, x3, x4);

% WRONG: Matrix input
% y = rfs([x1 x2 x3 x4]);  % ERROR: "Not enough input arguments"
```

Each `xN` is an independent column vector. All must have the same length.

### Use Cases

- Diversity combining (4-element array -> single output)
- Multi-port DUT testing (inject signals at different points)
- Beamforming receive array simulation

### Repurposing for Custom Topology

Same pattern as Tx=N: remove the Wilkinson Combiner and duplicate chains, repurpose
the extra Inport blocks as injection points at different nodes in the circuit.

## Pattern C: exportRFBlockset to Programmable Model

`exportRFBlockset(b)` creates a complete model with fixed source and display blocks.
Strip these to create a programmable model driven by arbitrary signals.

### What exportRFBlockset Generates

```
Constant(-30 dBm) -> "dBm to Linear ..." subsystem -> RF Inport -> [chain] -> RF Outport -> "Linear to dBm1" -> Display
```

The source chain provides a fixed-power CW tone. The output chain displays power in dBm.
Neither supports programmatic input/output.

### Conversion to Programmable Model

```matlab
b = rfbudget([lna mix ifamp], 2.4e9, -30, 20e6);
mdl = exportRFBlockset(b);
save_system(mdl, 'rx_programmable');
mdl = 'rx_programmable';
```

Then one `model_edit` call (block IDs from `model_read`; pass the JSON on one line). The
exported block names contain line breaks ("dBm to Linear
45[Deg] phase", "Available
input
power
(dBm)"); that does not matter, because `model_edit` addresses blocks by ID:

- `delete` the source chain: the input-power Constant and the "dBm to Linear" block;
- `delete` the readout chain: "Linear to dBm", the Subtract and both Display blocks;
- `add_block` a Simulink `In1` and connect it to the RF Inport's signal input `u1`;
- `add_block` a Simulink `Out1` and connect the RF Outport's signal output `y1` to it.

```json
[{"op":"delete","target":"<dBm to Linear id>"},{"op":"delete","target":"<Constant id>"},
 {"op":"delete","target":"<Linear to dBm id>"},{"op":"delete","target":"<Subtract id>"},
 {"op":"delete","target":"<Display id>"},{"op":"delete","target":"<Display id>"},
 {"op":"add_block","type":"simulink/Sources/In1","name":"Signal_In","ref":"si"},
 {"op":"connect","target":"#si.y1 -> <Inport1 id>.u1"},
 {"op":"add_block","type":"simulink/Sinks/Out1","name":"Signal_Out","ref":"so"},
 {"op":"connect","target":"<Outport1 id>.y1 -> #so.u1"}]
```

Save the model afterwards (`save_system(mdl)`).

### Simulating the Programmable Model

After port replacement, use `sim()` on a `Simulink.SimulationInput` with external input:

```matlab
in = Simulink.SimulationInput(mdl);
in = setExternalInput(in, timeseries(x_signal, (0:length(x_signal)-1)'/sampleRate));
in = setModelParameter(in, 'StopTime', num2str((length(x_signal)-1)/sampleRate));
simOut = sim(in);
y = simOut.yout{1}.Values.Data;
```

### When to Use exportRFBlockset Over rfsystem

| Scenario | Use exportRFBlockset |
|----------|---------------------|
| rfantenna is first or last element | YES (rfsystem fails with "Invalid Simulink object name") |
| Need visual model for manual editing | YES (opens with full UI display chain) |
| Standard programmatic simulation | NO (use rfsystem -- simpler, callable) |
| Need y=rfs(x) callable interface | NO (exportRFBlockset requires sim() after conversion) |

## Pattern D: Mid-Chain Tap on an rfsystem Model

Add an observation point to an existing `rfsystem` model without recreating it:

1. `release(rfs)`, then set `rfs.SLOutputs = 1` (one per tap). `rfsystem` adds a bare
   Simulink `Out` port (`Out2` after the main `Out1`) that `rfs(x)` will return.
2. With `model_edit` (block IDs from `model_read`), add an RF Outport with
   `SensorType='Ideal voltage'` (non-loading; `ZL` is ignored for it) and
   `OutputFormat='Complex Baseband'`, with `CarrierFreq` equal to the carrier AT THAT NODE
   (after a mixer: the IF), connect its `LConn1` to the node, and its `y1` to the new `Out`.
3. `[y, y_tap] = rfs(x)`. The tap returns node VOLTAGE: power is `mean(abs(y_tap).^2)/50`.

```json
[{"op":"add_block","type":"simrfV2util1/Outport","name":"MidChainTap","ref":"tap",
  "params":{"SensorType":"Ideal voltage","OutputFormat":"Complex Baseband",
  "CarrierFreq":"400","CarrierFreq_unit":"MHz"}},
 {"op":"connect","target":"<Mixer id>.RConn1 <-> #tap.LConn1"},
 {"op":"connect","target":"#tap.y1 -> <Out2 id>.u1"}]
```

Checked against `rfbudget` (LNA → down-mixer to 400 MHz IF → IF amp): main output -1.01 dBm
(budget -1.00), mixer-output tap -21.00 dBm (budget -21.00).

See `references/measure-power-tap.md` for the tap with a Power Meter readout and its
validation script.

## Cleanup Before Creating Models

Generated .s2p files (Wilkinson dividers, rffilter exports) persist on disk and cause
modal "already exists" dialogs on recreation:

```matlab
modelName = 'my_model';
if bdIsLoaded(modelName), close_system(modelName, 0); end
if exist([modelName '.slx'], 'file'), delete([modelName '.slx']); end
delete('*.s2p');  % Critical -- prevents modal dialog from rffilter/Wilkinson files
```

## Summary of Calling Conventions

| Pattern | Input | Output |
|---------|-------|--------|
| `rfsystem(b)` | `y = rfs(x)` single column | Single column |
| `rfsystem(b, Tx=N)` | `y = rfs(x)` single column | `[y1,...,yN] = rfs(x)` |
| `rfsystem(b, Rx=N)` | `y = rfs(x1, x2, ..., xN)` N separate args | Single column |
| `exportRFBlockset(b)` (converted) | External input via `sim()` | Via `simOut.yout` |
| Mid-chain tap (Pattern D) | Same as base model | `[y, y_tap] = rfs(x)` via `rfs.SLOutputs` |

## Gotchas

- **RF Outports default to a loading `'Power'` sensor.** Any Outport used as a mid-chain
  tap must be `SensorType='Ideal voltage'`.
- **`rfs(x)` ignores Outports it does not manage.** It returns `RFOutputs + SLOutputs`
  outputs; add extra ones with `rfs.SLOutputs`, or use `sim()`.
- **Rx=N requires separate arguments.** `rfs(x1, x2)` not `rfs([x1 x2])`.
- **Wilkinson .s2p files on disk.** Delete `*Wilkinson*.s2p` before recreating Tx/Rx
  models to prevent modal dialogs.
- **exportRFBlockset source block name varies.** The dBm-to-Linear subsystem name
  includes phase info (e.g., "dBm to Linear 45[Deg] phase"). Use `find_system` with
  `contains` rather than exact name matching.
- **Check the result with `model_read`** after structural edits: it lists every
  connection by block ID.
- **release(rfs) before any model modification.** Fast Restart lock blocks all model
  operations. Always call `release(rfs)` first.

----

Copyright 2026 The MathWorks, Inc.

----
