# Claude Code Setup Guidance

**Status: Tested**

This reference file contains Claude Code-specific instructions for Phase 3b of the setup skill.

## Overview

Claude Code uses a plugin system with a marketplace. The `model-based-design-core` plugin delivers Simulink domain skills, and the `toolkit` plugin delivers the setup skill. Neither ships MCP server configuration (MCP config is system-specific and can't be meaningfully defaulted). The setup skill registers the MCP server using `claude mcp add-json` so it is managed by Claude Code's native settings system.

## Global Config Path

MCP server config is managed by `claude mcp add-json` with `-s user` scope. Do NOT write `~/.claude/.mcp.json` directly — Claude Code ignores manually written files and only reads MCP servers registered through its CLI.

## Phase 3b: Register Plugin

### Step 1: Add the marketplace

```bash
claude plugin marketplace add "https://github.com/mathworks/simulink-agentic-toolkit"
```

If the marketplace is already registered, this is a no-op. Continue to the next step.

### Step 2: Install plugins

```bash
claude plugin install model-based-design-core@simulink-agentic-toolkit
claude plugin install toolkit@simulink-agentic-toolkit
```

Claude's native prompt will ask the user to choose scope for each plugin. Do NOT implement your own scope selection — let Claude Code handle it.

### Step 3: Register MCP server

Use `claude mcp add-json` to register the simulink MCP server at user scope:

```bash
claude mcp add-json simulink '{"command":"<ABSOLUTE_PATH_TO_HOME>/.local/bin/matlab-mcp-core-server","args":["--matlab-session-mode=existing","--extension-file=<TOOLKIT_ROOT>/tools/tools.json","--matlab-root=<MATLAB_ROOT>"]}' -s user
```

All paths must be absolute expanded paths (e.g., `/home/username/.local/bin/matlab-mcp-core-server`), not `~/.local/bin/...`. Replace `<TOOLKIT_ROOT>` with the absolute path to the toolkit repo and `<MATLAB_ROOT>` with the detected MATLAB installation root.

Do NOT write `~/.claude/.mcp.json` directly — Claude Code ignores that file and only reads MCP servers registered through `claude mcp add` / `claude mcp add-json`.

The MCP tools become available in the next session (or immediately if the session is restarted).

### Step 4: Verify plugin installation

```bash
claude plugin list 2>&1
```

Confirm that `model-based-design-core@simulink-agentic-toolkit` and `toolkit@simulink-agentic-toolkit` appear in the output.

## If Plugin Commands Fail

If `claude` CLI commands fail (e.g., not available in the user's Claude Code version):

1. Report the error clearly
2. Skip plugin installation — skills can be used by reading SKILL.md files directly from the repo
3. The MCP server registration (Step 3) via `claude mcp add-json` still works independently of the plugin system

## Verification

Use MATLAB MCP tools (available after restarting the session):

```matlab
v = ver('Simulink');
if isempty(v)
    fprintf('WARNING: Simulink not found.\n');
else
    fprintf('Simulink %s (%s) — ready.\n', v.Version, v.Release);
end
```

If MCP tools are not available in the current session:

> The plugin was just installed. Start a **new Claude Code session** to activate the Simulink MCP tools, then verify with: "What version of Simulink is running?"

If MCP tools fail with a connection error:

> Ensure MATLAB is running with `satk_initialize` executed. Open MATLAB and run:
> ```matlab
> addpath('<TOOLKIT_ROOT>')
> satk_initialize
> ```
> Then try again.
