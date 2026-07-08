# Safety Analysis Manager — Spreadsheet API Reference

Programmatic reference for tabular safety analysis documents: FMEA, FHA, HARA, HAZOP, and custom spreadsheets. For shared APIs (save, callbacks, flags, links, change detection), see `common-api.md`.

> **Version enforcement:** Each API below is annotated with the MATLAB release it was introduced. Do NOT use an API unless the user's MATLAB release is equal to or newer than the listed version. If the user's release is unknown, assume R2023b and restrict to R2023b APIs only until confirmed.

## Creating Spreadsheets (R2023b)

### Blank Spreadsheet

```matlab
ss = safetyAnalysisMgr.newSpreadsheet                  % Create new blank spreadsheet in Safety Analysis Manager
```

A new blank spreadsheet starts with 1 default column (labeled "Label1") and 1 default row. Add your columns first, delete the default column, add your data rows, then delete the default empty row (row 1). See the "Custom Spreadsheet Setup" section below for the full pattern.

### From Built-In Template (only when explicitly requested by user)

```matlab
ss = safetyAnalysisMgr.newSpreadsheet("MW_Aerospace_Templates", "FMEA");  % from built-in template
ss = safetyAnalysisMgr.newSpreadsheet("MW_Aerospace_Templates", "AFHA");  % Aircraft FHA template
ss = safetyAnalysisMgr.newSpreadsheet("MW_Aerospace_Templates", "SFHA");  % System FHA template
```

### From File Template (only when explicitly requested by user)

```matlab
ss = safetyAnalysisMgr.newSpreadsheet(templateFile)    % Create new spreadsheet from .mldatx template file
```

## Built-In Templates

| Group | Template | Columns (8 total) | Enum Columns |
|---|---|---|---|
| `MW_Aerospace_Templates` | `FMEA` | Function Name, Failure Mode, Failure Rate (E-06), Flight Phase, Failure Effect, Detection Method, Comments | Flight Phase (`sfaTemplate.FlightPhase`) |
| `MW_Aerospace_Templates` | `AFHA` | ID#, Aircraft Function, Aircraft SubFunction, Failure Condition, Flight Phase, Effect of Failure Condition on Aircraft Crew Occupants, Severity Classification, Assumptions Comments Rationale Reference | Flight Phase (`sfaTemplate.FlightPhase`), Severity Classification (`sfaTemplate.SeverityClassification`) |
| `MW_Aerospace_Templates` | `SFHA` | ID#, System Function, Failure Condition, Flight Phase, Effect of Failure Condition on Aircraft Crew Occupants, Severity Classification, Assumptions Comments Rationale Reference | Flight Phase (`sfaTemplate.FlightPhase`), Severity Classification (`sfaTemplate.SeverityClassification`) |

**Enum values:**
- `sfaTemplate.FlightPhase`: `Unset` | `Taxi_Takeoff` | `OnGround` | `Climb` | `Cruise` | `Descent` | `Approach` | `Landing`
- `sfaTemplate.SeverityClassification`: `Unset` | `Catastrophic` | `Hazardous` | `Major` | `Minor` | `NoSafetyEffect`

When using `addRow(Value={...})` with enum columns, pass the enum value as a string (e.g., `"Cruise"`, `"Catastrophic"`).

## Spreadsheet Class (`safetyAnalysisMgr.Spreadsheet`) (R2023b)

Inherits from `safetyAnalysisMgr.Document`.

### Properties

| Property | Access | Description |
|---|---|---|
| `Rows` | Read-only | Number of rows |
| `Columns` | Read-only | Number of columns |
| `FileName` | Read-only | File path (empty string until first save) |
| `Description` | Read/Write | Spreadsheet description |

## Row Operations

```matlab
addRow(ss)                                    % Add row to spreadsheet in Safety Analysis Manager (R2023b)
addRow(ss, Position=3)                        % Add row at index 3 (R2023b)
addRow(ss, Count=5)                           % Add 5 empty rows (R2023b)
addRow(ss, Value={"col1val", "col2val", ...}) % Add row with values (must match column count) (R2023b)
addRow(ss, Value={"a","b"; "c","d"}, Count=2) % Add multiple rows with values (R2023b)
deleteRow(ss, index)                          % Delete row in spreadsheet in Safety Analysis Manager (R2023b)
moveRow(ss, FromPosition, ToPosition)         % Move row from one position to another (R2026b+)
row = getRow(ss, index)                       % Retrieve spreadsheet rows (R2024b)
```

## Column Operations

```matlab
addColumn(ss)                                             % Add column to spreadsheet in Safety Analysis Manager (R2023b)
addColumn(ss, Label="Name", Type="text")                  % Add named text column (R2023b)
addColumn(ss, Label="Done", Type="checkbox")              % Add checkbox column (R2023b)
addColumn(ss, Label="Score", Type="derived")              % Add derived/formula column (R2023b)
addColumn(ss, Label="Phase", Type="sfaTemplate.FlightPhase")  % Add enum dropdown column (R2023b)
addColumn(ss, Position=2, Label="ID", Type="text")        % Add column at position (R2023b)
addColumn(ss, Count=3, Label=["A","B","C"], Type=["text","text","checkbox"])  % Add multiple columns (R2023b)
deleteColumn(ss, index_or_label)                          % Delete column in spreadsheet in Safety Analysis Manager (R2023b)
labels = getColumnLabels(ss)                              % Retrieve column labels in spreadsheet in Safety Analysis Manager (R2023b)
types  = getColumnTypes(ss)                               % Retrieve column types in spreadsheet in Safety Analysis Manager (R2024b)
setColumnLabel(ss, indexOrLabel, newLabel)                 % Adjust column label of spreadsheet in Safety Analysis Manager (R2023b)
```

Column types: `"text"` | `"checkbox"` | `"derived"` | enumeration class name string (e.g., `"sfaTemplate.FlightPhase"`)

## Cell Access (R2023b)

```matlab
setValue(ss, row, column, value)       % Write values to spreadsheet cells (column: index or label string)
cell = getCell(ss, row, column)        % Retrieve spreadsheet cells (column: index or label)
```

Values: string/char for text, `true`/`false` for checkbox, enum value or string for enum columns. Cannot set derived column values (computed automatically).

**Note:** `getCell` on enum columns returns the enum object (e.g., `sfaTemplate.FlightPhase.Cruise`), not a string. Use `string(cell.Value)` to convert for display or concatenation.

## Derived Column Formulas (R2023b)

```matlab
setColumnFormula(ss, indexOrLabel, matlabCode)   % Specify derived column formulas in spreadsheet in Safety Analysis Manager (R2023b)
code = getColumnFormula(ss, indexOrLabel)         % Retrieve derived column formula code (R2023b)
refreshDerivedValues(ss)                          % Recalculate values in spreadsheet derived columns (R2024b)
```

**Important:** Derived columns count toward the `addRow(Value={...})` array length. Pass `""` as a placeholder for derived column positions — the value is ignored but the element must be present.

Inside formulas, use `sfa_columnValue("ColumnLabel")` to read values from other columns in the same row. The formula **must assign its output to `sfa_derivedValue`** — simply returning or evaluating an expression does not work. For computations, call an external function or write inline code that assigns to `sfa_derivedValue`:

```matlab
addColumn(ss, Label="RPN", Type="derived");
setColumnFormula(ss, "RPN", ...
    "x = sfa_columnValue(""Severity""); y = sfa_columnValue(""Occurrence""); sfa_derivedValue = num2str(str2double(x) * str2double(y));");
```

For complex formulas, define an external `.m` function and call it from the formula:

```matlab
% myRPNCalc.m on the MATLAB path:
%   function output = myRPNCalc(severity, occurrence)
%       output = num2str(str2double(severity) * str2double(occurrence));
%   end

setColumnFormula(ss, "RPN", ...
    "s = sfa_columnValue(""Severity""); o = sfa_columnValue(""Occurrence""); sfa_derivedValue = myRPNCalc(s, o);");
```

When using cell references (see Cell References section below), use `sfa_referencedValues()` to retrieve values from referenced cells as a cell array:

```matlab
setColumnFormula(ss, "Total", ...
    "vals = sfa_referencedValues(); sfa_derivedValue = num2str(sum(str2double(vals)));");
```

**Formula context functions summary:**
- `sfa_columnValue("Label")` — read a value from another column in the same row
- `sfa_referencedValues()` — read values from externally referenced cells (returns cell array)
- `sfa_derivedValue` — assign the output (must be char/string)

**Known limitation:** Derived column formulas may fail with "Invalid text character" errors when referenced text columns contain non-ASCII characters (e.g., em-dashes). Workaround: use a plain text column and set RPN values manually with `setValue`.

## Search (R2023b)

```matlab
cells = find(ss, "searchText")                          % Find cells in Safety Analysis Manager spreadsheets containing specific values
cells = find(ss, "searchText", MatchCase=true)           % Find cells (case-sensitive)
cells = find(ss, "searchText", WholeWord=true)           % Find cells (exact cell content match)
cells = find(ss, "searchText", MatchCase=true, WholeWord=true)
```

Returns `SpreadsheetCell` array of matching cells. Searches text, derived, and enum columns only (skips checkboxes).

## Custom Spreadsheet Setup

**Important:** A new blank spreadsheet starts with 1 default row and 1 default column (labeled "Label1"). You must account for this:

1. Add your desired columns first.
2. Delete the default "Label1" column.
3. After adding your data rows, delete the default empty row (row 1).

```matlab
ss = safetyAnalysisMgr.newSpreadsheet;

% Add desired columns (all text)
addColumn(ss, Label="Hazard ID", Type="text");
addColumn(ss, Label="Severity", Type="text");
addColumn(ss, Label="Occurrence", Type="text");
addColumn(ss, Label="RPN", Type="text");

% Remove the default first column
deleteColumn(ss, 1);

% Add data rows (cell array length must match column count)
addRow(ss, Value={"H-001", "8", "4", "32"});
addRow(ss, Value={"H-002", "6", "3", "18"});

% Delete the default empty row (always row 1 before your data rows)
deleteRow(ss, 1);
```

## SpreadsheetCell Class (`safetyAnalysisMgr.SpreadsheetCell`) (R2023b)

### Properties

| Property | Access | Description |
|---|---|---|
| `Row` | Read-only | Row index |
| `Column` | Read-only | Column index |
| `ColumnLabel` | Read-only | Column label string |
| `Value` | Read/Write | Cell content (string for text, logical for checkbox, enum for enum columns). Cannot set on derived columns. |
| `Description` | Read/Write | Cell annotation (free-text note) |

### Methods

```matlab
ss = getSpreadsheet(cell)                          % Retrieve spreadsheet containing specified cell (R2024a)
row = getRow(cell)                                 % Retrieve row containing specified cell (R2024b)
navigate(cell)                                     % Navigate to cell in Safety Analysis Manager GUI (R2023b)
linksStruct = getLinks(cell)                       % Get links associated with spreadsheet cell or row in Safety Analysis Manager (R2023b)
flag = addFlag(cell, type, Description=..., Tag=...)  % Add flag to Safety Analysis Manager spreadsheet cell or row (R2023b)
flags = getFlags(cell)                             % Retrieve flags from Safety Analysis Manager spreadsheets (R2023b)
clearFlags(cell)                                   % Clear flags in Safety Analysis Manager spreadsheet (R2023b)
changes = getChanges(cell)                         % Get changed artifacts linked to artifacts in Safety Analysis Manager (R2024b)
acceptAllChanges(cell)                             % Accept detected changes to linked artifacts in Safety Analysis Manager (R2024b)
```

### Cell References (R2024b)

Cell references allow a derived column formula to pull values from cells in other spreadsheets.

```matlab
addReference(cell, arrayOfSourceCells)             % Add references to cells (R2024b)
references = getReferences(cell)                   % Get referenced cells — returns cell array of CellReference objects (R2024b)
values = getReferencedValues(cell)                 % Get referenced cell values — returns cell array of strings (R2024b)
removeReference(cell, indexOrSourceCell)           % Remove reference by index or source cell (R2024b)
moveReference(cell, currentIndex, newIndex)        % Change order of references (R2024b)
```

Requirements: the cell must be in a derived column, and the spreadsheet must be saved before references can be added.

### CellReference Class (`safetyAnalysisMgr.CellReference`) (R2024b)

| Property | Access | Description |
|---|---|---|
| `FileName` | Read-only | Full file path of the source spreadsheet (empty if invalid) |
| `Row` | Read-only | Row index of referenced cell (NaN if unresolved) |
| `Column` | Read-only | Column index of referenced cell (NaN if unresolved) |
| `ColumnLabel` | Read-only | Column label of referenced cell (empty if unresolved) |
| `Value` | Read-only | Current value of referenced cell |

## SpreadsheetRow Class (`safetyAnalysisMgr.SpreadsheetRow`) (R2024b)

### Properties

| Property | Access | Description |
|---|---|---|
| `Index` | Read-only | Row index |
| `Cells` | Read-only | Number of cells in the row |
| `Description` | Read/Write | Row annotation |

### Methods

```matlab
cell = getCell(row, column)                        % Retrieve spreadsheet cells by index or label (R2024b)
ss = getSpreadsheet(row)                           % Retrieve spreadsheet containing specified row (R2024b)
move(row, toPosition)                              % Move row to a new position (positional arg, not name-value) (R2026b+)
navigate(row)                                      % Navigate to row in Safety Analysis Manager GUI (R2024b)
linksStruct = getLinks(row)                        % Get links associated with spreadsheet cell or row in Safety Analysis Manager (R2024b)
flag = addFlag(row, type, Description=..., Tag=...)  % Add flag to Safety Analysis Manager spreadsheet cell or row (R2024b)
flags = getFlags(row)                              % Retrieve flags from Safety Analysis Manager spreadsheets (R2024b)
clearFlags(row)                                    % Clear flags in Safety Analysis Manager spreadsheet (R2024b)
changes = getChanges(row)                          % Get changed artifacts linked to artifacts in Safety Analysis Manager (R2024b)
acceptAllChanges(row)                              % Accept detected changes to linked artifacts in Safety Analysis Manager (R2024b)
```

## Guardrails

- Use `addRow` with the `Value` parameter for bulk population — it is faster than setting cells individually
- Match the cell array length in `addRow(ss, Value={...})` exactly to the number of columns
- Use ASCII characters only in cell values (avoid em-dashes, curly quotes) to prevent formula evaluation errors
- Do not assume column indices without checking `getColumnLabels` first on existing spreadsheets

----

Copyright 2026 The MathWorks, Inc.

----
