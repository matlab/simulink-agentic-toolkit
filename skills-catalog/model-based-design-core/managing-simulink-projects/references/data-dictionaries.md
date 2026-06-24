# Data Dictionaries

## Standard Pattern

```matlab
% Create dictionary in project folder:
dict = Simulink.data.dictionary.create(fullfile(proj.RootFolder, 'data', 'MyData.sldd'));

% Register AND make resolvable (both required):
addFile(proj, 'data/MyData.sldd');
addPath(proj, 'data');

% Link model to dictionary — FILENAME ONLY:
set_param('MyModel', 'DataDictionary', 'MyData.sldd');
```

## Dictionary References (Chaining)

```matlab
% Reference another dictionary — FILENAME ONLY:
addDataSource(dict, 'BaseTypes.sldd');

% The referenced dictionary's folder must also be on the path:
addPath(proj, 'shared_data');
```

## Common Failures

| Code | Problem |
|------|---------|
| `addDataSource(dict, '/full/path/to/Base.sldd')` | Throws "must be a valid MATLAB identifier" |
| `set_param(mdl, 'DataDictionary', fullfile(...))` | Stores filename only internally; full path causes resolution failure on reload |
| Not calling `addPath` on dictionary folder | Dictionary can't be found when model loads |

## Key Behaviors

- Dictionary references chain — dict A references dict B, all must be on path
- `Simulink.data.dictionary.getOpenDictionaryPaths` shows what's currently loaded
- Project close auto-closes open dictionaries
- Design data section is accessed via `getSection(dict, 'Design Data')`
