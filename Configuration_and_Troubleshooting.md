# Configuration and Troubleshooting
This page shows you how to configure the Simulink® Agentic Toolkit. For an overview of the Simulink Agentic Toolkit, see the [README](README.md).

## Requirements

- **MATLAB R2023a or later** with **Simulink**
- A supported **AI coding agent**
- **Simulink Test** *(optional)* — required only for the `model_test` tool
- Some skills require additional toolboxes (e.g., System Composer, Simscape, Stateflow). Check the `requires-products` field in each skill's `manifest.yaml` under [`skills-catalog/`](skills-catalog/) for additional requirements.

### Installing from Local Files (Offline Computer)

To install Simulink Agentic Toolkit in an offline or air-gapped environment, first download these artifacts on a computer with internet access and transfer them to the target machine or a shared location.

| Artifact | Where to Get It |
|----------|----------------|
| MCP server binary | [Latest release](https://github.com/matlab/matlab-mcp-server/releases/latest) — download the binary for your platform (e.g., `matlab-mcp-server-macos-arm64`, `matlab-mcp-server-windows-x64.exe`) |
| MCP server toolbox | [Latest release](https://github.com/matlab/matlab-mcp-server/releases/latest) — download `MATLABMCPServerToolbox.mltbx` |
| Simulink Agentic Toolkit | Clone or download from [GitHub](https://github.com/matlab/simulink-agentic-toolkit) |
| MATLAB Agentic Toolkit | Clone or download from [GitHub](https://github.com/matlab/matlab-agentic-toolkit) (only needed when installing with `Toolkit="matlab"`)|


After you download these artifacts, run the `setupAgenticToolkit` command in your MATLAB command window with these name-value arguments.

| Argument | Value |
|----------|-----------------|
| `MCPServerLocation` | Path to the MCP server binary download |
| `MCPToolboxLocation` | Path to the MATLAB toolbox (`.mltbx`) download |
| `MATLABAgenticToolkitLocation` | Path to the MATLAB Agentic Toolkit repository clone |
| `SimulinkAgenticToolkitLocation` | Path to the Simulink Agentic Toolkit repository clone |

The installer downloads any artifact you do not provide locally. To prevent internet access and report an error if an artifact is unavailable, set `Offline=true`. For example, use this command to install Simulink Agentic Toolkit from local files.

```matlab
setupAgenticToolkit("install", Offline=true,  ...
    MCPServerLocation="/shared/agentic-toolkits/bin/matlab-mcp-server-linux-x64", ...
    MCPToolboxLocation="/shared/agentic-toolkits/toolboxes/MATLABMCPServerToolbox.mltbx", ...
    SimulinkAgenticToolkitLocation="/shared/agentic-toolkits/simulink-agentic-toolkit")
```

### Automated Setup Configuration

If you use automated setup using the 'setupAgenticToolkit' function, it writes two things: an MCP server configuration (so your agent can talk to MATLAB) and skill registrations (so your agent has Simulink expertise). The details vary by platform.

| Platform | MCP Configuration | Skills Delivery | How To Update Toolkit |
|----------|------------------|-----------------|-------------------|
| Claude Code | `~/.claude.json` (mcpServers) | `claude plugin` system | `setupAgenticToolkit("update")` |
| GitHub Copilot | VS Code user-profile `mcp.json` | `~/.agents/skills/` symlinks | `setupAgenticToolkit("update")` |
| OpenAI Codex | `~/.codex/config.toml` | `~/.agents/skills/` symlinks | `setupAgenticToolkit("update")` |
| Gemini CLI | `~/.gemini/settings.json` | `~/.agents/skills/` symlinks | `setupAgenticToolkit("update")` |
| Sourcegraph Amp | `~/.config/amp/settings.json` | `amp.skills.path` direct ref | `setupAgenticToolkit("update")` |

**How skill delivery works:** Claude Code uses the native `claude plugin` system — setup registers a marketplace and installs plugins automatically. Other platforms discover skills from `~/.agents/skills/` via symbolic links that setup creates pointing to the installed toolkit. When you re-run install, the linked skills update automatically. If new skills are added, re-run configure to create the additional links.

### Platform-Specific Notes

**Claude Code** — Setup writes MCP configuration to `~/.claude.json` and registers skills via the `claude plugin` system (marketplace + plugin install). If the `claude` CLI is not on PATH, setup falls back to skill symlinks in `~/.claude/skills/`.

**GitHub Copilot** — Setup writes global MCP config to the VS Code user-profile `mcp.json` (`~/Library/Application Support/Code/User/mcp.json` on macOS, `~/.config/Code/User/mcp.json` on Linux, `%APPDATA%\Code\User\mcp.json` on Windows) and creates skill symlinks in `~/.agents/skills/`. Reload VS Code after setup completes (Cmd/Ctrl + Shift + P, then "Developer: Reload Window").

**OpenAI Codex** — Setup writes `~/.codex/config.toml`. Skills are installed as global symlinks in `~/.agents/skills/`. After setup, you may want to tune two settings in the `[mcp_servers.matlab]` section of `~/.codex/config.toml`:
- `tool_timeout_sec = 600` — increases the tool timeout from the default (which is too short for many MATLAB operations like test suites and simulations). Increase further for very long-running tasks.
- `env_vars = ['WINDIR']` — **Windows only.** Required for Simulink to work, since Codex strips environment variables from MCP server subprocesses by default.

**Gemini CLI** — Setup writes global config to `~/.gemini/settings.json` and creates skill symlinks in `~/.agents/skills/`. Start a new Gemini session after setup.

**Sourcegraph Amp** — Setup writes to `~/.config/amp/settings.json` using the `amp.` prefix for all keys. Skills load directly from the toolkit via `amp.skills.path` (no symlinks needed). If you have `amp.mcpPermissions` rules that block MCP servers, setup will detect this and ask before making changes.


## Manual Setup Configuration

If you prefer to manage your own MCP server installation and agent configuration, you can set up the toolkit manually following the instructions in the [MATLAB MCP Server](https://github.com/matlab/matlab-mcp-core-server) repository to install the MCP server binary and configure it with your coding agent. For an overview of manual set up, see the [README](README.md).



## Update Simulink Agentic Toolkit

Run the update action in MATLAB to download the latest toolkit and MCP server:

```matlab
setupAgenticToolkit("update")
```

After updating:

1. **Re-run `satk_initialize`** in MATLAB to pick up any tool changes
2. **Restart your agent session** to load updated skills


## Other Setup Actions

The `setupAgenticToolkit` function supports several actions:

| Action | Command | Description |
|--------|---------|-------------|
| Install | `setupAgenticToolkit("install")` | Download MCP server and toolkit files, then configure |
| Configure | `setupAgenticToolkit("configure")` | Set up an agent with MCP and skills |
| Update | `setupAgenticToolkit("update")` | Download latest MCP server and toolkit files |
| Uninstall | `setupAgenticToolkit("uninstall")` | Remove installed toolkits and agent configurations |
| Status | `setupAgenticToolkit("status")` | Show current installation and configuration status |

All actions support `Prompt=false` for non-interactive use.

```matlab
setupAgenticToolkit("install", Toolkit=["matlab", "simulink"], Prompt=false)
setupAgenticToolkit("configure", Agents="claude-code", Scope="global", Prompt=false)
```

 If your organization uses a CLI wrapper, pass `AgentCLI="claude-code=/path/to/wrapper"` during configure.

### Custom Agent CLI Commands

If your organization uses a wrapper or alias for agent CLI binaries, use the `AgentCLI` parameter:

```matlab
setupAgenticToolkit("configure", AgentCLI="claude-code=/usr/local/bin/my-claude-wrapper")
```

The format is `"agent-id=command"`. This override is saved to `config.json` and automatically used for all subsequent actions (configure, uninstall). You only need to specify it once.

> **Note:** Currently only Claude Code uses a CLI during setup (for plugin registration via `claude plugin`). All other agents are configured via file writes and symlinks, so they do not need `AgentCLI`. If the Claude CLI is not found, setup falls back to symlinks automatically.

### Remove Agent Configurations

To remove agent configurations without uninstalling toolkits, run:

```matlab
setupAgenticToolkit("uninstall")
```

Then select **Agent configurations only** from the interactive prompt. This removes MCP config entries and skill registrations while keeping installed toolkits and the MCP server intact. Useful when switching agents or cleaning up stale configurations.

### Disable Data Collection

MATLAB MCP Server collects fully anonymized information about your usage of the server and sends it to MathWorks. This data collection helps MathWorks improve products and is on by default. To opt out of data collection, configure the toolkit with the `DisableTelemetry` option set to `true` by running this command in MATLAB:

```matlab
setupAgenticToolkit("configure", DisableTelemetry=true)
```

This command opts every configured agent out of data collection. This setting is retained when you update to a new version the toolkit with `setupAgenticToolkit("update")`. If you reconfigure the toolkit for your agent(s) by running `setupAgenticToolkit("configure")`, include `DisableTelemetry=true` again to keep data collection disabled.

---

## Troubleshooting
| Problem | Likely Cause | Fix |
|---------|-------------|-----|
| Add-On Manager fails when opening mltbx (`ERR_CERT_AUTHORITY_INVALID` or "Unable to open the requested feature") | CEF/display issue — often caused by corporate proxies, antivirus software, or headless environments | Install programmatically instead: `matlab.addons.toolbox.installToolbox("agenticToolkitInstaller.mltbx")` |
| Agent doesn't list Simulink skills | Skills not registered | Re-run `setupAgenticToolkit("configure")` |
| MCP tools fail with "Undefined function" | `satk_initialize` not run in current MATLAB session | Run `satk_initialize` in MATLAB |
| MCP server can't connect to MATLAB | Connector not running or stale connection | Add `--log-folder` and `--log-level` arguments to your MCP server configuration (see [MATLAB MCP Server arguments](https://github.com/matlab/matlab-mcp-server#arguments)), then run `satk_initialize` again (it calls `shareMATLABSession` automatically). Check the generated logs. |
| macOS blocks the MCP server binary | Gatekeeper quarantine | Right-click → Open, or run: `xattr -d com.apple.quarantine ~/.matlab/agentic-toolkits/bin/matlab-mcp-server` |
| "rmiml.selectionLinkHelper" error | Path corruption from other toolboxes | Run `restoredefaultpath` in MATLAB, then re-run `satk_initialize` |
| `model_test` fails or is unavailable | Simulink Test not installed | Install Simulink Test, or use the other 7 tools which work without it |
| Codex tool calls time out | Default tool timeout too short for MATLAB | Add `tool_timeout_sec = 600` (or higher) to `[mcp_servers.matlab]` in `~/.codex/config.toml` |
| Simulink fails in Codex on Windows | Missing `WINDIR` environment variable | Add `env_vars = ['WINDIR']` to `[mcp_servers.matlab]` in `~/.codex/config.toml` |


## Report Bugs

If you encounter a bug, use the **filing-bug-reports** skill to generate a report before opening a GitHub issue. Ask your agent:

```
File a bug report for this issue
```

The skill automatically captures environment details, reproduction steps, and error output. **Run the skill in the same session where the bug occurred**, because it uses conversation context to reconstruct what happened. Then [open a bug report](https://github.com/matlab/simulink-agentic-toolkit/issues/new?template=bug_report.yml) and paste the generated report.


Copyright 2025-2026 The MathWorks, Inc.

---
