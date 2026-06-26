# Migrate from a Previous Installation

If you set up the Simulink® Agentic Toolkit using an earlier version (the agent-driven "Set up the Simulink Agentic Toolkit" workflow), you should clean up the old installation before using `setupAgenticToolkit`. The old workflow installed files to different locations that the new setup script does not manage.

### What to Remove

1. **Old toolkit data folder** — delete `~/.simulink-agentic-toolkit/` (macOS/Linux) or `%USERPROFILE%\.simulink-agentic-toolkit\` (Windows). This was the data directory used by the old agent-driven setup.

2. **MCP server binary** — delete `~/.matlab/agentic-toolkits/bin/matlab-mcp-server` (macOS/Linux) or `%USERPROFILE%\.matlab\agentic-toolkits\bin\matlab-mcp-server.exe` (Windows). Some earlier versions installed the binary as `matlab-mcp-core-server` or to `~/.local/bin/` or `%USERPROFILE%\.local\bin\` — check both locations and names.

3. **MCP Add-On** — delete `~/.local/share/MATLABMCPCoreServerToolbox.mltbx` (macOS/Linux) or `%USERPROFILE%\.local\share\MATLABMCPCoreServerToolbox.mltbx` (Windows). If you already installed the toolbox in MATLAB, you can uninstall it via `matlab.addons.uninstall` or manually through the Add-On Manager — the new setup uninstalls any previous copy automatically before installing the latest `.mltbx`. (The toolbox was previously named "MATLAB MCP Core Server Toolbox" and is now "MATLAB MCP Server Toolbox".)

4. **Agent MCP configuration** — remove the old `matlab` or `simulink` MCP server entry from your agent's config file. Your config should **not** reference any of the paths above. The location depends on your platform:
   - Claude Code: `~/.claude.json` (`%USERPROFILE%\.claude.json` on Windows) — remove the entry from `mcpServers`
   - GitHub Copilot: VS Code user-profile `mcp.json` (remove the `matlab` or `simulink` server). File location: `~/Library/Application Support/Code/User/mcp.json` (macOS), `~/.config/Code/User/mcp.json` (Linux), `%APPDATA%\Code\User\mcp.json` (Windows)
   - OpenAI Codex: `~/.codex/config.toml` (remove `[mcp_servers.matlab]` or `[mcp_servers.simulink]`)
   - Gemini CLI: `~/.gemini/settings.json` (remove the `mcpServers` entry)
   - Sourcegraph Amp: `~/.config/amp/settings.json` (remove `amp.mcpServers.matlab` or `amp.mcpServers.simulink` **and** `amp.skills.path`)

5. **Skill registrations** — remove old symlinks from `~/.agents/skills/` and `~/.claude/skills/` that point into your old toolkit clone. For Amp, also remove the `amp.skills.path` entry in `~/.config/amp/settings.json` if it references your old toolkit path.

6. **Old toolkit clone** — if you cloned the repository just for setup and no longer need it as a reference, you can delete it. The new setup script downloads toolkit files to `~/.matlab/agentic-toolkits/`.

> **Tip:** After removing the items above, you can ask your coding agent to search your home directory for any remaining references to the old toolkit (e.g., "matlab-mcp", "simulink-agentic-toolkit", or old paths like `.local/bin`) to catch anything we missed.

After cleaning up, follow the [Automated Setup](README.md#install-simulink-agentic-toolkit-automated-setup) instructions in the README.

---
