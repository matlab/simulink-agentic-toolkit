# Simulink Agentic Toolkit

The Simulink® Agentic Toolkit allows you to use AI agents with Simulink by giving your AI agent the knowledge and context to read, build, edit, and test Simulink® models using Model-Based Design best practices.  It connects agents to Simulink through the [MATLAB MCP Server](https://github.com/matlab/matlab-mcp-core-server), giving them the **ability** (tools) and the **knowledge** (skills) to work with Simulink models effectively. Use this toolkit to provide trusted Simulink capabilities to your agent. This toolkit prevents your AI coding agent from hallucinating, missing new features, and wasting time with extra steps that experienced Simulink users would skip.

The toolkit provides:

- **MCP tools** for reading, editing, querying, testing, and checking Simulink models
- **Agent skills** encoding Model-Based Design best practices for model building, simulation, plant specification, testing, requirements, project management, and architecture modeling
- **Automated setup** using a MATLAB® function that installs the MATLAB MCP Server, configures your agent, and registers skills
- Supports **Claude Code, Copilot, Codex, Amp, and Gemini CLI**

> To use AI agents with MATLAB, install the [MATLAB Agentic Toolkit](https://github.com/matlab/matlab-agentic-toolkit). Use the automated setup option to install both the toolkits in one step.


## How the Simulink Agentic Toolkit Works

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


## Requirements

- **MATLAB R2023a or later** with **Simulink**
- A supported **AI coding agent** (see [Supported Platforms](README.md#supported-platforms))
- **Simulink Test** *(optional)* — required only for the `model_test` tool
- Some skills require additional toolboxes (e.g., System Composer, Simscape, Stateflow). Check the `requires-products` field in each skill's `manifest.yaml` under [`skills-catalog/`](skills-catalog/) for additional requirements.

## Supported Platforms

The Simulink Agentic Toolkit works with any AI coding agent that supports skills and MCP. The automated setup has been verified on the platforms listed below. Performance may vary with other coding agents.

| Platform | Setup |
|----------|-------|
| [Claude Code](https://claude.ai/code) | Automated |
| [GitHub Copilot](https://github.com/features/copilot) | Automated |
| [OpenAI Codex](https://openai.com/codex) | Automated |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | Automated |
| [Sourcegraph Amp](https://ampcode.com/) | Automated |


## Get Started with the Simulink Agentic Toolkit

These steps show you how to use the Simulink Agentic Toolkit to install the MATLAB MCP Server and add skills to your agent.
> Note: For detailed instructions on configuration options for this toolkit, platform-specific notes, verification steps, and troubleshooting, see [Configuration and Troubleshooting](Configuration_and_Troubleshooting.md).

### Install Simulink Agentic Toolkit (Automated Setup)
You can use the Agentic Toolkit installer to set up the Simulink Agentic Toolkit. The installer:

* Supports both the MATLAB and Simulink Agentic Toolkits.
* Supports connecting to an existing MATLAB session (--matlab-session-mode="auto" or "existing").
* Provides the option to configure your agent for individual projects or globally.

Follow these steps to set up the Simulink Agentic Toolkit.

1. Download `agenticToolkitInstaller.mltbx` from the [latest release](https://github.com/matlab/simulink-agentic-toolkit/releases).
2. Open the downloaded file to install the installer add-on. If the Add-On Manager fails to launch (common on headless machines, corporate proxies/antivirus, or older MATLAB versions — you may see this error ERR_CERT_AUTHORITY_INVALID or "Unable to open the requested feature"), install programmatically instead:

   ```matlab
   matlab.addons.toolbox.installToolbox("agenticToolkitInstaller.mltbx")
   ```
3. After installing, in MATLAB, run:

   ```matlab
   setupAgenticToolkit("install")
   ```

To update to the latest version, run `setupAgenticToolkit("update")`.

To uninstall the toolkit, run `setupAgenticToolkit("uninstall")`.

> **Existing users:** If you previously set up the toolkit using the agent-driven workflow, you must uninstall that custom installation and global configuration setup. See [Migrating from a Previous Installation](Migrate-from-Previous-Installation.md).

### Alternative Manual Installation Workflow

If you prefer to manage your own MATLAB MCP server installation and agent configuration, or if you are using an agent that is not listed under [Supported Platforms](#supported-platforms), you can set up the toolkit manually, following these steps.

1. Download the latest MATLAB MCP server from the [MCP server release](https://github.com/matlab/matlab-mcp-core-server/releases).
2. Install the MATLAB MCP Server Toolbox by running:

   ```bash
   ./matlab-mcp-server --setup-matlab
   ```

   > **Note:** If you downloaded the binary manually from GitHub releases, the asset name includes a platform suffix that depends on the release version:
   >
   > | Platform | New asset name | Legacy asset name (pre-6/18) |
   > |----------|---------------|------------------------------|
   > | Linux x86_64 | `matlab-mcp-server-linux-x64` | `matlab-mcp-core-server-glnxa64` |
   > | macOS arm64 | `matlab-mcp-server-macos-arm64` | `matlab-mcp-core-server-maca64` |
   > | macOS x86_64 | `matlab-mcp-server-macos-x64` | `matlab-mcp-core-server-maci64` |
   > | Windows x86_64 | `matlab-mcp-server-windows-x64.exe` | `matlab-mcp-core-server-win64.exe` |
   >
   > Rename the downloaded file to `matlab-mcp-server` (or `matlab-mcp-server.exe` on Windows) and place it in `~/.matlab/agentic-toolkits/bin/`. The automated setup handles this automatically.

3. Connect the MATLAB MCP Server to a running MATLAB session. In the command window of the running MATLAB session, run `shareMATLABSession()`.

4. Clone the [Simulink Agentic Toolkit](https://github.com/matlab/simulink-agentic-toolkit) repository, then add toolkit flags to your agent's MCP server configuration:

   ```
   --matlab-session-mode=existing
   --extension-file=/path/to/simulink-agentic-toolkit/tools/tools.json
   ```

4. Register skills by pointing your agent's skill or prompt directory at each non-empty group under `skills-catalog/` — `model-based-design-core/`, `model-based-system-engineering/`, `verification-validation-and-test/`, `simulink-simulation/`, `simulink-modeling/`, `control-systems/`, `simulink-environment-fundamentals/`, `signal-processing/`, and `code-generation/`. Each skill is a self-contained `SKILL.md` with a `manifest.yaml`.

   For platforms that discover skills from `~/.agents/skills/`, create symlinks:

   ```bash
   mkdir -p ~/.agents/skills
   for group in model-based-design-core model-based-system-engineering verification-validation-and-test simulink-simulation simulink-modeling control-systems simulink-environment-fundamentals signal-processing code-generation; do
     for skill in /path/to/simulink-agentic-toolkit/skills-catalog/$group/*/; do
       ln -s "$skill" ~/.agents/skills/$(basename "$skill")
     done
   done
   ```

### MATLAB Setup
The MATLAB MCP Server connects to a running MATLAB session. For each session, add the Simulink Agentic Toolkit to the path and initialize it.

```matlab
addpath("~/.matlab/agentic-toolkits/simulink")
satk_initialize
```

This does three things:

1. Adds the toolkit's tool directories to the MATLAB path
2. Calls `shareMATLABSession` so that the MATLAB MCP server can connect to running MATLAB session
3. Runs `validate_installation` to check that everything is configured correctly

If you installed the MCP server binary to a non-default location (e.g., a network share), pass its path explicitly:

```matlab
satk_initialize(MCPServerPath="//server/share/bin/matlab-mcp-server")
```

> **Note:** `satk_initialize` must run once per MATLAB session. To automate this, add the following to your [`startup.m`](https://www.mathworks.com/help/matlab/ref/startup.html):
>
> ```matlab
> % Initialize the Simulink Agentic Toolkit (adjust version/path as needed)
> if contains(version, 'R2026a')
>     addpath("~/.matlab/agentic-toolkits/simulink")
>     satk_initialize
> end
> `

### Verify

Check that your agent has loaded skills or plugins on its path (e.g., Claude Code's `/skills` command), confirm the Simulink Agentic Toolkit skills are listed. Open any Simulink model — your own, or a shipped example.

```matlab
openExample('simulink_general/sldemo_househeatExample')
```

This opens the shipped example model `sldemo_househeat`. Ask your agent:

```
Describe the structure of the currently open model.
```
## Library Configuration

### Toolbox Libraries

Use `satk.Configuration.setLibrary` to activate pre-built knowledge bases for installed MathWorks toolboxes:

```matlab
satk.Configuration.setLibrary('all')                                          % Activate all installed toolbox KBs
satk.Configuration.setLibrary({'Aerospace Blockset', 'Simscape'})  % Activate specific toolboxes by name
satk.Configuration.setLibrary('none')                                         % Deactivate all toolbox KBs
```

### Custom Libraries

To use your own custom Simulink block libraries with the toolkit, register them in MATLAB once:

```matlab
satk.Configuration.setCustomLibraries("C:\path\to\customLibs")
```

This declares your custom libraries. 
On the next model-building task or on invocation of the **'setup-custom-libraries'** skill, the agent indexes the libraries into a knowledge base (~3–5 min to complete) storing it in MATLAB's preference directory (prefdir) enabling usage of custom blocks alongside built-in ones.

### Clearing Configuration

To remove all library configuration:

```matlab
satk.Configuration.clearConfig()
```
## MCP Tools

After you install the Simulink Agentic Toolkit, your agent can use the following tools.

| Tool | What your agent can do |
|------|------------------------|
| `model_overview` | Explore model architecture. Review subsystem hierarchy, interfaces, and how major components connect |
| `model_read` | Understand model behavior. Inspect blocks, algorithmic expressions, signal flow, and parameter values |
| `model_edit` | Build and modify models. Add blocks, wire signals, create subsystems, and configure parameters as needed |
| `model_check` | Validate model structure. Detect unconnected ports, dangling lines, and Edit-Time Checks on States and Subcharts |
| `model_read_diagnostics` | Read diagnostics. Retrieve errors, warnings, and info messages from the Diagnostic Viewer after compilation, simulation, or code generation |
| `model_test` | Verify requirements. Run human-readable Gherkin tests with automatic harness generation *(requires Simulink Test)* |
| `model_query_params` | Inspect any parameter. Query block settings, signal properties, solver config, and logging flags |
| `model_resolve_params` | Get actual values. Resolve workspace variables like `Kp` to their numeric values across all scopes |


---

## Agent Skills

After you install the Simulink Agentic Toolkit, your agent can use the skills in the following groups. To see lists of available skills, see [skills catalog](skills-catalog/README.md).

| Skill Group | Description |
|-------|---------------------------|
| [Model-Based Design Core](skills-catalog/model-based-design-core/) | Core Model-Based Design (MBD) skills for building, testing, and specifying Simulink models |
| [Model-Based System Engineering](skills-catalog/model-based-system-engineering/) | Model-Based System Engineering skills for System Composer architecture models |
| [Verification, Validation, and Test](skills-catalog/verification-validation-and-test/) | Author custom Model Advisor checks and run compliance reviews against industry standards (MISRA, MAB, ISO 26262, DO-178C, etc.) |
| [Simulink Simulation](skills-catalog/simulink-simulation/) | Skills for constructing simulation input datasets and configuring simulation workflows |
| [Simulink Modeling](skills-catalog/simulink-modeling/) | Configure and integrate C/C++ code into Simulink models via C Function blocks |
| [Control Systems](skills-catalog/control-systems/) | Control system design and analysis skills for Simulink models |
| [Simulink Environment Fundamentals](skills-catalog/simulink-environment-fundamentals/) | Core Simulink environment capabilities, including discovering shipped example models |
| [Signal Processing](skills-catalog/signal-processing/) | Frame-based streaming DSP models in Simulink using DSP System Toolbox |
| [Code Generation](skills-catalog/code-generation/) | Prepare Simulink models for production code generation, including single-precision conversion |

## Security Considerations
When using the Simulink Agentic Toolkit and MATLAB MCP Server, you should thoroughly review and validate all tool calls before you run them. Always keep a human in the loop for important actions and only proceed once you are confident the call will do exactly what you expect. For more information, see [User Interaction Model (MCP)](https://modelcontextprotocol.io/specification/2025-06-18/server/tools#user-interaction-model) and [Security Considerations (MCP)](https://modelcontextprotocol.io/specification/2025-06-18/server/tools#security-considerations).

## Licensing and Usage

The license is available in the [LICENSE.md](LICENSE.md) file in this GitHub repository.

MCP servers are only permitted to be used with MATLAB and Simulink in accordance with the MathWorks Software License Agreement, and must not be shared by multiple users. Contact MathWorks if you need to support shared or centralized server use.

## Research Preview: Agentic Task Explorer

The Agentic Task Explorer provides curated, multi-step tasks that show what agents can do with Simulink — model understanding, creation, modification, testing, bug fixing, and verification. Each task includes Simulink models and supporting files, ready to go.

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

MathWorks encourages you to use this repository and provide feedback. To request technical support or submit an enhancement request, [create a GitHub issue](https://github.com/matlab/simulink-agentic-toolkit/issues) or [contact technical support](https://www.mathworks.com/support/contact_us.html). For MATLAB MCP Server issues, see the [MATLAB MCP Server](https://github.com/matlab/matlab-mcp-core-server) repository.

Pull requests are not enabled on this repository. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

Copyright 2025-2026 The MathWorks, Inc.
