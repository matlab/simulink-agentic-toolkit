# Configuration Block Programmatic Tools

## CRITICAL: Dialog-Safe Workflow

The mask dialog "owns" block parameters while open. If a parameter changes while the dialog is open, the plot function will refuse with: *"Changes to dialog parameter X exists. Press Apply and try again."*

**Correct sequence:**
1. Set ALL parameters with `model_edit` `configure` (with dialog CLOSED)
2. Call `save_system(mdl)`
3. THEN call `open_system(blk)` — dialog opens with saved values
4. Call the plot/selection function — works because dialog has no pending changes

**If you need to change params after seeing a plot:**
1. Close the mask dialog: `close(simrfV2_find_dialog(blk))`
2. Then `configure` → `save_system` → `open_system(blk)` → call function again

---

## SolverType (Integration Scheme)

`SolverType` controls the time-marching integration scheme used by the Circuit Envelope solver. Leave it on **Auto** (default) unless you have a specific reason to override.

| Scheme | Characteristics |
|--------|----------------|
| Auto | Lets the solver pick the best scheme for the model topology |
| NDF2 | Most robust — handles stiff nonlinear circuits well. Requires more history points and introduces some numerical damping. Needs wider zero-padded guard band at spectrum edges to avoid integration artifacts (hence the `1/(8×BW)` StepSize recommendation) |
| Trapezoidal | Less damping, fewer history points, but can ring on stiff systems |

**Practical guidance:**
- For PA and mixer models (stiff nonlinear), NDF2 (or Auto, which often selects NDF2) is safest
- The "damping" in NDF2 slightly attenuates fast transients — acceptable for envelope simulation but settling times may appear marginally longer
- If you see spectral artifacts at the band edges of your output, the fix is usually to decrease `StepSize` (widen the zero-padded guard band) rather than change `SolverType`

See the "Transient analysis" section of the Configuration block documentation for full details on each scheme.

---

## Newton Iteration Convergence (RelTol, AbsTol, MaxIter, ErrorEstimationType)

At each time step, the CE solver solves a nonlinear system via Newton iteration. Four parameters control convergence:

| Parameter | Range | Default | Purpose |
|-----------|-------|---------|---------|
| `RelTol` | 1e-9 – 1e-1 | 1e-3 | Relative tolerance on solution update |
| `AbsTol` | 1e-9 – 1e-1 | 1e-6 | Absolute tolerance (floor for small signals) |
| `MaxIter` | 1 – 50 | 10 | Maximum Newton iterations per time step |
| `ErrorEstimationType` | `'2-norm over all variables'` or `'Each variable separately'` | — | How convergence is evaluated |

**Convergence criterion:**

- **2-norm over all variables:** `norm(delta_x, 2) < RelTol * norm(max_all_prev(abs(x))) + AbsTol` — a single scalar check across all states and simulation frequencies
- **Each variable separately:** `all(abs(delta_x)) < RelTol * max_all_prev(abs(x)) + AbsTol` — every state variable and simulation frequency must individually satisfy the bound

Here `delta_x` is the linear iteration update and `max_all_prev(abs(x))` is the running maximum of the absolute solution value seen in previous iterations.

**Practical guidance:**
- The defaults (`RelTol=1e-3`, `AbsTol=1e-6`, `MaxIter=10`) work well for most behavioral RF scenarios — leave them alone unless you have a reason to change
- `AbsTol` should be ~1000× smaller than `RelTol` — it prevents the criterion from being trivially satisfied when signals are near zero
- **When to tighten:** If you observe strange numerical artifacts affiliated with nonlinearity (unexpected spectral content, asymmetric distortion), reduce `RelTol` and `AbsTol` and check whether the solution changes. If it does, keep reducing until results converge
- **MaxIter follows tolerances:** Tighter tolerances require more iterations to converge. When reducing tolerances, increase `MaxIter` proportionally (e.g., `RelTol=1e-5` may need `MaxIter=20–30`)
- If the solver errors out with "maximum iterations exceeded," either increase `MaxIter` or reduce input power (you may be driving past compression into a region where Newton struggles)
- "Each variable separately" is stricter — use it when you need uniform accuracy across all carriers (e.g., weak signal coexisting with a strong carrier)

---

## Reading Mask Dialog Text (Widget Values)

The Configuration block displays computed status values as read-only text on the mask dialog. Read them programmatically with `dlg.getWidgetValue(tag)`:

```matlab
blk = [mdl '/Configuration'];
save_system(mdl);  % ensure fresh computation

old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(blk);
dlg = simrfV2_find_dialog(blk);

nFreqs = dlg.getWidgetValue('Totalfreqs');   % e.g., '25'
envBW  = dlg.getWidgetValue('EnvBW');        % e.g., '1 MHz'
cd(old);
```

**Configuration block widget tags (Main tab → Spectrum group):**

| Tag | Content | Notes |
|-----|---------|-------|
| `Totalfreqs` | `'25'` or `'Computed at simulation time'` | Number of simulation frequencies (shows count only when AutoFreq is off) |
| `EnvBW` | `'1 MHz'` | Envelope bandwidth derived from StepSize |
| `ErrMsgId` | `'N/A'` or error text | Frequency configuration error/warning |
| `ErrMsgIdEnvBW` | `'N/A'` or error text | Bandwidth-related error/warning |
| `filterDelayMsg` | `'Filter delay (in samples): ...'` | Interpolation filter delay |

**Use cases:**
- Verify frequency count before simulation (is it manageable?)
- Confirm envelope bandwidth matches intended signal BW
- Detect configuration errors programmatically (`ErrMsgId ~= 'N/A'`)
- Gradual testing: compare `Totalfreqs` before/after reducing harmonics

**Note:** `Totalfreqs` shows `'Computed at simulation time'` when `AutoFreq` is `'on'`. Turn AutoFreq off and set explicit Tones/Harmonics to get the count at design time.

---

## Frequency Explanation Plot

Opens a figure showing all simulation frequencies, their sources (e.g., `f1`, `3f1-2f2`), and lets you verify the Tones/Harmonics choice.

**Prerequisite:** `save_system(mdl)` before calling — unapplied parameter changes cause an error dialog (see Dialog-Safe Workflow above).

```matlab
blk = 'myModel/Configuration';  % full block path
save_system('myModel');

old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(blk);
simrfV2_plot_solver_freqs(simrfV2_find_dialog(blk).getDialogSource);
cd(old);
```

The figure contains:
- Stem plot of all simulation frequencies
- **Tones (Hz)** listbox
- **Simulation frequencies (Hz)** listbox
- **Explanation** panel showing the mixing product source of the selected frequency

### Extracting Frequency Count Programmatically

```matlab
fig = findall(0, 'Name', [get_param(blk,'Name') ': Explaining simulation frequencies']);
lb = findall(fig, 'Style', 'listbox');
simFreqStr = lb(1).String;  % char array, one freq per row
nFreqs = size(simFreqStr, 1);
fprintf('Total simulation frequencies: %d\n', nFreqs);
```

### Getting Explanations for Each Frequency

```matlab
fig = findall(0, 'Name', [get_param(blk,'Name') ': Explaining simulation frequencies']);
listboxes = findall(fig, 'Style', 'listbox');
simFreqLB = listboxes(1);  % 25-item frequency listbox
allUI = findall(fig, 'Type', 'uicontrol');
explText = allUI(1);        % explanation text field
cb = simFreqLB.Callback;    % cell with callback function

% Select a frequency and read explanation
simFreqLB.Value = 7;        % e.g., index 7
feval(cb{1}, simFreqLB, [], cb{2:end});
explanation = strtrim(explText.String);  % e.g., "f1" or "3f1-2f2"
```

---

## Small-Signal Frequency Selection Tool

Opens an interactive figure for choosing which frequencies to include in small-signal transient analysis.

**Prerequisite:** `SmallSignalApprox` must be `'on'` and `AllSimFreqs` must be `'off'`.

First `model_edit` `configure` the Configuration block, `SimFreqs` before `AllSimFreqs`
(`AllSimFreqs='off'` with the default empty `SimFreqs` fails mask initialization; the tool
rewrites `SimFreqs` anyway):

```json
[{"op":"configure","target":"<Configuration id>","params":{"SmallSignalApprox":"on",
  "SimFreqs":"[2.4e9]","AllSimFreqs":"off"}}]
```

Then:

```matlab
blk = 'myModel/Configuration';
save_system('myModel');

old = pwd;
cd(fullfile(matlabroot, 'toolbox', 'simrf', 'simrf', 'simrfV2masks', 'private'));
open_system(blk);
src = simrfV2_find_dialog(blk).getDialogSource;
simrfV2_select_solver_freqs(src);       % Open selection figure
% simrfV2_select_solver_freqs(src, true);  % Force-update if model changed
cd(old);
```

The selection figure shows:
- **Blue stems:** All available simulation frequencies
- **Red stems:** Currently selected small-signal subset
- **Tones (Hz)** listbox
- **Harmonic order** selector: "Tones only", "Up to order 1/2/3"
- **"-> Select ->"** button: Computes frequencies for chosen harmonic order
- **"Include all input and output frequencies"** checkbox
- **"Populate Mask"** button: Writes selection back to `SimFreqs` parameter

### Direct Programmatic Assignment (Preferred for Agents)

Rather than using the interactive UI, set `SimFreqs` directly:

`model_edit` `configure` (must include all Inport/Outport CarrierFreq values), then
`save_system('myModel')`:

```json
[{"op":"configure","target":"<Configuration id>","params":{"SimFreqs":"[2.4e9, 2.5e9, 4.9e9]",
  "SimFreqs_unit":"Hz"}}]
```

----

Copyright 2026 The MathWorks, Inc.

----
