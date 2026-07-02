# Generating the Conversion Report

After `convertToSingle` returns, summarize the result for the user in plain language including the APIs usage. Do not just dump the raw report object — agents that print the struct verbatim are not useful. Generate a human-readable report based on what the tool actually did. Include the exact API call used (e.g., `report = DataTypeWorkflow.Single.convertToSingle('modelName')`) at the top of the report for traceability.

If the model has already been converted to single precision and saved, re-running the conversion will report identical before and after memory values. To obtain a meaningful memory comparison on a subsequent run, close the model **without saving**, reopen it to restore the original double-precision baseline, and then re-run the conversion.

## Required Output Sections

1. **Outcome** — Did the conversion succeed? (`CheckInfo.ready` was true and `ConvertInfo.err` is empty.)
2. **What was converted** — From `ConvertInfo.results`: the blocks/signals whose data type was changed from `double` to `single`. List all blocks by full block path;
3. **What was changed automatically** — From `CheckInfo`, summarize any side effects the tool applied:
   - `TLSSettings` → "Target Language Standard updated to C99 on N model(s)."
   - `DTOSettings` → "Data Type Override reset to UseLocalSettings on N system(s)."
   - `SolverSettings` → "Variable-step solver replaced with fixed-step on N model(s)."
   - `configSettings` → "Configuration parameters updated (e.g., GenerateComments, ParameterPrecisionLossMsg)."
4. **Items that need manual attention** — Anything in `IncompatibleBlks`, `UnsupportedBlks`, `DTLockedDblBlks`, or `VerifyInfo.StowawayDblBlks`. For each, give the block path and one-line cause (e.g., "MATLAB Function Block uses global variable").
5. **Memory impact** — If `CheckInfo.memoryUse.BeforeValue` and `VerifyInfo.memoryUse.AfterValue` is populated, report before/after bytes and the percentage reduction. The field is a **table** (not a scalar). Each row is one converted parameter; Compute the model-wide totals with `before = sum(report.CheckInfo.memoryUse.BeforeValue.RuntimeMemory); after = sum(report.VerifyInfo.memoryUse.AfterValue.RuntimeMemory);`.

## Empty-Report Fallback

If `ConvertInfo.results` is **empty** but the conversion succeeded (`err` empty, `ready` true), the model was **already single** or had no convertible doubles. In that case, do NOT report "nothing happened." Instead, report on what the tool changed in the model configuration:

- Walk `CheckInfo.TLSSettings`, `CheckInfo.DTOSettings`, `CheckInfo.SolverSettings`, `CheckInfo.configSettings` and list each model/setting that was modified.
- If all of those are also empty, report: "The model was already configured for single precision and required no changes."

## Reporting Convention

- Use full Simulink block paths (e.g., `myModel/Controller/Gain`), not just block names.
- Quote error identifiers verbatim when reporting failures (e.g., `Coder:FXPCONV:F2FGLOBALINMLFB_DTS`) so the user can search docs.
- Keep the report compact — group related findings rather than listing every block individually when counts are large.

## Suggest a Code Generation Readiness Check

Single-precision conversion is most often a step toward embedded deployment. After reporting on the conversion, check whether **Embedded Coder** is installed; if so, recommend running the Model Advisor's code-generation readiness checks on the converted model.

**Detect Embedded Coder** before suggesting the check — do not recommend it unconditionally:

```matlab
if license('test', 'RTW_Embedded_Coder')
    % Open Model Advisor for an interactive readiness review:
    modeladvisor('myModel');
    %
    % Or run the Embedded Coder check group programmatically:
    % ModelAdvisor.run({'myModel'}, 'Configuration', 'configFile.json');
end
```

Use the **"Embedded Coder"** check group in Model Advisor (under By Task → Modeling Standards for MAB / Embedded Coder). It surfaces configuration issues that would block or degrade code generation — solver mode, hardware target settings, code interface, optimization options — which are independent of the data-type conversion and are common follow-up tasks after a single-precision conversion.

If Embedded Coder is not installed, mention the readiness check as an optional follow-up the user could run if they have the toolbox, and do NOT emit code that would fail with a license error.

----

Copyright 2026 The MathWorks, Inc.

----

