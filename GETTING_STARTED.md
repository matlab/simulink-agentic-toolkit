# Getting Started with the Simulink® Agentic Toolkit

Give your AI coding agent the ability to read, build, edit, and test Simulink models using Model-Based Design best practices.

This guide takes you from download to your first agent-driven model interaction. By the end, your agent will read the structure of a real Simulink model and answer questions about it.

> For a project overview, tool/skill reference, and documentation links, see the [README](README.md).

> Automated setup has been verified with basic workflows on Claude Code, Sourcegraph Amp, Gemini CLI, and OpenAI Codex. Other platforms are provided as-is and currently untested. Please [report issues](https://github.com/mathworks/simulink-agentic-toolkit/issues) if you encounter problems.

---

## Prerequisites

Before you begin, make sure you have:

- [ ] **MATLAB® R2023a or later** with **Simulink®** installed
- [ ] **An AI coding agent** that supports MCP — see [Supported Platforms](#how-configuration-works-per-platform)
- [ ] **Git™** (to clone the toolkit)
- [ ] *(Optional)* **Simulink Test** — required only for the `model_test` tool. Everything else works without it.

### AI Model Capability Guidance

This toolkit relies on strong multi-step reasoning, tool use, and coding performance from the AI model.

We have tested the toolkit with higher-capability models, including Claude Opus and Sonnet, OpenAI GPT-5 models, and Gemini Pro models, and have generally seen good results on demanding workflows.

Model capability has a significant impact on quality. In our testing, lightweight or lower-capability models were less reliable for tasks such as model construction and complex edits, and were more likely to produce incomplete or incorrect results. These models may still be sufficient for simpler tasks, but for the best overall experience we recommend using a higher-capability model.

---

## Choose Your Path

| Path | When to use | What you get |
|------|-------------|--------------|
| [**Full Setup**](#full-setup) | First time; want everything automated | MCP server binary + skills + global configuration |
| [**Adding Skills Only**](#adding-skills-only) | Already have the MCP server configured | Skills/prompts only; no MCP changes |

---

## Full Setup

Full setup clones the toolkit repository, then uses your agent to automate the entire configuration. This is the recommended path for first-time users.

### What Setup Does

1. **Installs the MCP server** — downloads the [MATLAB MCP Core Server](https://github.com/matlab/matlab-mcp-core-server) binary to `~/.local/bin/` (`%USERPROFILE%\.local\bin\` on Windows) and toolbox to `~/.local/share/`
2. **Configures your agent** — connects the MCP server to your agent via global config
3. **Registers skills** — adds Simulink skills via the platform's native plugin system or global skill links
4. **Verifies** — confirms the MCP server can reach MATLAB and Simulink, and reports an environment summary

Setup is re-runnable. Run it again to update the binary, switch MATLAB versions, or fix a broken configuration.

### Step 1: Clone and Launch

Clone the toolkit to a permanent location outside your project directories (e.g., `~/tools/` or `~/repos/`). Most platforms reference this clone via symbolic links, so the toolkit needs to stay in place after setup.

```
git clone https://github.com/mathworks/simulink-agentic-toolkit.git
cd simulink-agentic-toolkit
```

Then launch your agent:

| Platform | Launch command |
|----------|---------------|
| Claude Code | `claude` |
| OpenAI Codex | `codex` |
| Gemini CLI | `gemini` |
| GitHub Copilot | Open folder in VS Code, then start Copilot chat |
| Sourcegraph Amp | `amp` |
| Cursor | Open folder in Cursor |

### Step 2: Run Setup

Ask your agent:

```
Set up the Simulink Agentic Toolkit
```

The setup skill walks you through detection, planning, and execution. It presents all decisions (which MATLAB to use, etc.) before making any changes.

### Step 3: Configure MATLAB

The Simulink Agentic Toolkit connects to a **running MATLAB session**. Two things are needed:

**One-time per MATLAB version** — install the MCP toolbox (provides `shareMATLABSession`). The setup skill downloads this to `~/.local/share/` (`%USERPROFILE%\.local\share\` on Windows):

```matlab
matlab.addons.install("~/.local/share/MATLABMCPCoreServerToolkit.mltbx")
```

**Each MATLAB session** — add the toolkit to the path and share the session:

```matlab
addpath("/path/to/simulink-agentic-toolkit")
satk_initialize
```

This does three things:

1. Adds the toolkit's tool directories to the MATLAB path
2. Calls `shareMATLABSession` (so the MCP server can connect to this MATLAB session)
3. Runs `validate_installation` to check that everything is configured correctly

> **Note:** `satk_initialize` must run once per MATLAB session. To automate this, add the `addpath` and `satk_initialize` lines to your [`startup.m`](https://www.mathworks.com/help/matlab/ref/startup.html).

> **Important:** After running `satk_initialize`, you must **restart your coding agent session** (or reload your VS Code window for Copilot/Cursor) so the MCP server picks up the MATLAB session. The MCP server connects to MATLAB at startup — if MATLAB wasn't shared when the agent session started, the connection won't exist until the agent restarts.

### Step 4: Start Your Agent and Verify

Start a **new agent session in any project directory** — Simulink tools and skills are available everywhere.

Ask your agent:

```
Open the Simulink model f14 and describe its structure.
```

The agent calls `model_overview` and `model_read` via MCP, reads the model hierarchy from MATLAB, and describes the subsystems, connections, and what the model does.

> **Tip:** After the first setup, you can re-run setup at any time to update the binary, switch MATLAB versions, or fix a broken configuration. Ask "Set up the Simulink Agentic Toolkit" from the toolkit directory.

### How Configuration Works per Platform

Setup writes two things: an MCP server configuration (so your agent can talk to MATLAB) and skill registrations (so your agent has Simulink expertise). The details vary by platform.

| Platform | MCP Configuration | Skills Delivery | How To Update Toolkit |
|----------|------------------|-----------------|-------------------|
| Claude Code | `claude mcp add-json` (user scope) | Plugin cache | Re-run setup or reinstall plugin |
| GitHub Copilot | `~/.vscode/settings.json` | `~/.agents/skills/` symlinks | `git pull` in toolkit repo, re-run setup |
| OpenAI Codex | `~/.codex/config.toml` | `~/.agents/skills/` symlinks | `git pull` in toolkit repo, re-run setup |
| Gemini CLI | `~/.gemini/settings.json` | `~/.agents/skills/` symlinks | `git pull` in toolkit repo, re-run setup |
| Sourcegraph Amp | `~/.config/amp/settings.json` | `amp.skills.path` direct ref | `git pull` in toolkit repo, re-run setup |
| Cursor | `~/.cursor/mcp.json` | `.cursor-plugin/` discovery | Manual |

**How skill symlinks work:** Most platforms discover skills from `~/.agents/skills/`. Setup creates symbolic links from that directory to the individual skill directories in your toolkit clone. When you run `git pull`, the linked skills update automatically. If new skills are added to the toolkit, re-run setup to create the additional symlinks.

### Platform-Specific Notes

**Claude Code** — Setup registers the toolkit via the plugin marketplace and registers the MCP server using `claude mcp add-json` at user scope. Skills are cached by the plugin system.

**GitHub Copilot** — Setup writes global MCP config to `~/.vscode/settings.json` and creates skill symlinks in `~/.agents/skills/`. Reload VS Code after setup completes (Cmd/Ctrl + Shift + P, then "Developer: Reload Window").

**OpenAI Codex** — Setup uses `codex mcp add` if available, otherwise writes `~/.codex/config.toml` directly. Skills are installed as global symlinks in `~/.agents/skills/`. After setup, you may want to tune two settings in the `[mcp_servers.simulink]` section of `~/.codex/config.toml`:
- `tool_timeout_sec = 600` — increases the tool timeout from the default (which is too short for many MATLAB operations like test suites and simulations). Increase further for very long-running tasks.
- `env_vars = ['WINDIR']` — **Windows only.** Required for Simulink to work, since Codex strips environment variables from MCP server subprocesses by default.

**Gemini CLI** — Setup writes global config to `~/.gemini/settings.json` and creates skill symlinks in `~/.agents/skills/`. Start a new Gemini session after setup.

**Sourcegraph Amp** — Setup writes to `~/.config/amp/settings.json` using the `amp.` prefix for all keys. Skills load directly from the toolkit via `amp.skills.path` (no symlinks needed). If you have `amp.mcpPermissions` rules that block MCP servers, setup will detect this and ask before making changes.

**Cursor** — Setup writes `~/.cursor/mcp.json`. If automation fails, create `~/.cursor/mcp.json` manually with the Simulink MCP entry. Cursor is the only platform without automated setup verification — this configuration is **untested and provided as-is**.

---

<a id="adding-skills-only"></a>
## Adding Skills Only

If you already have the [MATLAB MCP Core Server](https://github.com/matlab/matlab-mcp-core-server) installed and configured, you only need skills.

### Claude Code

Add skills directly via the plugin marketplace:

```bash
claude plugin marketplace add "https://github.com/mathworks/simulink-agentic-toolkit"
claude plugin install model-based-design-core@simulink-agentic-toolkit
```

Choose your preferred scope (per-project, per-user, or global) when prompted. Your existing MCP configuration is not modified.

> To also get the setup skill (for managing the MCP server later), additionally run:
> `claude plugin install toolkit@simulink-agentic-toolkit`

### Other Platforms

Point your agent's skill or prompt directory at `skills-catalog/model-based-design-core/`. Each skill is a self-contained `SKILL.md` with a `manifest.yaml`.

For platforms that discover skills from `~/.agents/skills/`, create symlinks:

```bash
mkdir -p ~/.agents/skills
for skill in /path/to/simulink-agentic-toolkit/skills-catalog/model-based-design-core/*/; do
  ln -s "$skill" ~/.agents/skills/$(basename "$skill")
done
```

Replace `/path/to/simulink-agentic-toolkit` with the actual path to your toolkit clone.

---

## Verification

### Check that skills are loaded

If your agent shows loaded skills or plugins in its UI (e.g., Claude Code's `/skills` command), confirm the Simulink Agentic Toolkit skills are listed:

| Skill | Description |
|-------|-------------|
| **building-simulink-models** | Best practices for structural model changes |
| **filing-bug-reports** | Generate standalone bug reports for reproducing and fixing issues |
| **simulink-agentic-toolkit-setup** | Install and configure the toolkit, install MCP server |
| **specifying-mbd-algorithms** | Specify algorithms for MBD — system specs, architecture specs, implementation and test plans |
| **specifying-plant-models** | Specify plant models for closed-loop simulation |
| **testing-simulink-models** | Test Simulink model behavior |
| **generate-requirement-drafts** | Requirements generation (Requirements Toolbox or structured YAML) |

### Try it out

Ask your agent:

```
Open the Simulink model f14 and describe its structure.
```

### More examples

```
Find the block named Kf in f14 and tell me what parameter it uses and what value it resolves to.
```

```
Save a copy of f14 as f14_agent_demo.slx, then add a Scope block connected
to the output of the Actuator Model subsystem.
```

---

## Updating

Pull the latest changes from the repository:

```bash
cd /path/to/simulink-agentic-toolkit
git pull
```

This updates all skills and tools. After pulling:

1. **Re-run setup** to download the latest MCP server binary to `~/.local/bin/` (`%USERPROFILE%\.local\bin\` on Windows)
2. **Re-run `satk_initialize`** in MATLAB to pick up any tool changes
3. **Restart your agent session** to load updated skills

---

## Troubleshooting

| Problem | Likely Cause | Fix |
|---------|-------------|-----|
| Agent doesn't list Simulink skills | Plugin not installed or skills not linked | Re-run setup; for Claude Code, try `claude plugin install model-based-design-core@simulink-agentic-toolkit` |
| MCP tools fail with "Undefined function" | `satk_initialize` not run in current MATLAB session | Run `satk_initialize` in MATLAB |
| MCP server can't connect to MATLAB | Connector not running or stale connection | Run `satk_initialize` again (it calls `shareMATLABSession` automatically) |
| macOS blocks the MCP server binary | Gatekeeper quarantine | Right-click → Open, or run: `xattr -d com.apple.quarantine ~/.local/bin/matlab-mcp-core-server` |
| "rmiml.selectionLinkHelper" error | Path corruption from other toolboxes | Run `restoredefaultpath` in MATLAB, then re-run `satk_initialize` |
| `model_test` fails or is unavailable | Simulink Test not installed | Install Simulink Test, or use the other 6 tools which work without it |
| Codex tool calls time out | Default tool timeout too short for MATLAB | Add `tool_timeout_sec = 600` (or higher) to `[mcp_servers.simulink]` in `~/.codex/config.toml` |
| Simulink fails in Codex on Windows | Missing `WINDIR` environment variable | Add `env_vars = ['WINDIR']` to `[mcp_servers.simulink]` in `~/.codex/config.toml` |

---

## Server Modes

The MATLAB MCP Core Server supports two modes:

### Attach Mode (Recommended)

```
--matlab-session-mode=existing
```

Connects to your running MATLAB session. Preserves your workspace, loaded models, and path configuration. Requires `MATLABMCPCoreServerToolkit.mltbx` installed and `shareMATLABSession` called in MATLAB (handled by `satk_initialize`).

### Launch Mode

The default mode (no `--matlab-session-mode` flag). Starts a new MATLAB instance. Simpler to set up but state is lost when the server restarts.

---

Copyright 2025-2026 The MathWorks, Inc.

---

MATLAB and Simulink are registered trademarks of The MathWorks, Inc. See [mathworks.com/trademarks](https://www.mathworks.com/trademarks) for a list of additional trademarks. Other product or brand names may be trademarks or registered trademarks of their respective holders.
