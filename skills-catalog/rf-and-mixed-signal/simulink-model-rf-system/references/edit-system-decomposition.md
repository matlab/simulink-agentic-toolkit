# Edit System (Block Decomposition)

**Available on:** All `simrfV2systems` blocks (IQ Modulator, IQ Demodulator, Modulator, Demodulator, Channel)

Decomposes a system-level block into its internal components for per-element manipulation. The library link must be **intact** — do not break it before calling.

**When to use:** Only when the task requires a circuit structure that cannot be achieved through system-level mask parameters alone — e.g., asymmetric I/Q gain (different gain on MixerI vs MixerQ), per-mixer phase noise, or replacing an internal component with a custom one.

**When NOT to use:** Do NOT expand if you only need to configure impairments (use `model_edit` `configure` on the system block), visualize responses (use `simrfV2plotfilter`/`simrfV2plotparam` on the intact block), or read current settings. Expansion is destructive — it permanently replaces the system block with its decomposed internals and the mask parameters (like `DesignMethodIR`, `AddCSFilters`) will no longer exist on the block.

```matlab
blk = [mdl '/IQMod'];

% Shadow questdlg to bypass modal dialog
tmpDir = fullfile(tempdir, 'questdlg_override');
if ~exist(tmpDir, 'dir'); mkdir(tmpDir); end
fid = fopen(fullfile(tmpDir, 'questdlg.m'), 'w');
fprintf(fid, 'function answer = questdlg(varargin)\nanswer = ''Edit System'';\nend\n');
fclose(fid);
addpath(tmpDir);

% Expand the block (requires open dialog)
old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(blk);
simrfV2expandblock(blk, simrfV2_find_dialog(blk));
cd(old);
rmpath(tmpDir);

% Internal blocks now have resolved numerical parameters (not variables)
% e.g., MixerI linear_gain reads '-6' (model_query_params)
```

**Critical:** Do NOT break the library link (`LinkStatus` `'none'`) before calling — the function requires the link to be intact.

**IQ Modulator internals after expansion:** MixerI, MixerQ, LO (CW Source), PhaseShifter, RI, RQ, Rout, SignalCombiner, IRFilterI, IRFilterQ, Gnd, ThermalNoise. For PA coefficient extraction (memory polynomial fitting), see `references/ce-block-parameters.md`.

----

Copyright 2026 The MathWorks, Inc.

----
