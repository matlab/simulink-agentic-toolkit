# API Reference — Design Error Detection functions

Both functions are in the skill's `scripts/` directory (run via `evaluate_matlab_code` with
`project_path` set to that folder).

---

## `sldv_run_defect_checker(model, ...)` — detect defects

Runs SLDV Design Error Detection: a **predefined, quick scan** for a fixed set of defect
classes (division-by-zero, integer overflow, dead logic, out-of-bounds array access). It is
fast and its findings are sound — every reported defect is real — but it is **not
exhaustive**. A clean result does **not** mean the model is error-free; it only means no
defects of the checked types were found. It does not detect requirement violations, functional
bugs, Inf/NaN, or anything outside its predefined check set. Frame a passing result to the
user as "no defects of the checked types were found," never "the model is error-free."

**Auto-detection of cached results:** before running expensive DED, the function checks
`OutputDir` for cached `*_sldvdata.mat` files. If found, it loads them instantly and returns
`ResultSource="cached"`. Pass `ForceRerun=true` to bypass the cache and re-run.

### Returns

| Field | Meaning |
|-------|---------|
| `Status` | `"pass"` (clean), `"fail"` (defects found), `"error"` |
| `Findings` | Struct array — each has `.DefectType`, `.BlockPath`, `.Status` |
| `DedResult` | Opaque struct — pass directly to `sldv_find_de_root_cause` |
| `Summary` | Human-readable one-liner |
| `ResultSource` | `"cached"` or `"fresh"` |

### Options

| Option | Default | Description |
|--------|---------|-------------|
| `Mode` | `"defectChecker"` | `"defectChecker"` (all defects) or `"deadLogic"` (dead logic only) |
| `OutputDir` | `"artifacts/sldv_rca"` | Where SLDV artifacts are saved |
| `ForceRerun` | `false` | Bypass cached `*_sldvdata.mat` and re-run DED |

---

## `sldv_find_de_root_cause(model, ...)` — root cause analysis

Given a failed DED result, produces the facts an agent needs to locate root causes: backward
slices, counterexamples, locality/blast-radius measures, and shared-root cascade annotations.
For dead-logic findings it also attaches classification context (see the Classify step in
SKILL.md).

### Returns

| Field | Meaning |
|-------|---------|
| `SliceBlocks` | All upstream blocks per finding (backward slice) — `.BlockPath`, `.SID`, `.FindingKey` |
| `Counterexample` | Input signal values that trigger each defect — `.FindingKey`, `.TimeValues`, `.DataValues` |
| `Locality` | Per unique block: `.BlockPath`, `.Locality` (blast radius), `.FindingCount` (defect coverage) |
| `Cascades` | Shared-root annotations — `.RootBlockPath`, `.AffectedFindings`, `.AffectedCount` |
| `Findings` | Original defect findings, pre-enriched for dead logic (`.ModelContext`, `.PatternCatalog`, `.Classification`) |

### Options

| Option | Default | Description |
|--------|---------|-------------|
| `DedResult` | — | Struct from `sldv_run_defect_checker` (provide this OR `DataFile`) |
| `DataFile` | — | Path to SLDV `.mat` file (alternative to `DedResult`) |
| `Findings` | `[]` | Pre-extracted findings array (skips re-load when chaining from the checker) |
| `OutputDir` | `"artifacts/sldv_rca"` | Where to save root cause analysis artifacts |

---

## Sub-functions (rarely needed)

The two functions above orchestrate the full pipeline internally — you do not normally call
these. Reach for them only for targeted investigation (e.g., re-slicing a single finding, or
computing locality without a full run).

| Function | Purpose |
|----------|---------|
| `defaultConfig` | Build config struct with name-value overrides |
| `extractFindings` | Parse SLDV objectives into finding structs |
| `buildSlice` | Upstream Model Slicer slice from a finding site |
| `isolateRootCauses` | Collect all upstream blocks from a slice |
| `computeReach` | Forward slice for locality measurement |
| `detectCascade` | Validation-based cascade detection |
