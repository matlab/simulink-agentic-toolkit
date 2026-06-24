---
name: managing-simulink-projects
description: >-
  Manages MATLAB projects for Simulink workflows: path management, file registration, labels,
  source control configuration, and project lifecycle. Use when creating projects, adding
  models/dictionaries/requirements to projects, configuring labels for automation, fixing broken
  model references, or setting up source control for Simulink artifacts.
license: MathWorks BSD-3-Clause
metadata:
  author: MathWorks
  version: "1.1"
---

# Managing Simulink Projects

MATLAB projects coordinate Simulink workflows — they manage the MATLAB path (which Simulink uses to resolve model references, data dictionaries, and requirements), track file membership for source control, and provide label-based automation for selecting targets in CI/CD pipelines.

## When to Use

- Creating a new MATLAB project for Simulink models
- Adding models, data dictionaries, or requirements to an existing project
- Configuring project paths so Simulink can resolve references
- Setting up labels for automation (test selection, code generation targets)
- Configuring source control and cache folders
- Diagnosing broken model references, missing dictionaries, or failing project health checks

## When NOT to Use

- Building or editing model structure (blocks, connections) → use `building-simulink-models`
- Writing or running tests → use `testing-simulink-models`
- Drafting requirements content → use `generate-requirement-drafts`
- Running simulations for analysis → use `simulating-simulink-models`

## Mental Model

Four principles that prevent the most common failures:

1. **Registration ≠ path.** `addFile` registers a file with the project for source control tracking. `addPath` puts a folder on the MATLAB path so Simulink can resolve artifacts by filename. These are independent operations — you almost always need both.

2. **Filename-only resolution.** Data dictionaries (`set_param(...,'DataDictionary',...)`, `addDataSource`), model references, and requirements all resolve via MATLAB path using **filename only** — never full paths. The containing folder must be on the project path.

3. **`addPath` is not recursive.** Each subfolder containing resolvable artifacts needs its own `addPath` call.

4. **Single-project constraint.** Only one project can be open at a time. Creating or opening a new project silently closes the current one (running its shutdown scripts). `currentProject` throws an error when no project is open — it does not return empty.

## Guardrails

**Always:**
- Use `addPath(proj, folder)` for every folder containing dictionaries, referenced models, requirements, or profiles
- Pass filename only (not full paths) to `addDataSource`, `set_param(...,'DataDictionary',...)`, and `slreq.createLink`
- Use absolute paths for `SimulinkCacheFolder` and `SimulinkCodeGenFolder`: `proj.SimulinkCacheFolder = fullfile(proj.RootFolder, 'work')`
- Call `updateDependencies(proj)` before querying `proj.Dependencies`
- Close the current project before creating or opening another
- Use `.graphml` extension for `DependencyCacheFile`
- Use `.gitignore` for excluding derived files from source control
- Add requirements folder to project path when linking requirements to models
- Register `.slmx` link-store files with the project (guarded by `isfile` check)

**Ask First:**
- Deleting files from a project (`removeFile` then disk delete)
- Modifying startup/shutdown scripts (affects all users who open the project)
- Changing project references (affects dependent projects)

**Never:**
- Use `proj.IgnoredFilePatterns` — throws "Feature not supported" for all project types from `createProject`
- Use `cat.Labels` — the correct property is `cat.LabelDefinitions`
- Use `'string'` as a label DataType — valid types are `'none'`, `'char'`, `'double'`, `'integer'`, `'logical'`
- Use `findFile` (singular) for label queries in R2024a+ — use `findFiles` (plural). ONLY use `findFile` with R2023a/b
- Pass full file paths to filename-only APIs
- Attempt to open two projects simultaneously
- Use `clear all` in startup scripts — it wipes the `proj` variable

## Task Routing

| Intent | Reference |
|--------|-----------|
| Add files/folders to project, manage project path | `references/path-and-file-management.md` |
| Set up labels for automation pipelines | `references/labels-and-automation.md` |
| Link data dictionaries to models | `references/data-dictionaries.md` |
| Configure model references across folders | `references/model-references.md` |
| Configure source control, cache folders, `.gitignore` | `references/source-control-and-caching.md` |
| Diagnose broken references or health check failures | Start with Verification below, then route to the relevant reference |

## Verification

Run after every project modification:

```matlab
results = runChecks(proj);
updateDependencies(proj);
deps = proj.Dependencies;  % digraph
```

If `runChecks` reports issues, inspect which folders are missing from the project path — this is the root cause of most failures.

----

Copyright 2026 The MathWorks, Inc.

----
