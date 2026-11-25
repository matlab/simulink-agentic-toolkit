# Build from Measured Data

Create component models from Touchstone files, AM/AM measurements, or EM-extracted data.
Validate each in isolation before assembling into a system.

## Component Testbench Workflow

```matlab
% Step 1: Create component budget for isolated validation
pa_element = nport('pa_measured.s2p');
b_pa = rfbudget(pa_element, 2.4e9, -10, 20e6);

% Step 2: Export to testbench -- validates in proper source/load context
exportTestbench(b_pa);
% Run testbench to compare S21 against Touchstone data

% Step 3: After validation, assemble full chain
lna = amplifier(Name='LNA', Gain=15, NF=2, OIP3=20);
pa = nport('pa_measured.s2p');
b_full = rfbudget([lna pa], 2.4e9, -30, 20e6);
rfs = rfsystem(b_full, ModelName='tx_validated');
```

**Noise from an `nport`.** If the simulation needs noise, note that an `nport` exports (through
`rfsystem` or `exportRFBlockset`) to an S-parameters block, which calculates noise only from the
S-parameter data (Bosma's theorem) and ignores the noise section of the `.s2p` file. If the data
isn't passive, as for an amplifier, the block warns `DataNotPassive` and adds no noise, while
`rfbudget` still reports the file's NF.

## S-Parameter Import Options

The `nport` element accepts Touchstone files directly:
```matlab
% From file (most common)
elem = nport('component.s2p', 'MyFilter');

% From sparameters object (after manipulation)
s = sparameters('raw.s2p');
s = newref(s, 50);  % Re-reference to 50 ohm
elem = nport(s, 'RematcedFilter');
```

## Bottom-Up Assembly Strategy

1. **Validate individually** using `exportTestbench(b_component)` -- creates self-contained
   measurement model with proper source/load termination
2. **Assemble the full system** as a single rfbudget/rfsystem (not cascaded rfsystem
   objects) to capture inter-stage interactions
3. If needed, `open_system(rfs)` and replace ideal blocks with validated models via `model_edit`

**Why not cascade rfsystem objects?** `y1 = rfs1(x); y2 = rfs2(y1)` is unidirectional --
no backward reflections propagate. Mismatch between stages is lost.

## Component Extraction (Top-Down to Bottom-Up Transition)

When the top-down designer identifies a tall pole and needs to validate against hardware:

| What Must Be Determined | Why It Matters |
|---|---|
| Configuration block carriers | Wrong frequencies -> meaningless simulation |
| Harmonic order | Too few -> misses intermod; too many -> slow |
| Input power level | Nonlinear behavior depends on drive level |
| Source impedance | Affects gain, stability, noise |
| Load impedance | Affects power delivery and reflection |

**Procedure:**
1. Identify component boundaries in existing model
2. Read Configuration block settings (use `model_query_params`)
3. Determine input signal characteristics from preceding stage
4. Create isolated model with appropriate source
5. Add correct termination (50 Ohm or actual in-system impedance)
6. Run measurement and compare to hardware/datasheet

## Replacing Ideal Blocks with Detailed Models

After validation, swap the ideal rfbudget element with the measurement-based model:

`release(rfs)`, then one `model_edit` `replace_block` on `rfs.ModelName` (block ID from
`model_read`). `replace_block` keeps the block's name, position and connections:

```json
[{"op":"replace_block","target":"<PA id>","type":"simrfV2elements/S-parameters",
  "params":{"File":"pa_measured.s2p"}}]
```

Then `y = rfs(x);` simulates with the measured PA (no save needed first; `save_system`
keeps the edit on disk). Verified: the output moves by the file's |S21| at the carrier.
After a `replace_block` the block has a new ID; `model_read` again before the next edit.

----

Copyright 2026 The MathWorks, Inc.

----
