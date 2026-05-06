# Getting Started with the Simulink® Agentic Toolkit

Give your AI coding agent the ability to read, build, edit, and test Simulink models using Model-Based Design best practices.

This guide takes you from download to your first agent-driven model interaction. By the end, your agent will read the structure of a real Simulink model and answer questions about it.

> For a project overview, tool/skill reference, and documentation links, see the [README](README.md).

> Automated setup has been verified with basic workflows on Claude Code, Sourcegraph Amp, Gemini CLI, and OpenAI Codex. Other platforms are provided as-is and currently untested. Please [report issues](https://github.com/matlab/simulink-agentic-toolkit/issues) if you encounter problems.

---

## Contents

- [Prerequisites](#prerequisites)
- [Choose Your Path](#choose-your-path)
- [Automated Setup (Recommended)](#automated-setup-recommended)
- [Manual Setup](#manual-setup)
- [Migrating from a Previous Installation](#migrating-from-a-previous-installation)
- [Verification](#verification)
- [Updating](#updating)
- [Other Setup Actions](#other-setup-actions)
- [Reporting Bugs](#reporting-bugs)
- [Troubleshooting](#troubleshooting)
- [Server Modes](#server-modes)

---

## Prerequisites

Before you begin, make sure you have:

- [ ] **MATLAB® R2023a or later** with **Simulink®** installed
- [ ] **An AI coding agent** that supports MCP — see [Supported Platforms](#how-configuration-works-per-platform)
- [ ] *(Optional)* **Simulink Test** — required only for the `model_test` tool. Everything else works without it.

### AI Model Capability Guidance

This toolkit relies on strong multi-step reasoning, tool use, and coding performance from the AI model.

We have tested the toolkit with higher-capability models, including Claude Opus and Sonnet, OpenAI GPT-5 models, and Gemini Pro models, and have generally seen good results on demanding workflows.

Model capability has a significant impact on quality. In our testing, lightweight or lower-capability models were less reliable for tasks such as model construction and complex edits, and were more likely to produce incomplete or incorrect results. These models may still be sufficient for simpler tasks, but for the best overall experience we recommend using a higher-capability model.

---

## Choose Your Path

| Path | When to use |
|------|-------------|
| [**Automated Setup**](#automated-setup-recommended) *(recommended)* | First time; want everything handled for you |
| [**Manual Setup**](#manual-setup) | You already have the MCP server or want full control over configuration |

---

## Automated Setup (Recommended)

The `setupAgenticToolkit` function handles everything: downloading the MCP server binary, installing toolkit files, configuring your AI coding agent, and registering skills. It supports both the **MATLAB Agentic Toolkit** and **Simulink Agentic Toolkit**, and provides `install`, `update`, `configure`, and `uninstall` actions.

### What Setup Does

1. **Installs the MCP server** — downloads the [MATLAB MCP Core Server](https://github.com/matlab/matlab-mcp-core-server) binary and toolkit files to `~/.matlab/agentic-toolkits/` (`%USERPROFILE%\.matlab\agentic-toolkits\` on Windows), then runs `--setup-matlab` to install the MATLAB MCP Core Server Toolbox (one-time per MATLAB version)
2. **Configures your agent** — writes an MCP server entry to your agent's local configuration file (e.g., `~/.claude.json` for Claude Code, `~/.codex/config.toml` for Codex — see [per-platform details](#how-configuration-works-per-platform) for the full list)
3. **Registers skills** — creates skill symlinks or configures skill paths for your agent platform

Setup is re-runnable. Run it again to update the binary, switch MATLAB versions, add another agent, or fix a broken configuration.

### Step 1: Install the Setup Add-On

Download `agenticToolkitInstaller.mltbx` from the [GitHub release](https://github.com/matlab/simulink-agentic-toolkit/releases) and double-click it in MATLAB to install via the Add-On Manager. If the Add-On Manager fails to launch (common on headless machines or older MATLAB versions), install programmatically:

```matlab
matlab.addons.toolbox.installToolbox("agenticToolkitInstaller.mltbx")
```

After installing, `setupAgenticToolkit` is automatically on your path.

### Step 2: Install and Configure

In MATLAB, run:

```matlab
setupAgenticToolkit("install")
```

The installer walks you through:
1. Selecting which toolkits to install (MATLAB, Simulink, or both)
2. Downloading the MCP server binary and toolkit files from GitHub releases
3. Selecting which agent to configure (Claude Code, Copilot, Codex, Amp, Gemini CLI)
4. Choosing scope (global or project-level)
5. Selecting which installed toolkits to enable for this configuration

To set up additional agents or add project-level configurations later, run `setupAgenticToolkit("configure")` separately.

### Step 3: Configure MATLAB

The Simulink Agentic Toolkit connects to a **running MATLAB session**. Each MATLAB session, add the toolkit to the path and share the session:

```matlab
addpath("~/.matlab/agentic-toolkits/simulink")
satk_initialize
```

This does three things:

1. Adds the toolkit's tool directories to the MATLAB path
2. Calls `shareMATLABSession` (so the MCP server can connect to this MATLAB session)
3. Runs `validate_installation` to check that everything is configured correctly

The MATLAB-side MCP components are installed automatically during `setupAgenticToolkit("install")` by running the MCP server binary with `--setup-matlab`. **Restart MATLAB after the first install** (or after upgrading MATLAB) so the new components are on the path. If you need to run this manually, use:

```bash
~/.matlab/agentic-toolkits/bin/matlab-mcp-core-server --setup-matlab --matlab-root=/path/to/MATLAB/R20XXx
```

Replace `/path/to/MATLAB/R20XXx` with your MATLAB installation path (e.g., `/usr/local/MATLAB/R2025a`). On Windows, use `%USERPROFILE%\.matlab\agentic-toolkits\bin\matlab-mcp-core-server.exe`.

> **Note:** `satk_initialize` must run once per MATLAB session. To automate this, add the following to your [`startup.m`](https://www.mathworks.com/help/matlab/ref/startup.html):
>
> ```matlab
> % Initialize the Simulink Agentic Toolkit (adjust version/path as needed)
> if contains(version, 'R2026a')
>     addpath("~/.matlab/agentic-toolkits/simulink")
>     satk_initialize
> end
> ```

> **Important:** After running `satk_initialize`, you must **restart your coding agent session** (or reload your VS Code window for Copilot) so the MCP server picks up the MATLAB session. The MCP server connects to MATLAB at startup — if MATLAB wasn't shared when the agent session started, the connection won't exist until the agent restarts.

### Step 4: Start Your Agent and Verify

Start a **new agent session in any project directory** — Simulink tools and skills are available everywhere.

Open any Simulink model in MATLAB — your own, or a shipped example like `f14`:

```matlab
openExample("simulink/AddBlockToModelFromLibraryExample")       % only needed for R2023b+
open_system("f14")
```

Then ask your agent:

```
Describe the structure of the currently open model.
```

The agent calls `model_overview` and `model_read` via MCP, reads the model hierarchy from MATLAB, and describes the subsystems, connections, and what the model does.

### How Configuration Works per Platform

Setup writes two things: an MCP server configuration (so your agent can talk to MATLAB) and skill registrations (so your agent has Simulink expertise). The details vary by platform.

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

---

## Manual Setup

If you prefer to manage your own MCP server installation and agent configuration, you can set up the toolkit manually. You are responsible for ensuring all components are configured correctly.

### Step 1: Install and Configure the MATLAB MCP Core Server

Follow the instructions in the [MATLAB MCP Core Server](https://github.com/matlab/matlab-mcp-core-server) repository to install the MCP server binary and configure it with your coding agent.

### Step 2: Install MATLAB-Side Components

Run the MCP server binary with the `--setup-matlab` command to install the MATLAB-side toolbox:

```bash
matlab-mcp-core-server --setup-matlab --matlab-root=/path/to/MATLAB/R20XXx
```

This is a one-time step per MATLAB version.

### Step 3: Add Toolkit Flags to Your MCP Server Configuration

In your agent's MCP server configuration, add the following flags to the server command:

```
--matlab-session-mode=existing
--extension-file=/path/to/simulink-agentic-toolkit/tools/tools.json
```

| Flag | Purpose |
|------|---------|
| `--matlab-session-mode=existing` | Attaches to a running MATLAB session instead of launching a new one (required for Simulink workflows) |
| `--extension-file` | Points to the toolkit's tool definitions — this is what gives your agent access to `model_edit`, `model_read`, etc. |

> **Note:** `--matlab-root` and `--matlab-session-mode=existing` are mutually exclusive. Use `--matlab-root` only when *not* using `--matlab-session-mode=existing` (see [Server Modes](#server-modes)).

The exact location where you add these flags depends on your agent platform — see [How Configuration Works per Platform](#how-configuration-works-per-platform).

### Step 3: Register Skills

Skills teach your agent MBD best practices. Point your agent's skill or prompt directory at `skills-catalog/model-based-design-core/`. Each skill is a self-contained `SKILL.md` with a `manifest.yaml`.

For platforms that discover skills from `~/.agents/skills/`, create symlinks:

```bash
mkdir -p ~/.agents/skills
for skill in /path/to/simulink-agentic-toolkit/skills-catalog/model-based-design-core/*/; do
  ln -s "$skill" ~/.agents/skills/$(basename "$skill")
done
```

### Step 4: Initialize MATLAB

Each MATLAB session, add the toolkit to the path and share the session:

```matlab
addpath("/path/to/simulink-agentic-toolkit")
satk_initialize
```

Then restart your coding agent session so the MCP server picks up the MATLAB connection.

---

## Migrating from a Previous Installation

If you set up the toolkit using an earlier version (the agent-driven "Set up the Simulink Agentic Toolkit" workflow), you should clean up the old installation before using `setupAgenticToolkit`. The old workflow installed files to different locations that the new setup script does not manage.

### What to Remove

1. **Old toolkit data folder** — delete `~/.simulink-agentic-toolkit/` (macOS/Linux) or `%USERPROFILE%\.simulink-agentic-toolkit\` (Windows). This was the data directory used by the old agent-driven setup.

2. **MCP server binary** — delete `~/.matlab/agentic-toolkits/bin/matlab-mcp-core-server` (macOS/Linux) or `%USERPROFILE%\.matlab\agentic-toolkits\bin\matlab-mcp-core-server.exe` (Windows)

3. **MCP Add-On** — delete `~/.local/share/MATLABMCPCoreServerToolkit.mltbx` (macOS/Linux) or `%USERPROFILE%\.local\share\MATLABMCPCoreServerToolkit.mltbx` (Windows). If you already installed the toolbox in MATLAB, you can uninstall it via `matlab.addons.uninstall` — the new setup uses `--setup-matlab` to handle this automatically.

4. **Agent MCP configuration** — remove the old `matlab` or `simulink` MCP server entry from your agent's config file. Your config should **not** reference any of the paths above. The location depends on your platform:
   - Claude Code: `~/.claude.json` (remove the entry from `mcpServers`)
   - GitHub Copilot: VS Code user-profile `mcp.json` (remove the `matlab` or `simulink` server)
   - OpenAI Codex: `~/.codex/config.toml` (remove `[mcp_servers.matlab]` or `[mcp_servers.simulink]`)
   - Gemini CLI: `~/.gemini/settings.json` (remove the `mcpServers` entry)
   - Sourcegraph Amp: `~/.config/amp/settings.json` (remove `amp.mcpServers.matlab` or `amp.mcpServers.simulink`)

5. **Skill symlinks** — remove old symlinks from `~/.agents/skills/` and `~/.claude/skills/` that point into your old toolkit clone

6. **Old toolkit clone** — if you cloned the repository just for setup and no longer need it as a reference, you can delete it. The new setup script downloads toolkit files to `~/.matlab/agentic-toolkits/`.

After cleaning up, follow the [Automated Setup](#automated-setup-recommended) instructions above.

---

## Verification

### Check that skills are loaded

If your agent shows loaded skills or plugins in its UI (e.g., Claude Code's `/skills` command), confirm the Simulink Agentic Toolkit skills are listed:

| Skill | Description |
|-------|-------------|
| **building-simulink-models** | Best practices for structural model changes |
| **filing-bug-reports** | Generate standalone bug reports for reproducing and fixing issues |
| **simulating-simulink-models** | Run simulations for data exploration, parameter sweeps, and custom analysis |
| **specifying-mbd-algorithms** | Specify algorithms for MBD — system specs, architecture specs, implementation and test plans |
| **specifying-plant-models** | Specify plant models for closed-loop simulation |
| **testing-simulink-models** | Test Simulink model behavior |
| **generate-requirement-drafts** | Requirements generation (Requirements Toolbox or structured YAML) |

### Try it out

Open any Simulink model in MATLAB — your own, or a shipped example like `f14`:

```matlab
openExample("simulink/AddBlockToModelFromLibraryExample")       % only needed for R2023b+
open_system("f14")
```

Then ask your agent:

```
Describe the structure of the currently open model.
```

### More examples

```
Find the gain block in f14 that uses the parameter Kf, and tell me what value it resolves to.
```

```
Save a copy of f14 as f14_agent_demo.slx, then add a Scope block connected
to the output of the Actuator Model subsystem.
```

---

## Updating

Run the update action in MATLAB to download the latest toolkit and MCP server:

```matlab
setupAgenticToolkit("update")
```

After updating:

1. **Re-run `satk_initialize`** in MATLAB to pick up any tool changes
2. **Restart your agent session** to load updated skills

---

## Other Setup Actions

The `setupAgenticToolkit` function supports several actions:

| Action | Command | Description |
|--------|---------|-------------|
| Install | `setupAgenticToolkit("install")` | Download MCP server and toolkit files, then configure |
| Configure | `setupAgenticToolkit("configure")` | Set up an agent with MCP and skills |
| Update | `setupAgenticToolkit("update")` | Download latest MCP server and toolkit files |
| Uninstall | `setupAgenticToolkit("uninstall")` | Remove installed toolkits and agent configurations |
| Status | `setupAgenticToolkit("status")` | Show current installation and configuration status |

All actions support `Prompt=false` for non-interactive use:

```matlab
setupAgenticToolkit("install", Toolkit=["matlab", "simulink"], Prompt=false)
setupAgenticToolkit("configure", Agents="claude-code", Scope="global", Prompt=false)
```

### Custom Agent CLI Commands

If your organization uses a wrapper or alias for agent CLI binaries, use the `AgentCLI` parameter:

```matlab
setupAgenticToolkit("configure", AgentCLI="claude-code=/usr/local/bin/my-claude-wrapper")
```

The format is `"agent-id=command"`. This override is saved to `config.json` and automatically used for all subsequent actions (configure, uninstall) — you only need to specify it once.

> **Note:** Currently only Claude Code uses a CLI during setup (for plugin registration via `claude plugin`). All other agents are configured via file writes and symlinks, so they do not need `AgentCLI`. If the Claude CLI is not found, setup falls back to symlinks automatically.

### Removing Agent Configurations

To remove agent configurations without uninstalling toolkits, run:

```matlab
setupAgenticToolkit("uninstall")
```

Then select **Agent configurations only** from the interactive prompt. This removes MCP config entries and skill registrations while keeping installed toolkits and the MCP server intact. Useful when switching agents or cleaning up stale configurations.

---

## Reporting Bugs

If you run into a bug, use the **filing-bug-reports** skill to generate a report. Ask your agent:

```
File a bug report for this issue
```

The skill captures environment details, reproduction steps, and error output automatically. **Be sure to use it in the same chat session where the bug occurred.** If the issue did not occur in a chat session, describe the issue as best you can to the agent, then ask it to file a bug report.
Then [open a bug report](https://github.com/mathworks/simulink-agentic-toolkit/issues/new?template=bug_report.yml) and paste the generated report in the form.

---

## Troubleshooting

| Problem | Likely Cause | Fix |
|---------|-------------|-----|
| Add-On Manager fails when opening mltbx | CEF/display issue on headless or older MATLAB | Install programmatically: `matlab.addons.toolbox.installToolbox("agenticToolkitInstaller.mltbx")` |
| Agent doesn't list Simulink skills | Skills not registered | Re-run `setupAgenticToolkit("configure")` |
| MCP tools fail with "Undefined function" | `satk_initialize` not run in current MATLAB session | Run `satk_initialize` in MATLAB |
| MCP server can't connect to MATLAB | Connector not running or stale connection | Run `satk_initialize` again (it calls `shareMATLABSession` automatically) |
| macOS blocks the MCP server binary | Gatekeeper quarantine | Right-click → Open, or run: `xattr -d com.apple.quarantine ~/.matlab/agentic-toolkits/bin/matlab-mcp-core-server` |
| "rmiml.selectionLinkHelper" error | Path corruption from other toolboxes | Run `restoredefaultpath` in MATLAB, then re-run `satk_initialize` |
| `model_test` fails or is unavailable | Simulink Test not installed | Install Simulink Test, or use the other 6 tools which work without it |
| Codex tool calls time out | Default tool timeout too short for MATLAB | Add `tool_timeout_sec = 600` (or higher) to `[mcp_servers.matlab]` in `~/.codex/config.toml` |
| Simulink fails in Codex on Windows | Missing `WINDIR` environment variable | Add `env_vars = ['WINDIR']` to `[mcp_servers.matlab]` in `~/.codex/config.toml` |

---

## Server Modes

The MATLAB MCP Core Server supports two modes:

### Attach Mode (Recommended)

```
--matlab-session-mode=existing
```

Connects to your running MATLAB session. Preserves your workspace, loaded models, and path configuration. Requires `shareMATLABSession` called in MATLAB (handled by `satk_initialize`). The MCP add-on is installed automatically on first connection.

### Launch Mode

The default mode (no `--matlab-session-mode` flag). Starts a new MATLAB instance. Simpler to set up but state is lost when the server restarts. Use `--matlab-root=/path/to/MATLAB/R20XXx` to specify the MATLAB installation path.

> **Note:** `--matlab-root` is only valid in launch mode. The server will reject it if combined with `--matlab-session-mode=existing`.

---

Copyright 2025-2026 The MathWorks, Inc.

---

MATLAB and Simulink are registered trademarks of The MathWorks, Inc. See [mathworks.com/trademarks](https://www.mathworks.com/trademarks) for a list of additional trademarks. Other product or brand names may be trademarks or registered trademarks of their respective holders.
