# Visualizing IR/CS Filters Inside System Blocks

`simrfV2plotfilter` works on standalone `simrfV2elements/Filter` blocks — NOT directly on system blocks (IQ Mod/Demod). To visualize filters inside a system block, target the internal filter blocks:

Step 1: compile the model so mask variables reach the internal blocks: one
`model_query_params` call with `compile` = `true` (any parameter, e.g. `["StopTime"]` on
target `config:<model>`). Then:

```matlab
mdl = 'myModel';
blk = [mdl '/IQDemod'];

% Step 2: Find internal filter blocks (appear after compile)
irBlk = [blk '/IRFilter'];     % IQ Demod has: IRFilter, CSFilterI, CSFilterQ
% IQ Mod has: IRFilterI, IRFilterQ, CSFilter

% Step 3: Call simrfV2plotfilter on the internal block
old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(irBlk);
dlg = simrfV2_find_dialog(irBlk);
simrfV2plotfilter(irBlk, dlg);
cd(old);

% Step 4: Extract data from the plot (figure named with block path)
fig = findall(0, 'Name', irBlk);
ax = findall(fig, 'Type', 'axes');
lines = findall(ax, 'Type', 'line');
freq = get(lines(1), 'XData');   % Hz
mag_dB = get(lines(1), 'YData'); % dB
```

**What the plot shows:** "Voltage transfer [Mag dB]" is S21 of the implemented LC network with 50 ohm at both ports. Rsrc/Rload set the element values of the design; they are not the plot's terminations. The same curve comes from the `rffilter` object in the internal block's `UserData`, with no figure needed:

```matlab
r = get_param(irBlk, 'UserData');            % rffilter used by the block
S = sparameters(r, freq, 50);
mag_dB = 20*log10(abs(squeeze(S.Parameters(2,1,:))));
```

**Choosing Rsrc/Rload (IQ Demodulator):** a filter meets its nominal response in simulation only when Rsrc/Rload equal the impedances around it inside the block. In the expanded block, each mixer input is 2×`Zin`, and the I and Q mixers are fed in parallel, so the IR filter is loaded by `Zin`. Each mixer output has source impedance `Zout`:

| Filter | Rsrc | Rload |
|---|---|---|
| IR (before the mixers) | source impedance driving the block | `Zin` |
| CS (after each mixer) | `Zout` | load impedance at the block output |

When an Amplifier drives the block, its source impedance is its `Zout`, unless its
`Source_linear_gain` is `Data source`. Every Amplifier carries the hidden defaults
`DataSource='Data file'` and `File='unitygain.s2p'`; they don't mean it uses a file.

With other values the simulated response departs from the nominal design. The plot (50 ohm at both ports) shows the simulated response only when the impedances around the filter are 50 ohm on both sides.

----

Copyright 2026 The MathWorks, Inc.

----
