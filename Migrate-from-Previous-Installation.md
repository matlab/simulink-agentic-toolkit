# Migrate from a Previous Installation

Use the [Agentic Toolkit Installer](https://github.com/matlab/agentic-toolkit-installer) to install the Simulink® Agentic Toolkit. The Agentic Toolkit Installer replaces the `setupAgenticToolkit` installer (`agenticToolkitInstaller.mltbx`) and the previous agent-driven setup.

## What the Installer Removes for You

When you run `agentic-toolkit-installer install`, the installer detects previous installations and prompts you to remove them before proceeding with the installation.

The installer can remove:

- The installation created by `setupAgenticToolkit` in `~/.matlab/agentic-toolkits/` (`%USERPROFILE%\.matlab\agentic-toolkits\` on Windows), including its Model Context Protocol (MCP) server binary
- Files created by the previous agent-driven installation workflow, including `~/.simulink-agentic-toolkit/` and the MCP server binary and toolbox under `~/.local/`
- The **MathWorks Agentic Toolkit Setup** and **MATLAB MCP Core Server Toolbox** add-ons from the previous installation
- Previous `matlab` or `simulink` MCP server entries and toolkit plugin marketplaces configured for your coding agents
- Skill symbolic links that reference the previous installation in `~/.agents/skills/`, `~/.claude/skills/`, and `~/.copilot/skills/`

Close your coding agents before you run the installer. On Windows, a running agent can prevent the installer from removing an MCP server binary that is in use.

## What You Still Need to Do

1. **Clean up `startup.m`.** The installer does not edit your files. If you added these lines, remove them:

   ```matlab
   addpath("~/.matlab/agentic-toolkits/simulink")   % or the fullfile(getenv('USERPROFILE'), ...) form
   satk_initialize
   ```

   The toolkit is on the MATLAB path automatically, so you no longer need `satk_initialize`. The function still works and issues a deprecation warning. However, a future release will remove it. If your scripts call `validate_installation`, replace it with `satk_doctor`. Installations from the Agentic Toolkit Installer do not include `validate_installation`.

2. **Remove references from project-level configuration.** If you set up the toolkit for a specific project instead of globally:
   - In the project skill folders (`.agents/skills/`, `.claude/skills/`, or `.github/skills/`), remove links that reference the previous installation.
   - In the project MCP configuration files (`.mcp.json` for Claude Code, `.vscode/mcp.json` for GitHub Copilot in VS Code), remove the previous `matlab` server entry. Otherwise, your agent can list the MCP server twice or connect to the previous installation.

3. **Delete an old toolkit clone.** If you cloned the Simulink Agentic Toolkit repository only to set up the toolkit, delete the clone.

4. **Restart MATLAB and your agents, and then run `satk_doctor` in MATLAB.** Review the diagnostic results for references to the previous `setupAgenticToolkit` installation.

> **Tip:** Ask your coding agent to search your home folder for any remaining references to the old setup (for example, `matlab-mcp-core-server`, `agentic-toolkits`, or `.local/bin`) to catch anything left over.

---

Copyright 2025-2026 The MathWorks, Inc.
