# GitHub Copilot Setup Guidance

**Status: Automated — tested**

This reference file contains **executable automation steps** for Phase 3b of the setup skill. The setup skill implements these steps to configure GitHub Copilot for Simulink MCP.

---

## Overview

GitHub Copilot reads MCP server configuration from the user-profile `mcp.json`. The path is platform-specific:

| Platform | User-profile MCP config path |
|----------|------------------------------|
| macOS | `~/Library/Application Support/Code/User/mcp.json` |
| Linux | `~/.config/Code/User/mcp.json` |
| Windows | `%APPDATA%\Code\User\mcp.json` |

All steps below refer to this file as `<MCP_CONFIG_PATH>`. Resolve it once using the platform detected in Phase 1a.

Setup automates:

1. **Global MCP config** — write to `<MCP_CONFIG_PATH>` with absolute paths
2. **Global skills** — create symlinks in `~/.agents/skills/` or `~/.copilot/skills/` pointing to `skills-catalog/`

This matches the target workflow: **clone once, setup once, use everywhere**.

---

## Phase 3b: Automation Steps

### Step 0: Resolve config path

Set `MCP_CONFIG_PATH` based on the platform detected in Phase 1a:

```bash
case "$(uname -s)" in
  Darwin*)          MCP_CONFIG_PATH="$HOME/Library/Application Support/Code/User/mcp.json" ;;
  Linux*)           MCP_CONFIG_PATH="$HOME/.config/Code/User/mcp.json" ;;
  MINGW*|MSYS*|CYGWIN*)  MCP_CONFIG_PATH="$APPDATA/Code/User/mcp.json" ;;
esac
```

### Step 1: Read existing config

Read `<MCP_CONFIG_PATH>` as **JSON**.
If the file exists, parse it (use a JSON tool like `jq` if available, or a safe JSON reader). If it doesn't exist, start with an empty config:

```json
{
  "servers": {}
}
```

### Step 2: Add or update Simulink MCP entry

Merge the Simulink entry into the config. Use `jq` (if available) for safe JSON manipulation:

**With jq:**
```bash
jq '.servers.simulink = {
  "type": "stdio",
  "command": "<MCP_SERVER_PATH>",
  "args": [
    "--matlab-session-mode=existing",
    "--extension-file=<TOOLKIT_ROOT>/tools/tools.json",
    "--matlab-root=<MATLAB_ROOT>"
  ]
}' "$MCP_CONFIG_PATH" > "$MCP_CONFIG_PATH.tmp" && mv "$MCP_CONFIG_PATH.tmp" "$MCP_CONFIG_PATH"
```

**Without jq (Python fallback):**
```python
import json, os

# mcp_config_path: use the platform-appropriate path from the Overview table

config = {}
if os.path.exists(mcp_config_path):
    with open(mcp_config_path, 'r') as f:
        config = json.load(f)

if 'servers' not in config:
    config['servers'] = {}

config['servers']['simulink'] = {
    'type': 'stdio',
    'command': '<MCP_SERVER_PATH>',
    'args': [
        '--matlab-session-mode=existing',
        '--extension-file=<TOOLKIT_ROOT>/tools/tools.json',
        '--matlab-root=<MATLAB_ROOT>'
    ]
}

os.makedirs(os.path.dirname(mcp_config_path), exist_ok=True)
with open(mcp_config_path, 'w') as f:
    json.dump(config, f, indent=2)
```

Replace placeholders:
- `<MCP_SERVER_PATH>` — absolute path to the binary (detected in Phase 1)
- `<TOOLKIT_ROOT>` — absolute path to the toolkit clone
- `<MATLAB_ROOT>` — absolute path to the MATLAB installation (detected in Phase 1)

**Important:** Preserve all other entries in `<MCP_CONFIG_PATH>` — only add or update the `servers.simulink` entry.

### Step 3: Write config back to file

Write the merged config to `<MCP_CONFIG_PATH>`. Ensure the parent directory exists first:

```bash
mkdir -p "$(dirname "$MCP_CONFIG_PATH")"
# Write merged JSON to $MCP_CONFIG_PATH
# (implementation: use jq, Python json module, or equivalent)
```

### Step 4: Register global skills

Skills are registered via the shared step (3b-shared in SKILL.md) using the cross-platform helper scripts. These handle the `~/.agents/skills/` → `~/.copilot/skills/` fallback automatically.

**macOS / Linux:**
```bash
bash "<TOOLKIT_ROOT>/skills-catalog/toolkit/simulink-agentic-toolkit-setup/scripts/install-global-skills.sh" "<TOOLKIT_ROOT>"
```

**Windows PowerShell:**
```powershell
powershell -ExecutionPolicy Bypass -File "<TOOLKIT_ROOT>\skills-catalog\toolkit\simulink-agentic-toolkit-setup\scripts\install-global-skills.ps1" -ToolkitRoot "<TOOLKIT_ROOT>"
```

---

## Platform Details

| Setting | Value |
|---------|-------|
| Config file | User-profile `mcp.json` (see path table in Overview) |
| Server type | `"type": "stdio"` |
| MCP key name | `"servers"` (not `"mcpServers"` or `"mcp.servers"`) |
| Skills paths | `~/.agents/skills/`, `~/.copilot/skills/`, `.github/skills/` |

**Quirks:**
- VS Code natively parses JSONC (JSON with comments), but setup must write valid JSON (no comments) to avoid merge conflicts
- Skills are discovered from any of the three paths; global symlinks make them available across all projects
- No per-project setup needed — global config works everywhere

---

## Fallback (Manual Setup)

If automation encounters an error, provide the user with manual instructions:

### Option A: Global setup (manual)

> 1. Open the user-profile `mcp.json` in a text editor (see path table in [Overview](#overview))
> 2. Add or merge the `simulink` entry under `"servers"`:
>    ```json
>    {
>      "servers": {
>        "simulink": {
>          "type": "stdio",
>          "command": "/path/to/matlab-mcp-core-server",
>          "args": [
>            "--matlab-session-mode=existing",
>            "--extension-file=/path/to/simulink-agentic-toolkit/tools/tools.json",
>            "--matlab-root=/path/to/MATLAB/R2025b"
>          ]
>        }
>      }
>    }
>    ```
> 3. Save and reload VS Code (Cmd/Ctrl + Shift + P → "Developer: Reload Window")

### Option B: Project-level setup

> For a single project, create `.vscode/mcp.json`:
> ```json
> {
>   "servers": {
>     "simulink": {
>       "type": "stdio",
>       "command": "/path/to/matlab-mcp-core-server",
>       "args": [
>         "--matlab-session-mode=existing",
>         "--extension-file=/path/to/simulink-agentic-toolkit/tools/tools.json",
>         "--matlab-root=/path/to/MATLAB/R2025b"
>       ]
>     }
>   }
> }
> ```

For skills, users can run the shared helper script manually:
```bash
bash /path/to/simulink-agentic-toolkit/skills-catalog/toolkit/simulink-agentic-toolkit-setup/scripts/install-global-skills.sh /path/to/simulink-agentic-toolkit
```

---

## Verification

After the setup skill completes:

1. **Check config file** (using the resolved `<MCP_CONFIG_PATH>`):
   ```bash
   cat "$MCP_CONFIG_PATH"
   ```
   Should contain the `simulink` entry with correct paths.

2. **Check skills symlinks:**
   ```bash
   ls -la ~/.agents/skills/
   ```
   Should show symlinks to skill directories.

3. **In VS Code/Copilot:**
   - Reload: Cmd/Ctrl + Shift + P → "Developer: Reload Window"
   - Ensure MATLAB is running with `satk_initialize` executed
   - Ask: "What version of Simulink is running?"
   - If Simulink tools are available, setup was successful
