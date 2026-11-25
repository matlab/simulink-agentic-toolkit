# Self-Contained Delivery Pattern

When delivering an RF system for others to use (or for validation), provide three files:
workspace (.mat), model (.slx), and a demo script that proves it works in a cold session.

## Why Three Files

The rfsystem object stores a reference to an underlying Simulink model, but does NOT
embed the model inside the .mat file. When you `save('workspace.mat')` and later reload:

1. MATLAB loads the rfsystem object with its stored rfbudget
2. The rfsystem looks for a .slx file matching `ModelName` on the path
3. **If found** -> uses the saved model (preserving modifications)
4. **If NOT found** -> regenerates a fresh model from the rfbudget (losing all modifications)

## Build Script

```matlab
%% === build_system.m -- create the RF system ===
lna = amplifier(Name='LNA', Gain=15, NF=2, OIP3=20);
mix = modulator(Name='Mixer', Gain=-6, NF=10, OIP3=15, ...
    LO=2.4e9, ConverterType='Down');
ifamp = amplifier(Name='IF_Amp', Gain=20, NF=5, OIP3=30);

b = rfbudget([lna mix ifamp], 2.4e9, -30, 20e6);
rfs = rfsystem(b, ModelName='rx_direct_conv');

% Configure and verify
rfs.SampleTime = 1/50e6;
Fs = 1/rfs.SampleTime;
x = 0.001 * exp(1j*2*pi*1e6*(0:999)'/Fs);
y = rfs(x);
fprintf('Gain: %.1f dB\n', 10*log10(rms(y)^2/rms(x)^2));

% Save both workspace AND model
save_system(rfs.ModelName);          % Critical: saves .slx
save('eval_workspace.mat');          % Saves rfsystem + rfbudget objects
close_system(rfs.ModelName, 0);
```

## Demo Script

```matlab
%% === run_demo.m -- works in a fresh MATLAB session ===
% Demonstrates the direct-conversion receiver with a two-tone test.
% Requires: eval_workspace.mat and rx_direct_conv.slx in same directory.

load('eval_workspace.mat');

% Reconnect rfsystem to its saved model
release(rfs);
rfs.SampleTime = 1/50e6;

% Two-tone test: +/-500 kHz around carrier -> IM3 at +/-1.5 MHz baseband
Fs = 1/rfs.SampleTime;
N = 4000;
t = (0:N-1)'/Fs;
f1 = 0.5e6; f2 = -0.5e6;
x = 0.001 * (exp(1j*2*pi*f1*t) + exp(1j*2*pi*f2*t));

% Simulate
y = rfs(x);

% Measure IM3
Y = fft(y);
freqs = (0:N-1)' * Fs/N;
freqs(freqs > Fs/2) = freqs(freqs > Fs/2) - Fs;
[~, idx_f1] = min(abs(freqs - f1));
[~, idx_im3] = min(abs(freqs - 1.5e6));  % 2*f1 - f2
fund_dB = 20*log10(abs(Y(idx_f1)));
im3_dB = 20*log10(abs(Y(idx_im3)));
fprintf('Fundamental: %.1f dB, IM3: %.1f dB, Delta: %.1f dB\n', ...
    fund_dB, im3_dB, fund_dB - im3_dB);
```

## Key Principles

- `run_demo.m` must work after `clear all` + `load` -- no hidden state
- The .slx must be saved alongside the .mat (rfsystem regenerates from rfbudget if .slx missing)
- Name output variables clearly (`y`, `output`) so downstream scripts can find them
- Print numeric results so success is visible in text output
- Always use an explicit `ModelName` (not 'untitled') and save the .slx alongside workspace

## Model Persistence Across Sessions

To ensure modifications survive across sessions:

```matlab
% After modifying the model:
save_system(rfs.ModelName);  % Saves the .slx to current directory

% In your demo/usage script that loads the workspace:
load('eval_workspace.mat');  % Loads the rfsystem object
% The .slx must be in the same directory or on the MATLAB path
% If you named it explicitly, rfsystem reconnects automatically:
release(rfs);
y = rfs(x);  % Uses the saved .slx with modifications intact
```

## Multi-Chain Delivery

For multi-chain (phased array) systems, remember that `rfsystem` auto-generates
Wilkinson combiner/divider `.s2p` files alongside the model. Include these in delivery:

```
delivery/
  eval_workspace.mat       % rfsystem + rfbudget objects
  rx_array.slx             % Simulink model
  *Wilkinson*.s2p          % Auto-generated combiner/divider files
  run_demo.m               % Cold-start demonstration script
```

## Text Projection of a Model (Describing What You Built)

A `.slx` is binary, so anything that reads your delivery as text -- a reviewer, a report, a
diff -- sees nothing. Emit a text projection next to it: every top-level block with its
library block and parameter values, plus the connection list. Generate it by code from the
saved model, so it describes what exists rather than what you intended.

**Connections: use `PortConnectivity`, never a line walk.** `find_system(...,'Type','Line')`
looks like the way to enumerate wiring, but it is incomplete on RF Blockset models. Physical
lines branch (one trunk feeding several blocks at a shared node), and a branch's child
segments return `SrcBlockHandle <= 0` -- so the obvious loop silently drops exactly the
shared nodes that define the topology, and recovering them means walking
`LineParent`/`LineChildren` into a union-find over segments. `PortConnectivity` reports the
same wiring per block with branches already resolved.

```matlab
blks = find_system(mdl, 'SearchDepth', 1, 'Type', 'Block');

% Port handle -> "Block.PortLabel". Physical DstPort entries are HANDLES, not indices,
% so this map is what makes the destination side readable.
pmap = containers.Map('KeyType', 'double', 'ValueType', 'char');
for i = 1:numel(blks)
    blockName = strrep(get_param(blks{i}, 'Name'), newline, ' ');
    ports = get_param(blks{i}, 'PortHandles');
    for field = string(fieldnames(ports))'
        handles = ports.(field);
        for n = 1:numel(handles)
            switch field
                case "Inport",  label = "u" + n;
                case "Outport", label = "y" + n;
                otherwise,      label = field + n;   % LConn1, RConn2, ...
            end
            pmap(handles(n)) = char(string(blockName) + "." + label);
        end
    end
end

conns = strings(0, 1);
for i = 1:numel(blks)
    blockName = string(strrep(get_param(blks{i}, 'Name'), newline, ' '));
    pc = get_param(blks{i}, 'PortConnectivity');
    for k = 1:numel(pc)
        if isempty(pc(k).DstBlock), continue; end     % walk each link from its source only
        portIndex = str2double(pc(k).Type);           % numeric Type = Simulink outport index
        isPhysical = isnan(portIndex);                % non-numeric Type = LConn1 / RConn1
        if isPhysical
            src = blockName + "." + string(pc(k).Type);
        else
            src = blockName + ".y" + string(portIndex);
        end
        for m = 1:numel(pc(k).DstBlock)
            dstHandle = pc(k).DstPort(m);
            if isKey(pmap, dstHandle)
                dst = string(pmap(dstHandle));                        % physical port handle
            else
                dstName = strrep(get_param(pc(k).DstBlock(m), 'Name'), newline, ' ');
                dst = string(dstName) + ".u" + string(dstHandle + 1); % signal port is 0-based
            end
            if isPhysical
                ends = sort([src dst]);      % physical links are undirected -- canonical order
                conns(end+1) = ends(1) + " <-> " + ends(2);
            else
                conns(end+1) = src + " -> " + dst;
            end
        end
    end
end
conns = unique(conns);   % each physical link is reported from both ends
```

Two details that otherwise cost real time: `pc(k).Type` is the **outport index** for Simulink
signal ports but the **port name** (`LConn1`) for physical ports, and `pc(k).DstPort` is a
**0-based index** for signal ports but a **port handle** for physical ones -- hence the map and
the `isnan` test. A correct dump yields as many unique connections as the model has line
segments; compare against
`numel(find_system(mdl,'SearchDepth',1,'FindAll','on','Type','Line'))` as a self-check.

**Finish by writing the file, in the same code that built `conns`.** The block parameters are
the other half of the projection: loop the same `blks` with `get_param(b, 'MaskNames')`, at
`SearchDepth` 1 with no `LookUnderMasks` -- looking under masks recurses into each block's
Simscape internals and buries the user-set values in thousands of lines.

```matlab
% One formatter for every value you might print. Do NOT use mat2str here: it throws
% "Input matrix must be a numeric array, character array, or string array" on cells,
% structs and objects, all of which turn up in mask values and model-workspace variables.
fmt = @(v) string(strtrim(regexprep( ...
    strrep(char(formattedDisplayText(v, 'SuppressMarkup', true)), newline, ' '), '\s+', ' ')));

D = strings(0, 1);
D(end+1) = "MODEL: " + string(mdl);
D(end+1) = "";
D(end+1) = "== CONNECTIONS ==";      % topology first, ahead of the long parameter list
D = [D(:); conns(:)];        % (:) on both -- they grow into different orientations
D(end+1) = "";
D(end+1) = "== BLOCKS ==";
for i = 1:numel(blks)
    nm  = string(strrep(get_param(blks{i}, 'Name'), newline, ' '));
    ref = string(strrep(get_param(blks{i}, 'ReferenceBlock'), newline, ' '));
    if strlength(ref) == 0, ref = string(get_param(blks{i}, 'BlockType')); end
    allNames = string(get_param(blks{i}, 'MaskNames'));
    mn = allNames;
    if isempty(mn) && isfield(get_param(blks{i}, 'DialogParameters'), 'Value')
        mn = "Value";                                % unmasked Constant blocks
    end
    mn = mn(~endsWith(mn, "_unit") & lower(mn) ~= "classname");
    kv = strings(size(mn));
    for k = 1:numel(mn)
        kv(k) = mn(k) + "=" + fmt(get_param(blks{i}, mn(k)));
        if ismember(mn(k) + "_unit", allNames)       % fold the unit into its value
            kv(k) = kv(k) + " " + fmt(get_param(blks{i}, mn(k) + "_unit"));
        end
    end
    % One line per block: library block it came from, then name=value pairs
    D(end+1) = nm + " [" + ref + "]: " + strjoin(kv, "; ");
end
writelines(D, outFile);      % append to a prose header with writelines(...,'WriteMode','append')
```

`ReferenceBlock` is what identifies the library block a masked RF block came from;
`BlockType` covers the plain Simulink blocks (Constant, Gain, Outport) that have no
`ReferenceBlock`. Both are needed -- a dump listing only names says nothing about what was
actually placed. Keep it compact -- one line per block, units folded into values -- since
long projections are often read only in part.

Put the write at the END of the same call that computes `conns`. Printing the dump to the
console and writing the file as a separate step is how a complete, correct dump ends up
nowhere on disk.

----

Copyright 2026 The MathWorks, Inc.

----
