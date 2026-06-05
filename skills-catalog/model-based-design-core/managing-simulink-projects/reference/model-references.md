# Model References

## Cross-Folder Resolution

Model references resolve via the MATLAB path by filename. Simulink checks the model's own folder first, but cross-folder references require the target folder on the project path.

## Standard Pattern

```matlab
% Each subfolder with referenced models needs its own addPath:
addPath(proj, 'models');
addPath(proj, 'models/plants');
addPath(proj, 'models/controllers');
```

## Dependency Graph

Always call `updateDependencies` before querying — the graph is not automatically refreshed.

```matlab
updateDependencies(proj);
deps = proj.Dependencies;  % digraph

% Inspect edges:
deps.Edges  % table showing who depends on whom

% Find what a specific file needs:
reqFiles = listRequiredFiles(proj, 'models/TopModel.slx');

% Find what's impacted by changes to a file:
impacted = listImpactedFiles(proj, 'models/plants/PlantModel.slx');
```

## Common Failures

| Code | Problem |
|------|---------|
| Querying `proj.Dependencies` without `updateDependencies` first | Stale or empty dependency info |
| Iterating `Dependencies` like a struct array | It's a `digraph` — use `.Edges`, `.Nodes`, graph functions |
| Not adding each subfolder with `addPath` | "Unable to find model" at simulation time |

## Key Behaviors

- `listRequiredFiles` includes the queried file itself in results
- `listImpactedFiles` includes the queried file itself in results
- Same-folder references auto-resolve without path configuration
- `addPath` is NOT recursive — must add each subfolder explicitly
