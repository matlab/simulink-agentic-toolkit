# model_edit Operations for RF Blockset

**ALWAYS build and modify RF Blockset model structure with the `model_edit` MCP tool. Do NOT hand-write
`add_block`/`add_line`/`set_param` in a MATLAB script to construct topology — even when you also have to
produce a `.m` script.** Build the model interactively with `model_edit`; if a description of the
model-edit work is required, mirror the exact `model_edit` operations into a script as the written record
(it need not be independently re-executable). `model_edit` addresses blocks by `#ref`/`blk_N` and
connects physical ports by NAME with
`<->`; it resolves the connection, auto-layouts, and tracks errors, so you do NOT pre-compute port
handles or fight port orientation. This is the SATK-recommended path and avoids the slow, probe-heavy
port-handle guessing that hand-written `add_line` requires.

This file has no raw `add_block`/`add_line` recipes. If a `model_edit` operation fails, read its
error and suggestion (they name the valid port or parameter) and retry with the corrected
operation. Exported models whose block names contain line breaks need no special handling:
`model_edit` addresses blocks by `blk_N` ID, not by name.

## Tool Signatures

| Tool | Signature | Purpose |
|------|-----------|---------|
| `model_overview` | `model_overview(model)` | Compact hierarchy |
| `model_read` | `model_read(model)` or `model_read(model, scope)` | Detailed topology |
| `model_edit` | `model_edit(model, scope, operations, layout_mode)` (MCP tool) | Add/connect/configure/delete/replace |
| `model_query_params` | `model_query_params(model, blk_id, params_json)` | Query block parameters |

> Pass an explicit list of the parameters you want to `model_query_params`. `["all"]` returns
> the block's entire parameter set (~24 kB for three blocks, most of it generic Simulink
> internals) and is rarely needed -- the CE block parameters you actually set are already
> tabulated in `ce-block-parameters.md`, `configuration-block.md`, and `library-catalog.md`.

## Operation Types

```json
// Add blocks -- use full library path
{"op": "add_block", "type": "simrfV2elements/Amplifier", "name": "LNA", "ref": "lna"}
{"op": "add_block", "type": "simrfV2sources1/Continuous Wave", "name": "Src", "ref": "src"}
{"op": "add_block", "type": "simrfV2util1/Configuration", "name": "Config", "ref": "cfg"}
{"op": "add_block", "type": "simrfV2util1/Outport", "name": "Out", "ref": "out"}
{"op": "add_block", "type": "Outport", "name": "Signal_Out", "ref": "sigout"}

// Physical connections -- use ACTUAL port names, NOT model_read aliases
{"op": "connect", "target": "#src.LConn1 <-> #lna.LConn1"}
{"op": "connect", "target": "#lna.RConn1 <-> #out.LConn1"}
{"op": "connect", "target": "#cfg.LConn1 <-> #src.LConn1"}

// Signal connections -- standard Simulink arrow syntax
{"op": "connect", "target": "#out.y1 -> #sigout.u1"}

// Disconnect
{"op": "disconnect", "target": "blk_5.RConn1 <-> blk_6.LConn1"}

// Configure block parameters
{"op": "configure", "target": "blk_1", "params": {"Tones": "[2.4e9]", "Harmonics": "[3]"}}

// Delete block
{"op": "delete", "target": "blk_3"}
```

## Critical Rules

1. **Port names**
   - Physical (RF) ports are `LConn1`, `LConn2`, ... and `RConn1`, `RConn2`, ...
   - Simulink signal ports are `u1`, `u2`, ... (inputs) and `y1`, `y2`, ... (outputs)
   - `model_read` lists connections with these same names; use them as shown

2. **Physical vs signal connections**
   - Physical (RF domain): `<->` bidirectional
   - Signal (Simulink): `->` directional
   - Switched/signal-driven blocks (SPDT/SPST `Vctl`, Variable Attenuator, Variable Phase
     Shift) mix both domains. For the control input use the **numeric** signal port `u1` with
     `->`, NOT the mask name: `#modeC.y1 -> #sw1.u1` (not `... -> #sw1.Vctl`). The mask names
     (`Vctl` etc.) name the mask, not a connectable port, and `model_edit` rejects them with
     "Cannot resolve destination port 'Vctl' ... use a numeric port (e.g. u1)".

3. **layout_mode**
   - `"full"` -- new model from scratch (arranges all blocks)
   - `"incremental"` -- adding to existing model

4. **Block references**
   - Use `#ref` syntax in the same call that defines `"ref": "name"`
   - Use `blk_N` IDs from previous model_edit responses for subsequent calls

5. **Configuration block MUST be physically connected**
   - Has a single `LConn1` port
   - Wire to any node: `#cfg.LConn1 <-> #src.LConn1`
   - Without this: "Each physical network must be connected to exactly one Solver Configuration block"

## Physical Port Names by Block Type

| Block | LConn ports | RConn ports | Notes |
|-------|-------------|-------------|-------|
| Configuration | 1 (network tap) | -- | Must connect to network |
| CW Source | 1 (output) | -- | Signal source |
| Amplifier | 1 (RF in) | 1 (RF out) | Standard 2-port |
| Power Amplifier | 1 (in) | 1 (out) | Memory effects |
| Mixer | 2 (RF, LO) | 1 (IF) | LConn1=RF, LConn2=LO |
| IMT Mixer | 2 (RF, LO) | 1 (IF) | Same as Mixer |
| S-Parameters | 1 (in) | 1 (out) | 2-port network |
| S-Parameters (N-port) | N/2 | N/2 | LConn=odd ports, RConn=even ports |
| Filter | 1 (in) | 1 (out) | 2-port |
| Coupler | 2 (**in**=LConn1, **isolated**=LConn2) | 2 (**through**=RConn1, **coupled**=RConn2) | 4-port directional coupler (not 3-port) |
| Divider | 2 (**in**=LConn1, **out2**=LConn2) | 1 (**out1**=RConn1) | T power split — input + one output share the LEFT side (see note) |
| Circulator | 2 (port1, port3) | 1 (port2) | Non-reciprocal |
| Termination | 1 (connects to node) | -- | Matched load (set Z) |
| Gnd | 1 (connects to node) | -- | Short to ground |
| RF Outport | 1 (input from network) | -- | Also has signal output `y1` |
| RF Inport | -- | 1 (output to network) | Also has signal input `u1` |

## Working Example: Build a Cascade with `model_edit` (default path)

Build the whole chain with `model_edit` add/connect/configure ops — this is the normal way to
construct a model, not a special case.

Create and save an empty model (`new_system('my_rf_model'); save_system('my_rf_model')`),
then call the `model_edit` tool with `model` = `my_rf_model`, `scope` = `root` and
`layout_mode` = `full` (pass the JSON on one line):

```json
[{"op":"add_block","type":"simrfV2util1/Configuration","name":"Config","ref":"cfg"},
 {"op":"add_block","type":"simrfV2sources1/Continuous Wave","name":"Src","ref":"src"},
 {"op":"add_block","type":"simrfV2elements/Amplifier","name":"LNA","ref":"lna"},
 {"op":"add_block","type":"simrfV2util1/Outport","name":"RFOut","ref":"rfout"},
 {"op":"add_block","type":"Outport","name":"Signal_Out","ref":"sigout"},
 {"op":"connect","target":"#src.LConn1 <-> #lna.LConn1"},
 {"op":"connect","target":"#lna.RConn1 <-> #rfout.LConn1"},
 {"op":"connect","target":"#cfg.LConn1 <-> #src.LConn1"},
 {"op":"connect","target":"#rfout.y1 -> #sigout.u1"}]
```

Then configure each block by the `blk_N` ID the response returns (`layout_mode` =
`incremental`):

```json
[{"op":"configure","target":"<Src id>","params":{"CWSourceType":"Power","MagPower":"1e-4",
  "CarrierFreq":"2.4e9","Z0":"50"}},
 {"op":"configure","target":"<LNA id>","params":{"linear_gain":"15","NF":"2","IP3":"20"}},
 {"op":"configure","target":"<RFOut id>","params":{"CarrierFreq":"2.4e9"}}]
```

## Edit System (Block Decomposition)

System blocks (IQ Modulator, IQ Demodulator, Channel) can be decomposed into internal
components. Use when mask parameters are insufficient.

```matlab
blk = [mdl '/IQMod'];

% Bypass modal dialog
tmpDir = fullfile(tempdir, 'questdlg_override');
if ~exist(tmpDir, 'dir'); mkdir(tmpDir); end
fid = fopen(fullfile(tmpDir, 'questdlg.m'), 'w');
fprintf(fid, 'function answer = questdlg(varargin)\nanswer = ''Edit System'';\nend\n');
fclose(fid); addpath(tmpDir);

old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(blk);
simrfV2expandblock(blk, simrfV2_find_dialog(blk));
cd(old); rmpath(tmpDir); delete(fullfile(tmpDir, 'questdlg.m')); rmdir(tmpDir);
```

## Inserting Multi-Port Junction Blocks

To insert a block inline (e.g., a directional coupler between PA and filter), do it with `model_edit`:
`disconnect` the existing line, `add_block` the junction, and `connect` the new physical ports by name
with `<->` — see the branch recipe above. The port-role table and notes here tell you which named ports
to connect. This works in exported models too (blocks are addressed by ID); see the coupler
recipe below.

### Junction Block Port Structure

| Block | LConn ports | RConn ports | Notes |
|-------|-------------|-------------|-------|
| Coupler | 2 (**in**=LConn1, **isolated**=LConn2) | 2 (**through**=RConn1, **coupled**=RConn2) | 4-port directional coupler |
| Divider | 2 (**in**=LConn1, **out2**=LConn2) | 1 (**out1**=RConn1) | T power split — NOT 1-in/2-RConn; see note |
| Circulator | 2 (port1, port3) | 1 (port2) | Non-reciprocal |
| SPDT | 1 (In=LConn1) | 2 (Out1=RConn1, Out2=RConn2) | Switchable; also a `Vctl` signal input |
| SPST | 1 (In=LConn1) | 1 (Out=RConn1) | Same parameters as SPDT; also a `Vctl` signal input |
| Variable Attenuator | 1 (In=LConn1) | 1 (Out=RConn1) | Plus an `Att` signal input, in **dB** |
| Variable Phase Shift | 1 (In=LConn1) | 1 (Out=RConn1) | Plus a `Phase` signal input (unit set by `PhaseShift_unit`) |

For the Coupler block (`simrfV2junction1/Coupler`) — a **4-port** directional coupler (2 LConn + 2 RConn):
- `LConn1` = **Input** port
- `RConn1` = **Through** port (main path continues here — on the RIGHT, opposite the input)
- `RConn2` = **Coupled** port (the tap, `−Coupling` dB below input; leave open or terminate if no detector yet)
- `LConn2` = **Isolated** port (`−(Coupling+Directivity)` dB, effectively nothing; terminate it)

> **Do not treat the Coupler as a 3-port.** It has 2 LConn + 2 RConn. The through path leaves `RConn1`
> (opposite the input), the coupled tap is `RConn2`, and `LConn2` — the port next to the input on the
> left — is the ISOLATED port. Terminate `LConn2`; never route the main signal path through it. When
> port roles matter, confirm them with the same one-line probe shown for the Divider below.

> **The Divider is 1-in / 2-out despite showing 2 ports on the left.** `simrfV2junction1/Divider` is a
> 3-port T power divider with **2 LConn + 1 RConn**. Its input and one of its two outputs both sit on
> the LEFT: `LConn1`=input, `LConn2`=second output, `RConn1`=first output. There is no `RConn2` —
> addressing one will error. When port roles matter, confirm them with a one-line probe rather than
> relying on memory: add the block with `model_edit` and `model_read` the scope, which lists every
> connection by port name (`LConn1`, `RConn1`, ...).

### Recipe (PREFERRED): Branch / Parallel Path with `model_edit`

For branching or parallel topologies (dividers, combiners, quadrature/Hartley splits, TR switches),
**build with `model_edit` connect ops, not hand-written `add_line`.** You address blocks by `#ref`/`blk_N`
and wire physical ports with `<->` by NAME — `model_edit` resolves the connection, auto-layouts, and
tracks errors, so you do NOT pre-compute port handles or fight port orientation. This is the SATK-
recommended path (`evaluate_matlab_code` + `set_param`/`add_line` bypasses autolayout and error recovery).

Example — a divider feeding two parallel amplifier branches that recombine (the skeleton of a Hartley /
image-reject or any split-process-combine stage):

```json
[
  {"op":"add_block","type":"simrfV2junction1/Divider","name":"Split","ref":"div"},
  {"op":"add_block","type":"simrfV2elements/Amplifier","name":"BranchI","ref":"ampI"},
  {"op":"add_block","type":"simrfV2elements/Amplifier","name":"BranchQ","ref":"ampQ"},
  {"op":"add_block","type":"simrfV2junction1/Divider","name":"Combine","ref":"comb"},

  {"op":"connect","target":"#div.RConn1 <-> #ampI.LConn1"},
  {"op":"connect","target":"#div.LConn2 <-> #ampQ.LConn1"},
  {"op":"connect","target":"#ampI.RConn1 <-> #comb.RConn1"},
  {"op":"connect","target":"#ampQ.RConn1 <-> #comb.LConn2"}
]
```

Key points:
- **Divider as a splitter:** feed `LConn1` (input); take the two outputs from `RConn1` and `LConn2`.
- **Divider as a combiner:** reverse it — the two branch outputs drive `RConn1`/`LConn2`, the merged
  signal leaves `LConn1`. (The T-divider is reciprocal; a real design uses a Wilkinson/combiner block,
  but the port mapping is the same 1↔2 pattern.)
- **Never write `RConn2` on a Divider** — it has only one RConn.
- Wire the whole branch in ONE `model_edit` call with `layout_mode:"full"` for a clean auto-layout, then
  a second `incremental` call to `configure` each block by its returned `blk_N` id.
- Exported models with newline block names are addressed by ID and need no workaround.

### Recipe: Switched TX/RX (TR) Module with a Shared Common Path

Two chains alternately owning one shared path to the antenna, routed by three SPDTs (common
on `LConn1`, throws on `RConn1`/`RConn2`). The full topology, parameters and the throw
assignment that lets one uninverted control drive all three switches are in the TR-module
recipe (Quick Reference row "Switched TX/RX (TR) module" in SKILL.md).

If you do park a throw on a dump load, note there is no Termination block — use
`simrfV2elements/R`, parameter **`Resistance`** (not `R`) — and that a resistor reachable
only through an off (high-impedance) throw becomes its own physical network, erroring with
*"Each physical network must be connected to exactly one Solver Configuration block"*.

### Recipe: Insert a Coupler Between Two Blocks, Isolated Port Terminated

`release(rfs)` first if the model belongs to an `rfsystem`. One `model_edit` call (block IDs from
`model_read`; pass the JSON on one line): `disconnect` the PA → filter line, add the Coupler, connect
input `LConn1` and through port `RConn1`, and terminate the isolated port `LConn2` in 50 ohm to
ground (`simrfV2elements/R`, parameter `Resistance`, plus `simrfV2elements/Gnd`; there is no
Termination block). The coupled port `RConn2` feeds the monitor path, or stays open.

```json
[{"op":"disconnect","target":"<PA id>.RConn1 <-> <Filter id>.LConn1"},
 {"op":"add_block","type":"simrfV2junction1/Coupler","name":"Coupler","ref":"cp"},
 {"op":"connect","target":"<PA id>.RConn1 <-> #cp.LConn1"},
 {"op":"connect","target":"#cp.RConn1 <-> <Filter id>.LConn1"},
 {"op":"add_block","type":"simrfV2elements/R","name":"Z_isolated","ref":"r",
  "params":{"Resistance":"50"}},
 {"op":"add_block","type":"simrfV2elements/Gnd","name":"Gnd_isolated","ref":"g"},
 {"op":"connect","target":"#cp.LConn2 <-> #r.LConn1"},
 {"op":"connect","target":"#r.RConn1 <-> #g.LConn1"}]
```

This also works in an `exportRFBlockset` model. Then simulate with `y = rfs(x);`.

### Rerouting an Existing Signal Line (Simulink/DSP domain)

To change what feeds a Simulink input (a `Subtract`, `Product` or measurement block, e.g. in an
`exportRFBlockset` output), `connect` the new source to that input. `connect` replaces the
connection already on the destination port (it reports `CONNECTION_REPLACED`), so no separate
delete is needed:

```json
[{"op":"connect","target":"<NewSrc id>.y1 -> <Subtract id>.u2"}]
```

Run `model_read` afterwards to confirm the new connection list.

### Unconnected Ports vs Disconnected Networks

- **Unconnected port** = open circuit (infinite impedance). Valid — solver treats it
  as a zero-current boundary. May cause reflections in the through path.
- **Disconnected network** = nodes not reachable from the Configuration block. This
  causes solver failure.

Disconnection can happen two ways:
1. **Topological:** block is not wired to anything connected to Configuration.
2. **Mathematical:** S-parameter matrix is block-diagonal, creating isolated
   subnetworks even though wires exist. E.g., a 4-port with zero coupling between
   port pairs (ports 1-2 isolated from ports 3-4) means the solver sees two
   independent circuits — only one has the Configuration block.

This is why the dedicated `simrfV2junction1/Coupler` block is preferred over
hand-built S-parameter files: the library block guarantees proper port coupling.
If using `simrfV2elements/S-parameters` with a custom .sNp file, ensure the
S-matrix has non-zero off-diagonal terms coupling all port groups that must
share the same solver network.

For realistic behavior (e.g., matched coupler), terminate the coupled port:
- `simrfV2elements/Termination` — matched load (set `Z` to system impedance)
- `simrfV2elements/Gnd` — short to ground
- `simrfV2elements/R` — specific resistance value

Termination is a modeling choice, not a solver requirement. The solver only fails
when portions of the circuit are disconnected (topologically or mathematically)
from the Configuration block.

### Alternative: S-Parameters Block for Custom Multi-Port

If the dedicated junction block doesn't match your device, use
`simrfV2elements/S-parameters` with an .s4p file:

```matlab
% Create a 4-port S-parameter file programmatically
sparams = sparameters(S_matrix, freq);
rfwrite(sparams, 'coupler.s4p');
```

Add it with `model_edit` (`add_block`, or `replace_block` on an existing Coupler, which keeps its
connections):

```json
[{"op":"replace_block","target":"<Coupler id>","type":"simrfV2elements/S-parameters",
  "params":{"File":"coupler.s4p"}}]
```

Port mapping for an N-port S-parameters block: `LConn1..LConn(N/2)` are the odd ports and
`RConn1..RConn(N/2)` the even ports; for 4 ports, `LConn1`=port 1, `RConn1`=port 2,
`LConn2`=port 3, `RConn2`=port 4. Unused ports are open (valid); terminate with R + Gnd for a
matched load.

## Simulating After Model Edits

### Priority 1: Use `rfs(x)` (System Object Stepping)

After modifying an rfsystem model, **use `rfs(x)` to simulate**. The callable
interface auto-computes StopTime from the input signal length. This is always
the first choice when you have an rfsystem object.

```matlab
release(rfs);
% ... make model edits ...
save_system(rfs.ModelName);
y = rfs(x);  % StopTime auto-set from length(x)/SampleRate
```

### Priority 2: `sim()` with Explicit StopTime

When you need internal signals (e.g., tap outputs) that `rfs(x)` doesn't expose,
use `sim()` on a `Simulink.SimulationInput` with StopTime from the signal duration (the
model itself is not changed; verified to match `rfs(x)`):

```matlab
release(rfs);
Fs = 1 / rfs.SampleTime;
in = Simulink.SimulationInput(rfs.ModelName);
in = setExternalInput(in, timeseries(x, (0:length(x)-1)'/Fs));
in = setModelParameter(in, 'StopTime', num2str((length(x) - 1) / Fs));
simOut = sim(in);
y = simOut.yout{1}.Values.Data;
```

Never simulate without setting StopTime — the default (often 10s) at GHz
carriers requires billions of solver steps.

### Priority 3: Pause-and-Assess (Unknown Duration)

When StopTime is uncertain or you inherited a model with unknown configuration,
use `Simulink.Simulation` with a wall-clock gate:

```matlab
sm = simulation(mdl);
start(sm);

% Wall-clock gate: let it run 60 seconds
pause(60);

if sm.Status == "running"
    pause(sm);  % Simulink pause — halts solver

    simTime = sm.SimulationTime;
    stopTime = str2double(get_param(mdl, 'StopTime'));
    progress = simTime / stopTime;

    if progress < 0.1  % Less than 10% done after 60s
        % Step once to measure per-step wall-clock cost
        stepSize = str2double(get_param(mdl, 'FixedStep'));
        tic;
        step(sm, PauseTime=simTime + stepSize);
        stepWall = toc;

        stepsRemaining = (stopTime - simTime) / stepSize;
        estimatedRemaining = stepsRemaining * stepWall;

        if estimatedRemaining > 300  % >5 min remaining
            stop(sm);
            error('Simulation too slow (~%.0f min left). Reduce StopTime or use rfs(x).', ...
                estimatedRemaining/60);
        end
    end
    resume(sm);
end
```

This pattern avoids both unnecessary probe runs and unbounded hangs.

## Preventing Modal Dialogs

Modal dialogs block execution with no recovery:

```matlab
% Before new_system:
if bdIsLoaded('m'); close_system('m', 0); end
if exist('m.slx', 'file'); delete('m.slx'); end

% Always use close_system with 0 flag (skips save prompt):
close_system(model, 0);
```

## Gotchas (duplicated here for convenience)

- **Port names:** `LConn1`/`RConn1` for physical ports, `u1`/`y1` for Simulink signals;
  for mixed-domain blocks use the numeric signal port (`u1`), not a mask name like `Vctl`.
- **Use full library paths.** `simrfV2elements/Amplifier`, not `"Amplifier"`. Short names
  match the wrong block (e.g., `"Configuration"` -> 76% confidence wrong block).
- **Physical vs signal connections.** Physical (RF domain): `<->`. Signal (Simulink): `->`.
  Using `->` between RF blocks fails silently.
- **release(rfs) before model_edit.** If rfsystem was used (`rfs(x)` called), Fast Restart
  is active. model_edit will fail or produce unexpected results. Always release first.
- **layout_mode matters.** Use `"full"` for new/empty models (auto-layouts everything).
  Use `"incremental"` for modifications to existing models (preserves layout).
- **Configuration block must exist and be wired.** After adding blocks manually, the
  Configuration block must be physically connected (`LConn1 <->`) to some node in the
  network. Without it, simulation fails.
- **save_system after edits.** model_edit changes are in-memory only. Without
  `save_system(mdl)`, changes are lost on close or reload.
- **Use `rfs(x)` after model edits, NOT `sim()`.** The callable interface auto-sets
  StopTime from signal length (microseconds). Raw `sim()` uses default StopTime=10s,
  which at GHz carriers causes hours-long simulation. If you must use `sim()`, set
  StopTime on a `Simulink.SimulationInput` to match signal duration.
- **`configure` applies parameters one at a time, in the order given.** Unlike one
  `set_param` call, intermediate states are evaluated, so put a parameter after the ones it
  depends on: mode selectors (`Source_linear_gain`) first; on the Configuration block,
  `SimFreqs` before `AllSimFreqs='off'` (else mask initialization fails).
- **Junction block unused ports are open circuits.** Unconnected ports = infinite
  impedance (valid, but may cause reflections). For realistic matched-load behavior,
  terminate in R + Gnd (`simrfV2elements/R`, `simrfV2elements/Gnd`; there is no Termination block). Solver only fails if blocks are completely
  disconnected from the Configuration network.

----

Copyright 2026 The MathWorks, Inc.

----
