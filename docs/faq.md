# Frequently Asked Questions

## Environment

### How can I check whether Simulink Agentic Toolkit has been set up correctly?

**From MATLAB:** Call `satk_initialize`, then run `validate_installation`:

```matlab
satk_initialize
validate_installation
```

This runs six checks in order and prints a summary:

| # | Check | What it verifies |
|---|-------|-----------------|
| 1 | MATLAB version | R2023a or later |
| 2 | Simulink | Installed and licensed |
| 3 | Tool entry points | All MCP tool functions are on the MATLAB path |
| 4 | Package resolution | `+sage` and `+mbd` packages resolve inside the toolkit and are not shadowed |
| 5 | MCP server binary | `matlab-mcp-server` exists at `~/.matlab/agentic-toolkits/bin/` |
| 6 | MCP connectivity | `shareMATLABSession` is available and the MATLAB connector is running |

The output uses pass/fail/warning icons and provides a fix suggestion for each failed check. If all checks pass, the overall result is **PASS** and MCP tools are ready for use by your AI coding agent.

**From your AI coding agent:** Verify that MCP tools and skills are registered. The method varies by agent:

| Agent | Check MCP tools | Check skills |
|-------|----------------|--------------|
| Claude Code | `/mcp` | `/skills` |
| GitHub Copilot | VS Code command palette: `MCP: List Servers` | Skills visible in chat `@` mentions |
| OpenAI Codex | `codex --list-tools` or check `~/.codex/config.toml` | Check `.codex-plugin/plugin.json` registration |
| Sourcegraph Amp | Check `~/.config/amp/settings.json` for MCP config | Verify `amp.skills.path` in settings |
| Gemini CLI | `gemini --list-tools` or check `~/.gemini/settings.json` | Check `gemini-extension.json` registration |

You should see the `matlab` MCP server with tools like `model_overview`, `model_read`, `model_edit`, `model_query_params`, `model_resolve_params`, and `model_test`. For skills, look for the Model-Based Design skills (e.g., `building-simulink-models`, `testing-simulink-models`, `simulating-simulink-models`) and the setup skill (`simulink-agentic-toolkit-setup`).

**Common fixes for failures:**

- **Checks 1–2 fail (halts remaining checks):** Upgrade MATLAB or install Simulink.
- **Checks 3–4 fail:** Run satk_initialize to add the toolkit paths, or remove conflicting path entries that shadow the toolkit packages.
- **Check 5 warns:** Run `setupAgenticToolkit("install")` to download the MCP server binary.
- **Check 6 fails:** Install the MATLAB MCP Server Toolbox (downloaded automatically during setup), then restart MATLAB and re-run `satk_initialize`.
- **`/mcp` shows no matlab server:** Re-run the setup skill (`simulink-agentic-toolkit-setup`) to register the MCP server with your agent, or verify the binary path in your agent's MCP configuration.
- **`/skills` is missing MBD skills:** Re-run the setup skill to register skills globally, or confirm the toolkit plugin is installed for your agent.


## Skill: testing-simulink-models

### Why is gherkin used for test authoring?

Gherkin was selected as the test authoring format because it sits at a sweet spot — LLMs generate it reliably, it maps naturally onto how requirements are written, and humans can review it quickly.

Rather than asking an LLM to create and maintain complex Simulink Test artifacts directly, the agent generates a simple, reviewable text file that `model_test` converts into Simulink Test artifacts. This approach also works consistently across MATLAB releases.

- **LLM reliability.** There is a large corpus of Gherkin on the internet, so LLMs are well-trained on the syntax and produce it very consistently. Gherkin's execution model is also similar to pytest — the agent outputs a constrained file, runs it, and interprets results — which is another pattern LLMs have extensive pretraining data on.

- **Natural alignment with requirements.** Gherkin is designed for behavior-based testing, which maps directly to how requirements are written. EARS notation (Easy Approach to Requirements Syntax), widely used in automotive and aerospace, uses the same logical structure — *When \<trigger\>, the system shall \<response\>* — just with different keywords. A requirement and a Gherkin scenario are cognitively the same object. This makes translating requirements into test files straightforward for the agent, and lets 100% of its reasoning go toward the engineering problem rather than toward managing tool APIs or harness lifecycles.

- **Human reviewability.** A Gherkin file sits at the intersection of what agents can output reliably and what humans can review quickly. As AI-assisted workflows scale, agents will generate while humans review — and that review needs to be cognitively simple. Gherkin delivers that.

- **Broad release compatibility.** The toolkit targets MATLAB releases back to R2023a. Gherkin is a plain-text format that `model_test` translates into Simulink Test artifacts, so it works across releases without depending on version-specific APIs.

- **Domain-specific extensions.** The Gherkin specification itself does not define the full set of semantics needed for Simulink testing (e.g., input signals, tolerances, logged signals). The toolkit overlays additional structured sections for inputs and assessments that the agent generates alongside the standard Given/When/Then steps.

- **Future evolution.** This is not necessarily the final answer. The ideal interface — one an agent can generate and a human can review — will keep evolving as both LLM capabilities and Simulink Test features advance. MBD GenAI benchmarks are being developed to run tradeoff experiments across different test formats.
