---
name: filing-bug-reports
description: "Generate a standalone bug report that another developer can use to reproduce, investigate, and fix an issue. Use when the user says 'file a bug', 'write a bug report', 'report this issue', or asks to document a defect for handoff."
license: MathWorks BSD-3-Clause
metadata:
  author: MathWorks
  version: "1.0"
---

# Filing Bug Reports

Generate a self-contained bug report as a Markdown file that gives a receiving developer everything needed to reproduce the issue — without prescribing root cause or solution.

## When to Use

- User asks to file, write, or document a bug
- User wants to hand off a defect for another developer to investigate
- User wants a reproducible record of unexpected behavior

## When NOT to Use

- User wants to debug and fix the issue themselves right now — just help them directly
- User wants a design review or code review — use `code-review` skill instead

## Output Conventions

- **File:** `issues/BUG-<NNN>-<slug>.md` (next available number, kebab-case slug from title)
- **Create** the `issues/` directory if it doesn't exist
- **One bug per file** — never combine multiple bugs

## Workflow

1. **Reconstruct from conversation context.** You were present when the bug occurred — use your conversation history to extract:
   - What the user was doing (the action and intent)
   - What actually happened (error messages, tool output, unexpected behavior)
   - What was expected (infer from the user's goal — e.g., if they asked to read a model and got an error, expected behavior is a successful read)

2. **Gather environment details programmatically.** Don't ask the user for things you can look up:
   - Agent workspace root, OS, architecture: from your system context

   **Skill state vocabulary.** The skill spec uses progressive disclosure: metadata (name + description) is always in context; the body loads only when triggered. These terms describe the observable states and are agent-agnostic — they hold for any host that implements the Agent Skills standard, not just Claude Code:
   - *Registered* — the skill appears in the host agent's available-skills list this session.
   - *Described* — registered AND has a non-empty `description` in metadata. (Default state, no glyph.)
   - *Name-only* (⊘) — registered with only a name; the `description` field is absent from the agent's registration entry. Record which skills are name-only and stop there. **Do not read SKILL.md files on disk to verify whether descriptions exist** — the available-skills listing is the only state the bug report records. Reading the source frontmatter is cause-investigation, which is out of scope.

     Note: some host agents drop descriptions from the listing automatically when total skill text exceeds an internal budget — for example, Claude Code allocates a character budget that scales with context window size and strips descriptions from least-recently-invoked skills first when the budget is exceeded. Name-only is therefore often expected host behavior in a session with many skills loaded, not a SATK defect. Record the state, but don't frame the bug report as "SATK skill registration is broken" unless the same skill is name-only in a session where the budget clearly isn't exhausted (few skills present, or the host reports no truncation).
   - *Invoked* (▶) — the skill's body was read into the agent's context this session.
   - *Unregistered SATK skill* (✗) — a `SKILL.md` exists on disk under the toolkit's `skills-catalog/` but is absent from the available-skills list. ✗ is scoped to SATK only — we don't track unregistered skills from other sources.

   With those definitions:
   - Skills (stack view): read the available-skills list directly (not prior bug reports or docs) and mark each registered skill per the glossary. For ✗, also consult the SATK skill manifest at the toolkit root and list any SATK skills declared there that aren't in the registered set. Render per the Skills subsection of `reference/bug-report-template.md`.
   - Skill conflict analysis: only consider SATK `model-based-design-core` skills whose bodies are already in your context, and only if you noticed a conflict between them while doing the work that's plausibly related to this bug. Don't re-read skill bodies to hunt for conflicts; if nothing surfaced naturally, write `N/A — <reason>`.
   - Available MCP tools: list the MCP tools you have access to
   - Relevant source files: read the files involved in the failure

   **SATK-specific** (when Simulink MCP tools are available):
   - SATK version: read the `VERSION` file at the SATK root. If it doesn't exist and a `.git/` folder is present, read the latest commit hash and note "development build (<hash>)". If neither exists, ask the user what version of Simulink Agentic Toolkit they are using
   - MATLAB: `evaluate_matlab_code` → `disp(version); ver('simulink'); disp(pwd); disp(computer('arch'))`
   - `satk_initialize.m` status: `evaluate_matlab_code` → `which('model_read')` (empty = not run)
   - Connector: `evaluate_matlab_code` → `try; disp(connector.securePort); catch; disp('not running'); end`
   - MCP config: read `.vscode/mcp.json` for server mode and binary path

3. **Reproduce the bug.** Re-run the failing operation to confirm it's reproducible and capture exact output. If it passes on retry, note it as intermittent and try to identify what differs.

4. **Shrink to a minimal reproduction.** Remove every step, file, and variable that isn't needed to trigger the bug. The goal is the smallest input that still fails.

5. **Ask the user ONLY for what you cannot determine:**
   - Expected behavior — only if the output looks plausible but the user says it's wrong (you can't know what "right" looks like)
   - Severity / business impact — only if it's ambiguous (an outright crash is obviously high; a formatting nit is obviously low)
   - Context from outside this session — if the user references something you didn't witness

6. **Write the report** using the template in `reference/bug-report-template.md`. Fill every required section. Mark optional sections N/A if not applicable.

7. **Review before saving.** Verify:
   - A developer unfamiliar with the project can follow the steps without asking questions
   - No root cause or fix is prescribed (observations and hypotheses go in the Notes section only)
   - Error messages and logs are exact copies, not paraphrased
   - The title follows the format: `[Area] — Action — Unexpected result`

## Guardrails

- **Always:** Include exact reproduction steps starting from a clean/known state
- **Always:** Include verbatim error messages and log output (never paraphrase)
- **Always:** Specify the environment (versions, OS, platform)
- **Never:** State the root cause — that's the investigator's job
- **Never:** Propose a fix in the report body (hypotheses go in Notes only, clearly marked as speculation)
- **Never:** Include secrets, tokens, passwords, or PII — redact with `<REDACTED>`

## References

- `reference/bug-report-template.md` — The output template (always use this structure)

----

Copyright 2026 The MathWorks, Inc.

----

