---
name: simulink-agentic-toolkit-setup
description: Install and configure the Simulink Agentic Toolkit — detect platform, download and install the MCP server binary, register with your AI coding agent, and verify the environment. Supports Claude Code, Cursor, Codex, GitHub Copilot, Amp, and Gemini CLI.
license: MathWorks BSD-3-Clause
metadata:
  version: "1.0"
---

# Simulink Agentic Toolkit Setup

Automated onboarding for the Simulink Agentic Toolkit. Detects your platform, downloads and installs the MCP server binary from GitHub, configures your AI coding agent, and verifies everything works.

> **Tested platform:** Claude Code.
> **Automated platforms:** GitHub Copilot, Gemini CLI (with manual fallback provided).
> **Experimental platforms:** Cursor, Codex, Amp are provided as-is; setup will guide you through each step and provide manual fallback instructions if anything fails.

This skill does NOT require the MATLAB MCP server to already be running — it uses shell commands for everything until the final verification step.

## When to Use

- User asks to set up the Simulink Agentic Toolkit
- First time using the toolkit after cloning
- After moving the toolkit to a new location
- After updating the toolkit (`git pull`) which may include a new MCP server binary
- MCP connection issues that may indicate a broken installation
- User wants to configure Simulink MCP for any supported agent platform

## When NOT to Use

- Simulink environment is already set up and working — use environment validation directly instead
- User is asking about a specific Simulink task (use the appropriate domain skill)

## Workflow Overview

1. **Discovery** (silent) — detect platform, find MATLAB installations, check for existing MCP server, detect agent platform
2. **Plan** (interactive) — present everything found and all proposed actions in a single summary; let the user confirm or adjust before any changes are made
3. **Execute** (uninterrupted) — carry out the approved plan: install binary, configure agent
4. **Verify** — confirm the MCP server can reach MATLAB and Simulink
5. **Report** — present a final summary of everything that was set up and where it lives

The goal is to ask the user **once** for all decisions, then execute without further interruption.

---

## Phase 1: Discovery

Run all of these checks silently — do not prompt the user during this phase. Collect all results for presentation in Phase 2.

### 1a. Detect platform

```bash
uname -s   # Darwin, Linux, or MINGW*/MSYS* for Windows
uname -m   # arm64, x86_64, aarch64
```

Map to binary asset names:

| OS | Architecture | Asset Name |
|----|-------------|------------|
| macOS | arm64 | `matlab-mcp-core-server-maca64` |
| macOS | x86_64 | `matlab-mcp-core-server-maci64` |
| Linux | x86_64 | `matlab-mcp-core-server-glnxa64` |
| Windows | x86_64 | `matlab-mcp-core-server-win64.exe` |

The local binary name after installation is always `matlab-mcp-core-server` (or `matlab-mcp-core-server.exe` on Windows).

### 1b. Check for existing config

```bash
cat ~/.simulink-agentic-toolkit/config.json 2>/dev/null
```

If a config exists with valid paths, note the stored values as defaults for Phase 2.

### 1c. Check latest MCP server version

Query GitHub for the latest release:

```bash
curl -sL https://api.github.com/repos/matlab/matlab-mcp-core-server/releases/latest | grep '"tag_name"' | head -1 | sed 's/.*"\(v[^"]*\)".*/\1/'
```

Record the latest tag (e.g., `v0.8.0`).

### 1d. Check for existing installed binary

Check `~/.local/bin/matlab-mcp-core-server --version` and `which matlab-mcp-core-server`. If found, record path and version. Compare with the latest version from step 1c.

### 1e. Find MATLAB installations

Search all of: PATH (`which matlab`), common locations, and macOS Spotlight. Collect ALL results.

| Platform | Search locations |
|----------|-----------------|
| macOS | `/Applications/*/MATLAB_*.app`, `/Applications/MATLAB_*.app`, Spotlight |
| Linux | `/usr/local/MATLAB/R20*`, `/opt/MATLAB/R20*` |
| Windows | `/c/Program Files/MATLAB/R20*` |

Validate each: `test -x "$MATLAB_ROOT/bin/matlab"` and read version from `VersionInfo.xml`.

MATLAB must be **R2023a or later** and have **Simulink** installed. Note: Simulink availability cannot be confirmed via filesystem alone — it will be verified in Phase 4 via MCP.

### 1f. Check existing agent configuration

For Claude Code:
```bash
claude plugin list 2>&1
claude mcp list 2>&1
```

If a `simulink` MCP server is already registered, check whether its command and args match the current expected values (`matlab-mcp-core-server` with `--matlab-session-mode=existing`, `--extension-file`, `--matlab-root`). If the command, args, or binary path don't match, the config is **stale and must be updated** in Phase 3.

For other platforms, check if their global config files already have a `simulink` MCP server entry (see platform-specific reference files for paths). Apply the same staleness check.

### 1g. Detect agent platform

Check environment and CLI tools: `claude --version` (Claude Code), `$CURSOR_TRACE` (Cursor), `codex --version` (Codex), `amp --version` (Amp), `gemini --version` (Gemini CLI), `$VSCODE_*` (Copilot). If ambiguous, ask the user.

---

## Phase 2: Plan

Present ALL discoveries and proposed actions in a **single message**. If the agent has an interactive elicitation tool available, it may use it. Otherwise, print the plan and wait for a normal user reply. Format the plan like this:

```
Simulink Agentic Toolkit — Setup Plan
=======================================

Platform:  Linux x86_64 (glnxa64)

MATLAB installations found:
  [1] R2025b  /usr/local/MATLAB/R2025b

MCP server:
  Installed:  not found
  Latest:     v0.8.0
  Install to: ~/.local/bin/matlab-mcp-core-server
  Toolbox:    ~/.local/share/MATLABMCPCoreServerToolkit.mltbx (download from GitHub, install once per MATLAB version)
  Extension:  <TOOLKIT_ROOT>/tools/tools.json (referenced via --extension-file, not copied)

Agent platform:  Claude Code (detected)
  Status:        Tested

Proposed actions:
  MCP server:    Download v0.8.0 to ~/.local/bin/matlab-mcp-core-server
  MCP toolbox:   Download MATLABMCPCoreServerToolkit.mltbx to ~/.local/share/
  Agent config:  Configure MCP server globally (available in all sessions)
  MATLAB:        Validate R2025b (/usr/local/MATLAB/R2025b) has Simulink

IMPORTANT: After setup, you must run `satk_initialize` in MATLAB once per session
for the MCP server to connect. Add to your startup.m for automation.

Proceed with this plan? You can adjust any choice:
  - Pick a different MATLAB: "use 2" or provide a path
  - Keep existing server: "use server at /path/to/binary"
  - Configure a different agent: "use Cursor" or "use Amp"
```

For non-Claude platforms, clearly note "EXPERIMENTAL — untested, provided as-is" and that manual fallback will be provided if automated setup fails.

For OpenAI Codex specifically, the plan must cover **both**:
- Global MCP configuration in `~/.codex/config.toml`
- Global skill references in `~/.agents/skills/` so the toolkit is available from any repo after setup

### Decision points

| Decision | Default | How to override |
|----------|---------|-----------------|
| Which MATLAB | Newest R2023a+ found | User picks by number or provides a path |
| MCP server | Download latest to `~/.local/bin/` | User says "use existing" or provides a path |
| Agent platform | Auto-detected | User says "use [platform]" |

Note: SATK always uses `--matlab-session-mode=existing` (connects to a running MATLAB session). The `--extension-file` and `--matlab-root` args are resolved from the toolkit root and detected MATLAB installation.

### If no MATLAB found

Report that no MATLAB was found and ask the user to provide the path to their MATLAB root directory. Validate before proceeding.

### User confirms

Once the user confirms — move to Phase 3. If they adjust choices, update the plan and re-confirm only if changes are significant.

---

## Phase 3: Execute

Carry out the approved plan. Do NOT prompt the user during this phase — all decisions were made in Phase 2.

### 3a. Install MCP server binary and MATLAB toolbox

**Download the binary** using `curl` (preferred) or `wget` to `~/.local/bin/matlab-mcp-core-server`:

```bash
mkdir -p ~/.local/bin
curl -sL -o ~/.local/bin/matlab-mcp-core-server \
  "https://github.com/matlab/matlab-mcp-core-server/releases/download/${LATEST_TAG}/${ASSET_NAME}"
```

Post-download:
- macOS/Linux: `chmod +x ~/.local/bin/matlab-mcp-core-server`
- macOS: `xattr -d com.apple.quarantine ~/.local/bin/matlab-mcp-core-server 2>/dev/null`
- Windows: `Unblock-File -Path "$env:USERPROFILE\.local\bin\matlab-mcp-core-server.exe"` (PowerShell)

Verify:
```bash
~/.local/bin/matlab-mcp-core-server --version
```

If download fails, provide the direct URL for manual download.

**Download the MATLAB toolbox** to `~/.local/share/`:

```bash
mkdir -p ~/.local/share
curl -sL -o ~/.local/share/MATLABMCPCoreServerToolkit.mltbx \
  "https://github.com/matlab/matlab-mcp-core-server/releases/download/${LATEST_TAG}/MATLABMCPCoreServerToolkit.mltbx"
```

**Remind the user to install the toolbox** (once per MATLAB version). This provides the `shareMATLABSession` function that enables the MCP server to connect to a running MATLAB session. Tell the user to run the following in MATLAB:

```matlab
matlab.addons.install('<ABSOLUTE_PATH_TO_HOME>/.local/share/MATLABMCPCoreServerToolkit.mltbx')
```

Do NOT attempt to run this via MCP — the MCP server is not yet connected during setup. This only needs to be done once per MATLAB version and persists across sessions.

Note: `tools.json` is **not** downloaded to `~/.local/bin/`. It stays in the toolkit repo at `tools/tools.json` and is referenced at runtime via the `--extension-file` argument.

### 3b-shared. Register global skills (Copilot, Codex, Gemini)

For platforms that discover skills from `~/.agents/skills/` — GitHub Copilot, OpenAI Codex, and Gemini CLI — create symlinks pointing back to the toolkit repo. This only needs to run once, even if multiple platforms are configured.

The toolkit includes cross-platform helper scripts:

**macOS / Linux:**
```bash
bash "<TOOLKIT_ROOT>/skills-catalog/toolkit/simulink-agentic-toolkit-setup/scripts/install-global-skills.sh" "<TOOLKIT_ROOT>"
```

**Windows PowerShell:**
```powershell
powershell -ExecutionPolicy Bypass -File "<TOOLKIT_ROOT>\skills-catalog\toolkit\simulink-agentic-toolkit-setup\scripts\install-global-skills.ps1" -ToolkitRoot "<TOOLKIT_ROOT>"
```

These create symlinks such as:
```text
~/.agents/skills/building-simulink-models       -> <TOOLKIT_ROOT>/skills-catalog/model-based-design-core/building-simulink-models
~/.agents/skills/testing-simulink-models        -> <TOOLKIT_ROOT>/skills-catalog/model-based-design-core/testing-simulink-models
~/.agents/skills/simulink-agentic-toolkit-setup -> <TOOLKIT_ROOT>/skills-catalog/toolkit/simulink-agentic-toolkit-setup
```

Echo back the list of skill links created or updated.

> **Why `~/.agents/skills/`?** This is the cross-platform convention for global skill discovery. Copilot, Codex, and Gemini CLI all read from this directory natively. Using a single canonical location avoids duplicate skill warnings when multiple agents are installed.

### 3b-platform. Configure agent platform

**Automated setup for each platform:**

#### GitHub Copilot

Uses `~/.vscode/settings.json`. Automate using Python (jq may not be installed):

```python
import json, os
settings_path = os.path.expanduser('~/.vscode/settings.json')
settings = {}
if os.path.exists(settings_path):
    with open(settings_path, 'r') as f:
        settings = json.load(f)
if 'mcp.servers' not in settings:
    settings['mcp.servers'] = {}
settings['mcp.servers']['simulink'] = {
    'type': 'stdio',
    'command': os.path.expanduser('~/.local/bin/matlab-mcp-core-server'),
    'args': ['--matlab-session-mode=existing', '--extension-file=<TOOLKIT_ROOT>/tools/tools.json', '--matlab-root=<MATLAB_ROOT>']
}
os.makedirs(os.path.dirname(settings_path), exist_ok=True)
with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2)
```

Skills are registered via the shared step (3b-shared) — no additional symlinks needed here.

Echo back:
- File path: `~/.vscode/settings.json`
- MATLAB entry was added/updated

#### Other platforms

**Read** the platform-specific reference file (located in the `reference/` directory next to this skill file) and follow its instructions exactly. Use the toolkit root to resolve the path: `<TOOLKIT_ROOT>/skills-catalog/toolkit/simulink-agentic-toolkit-setup/reference/<filename>`.

| Platform | Reference file |
|----------|---------------|
| Claude Code | `reference/claude-code-setup-guidance.md` |
| Cursor | `reference/cursor-setup-guidance.md` |
| OpenAI Codex | `reference/codex-setup-guidance.md` |
| Sourcegraph Amp | `reference/amp-setup-guidance.md` |
| Gemini CLI | `reference/gemini-cli-setup-guidance.md` |

Each reference file contains the exact config format, **global config path**, merge instructions, and manual fallback steps. The MCP server should be configured **globally** (not per-project) so it is available in every session regardless of which workspace the user opens.

**After writing any config file**, always echo back to the user:
1. The file path that was written
2. The exact content that was written
3. Whether the file was created new or an existing entry was updated

### 3c. Save state

Write configuration to `~/.simulink-agentic-toolkit/config.json`:

```bash
mkdir -p ~/.simulink-agentic-toolkit
```

```json
{
  "toolkitRoot": "<TOOLKIT_ROOT>",
  "mcpServerPath": "~/.local/bin/matlab-mcp-core-server",
  "mcpServerArch": "<ARCH>",
  "matlabRoot": "<MATLAB_ROOT>",
  "matlabVersion": "<VERSION>",
  "configuredPlatforms": ["<PLATFORM>"],
  "lastSetup": "<ISO_8601_TIMESTAMP>"
}
```

---

## Phase 4: Verify

Verification depends on the agent platform.

### Claude Code

Use the MATLAB MCP tools (now available via the plugin) to run:

```matlab
v = ver('Simulink');
if isempty(v)
    fprintf('WARNING: Simulink not found. MATLAB is connected but Simulink is not available.\n');
else
    fprintf('Simulink %s (%s) — ready.\n', v.Version, v.Release);
end
```

If MCP tools are not available in the current session (common after first-time setup), tell the user:

> The plugin was just installed. Start a **new Claude Code session** to activate the Simulink MCP tools, then verify with: "What version of Simulink is running?"

**IMPORTANT:** For MCP tools to work, the user must have MATLAB running with `satk_initialize` already executed:

> If verification fails with a connection error, open MATLAB and run:
> ```matlab
> addpath('<TOOLKIT_ROOT>')
> satk_initialize
> ```
> Then try again.

### Other platforms

For non-Claude platforms, verify what we can:

1. **Binary runs:**
   ```bash
   ~/.local/bin/matlab-mcp-core-server --version
   ```

2. **Config file exists and contains the simulink entry:**
   ```bash
   cat <GLOBAL_CONFIG_PATH> 2>/dev/null | grep simulink
   ```

3. **Tell the user how to verify in their agent:**
   > Restart [platform name], then ask: "What version of Simulink is running?"
   > If the agent can call `model_overview` or `evaluate_matlab_code`, setup was successful.

If verification fails:
1. Verify `matlab-mcp-core-server` is accessible (`which matlab-mcp-core-server` or check `~/.local/bin/`)
2. Try running the server manually to diagnose:
   ```bash
   ~/.local/bin/matlab-mcp-core-server --matlab-session-mode=existing --extension-file=<TOOLKIT_ROOT>/tools/tools.json --matlab-root=<MATLAB_ROOT> 2>&1 | head -20
   ```
3. Ensure MATLAB is running with `satk_initialize` executed (which calls `shareMATLABSession`)
4. Ensure `MATLABMCPCoreServerToolkit.mltbx` has been installed for this MATLAB version

---

## Phase 5: Report

Present a final summary including: MATLAB version and location, MCP server binary path, agent platform and config file path, and state file location.

**IMPORTANT — prerequisites for MCP connection:**

> The Simulink Agentic Toolkit uses `--matlab-session-mode=existing`, which connects to a running MATLAB session. Two things must be in place:
>
> 1. **One-time per MATLAB version:** Install the toolbox: `matlab.addons.install('<ABSOLUTE_PATH_TO_HOME>/.local/share/MATLABMCPCoreServerToolkit.mltbx')` — resolve `<ABSOLUTE_PATH_TO_HOME>` to the user's home directory; do not use `~`
> 2. **Each MATLAB session:** Open MATLAB and run: `addpath('<TOOLKIT_ROOT>'); satk_initialize`
>
> `satk_initialize` calls `shareMATLABSession` to make the session visible to the MCP server.
>
> **Tip:** Add the `addpath` and `satk_initialize` lines to your [`startup.m`](https://www.mathworks.com/help/matlab/ref/startup.html) to automate step 2.

**For Claude Code:** List installed plugins and their scope. Next steps: start new session, try "What version of Simulink is running?", list available skills.

**For other platforms:** Mark as "EXPERIMENTAL". Next steps: restart the agent, try "What version of Simulink is running?". Include troubleshooting: check config file, test binary, link to GETTING_STARTED.md.

---

## Re-run Behavior

When setup is run again: read existing config as defaults, run full discovery, present plan showing current vs. proposed state (e.g., "Binary already installed at v0.7.0 — update to v0.8.0?"), then execute and verify.

**IMPORTANT — always update on re-run:** Do NOT skip steps just because an existing config mentions the `simulink` MCP key. The binary name, args, and toolbox may have changed between versions. On every re-run:
1. **Always re-download the binary** from GitHub releases to `~/.local/bin/` (the binary name may have changed)
2. **Always re-write the MCP config** with the current binary name and args from this skill file — do not preserve stale config values from a prior setup
3. **Always check the mltbx** is installed for the detected MATLAB version

---

## Conventions

- Use `bash` commands for all steps except verification (Phase 4 for Claude Code), which uses MATLAB MCP tools
- Never modify files outside the toolkit directory, `~/.simulink-agentic-toolkit/`, `~/.local/bin/`, `~/.local/share/`, and the platform's global config path
- Collect all information silently in Phase 1; present all decisions together in Phase 2
- On failure, provide an actionable message — never show raw errors without context
- For non-Claude platforms, always provide manual fallback instructions

## Guardrails

### Always
- Check for existing installation before downloading the binary
- Validate MATLAB root before proceeding
- Present the full plan before making any changes
- Echo back exactly what was written to config files
- Clearly label experimental/untested platform support

### Ask First
- All decisions are presented together in Phase 2 — no mid-execution prompts
- If multiple MATLAB installations found, present the list and recommend the newest

### Never
- Run MATLAB via bash/terminal — use MCP tools only (and only in Phase 4 for Claude Code)
- Install MATLAB itself
- Overwrite existing config entries for other MCP servers (only add/update the `simulink` entry)
- Skip the verification step
- Prompt the user during Phase 1 (discovery) or Phase 3 (execution)
- Claim untested platforms are fully supported

## Communication

When discussing blocks, use: Name (blk_ID)
