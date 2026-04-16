# GitHub Copilot Setup Guidance

**Status: Automated — tested**

This reference file contains **executable automation steps** for Phase 3b of the setup skill. The setup skill implements these steps to configure GitHub Copilot for Simulink MCP.

---

## Overview

GitHub Copilot accesses MCP servers via `~/.vscode/settings.json` (global, user-level config). Setup automates:

1. **Global MCP config** — write to `~/.vscode/settings.json` with absolute path to installed binary
2. **Global skills** — create symlinks in `~/.agents/skills/` or `~/.copilot/skills/` pointing to `skills-catalog/`

This matches the target workflow: **clone once, setup once, use everywhere**.

---

## Phase 3b: Automation Steps

### Step 1: Read and merge VS Code settings

Read `~/.vscode/settings.json` as **JSON** (not JSONC to avoid comment parsing complexity):

```bash
if [ -f ~/.vscode/settings.json ]; then
  SETTINGS_JSON="$HOME/.vscode/settings.json"
else
  SETTINGS_JSON=""
fi
```

If the file exists, parse it. If it doesn't exist, start with an empty config:

```json
{
  "mcp.servers": {}
}
```

### Step 2: Add or update Simulink MCP entry

Merge the Simulink entry into the config. Use Python for safe JSON manipulation:

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

**Important:** Preserve all other settings in `~/.vscode/settings.json` — only add or update the `mcp.servers.simulink` entry.

### Step 3: Write settings back to file

Write the merged config to `~/.vscode/settings.json`. Use `mkdir -p ~/.vscode` first to ensure the directory exists.

### Step 4: Register global skills

Skills are registered via the shared step (3b-shared in SKILL.md) using the cross-platform helper scripts. These handle the `~/.agents/skills/` -> `~/.copilot/skills/` fallback automatically.

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
| Config file | `~/.vscode/settings.json` (global, user-level) |
| Server type | `"type": "stdio"` |
| MCP key name | `"mcp.servers"` (not `"mcpServers"`) |
| Skills paths | `~/.agents/skills/`, `~/.copilot/skills/`, `.github/skills/` |

**Quirks:**
- VS Code natively parses JSONC (JSON with comments), but setup must write valid JSON (no comments) to avoid merge conflicts
- Skills are discovered from any of the three paths; global symlinks make them available across all projects
- No per-project setup needed — global config works everywhere

---

## Fallback (Manual Setup)

If automation encounters an error, provide the user with manual instructions:

### Option A: Global setup via VS Code Settings UI

> 1. Open VS Code
> 2. Open Settings (Cmd/Ctrl + ,)
> 3. Search for "mcp.servers"
> 4. Click "Edit in settings.json"
> 5. Add:
>    ```json
>    "mcp.servers": {
>      "simulink": {
>        "type": "stdio",
>        "command": "~/.local/bin/matlab-mcp-core-server",
>        "args": ["--matlab-session-mode=existing", "--extension-file=<TOOLKIT_ROOT>/tools/tools.json", "--matlab-root=<MATLAB_ROOT>"]
>      }
>    }
>    ```
> 6. Save and reload VS Code

### Option B: Project-level setup

> For a single project, create `.vscode/mcp.json`:
> ```json
> {
>   "servers": {
>     "simulink": {
>       "type": "stdio",
>       "command": "~/.local/bin/matlab-mcp-core-server",
>       "args": ["--matlab-session-mode=existing", "--extension-file=<TOOLKIT_ROOT>/tools/tools.json", "--matlab-root=<MATLAB_ROOT>"]
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

1. **Check config file:**
   ```bash
   cat ~/.vscode/settings.json | grep -A5 mcp.servers
   ```
   Should contain the `simulink` entry with correct path.

2. **Check skills symlinks:**
   ```bash
   ls -la ~/.agents/skills/
   ```
   Should show symlinks to skill directories.

3. **In VS Code/Copilot:**
   - Reload: Cmd/Ctrl + Shift + P -> "Developer: Reload Window"
   - Ensure MATLAB is running with `satk_initialize` executed
   - Ask: "What version of Simulink is running?"
   - If Simulink tools are available, setup was successful
