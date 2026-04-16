# Sourcegraph Amp Setup Guidance

**Status: EXPERIMENTAL — untested, provided as-is**

This reference file contains Sourcegraph Amp-specific instructions for Phase 3b of the setup skill.

## Overview

Amp needs two things configured globally in `~/.config/amp/settings.json`:

1. **MCP server** via `amp.mcpServers` — makes Simulink tools always available (required)
2. **Skills path** via `amp.skills.path` — points at the cloned toolkit so skills load on demand and update via `git pull` (recommended)

The MCP server must be in global settings (not bundled in a skill) because it is the execution layer for all Simulink interactions. Skill-bundled MCP servers hide their tools until the skill loads, which would prevent general Simulink requests from working.

## Global Config Path

| Platform | Path |
|----------|------|
| macOS / Linux | `~/.config/amp/settings.json` |
| Windows | `%USERPROFILE%\.config\amp\settings.json` |

## Config Format

```json
{
  "amp.mcpServers": {
    "simulink": {
      "command": "~/.local/bin/matlab-mcp-core-server",
      "args": ["--matlab-session-mode=existing", "--extension-file=<TOOLKIT_ROOT>/tools/tools.json", "--matlab-root=<MATLAB_ROOT>"]
    }
  },
  "amp.skills.path": "<TOOLKIT_ROOT>/skills-catalog/model-based-design-core:<TOOLKIT_ROOT>/skills-catalog/toolkit"
}
```

Use the absolute expanded path for both `command` and `amp.skills.path`. Replace `<TOOLKIT_ROOT>` with the actual resolved path at setup time.

**Note:** All Amp settings use the `amp.` prefix. The MCP servers key is `amp.mcpServers` (not just `mcpServers`).

**Windows:** Use backslash paths for `command`, `args`, and `amp.skills.path`. Use semicolons (`;`) instead of colons (`:`) to separate multiple paths in `amp.skills.path`.

## Phase 3b: Write Config

### Step 1: Read existing config (if any)

```bash
cat ~/.config/amp/settings.json 2>/dev/null
```

### Step 2: Write or merge the config

- If the file **does not exist**: create it with the MCP server and skills path settings.
- If the file **exists**: parse the JSON, add or update the `simulink` key under `amp.mcpServers` and set `amp.skills.path`, preserving all other settings and server entries. Do NOT overwrite other settings or MCP servers.

If `amp.skills.path` already has a value, append the toolkit paths (colon-separated) rather than replacing.

```bash
mkdir -p ~/.config/amp
```

Then write the file. After writing, echo back the full file content to the user.

### Step 3: Check for MCP permission blocks

Read the existing config and check whether `amp.mcpPermissions` contains rules that would block the Simulink MCP server (e.g., `{"matches": {"command": "*"}, "action": "reject"}`).

If reject rules exist that would block the server, **do not silently modify them**. Instead, warn the user:

> Your `amp.mcpPermissions` settings block MCP servers matching `command: "*"`. This will prevent the Simulink MCP server from running, even though it is configured in your global settings.
>
> To allow the Simulink server, add this rule **before** your reject rules in `amp.mcpPermissions`:
> ```json
> { "matches": { "command": "*matlab-mcp-core-server*" }, "action": "allow" }
> ```
>
> Would you like me to add this rule?

Only modify `amp.mcpPermissions` if the user explicitly confirms.

### Step 4: Confirm what was written

Tell the user:

> Wrote Simulink configuration to `~/.config/amp/settings.json`:
> ```json
> [show the exact content written]
> ```
> - **MCP server:** Always available in all Amp sessions
> - **Skills:** Loaded on demand from the cloned toolkit. Run `git pull` in the toolkit repo to get updates.

## Platform Quirks

- **Settings prefix:** All keys use `amp.` prefix (e.g., `amp.mcpServers`, not just `mcpServers`).
- **Global vs. workspace MCP:** Global settings (`~/.config/amp/settings.json`) do not require trust approval. Workspace settings (`.amp/settings.json`) do. Always configure the MCP server globally.
- **Skills path:** `amp.skills.path` supports colon-separated paths (semicolon on Windows).
- **MCP permissions:** If the user has `amp.mcpPermissions` rules that reject all MCP servers, the Simulink MCP server will be blocked even though it's in global settings. See Step 3.

## Manual Fallback

If automated config writing fails, tell the user:

> I was unable to write the config file automatically. Please create or edit `~/.config/amp/settings.json` manually:
>
> 1. Open `~/.config/amp/settings.json` in a text editor (create the file and directory if they don't exist)
> 2. Add the following (merge with existing content if the file already has settings):
>    ```json
>    {
>      "amp.mcpServers": {
>        "simulink": {
>          "command": "/absolute/path/to/.local/bin/matlab-mcp-core-server",
>          "args": ["--matlab-session-mode=existing", "--extension-file=<TOOLKIT_ROOT>/tools/tools.json", "--matlab-root=<MATLAB_ROOT>"]
>        }
>      },
>      "amp.skills.path": "/path/to/simulink-agentic-toolkit/skills-catalog/model-based-design-core:/path/to/simulink-agentic-toolkit/skills-catalog/toolkit"
>    }
>    ```
> 3. Save the file and restart Amp

## Verification

After the user restarts Amp:

> Start a new Amp session and ask: "What version of Simulink is running?"
> Ensure MATLAB is running with `satk_initialize` executed first.
> If Amp can call `model_overview` or `evaluate_matlab_code`, setup was successful.
>
> If it doesn't work:
> - Run `amp mcp doctor` to check MCP server status
> - Check `~/.config/amp/settings.json` contains `amp.mcpServers.simulink`
> - Verify the binary runs: `~/.local/bin/matlab-mcp-core-server --version`
> - Run `amp skill list` to confirm Simulink skills are visible
