# Sample Rate & Frame Rate Conversion

Load when changing a signal's sample rate in a Simulink model — decimating a high-rate ADC, upsampling for a DAC, or fractional resampling (e.g. 44.1→48 kHz). Also load when a rate-conversion block's output frame size or frame rate is not what was expected.

## Block Selection: Anti-Aliasing Safe vs Raw

| User intent | Use this block | NOT this | Why |
|---|---|---|---|
| Reduce sample rate by integer factor | **FIR Decimation** (`dspmlti4`) | Downsample | FIR Decimation lowpass-filters before dropping samples → no aliasing. Downsample just drops every Kth sample → aliasing. |
| Increase sample rate by integer factor | **FIR Interpolation** (`dspmlti4`) | Upsample | FIR Interpolation filters out spectral images after zero-insertion. Upsample inserts zeros only → images remain. |
| Non-integer rate change (L/M) | **Sample-Rate Converter** (`dspmlti4`) | Cascade of Interp + Decim | Single block designs the combined anti-alias/anti-image filter and the L/M factors for you. |

**Rule:** For any rate change that must preserve signal integrity, use the FIR-based block (or Sample-Rate Converter). Reach for Downsample/Upsample only when aliasing/imaging is explicitly acceptable (rare).

Set the decimation/interpolation factor as an integer (e.g. 192→48 kHz ⇒ `DecimationFactor = 4`). For fractional conversion, the Sample-Rate Converter takes input and output sample rates directly and computes L/M internally.

## RateOptions: Single-Rate vs Multirate (the critical setting)

Decimation/interpolation blocks have a **`RateOptions`** parameter that decides *whether the frame size changes or the frame rate changes*. Getting this backwards is the most common rate-conversion error — the model still runs, but the downstream frame size / timing is wrong.

For **decimation by factor K** with input frame size `M` at sample period `Ts`:

| RateOptions value | Output frame size | Output frame period | Output sample rate | What stays constant |
|---|---|---|---|---|
| **Enforce single-rate processing** (default) | `M / K` | `M × Ts` (**unchanged**) | drops by K | **Frame period** — same rate, smaller frame |
| **Allow multirate processing** | `M` (**unchanged**) | `M × K × Ts` (slower) | drops by K | **Frame size** — same frame, slower rate |

For **interpolation by factor K**, the relationship inverts: single-rate grows the frame to `M × K` at the same frame period; multirate keeps frame size `M` and speeds the frame rate up by K.

**Mnemonic:**
- *Enforce single-rate* → the **model base rate is preserved**; the **frame size** absorbs the conversion (`M/K` for decimation, `M×K` for interpolation).
- *Allow multirate* → the **frame size is preserved**; the **frame rate** absorbs the conversion (frame period scales by K).

**Constraint (single-rate decimation):** input frame size `M` must be divisible by the decimation factor `K`, since the output frame size `M/K` must be an integer.

### Diagnosing "wrong output frame size"

Symptom: *"I decimated by 4 but my frame went from 512 to 128 and I wanted it to stay 512."*
Cause: `RateOptions = "Enforce single-rate processing"` (default) shrinks the frame.
Fix: set `RateOptions = "Allow multirate processing"` to keep the frame size and slow the frame rate instead.

The reverse symptom (*"frame size stayed the same but the timing changed"*) means multirate is selected when single-rate was wanted.

## InputProcessing

Decimation/interpolation blocks default `InputProcessing = "Columns as channels (frame based)"` (correct for streaming). Leave it unless the input is genuinely sample-based multichannel. See the Build Checklist in SKILL.md.

## Two-Band Filterbank (worked timing)

Analysis–synthesis around a decimated low band, at 48 kHz, frame size 480:
```
[Source 48k, 480] ─┬─→ [FIR Decimation K=6] → [LP filter] → [FIR Interpolation K=6] ─┐
                   │      (8 kHz, frame 80, single-rate)                              ├─→ [Sum] → out
                   └─→ [HP filter @ 48 kHz, frame 480] ─────────────────────────────┘
```
- Low band after decimation (single-rate): frame `480/6 = 80`, sample rate 8 kHz.
- After interpolation back: frame `80×6 = 480`, 48 kHz again.
- High band stays 480 / 48 kHz. **Both paths must present frame size 480 at the Sum block.**

This is a multirate model (the low band runs at 8 kHz, the high band at 48 kHz). Enable sample time colors via a `configure` op — `{"op":"configure","target":"config:<model>","params":{"SampleTimeColors":"on"}}` (never `set_param`) — so the two rates and the transitions at the decimation/interpolation blocks are visible on the diagram. See the Multirate Model Rules in `buffering-multirate.md`.

----

Copyright 2026 The MathWorks, Inc.

----
