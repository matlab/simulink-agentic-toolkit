# Simulink Agentic Toolkit

Give your AI coding agent the ability to read, build, edit, and test Simulink® models using Model-Based Design best practices.

---

## What It Does

The Simulink Agentic Toolkit packages MathWorks® Model-Based Design expertise for AI coding agents. It connects agents to Simulink through the [Model Context Protocol (MCP)](https://modelcontextprotocol.io/), giving them both the **ability** (tools) and the **knowledge** (skills) to work with Simulink models effectively.

- **6 MCP tools** for reading, editing, querying, testing, and checking Simulink models
- **7 agent skills** encoding MBD best practices for model building, plant specification, testing, requirements, and tool initialization
- **Per-agent manifests** for Claude Code, Cursor, Codex, Copilot, Amp, and Gemini CLI — install once, skills and MCP are configured automatically
- **Automated setup** that configures MATLAB® paths, enables MCP attachment, and validates your installation

---

## How It Works

```
┌───────────┐       ┌───────────┐       ┌──────────┐
│ AI Agent  │◄─MCP─►│MCP Server │◄─────►│ MATLAB / │
│ (Claude,  │       │ (MATLAB   │       │ Simulink │
│  Cursor,  │       │ MCP Core) │       └──────────┘
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

Your agent reads **skills** for domain knowledge, then calls **MCP tools** to interact with MATLAB and Simulink. The [MATLAB MCP Core Server](https://github.com/matlab/matlab-mcp-core-server) bridges the connection (downloaded during setup).

---

## Supported Platforms

| Platform | Manifest | Install Method |
|----------|----------|----------------|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | `.claude-plugin/marketplace.json` | Plugin marketplace |
| [GitHub Copilot](https://github.com/features/copilot) | Shared `.claude-plugin/marketplace.json` | Cross-discovery from Claude plugin |
| [Cursor](https://www.cursor.com/) | `.cursor-plugin/plugin.json` | Plugin directory |
| [OpenAI  Codex](https://openai.com/codex) | `.codex-plugin/plugin.json` | Marketplace registry (`.agents/plugins/`) |
| [Sourcegraph Amp](https://ampcode.com/) | `amp.skills.path` | MCP config via setup + `amp skill add` |
| [Gemini  CLI](https://github.com/google-gemini/gemini-cli) | `gemini-extension.json` | MCP config only (manual skill setup) |

---

## Quick Start

> **Full walkthrough:** See the [Getting Started guide](GETTING_STARTED.md) for detailed instructions, verification steps, and troubleshooting.

**Prerequisites:** MATLAB R2023a or later with Simulink, and a supported AI coding agent. The MCP server binary is downloaded from GitHub during setup.

### Claude Code

```bash
# Clone the toolkit
git clone https://github.com/mathworks/simulink-agentic-toolkit.git
```

Then launch your agent in the toolkit directory and ask:

```
Set up the Simulink Agentic Toolkit
```

The setup skill automates everything: detects your platform, installs the MCP server binary, configures your agent, and verifies the installation. See [GETTING_STARTED.md](GETTING_STARTED.md) for detailed instructions for all supported platforms.

### MATLAB Setup (all platforms)

The MCP server connects to a running MATLAB session. Open MATLAB and run:

```matlab
addpath("/path/to/simulink-agentic-toolkit")
satk_initialize
```

### Verify

Ask your agent:

```
Open the Simulink model f14 and describe its structure.
```

---

## MCP Tools

| Tool | What your agent can do |
|------|------------------------|
| `model_overview` | Explore model architecture — see subsystem hierarchy, interfaces, and how major components connect |
| `model_read` | Understand model behavior — inspect blocks, algorithmic expressions, signal flow, and parameter values |
| `model_edit` | Build and modify models — add blocks, wire signals, create subsystems, and configure parameters |
| `model_test` | Verify requirements — run human-readable Gherkin tests with automatic harness generation *(requires Simulink Test)* |
| `model_query_params` | Inspect any parameter — query block settings, signal properties, solver config, and logging flags |
| `model_resolve_params` | Get actual values — resolve workspace variables like `Kp` to their numeric values across all scopes |

---

## Agent Skills

Skills are organized in the [skills catalog](skills-catalog/). The core skill group includes:

| Skill | What it teaches your agent |
|-------|---------------------------|
| `building-simulink-models` | Best practices for structural model changes — adding blocks, wiring, layout |
| `filing-bug-reports` | Generate standalone bug reports for reproducing, investigating, and fixing issues |
| `simulink-agentic-toolkit-setup` | MATLAB path configuration, MCP tool initialization, tool selection guidance |
| `specifying-mbd-algorithms` | Specify algorithms for MBD — system specs, architecture specs, implementation and test plans |
| `specifying-plant-models` | How to specify plant models for closed-loop simulation |
| `testing-simulink-models` | How to test model behavior — reproduce issues, verify changes, regression tests |
| `generate-requirement-drafts` | Requirements generation — prefers Requirements Toolbox (.slreqx) with traceability links when available, falls back to structured YAML |

---

## Repository Structure

```
simulink-agentic-toolkit/
├── .claude-plugin/           # Claude Code + Copilot manifest
├── .cursor-plugin/           # Cursor manifest
├── .agents/plugins/          # Codex marketplace registry
├── .codex-plugin/            # Codex plugin definition
├── gemini-extension.json     # Gemini CLI MCP config
├── skills-catalog/           # Agent skills (not auto-discovered)
│   ├── model-based-design-core/  # Core MBD skills (6 skills)
│   └── PRODUCT-GROUP-NAME/      # Placeholder for additional skill groups
├── tools/                    # MCP tool implementations
├── satk_initialize.m         # MATLAB setup entry point
└── research-previews/        # Curated example tasks
```

---

## Research Preview: Agentic Task Explorer

The Agentic Task Explorer provides curated example tasks that demonstrate what agents can do with Simulink — model understanding, modification, verification, and testing. Browse tasks by category and difficulty, stage them in an isolated workspace, and run them with your agent.

*This is a research preview. Behavior and interfaces may change.*

---

## Requirements

- **MATLAB R2023a or later** with **Simulink**
- **Simulink Test** *(optional)* — required only for `model_test`
- **System Composer** *(optional)* — enables architecture modeling and component analysis
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

## Trademarks

MATLAB and Simulink are registered trademarks of The MathWorks, Inc. See [mathworks.com/trademarks](https://www.mathworks.com/trademarks) for a list of additional trademarks. Other product or brand names may be trademarks or registered trademarks of their respective holders.

## Contributing

We welcome feedback through [GitHub Issues](https://github.com/mathworks/simulink-agentic-toolkit/issues). Pull requests are reviewed for ideas and feedback but are not merged from external contributors. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Support

MathWorks encourages you to use this repository and provide feedback. To request technical support or submit an enhancement request, [create a GitHub issue](https://github.com/mathworks/simulink-agentic-toolkit/issues) or email [genai-support@mathworks.com](mailto:genai-support@mathworks.com).

#
When using the Simulink Agentic Toolkit and MATLAB MCP Core Server, you should thoroughly review and validate all tool calls before you run them. Always keep a human in the loop for important actions and only proceed once you are confident the call will do exactly what you expect. For more information, see [User Interaction Model (MCP)](https://modelcontextprotocol.io/specification/2025-06-18/server/tools#user-interaction-model) and [Security Considerations (MCP)](https://modelcontextprotocol.io/specification/2025-06-18/server/tools#security-considerations).

The MATLAB MCP Core server may only be used with MATLAB installations that are used as a Personal Automation Server. Use with a central Automation Server is not allowed. Please contact MathWorks if Automation Server use is required. For more information see the [Program Offering Guide (MathWorks)](https://www.mathworks.com/help//pdf_doc/offering/offering.pdf).

---

Copyright 2025-2026 The MathWorks, Inc.
