# Adding Tasks to the Agentic Task Explorer

## Quick Start: Add a Task

**1.** Create a folder in `examples/tasks/` with your task ID:

```
examples/tasks/D15/
└── task.json
```

**2.** Write a minimal `task.json`:

```json
{
  "id": "D15",
  "title": "Verify Interface Compliance",
  "workspace": {
    "context_variables": {
      "model_name": "StabilityControlSystem.slx"
    },
    "include_files": [
      "$/StabilityControlSystem.slx",
      "$/interface.json"
    ]
  },
  "steps": [
    {
      "title": "Check the model against its interface definition",
      "prompt": "Compare the interface of StabilityControlSystem.slx against interface.json. Report any mismatches.",
      "look_for": [
        "Agent reads interface.json",
        "Agent reads the model interface (model_overview or model_read)",
        "Agent identifies port count mismatches"
      ]
    }
  ],
  "presentation": {
    "section": "4 — Verify & Quality",
    "order": 5,
    "duration": "5-8 min",
    "background": "The interface.json was updated after a requirement change but the model hasn't been updated to match."
  }
}
```

**3.** Stage and test:

```matlab
slAgenticTaskExplorer('D15')
```

This opens the workspace in VS Code with the model loaded. Paste the prompt into the agent, observe the results, edit `task.json`, and re-stage until it flows well.

---

## task.json Reference

```jsonc
{
  "id": "D15",                              // Unique ID — must match folder name
  "title": "Human-readable title",          // Shown in task explorer
  "description": "What this task demonstrates.",

  "workspace": {
    "context_variables": {                   // Free-form key-value pairs
      "model_name": "MyModel.slx"           // model_name auto-opens during staging
    },
    "include_files": [                       // Files copied into workspace
      "$/shared_model.slx",                  // $/ = from shared/ folder
      "local_script.m"                       // no prefix = from task folder
    ]
  },

  "steps": [                                 // At least one step required
    {
      "prompt": "The request to give the agent.",
      "title": "Step title for presenter",
      "notes": "Internal notes (not shown to agent).",
      "look_for": ["Specific observable behavior"],
      "recovery": "If agent gets stuck: 'Try this...'"
    }
  ],

  "presentation": {                          // Controls task explorer display
    "section": "1 — Understand & Document",  // Grouping label
    "order": 1,                              // Sort order (lower = first)
    "duration": "5-8 min",                   // Estimated time
    "background": "Context for the presenter.",
    "skills": ["building-simulink-models"],   // Skills staged in workspace
    "good_looks_like": ["Success criteria"],
    "recording": "https://...",              // Link to pre-recorded video
    "visible": true                          // false to hide from menu
  }
}
```

### include_files

Files are declared in `workspace.include_files` using glob patterns:

| Pattern | Source | Example |
|---------|--------|---------|
| `$/model.slx` | `shared/` folder | Shared across tasks |
| `$/libs/*` | `shared/libs/` | All files in a shared subfolder |
| `script.m` | Task folder | Task-local file |
| `*.m` | Task folder | All `.m` files in task folder |

Shared files (`$/`) are copied first; task-local files are copied second and overwrite on conflict. `task.json` is never copied to the workspace.

> **Note:** `context_variables.model_name` does **not** auto-include the file — you must list it in `include_files` separately.

### presentation

All fields are optional. Defaults: `skills` defaults to `["building-simulink-models", "testing-simulink-models", "generate-requirement-drafts"]`, `visible` defaults to `true`, everything else defaults to empty.

Set `"visible": false` to hide a work-in-progress task from the menu while keeping it stageable by ID.

The `recording` field accepts any URL your team can access. The task explorer opens it in the system browser.

---

## Writing Effective Tasks

**Write prompts as a real user would.** Don't spell out the answer — the task is more compelling when the agent discovers things itself.

Good: *"I'm seeing an issue with the brake torque distribution. Can you reproduce and root cause it?"*

Avoid: *"Find the bug in BrakeTorqueDistribution where Mux4 u3 and u4 are swapped."*

**Make look_for items specific and observable.** Each item should name a concrete tool call, finding, or action — not a subjective judgment.

Good:
```json
"look_for": [
  "Agent calls model_overview → model_read on BrakeTorqueDistribution",
  "Agent identifies root cause: u3 and u4 on Mux4 are swapped",
  "Agent writes a Gherkin test — test fails confirming the bug"
]
```

Avoid:
```json
"look_for": ["Agent does a good job", "Agent finds the bug"]
```

**For multi-step tasks, design a narrative arc.** Step 1 investigates, step 2 proposes a fix, step 3 executes, step 4 verifies. Later prompts can be short (e.g., `"Fix it."`) since the agent carries context forward.

---

## Folder Structure

```
examples/
├── tasks/                          # One subfolder per task
│   ├── D01/
│   │   ├── task.json               # Task definition (required)
│   │   └── local_data.mat          # Task-local files (optional)
│   └── D02/
│       └── task.json
├── shared/                         # Files shared across tasks
│   ├── StabilityControlSystem.slx
│   └── interface.json
└── dataset.json                    # Collection metadata (optional)
```

Each collection is self-contained — no cross-collection references. See existing tasks in `examples/tasks/` for working examples.
