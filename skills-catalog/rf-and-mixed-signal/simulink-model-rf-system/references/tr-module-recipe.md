# Switched TX/RX (TR) Module — Standard Topology

Build the TR module as a **ring**: the transmit chain, the receive chain and the shared common
path (programmable attenuator + phase shifter) form a closed loop, and three SPDT switches
decide which way the signal travels around it.

```
  TX_In  (Inport,  ZS = 50) ──┐                                    ┌── DRV ── PA ──┐
                              ├── SW1 ── ATT ── PS ── SW2 ────────┤               ├── SW3 ── ANT node
  RX_Out (Outport, ZL = 50) ──┘        └ common path ┘              └── STG ── LNA ─┘
```

- `SW1` common = common-path input; throws = `TX_In` and `RX_Out`
- `SW2` common = common-path output; throws = `DRV` input and `STG` output
- `SW3` common = **antenna node**; throws = `PA` output and `LNA` input

Signal flow, one path per mode — the common path is traversed in **both** directions:

```
TX:  TX_In -> SW1 -> ATT -> PS -> SW2 -> DRV -> PA  -> SW3 -> ANT
RX:  ANT   -> SW3 -> LNA -> STG      -> SW2 -> PS   -> ATT -> SW1 -> RX_Out
```

## Two choices that keep the block count down

**1. Put TX on the same throw of all three switches.** TX on `RConn1` everywhere and RX on
`RConn2` everywhere means **one uninverted control drives all three SPDTs** — fan a single
`Constant` out to the three `Vctl` inputs and you are done. Assign the throws
inconsistently and you need a `Gain(-1)` → `Bias(+1)` inverter for the odd switch out,
which is extra blocks and an extra thing to get backwards.

**2. Let the gateways be the terminations.** Every switch throw lands on something real —
`TX_In` (`ZS = 50`), `RX_Out` (`ZL = 50`), the antenna node, or an amplifier that leads
back into the ring. Nothing dangles, so you need **no dump resistors and no Electrical
Reference blocks**, and no throw can strand itself into a second physical network.

Receiver protection comes from the switch isolation itself: in TX mode the LNA input sits
on the off throw of `SW3`, reachable only through `Iiso`. That is how a real TR module
behaves — it does not need a modelled dump load.

## Antenna node

The antenna is **one bidirectional node**, not two ports: an `Inport` that injects the
received signal (and presents the matched 50 Ω load the PA works into, since its drive is
zero while transmitting) plus a non-loading `Outport` probe.

```
ANT_In     Inport   SimulinkInputSignalType='Power', CarrierFreq=2.1e9, ZS=50
ANT_Probe  Outport  SensorType='Ideal voltage', ZL=Inf        (non-loading tap)
RX_Out     Outport  SensorType='Power',         ZL=50         (the matched RX load)
TX_In      Inport   SimulinkInputSignalType='Power', ZS=50
```

`SensorType='Ideal voltage'` is an open circuit and **ignores `ZL`** — correct for a probe,
wrong for the receiver output. Use `SensorType='Power'` with a finite `ZL` wherever the
port is meant to load the network.

## Parameters that matter

Switches live in **`simrfV2junction1/SPDT`** — not `simrfV2elements`, where the attenuator
and phase shifter are, under names containing a **newline**:
`sprintf('simrfV2elements/Variable\nAttenuator')`, `sprintf('simrfV2elements/Variable\nPhase Shift')`.

The `Variable` blocks are what make the common path tunable while a simulation runs: their `Att` /
`Phase` values come from control signals. A regular `Attenuator` / `Phase Shift` cannot change during a
simulation. The TR architecture itself does not need them — if the attenuation and phase only change
between runs, use the regular `Attenuator` / `Phase Shift` with their values in workspace variables,
which is simpler and much cheaper to simulate.

```
SPDT    Vthres=0.5          BETWEEN the two control levels (see below)
        CharType='Insertion loss'
        Iloss=0.8           on-throw insertion loss, dB
        Iiso=25             off-throw ISOLATION, dB -> the TX/RX leakage path
        LoadType='Absorptive'
        Z0=55               off 50 -> switch-junction mismatch
ATT     Attmin=0.5  Attmax=31.5   Zin=Zout=50      Att input is in dB
PS      PhaseShift_unit='deg'     SparamZ0=50
Amp     linear_gain=20  IPType='Output'  IP3=45  NF=6
                        (gain is `linear_gain`, NOT `Gain`; dB by default)
Config  AutoFreq='off'  Tones=2.1e9  Harmonics=1  StepSize=1e-8  AddNoise='on'
```

`Iiso` is what makes leakage meaningful — the default leaves the off throw effectively
perfectly isolated, so the model reports no TX/RX coupling at all. A `Z0` slightly off 50 Ω
is what produces switch-junction mismatch. Both are properties of the switch, not extra
blocks.

The `Vthres` threshold rule — and why the library default of `'0'` with a 0/1 control never
switches — is in `references/ce-block-parameters.md` § "Switches and Signal-Driven
Elements". Read it rather than building a probe model to find mask names.

## Build order

Wire the whole ring in **one** `model_edit` call with `layout_mode:"full"`, then a second
`incremental` call to `configure` each block by its returned `blk_N` id. Addressing blocks
by `#ref` and wiring physical ports by name with `<->` means you never pre-compute port
handles — see `references/model-edit-operations.md` § "Recipe (PREFERRED): Branch /
Parallel Path".

Gateway settings fail at **compile** time, not edit time, both as *"Failed to evaluate mask
initialization commands"*: a CW source with `CWSourceType='Power'` needs `Z0 > 0`, and an
`Outport` with `SensorType='Power'` needs finite `ZL`. Inport source impedance is **`ZS`**.

## Verify

Toggle the mode control and confirm the active output swaps **in opposite directions** —
e.g. `Vctl 0 -> 1` moves `RX_Out` up tens of dB while the antenna probe drops. That single
comparison covers routing, threshold and throw assignment together — a model whose
`Vthres` is wrong, or
whose throws are inconsistently assigned, shows the *same* output in both states. A short
`StopTime` (2e-6 s at `StepSize=1e-8`) is enough.

----

Copyright 2026 The MathWorks, Inc.

----
