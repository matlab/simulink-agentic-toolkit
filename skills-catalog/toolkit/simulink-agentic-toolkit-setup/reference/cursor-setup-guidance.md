# Cursor Setup Guidance

**Status: EXPERIMENTAL — untested, provided as-is**

This reference file contains Cursor-specific instructions for Phase 3b of the setup skill.

## Overview

Cursor stores MCP server configuration in JSON files. The global config at `~/.cursor/mcp.json` makes the MCP server available across all projects.

## Global Config Path

```
~/.cursor/mcp.json
```

## Config Format

```json
{
  "mcpServers": {
    "simulink": {
      "command": "~/.local/bin/matlab-mcp-core-server",
      "args": ["--matlab-session-mode=existing", "--extension-file=<TOOLKIT_ROOT>/tools/tools.json", "--matlab-root=<MATLAB_ROOT>"]
    }
  }
}
```

Use the absolute expanded path for `command` (e.g., `/home/username/.local/bin/matlab-mcp-core-server`).

## Phase 3b: Write Config

### Step 1: Read existing config (if any)

```bash
cat ~/.cursor/mcp.json 2>/dev/null
```

### Step 2: Write or merge the config

- If the file **does not exist**: create it with the full JSON above.
- If the file **exists**: parse the JSON, add or update the `simulink` key under `mcpServers`, and preserve all other server entries. Do NOT overwrite other MCP servers.

```bash
mkdir -p ~/.cursor
```

Then write the file. After writing, echo back the full file content to the user.

### Step 3: Confirm what was written

Tell the user:

> Wrote Simulink MCP server configuration to `~/.cursor/mcp.json`:
> ```json
> [show the exact content written]
> ```
> This makes the Simulink MCP server available in all Cursor projects.

## Platform Quirks

- **Variable interpolation:** Cursor supports `${userHome}` in config values, but using absolute paths is more reliable.
- **Tool limit:** Cursor has a maximum of 40 active tools across ALL MCP servers combined. The Simulink Agentic Toolkit provides 7 tools, well within this budget.
- **Transport:** Only stdio transport is needed (the default for local servers).

## Manual Fallback

If automated config writing fails, tell the user:

> I was unable to write the config file automatically. Please create or edit `~/.cursor/mcp.json` manually:
>
> 1. Open `~/.cursor/mcp.json` in a text editor (create the file if it doesn't exist)
> 2. Add the following under `mcpServers`:
>    ```json
>    "simulink": {
>      "command": "/absolute/path/to/.local/bin/matlab-mcp-core-server",
>      "args": ["--matlab-session-mode=existing", "--extension-file=<TOOLKIT_ROOT>/tools/tools.json", "--matlab-root=<MATLAB_ROOT>"]
>    }
>    ```
> 3. Save the file and restart Cursor

## Verification

After the user restarts Cursor:

> Open any project in Cursor and ask: "What version of Simulink is running?"
> Ensure MATLAB is running with `satk_initialize` executed first.
> If Cursor can call `model_overview` or `evaluate_matlab_code`, setup was successful.
>
> If it doesn't work:
> - Check `~/.cursor/mcp.json` exists and contains the `simulink` entry
> - Verify the binary runs: `~/.local/bin/matlab-mcp-core-server --version`
> - Check Cursor's MCP server status in the Cursor settings UI
