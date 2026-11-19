# Configuration and Troubleshooting
This page shows you how to configure and troubleshoot the Simulink® Agentic Toolkit. For an overview of the Simulink Agentic Toolkit, see the [README](README.md).

## Installation and Configuration

Use the [Agentic Toolkit Installer](https://github.com/matlab/agentic-toolkit-installer) to install and configure the toolkit.

See the installer README for information about:

- Checking requirements, including supported MATLAB versions, platforms, and AI coding agents
- Configuring coding agents, toolkits, skill groups, scope, and Model Context Protocol (MCP) settings
- Viewing a summary of your configuration (`status`) and making changes to your configuration (`configure`)
- Uninstalling the toolkit and agent configuration (`uninstall`)
- Running the installer programmatically
- Pinning toolkit versions and using environment variables
- Configuring proxies and mirrors and authenticating with private repositories
- Disabling data collection (`--disable-telemetry`)

After installation or configuration changes, restart your agent to begin using the updated configuration with MATLAB and Simulink.

### Check Your Installation

Run this in MATLAB:

```matlab
satk_doctor
```

`satk_doctor` prints a health check and returns the results as YAML. It checks what only MATLAB can see and reports:

- The folder that the toolkit's MATLAB tools run from
- Files remaining from a previous `setupAgenticToolkit` installation
- MATLAB path configuration, including missing tools, packages, or path conflicts
- MATLAB MCP Server Toolbox installation and MATLAB session sharing status

To check installed toolkit versions, configured agents, and the MCP server, run the installer's `status` command in a terminal, from the folder where you downloaded the installer:

```
./agentic-toolkit-installer status        # Linux and macOS
.\agentic-toolkit-installer.exe status    # Windows
```

### MATLAB Sessions

The installer configures the MCP server to automatically connect to a shared MATLAB session if one is available. Otherwise, the server starts a new MATLAB session. To use an existing MATLAB session with your agent and retain its current workspace and loaded models, run the following command in that MATLAB session:

```matlab
shareMATLABSession
```

### Agent-Specific Notes

**GitHub Copilot in VS Code** — Reload VS Code after configuring (Cmd/Ctrl + Shift + P, then "Developer: Reload Window").

**OpenAI Codex** — You can tune the tool timeout in the `[mcp_servers.matlab]` section of `~/.codex/config.toml`:
- `tool_timeout_sec = 600` — increases the tool timeout from the default, which is too short for many MATLAB operations, such as test suites and simulations. For longer-running tasks, increase the value further.

---

## Troubleshooting
| Problem | Likely Cause | Fix |
|---------|-------------|-----|
| Installation, update, or agent configuration fails | Installer issue | See the [Agentic Toolkit Installer](https://github.com/matlab/agentic-toolkit-installer) known issues, or run `agentic-toolkit-installer status --verbose` |
| Agent does not list Simulink skills | Skills not registered, or the agent session predates the install | Run `agentic-toolkit-installer configure`, then restart your agent |
| MCP tools or `satk_doctor` fail with "Undefined function" | Simulink Agentic Toolkit is not installed | Run `agentic-toolkit-installer install`, then restart MATLAB |
| MCP server cannot connect to MATLAB | MATLAB MCP Server Toolbox missing, or stale connection | Run `satk_doctor` in MATLAB and `agentic-toolkit-installer status` in a terminal. Add `--log-folder` and `--log-level` arguments to your MCP server configuration (see [MATLAB MCP Server arguments](https://github.com/matlab/matlab-mcp-server#arguments)) and check the logs |
| `satk_initialize` or `validate_installation` prints a deprecation warning, or `validate_installation` is undefined | Leftover call from the previous setup workflow. `satk_initialize` still works, but a future release will remove it. Installations from the Agentic Toolkit Installer do not include `validate_installation` | Remove `satk_initialize` (and any `addpath` to `~/.matlab/agentic-toolkits`) from your `startup.m` and scripts. Replace `validate_installation` with `satk_doctor` |
| `satk_doctor` warns about legacy `setupAgenticToolkit` files | Files from an earlier installation remain | See [Migrate from a Previous Installation](Migrate-from-Previous-Installation.md) |
| macOS blocks the MCP server binary | Gatekeeper quarantine | Run `xattr -d com.apple.quarantine "<path>"`, using the MCP server binary path that `agentic-toolkit-installer status --verbose` reports |
| "rmiml.selectionLinkHelper" error | Path corruption from other toolboxes | Run `restoredefaultpath` in MATLAB, then restart MATLAB |
| `model_test` fails or is unavailable | Simulink Test not installed | Install Simulink Test, or use the other tools, which work without it |
| Codex tool calls time out | Default tool timeout too short for MATLAB | Add `tool_timeout_sec = 600` (or higher) to `[mcp_servers.matlab]` in `~/.codex/config.toml` |


## Report Bugs

If you encounter a bug, use the **filing-bug-reports** skill to generate a report before opening a GitHub issue. Ask your agent:

```
File a bug report for this issue
```

The skill automatically captures environment details, reproduction steps, and error output. **Run the skill in the same session where the bug occurred**, because it uses conversation context to reconstruct what happened. Then [open a bug report](https://github.com/matlab/simulink-agentic-toolkit/issues/new?template=bug_report.yml) and paste the generated report.


Copyright 2025-2026 The MathWorks, Inc.

---
