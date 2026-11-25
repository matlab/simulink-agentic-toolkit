# Non-Loading Power Tap Pattern

Complete observation point: non-disturbing tap plus calibrated dBm readout.

## Pattern

```text
RF chain node
    |
    +-> RF Outport (SensorType='Ideal voltage') -> DSP Power Meter -> dBm
```

Build it with one `model_edit` call (block IDs from `model_read`; pass the JSON on one line):

1. **Tap:** an RF Outport (`simrfV2util1/Outport`) with `SensorType='Ideal voltage'`, an
   ideal (infinite-impedance) voltage probe that does NOT load the node. `ZL` only applies
   to a `'Power'` sensor, so leave it. Connect its `LConn1` to the node, here the PA input.
2. **Meter:** a DSP Power Meter (`dspstat3/Power Meter`) measuring average power in dBm,
   with `ReferenceLoad` equal to the system Z0.
3. **Wire** the tap's Simulink output `y1` to the meter's input `u1`.

```json
[{"op":"add_block","type":"simrfV2util1/Outport","name":"Tap_Pre_PA","ref":"tap",
  "params":{"SensorType":"Ideal voltage","OutputFormat":"Complex Baseband",
  "CarrierFreq":"2.4","CarrierFreq_unit":"GHz"}},
 {"op":"connect","target":"<PA id>.LConn1 <-> #tap.LConn1"},
 {"op":"add_block","type":"dspstat3/Power Meter","name":"Tap_Power_Meter","ref":"pm",
  "params":{"Measurement":"Average power","OutputPowerUnits":"dBm","ReferenceLoad":"50"}},
 {"op":"connect","target":"#tap.y1 -> #pm.u1"}]
```

## Critical Settings

| Setting | Value | Why |
|---------|-------|-----|
| `SensorType` | `'Ideal voltage'` | Non-disturbing voltage probe — this is what makes the tap non-loading |
| `CarrierFreq` | Must match signal carrier | Wrong freq -> zero output |
| `ReferenceLoad` on Power Meter | Must match system Z0 (typically 50) | Wrong ref -> incorrect dBm |

Note: `ZL` does **not** apply to an ideal-voltage (or ideal-current) probe — it is
ignored. Loading is determined by the `SensorType`, not by `ZL`. `ZL` is only meaningful
for a `'Power'` sensor, where it *is* the matched load impedance.

## Three Sensor Types

The `simrfV2util1/Outport` block supports:

| Type | Loads Circuit? | ZL relevant? | Use Case |
|------|---------------|--------------|----------|
| `'Power'` | YES (inserts a matched load, `ZL`) | Yes — it IS the load | At system output -- replaces load |
| `'Ideal voltage'` | NO (infinite-impedance probe) | No — ignored | Mid-circuit monitoring -- non-disturbing |
| `'Ideal current'` | NO (zero-impedance probe) | No — ignored | Series current measurement |

## Why a Power sensor mid-chain corrupts readings

A `'Power'` sensor terminates the node in a load equal to its `ZL` (default 50 Ω). Placed
mid-chain it diverts current into that load — a voltage divider against the downstream
input impedance — so the node level, and every reading after it, drops:

```
Z_load_total = parallel(Z_component_input, Z_tap)
             = (Z_comp * Z_tap) / (Z_comp + Z_tap)
```

**Example:** 50 Ω tap on a 50 Ω node -> total load = 25 Ω -> ~6 dB gain drop.

| `ZL` on a `'Power'` sensor | Loading on a 50 Ω node |
|----|--------------------------|
| 50 | −1.25 dB (−6 dB voltage) |
| 100 | −0.41 dB |
| 500 | −0.09 dB |
| 1e6 | negligible |
| `Inf` | **not supported — sim errors** ("Failed to evaluate mask initialization") |

A large finite `ZL` reduces the loading, but there is no reason to add a big resistor when
`SensorType='Ideal voltage'` is a purpose-built infinite-impedance probe that draws no
current and reads the true node level with no resistor at all. **Fix a loading mid-chain
sensor by changing `SensorType` to `'Ideal voltage'` — not by raising `ZL`.**

### CRITICAL: swapping to 'Ideal voltage' is only HALF the fix — its output is VOLTAGE, not power

A `'Power'` sensor outputs **power (W)**. An `'Ideal voltage'` sensor outputs the node
**voltage V** (complex-baseband, already RMS). These are different physical quantities, so
**any downstream stage that expected power must be corrected when you switch sensor type**,
or the reading will be wrong (typically by `10*log10(R)` ≈ **17 dB** for R=50).

Convert voltage → power with `P = |V|² / R` (RMS convention — **no factor of 2**):
- **In post-processing (MATLAB):** `P_dBm = 10*log10( abs(V).^2 / R / 1e-3 )`.
- **In-model, feeding a `Linear to dBm` block** (which computes `10*log10(|x|²·1000)` with
  **no divide-by-R**): insert a `Gain` block of **`1/sqrt(R)`** (i.e. `1/sqrt(50)`) *before*
  it, so the block squares `(V/√R)² = V²/R`. Feeding raw `V` into `Linear to dBm` is the
  classic 17 dB error.
- Alternatively use an Ideal-voltage **and** Ideal-current sensor and compute `P = real(V·I*)`
  when the node impedance is unknown.

So a correct non-loading power measurement = **non-loading sensor (Ideal voltage) AND the
V→power conversion.** Changing only the sensor type leaves the power/dBm reading wrong.

## Common Mistakes

| Mistake | Symptom | Fix |
|---------|---------|-----|
| `SensorType='Power'` mid-circuit | Downstream readings drop | Change `SensorType` to `'Ideal voltage'` |
| Swapped to `'Ideal voltage'` but left downstream power math unchanged | Reading off by ~17 dB (`10*log10(50)`) | Its output is VOLTAGE — convert with `P=|V|²/R` (post-proc) or a `1/sqrt(50)` gain before `Linear to dBm` |
| `SensorType='Power'` with `ZL='Inf'` | Sim errors (mask init fails) | `Inf` is invalid for a Power sensor; use `'Ideal voltage'` instead |
| Raising `ZL` to reduce Power-tap loading | Works but pointless | Use `'Ideal voltage'` (no resistor needed) |
| CarrierFreq mismatch | Zero or wrong power reading | Match to signal carrier |
| Wrong ReferenceLoad on meter | dBm value shifted | Set to system Z0 (50 Ohm) |
| Power Meter block not found | `dspsnks4/Power Meter` not in library | Use `dspstat3/Power Meter` |

## Validation Script

Use `verifyRfPowerTapConfiguration` in the skill's `scripts/` folder to check an existing tap
configuration. `<skill_root>` is the absolute path of the folder this skill's SKILL.md was
loaded from:

```matlab
addpath(fullfile('<skill_root>', 'scripts'));
report = verifyRfPowerTapConfiguration(modelName, tapOutportName, tapPowerMeterName, ...
    ExpectedCarrierGHz=2.4, ExpectedReferenceLoadOhm=50, OpenModel=false);
```

- **Inputs:** `modelName` (model name); `tapOutportName` (default `"Tap_Pre_PA"`) and
  `tapPowerMeterName` (default `"Tap_Power_Meter"`), the block names; `ExpectedCarrierGHz`
  (default `NaN`, carrier not checked); `ExpectedReferenceLoadOhm` (default `50`); `OpenModel`
  (default `true` opens the model window; use `false` to only load it).
- **Output:** `report`, a table with columns `Check`, `Passed`, `Actual`. It always prints
  `RF_POWER_TAP_CONFIGURATION=PASS` or `=FAIL`; called with no output argument it also displays
  the table.

It checks:
1. Tap block exists and is RF Outport
2. SensorType = 'Ideal voltage' (this alone makes the tap non-loading; ZL is ignored)
3. OutputFormat = 'Complex Baseband'
4. CarrierFreq matches system
5. Power Meter block exists
6. Power Meter measures average power in dBm
7. Power Meter ReferenceLoad = system Z0

## Power from Voltage (Manual Calculation)

An `'Ideal voltage'` sensor outputs the node voltage V (complex-baseband, RMS). Convert to
power with `P = |V|²/R` — **no factor of 2**, because CE power-wave signals are already RMS.

```matlab
% Complex baseband envelope from an Ideal voltage sensor -> power:
P_watts = mean(abs(tapOutput).^2) / 50;   % P = |V|^2 / R   (R = system Z0 = 50)
P_dBm   = 10*log10(P_watts / 1e-3);
```

In-model equivalent (feeding a `Linear to dBm` block, which does `10*log10(|x|²·1000)` with
no /R): put a `Gain` of `1/sqrt(50)` before it, so it squares `(V/√50)² = V²/50`:

```json
[{"op":"add_block","type":"simulink/Math Operations/Gain","name":"Vscale","ref":"vs",
  "params":{"Gain":"1/sqrt(50)"}},
 {"op":"connect","target":"<tap id>.y1 -> #vs.u1"},
 {"op":"connect","target":"#vs.y1 -> <Linear to dBm id>.u1"}]
```

## Other In-System Measurement Methods

| Method | When to Use |
|--------|------------|
| Outport with `SensorType='Power'` | At chain end (replaces load) |
| Ideal voltage + known Z | Mid-circuit, known impedance |
| Ideal voltage + Ideal current | Unknown impedance (compute V*conj(I)) |
| Power Meter block | Calibrated dBm with averaging |

----

Copyright 2026 The MathWorks, Inc.

----
