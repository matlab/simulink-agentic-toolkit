---
name: simscape-write-ssc
description: >
  Use when writing or editing Simscape Language (.ssc) source files — components,
  domains, or functions. Triggers include: model a physical component in .ssc;
  write physical equations for a Simscape block; add or modify physics or
  parameterization options in a Simscape component; build a composite component.
  Also use for validating .ssc syntax, fixing Simscape Language errors, or
  converting governing equations into working Simscape component code. Do NOT use
  for configuring or connecting existing Simscape blocks in a Simulink model —
  that is model building, not language authoring.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Simscape Language Authoring

Write .ssc files (components, domains, functions) that pass validation and are
physically correct.

## When to Use

- Writing a new .ssc component, domain, or function from scratch
- Adding or modifying physics, equations, or parameterization in an existing .ssc file
- Converting governing equations into a working Simscape component
- Adding mode charts, events, or switching logic to a component
- Building a composite component that connects subcomponents together
- Fixing Simscape Language syntax or validation errors

## When NOT to Use

- Configuring or connecting existing Simscape blocks in a Simulink model — use
  `building-simulink-models` instead
- Simulating a model or inspecting results — use `simulating-simulink-models`
- Setting block parameters from MATLAB or a script without editing .ssc source

---

# Workflow

## Designing a component

Below are the sections that make up a Simscape component. Include only what is needed.

### `nodes`, `inputs`, `outputs`

- **`nodes`** — quantity participates in bilateral energy exchange (the network
  enforces Across equalization + Through summation).
- **`inputs`** — physical signal imposed from outside (control signal, environment).
- **`outputs`** — physical signal for a measurement or computed result.

Node ports have a domain. Reuse an existing one, especially foundation; author a custom
domain only when none covers the physics.

| Physics | Domain path |
|---|---|
| Electrical (single-phase) | `foundation.electrical.electrical` |
| Rotational mechanical | `foundation.mechanical.rotational.rotational` |
| Translational mechanical | `foundation.mechanical.translational.translational` |
| Thermal (heat transfer) | `foundation.thermal.thermal` |

For fluid domains, polyphase electrical, position/angle-based mechanical variants, or any
domain not in the table, you must read: `references/foundation/domain-selection.md`.

### `parameters`, `variables`

**Parameters** — user-configurable inputs; part of the interface.

- Expose as `parameters` for physical quantities the engineer sets (resistances,
  dimensions, thresholds).
- Use `parameters(Access=private)` for quantities computed from other parameters. Use 
  `intermediates` when the value depends on a runtime value.
- Defaults: physically typical values, so the component works out of the box.

**Variables** — differential, algebraic, or event.

- Differential (appear in `der(x)`): set `priority.high`; use an initial equation only
  when the start depends on another variable rather than a fixed/parameter value — never both.
- Event: declare `(Event = true)`

**Visibility (both):** default `Access = public`, `ExternalAccess = modify` for
user-facing items. `Access = private` + `ExternalAccess = none` for pure implementation
detail; `protected` + `observe` for internal quantities that subclasses or logging should see.

**Units — declare everywhere.** Every parameter and variable carries a unit
(`{value, 'unit'}`, or `'1'` for dimensionless). Simscape validates commensurability at
compile time and auto-converts across the network. Declare in the unit the engineer
naturally uses (`mm`, `deg`, `bar`). A bare number is a silent mismatch waiting to happen.

### Compile-time vs. runtime conditionals (`if`)

- **Interface items** (ports, variables the user sees): declared unconditionally (public).
  Use **conditional annotations** + `ExternalAccess` to hide/show them based on a
  parameter — they remain part of the interface but become invisible in inactive variants.
- **Internal items** (hidden variables, internal equations): prefer **compile-time `if`**
  (top-level, parameter-guarded) to eliminate them entirely — reduces states, logging,
  and solver work.
- **Runtime `if`** (inside `equations`): use when the governing equation changes at
  runtime. Must have an `else` branch. Equation count/dimensionality must be **identical**
  in every branch.

### `equations`, `intermediates`, `components`, `connections`, `for`, `modecharts`, `events`, `annotations`

| Section | Include when |
|---|---|
| `equations` | continuous relationships (`==` is symmetric equality), `assert` for parameter validation, `equations (Initial=true)` for init-only constraints |
| `intermediates` | factor a reused subexpression or want it logged |
| `components` / `connections` | assembling from existing subcomponents (composite) |
| `for` | arrays of components or nodes |
| `modecharts` | the component has discrete operating states, each with a **structurally different** equation set (different equation counts, or `der` terms that come/go) — and transitions between them, possibly with hysteresis. Overkill when a smooth approximation (`tanh`, `tablelookup`) or runtime `if` with identical equation counts fits. |
| `events` | update `variables(Event=true)` (latches, sample-hold, one-shot triggers) at discrete instants via `edge()` / `initialevent`. Prefer `modecharts` when suitable. |
| `annotations` | conditional visibility (`ExternalAccess` overrides), icons (`Icon`), dialog tabs (`UILayout`), port sides (`Side`), logging units (`LoggingUnit`), fault modeling (`Faults`), or unit dropdowns (`UnitDropdown`) |
| `setup` | **never** — deprecated; use `assert` in `equations` instead |

## Write the .ssc file

Write for textbook readability — equations should read as physics. Match the surrounding
library's conventions when editing an existing file.

## Validate

`simscape.agentic.sscIssues` (in `scripts/+simscape/+agentic/`) takes the fully qualified
name of a Simscape component, domain, or function and prints diagnostics or "No issues
found." Run it with `evaluate_matlab_code`, `project_path` set to the skill's `scripts/`
folder so MATLAB can find the package. Fix reported issues and re-validate until clean.

```matlab
simscape.agentic.sscIssues("mylib.components.MyComponent")
```

**Pass the fully qualified name — dot-separated namespaces, not a file path.** A file at
`+mylib/+components/MyComponent.ssc` on the MATLAB path is named
`mylib.components.MyComponent`. The function errors if the name is not on the path or does
not resolve to a .ssc/.sscp file.

**Setting `project_path` changes the current folder, so the working folder and the files
the component references may drop off the path.** A `not found on the MATLAB search path`
error, or a `Validation failed:` diagnostic naming a missing referenced file, is a path
problem — not a bug in the `.ssc`. Add necessary folders to the path before treating
diagnostics as real.

# Reference files (`references/`)

Each file is self-contained. Read only what you need.

```
references/
  composition/
    arrays-of-nodes.md
    composite-components-and-connections.md
    composites-member-variable-initialization.md
    for-loop-component-arrays.md
    inheritance-and-subclassing.md
    optional-and-variant-members.md
  equations-and-variables/
    assertions-and-bounds.md
    intermediates-and-let.md
    variables-derivatives-initialization.md
  foundation/
    domain-selection.md
    gas.md
    isothermal-liquid.md
    moist-air.md
    thermal-liquid.md
    two-phase-fluid.md
  language-functions/
    matlab-declaration-functions.md
    tablelookup.md
    writing-simscape-functions.md
  modecharts-and-events/
    events-and-event-variables.md
    modecharts.md
  parameters-and-conditionals/
    access-and-visibility-attributes.md
    conditional-sections-and-hiding-members.md
    enumerations.md
    parameter-declaration.md
  ports-and-nodes/
    branches.md
    nodes-conserving-ports.md
    physical-signal-inputs-and-outputs.md
  presentation/
    block-appearance-and-ports.md
    uilayout-and-dialog-tabs.md
```

----

Copyright 2026 The MathWorks, Inc.

----
