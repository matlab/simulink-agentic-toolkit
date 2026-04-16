# Gemini CLI Setup Guidance

**Status: Automated — tested**

This reference file contains **executable automation steps** for Phase 3b of the setup skill. The setup skill implements these steps to configure Gemini CLI for Simulink MCP.

---

## Overview

Gemini CLI uses a global JSON settings file (`~/.gemini/settings.json`) for MCP server configuration and discovers skills from `~/.agents/skills/` (the cross-platform convention shared with Copilot and Codex).

Setup automates configuring the MCP server so it is ready for the user on their next restart. Skills are registered via the shared step (3b-shared in SKILL.md) — no Gemini-specific skill configuration is needed.

---

## Phase 3b: Automation Steps

### Step 1: Read and merge Gemini settings

Read `~/.gemini/settings.json` as JSON:

```bash
if [ -f ~/.gemini/settings.json ]; then
  SETTINGS_JSON="$HOME/.gemini/settings.json"
else
  SETTINGS_JSON=""
fi
```

If the file exists, parse it. If it doesn't exist, start with an empty config:

```json
{
  "mcpServers": {}
}
```

### Step 2: Add or update Simulink MCP entry

Merge the Simulink entry into the `mcpServers` block. Use Python for safe JSON manipulation (avoids dependency on `jq`):

```python
import json, os

settings_path = os.path.expanduser('~/.gemini/settings.json')
settings = {}
if os.path.exists(settings_path):
    with open(settings_path, 'r') as f:
        settings = json.load(f)

if 'mcpServers' not in settings:
    settings['mcpServers'] = {}

settings['mcpServers']['simulink'] = {
    'command': os.path.expanduser('~/.local/bin/matlab-mcp-core-server'),
    'args': ['--matlab-session-mode=existing', '--extension-file=<TOOLKIT_ROOT>/tools/tools.json', '--matlab-root=<MATLAB_ROOT>']
}

os.makedirs(os.path.dirname(settings_path), exist_ok=True)
with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2)
```

**Important:** Preserve all other settings in `~/.gemini/settings.json` — only add or update the `mcpServers.simulink` entry.

### Step 3: Confirm what was done

Always echo back:
1. The file path that was written (`~/.gemini/settings.json`)
2. The exact `mcpServers.simulink` entry that was added or updated
3. Whether the file was created new or an existing entry was updated
4. That skills are available via `~/.agents/skills/` (created by the shared skills registration step)
5. A reminder to restart Gemini CLI to see the changes take effect

---

## Platform Details

| Setting | Value |
|---------|-------|
| Config file | `~/.gemini/settings.json` (global, user-level) |
| MCP key name | `"mcpServers"` |
| Skills paths | `~/.agents/skills/` |

**Quirks:**
- Do NOT use `gemini mcp add` from within a running Gemini session — it recursively invokes the CLI and can fail due to file locking on `settings.json`. Always use the direct Python file write above.
- The `mcpServers` key is at the top level of `settings.json`, alongside other keys like `general`, `security`, etc.
- Skills are discovered from `~/.agents/skills/`; global symlinks make them available across all projects

---

## Fallback (Manual Setup)

If automation encounters an error, provide these manual instructions to the user:

> 1. Open `~/.gemini/settings.json` in a text editor.
> 2. Add the following to the `mcpServers` block (creating it if it doesn't exist):
>    ```json
>    "mcpServers": {
>      "simulink": {
>        "command": "/absolute/path/to/.local/bin/matlab-mcp-core-server",
>        "args": ["--matlab-session-mode=existing", "--extension-file=<TOOLKIT_ROOT>/tools/tools.json", "--matlab-root=<MATLAB_ROOT>"]
>      }
>    }
>    ```
> 3. Save the file and restart Gemini CLI.

---

## Verification

After the setup skill completes:

1. **Check config file:**
   ```bash
   cat ~/.gemini/settings.json | grep -A5 mcpServers
   ```
   Should contain the `simulink` entry with correct path.

2. **Check skills symlinks:**
   ```bash
   ls -la ~/.agents/skills/
   ```
   Should show symlinks to skill directories.

3. **In Gemini CLI:**
   - Start a new Gemini CLI session
   - Ensure MATLAB is running with `satk_initialize` executed
   - Ask: "What version of Simulink is running?"
   - If Gemini can call `model_overview` or `evaluate_matlab_code`, setup was successful.
