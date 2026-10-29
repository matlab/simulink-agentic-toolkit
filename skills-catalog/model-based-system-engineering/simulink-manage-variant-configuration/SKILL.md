---
name: simulink-manage-variant-configuration
description: >
  Manage Simulink Variant Manager and Variant Configurations workflows — examine, list, and explore
  variant configurations, variant control variables, and variant model structure; create,
  modify, and delete variant configurations; validate variant constraints; generate valid
  variant configurations;
  apply, activate, or update models with variant configurations; compare variant configurations
  and analyze which blocks are active or different; open or close the Variant
  Manager UI; set up non-intrusive variant configuration specific simulation and testing with variant
  configurations; show/hide variant control variable usage. Use when working with variant configurations, variant manager,
  VCS objects (VariantConfigurationData / VariantConfigurations), variant control
  variables, preferred configuration, activation of variant choices, or
  reducing a variant model to selected variant configurations.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

## When to Use

- Examining, listing, or exploring variant configurations, control variables, or variant structure of a Simulink model
- Creating, modifying, or deleting variant configurations
- Validating variant configurations against constraints
- Generating valid valid configurations automatically
- Applying, activating, or updating a model with a variant configuration
- Comparing or analysing different variant configurations — which blocks are active, which differ, which are always active
- Reducing a variant model to lock down specific designs i.e a model free from variants as much as possible (`reduceModel`)
- Setting up non-intrusive simulation with variant configurations
- Setting up non-intrusive testing with variant configurations
- Setting or querying the preferred configuration
- Showing or hiding variant control variable usage in a model
- Opening or closing the Variant Manager UI

## When NOT to Use

- General simulation or testing workflows that do not involve variant configurations → use `simulating-simulink-models`, `simulink-run-parallel-simulations`, or `testing-simulink-models`
- General Simulink model building or block-level editing, including creating or editing variant blocks (Variant Subsystem, Variant Source/Sink) → use `building-simulink-models`
- Code generation for variant models → use `simulink-configure-model-for-code-generation`
- Changing `ActiveConfigurationSet` or ConfigSet parameters (Simulink configuration sets, not variant configurations) → use `building-simulink-models`

## Hard Rules

- **Onboard immediately.** As soon as this skill is invoked, run [Onboarding](#onboarding) before doing anything else. Do NOT skip onboarding, as this will setup necessary context for other workflows. Onboarding is per model — if the user switches to a different model or changes attached variant configurations object, onboard again for that model.
- **Read the data model before touching configurations.** Before any task that requires CRUD operations on variant configurations, constraints, or control variable values, read [references/variant-configurations-data-model.md](references/variant-configurations-data-model.md) — including before following [references/variant-configurations-operations.md](references/variant-configurations-operations.md). It defines the object structure, value unwrapping, and model-level control variable rules those tasks depend on.
- **One question at a time.** Ask a single question, give your recommended answer with a one-line reason, and wait for the reply before asking the next. Continue until shared understanding is reached.
- **Finding facts is YOUR job, never the user's.** Use tools to discover model state, variable names, enum values, dictionary contents, etc. Never ask the user to look something up that you can determine programmatically.
- **Never guess function syntax.** Only use syntax documented in the reference files of this skill. If the function is not covered in a reference file, run `help <functionName>` in MATLAB to confirm the exact syntax before using it. Do NOT invent arguments or assume parameter names.
- **Never assume names exist — always verify first.** Before using ANY property name, field name, class name, enum class name, method name, or parameter setting, verify it programmatically in MATLAB (e.g., using `fieldnames`, `properties`, `methods`, `class`, `which`, `get_param`). If you have not confirmed a name exists in the current session, you MUST NOT use it. Inspect first, act second. Exception: syntax and names explicitly documented in this skill's reference files can be assumed to be present.
- **Reload the UI once after all VCS mutations are complete.** Changes made via `evalin` — adding, removing, or modifying configurations, constraints, or control variable values — are not visible in an open Variant Manager until `reloadVariantConfigurationsInUI` runs. Call it exactly once, at the end of the whole mutation sequence: adding three configurations means one reload, not three. Never call it per operation, inside a loop, after read-only operations, after `applyConfiguration` (which does not change the VCS), or after `variantConfigActivateModel` / `variantConfigUpdateModel` (which already sync the UI). Reload discards any unapplied edits in the UI and re-reads the VCS from its source. Changing *which* VCS is attached is not a state change and reload does not handle it — close and reopen the UI instead.
- **Never let unsaved VCS changes be discarded silently.** Changes to the VCS live only in memory until they are saved: in a data dictionary they stay in the open dictionary until `saveChanges` is called, and in the base workspace they last only for the current MATLAB session. Do not save on your own initiative. Before running any code that closes data dictionaries with `'-discard'` — every simulation and testing workflow in this skill does — check for unsaved work and ask the user, one question at a time:
  - **VCS in a data dictionary** (`vcsSource` is `'data dictionary'`): if `Simulink.data.dictionary.open(slddFile).HasUnsavedChanges` is true, ask whether to save the dictionary first. Call `saveChanges` only after the user confirms; if they decline, tell them the changes will be lost when the dictionary is discarded.
  - **VCS in the base workspace**: if it was modified in this session, recommend saving it to a MAT-file (for example `save('<file>.mat', '<vcsName>')` in the base workspace) so it can be reused in a later MATLAB session, and save only after the user confirms.
- **Suggest the Variant Manager UI for exploration.** When the user is exploring variant structure (model hierarchy, variant components, configurations, control variables), suggest opening the Variant Manager UI. On R2026a+, use `Simulink.VariantManager.open(model)`. On older releases, use the `launchVariantManagerUI` script. To close the UI, use the `closeVariantManagerUI` script. The UI displays model hierarchy, variant components, and configuration details far more effectively than programmatic inspection alone.
- **Preferred configuration is only a label.** `PreferredConfiguration` records which configuration is regarded as preferred and has no functional effect: it does not activate, seed, or influence any variant operation. Never describe it as a default — its legacy name, `DefaultConfiguration`, invites that mistake.
- **Respect the MATLAB release. This is non-negotiable.** Before calling any API, check its "Introduced" annotation in the reference files against the onboarded `releaseVersion`. If it is newer, do NOT use it — use the documented fallback or tell the user it is unavailable. Use Name=Value syntax only on R2026a+ and positional arguments on earlier releases; never mix the two.


---

## Onboarding

Run this when the skill starts, and again whenever the target model changes. It establishes the facts every later step relies on: the MATLAB release, the target model, the variant configurations object (VCS) attached to the model, the data source that holds it, and the other VCS objects in that source. Determine them from MATLAB; ask the user only when no model, or more than one, is loaded.

### Step 1: Release and Target Model

```text
releaseVersion = version('-release');
modelNames = find_system('SearchDepth', 0);

if isempty(modelNames)
    error('No loaded Simulink model was found. Ask the user which model to open or use.');
elseif numel(modelNames) == 1
    modelName = modelNames{1};
else
    disp('Loaded models:');
    disp(modelNames(:));
    error('Multiple loaded models were found. Ask the user which model to use and store it as modelName.');
end
```

If several models are loaded, ask which one to use, store it in `modelName`, and continue with Step 2.

### Step 2: Attached VCS, Its Source, and Peer VCS Objects

```text
if ~isMATLABReleaseOlderThan('R2026b')
    vcsModelParam = 'VariantConfigurations';
    ddSectionName = 'Design Data';
    vcsClassName = 'Simulink.VariantConfigurations';
else
    vcsModelParam = 'VariantConfigurationObject';
    ddSectionName = 'Configurations';
    vcsClassName = 'Simulink.VariantConfigurationData';
end

vcsName = get_param(modelName, vcsModelParam);
slddFile = get_param(modelName, 'DataDictionary');

vcsLocation = '';
vcsSource = '';
availableVcsNames = {};

if ~isempty(char(slddFile))
    dictObj = Simulink.data.dictionary.open(slddFile);
    ddSection = getSection(dictObj, ddSectionName);
    entries = find(ddSection);

    for i = 1:numel(entries)
        if isa(getValue(entries(i)), vcsClassName)
            availableVcsNames{end+1} = entries(i).Name; %#ok<AGROW>
        end
    end

    if ismember(vcsName, availableVcsNames)
        vcsLocation = slddFile;
        vcsSource = 'data dictionary';
    end
end

% Check base workspace if the attached VCS was not found in the dictionary.
if isempty(vcsLocation) && ~isempty(vcsName)
    if evalin('base', sprintf('exist(''%s'', ''var'')', vcsName))
        if evalin('base', sprintf('isa(%s, ''%s'')', vcsName, vcsClassName))
            vcsLocation = 'base workspace';
            vcsSource = 'base workspace';
            if ~ismember(vcsName, availableVcsNames)
                availableVcsNames{end+1} = vcsName; %#ok<AGROW>
            end
        end
    end
end

otherVcsNames = setdiff(availableVcsNames, {vcsName}, 'stable');

fprintf('MATLAB release: %s\n', releaseVersion);
fprintf('Model: %s\n', modelName);
fprintf('Data dictionary: %s\n', slddFile);
fprintf('Attached VCS: %s\n', vcsName);
fprintf('Attached VCS location: %s\n', vcsLocation);
fprintf('Attached VCS source: %s\n', vcsSource);
fprintf('Other VCS objects in same source: %s\n', strjoin(otherVcsNames, ', '));
```

### Report

Report the onboarding facts to the user in this format:

```text
## Model: <modelName>

| Property | Value |
|----------|-------|
| MATLAB Release | <releaseVersion> |
| Model Name | <modelName or none> |
| Data Dictionary | <slddFile or none> |
| Attached Variant Configurations | <vcsName or none> |
| Attached VCS Location | <vcsLocation or not found> |
| Attached VCS Source | <vcsSource or not found> |
| Other VCS Objects In Same Source | <comma-separated names or none> |
```

Do not include configuration tables, constraints, or control-variable details in this report unless the user explicitly asked for them.

---

## Workflow Router

After onboarding, determine user intent and route to the appropriate reference.

### Disambiguation: Simulation vs Analysis vs Testing

| User's focus | Route to |
|---|---|
| **What output is produced for a named or implied variant configuration** — signal values, behavior, plotting results | Simulation |
| **What variants are active** — which blocks differ, active paths, structural comparison | Analysis |
| **Pass/fail verification** — benchmarking, regression, baseline, test reports | Testing |

**Precondition — no variant configuration, no skill.** Every row above presumes the request concerns a variant configuration. If the request names no configuration and none is implied (e.g. "simulate the model for 10 seconds and plot the output"), this skill does not apply: say so, do NOT onboard, use standard Simulink practice (`sim` / `Simulink.SimulationInput`), and do NOT call `setVariantConfiguration` or any other variant API. See [When NOT to Use](#when-not-to-use).

If ambiguous (e.g., "compare configurations"), ask the user: are they interested in simulation output values, structural differences between active variants, or pass/fail verification?

| User intent | Route to |
|-------------|----------|
| Inspect VCS structure, configurations, constraints, or stored values | [references/variant-configurations-data-model.md](references/variant-configurations-data-model.md#variant-configurations-object) |
| Inspect model variant control variables (allowed values, enum members, sources, activation times) | [references/variant-configurations-data-model.md](references/variant-configurations-data-model.md#model-control-variables) |
| Add/modify/remove a specific configuration (user describes exact values) | [references/variant-configurations-operations.md](references/variant-configurations-operations.md) |
| Add/modify/remove constraints | [references/variant-configurations-operations.md](references/variant-configurations-operations.md) |
| Add/modify/remove control variables | [references/variant-configurations-operations.md](references/variant-configurations-operations.md) |
| Copy a configuration | [references/variant-configurations-operations.md](references/variant-configurations-operations.md) |
| Set/get preferred configuration | [references/variant-configurations-operations.md](references/variant-configurations-operations.md) |
| Check if a configuration is active | [references/variant-configurations-operations.md](references/variant-configurations-operations.md) |
| Associate/query/remove referenced model configurations | [references/variant-configurations-operations.md](references/variant-configurations-operations.md) |
| Generate exhaustive valid combinations ("all possible", "every valid", "what combinations exist") | [references/variant-manager-operations.md](references/variant-manager-operations.md) (`generateConfigurations`) |
| Apply/activate/update model with a configuration | [references/variant-manager-operations.md](references/variant-manager-operations.md) |
| Validate a constraint against the model | [references/variant-manager-operations.md](references/variant-manager-operations.md) |
| Analyze/compare configurations (active blocks, differences) | [references/variant-manager-operations.md](references/variant-manager-operations.md) → [references/variant-configuration-analysis.md](references/variant-configuration-analysis.md) |
| Work with analysis object (active blocks, differences, dependent models) | [references/variant-configuration-analysis.md](references/variant-configuration-analysis.md) |
| Reduce model / lock down specific designs | [references/variant-manager-operations.md](references/variant-manager-operations.md) |
| Show/hide control variable usage | [references/variant-manager-operations.md](references/variant-manager-operations.md) |
| Attach a different variant configurations object to the model | [Switching the Attached VCS](#switching-the-attached-vcs-close-and-reopen-never-reload) — close and reopen the UI, do not reload |
| Open Variant Manager UI | R2026a+: `Simulink.VariantManager.open(model)` · Older: `launchVariantManagerUI` script |
| Close Variant Manager UI | `closeVariantManagerUI` script |
| Simulate a variant configuration | [references/variant-configuration-simulation.md](references/variant-configuration-simulation.md) |
| Run multiple configurations in parallel | [references/variant-configuration-simulation.md](references/variant-configuration-simulation.md) |
| Sweep configurations with parameter variations | [references/variant-configuration-simulation.md](references/variant-configuration-simulation.md) |
| Compare simulation results across configurations | [references/variant-configuration-simulation.md](references/variant-configuration-simulation.md) |
| Batch/cluster simulation of configurations | [references/variant-configuration-simulation.md](references/variant-configuration-simulation.md) |
| Test variant configurations (Test Manager) | [references/variant-configuration-testing.md](references/variant-configuration-testing.md) |
| Sweep configurations as test iterations | [references/variant-configuration-testing.md](references/variant-configuration-testing.md) |
| Regression/baseline testing across configurations | [references/variant-configuration-testing.md](references/variant-configuration-testing.md) |
| Generate test reports with variant traceability | [references/variant-configuration-testing.md](references/variant-configuration-testing.md) |

---

## Key Functions

Many of these APIs are newer than the skill's release floor. **Check the "Available From" column against the `releaseVersion` captured during onboarding before calling anything** — see the Hard Rules. The reference files carry the authoritative per-function `Introduced` annotation; this table is the summary.

| Function | Purpose | Product | Available From |
|---|---|---|---|
| `Simulink.VariantConfigurationData` / `Simulink.VariantConfigurations` | The VCS — container for configurations, control variables, constraints | Simulink | R2013b (renamed R2026b) |
| `addConfiguration` / `removeConfiguration` / `addCopyOfConfiguration` | Create, delete, copy a configuration | Simulink | R2013b |
| `addControlVariables` / `removeControlVariable` | Set or clear control variable values in a configuration | Simulink | R2013b |
| `addConstraint` / `removeConstraint` | Define or drop a validity constraint | Simulink | R2013b |
| `getPreferredConfiguration` / `setPreferredConfiguration` | Query or set the preferred configuration | Simulink | R2022b |
| `Simulink.VariantManager.applyConfiguration` | Apply a configuration's values to the workspace | Simulink | R2022b |
| `Simulink.VariantManager.activateModel` | Activate variant choices for a configuration | Simulink | R2022b |
| `Simulink.VariantManager.getConfigurationData` / `getVariantConfigurations` | Retrieve the VCS attached to a model | Simulink | R2022b (renamed R2026b) |
| `Simulink.VariantManager.findVariantControlVars` | Discover control variables used by a model | Simulink | R2016a |
| `Simulink.VariantManager.generateConfigurations` | Generate all valid configurations | Simulink | R2022b |
| `Simulink.VariantManager.reduceModel` | Reduce a 150% model to selected designs | Simulink | R2016a |
| `getReferencedConfigurationName` / `addReferencedConfiguration` | Associate referenced-model configurations | Simulink | R2022b–R2023b (renamed R2026b) |
| `setVariantConfiguration` / `getVariantConfiguration` (on `SimulationInput`) | Non-intrusive simulation with a configuration | Simulink | **R2024a** |
| `variantConfigUpdateModel` (script) | Activation plus update diagram, with UI sync | Simulink | **R2024b** |
| `isConfigActive` (in constraint conditions) | Constrain one configuration against another | Simulink | **R2025a** |
| `Simulink.VariantManager.validateConstraint` | Validate a constraint against the model | Simulink | **R2025a** |
| `Simulink.VariantManager.open` | Open the Variant Manager UI programmatically | Simulink | **R2026a** |
| `Simulink.VariantManager.analyzeModel` | Analyze and compare configurations | Simulink | **R2026a** |
| Name=Value syntax on VCS methods | Named arguments instead of positional | Simulink | **R2026a** |
| `parsim` / `batchsim` | Run configurations in parallel or on a cluster | Simulink + Parallel Computing Toolbox | R2017a / R2018b |
| `sltest.testmanager.*` | Test configurations via Test Manager | Simulink Test | R2015a |

On releases below an entry's "Available From", use the fallback documented in the corresponding reference file — do not call the API and do not invent a substitute.

---

## Scripts

### Calling Convention

Before calling any script, capture the current working directory in a separate call. Then pass it as the `currentPath` argument: `project_path` moves the working folder to the scripts folder, and each script changes back into `currentPath` before it runs and stays there.

```text
% Call 1: capture current path (no project_path)
mcp__matlab__evaluate_matlab_code(code: "currentPath = pwd;")

% Call 2: invoke script (with project_path)
mcp__matlab__evaluate_matlab_code(
  code: "<scriptCall>(modelName, currentPath, ...)",
  project_path: "SKILL_DIR/scripts"
)
```

### Available Scripts

| Script | Purpose | Syntax |
|--------|---------|--------|
| `variantConfigActivateModel` | Lightweight variant activation with UI sync | `variantConfigActivateModel(modelName, currentPath, 'Configuration', configName)` |
| `variantConfigUpdateModel` | Full update diagram (compile) with UI sync (R2024b+) | `variantConfigUpdateModel(modelName, currentPath, 'Configuration', configName)` |
| `reloadVariantConfigurationsInUI` | Reload VCS in an open Variant Manager UI after modifications | `reloadVariantConfigurationsInUI(modelName, currentPath)` |
| `vmgrHighlightControlVariables` | Show/hide control variable usage highlighting in the model | `vmgrHighlightControlVariables(modelName, currentPath, controlVarNames, showUsage)` |
| `launchVariantManagerUI` | Open Variant Manager UI for releases older than R2026a | `launchVariantManagerUI(modelName, currentPath)` |
| `closeVariantManagerUI` | Close Variant Manager UI, handling unsaved changes | `closeVariantManagerUI(modelName, currentPath, applyChanges)` |

### Switching the Attached VCS: Close and Reopen, Never Reload

`reloadVariantConfigurationsInUI` re-reads the object **currently** attached to the model. It cannot pick up a *different* object. When the attachment itself changes — you set the model parameter, or the user attaches another VCS themselves — an open Variant Manager UI keeps showing the old object and no amount of reloading will correct it.

**Procedure:**

1. Ask whether to apply the edits pending in the UI to `<oldVcsName>` or discard them — closing the Variant Manager loses them otherwise. Recommend applying them if they look intentional.
2. Close with the answer: `closeVariantManagerUI(modelName, currentPath, applyChanges)`
3. Attach the new object, using the release-specific parameter name found during [Onboarding](#onboarding):
   ```matlab
   set_param(modelName, vcsModelParam, 'newVcsName');
   ```
4. Reopen the UI — R2026a+: `Simulink.VariantManager.open(modelName)` · older: `launchVariantManagerUI`
5. Re-run [Onboarding](#onboarding). The configurations, control variables, and VCS location all changed.

**Do not change the attachment while the UI is open** — the UI and the model parameter disagree until it is reopened. Attaching is a model parameter change, so it dirties the model: tell the user to save the model, or the old attachment returns on reload.

----

Copyright 2026 The MathWorks, Inc.

----
