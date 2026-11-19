# Simulink Agentic Toolkit

The Simulink® Agentic Toolkit enables you to use AI agents with Simulink. It gives your AI agent the knowledge and context to read, build, edit, and test Simulink models by using Model-Based Design best practices. It connects agents to Simulink through the [MATLAB MCP Server](https://github.com/matlab/matlab-mcp-server), giving them the **ability** (tools) and the **knowledge** (skills) to work with Simulink models effectively. Use this toolkit to provide trusted Simulink capabilities to your agent. This toolkit helps prevent your AI coding agent from hallucinating, missing new features, and wasting time with extra steps that experienced Simulink users skip.

The toolkit provides:

- **MCP tools** for reading, editing, querying, testing, and checking Simulink models
- **Agent skills** encoding Model-Based Design best practices for model building, simulation, plant specification, testing, requirements, project management, and architecture modeling
- Support for **Claude Code, GitHub Copilot in Visual Studio Code, GitHub Copilot CLI, and OpenAI Codex**

> To use AI agents with MATLAB, install the [MATLAB Agentic Toolkit](https://github.com/matlab/matlab-agentic-toolkit). The Agentic Toolkit Installer can install both toolkits in one step.


## How the Simulink Agentic Toolkit Works

```
┌───────────┐       ┌───────────┐       ┌──────────┐
│ AI Agent  │◄─MCP─►│MCP Server │◄─────►│ MATLAB / │
│ (Claude,  │       │ (MATLAB   │       │ Simulink │
│  Codex,   │       │ MCP)      │       └──────────┘
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

Your agent reads **skills** for domain knowledge, then calls **MCP tools** to interact with MATLAB and Simulink. The [MATLAB MCP Server](https://github.com/matlab/matlab-mcp-server) bridges the connection.


## Requirements

- **MATLAB R2023a or later** with **Simulink**
- An AI coding agent that supports MCP servers and skills. The installer configures supported agents automatically. To manually configure the MCP server and install skills, see the documentation for your agent. Supported agents include:
  - [Claude Code](https://claude.com/product/claude-code)
  - [GitHub Copilot in Visual Studio Code](https://code.visualstudio.com/docs/copilot/overview)
  - [GitHub Copilot CLI](https://github.com/features/copilot/cli)
  - [OpenAI Codex](https://openai.com/codex/)
- **Simulink Test** *(optional)* — required only for the `model_test` tool
- Some skills require additional toolboxes (e.g., System Composer, Simscape, Stateflow). Check the `requires-products` field in each skill's `manifest.yaml` under [`skills-catalog/`](skills-catalog/) for additional requirements.

## Get Started with Simulink Agentic Toolkit

These steps show you how to install the Simulink Agentic Toolkit and the MATLAB MCP Server and how to add skills to your agent.

### Install the Simulink Agentic Toolkit

To install, update, or uninstall the Simulink Agentic Toolkit and MATLAB MCP Server together, use the **[Agentic Toolkit Installer](https://github.com/matlab/agentic-toolkit-installer)**. Follow the installation instructions in the repository. The installer downloads the toolkit and MATLAB MCP Server, installs the required MATLAB toolboxes, and configures the MCP server and skills for your agent.

When you use the installer, you do not need to set up the toolkit for each MATLAB session. The toolkit is automatically available on the MATLAB path, and agents can connect to MATLAB automatically. To use an existing MATLAB session and retain its workspace and loaded models, run `shareMATLABSession` in that session.

> **Existing users:** If you previously set up the toolkit by using `setupAgenticToolkit` or the earlier agent-driven workflow, the installer detects the previous installation and prompts you to remove it. You no longer need to run `satk_initialize`. Remove `satk_initialize` from your `startup.m` file. For more information, see [Migrate from a Previous Installation](Migrate-from-Previous-Installation.md).

### Verify the Installation

To check your installation, run this in MATLAB:

```matlab
satk_doctor
```

`satk_doctor` checks the toolkit's MATLAB tools, the MATLAB path, and MATLAB session sharing. To check installed versions, configured agents, and the MCP server, run `agentic-toolkit-installer status` in a terminal. Confirm that your agent lists the Simulink Agentic Toolkit skills. For example, in Claude Code, use the `/skills` command.

Then, open a Simulink model. You can use your own model or open an example model.

```matlab
openExample('simulink_general/sldemo_househeatExample')
```

This command opens the shipped example model `sldemo_househeat`. Ask your agent:

```
Describe the structure of the currently open model.
```

For troubleshooting, see [Configuration and Troubleshooting](Configuration_and_Troubleshooting.md).

## Library Configuration

### Toolbox Libraries

Use `satk.Configuration.setToolboxes` to activate pre-built knowledge bases for installed MathWorks toolboxes:

```matlab
satk.Configuration.setToolboxes('all')                                 % Activate all installed toolbox KBs
satk.Configuration.setToolboxes({'Aerospace Blockset', 'Simscape'})    % Activate specific toolboxes by name
satk.Configuration.setToolboxes('none')                                % Deactivate all toolbox KBs
```

### Custom Libraries

To use your own custom Simulink block libraries with the toolkit, register them in MATLAB once:

```matlab
satk.Configuration.setCustomLibraries("C:\path\to\customLibs")
```
This declares your custom libraries. By default (`GenerateKB=false`), the toolkit does not build the knowledge base immediately. Instead, the agent indexes the libraries into a knowledge base on the next model-building task or when you invoke the **setup-custom-libraries** skill. Indexing takes about 3–5 minutes and enables the agent to use custom blocks alongside built-in ones.

Each entry is either a folder, which registers every `.slx` and `.mdl` file in
it, or the path to a single library file. To register more than one entry, pass
a string array or a cell array:

```matlab
% Multiple folders
satk.Configuration.setCustomLibraries(["C:\path\to\motorLibs", "C:\path\to\sensorLibs"])

% Individual library files
satk.Configuration.setCustomLibraries(["C:\libs\motorLib.slx", "C:\libs\sensorLib.slx"])
```

Each call **replaces** the full set of registered custom libraries instead of
adding to it, so list every library that you want in a single call.

#### Options

`setCustomLibraries` accepts the following options:

```matlab
% Build the knowledge base deterministically from block metadata present in the libraries. 
satk.Configuration.setCustomLibraries("C:\path\to\customLibs", GenerateKB=true)
% Choose where the KB and configuration folder is written.
% Omitted  -> MATLAB prefdir (default): per-user, global, paths stored absolute.
% <dir>    -> an existing directory: library paths on the same drive are
%             stored relative to this root (so the .satk folder can be
%             committed and shared); paths on a different drive are stored
%             absolute.
satk.Configuration.setCustomLibraries("libs", Location="C:\repo\myProject")
```

When you register custom libraries with a `Location`, activating toolbox
knowledge bases with `setToolboxes` writes them into that same `.satk` folder.

If you activate toolbox KBs globally first and later register custom
libraries with a `Location`, the toolkit automatically moves the toolbox KBs
alongside the custom libraries.

### Clearing Configuration

To remove the global (prefdir) library configuration:

```matlab
satk.Configuration.clearConfig()
```

To remove a project-local configuration, including its `.satk/` folder and any
`satk-libraries.json` file at the project root, run this command. For example,
remove the project configuration if it shadows the global configuration and
you want the global configuration to take precedence.

```matlab
satk.Configuration.clearConfig("C:\repo\myProject")
```

Both forms are destructive and not reversible.


## MCP Tools

After you install the Simulink Agentic Toolkit, your agent can use the following tools.

| Tool | What your agent can do |
|------|------------------------|
| `model_overview` | Explore model architecture. Review subsystem hierarchy, interfaces, and how major components connect |
| `model_read` | Understand model behavior. Inspect blocks, algorithmic expressions, signal flow, and parameter values |
| `model_edit` | Build and modify models. Add blocks, wire signals, create subsystems, and configure parameters as needed |
| `model_check` | Validate model structure. Detect unconnected ports, dangling lines, and edit-time check issues in states and subcharts |
| `model_read_diagnostics` | Read diagnostics. Retrieve errors, warnings, and info messages from the Diagnostic Viewer after compilation, simulation, or code generation |
| `model_test` | Verify requirements. Run human-readable Gherkin tests with automatic harness generation *(requires Simulink Test)* |
| `model_query_params` | Inspect any parameter. Query block settings, signal properties, solver config, and logging flags |
| `model_resolve_params` | Get actual values. Resolve workspace variables such as `Kp` to their numeric values across all scopes |
| `model_scan` | Find something specific, fast. Regex-search the saved `.slx` file on disk for a block name, parameter value, or string without loading the model |


---

## Agent Skills

After you install the Simulink Agentic Toolkit, your agent can use the skills in the following groups. To see lists of available skills, see the [skills catalog](skills-catalog/README.md).

| Skill Group | Description |
|-------|---------------------------|
| [Model-Based Design Core](skills-catalog/model-based-design-core/) | Core Model-Based Design (MBD) skills for building, testing, and specifying Simulink models |
| [Model-Based System Engineering](skills-catalog/model-based-system-engineering/) | Model-Based System Engineering skills for System Composer architecture models |
| [Verification, Validation, and Test](skills-catalog/verification-validation-and-test/) | Author custom Model Advisor checks, run compliance reviews against industry standards (MISRA, MAB, ISO 26262, DO-178C, etc.), fix SLDV incompatibilities, and explain missing coverage |
| [Simulink Simulation](skills-catalog/simulink-simulation/) | Skills for constructing simulation input datasets and configuring simulation workflows |
| [Simulink Modeling](skills-catalog/simulink-modeling/) | Configure and integrate C/C++ and Python code into Simulink models via C Function and Python Code blocks |
| [Control Systems](skills-catalog/control-systems/) | Control system design and analysis skills for Simulink models |
| [Simulink Environment Fundamentals](skills-catalog/simulink-environment-fundamentals/) | Core Simulink environment capabilities, including discovering shipped example models |
| [Signal Processing](skills-catalog/signal-processing/) | Build frame-based streaming DSP models in Simulink by using DSP System Toolbox |
| [Physical Modeling](skills-catalog/physical-modeling/) | Model, simulate, and analyze multidomain physical systems with the Simscape product family |
| [Code Generation](skills-catalog/code-generation/) | Prepare Simulink models for production code generation, including single-precision conversion, optimizing generated embedded code, configuring Embedded Coder deployment settings, and customizing A2L calibration files |
| [Real-Time Simulation and Testing](skills-catalog/real-time-simulation-and-testing/) | Configure, deploy, and run Simulink models on real-time target computers with Simulink Real-Time |
| [Simulink Block and Blockset Authoring](skills-catalog/simulink-block-and-blockset-authoring/) | Author the appearance of custom Simulink blocks, such as dynamic SVG block icons |
| [Aerospace](skills-catalog/aerospace/) | Aerospace skills for Simulink models using Aerospace Blockset |

## Security Considerations
When you use the Simulink Agentic Toolkit and MATLAB MCP Server, review and validate all tool calls before you run them. Always keep a human in the loop for important actions, and proceed only when you are confident that the call does what you expect. For more information, see [User Interaction Model (MCP)](https://modelcontextprotocol.io/specification/2026-07-28/server/tools#user-interaction-model) and [Security Considerations (MCP)](https://modelcontextprotocol.io/specification/2026-07-28/server/tools#security-considerations).

## Licensing and Usage

The license is available in the [LICENSE.md](LICENSE.md) file in this GitHub repository.

MCP servers are only permitted to be used with MATLAB and Simulink in accordance with the MathWorks Software License Agreement, and must not be shared by multiple users. Contact MathWorks if you need to support shared or centralized server use.

## Research Preview: Agentic Task Explorer

The Agentic Task Explorer provides curated, multi-step tasks that show what agents can do with Simulink — model understanding, creation, editing, testing, bug fixing, and verification. Each task includes Simulink models and supporting files, ready to go.

```matlab
slAgenticTaskExplorer
```

Select a task from the interactive UI. The explorer stages it into an isolated workspace with all required files, then opens your coding agent. Each task presents step-by-step prompts — copy each prompt into your coding agent and watch it work.

*This is a research preview. Behavior and interfaces might change.*

---
## Report Bugs

If you encounter a bug, use the **filing-bug-reports** skill to generate a report before opening a GitHub issue. Ask your agent:

```
File a bug report for this issue
```

The skill automatically captures environment details, reproduction steps, and error output. **Run the skill in the same session where the bug occurred**, because it uses conversation context to reconstruct what happened. Then [open a bug report](https://github.com/matlab/simulink-agentic-toolkit/issues/new?template=bug_report.yml) and paste the generated report.

---

## Support and Contributions

MathWorks encourages you to use this repository and provide feedback. To request technical support or submit an enhancement request, [create a GitHub issue](https://github.com/matlab/simulink-agentic-toolkit/issues) or [contact technical support](https://www.mathworks.com/support/contact_us.html). For installation issues, see the [Agentic Toolkit Installer](https://github.com/matlab/agentic-toolkit-installer) repository. For MATLAB MCP Server issues, see the [MATLAB MCP Server](https://github.com/matlab/matlab-mcp-server) repository.

This repository does not accept pull requests. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

Copyright 2025-2026 The MathWorks, Inc.
