# Upgrade rfantenna(TransmitReceive) to Channel Block

**When:** The model was built with `rfantenna(Type='TransmitReceive', PathLoss=...)` which exports as two scalar-gain Antenna blocks with fixed path loss. To get realistic propagation (delay, phase, polarization mismatch, multipath), replace with a Channel block driven by `txsite`/`rxsite` objects.

**Upgrade when you need:** frequency-dependent antenna patterns, polarization propagation (2-pol EIRP through channel), geometric delay and phase, ray-tracing (reflections, diffraction), and realistic path loss from propagation models (free-space, rain, gas, fog, ray-tracing).

```matlab
% 1. Create antenna objects (Antenna Toolbox)
txAnt = design(patchMicrostrip, 5.8e9);
rxAnt = design(dipole, 5.8e9);
[~] = impedance(txAnt, 5.8e9);  % analyze each antenna once, or the Channel block
[~] = impedance(rxAnt, 5.8e9);  % rejects it as newly created

% 2. Create site objects with positions and antennas
tx = txsite('cartesian', Name='BaseTx', ...
    AntennaPosition=[0; 0; 10], ...    % [x; y; z] in meters
    Antenna=txAnt, ...
    TransmitterFrequency=5.8e9);

rx = rxsite('cartesian', Name='MobileRx', ...
    AntennaPosition=[200; 50; 2], ...
    Antenna=rxAnt);

% 3. Create the propagation model. Ray-tracing mode accepts only a ray-tracing
%    model, and its CoordinateSystem must match the sites ('cartesian' here).
pm = propagationModel('raytracing', CoordinateSystem='cartesian');
% Optional: Method='sbr', MaxNumReflections=3

% 4. Assign to base workspace (the Channel block reads variable names)
assignin('base', 'txSiteObj', tx);
assignin('base', 'rxSiteObj', rx);
assignin('base', 'pmObj', pm);
```

**5. Replace the exported antenna pair with a Channel block** using `model_edit` (block
IDs from `model_read`; pass the JSON on one line).

The export of `rfantenna(Type='TransmitReceive')` is two Antenna blocks with a Gain block
between their wave ports, and two Configuration blocks, one per network:

- FROM: PA → `Antenna` → `PathLoss` (Gain) → `Antenna1` → LNA
- TO: PA → `Channel` → LNA

The Channel (`simrfV2systems/Channel`) is an RF block with two RF terminals (`LConn1`
transmit side, `RConn1` receive side). It contains the antennas, which it takes from the
`Antenna` property of the `txsite`/`rxsite` objects, so the three exported blocks go:

- `delete` `Antenna`, `PathLoss` and `Antenna1`;
- `add_block` the Channel and `connect` `PA.RConn1 <-> Channel.LConn1` and
  `Channel.RConn1 <-> LNA.LConn1`;
- keep **both** Configuration blocks: the Channel separates the transmit and receive
  networks, each needs its own, and their `StepSize` values must be equal.

```json
[{"op":"delete","target":"<Antenna id>"},{"op":"delete","target":"<PathLoss id>"},
 {"op":"delete","target":"<Antenna1 id>"},
 {"op":"add_block","type":"simrfV2systems/Channel","name":"Channel","ref":"ch","params":
  {"ChannelSource":"Ray-tracing","txSite":"txSiteObj","rxSite":"rxSiteObj",
   "propagationModel":"pmObj","CarrierFreq":"5.8","CarrierFreq_unit":"GHz"}},
 {"op":"connect","target":"<PA id>.RConn1 <-> #ch.LConn1"},
 {"op":"connect","target":"#ch.RConn1 <-> <LNA id>.LConn1"}]
```

`propagationModel` is evaluated as a MATLAB expression; pass the model object's variable
name. A quoted `'raytracing'` gives a geographic model, which fails for Cartesian sites.
Save the model afterwards (`save_system(mdl)`).

**Channel modes:**
- `'Isotropic free-space'` — scalar `PathLoss` (dB) and `PathDelay` (s), no antenna pattern (equivalent to rfantenna TransmitReceive but as a block you can modify)
- `'Ray-tracing'` — full propagation from `txsite`/`rxsite` with `propagationModel`, optional 3D `map` environment

----

Copyright 2026 The MathWorks, Inc.

----
