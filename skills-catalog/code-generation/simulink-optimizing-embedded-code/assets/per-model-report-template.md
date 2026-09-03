# Per-Model Optimization Report — Template & Field Mapping

> **When to use:** Phase 5 (finalizing-results) wrap-up, after all metrics have been verified and the final wrap-up message is being prepared. The agent generates one HTML report per model run.

> **Why HTML:** A self-contained file (inline CSS, no external assets) that the customer opens in any browser by double-clicking. Portable, emailable, archivable.

---

## Output location

Save the rendered report to:

```
<project_path>/.eco_diagnostics/<MODEL_NAME>_optimization_report.html
```

`<project_path>` is the value carried in the state object. `<MODEL_NAME>` is the value of `state.MODEL`. The `.eco_diagnostics/` folder is already created earlier in the run for the diagnostic logs — reuse it.

After saving, the agent's wrap-up message MUST tell the user the absolute path and how to open it:

> *"I've generated your optimization report at `<absolute_path>`. Open it in any web browser (Chrome / Edge / Firefox) by double-clicking the file — it's self-contained, no server needed."*

---

## Template

The HTML skeleton is in `assets/per-model-report-template.html`. Read it once, copy it into memory, then replace every `{{PLACEHOLDER}}` with the values sourced as below. Write the resulting string to the output path.

A practical recipe in MATLAB:

```matlab
tplPath = fullfile('<skill_root>', 'assets', 'per-model-report-template.html');
tpl     = fileread(tplPath);
out     = tpl;
out = strrep(out, '{{MODEL_NAME}}',         modelName);
out = strrep(out, '{{MODEL_FILE}}',         [modelName '.slx']);
% ... (every placeholder) ...
outPath = fullfile(projectPath, '.eco_diagnostics', [modelName '_optimization_report.html']);
fid = fopen(outPath, 'w'); fwrite(fid, out); fclose(fid);
```

The agent platform may also use its native file-write tool — the template + replace pattern is platform-agnostic.

---

## Field-mapping table

For every placeholder in the template, this table gives the source and the format. Sources:

- **state** — values read from `<project_path>/.eco_diagnostics/state.json` at Phase 5 entry (e.g., `state.MODEL`, `state.GOAL`, `state.versionMap`).
- **diag/report** — `<project_path>/.eco_diagnostics/eco_optimization_report.md` (token usage entries).
- **diag/trace** — `<project_path>/.eco_diagnostics/eco_decision_trace.md` (decisions, suggestions, risk checks).
- **artifacts** — anything saved during the run (sim-vs-SIL `.mat`, profiling reports). Versioned model snapshots live in the workspace `.git` repo. The sim-vs-SIL `.mat` is produced by `finalizing-results` **step 5** — it captures golden reference (normal sim or SIL/PIL from Phase 2) vs `SIL(vN_model)` (the live workspace) and is the source of every `{{VERIFY_*}}` placeholder. Step 5 is mandatory for ALL modes (including codegen). If golden reference is missing (`state.GOLDEN_REF_PATH` empty), render a "Not run" card instead of omitting the section.
- **derived** — computed by the agent in Phase 5 from the above.

| Placeholder                  | Source        | Notes / format                                                                                                                                |
|------------------------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| `{{MODEL_NAME}}`             | state         | `state.MODEL`                                                                                                                                  |
| `{{MODEL_FILE}}`             | derived       | `<MODEL_NAME>.slx`                                                                                                                             |
| `{{HW_TARGET}}`              | state         | `state.HARDWARE` (e.g., "Texas Instruments → C2000", "Intel x86-64 (Windows64)")                                                                |
| `{{VERIFICATION_MODE}}`      | state         | `state.VERIFICATION_MODE` (codegen / SIL / PIL)                                                                                                 |
| `{{GOAL}}`                   | state         | `state.GOAL` (speed / memory / both / custom axes)                                                                                              |
| `{{RUN_DATE}}`               | derived       | Today's date in `YYYY-MM-DD`                                                                                                                   |
| `{{HEADLINE_CARDS}}`         | derived       | One `<div class="card …">` per goal-axis Δ + one for the verdict. Use `green` for improvement, `red` for regression, `yellow` for mixed/borderline, `gray` for "no change". See "Headline cards format" below. |
| `{{METRIC1_LABEL}}` / `{{METRIC2_LABEL}}` | derived | The two most relevant metric column headers. For `GOAL=speed`: `Exec (ns)`, `RAM (B)`. For `GOAL=memory`: `RAM (B)`, `Stack (B)`. For `GOAL=both`/multi-axis: pick the two top axes. |
| `{{ITERATION_ROWS}}`         | state + diag/trace | One `<tr>` per entry in `state.versionMap` (including FAIL reverted ones). Columns: iter index, **display version tag** (in `<code>`, per the **Version-tag display convention** below — NOT the internal state tag), customer-friendly description of the change (no internal stage A/B/C/D nomenclature; phrase it in user terms — e.g., "convert datatypes to single precision", "absorb sum into chart body", "force-inline chart"), the two metric values (use `class="num delta-neg"` if improved vs prior, `class="num delta-pos"` if regressed, plain `class="num"` if flat or baseline), notes. **The per-iteration row description MUST include the original suggestion summary that used to live in the standalone "High-level Suggestions per Stage" section (this section has been removed — its content is folded inline here so the customer sees suggestion + outcome together).** The `commitSHA` from each entry can be included in the notes column for traceability back to the workspace git repo. Stage-level taxonomy (A/B/C/D + sub-skills) belongs in `eco_decision_trace.md` only — it is internal workflow detail and MUST NOT appear in the customer report. |
| `{{ITERATION_FOOTNOTE}}`     | derived       | "N iterations across M phases." Add a sentence on errors recovered if any (pull from diag/trace **Unexpected Events**). |
| `{{TOKEN_CARDS}}`            | diag/report   | One `<div class="card …">` per "## Phase: N" heading in `eco_optimization_report.md`, plus a leading `accent` card for the estimated total. Pull the "Estimated total" from each phase block. |
| `{{VERIFY_CLASS}}`           | artifacts     | Section CSS class controlling the colour of the verification panel. PASS → `verify-pass`, PASS (warn) → `verify-warn`, FAIL → `verify-fail`. The verification section is ALWAYS rendered — all modes (codegen, SIL, PIL) produce a `state.VERIFY` result via the Phase 5 final check. If `state.VERIFY` is empty (golden reference missing), render a "Not run" card with `verify-warn` class. |
| `{{VERIFY_VERDICT}}`         | artifacts     | "PASS", "PASS (warn)", or "FAIL"                                                                                                                |
| `{{VERIFY_VERDICT_COLOR}}`   | derived       | `green` / `yellow` / `red` to match the verdict                                                                                                |
| `{{VERIFY_VERDICT_SUB}}`     | artifacts     | Short qualifier (e.g., "within numerical-rounding tolerance", "exact match", "deviation exceeds tolerance")                                     |
| `{{VERIFY_MAX_ERR}}`         | artifacts     | Max absolute error value, scientific notation (e.g., `7.28e-12`, `0`)                                                                          |
| `{{VERIFY_MAX_ERR_SUB}}`     | artifacts     | Short qualifier (signal name, units)                                                                                                           |
| `{{VERIFY_NARRATIVE}}`       | artifacts     | 2–4 sentence plain-language explanation of *why* the result is acceptable / suspect. Reference any algorithmic rewrites (e.g., `inv()` → `mldivide`) that explain sub-ulp drift. |
| `{{VERIFY_ARTIFACTS}}`       | artifacts     | Relative path to the comparison `.mat` (e.g., `bench_results/<MODEL>_artifacts/sim_vs_sil_comparison.mat`)                                      |
| `{{GIT_REPO_PATH}}`          | derived       | `<project_path>/.git` — the workspace git repo. Pure display string for traceability; all versions are reachable via tags. |
| `{{TREE_PREAMBLE_NOTE}}`     | derived       | One-sentence note about the tree shape that distinguishes both revert kinds. Examples: *"This run produced no rejects or reverts, so the tree is a single chain."*, *"This run had 2 Gate-Rejected candidates that ablated into v(N+1)a/b."*, *"This run had 1 User-Requested Revert (v3 → restored to v1) — alternate routes continue from v1."* Pulled from the counts of `revertCause == "Gate_Rejected"` and `revertCause == "User_Requested_Revert"` entries in `state.versionMap`. |
| `{{EVOLUTION_TREE_NODES}}`   | state + diag/trace | The full tree body. Built by walking `state.versionMap` and grouping entries by `parentVersion`. Each parent with one child emits a `<div class="tree-level">` + connector; each parent with multiple children emits a single `<div class="tree-children-row">` containing one `<div class="tree-child">` column per child (placed side by side). `Gate_Rejected` and `User_Requested_Revert` entries are always leaves; each `User_Requested_Revert` leaf additionally emits a back-pointer anchor to its `revertTargetVersion` node. See "Evolution tree node format" below for the per-node, per-edge, and per-child HTML patterns. |
| `{{NUM_PHASES}}`             | diag/report   | Count of `## Phase:` headings                                                                                                                  |
| `{{NUM_TRANSITIONS}}`        | derived       | `NUM_PHASES - 1`                                                                                                                               |
| `{{NUM_ERRORS}}`             | diag/trace    | Count of entries in **Unexpected Events** sections (build failures, retries, dropped params, etc.) summed across all phases                     |

---

### Agent-filled placeholders

These placeholders have **auto-generated defaults** produced by `renderOptimizationReport.m` from the state object and diagnostic files. However, the **agent SHOULD pre-populate** these fields in `state.REPORT.*` before calling `renderOptimizationReport` to produce a richer, more contextual customer report. The agent has access to the full run history and can synthesize better narratives than the mechanical defaults.

| Placeholder                  | Source        | Agent override field                 | Notes / format |
|------------------------------|---------------|--------------------------------------|----------------|
| `{{OPTIMIZATION_SUMMARY}}`   | agent-filled  | `state.REPORT.summary`               | 2-4 paragraph narrative summarising what was accomplished, the primary bottleneck, approach taken, and outcome. Wrap in `<p>` tags. The script auto-generates from version counts + goal-axis delta if not supplied. |
| `{{SCOPE_CARDS}}`            | agent-filled  | `state.REPORT.scopeCards`            | Grid of `<div class="scope-item">` cards showing: target functions, stages covered, model fingerprint, tradeoffs allowed, deferred levers. Auto-generated from `state.TARGET_FUNCTIONS`, `state.STAGE_SCOPE`, `state.DEFERRED_LEVERS`, `state.TRADEOFFS`, `state.MODEL_FINGERPRINT`. |
| `{{RECOMMENDATIONS}}`        | agent-filled  | `state.REPORT.recommendations`       | `<li class="reco-high|reco-med|reco-low">` items. Agent supplies a cell array of structs: `{struct('text','...','priority','high'), ...}`. Auto-generated from `state.DEFERRED_LEVERS` + "Noted"/"Manual"/"Further" entries in `eco_decision_trace.md`. |
| `{{PREFERENCES_SECTION}}`    | agent-filled  | `state.REPORT.preferencesNote`       | Entire `<section>` block. Omitted (empty string) if no `.custom_optimizations/optimization_preferences.yaml` existed and `state.PREFERENCES_APPLIED` is not set. When present, shows how many `never`/`skip`/custom rules fired. |

**How the agent populates these (Phase 5 procedure):**

Before calling `renderOptimizationReport(state, projectPath, skillRoot)`, the agent SHOULD:

1. Set `state.REPORT.summary` to a hand-crafted narrative based on the full optimization run. Focus on: what the model does, what was slowing it down, what technique(s) helped most, and the final outcome. Keep it customer-readable (no internal IDs, no stage taxonomy).

2. Set `state.REPORT.recommendations` to a cell array listing any further manual optimizations identified during the run. Priority levels:
   - `'high'` — significant expected gain, clear instructions, low risk
   - `'med'` — moderate gain or requires domain expertise
   - `'low'` — noted during analysis but uncertain benefit

3. Optionally set `state.REPORT.preferencesNote` if custom logic was applied (e.g., "Your `never` rule blocked 2 candidates targeting lookup-table merges; 1 custom optimization from `my_custom_opt.m` was evaluated and accepted.").

4. `state.REPORT.scopeCards` is rarely needed as an override — the auto-generated version reads all relevant state fields. Override only if the agent wants to add cards not derivable from standard state fields (e.g., "PIL board: STM32F4 Discovery").

If the agent does NOT set these fields, `renderOptimizationReport` produces mechanical but correct defaults — the report is still valid.

---

### Encoding rules (MANDATORY for every customer-facing render)

The customer-facing HTML report MUST be **pure ASCII on disk** (every byte `<= 0x7F`). This eliminates the entire class of mojibake bugs that arises when scripts read/write the template with mismatched encodings (Windows PowerShell 5.1 defaults to cp1252 for `Get-Content`/`Set-Content` unless `-Encoding utf8` is passed; even then it may emit a BOM that some downstream tools mishandle).

**The template (`per-model-report-template.html`) is itself maintained as pure ASCII** &mdash; any unicode character that would normally appear in prose (arrows, em-dashes, undo-arrows, middle-dots, etc.) is encoded as an HTML entity. The canonical entities in use:

| Visible glyph | HTML entity   | Codepoint |
|---------------|---------------|-----------|
| `&mdash;` (em-dash)        | `&mdash;`     | U+2014    |
| `&rarr;` (right arrow)      | `&rarr;`      | U+2192    |
| `&#x21B6;` (undo arrow)     | `&#x21B6;`    | U+21B6    |
| `&middot;` (middle dot)     | `&middot;`    | U+00B7    |

The renderer MUST also keep every `{{PLACEHOLDER}}` replacement value pure-ASCII (use the same HTML entities in prose strings, narratives, and tree-change descriptions).

**Recommended PowerShell read / write incantation** (avoids the cp1252 fallback and avoids emitting a BOM that older browsers occasionally choke on):

```powershell
# Read template
$tpl = [System.IO.File]::ReadAllText($tplPath, [System.Text.Encoding]::UTF8)
# ...substitute placeholders...
# Write rendered report as UTF-8 with NO BOM
[System.IO.File]::WriteAllText($outPath, $out, [System.Text.UTF8Encoding]::new($false))
```

**Render-time sanity check (RECOMMENDED, NOT optional):**

```powershell
$bytes = [System.IO.File]::ReadAllBytes($outPath)
$nonAscii = ($bytes | Where-Object { $_ -gt 127 } | Measure-Object).Count
if ($nonAscii -ne 0) { throw "Rendered report has $nonAscii non-ASCII bytes; pure-ASCII rule violated." }
```

### Version-tag display convention (MANDATORY for every customer-facing render)

The internal state-tag strings (`v0_pristine`, `v1_baseline`, `v2_rejected_stageB_single`, `v3_rejected_stageC_c1`, etc.) are an orchestrator contract — they live in `state.json` and the workspace git repo and MUST NOT be changed under the agent's authority. The customer-facing report (HTML iteration table + evolution-tree node `vtag` labels) uses display labels derived from those tags by the following rules:

| Internal state tag pattern                          | Display label                                                                                                 |
|-----------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| `v0_pristine`                                       | `v0_original`                                                                                                  |
| `v1_baseline`, `v1_baseline_*`                      | `v1_baseline`                                                                                                  |
| `vN_<accepted-optimization-tag>` (any accepted v≥2) | `vN_<short_optimization_phrase>` — short, customer-readable (e.g. `v2_inline_chart`, `v3_single_precision`). NO stage prefix (`stageA_` / `stageB_` etc.) and NO sub-skill suffix. |
| `vN_rejected_*`                                     | `vN_<short_optimization_phrase>` — the same short phrase the accepted version would have used, with NO `_rejected` suffix in the display tag. The Gate-Rejected status is conveyed by the red node border + the `Gate Rejected` badge in the head, not by the label. |
| `vN_baseline_retrofit`                              | `vN_baseline_retrofit` (kept verbatim — it's already customer-readable) |

**Why:** the customer cares about *what was tried*, not the internal stage taxonomy or the rejected/accepted suffix (which is already conveyed by node colour and the status badge). Showing `v3_rejected_stageC_c1` in a tree node is jargon; showing `v3_absorb_add_into_chart` with a red border + `Gate Rejected` badge tells the same story in user language.

**Stage and sub-skill information is allowed ONLY inside the per-node hover details body** (`.tree-details > .tree-change`). Phrase it as background context, not as the primary label. Example: *"Tried as part of the Stage C sub-skill functions/matlab-function-reauthor."*

### Headline cards format

For each axis the user listed in `state.GOAL` (and a couple of common side metrics like cyclomatic complexity, data copies, stack — only if they changed materially), emit one card:

```html
<div class="card green"><div class="label">Δ Total Exec</div><div class="value">−44.3 %</div><div class="sub">2,474,300 → 1,378,300 ns</div></div>
```

Colour rules:
- `green` — improvement beyond noise floor on a goal axis, OR improvement on a non-goal axis
- `red` — regression beyond noise floor (only possible on non-goal axes after the Goal-Axis Acceptance Gate; goal-axis regressions cause revert before this report is written)
- `yellow` — within noise floor but flagged for the customer's attention (e.g., a stub that recommended further manual work)
- `gray` — no measurable change
- `accent` — for the final "Verdict" card

Always include a final "Verdict" card summarising the run in one of: **Improvement**, **Mixed**, **Baseline retained** (for runs where no change passed the gate), or **Regression** (only if the user accepted a non-goal-axis trade).

### Suggestion row format — **DEPRECATED / FOLDED INTO ITERATION ROWS**

> **Status:** The standalone "High-level Suggestions per Stage" section has been removed from the customer-facing template. Its content is now folded into the **Iteration row** description cell (`{{ITERATION_ROWS}}`), phrased in customer-facing language with no internal stage A/B/C/D taxonomy. Stage / sub-skill information appears ONLY in `eco_decision_trace.md` and may be referenced inside the per-node hover details body in the evolution tree (`.tree-details > .tree-change`) for forensic context — never as a primary label.
>
> The legacy stage-per-row format below is retained for backwards reference only (some older runs produced reports against the previous template). Do NOT emit it in new reports.

**Legacy rule (no longer enforced):** Mirror the structure used in `models_dashboard.html`. Each stage gets exactly one top-level `<tr class="suggestion-row">`. If the stage has sub-skills (currently only **Stage C — modeling-design-patterns**), the description cell MUST contain a nested borderless table with one row per sub-skill, plus a final row for cross-cutting / block-level suggestions that don't belong to any one sub-skill.

**Simple stages (A, B, D — no sub-skills):**

```html
<tr class="suggestion-row">
  <td><span class="stage-tag-A">A · configset</span></td>
  <td>2–3 line summary of what was suggested, with <code>parameter</code> and <code>block names</code> in code tags.</td>
  <td class="center num">9</td>
  <td class="center"><span class="b green">applied</span></td>
</tr>
```

**Stage C (structural changes) — nested sub-skill breakdown, REQUIRED format:**

The description cell uses a borderless inner table. Emit **one row per sub-skill** (in the order below), even if the sub-skill produced no suggestions — in that case write a one-line "Not exercised — &lt;reason&gt;" entry. Then emit a final mandatory `general (block-level)` row for any cross-cutting / noted-only suggestions that don't map to a single sub-skill (e.g., "5 lookup tables switched Linear → Binary search", "comment out Scope + CallbackButton", "5 ManualSwitch blocks noted for deferred removal").

Sub-skills (current set, in order):
1. `subsystems/atomic-inline`
2. `subsystems/clone-detection-reuse`
3. `subsystems/variant-transform`
4. `subsystems/referenced-model-memory`
5. `signals/storage-class`
6. `signals/buffer-reuse`
7. `signals/mux-selector-to-multiport`
8. `functions/matlab-function-reauthor`
9. `functions/matlab-function-buffer-reuse`
10. `lookup-tables/shared-prelookup`
11. `lookup-tables/merge-interpolation`
12. `data-stores/eliminate-local`

Followed by:
13. `general (block-level)` — REQUIRED row, even if it just says "None — all suggestions tied to a sub-skill above."

Pattern:

```html
<tr class="suggestion-row">
  <td>
    <span class="stage-tag-C">C · structural</span><br>
    <span style="font-weight:400;font-size:10px;color:var(--text2)">12 sub-skills</span>
  </td>
  <td>
    <table style="margin:0;border:none">
      <tr>
        <td style="width:170px;border:none;padding:4px 8px 4px 0"><code>matlab-function-reauthor</code></td>
        <td style="border:none;padding:4px 0">Not exercised — no user-authored MATLAB Function blocks.</td>
      </tr>
      <tr>
        <td style="border:none;padding:4px 8px 4px 0"><code>atomic-inline</code></td>
        <td style="border:none;padding:4px 0">&lt;summary or "Not exercised — &lt;reason&gt;"&gt;</td>
      </tr>
      <tr>
        <td style="border:none;padding:4px 8px 4px 0"><code>storage-class</code></td>
        <td style="border:none;padding:4px 0">&lt;summary or "Not exercised — &lt;reason&gt;"&gt;</td>
      </tr>
      <tr>
        <td style="border:none;padding:4px 8px 4px 0"><code>buffer-reuse</code></td>
        <td style="border:none;padding:4px 0">&lt;summary or "Not exercised — &lt;reason&gt;"&gt;</td>
      </tr>
      <tr>
        <td style="border:none;padding:4px 8px 4px 0"><i>general (block-level)</i></td>
        <td style="border:none;padding:4px 0">&lt;cross-cutting suggestions not tied to any one sub-skill; if none, write "None — all suggestions tied to a sub-skill above."&gt;</td>
      </tr>
    </table>
  </td>
  <td class="center num">&lt;total count across all rows&gt;</td>
  <td class="center"><span class="b green">N applied · M noted</span></td>
</tr>
```

**Why this is mandatory:** the customer-facing report must make sub-skill coverage auditable at a glance — the reader can see which sub-skills fired, which were skipped (and why), and what general/cross-cutting suggestions exist outside the sub-skill taxonomy. Collapsing Stage C into a single summary line (as Stages A/B/D do) hides this and breaks parity with `models_dashboard.html`.

### Evolution tree node format

`{{EVOLUTION_TREE_NODES}}` is the body of the Evolution Tree section's `<div class="tree">…</div>` wrapper. The tree is built by walking `state.versionMap` and grouping entries by `parentVersion` (see the **Tree hierarchy rule** below for the full algorithm). A parent with exactly one child emits a `<div class="tree-level">` containing that child plus a connector to it; a parent with multiple children emits a `<div class="tree-children-row">` containing one `<div class="tree-child">` column per child, placed side-by-side. Every node header carries a `<span class="hint">hover for details</span>` and the node uses `tabindex="0"` so keyboard users can focus-to-expand.

**Node classes — pick one per node based on `versionMap[i]`:**

| Source predicate                                              | Node class                          | Status badge in head                            |
|---------------------------------------------------------------|-------------------------------------|-------------------------------------------------|
| `version == "v0"` (Auto-Detection Step 0d entry — internally tagged `v0_pristine`) | `original`                          | `<span class="b gray">original</span>` (display label; the internal state-tag string `v0_pristine` is preserved in `state.json` and the workspace git repo as a stable orchestrator contract, but every customer-facing render maps it to `original`) |
| First post-config-normalisation entry (e.g. `v1_baseline`)    | `baseline`                          | `<span class="b accent">baseline</span>`        |
| `status` starts with `"OK ACCEPT"`                            | `accept`                            | **(no status badge — green border conveys acceptance; stage badge may still appear if relevant)** |
| `revertCause == "Gate_Rejected"`                              | `reject reject-branch reject-gate`  | `<span class="b red">Gate Rejected</span>`      |
| `revertCause == "User_Requested_Revert"`                      | `revert revert-user`                | `<span class="b yellow">User Revert → v{N}</span>` (N = `revertTargetVersion`) |

Append a `<span class="b accent">LATEST</span>` badge to the head of the node that corresponds to the live workspace pointer. **After a `User_Requested_Revert`, `LATEST` belongs on the *restored* node (the one identified by `revertTargetVersion`), NOT on the revert leaf and NOT on the abandoned version.**

Every `<div class="tree-node …">` MUST carry `id="node-<VERSION>"` (e.g. `id="node-v3"`) so the back-pointer anchor described below resolves.

**Per-node template (accepted/baseline/original — main spine):**

For `accept`-class nodes, `<STATUS_BADGES>` is empty (the green border conveys acceptance — no `ACCEPT` text badge). The `<span class="b accent">LATEST</span>` badge appears only on whichever node is the live workspace pointer.

```html
<div class="tree-level">
  <div class="tree-node <CLASS>" id="node-<VERSION>" tabindex="0">
    <div class="tree-node-head">
      <span class="vtag"><VERSION_TAG></span>
      <STATUS_BADGES>
      <span class="eid">commitSHA <SHORT_SHA></span>
      <span class="hint">hover for details</span>
    </div>
    <div class="tree-details">
      <div class="tree-metrics">
        <div class="m"><span class="k">Exec (ns)</span><span class="v"><EXEC></span></div>
        <div class="m"><span class="k">RAM (B)</span><span class="v"><RAM></span></div>
        <div class="m"><span class="k">DataCopies (B)</span><span class="v"><COPIES></span></div>
        <div class="m"><span class="k">Stack (B)</span><span class="v"><STACK></span></div>
      </div>
      <div class="tree-change">
        <strong>Δ from <PARENT_TAG>:</strong> <ONE_PHRASE_CHANGE_DESCRIPTION>
      </div>
      <div class="tree-gate">
        Gate (GOAL=<GOAL>; goal-axis noise floor <N> ns):<br>
        <span class="axis">Exec <span class="<neg|flat|pos>"><±DELTA></span> <VERDICT></span>
        <!-- one .axis per metric in goal_axes + non-goal axes that moved -->
        → <span class="b green">ACCEPT</span>
      </div>
    </div>
  </div>
</div>
```

**Per-edge template (between consecutive accepted nodes):**

```html
<div class="tree-edge">
  <span class="label"><ONE_PHRASE_TRANSITION></span>
  <div class="stem"></div>
  <div class="arrow"></div>
</div>
```

Use `<div class="tree-edge baseline-edge">` (blue arrow) for the v0 → v1 transition (config normalisation, not an optimisation). All other accepted-spine edges use the default green `<div class="tree-edge">`.

**Tree hierarchy rule (replaces the old single-leaf-per-parent layout):**

The tree is built by walking `versionMap` and grouping entries by `parentVersion`. This handles the three real shapes that arise in practice: a linear accepted spine, an accepted parent with one or more `Gate_Rejected` siblings beside it after ablation, and an accepted parent with one or more `User_Requested_Revert` leaves beside it after the user rolled back.

1. **Walk and group.** Build a map `children[parentVersion] = [entry, …]`. The `v0` node has no parent and is the tree root.
2. **Single child:** if a parent has exactly one child, emit the child as a centred next level (the existing `<div class="tree-level">` + connector pattern).
3. **Multiple children:** if a parent has N children, emit a single `<div class="tree-children-row">` directly below the parent, containing N `<div class="tree-child">` columns side by side. Each column is a vertical stack of: connector → child node → (recursively) that child's own subtree.
4. **Leaf invariant (MANDATORY):** A node with `revertCause != null` is a leaf and MUST NOT be traversed for children. If any later entry's `parentVersion` points at a revert leaf, the renderer logs `WARN FR-07` and skips that subtree. The lineage after a user-revert continues from `revertTargetVersion`, not from the revert leaf — this is enforced upstream in the state writer (see `<skill_root>/references/protocols/checkpointing-revert.md` → "Recovery on Bad Apply" step 5).
5. **Connector style per child:**
   - accepted child → solid green `<div class="tree-edge">` (or `baseline-edge` for the v0→v1 transition).
   - `Gate_Rejected` child → dashed red `<div class="tree-branch-edge gate-rejected">` with `<span class="label">GATE REJECTED</span>`.
   - `User_Requested_Revert` child → solid amber `<div class="tree-branch-edge user-revert">` with `<span class="label">USER REVERT</span>`.
6. **Back-pointer (MANDATORY for `User_Requested_Revert` only):** inside the revert leaf's `<div class="tree-details">`, emit a `<div class="tree-revert-backpointer">` containing a clickable anchor that links to the restored target node:
   ```html
   <div class="tree-revert-backpointer">
     <a href="#node-<REVERT_TARGET_VERSION>">
       ↶ Workspace restored to <REVERT_TARGET_VERSION>
       (commitSHA <SHORT_TARGET_SHA>) — click to jump
     </a>
   </div>
   ```
   This is the visible connector from the revert leaf to the node it pointed back to. Because the report is a single self-contained HTML file with no JS, the connector is a same-page anchor jump — every node carries `id="node-<VERSION>"` so this resolves.

**Per-child template patterns (CURRENT — explicit tree-fork markup, MANDATORY for new renders):**

The multi-child fork uses an explicit DOM hierarchy: `.tree-trunk-down` (vertical bar from parent), `.tree-bus` (horizontal manifold across child columns), `.tree-children-flex` (flex row containing N `.tree-child` columns). Each child has a `.tree-drop` (vertical stem from bus to node), `.tree-drop-label` (pill badge with the transition phrase), and `.tree-drop-arrow` (color-matched arrowhead pointing into the node). The per-child class `kind-baseline` / `kind-accept` / `kind-rolled-back` / `kind-user-revert` selects the colour scheme for that child's drop + label + arrow.

```html
<!-- Multi-child row: parent had N>1 children -->
<div class="tree-children-row">
  <div class="tree-trunk-down"></div>
  <div class="tree-bus"></div>
  <div class="tree-children-flex">

    <!-- Accepted / baseline child (blue) -->
    <div class="tree-child kind-baseline"> <!-- or kind-accept for non-baseline accepted spine -->
      <div class="tree-drop"></div>
      <div class="tree-drop-label">measurement retrofit</div> <!-- short, lowercase transition phrase -->
      <div class="tree-drop-arrow"></div>
      <div class="tree-node baseline" id="node-<VERSION>" tabindex="0"> ...node... </div>
      <!-- recurse into this child's own subtree if any -->
    </div>

    <!-- Gate_Rejected sibling (red dashed; always a leaf) -->
    <div class="tree-child kind-rolled-back">
      <div class="tree-drop"></div>
      <div class="tree-drop-label">rolled back</div>
      <div class="tree-drop-arrow"></div>
      <div class="tree-node reject reject-branch reject-gate" id="node-<VERSION>" tabindex="0">
        <div class="tree-node-head">
          <span class="vtag"><DISPLAY_VERSION_TAG></span>  <!-- per Version-tag display convention -->
          <span class="b red">Gate Rejected</span>
          <span class="eid">commitSHA <SHORT_SHA></span>
          <span class="hint">hover for details</span>
        </div>
        <div class="tree-details">
          <!-- metrics + delta + gate; offending axis uses class="pos" (red) -->
        </div>
      </div>
    </div>

    <!-- User_Requested_Revert sibling (amber; always a leaf) -->
    <div class="tree-child kind-user-revert">
      <div class="tree-drop"></div>
      <div class="tree-drop-label">user revert</div>
      <div class="tree-drop-arrow"></div>
      <div class="tree-node revert revert-user" id="node-<VERSION>" tabindex="0">
        <div class="tree-node-head">
          <span class="vtag"><DISPLAY_VERSION_TAG></span>
          <span class="b yellow">User Revert &rarr; <REVERT_TARGET_VERSION></span>
          <span class="eid">commitSHA <SHORT_SHA></span>
          <span class="hint">hover for details</span>
        </div>
        <div class="tree-details">
          <div class="tree-revert-backpointer">
            <a href="#node-<REVERT_TARGET_VERSION>">
              &#x21B6; Workspace restored to <REVERT_TARGET_VERSION>
              (commitSHA <SHORT_TARGET_SHA>) &mdash; click to jump
            </a>
          </div>
          <!-- optional: short user rationale lifted from eco_decision_trace.md -->
        </div>
      </div>
    </div>

  </div>
</div>
```

**Why explicit DOM and not pseudo-elements:** earlier revisions used `.tree-children-row::before` + `::after` to draw the trunk + manifold. That works for visually consistent child widths but breaks when children have different widths (e.g. `.tree-node.baseline` is 560px and `.tree-node.reject-branch` is 480px) because the horizontal manifold pseudo can't align with each child's centre. The explicit `.tree-trunk-down` / `.tree-bus` / `.tree-drop` chain is deterministic regardless of child count or per-child node width.

**Legacy markup (`.tree-edge` / `.tree-branch-edge.gate-rejected` / `.tree-branch-edge.user-revert`)** is kept in the template's CSS for backwards compatibility with already-emitted reports, but MUST NOT be used in new renders. Always emit the explicit-fork markup above.

The `commitSHA` from the reverted-to commit is shown in the leaf's `eid` line on both `Gate_Rejected` and `User_Requested_Revert` nodes so the customer can ask the agent to re-load the abandoned state for inspection (all prior commits remain reachable via tags).

**Per-axis delta classification (drives the green/gray/red colouring in `.tree-gate`):**

| Δ vs parent on this axis                                | Span class for the value |
|---------------------------------------------------------|---------------------------|
| Improvement beyond noise floor                          | `neg` (green)             |
| Regression beyond noise floor                           | `pos` (red)               |
| Within noise floor (`|Δ| ≤ 2 × noise_floor`)            | `flat` (gray)             |

Format the value as `<sign><value> <units>` followed by `(<sign><percent> %)` (e.g. `<span class="neg">−2,200 ns (−4.13 %)</span>`). The minus sign is U+2212 (`−`), not the hyphen `-`, to avoid being read as a list bullet by screen readers.

**Why this is mandatory:** the tree is the customer's primary mental model for *what the run actually did*. Hiding it behind the per-iteration table or behind a paragraph of prose loses the visual narrative — accepted advance vs reverted dead-end is the single most actionable signal in the report. The collapsed-by-default node design keeps the tree compact for skim-reading while preserving full forensic detail on hover/focus.

Status badge cheatsheet:
- `<span class="b green">applied</span>` — change went in and survived the goal-axis gate
- `<span class="b green">N applied · M noted</span>` — partial application
- `<span class="b yellow">N applied · M dropped</span>` — some failed validation / were locked
- `<span class="b gray">n/a</span>` — stage had no actionable surface
- `<span class="b gray">stub</span>` — stage skill is a stub / not yet implemented
- `<span class="b red">Gate Rejected</span>` — change was applied but regressed a goal axis; auto-reverted by the Goal-Axis Gate (Scenario 3)
- `<span class="b yellow">User Revert → v{N}</span>` — user rolled the workspace back to v{N} after re-measurement (Scenario 5); the leaf carries a clickable back-pointer to v{N}

---

## Diagnostic logging

After writing the report, append to `<project_path>/.eco_diagnostics/eco_decision_trace.md`:

- `OK FR-04: Per-model report written to <absolute_path>` — on success
- `WARN FR-04: Per-model report skipped — <reason>` — only if a hard failure prevents writing (e.g., `.eco_diagnostics/` doesn't exist and cannot be created). This is a degraded outcome — surface it to the user explicitly.

---

## What NOT to put in the report

- **Raw SIL/PIL stdout, build logs, or unfiltered tool output.** Summarise; the customer doesn't need 800-line build logs in their report.
- **Internal diagnostic IDs (`GR-01`, `MM-03`, etc.).** Those belong in `eco_decision_trace.md`, not in a customer-facing artifact.
- **Token estimates beyond the Token Usage section.** Don't litter other sections with cost numbers.
- **Speculation about future improvements that weren't logged in the trace.** If a sub-skill noted a manual follow-up, surface it; otherwise, don't invent suggestions.
- **Personally identifying information about the user, file paths containing usernames not relevant to the model, etc.** Use relative paths where possible.


----

Copyright 2026 The MathWorks, Inc.

----