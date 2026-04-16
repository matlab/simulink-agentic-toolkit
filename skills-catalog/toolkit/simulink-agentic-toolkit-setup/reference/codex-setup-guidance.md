# OpenAI Codex Setup Guidance

**Status: validated against `codex-cli 0.118.0` on macOS; Linux and Windows commands included below**

This reference file contains OpenAI Codex-specific instructions for Phase 3b of the setup skill.

## Overview

Codex setup needs two global registrations:

1. Add the Simulink MCP server to Codex's user config so the tools are available in every Codex session.
2. Add global skill references under `~/.agents/skills` so the toolkit skills are available in every repo and continue to update from this clone after `git pull`.

Do **not** copy skills into a Codex-private folder if a repo reference will work.

## Global Paths

```text
~/.codex/config.toml
~/.agents/skills/
```

Codex also honors `CODEX_HOME` for testing. If `CODEX_HOME` is set, the effective user config path is:

```text
$CODEX_HOME/config.toml
```

## Preferred MCP Configuration Path

Prefer Codex's native MCP management command when it is available:

```bash
codex mcp add simulink -- "~/.local/bin/matlab-mcp-core-server" --matlab-session-mode=existing --extension-file=<TOOLKIT_ROOT>/tools/tools.json --matlab-root=<MATLAB_ROOT>
```

Observed behavior in `codex-cli 0.118.0`:

- This command writes a global `[mcp_servers.simulink]` entry to `~/.codex/config.toml`
- Re-running it updates the existing `simulink` entry instead of creating duplicates
- Existing unrelated `mcp_servers.*` entries are preserved

### Fallback TOML Block

If `codex mcp add` is unavailable, write or update this section manually:

```toml
[mcp_servers.simulink]
command = "~/.local/bin/matlab-mcp-core-server"
args = ["--matlab-session-mode=existing", "--extension-file=<TOOLKIT_ROOT>/tools/tools.json", "--matlab-root=<MATLAB_ROOT>"]
tool_timeout_sec = 600
```

**CRITICAL:** The TOML key must be `mcp_servers` with an underscore. `mcp-servers` is silently ignored.

### Required Extra Fields

`codex mcp add` writes only `command` and `args`. The following fields must be added manually by editing `~/.codex/config.toml` after running `codex mcp add`, or included when writing the TOML block directly:

**`tool_timeout_sec` (all platforms):** The default Codex tool timeout is too short for many MATLAB operations (test suites, simulations, code generation). Set this to at least 600 seconds (10 minutes):

```toml
tool_timeout_sec = 600   # increase for long-running tasks
```

**`env_vars` (Windows only):** On Windows, Codex strips environment variables from MCP server subprocesses by default. Simulink requires the `WINDIR` environment variable:

```toml
env_vars = ['WINDIR']   # required for Simulink on Windows
```

The complete Windows TOML block should look like:

```toml
[mcp_servers.simulink]
command = "~/.local/bin/matlab-mcp-core-server"
args = ["--matlab-session-mode=existing", "--extension-file=<TOOLKIT_ROOT>/tools/tools.json", "--matlab-root=<MATLAB_ROOT>"]
tool_timeout_sec = 600
env_vars = ['WINDIR']
```

Use the absolute expanded path for `command` (e.g., `/home/username/.local/bin/matlab-mcp-core-server`).

## Global Skills Registration

Install repo-referenced skill directories into `~/.agents/skills`.

The toolkit includes shared helper scripts (used by Copilot, Codex, and Gemini CLI):

### macOS and Linux

```bash
bash "<TOOLKIT_ROOT>/skills-catalog/toolkit/simulink-agentic-toolkit-setup/scripts/install-global-skills.sh" "<TOOLKIT_ROOT>"
```

This creates or updates symlinks such as:

```text
~/.agents/skills/building-simulink-models       -> <TOOLKIT_ROOT>/skills-catalog/model-based-design-core/building-simulink-models
~/.agents/skills/testing-simulink-models        -> <TOOLKIT_ROOT>/skills-catalog/model-based-design-core/testing-simulink-models
~/.agents/skills/simulink-agentic-toolkit-setup -> <TOOLKIT_ROOT>/skills-catalog/toolkit/simulink-agentic-toolkit-setup
```

The script prefers `~/.agents/skills/` and falls back to `~/.copilot/skills/` if the primary directory cannot be created.

### Windows PowerShell

```powershell
powershell -ExecutionPolicy Bypass -File "<TOOLKIT_ROOT>\skills-catalog\toolkit\simulink-agentic-toolkit-setup\scripts\install-global-skills.ps1" -ToolkitRoot "<TOOLKIT_ROOT>"
```

The script first tries symbolic links and falls back to directory junctions.

## Phase 3b: Execute Codex Setup

### Step 1: Read existing Codex config

```bash
cat ~/.codex/config.toml 2>/dev/null
```

### Step 2: Register global skills

Run the platform-appropriate helper script from the toolkit repo.

After it completes, report:

1. The global skills directory used
2. The skill links created or updated
3. That the links point back to this repo clone for updateability

### Step 3: Add or update the Simulink MCP server

Preferred:

```bash
codex mcp add simulink -- "~/.local/bin/matlab-mcp-core-server" --matlab-session-mode=existing --extension-file=<TOOLKIT_ROOT>/tools/tools.json --matlab-root=<MATLAB_ROOT>
```

If the CLI command fails because it is unavailable in the installed Codex version, update `~/.codex/config.toml` manually using the TOML block above.

### Step 3b: Add required extra fields

`codex mcp add` does not support `tool_timeout_sec` or `env_vars`. After running `codex mcp add` (or when writing the TOML block directly), edit `~/.codex/config.toml` to add these fields to the `[mcp_servers.simulink]` section:

- **All platforms:** Add `tool_timeout_sec = 600`
- **Windows only:** Add `env_vars = ['WINDIR']`

See [Required Extra Fields](#required-extra-fields) above for the complete block.

### Step 4: Confirm what was written

Always echo back:

1. The config file path that was written
2. The exact `[mcp_servers.simulink]` section now present
3. Whether the `simulink` entry was created new or updated
4. The global skills path used
5. The list of skill links created or updated

## Verification

### Before restarting Codex

Verify the MCP registration locally:

```bash
codex mcp list
codex mcp get simulink --json
```

Expected result: a `simulink` stdio server whose command is the installed `matlab-mcp-core-server` binary and whose args include `--matlab-session-mode=existing`, `--extension-file`, and `--matlab-root`.

### After restarting Codex in another repo

Start a new Codex session in a different repository and ask:

```text
What version of Simulink is running?
```

Setup is successful when:

- Codex can call `model_overview` or `evaluate_matlab_code`
- Simulink skills are available outside the toolkit repo

## Manual Fallback

If automated setup fails:

1. Edit `~/.codex/config.toml` manually and add the `[mcp_servers.simulink]` section shown above
2. Create `~/.agents/skills`
3. Add directory symlinks or junctions from `~/.agents/skills/<skill-name>` to the corresponding directories in this repo
4. Restart Codex

## Platform Quirks

- Codex uses TOML for config, not JSON
- `mcp_servers` must use an underscore
- Current Codex CLI exposes `codex mcp ...` commands but does **not** expose a stable public plugin-install command
- Global skills come from `~/.agents/skills`, not from `.codex-plugin/`
- User config can be overridden by project config (`.codex/config.toml`) or CLI flags
