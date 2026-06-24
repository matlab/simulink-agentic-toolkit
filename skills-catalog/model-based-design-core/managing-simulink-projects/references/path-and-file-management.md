# Path and File Management

## The Core Distinction

| Operation | What it does | When you need it |
|-----------|-------------|-----------------|
| `addFile(proj, relPath)` | Registers file with project for source control tracking | Always — every file in your project |
| `addPath(proj, folder)` | Puts folder on MATLAB path so Simulink resolves artifacts by filename | Any folder containing `.sldd`, `.slx` (referenced models), `.slreqx`, or profiles |

These are independent. `addFile` never touches the MATLAB path. `addPath` never registers files.

## Standard Pattern

```matlab
% Register file AND make its folder resolvable (two operations):
addFile(proj, 'data/params.sldd');
addPath(proj, 'data');

% addPath is NOT recursive — each subfolder needs its own call:
addPath(proj, 'models');
addPath(proj, 'models/plants');
addPath(proj, 'models/controllers');
```

## Bulk Registration

```matlab
% Add entire folder tree to project (registration only — still need addPath):
addFolderIncludingChildFiles(proj, 'models');

% Then add each subfolder to the path:
addPath(proj, 'models');
addPath(proj, 'models/plants');
```

## Querying Project Files

```matlab
% Find files by label (correct API is findFiles, plural):
files = findFiles(proj, 'Category', 'Classification', 'Label', 'Design');

% All project files:
proj.Files  % array of ProjectFile objects
```

## Idempotent Script Pattern

When writing scripts that recreate artifacts, use `removeFile` before `delete` to prevent broken project references:

```matlab
targetFile = fullfile(proj.RootFolder, 'data', 'MyDict.sldd');
if isfile(targetFile)
    removeFile(proj, 'data/MyDict.sldd');
    delete(targetFile);
end
```

## Key Behaviors

- `addFile` is idempotent — adding same file twice does not error
- `addPath` is idempotent — adding same folder twice does not error
- `removePath` on a folder not in project path is a no-op
- `addPath` on a non-existent folder throws an error
- `addFile` on a non-existent file throws an error
- Files must be under the project root folder
- `addFile` auto-adds the parent folder entry
- Use `addPath(proj, ...)` not MATLAB's builtin `addpath()` — `runChecks` flags the latter
