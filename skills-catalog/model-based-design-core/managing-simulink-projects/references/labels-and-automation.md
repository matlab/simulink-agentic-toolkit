# Labels and Automation

## Creating Categories and Labels

```matlab
% Valid DataTypes: 'none', 'char', 'double', 'integer', 'logical'
% NOT 'string' — this is the most common hallucination
cat = createCategory(proj, 'CodeGen', 'char');

% Single-valued category (one label per file from this category):
cat = createCategory(proj, 'Priority', 'integer', 'single-valued');

% Create labels within a category:
createLabel(cat, 'Production');
createLabel(cat, 'Prototype');
```

## Applying Labels to Files

### R2024a+
```matlab
% Label a project file (with optional data for typed categories):
addLabel(proj, "models/MyModel.slx", 'CodeGen', 'Production');

% Label multiple files at once:
addLabel(proj, ["models/A.slx", "models/B.slx"], 'CodeGen', 'Prototype');
```

### R2023a/b:
The project-level `addLabel(proj, filePath, ...)` shortcut requires R2024b+. On R2023a or R2023b, retrieve the file object first with `findFile`:

```matlab
% R2023a/b pattern — get file object, then label it:
f = findFile(proj, "models/MyModel.slx");
addLabel(f, 'CodeGen', 'Production');

% Multiple files:
files = ["models/A.slx", "models/B.slx"];
for i = 1:numel(files)
    f = findFile(proj, files(i));
    addLabel(f, 'CodeGen', 'Prototype');
end
```

## Querying Labeled Files

```matlab
% CORRECT syntax — 'Category' + 'Label' name-value pairs:
files = findFiles(proj, 'Category', 'CodeGen', 'Label', 'Production');

% WRONG (common mistake): findFiles(proj, 'Label', 'X', 'Name', 'Y')
```

## Inspecting Category Definitions

```matlab
% CORRECT property:
cat.LabelDefinitions

% WRONG (does not exist): cat.Labels
```

## Key Behaviors

- `createCategory` and `createLabel` are idempotent
- For single-valued categories, adding a new label silently replaces the old one
- `findCategory` returns empty (not error) for non-existent categories
- Default "Classification" category exists on all projects and auto-classifies files:
  - `.slx` → "Design"
  - `.m` → "Convenience" (or other based on content)
- Valid DataTypes: `'none'`, `'char'`, `'double'`, `'integer'`, `'logical'` — nothing else
