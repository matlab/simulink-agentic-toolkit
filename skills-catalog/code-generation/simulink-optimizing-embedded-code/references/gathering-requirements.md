> **Release compatibility:** MATLAB R2023a and later.

# Phase 1: Gathering Requirements

## Auto-Detection (Entry Point)

Before starting requirements gathering, initialize version control, detect the model, and capture a pristine baseline:

0. **Initialize version control.** Call `eco_init(workspacePath)` where `workspacePath` is the absolute path of the project directory containing the model.

   This initializes a `.git` repo in the workspace (if not already present), creates a `.gitignore` (with `.eco_diagnostics/`, `bench_results/`, `slprj/`, `*.mexw64`), and commits + tags the initial state as `v0_pristine`.

   On re-entry (`.git` already exists with commits), `eco_init` is idempotent — returns `'already_initialized'` with current HEAD SHA. Skip steps 0c/0d.

   Add the checkpoint scripts to MATLAB path:
   ```matlab
   addpath(fullfile('<skill_root>', 'scripts'));
   ```

1. **Detect open models.** Run in MATLAB:
   ```matlab
   openModels = find_system('type','block_diagram','BlockDiagramType','model');
   ```

2. **Branch based on results:**
   - **No models open:** Tell the user: *"No Simulink models are currently open. Please open the model you want to optimize and try again."* **Stop here.**
   - **Exactly one model open:** Announce: *"I found an open model: `<model_name>`. Starting optimization workflow."* Proceed to step 0c.
   - **Multiple models open:** Present list and ask which to optimize. Wait for response, then proceed to step 0c.

0c. **Save the model.** Run `save_system('<model>')` to capture unsaved edits.

0d. **Capture pristine baseline.** If `eco_init` returned `'ok'` (fresh init), the `v0_pristine` commit is already created. Record the returned `commitSHA` as the first `versionMap` entry in `state.json`. If `eco_init` returned `'already_initialized'`, use the existing HEAD SHA.

    This is the floor preserved for end-of-run finalization comparison. It is NOT the Phase-4 revert target (see Step 0e in Phase 2).

**Harness check:** Before proceeding to the steps below, read `<skill_root>/references/protocols/harness-detection.md` and run the detection. If the model is a harness, extract the owner model and redirect.

## Steps

1. **Identify the model.** (Already done in auto-detection above.)

2. **Understand the user's goal.** The user may say something non-technical like "make it faster" or "reduce memory". Map their intent to one or more concrete objectives:
   - Maximize execution speed ("make it faster", "reduce runtime") → **Execution Time**, **function call overhead**, **loop structure**, **data copies**, **cyclomatic complexity**
   - Minimise RAM ("reduce memory", "too much RAM") → **Global RAM**, **Local Static Vars**, **Stack Usage**, **unused globals**
   - Balance RAM/speed ("optimize", "best tradeoff") → treat as multi-objective, balance **Execution Time** vs **RAM** usage
   - MISRA C:2012 compliance ("MISRA", "coding standards", "compliant code") → **MISRA C:2012 rule violations**, **code style**, **type safety**
   - Traceability ("trace requirements", "link to requirements") → **requirements-to-code traceability**, **model-to-code mapping**, **test coverage linkage**
   - Safety precautions ("safety", "functional safety", "ISO 26262") → **defensive coding**, **error detection**, **fault handling**, **safe state transitions**

   **MANDATORY:** If the user's phrase does not clearly map to a single objective (e.g., "too big" could mean ROM or RAM; "optimize" without qualifier), you MUST ask which specific metric they want to improve. Never assume. This applies even when the user uses urgent language like "just fix it" or "don't ask questions" — those phrases express impatience but do NOT constitute informed specification of the optimization target. "Too big" is always ambiguous (ROM? RAM? both?) and requires clarification.

3. **Confirm model understanding with the user.** Before asking any further questions, query the model's basic properties (hardware, solver, sample times, top-level subsystems) and build a narrative summary covering:
   - Model name and, if recognized/shipped example, its **application domain** and typical use-case context.
   - Top-level subsystems / architecture
   - Hardware target (from `ProdHWDeviceType` / `TargetHWDeviceType`)
   - Solver type and sample times
   - Optimization goal

   Present as **natural prose** (not a table). Ask: *"Here's my understanding of the model and goal. Does this look correct?"*

   **Do NOT proceed until the user confirms this summary.**

   Once confirmed, run `model_fingerprint`:
   ```matlab
   addpath(fullfile('<skill_root>', 'scripts'));
   fingerprint = model_fingerprint('<model>');
   ```
   Store result in state as `MODEL_FINGERPRINT`.

4. **Gather hardware context.** If hardware is generic (e.g., `'Generic->32-bit x86 compatible'`), ask: *"Are you targeting a specific hardware board or MCU, or is desktop/generic fine?"*

   If the hardware IS a real MCU/board (not generic), also ask: *"Is the board currently connected?"*

   Record hardware target and board connectivity. Set `ENABLE_CRL` to `yes` when hardware is a real MCU/board (CRL replacements happen at codegen time based on configured hardware, not connection status).

5. **Determine if runtime measurements are needed.** Based on user's goal:
   - **codegen sufficient:** user only wants code analysis — CRL checks, code structure, code size/ROM, code quality. Cues: "just generate code", "check the generated code", "see if CRL is working", "I don't need timing".
   - **SIL/PIL needed:** user wants execution-time measurements, stack profiling, or runtime data. Cues: "make it faster", "reduce runtime", "measure execution time", "profile the code".

   Set `VERIFICATION_MODE` to `codegen`, `SIL`, or `PIL`. SIL vs PIL decision follows hardware/board connectivity rules from `configuring-code-profile` sub-skill.

   **GUARDRAIL GR-06 — ERT target required for SIL/PIL:**
   If `VERIFICATION_MODE` is `SIL` or `PIL`, check the model's system target file:
   ```matlab
   stf = get_param('<model>', 'SystemTargetFile');
   ```
   If the STF does NOT contain the substring `'ert'` (e.g., it is `grt.tlc`, `rsim.tlc`, or another non-ERT target), SIL/PIL is not supported. Present the user with options:

   - If GOAL is `speed` or `balance` (codegen not permitted):
     > *"This model uses `<stf>` (Generic Real-Time target), which does not support SIL/PIL simulation. SIL/PIL requires an Embedded Coder target (`ert.tlc`). Since your goal requires execution-time measurement, I need to switch the system target file to `ert.tlc`. This changes code generation settings but enables full execution-time profiling. Shall I make this change?"*
     - If user agrees → run `set_param('<model>', 'SystemTargetFile', 'ert.tlc'); save_system('<model>');` and proceed.
     - If user refuses → explain that runtime optimization is not possible without SIL/PIL and ask if they'd like to change their goal to one compatible with codegen (RAM, ROM, MISRA, etc.). If user changes goal, re-evaluate from the top of Step 5.

   - If GOAL permits codegen (RAM-only, ROM-only, MISRA, traceability, safety):
     > *"This model uses `<stf>` (Generic Real-Time target), which does not support SIL/PIL simulation. You have two options:*
     > 1. *Switch to `ert.tlc` — enables execution-time profiling via SIL/PIL.*
     > 2. *Continue in codegen mode — I can analyze static metrics (RAM, ROM, stack, complexity) but won't measure execution time.*
     >
     > *Which would you prefer?"*
     - If user chooses option 1 → switch to `ert.tlc`, save model, keep `VERIFICATION_MODE` as SIL/PIL.
     - If user chooses option 2 → set `VERIFICATION_MODE = 'codegen'`.

   Log the outcome: `OK GR-06: STF is ERT-based (<stf>)` or `OK GR-06: STF was <stf> (non-ERT) — switched to ert.tlc per user confirmation` or `OK GR-06: STF was <stf> (non-ERT) — user chose codegen mode`.

   **GUARDRAIL GR-05 — runtime goal incompatible with codegen (HARD BLOCK):**
   If the user's GOAL is `speed` (maximize execution speed) or `balance` (balance RAM/speed) AND the user requests or implies codegen-only mode, the agent MUST NOT proceed with static analysis or suggestions. This is a hard block — the agent cannot offer a "codegen compromise" or provide speed suggestions without execution. The agent MUST:
   1. Explain to the user why codegen is insufficient AND which mode will be used instead:
      - If hardware is generic/desktop → *"To optimize execution speed, I need to actually run the generated code and measure timing. Codegen-only mode generates code but doesn't execute it, so I can't measure or verify runtime improvements. Since your hardware target is generic/desktop, I'll use SIL (Software-in-the-Loop) mode — this compiles and runs the generated code on your host machine so we can measure execution time."*
      - If hardware is a real MCU/board AND board is connected → *"To optimize execution speed, I need to actually run the generated code and measure timing. Codegen-only mode generates code but doesn't execute it, so I can't measure or verify runtime improvements. Since you have a <board> connected, I'll use PIL (Processor-in-the-Loop) mode — this cross-compiles the code, deploys it to your board, and measures real on-target execution time."*
      - If hardware is a real MCU/board but NOT connected → *"To optimize execution speed, I need to actually run the generated code and measure timing. Codegen-only mode generates code but doesn't execute it, so I can't measure or verify runtime improvements. Your target is <board> but it's not connected, so I'll use SIL mode for now — this runs the code on your host. If you connect the board later, we can switch to PIL for more accurate on-target timing."*
   2. Fall back to SIL (generic hardware or board not connected) or PIL (real board connected) based on the `configuring-code-profile` Decision 1 rules.
   3. Log `WARN GR-05: User requested codegen but GOAL=speed/balance requires execution — upgraded to <SIL/PIL>`.

   Codegen mode is ONLY permitted when GOAL is: RAM-only, ROM-only, MISRA compliance, traceability, or safety — goals that can be assessed from static code analysis without execution timing.

   **This guardrail is absolute.** Even if the user insists ("just analyze it", "don't run anything", "I don't care about measurement"), the agent MUST NOT provide speed optimization suggestions without committing to SIL/PIL verification. Providing static suggestions for speed without execution measurement is misleading — the agent cannot know if changes actually improve runtime without measuring. The only valid responses are: (a) explain why SIL/PIL is required and propose it, or (b) ask the user to change their goal to something compatible with codegen (RAM, ROM, MISRA).

   **When codegen mode IS selected (permitted goals only):** Explain the verification trade-off to the user:
   *"Since your goal is <RAM/ROM/MISRA/etc.>, I'll use codegen mode — this generates code and analyzes it statically without running it. Note: in this mode, I'll skip intermediate numerical correctness checks between optimization iterations (since I'm not executing the code each time). However, at the very end of the optimization run, I'll perform a final SIL verification to confirm that the optimized model still produces numerically correct results. If you'd prefer per-iteration correctness checks, I can use SIL mode instead — it's slower but verifies correctness after every change."*

   Wait for user acknowledgment before proceeding. If the user prefers per-iteration checks, upgrade to SIL/PIL.

6. **Establish tradeoff priorities.** Ask:
   - *"Is there a hard constraint on any resource (e.g., max 32 KB RAM)?"*
   - *"Are you willing to trade ROM for speed, or vice versa?"*
   - *"Any real-time deadline or target cycle time?"*

   Summarize understanding back to user before proceeding.

7. **MANDATORY TRANSITION to Phase 2.** Once confirmed: **(a)** append decision trace, **(b)** update token report, **(c)** construct state object, **(d)** proceed to Phase 2. **Refuse to transition if either diagnostic file not appended (OR-05/OR-06).** Set `NEXT_ACTION` based on `VERIFICATION_MODE`:
   - If `codegen`: `"Phase 2 Baseline (codegen) — (1) READ references/measuring-model-metrics/reference.md, (2) skip configureProfilingMode (codegen needs no profiling), (3) run CodeMetricsFetcherCodegen (sim + slbuild + static metrics), (4) CHECKPOINT: v1_baseline after run completes, (5) AWAIT_USER: present code analysis and ask which areas to target"`
   - If `SIL`/`PIL`: `"Phase 2 Baseline (<mode>) — (1) READ references/measuring-model-metrics/reference.md, (2) configureProfilingMode, (3) run CodeMetricsFetcher<mode> coarse, (4) CHECKPOINT: v1_baseline after run completes, (5) AWAIT_USER: present function listing with metrics and ask which functions to target"`

   **`CHECKPOINT:` = mandatory snapshot. `AWAIT_USER:` = hard stop for user input.**

## Risk / Alert — Known Failure Modes

| ID | Risk | Symptom | Triggered By | Mitigation |
|----|------|---------|-------------|------------|
| GR-01 | Goal misclassification | Agent chooses wrong mode | Ambiguous language | Always confirm VERIFICATION_MODE explicitly |
| GR-02 | Generic hardware assumed | CRL disabled, PIL skipped | Skipping step 4 | Never skip; always ask about MCU/board |
| GR-03 | Premature transition | Phase 2 without confirmation | Skipping "Does this look correct?" | Enforce wait for user yes |
| GR-04 | Missing tradeoff info | Wrong tradeoffs later | Skipping step 6 or vague answers | Re-ask if unclear |
| GR-05 | Codegen used for runtime goal | No execution time data; goal unachievable | User asks for "faster code" but also "no testing" or "codegen only" | Guardrail: explain that runtime requires execution, upgrade to SIL/PIL |
| GR-06 | Non-ERT target with SIL/PIL | `configureProfilingMode` fails on unsupported parameters in Phase 2 | Model uses `grt.tlc` or other non-ERT target but VERIFICATION_MODE is SIL/PIL | Check STF in Phase 1 Step 5; offer switch to `ert.tlc` or fallback to codegen before transitioning |

## Decision Trace Logging

After each numbered step, append to `<project_path>/.eco_diagnostics/eco_decision_trace.md`:

| After step | Log entry |
|------------|-----------|
| 4 (hardware) | `OK GR-02: Asked hardware target — user said <target>; board connected: <yes/no>` |
| 3 (summary) | `OK GR-03: Confirmed model summary with user` (or `WARN` if corrected) |
| 5 (verification) | `OK GR-01: Confirmed VERIFICATION_MODE=<mode>` |
| 5 (STF check) | `OK GR-06: STF is ERT-based (<stf>)` (or `OK GR-06: STF was <stf> (non-ERT) — switched to ert.tlc per user confirmation` or `OK GR-06: STF was <stf> (non-ERT) — user chose codegen mode`) |
| 5 (guardrail) | `WARN GR-05: User requested codegen but GOAL=<goal> requires execution — upgraded to <mode>` (or `OK GR-05: GOAL=<goal> compatible with codegen`) |
| 6 (tradeoffs) | `OK GR-04: Tradeoffs captured: <constraints>` |

If a risk's mitigation is intentionally not exercised, log `SKIP GR-0x: <reason>`. The diagnostic file MUST contain an entry for every GR-0x ID before transition.


----

Copyright 2026 The MathWorks, Inc.

----