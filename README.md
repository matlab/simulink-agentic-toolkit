# Simulink Agentic Toolkit

Give your AI coding agent the ability to read, build, edit, and test Simulink® models using Model-Based Design best practices.

---

## What It Does

The Simulink Agentic Toolkit packages MathWorks® Model-Based Design expertise for AI coding agents. It connects agents to Simulink through the [Model Context Protocol (MCP)](https://modelcontextprotocol.io/), giving them both the **ability** (tools) and the **knowledge** (skills) to work with Simulink models effectively.

- **7 MCP tools** for reading, editing, querying, testing, and checking Simulink models
- **9 agent skills** encoding MBD best practices for model building, simulation, plant specification, testing, requirements, project management, and architecture modeling
- **Automated setup** via a MATLAB&reg; function that installs the MCP server, configures your agent, and registers skills
- Supports **Claude Code, Copilot, Codex, Amp, and Gemini CLI**

---

## How It Works

```
┌───────────┐       ┌───────────┐       ┌──────────┐
│ AI Agent  │◄─MCP─►│MCP Server │◄─────►│ MATLAB / │
│ (Claude,  │       │ (MATLAB   │       │ Simulink │
│  Codex,   │       │ MCP Core) │       └──────────┘
│  Copilot) │       └───────────┘
└───────────┘
      ▲
      │ reads
┌─────┴─────┐
│  Skills   │
│ (MBD best │
│ practices)│
└───────────┘
```

Your agent reads **skills** for domain knowledge, then calls **MCP tools** to interact with MATLAB and Simulink. The [MATLAB MCP Server](https://github.com/matlab/matlab-mcp-core-server) bridges the connection (downloaded during setup).

---

## Supported Platforms

| Platform | Setup | Notes |
|----------|-------|-------|
| [Claude Code](https://claude.ai/code) | Automated | |
| [GitHub Copilot](https://github.com/features/copilot) | Automated | |
| [OpenAI Codex](https://openai.com/codex) | Automated | |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | Automated | |
| [Sourcegraph Amp](https://ampcode.com/) | Automated | |

> Automated setup has been verified with basic workflows on each platform. The toolkit is under active development — please [report issues](https://github.com/matlab/simulink-agentic-toolkit/issues) if you encounter problems.

## Quick Start

> **Full walkthrough:** See the [Getting Started guide](GETTING_STARTED.md) for detailed instructions, platform-specific notes, verification steps, and troubleshooting.

**Prerequisites:**
* MATLAB R2023a or later with Simulink
* Supported AI coding agent

### Automated Setup (Recommended)

The `setupAgenticToolkit` function handles installation, configuration, updates, and uninstallation for both the MATLAB and Simulink Agentic Toolkits. Download `agenticToolkitInstaller.mltbx` from the [latest release](https://github.com/matlab/simulink-agentic-toolkit/releases), install it in MATLAB, then run:

```matlab
setupAgenticToolkit("install")
```

This downloads the MCP server binary and toolkit files to `~/.matlab/agentic-toolkits/`, then walks you through configuring your first coding agent (MCP server entry + skill registration). To set up additional agents later, run `setupAgenticToolkit("configure")`. To update to the latest version, run `setupAgenticToolkit("update")`. If your organization uses a CLI wrapper, pass `AgentCLI="claude-code=/path/to/wrapper"` during configure.

> **Existing users:** If you previously set up the toolkit using the agent-driven workflow, you must uninstall that setup first. See [Migrating from a Previous Installation](GETTING_STARTED.md#migrating-from-a-previous-installation) in the Getting Started guide.

### Manual Setup

If you already have the [MATLAB MCP Server](https://github.com/matlab/matlab-mcp-core-server) installed or prefer full control, you can configure the toolkit manually. See [Manual Setup](GETTING_STARTED.md#manual-setup) in the Getting Started guide.

### MATLAB Setup (all platforms)

The MCP server connects to a running MATLAB session. Open MATLAB and run:

```matlab
addpath("~/.matlab/agentic-toolkits/simulink")
satk_initialize
```

### Verify

In MATLAB, open any Simulink model — your own, or a shipped example like `f14`:

```matlab
openExample("simulink/AddBlockToModelFromLibraryExample")       % only needed for R2023b+
open_system("f14")
```

Then ask your agent:

```
Describe the structure of the currently open model.
```

---

## MCP Tools

| Tool | What your agent can do |
|------|------------------------|
| `model_overview` | Explore model architecture — see subsystem hierarchy, interfaces, and how major components connect |
| `model_read` | Understand model behavior — inspect blocks, algorithmic expressions, signal flow, and parameter values |
| `model_edit` | Build and modify models — add blocks, wire signals, create subsystems, and configure parameters |
| `model_check` | Validate model structure — detect unconnected ports, dangling lines, and Edit-Time Checks on States and Subcharts |
| `model_test` | Verify requirements — run human-readable Gherkin tests with automatic harness generation *(requires Simulink Test)* |
| `model_query_params` | Inspect any parameter — query block settings, signal properties, solver config, and logging flags |
| `model_resolve_params` | Get actual values — resolve workspace variables like `Kp` to their numeric values across all scopes |

---

## Agent Skills

Skills are organized in the [skills catalog](skills-catalog/) by product area.

**Model-Based Design Core** — core MBD skills for building, testing, and specifying Simulink models:

| Skill | What it teaches your agent |
|-------|---------------------------|
| `building-simulink-models` | Best practices for structural model changes — adding blocks, wiring, layout |
| `filing-bug-reports` | Generate standalone bug reports for reproducing, investigating, and fixing issues |
| `managing-simulink-projects` | MATLAB project management — path setup, file registration, labels, model references, source control |
| `simulating-simulink-models` | Run simulations for data exploration, parameter sweeps, and custom analysis |
| `specifying-mbd-algorithms` | Specify algorithms for MBD — system specs, architecture specs, implementation and test plans |
| `specifying-plant-models` | How to specify plant models for closed-loop simulation |
| `testing-simulink-models` | How to test model behavior — reproduce issues, verify changes, regression tests |
| `generate-requirement-drafts` | Requirements generation — prefers Requirements Toolbox (.slreqx) with traceability links when available, falls back to structured YAML |

**Model-Based System Engineering** — MBSE skills for System Composer architecture models:

| Skill | What it teaches your agent |
|-------|---------------------------|
| `building-architecture-models` | Build multi-layer system architecture models — components, interfaces, allocations, stereotypes, and requirements traceability *(requires System Composer)* |

---

## Repository Structure

```
simulink-agentic-toolkit/
├── skills-catalog/           # Agent skills (not auto-discovered)
│   ├── model-based-design-core/          # Core MBD skills (8 skills)
│   └── model-based-system-engineering/   # MBSE skills (1 skill)
├── tools/                    # MCP tool implementations
├── satk_initialize.m         # MATLAB session setup entry point
└── research-previews/        # Curated example tasks
```

---

## Research Preview: Agentic Task Explorer

The Agentic Task Explorer provides curated, multi-step tasks that demonstrate what agents can do with Simulink — model understanding, creation, modification, testing, bug fixing, and verification. Each task includes Simulink models and supporting files, ready to go.

```matlab
slAgenticTaskExplorer
```

Select a task from the interactive UI. The explorer stages it into an isolated workspace with all required files, then opens your coding agent. Each task presents step-by-step prompts — copy each prompt into your coding agent and watch it work.

*This is a research preview. Behavior and interfaces may change.*

---

## Requirements

- **MATLAB R2023a or later** with **Simulink**
- **Simulink Test** *(optional)* — required only for `model_test`
- **System Composer** *(optional)* — enables architecture modeling and component analysis; required for `building-architecture-models` skill
- **Requirements Toolbox** *(optional)* — enables requirements traceability; used in `building-architecture-models` skill
- **Simscape** *(optional)* — enables physical modeling domain support
- **Stateflow** *(optional)* — enables state machine and chart analysis
- A supported **AI coding agent** (see [Supported Platforms](#supported-platforms))

---

## AI Model Capability Guidance

This toolkit relies on strong multi-step reasoning, tool use, and coding performance from the AI model.

We have tested the toolkit with higher-capability models, including Claude Opus and Sonnet, OpenAI GPT-5 models, and Gemini Pro models, and have generally seen good results on demanding workflows.

Model capability has a significant impact on quality. In our testing, lightweight or lower-capability models were less reliable for tasks such as model construction and complex edits, and were more likely to produce incomplete or incorrect results. These models may still be sufficient for simpler tasks, but for the best overall experience we recommend using a higher-capability model.

---

## Documentation

| Resource | Description |
|----------|-------------|
| [Getting Started](GETTING_STARTED.md) | Setup tutorial with per-agent instructions and troubleshooting |
| [Skills Catalog](skills-catalog/) | Browse all agent skill groups and individual skills |

## Reporting Bugs

If you encounter a bug, use the **filing-bug-reports** skill to generate a report before opening a GitHub issue. Ask your agent:

```
File a bug report for this issue
```

The skill automatically captures environment details, reproduction steps, and error output — producing a complete report in your workspace. Then [open a bug report](https://github.com/mathworks/simulink-agentic-toolkit/issues/new?template=bug_report.yml) and paste the generated report. **Be sure to run the skill in the same session where the bug occurred**, since it uses conversation context to reconstruct what happened. If the issue did not occur in a chat session, describe the issue as best you can to the agent, then ask it to file a bug report.

## Contributing

We welcome feedback through [GitHub Issues](https://github.com/matlab/simulink-agentic-toolkit/issues). Pull requests are reviewed for ideas and feedback but are not merged from external contributors. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Security Considerations

When using the Simulink Agentic Toolkit and MATLAB MCP Server, you should thoroughly review and validate all tool calls before you run them. Always keep a human in the loop for important actions and only proceed once you are confident the call will do exactly what you expect. For more information, see [User Interaction Model (MCP)](https://modelcontextprotocol.io/specification/2025-06-18/server/tools#user-interaction-model) and [Security Considerations (MCP)](https://modelcontextprotocol.io/specification/2025-06-18/server/tools#security-considerations).

## Licensing and Usage

The license is available in the [LICENSE.md](LICENSE.md) file in this GitHub repository.

MCP servers are only permitted to be used with MATLAB and Simulink in accordance with the MathWorks Software License Agreement, and must not be shared by multiple users. Contact MathWorks if you need to support shared or centralized server use.

## Contact Support

MathWorks encourages you to use this repository and provide feedback. To request technical support or submit an enhancement request, [create a GitHub issue](https://github.com/matlab/simulink-agentic-toolkit/issues) or [contact technical support](https://www.mathworks.com/support/contact_us.html). For MATLAB MCP Server issues and support, see the [MATLAB MCP Server](https://github.com/matlab/matlab-mcp-core-server) repository.

---

Copyright 2025-2026 The MathWorks, Inc.
