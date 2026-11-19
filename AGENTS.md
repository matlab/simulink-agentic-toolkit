<!-- Copyright 2026 The MathWorks, Inc. -->

# Simulink Agentic Toolkit — Agent Instructions

## Setup

If the user asks to install, update, or set up the Simulink Agentic Toolkit, direct them to the Agentic Toolkit Installer: https://github.com/matlab/agentic-toolkit-installer. Do not attempt to run setup commands on the user's behalf.

## Domain Skills

Simulink domain skills are in `skills-catalog/model-based-design-core/`. Each skill has a `SKILL.md` with instructions and a `manifest.yaml` with metadata.

## MCP Tools

Nine MCP tools are available when the MCP server is connected (see `tools/registry.json`):
- `model_overview` — hierarchical model visualization
- `model_read` — block topology and expression notation
- `model_edit` — structural modifications
- `model_check` — structural validation (unconnected ports, dangling lines, Edit-Time Checks on States and Subcharts)
- `model_read_diagnostics` — read errors, warnings, and info from the Diagnostic Viewer
- `model_query_params` — random access to parameters
- `model_resolve_params` — resolve workspace variables
- `model_scan` — regex search of the saved `.slx` file on disk for a specific block, parameter value, or string
- `model_test` — Gherkin-based behavioral testing (requires Simulink Test)

## MATLAB Prerequisite

The installer configures the MCP server with `--matlab-session-mode=auto`: it connects to a shared MATLAB session if one exists and otherwise starts its own. No per-session setup is needed; the toolkit is on the MATLAB path automatically. To use the MATLAB session the user already has open, guide them to run `shareMATLABSession` in it. If tools fail to connect or report "Undefined function", guide the user to run `satk_doctor` in MATLAB, which checks the MATLAB path and session sharing and suggests fixes. For installed versions, configured agents, or the MCP server, guide them to run `agentic-toolkit-installer status` in a terminal. `satk_initialize` and `validate_installation` are deprecated; do not suggest them to users. `validate_installation` is not on the MATLAB path for installer users, so if a script calls it, suggest `satk_doctor` instead.
