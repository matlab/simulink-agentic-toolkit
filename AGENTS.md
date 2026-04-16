# Simulink Agentic Toolkit — Agent Instructions

## Setup

If the user asks to set up the Simulink Agentic Toolkit, use the setup skill at `skills-catalog/toolkit/simulink-agentic-toolkit-setup/SKILL.md`. This automates platform detection, MCP server installation, agent configuration, and verification.

## Domain Skills

Simulink domain skills are in `skills-catalog/model-based-design-core/`. Each skill has a `SKILL.md` with instructions and a `manifest.yaml` with metadata.

## MCP Tools

Six MCP tools are available when the MCP server is connected (see `tools/registry.json`):
- `model_overview` — hierarchical model visualization
- `model_read` — block topology and expression notation
- `model_edit` — structural modifications
- `model_query_params` — random access to parameters
- `model_resolve_params` — resolve workspace variables
- `model_test` — Gherkin-based behavioral testing (requires Simulink Test)

## MATLAB Prerequisite

The MCP server uses `--matlab-session-mode=existing`. MATLAB must be running with `satk_initialize` executed (which calls `shareMATLABSession`) before MCP tools will work. The `MATLABMCPCoreServerToolkit.mltbx` must be installed once per MATLAB version. If tools fail to connect, guide the user to run `addpath('<toolkit_root>'); satk_initialize` in MATLAB.
