# Source Control and Caching

## Cache and Code Generation Folders

Use **absolute paths** — relative paths resolve against CWD, not project root.

```matlab
proj.SimulinkCacheFolder = fullfile(proj.RootFolder, 'work');
proj.SimulinkCodeGenFolder = fullfile(proj.RootFolder, 'work');
proj.DependencyCacheFile = fullfile(proj.RootFolder, 'work', 'dep_cache.graphml');
```

## .gitignore (Not IgnoredFilePatterns)

`IgnoredFilePatterns` throws "Feature not supported for projects of type: MATLAB:project:management:Xml" for all project types created by `createProject`. Use `.gitignore` instead.

Recommended `.gitignore` for Simulink projects:

```
work/
slprj/
*.slxc
*.mex*
codegen/
*.autosave
```

## Detecting Source Control

After `git init`, the project may need to be reopened for source control integration to appear:

```matlab
close(proj);
proj = openProject(projDir);
```

## Common Failures

| Code | Problem |
|------|---------|
| `proj.IgnoredFilePatterns = ["*.slxc"]` | Throws unsupported feature error |
| `proj.SimulinkCacheFolder = 'work'` | Resolves relative to CWD, not project root |
| `proj.DependencyCacheFile = '...cache.xml'` | Must be `.graphml` extension |

## Key Behaviors

- All project definition file types from `createProject` are XML-based — none support `IgnoredFilePatterns`
- `listModifiedFiles` returns files with a `SourceControlStatus` property
- The `ProjectPath` health check catches `addpath()` usage without `addPath()`
