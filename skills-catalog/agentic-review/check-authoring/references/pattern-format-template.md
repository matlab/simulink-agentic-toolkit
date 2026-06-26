# FormatTemplate Pattern (Custom Report Formatting)

## Overview
`ModelAdvisor.FormatTemplate` provides custom formatting for check results. It is an **optional enhancement** on top of the standard check pattern — use when you need tables with custom columns, grouped subchecks, or reference links.

## When to Use
- User asks for "custom report", "table output", or "custom columns"
- Results need structured tables (block name + property + expected vs actual)
- Multiple subchecks should be visually grouped

## FormatTemplate vs ResultDetail

- **FormatTemplate** → populates report HTML. Callback **returns** a cell array of FormatTemplate objects.
- **ResultDetail** → populates structured result data. Use `CheckObj.setResultDetails()`.
- **To get both**: return FormatTemplate AND call `setResultDetails()` in the same callback.
- `setResultDetails` only accepts `ModelAdvisor.ResultDetail`, NOT FormatTemplate.

## Template Types

| Type | Use For |
|------|---------|
| `ModelAdvisor.FormatTemplate('TableTemplate')` | Structured data in rows and columns |
| `ModelAdvisor.FormatTemplate('ListTemplate')` | Hyperlinked lists of model objects |

## Methods Reference

| Method | Purpose |
|--------|---------|
| `setCheckText(ft, 'text')` | Description of what the check does |
| `setSubTitle(ft, 'title')` | Title for a subcheck section |
| `setInformation(ft, 'text')` | Info below the subtitle |
| `setSubResultStatus(ft, 'Pass'/'Warn')` | Status indicator |
| `setSubResultStatusText(ft, 'text')` | Text below status |
| `setRecAction(ft, {'action'})` | Recommended action (cell array) |
| `setRefLink(ft, {{'Standard 1'}})` | See Also links |
| `setSubBar(ft, true/false)` | Separator line between subchecks |
| `setTableTitle(ft, 'title')` | Title above table |
| `setColTitles(ft, {'Col1', 'Col2'})` | Column headers |
| `addRow(ft, {val1, val2})` | Add a row |
| `setListObj(ft, blockList)` | Add list of hyperlinked objects |

## Template: TableTemplate

```matlab
function ResultDescription = <CheckName>Callback(system, CheckObj)
ResultDescription = {};

ft = ModelAdvisor.FormatTemplate('TableTemplate');
setCheckText(ft, '<Description>');
setSubTitle(ft, '<Section title>');
setColTitles(ft, {'<Column 1>', '<Column 2>', '<Column 3>'});

%% --- CHECK LOGIC ---
% violations = find_system(system, ...);
%% --- CHECK LOGIC END ---

if isempty(violations)
    setSubResultStatus(ft, 'Pass');
    setSubResultStatusText(ft, '<All-clear message>');
else
    setSubResultStatus(ft, 'Warn');
    setSubResultStatusText(ft, '<Violation summary>');
    setRecAction(ft, {'<Recommended action>'});
    for i = 1:numel(violations)
        addRow(ft, {'<val1>', '<val2>', '<val3>'});
    end
end
ResultDescription{end+1} = ft;

%% Also populate ResultDetail for structured data
if isempty(violations)
    ElementResults = ModelAdvisor.ResultDetail;
    ElementResults.ViolationType = 'Passed';
    ElementResults.Status = '<All-clear>';
else
    for i = 1:numel(violations)
        ElementResults(1, i) = ModelAdvisor.ResultDetail;
        ModelAdvisor.ResultDetail.setData(ElementResults(i), 'SID', violations{i});
        ElementResults(i).Status = '<Violation>';
        ElementResults(i).RecAction = '<Action>';
    end
end
CheckObj.setResultDetails(ElementResults);
end
```

## Template: ListTemplate

```matlab
ft = ModelAdvisor.FormatTemplate('ListTemplate');
setSubTitle(ft, '<Section title>');
if isempty(violationBlks)
    setSubResultStatus(ft, 'Pass');
else
    setSubResultStatus(ft, 'Warn');
    setListObj(ft, violationBlks);
end
ResultDescription{end+1} = ft;
```

## Multiple Subchecks

Combine multiple FormatTemplate objects in one callback:
```matlab
function ResultDescription = <CheckName>Callback(system, CheckObj)
ResultDescription = {};

%% Subcheck 1: Table
ft1 = ModelAdvisor.FormatTemplate('TableTemplate');
setSubTitle(ft1, '<First subcheck>');
% ... populate ...
ResultDescription{end+1} = ft1;

%% Subcheck 2: List
ft2 = ModelAdvisor.FormatTemplate('ListTemplate');
setSubTitle(ft2, '<Second subcheck>');
setSubBar(ft2, false);
% ... populate ...
ResultDescription{end+1} = ft2;

%% Populate ResultDetail separately
CheckObj.setResultDetails(ElementResults);
end
```
