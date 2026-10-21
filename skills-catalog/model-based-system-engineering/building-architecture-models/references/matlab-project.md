<!-- Copyright 2026 The MathWorks, Inc. -->

# Project Patterns for Architecture Workflows

System Composer–specific project patterns. For general project mechanics (`addFile` vs `addPath`, `removeFile`-before-delete, `.slmx` registration, source control), see `managing-simulink-projects`.

---

## Folder Structure

The workflow assumes these folders exist and are on the project path:

| Folder | Contents |
|--------|----------|
| `architecture/` | `.slx` models, `.sldd` dictionaries, `.xml` profiles, `.mldatx` allocation sets |
| `requirements/` | `.slreqx` requirement sets |
| `analysis/` | Analysis function files, `.mat` analysis outputs |

---

## Profile and Dictionary Resolution

System Composer resolves dictionaries, profiles, and models via the MATLAB path — not relative file paths. The architecture folder must be on the path before calling `createDictionary`, `createModel`, `linkDictionary`, or `applyProfile`:

```matlab
addPath(proj, 'architecture');
```

Without this, SC APIs either throw "file not found" or silently create artifacts in the current directory instead of the intended location.

## Saving Models into the Architecture Folder

`systemcomposer.createModel` takes a model **name**, not a path. Passing `fullfile(archDir, 'MyLogical')` drops the folder, and a later `model.save()` writes `MyLogical.slx` to the current folder. Save the new model into the folder explicitly:

```matlab
model = systemcomposer.createModel('MyLogical');
save_system('MyLogical', fullfile(archDir, 'MyLogical.slx'));
```

----

Copyright 2026 The MathWorks, Inc.

----
