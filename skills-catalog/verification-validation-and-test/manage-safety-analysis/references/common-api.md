# Safety Analysis Manager — Common API Reference

Shared programmatic APIs for all Safety Analysis Manager document types (spreadsheets and trees). Requires **Simulink Fault Analyzer** (R2023b+). Native file format: `.mldatx`.

> **Note:** Not all `.mldatx` files are Safety Analysis Manager documents. Always verify with `fileType` before opening unknown `.mldatx` files.

> **Version enforcement:** Each API below is annotated with the MATLAB release it was introduced. Do NOT use an API unless the user's MATLAB release is equal to or newer than the listed version. If the user's release is unknown, assume R2023b and restrict to R2023b APIs only until confirmed.

## Top-Level Functions

### File Type Verification

**Always** call `fileType` before `safetyAnalysisMgr.openDocument` when the origin of a `.mldatx` file is uncertain.

```matlab
ft = fileType(filePath);
% Returns "document" (SAM document) or "template" (SAM template).
% Throws an error if the file is not a Safety Analysis Manager file (e.g., Simulink Test Manager .mldatx files).
%
% "document" -> proceed with safetyAnalysisMgr.openDocument(filePath)
% "template" -> proceed with safetyAnalysisMgr.newSpreadsheet(filePath) or newTree(filePath)
```

| MATLAB Release | How to call |
|---|---|
| R2026b+ | `safetyAnalysisMgr.fileType(filePath)` (native) |
| R2023b–R2026a | `fileType(filePath)` via bundled `scripts/fileType` helper (identical behavior) |

### Document Lifecycle (R2023b)

```matlab
ss = safetyAnalysisMgr.openDocument(fileName)                 % Open Safety Analysis Manager document
docs = safetyAnalysisMgr.getOpenDocuments                     % Retrieve open spreadsheets in Safety Analysis Manager
ss = safetyAnalysisMgr.import(fileName)                       % Import Excel file into Safety Analysis Manager
```

**Important:** `openDocument` requires the file's parent folder to be on the MATLAB search path. Call `addpath(fileparts(fileName))` before opening if the folder is not already on the path.

### Unified Document Creation (R2026b+)

Alternative to `newSpreadsheet`/`newTree` — creates either document type via a single entry point.

```matlab
doc = safetyAnalysisMgr.newDocument('spreadsheet')            % Create new blank spreadsheet
doc = safetyAnalysisMgr.newDocument('fault-tree')             % Create new blank fault tree
doc = safetyAnalysisMgr.newDocument(templateFile)             % Create from .mldatx template
doc = safetyAnalysisMgr.newDocument(group, templateName)      % Create from registered template
```

### Manager UI (R2023b)

```matlab
safetyAnalysisMgr.openManager                                 % Open Safety Analysis Manager
safetyAnalysisMgr.closeManager                                % Close Safety Analysis Manager
safetyAnalysisMgr.closeAllDocuments                            % Close documents in Safety Analysis Manager (prompts to save)
safetyAnalysisMgr.closeAllDocuments(Force=true)                % Close documents without saving
```

### Selection (R2023b)

```matlab
sel = safetyAnalysisMgr.getCurrentSelection   % Get current cell or row in Safety Analysis Manager spreadsheet
```

### File Inspection (R2026b+)

```matlab
ft = safetyAnalysisMgr.fileType(filePath)     % returns "document" or "template"
```

### Diagnostics (R2023b)

```matlab
msg = safetyAnalysisMgr.getDiagnostics        % Return diagnostics in Safety Analysis Manager
safetyAnalysisMgr.clearDiagnostics            % Clear diagnostics in Safety Analysis Manager
safetyAnalysisMgr.saveDiagnostics(fileName)   % Save diagnostics in Safety Analysis Manager to text file
```

## Save, Close, Export (R2023b)

```matlab
save(doc)                              % Save spreadsheet in Safety Analysis Manager (errors if never saved)
save(doc, "path/to/file.mldatx")       % Save spreadsheet in Safety Analysis Manager (assigns filename)
close(doc)                             % Close spreadsheet in Safety Analysis Manager (errors if unsaved changes)
close(doc, Force=true)                 % Close spreadsheet without saving
export(doc, "path/to/file.xlsx")       % Export Safety Analysis Manager spreadsheet to Excel
saveTemplate(doc, "template.mldatx")   % Save spreadsheet in Safety Analysis Manager as a template
```

Export supports: `.xls`, `.xlsx`, `.xlsb`, `.xlsm`, `.xltx`, `.xltm` (Excel only).

**Important:** Save using `save(doc, 'filename.mldatx')`. Do **not** attempt to set `doc.Name` (not a valid property) or `doc.FileName` (read-only). The filename is assigned solely through the `save` function call. If you call `save(doc)` on a document that has never been saved, it will error.

## Callbacks

```matlab
names = getCustomCallbackNames(doc)                        % Retrieve custom callback names (R2026b+)
addCallback(doc, "MyCallback")                             % Add custom callback to Safety Analysis Manager spreadsheets (R2024a)
setCallback(doc, "AnalyzeFcn", "disp('running')")          % Assign code to Safety Analysis Manager spreadsheet callback (R2024a)
setCallback(doc, "MyCallback", "disp('custom')")           % Assign code to custom callback (R2024a)
code = getCallback(doc, "AnalyzeFcn")                      % Retrieve spreadsheet callback code in Safety Analysis Manager (R2024a)
code = getCallback(doc, "MyCallback")                      % Retrieve custom callback code (R2024a)
deleteCallback(doc, "MyCallback")                          % Delete custom callback from Safety Analysis Manager spreadsheets (R2024a)
renameCallback(doc, "oldName", "newName")                  % Rename custom callbacks in Safety Analysis Manager spreadsheets (R2024a)
enableCallback(doc, ["MyCallback1","MyCallback2"], [true, false])  % Enable or disable callbacks in Safety Analysis Manager spreadsheets (R2024a)
tf = isCallbackEnabled(doc, ["MyCallback1"])               % Determine whether custom callbacks are enabled (R2024a)
runAnalysis(doc)                                           % Execute callback script on Safety Analysis Manager spreadsheet (R2023b)
```

Built-in callback types: `'PreLoadFcn'` | `'PostLoadFcn'` | `'AnalyzeFcn'` | `'PreSaveFcn'` | `'PostSaveFcn'` | `'CloseFcn'`

Notes:
- `setCallback`/`getCallback` work with both built-in types and custom callback names
- `deleteCallback`, `renameCallback`, `enableCallback`, `isCallbackEnabled` work only with custom callbacks (not built-in)
- Custom callback names must be valid MATLAB variable names
- The code argument to `setCallback` must be a **string scalar** or **character vector**. For multi-line callback code, use `join([...lines...], newline)` to produce a scalar string — do NOT pass a string array or use character vector concatenation with `[...]` across multiple strings

### Predefined Variables in Callback Code

Inside callback code strings, use a predefined variable to access the document object that owns the callback:

| MATLAB Release | Variable | Status |
|---|---|---|
| R2026b+ | `sfa_document` | **Current** — use this for new code |
| R2023b–R2026a | `sfa_spreadsheet` | **Deprecated in R2026b** — still works for backward compatibility, but prefer `sfa_document` |

The variable resolves to the public document object (e.g., `safetyAnalysisMgr.Spreadsheet` or `safetyAnalysisMgr.FaultTreeDocument`) at execution time. Use it for all document operations inside the callback (e.g., `sfa_document.Rows`, `getCell(sfa_document, ...)`, `setValue(sfa_document, ...)`).

## Document Attributes

Key-value metadata attached to the document.

```matlab
addDocumentAttribute(doc, property="Author", value="Safety Team")   % Add document attribute to spreadsheet in Safety Analysis Manager (R2023b)
setDocumentAttribute(doc, "Author", "Updated Name")                 % Set document attributes in spreadsheet in Safety Analysis Manager (R2023b)
val = getDocumentAttribute(doc, "Author")                           % Retrieve document attribute values in spreadsheet in Safety Analysis Manager (R2023b)
props = getDocumentAttributeProperties(doc)         % Retrieve document attribute properties in Safety Analysis Manager spreadsheet (R2024b)
renameDocumentAttribute(doc, "oldName", "newName")                  % Rename document attributes in spreadsheets (R2023b)
deleteDocumentAttribute(doc, "Author")                              % Delete document attributes in spreadsheet in Safety Analysis Manager (R2023b)
```

## Flags (R2023b)

```matlab
flag = addFlag(element, "error", Description="Missing data", Tag="incomplete")   % Add flag to Safety Analysis Manager spreadsheet cell or row
flag = addFlag(element, "warning", Description="Needs review")                   % Add flag to Safety Analysis Manager spreadsheet cell or row
flags = getFlags(doc)             % Retrieve flags from Safety Analysis Manager spreadsheets (document-level)
flags = getFlags(element)         % Retrieve flags from a specific element (cell, row, or node)
clearFlags(doc)                   % Clear flags in Safety Analysis Manager spreadsheet (document-level)
clearFlags(element)               % Clear flags from specific element
clear(flag)                       % Clear Safety Analysis Manager document flag
```

Flag types: `"error"` | `"warning"` | `"check"`

### DocumentFlag Class (`safetyAnalysisMgr.DocumentFlag`) (R2023b)

| Property | Access | Description |
|---|---|---|
| `Type` | Read-only | `'error'` \| `'warning'` \| `'check'` |
| `Description` | Read-only | Flag description text |
| `Tag` | Read-only | Programmatic identifier |
| `FlaggedObject` | Read-only | The element that owns this flag |

```matlab
clear(flag)                           % remove this flag
```

## Change Detection (R2024b)

Tracks changes to any artifacts linked via requirement links (requirements, faults, model elements, tests, etc.) since the last accepted baseline.

**Prerequisites:**
- **Requirements Toolbox** must be installed
- The document must be part of an open **MATLAB project** (`openProject(...)`) with files added to the project
- The project folder must be on the MATLAB search path
- The document must have existing requirement links (`slreq.Link`) to artifacts

**Workflow:**
1. Open the MATLAB project containing the document
2. Open the SAM document (`safetyAnalysisMgr.openDocument`)
3. After linked artifacts change (e.g., fault properties modified, requirements updated), call `detectChanges`
4. Retrieve and review changes with `getChanges`
5. Accept changes individually (`accept`) or in bulk (`acceptAllChanges`) — this resets the baseline

```matlab
detectChanges(doc)                     % Scan for changes to linked artifacts
changes = getChanges(doc)              % Get all detected changes (document-level)
changes = getChanges(element)          % Get detected changes for a specific row/cell
acceptAllChanges(doc)                  % Accept all changes, reset baseline (document-level)
acceptAllChanges(element)              % Accept changes on a specific element
accept(change)                         % Accept a single detected change
navigate(change)                       % Navigate to the changed artifact in its editor
```

### ChangeInformation Class (`safetyAnalysisMgr.ChangeInformation`) (R2024b)

| Property | Access | Description |
|---|---|---|
| `AffectedElement` | Read-only | Element that has changes |
| `Type` | Read-only | `'linkCreated'` \| `'linkChanged'` \| `'linkedArtifactChanged'` \| `'linkOrLinkedArtifactRemoved'` |
| `Relation` | Read-only | `slreq.Link` or `[]` |
| `ChangedArtifact` | Read-only | The artifact that changed (link or requirement struct) |

```matlab
accept(change)                        % Accept detected change in Safety Analysis Manager document (not available for 'linkCreated' type — use acceptAllChanges instead)
navigate(change)                      % Navigate to changed artifact from detected change in Safety Analysis Manager document
```

## Links (R2023b)

```matlab
linksStruct = getLinks(element)       % Get links associated with any linkable element (spreadsheet row/cell, tree event/gate, or failure model)
```

Returns a struct with two fields:
- `.inLinks` — incoming `slreq.Link` objects
- `.outLinks` — outgoing `slreq.Link` objects

### Creating Traceability Links

Link document elements to other artifacts using `slreq.createLink` (requires Requirements Toolbox):

```matlab
% Link a row/cell/node to a fault object (preferred for fault traceability)
fault = Simulink.fault.findFaults('ModelName', Name='SensorStuck');
link = slreq.createLink(element, fault);

% Link a row/cell/node to a Simulink block
link = slreq.createLink(element, 'ModelName/SubsystemName/BlockName');

% Link a row/cell/node to a test case
link = slreq.createLink(element, testCaseObj);

% Verify links
linksStruct = element.getLinks();  % returns struct with .inLinks and .outLinks
numOut = numel(linksStruct.outLinks);
```

**Supported link destinations:** Anything supported by Requirements Toolbox:
- Fault objects (`Simulink.fault.Fault`) — use for fault traceability instead of block paths
- Simulink blocks (path string or handle)
- Requirements (`slreq.Requirement` object)
- Simulink Test test cases (`sltest.testmanager.TestCase`)

**Important:**
- The document must be saved to disk before links can be created — `slreq.createLink` does not work on unsaved documents
- Do NOT use `element.addLink()` — this method does not exist
- Links are bidirectional and visible from both endpoints
- Save the document after creating links

## Navigation (R2023b)

```matlab
navigate(element)                     % highlight element in Safety Analysis Manager GUI
```

----

Copyright 2026 The MathWorks, Inc.

----
