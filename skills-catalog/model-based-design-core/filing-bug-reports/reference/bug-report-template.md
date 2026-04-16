# BUG-<NNN>: [Area] — Action — Unexpected result

**Reporter:** *Name or agent identifier*
**Date:** *YYYY-MM-DD*
**Severity:** *Critical | High | Medium | Low*
**Reproducibility:** *Always | Often | Intermittent | Once*

---

## Summary

*One to two sentences: what is broken and under what conditions. A developer scanning a list of bugs should understand this issue from the summary alone.*

## Expected Behavior

*What should happen when following the reproduction steps. Be specific — include exact values, states, or outputs where applicable.*

## Actual Behavior

*What actually happens, described in plain language. Focus on the observable outcome (e.g., "the command returns an empty result" or "the block is placed but not connected"). Do not paste full error text here — that goes in Error Output below.*

## Reproduction Steps

*Numbered sequence starting from a known state. Each step should name the exact action, input values, and what to observe. A developer unfamiliar with this project must be able to follow these without asking questions.*

**Prerequisites:** *Any required setup — installed toolboxes, loaded models, specific files, workspace state, etc.*

1. *Step 1*
2. *Step 2*
3. *Step 3*
4. *Observe: [what goes wrong]*

### Minimal Reproduction (if applicable)

*The smallest possible input, command, or configuration that still triggers the bug. Include inline code or link to a standalone script/model.*

```matlab
% Example: paste the shortest code snippet that reproduces the issue
```

## Environment

### Toolkit & Agent

| Detail | Value |
|--------|-------|
| **SATK Version** | *e.g., v0.0.4* |
| **Agent / Client** | *e.g., Amp (VS Code), Claude Code CLI* |
| **Agent Workspace Root** | *The directory the agent considers its workspace — where it looks for `.agents/skills/`, `.vscode/mcp.json`, etc.* |
| **MCP Server Mode** | *e.g., attach-to-existing, launch* |
| **Available Skills** | *List all skills the agent can see at the time of the bug (from its startup context)* |
| **Loaded Skills** | *List any skills that were actually loaded/invoked during this session* |
| **Available MCP Tools** | *List the MCP tools the agent has access to (e.g., model_read, model_edit, etc.)* |

### MATLAB (include when Simulink MCP tools are involved)

| Detail | Value |
|--------|-------|
| **MATLAB Version** | *e.g., R2025b (25.2.0.xxxxx)* |
| **MATLAB Working Directory** | *Output of `pwd` in MATLAB — may differ from agent workspace* |
| **Simulink Version** | *e.g., 25.2* |
| **Relevant Toolboxes** | *e.g., Simulink Test 3.10, Stateflow 25.2* |
| **`setup.m` Status** | *e.g., "ran successfully", "not run this session", "failed at step 5 (MCP attach)"* |
| **Connector Port** | *e.g., 31515, or "not running" — only relevant for attach mode* |

### Platform

| Detail | Value |
|--------|-------|
| **OS** | *e.g., Windows 11 Build 26100, macOS 15.3, Ubuntu 24.04* |
| **Architecture** | *e.g., win64, maca64, glnxa64* |

*Add or remove rows as appropriate. For web/UI bugs, add browser and device details.*

## Error Output

*Paste the full error message, stack trace, or log output inside a code block. Do not paraphrase or summarize — include the exact text. Truncate only if extremely long, and indicate truncation with `[...truncated...]`.*

```
<paste exact error output here>
```

## Visual Evidence (if applicable)

*Screenshots, screen recordings, or annotated images that show the failure. Describe what each image shows.*

## Impact

*Who is affected and how. Include:*
- *Scope: all users / specific configuration / specific workflow*
- *Workaround: describe if one exists, or state "None known"*
- *Blocking: does this block other work? What?*

## Related Files

*List the files most likely relevant to this bug. Include paths and brief descriptions.*

| File | Relevance |
|------|-----------|
| *`path/to/file.m`* | *Brief description of why this file is relevant* |

## Notes (optional)

*Any observations, hypotheses, or context that might help the investigator. Clearly mark speculation as such. Do NOT state root cause — that is the investigator's job.*

*Example: "The error started appearing after commit abc1234. Might be related to the refactor of XYZ, but this is unconfirmed."*
