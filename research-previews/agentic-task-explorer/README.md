<!-- Copyright 2026 The MathWorks, Inc. -->

# Agentic Task Explorer

The Agentic Task Explorer stages and presents structured agentic tasks for live demonstrations and interactive exploration.

The task explorer is installed with the Simulink Agentic Toolkit. Install the toolkit and configure your agent with the [Agentic Toolkit Installer](https://github.com/matlab/agentic-toolkit-installer). You do not need to run any setup in MATLAB first: `slAgenticTaskExplorer` is on the MATLAB path, and staging a task shares your MATLAB session so that your agent works in it.

## Quick Start

```matlab
% Open task explorer with example selector
slAgenticTaskExplorer

% Stage a specific example
slAgenticTaskExplorer('D01')

% Stage from a custom example collection
slAgenticTaskExplorer('D01', '/path/to/examples')

% Stage to a custom workspace location
slAgenticTaskExplorer('D01', [], '~/my-workspace')

% Stage without opening the task explorer UI
slAgenticTaskExplorer('D01', [], [], true)
```

## Function Reference

```matlab
slAgenticTaskExplorer(example_id, data_path, workspace_root, skip_presenter)
```

| Parameter | Default | Description |
|-----------|---------|-------------|
| `example_id` | `[]` | Example ID to stage, or `[]` to open the task explorer |
| `data_path` | `[]` (sibling `examples/` folder) | Path to an example collection directory |
| `workspace_root` | `%USERPROFILE%\mbd-demo` (Windows) or `~/mbd-demo` (Linux/macOS) | Root directory for the staged workspace |
| `skip_presenter` | `false` | Skip opening the task explorer UI |

## What Happens When You Stage a Task

1. Closes all open Simulink models and clears the base workspace
2. Validates that all referenced files exist
3. Creates/clears the workspace directory (`workspace_root/workspace`)
4. Copies task files (shared + task-local) to the workspace
5. In a repository checkout only, copies the Model-Based Design Core skills to the workspace (an installed toolkit uses the skills that the installer configured for your agent)
6. Writes `.gitignore` and initializes a git repository
7. Opens the model (if `context_variables.model_name` is set)
8. Shares the MATLAB session (`shareMATLABSession`) so that your agent connects to it instead of starting its own
9. Opens VS Code in the workspace directory
10. Prints the runbook to the MATLAB command window
11. Displays the task explorer UI

## Task Validation

```matlab
% Validate all tasks in an example collection
validate_tasks('/path/to/examples/tasks')

% Validate a single task
validate_tasks('/path/to/examples/tasks', 'D01')
```

## File Structure

```
agentic-task-explorer/
├── README.md                     # This file
├── CONTRIBUTING_EXAMPLES.md      # Task authoring guide
├── src/
│   ├── slAgenticTaskExplorer.p   # Main entry point
│   ├── validate_tasks.p          # Task validation
│   └── presenter_template.html   # Task explorer UI template
└── examples/
    ├── tasks/                    # One subfolder per example
    │   ├── D01/
    │   │   └── task.json
    │   ├── D02/
    │   │   └── task.json
    │   └── ...
    ├── shared/                   # Files shared across examples
    └── dataset.json              # Collection metadata
```
