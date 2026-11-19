# Frequently Asked Questions

## Environment

### How Can I Check Whether the Simulink Agentic Toolkit Is Set Up Correctly?

**From MATLAB:** Run `satk_doctor`.

```matlab
satk_doctor
```
The `satk_doctor` function displays a diagnostic summary and returns the results in YAML format. It checks what only MATLAB can see, such as the MATLAB path and session sharing. To check installed versions, configured agents, and the MCP server, run `agentic-toolkit-installer status` in a terminal from the folder where you downloaded the [Agentic Toolkit Installer](https://github.com/matlab/agentic-toolkit-installer).

It performs these checks:

| Check | Description |
|-------|-----------------|
| MATLAB version | Verifies that you are using MATLAB R2023a or later. If this check fails, the remaining checks do not run.|
| Simulink | Verifies that Simulink is installed and licensed. If this check fails, the remaining checks do not run.|
| Toolkit location | Reports the folder that the toolkit's MATLAB tools run from.|
| Legacy installation | Verifies that no leftover `setupAgenticToolkit` files remain in `~/.matlab/agentic-toolkits`.|
| Tool entry points | Verifies that all Model Context Protocol (MCP) tool functions are on the MATLAB path.|
| Package resolution | Verifies that the `+sage` and `+mbd` packages resolve to the toolkit installation and are not shadowed by other packages.|
| MATLAB session | Verifies that the MATLAB MCP Server Toolbox is installed and reports whether the current MATLAB session is shared. |
| Diagnostic capture and block layout | Verifies that the required internal components load successfully.|

For each warning or failure, `satk_doctor` provides a suggested corrective action. If no checks fail, the overall result is **PASS**.

**From your AI coding agent:** Verify that MCP tools and skills are registered. The method varies by agent:

| Agent | Check MCP tools | Check skills |
|-------|----------------|--------------|
| Claude Code | Run `/mcp` | Run `/skills` |
| GitHub Copilot in VS Code | From the VS Code Command Palette, select `MCP: List Servers` | Type `/` in the chat input to see the available skills |
| GitHub Copilot CLI | In a terminal, run `copilot mcp list` | Run `/skills list` |
| OpenAI Codex | In a terminal, run `codex mcp list` | Ask the agent to list its skills |

The list includes the `matlab` MCP server with tools such as `model_overview`, `model_read`, `model_edit`, `model_query_params`, `model_resolve_params`, and `model_test`. For skills, look for the Model-Based Design skills (for example, `building-simulink-models`, `testing-simulink-models`, `simulating-simulink-models`).

**Common fixes for failures:**

- **MATLAB version or Simulink fails:** Upgrade MATLAB or install Simulink.
- **Tool entry points or package resolution fails:** Restart MATLAB. If the check continues to fail, reinstall the toolkit with the Agentic Toolkit Installer or remove MATLAB path entries that shadow the toolkit packages.
- **MATLAB session check reports a warning:** Reinstall with the Agentic Toolkit Installer, then restart MATLAB.
- **Legacy installation reports a warning:** See [Migrate from a Previous Installation](../Migrate-from-Previous-Installation.md).
- **MATLAB MCP Server or Model-Based Design skills are unavailable:** Run `agentic-toolkit-installer configure`, then restart your agent.


## Skill: testing-simulink-models

### Why Does the Toolkit Use Gherkin for Test Authoring?

The toolkit uses Gherkin as the test authoring format because it balances three needs: large language models (LLMs) generate it reliably, it maps naturally onto how requirements are written, and humans can review it quickly.

Rather than asking an LLM to create and maintain complex Simulink Test artifacts directly, the agent generates a simple, reviewable text file that `model_test` converts into Simulink Test artifacts. This approach also works consistently across MATLAB releases.

- **LLM reliability.** There is a large corpus of Gherkin on the internet, so LLMs are well-trained on the syntax and produce it consistently. The Gherkin execution model is also similar to pytest: the agent outputs a constrained file, runs it, and interprets the results. LLMs also have extensive pretraining data for this pattern.

- **Natural alignment with requirements.** Gherkin is designed for behavior-based testing, which maps directly to how requirements are written. Easy Approach to Requirements Syntax (EARS) notation, widely used in automotive and aerospace, uses the same logical structure — *When \<trigger\>, the system shall \<response\>* — but with different keywords. A requirement and a Gherkin scenario are cognitively the same object. This alignment makes it straightforward for the agent to translate requirements into test files. The agent can then focus its reasoning on the engineering problem rather than on managing tool APIs or harness lifecycles.

- **Human reviewability.** A Gherkin file sits at the intersection of what agents can output reliably and what humans can review quickly. As AI-assisted workflows scale, agents generate content while humans review it, and that review needs to be cognitively simple. Gherkin keeps the review simple.

- **Broad release compatibility.** The toolkit targets MATLAB releases back to R2023a. Gherkin is a plain-text format that `model_test` translates into Simulink Test artifacts, so it works across releases without depending on version-specific APIs.

- **Domain-specific extensions.** The Gherkin specification does not define the full set of semantics needed for Simulink testing (for example, input signals, tolerances, logged signals). The toolkit overlays additional structured sections for inputs and assessments that the agent generates alongside the standard Given/When/Then steps.

- **Future evolution.** This is not necessarily the final answer. The ideal interface — one an agent can generate and a human can review — will keep evolving as both LLM capabilities and Simulink Test features advance. MathWorks is developing Model-Based Design generative AI benchmarks to run tradeoff experiments across different test formats.
