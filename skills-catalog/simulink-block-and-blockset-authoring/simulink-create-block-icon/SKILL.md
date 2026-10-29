---
name: simulink-create-block-icon
description: "Create and register Simulink block icons programmatically. Use when asked to create an icon, generate a block icon, design an SVG icon for a Simulink block, register an icon, or help with IconEditor features like visibility conditions, layout constraints, parts, port labels, dynamic text, or block frame shapes (e.g. a round or capsule outline)."
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "0.1.1"
---

# Simulink Block Icon Creator

Creates Simulink block icons the MathWorks-recommended way: a DVG SVG registered on the block
(not `MaskDisplay` drawing), which stays editable in the IconEditor.

## When to Use

Use this skill when the user wants to create, design, or register a graphical icon on a Simulink block — including:
- Generating an SVG icon for a block (masked, plain, or Simscape component)
- Adding dynamic icon behavior: visibility conditions, live expression/parameter text, equations, relative positioning, or first-fit sizing
- Drawing or anchoring port labels on a block's icon
- Registering an existing icon SVG onto a block, or opening a block's icon in the IconEditor

## When NOT to Use

- Editing a model's structure, parameters, ports, or connections (adding/wiring/deleting blocks, changing block parameters, Stateflow internals) — that is model building, not icon appearance (e.g. `building-simulink-models`, if available).
- Registering or configuring `.slx` block libraries for model building — that is library setup, not icon creation (e.g. `setup-custom-libraries`, if available).

**Mixed requests.** If a request also needs something outside icon authoring (e.g. a port that
doesn't exist yet), tell the user up front that this part is out of this skill's scope. If they
already asked for it, it can be done without this skill; otherwise ask. Do the icon part once its
prerequisites exist.

## Key Functions

Bundled in `scripts/`; all require Simulink, R2026a or later.

| Function | Purpose | Toolbox | Available From |
|----------|---------|---------|----------------|
| `inspect_block` | Read a block's mask params, ports, size, existing icon, Simscape info | Simulink | R2026a |
| `svg_to_dvg` | Convert a plain SVG into a DVG-ready icon skeleton | Simulink | R2026a |
| `dvg_set` | Set dynamic attributes (`d:visible`, `d:options`, …) on an element | Simulink | R2026a |
| `dvg_add_part` | Attach another part or First Fit tier | Simulink | R2026a |
| `dvg_add_equation` | Add a LaTeX equation element | Simulink | R2026a |
| `dvg_validate` | Check the icon before registering | Simulink | R2026a |
| `register_icon` | Register the icon on the block and verify it renders | Simulink | R2026a |
| `open_in_iconeditor` | Open the registered icon in the IconEditor | Simulink | R2026a |

Full signatures, options and error ids: [references/script-api.md](references/script-api.md).

---

## Phase 0: Entry

Route on what the conversation already provides:
- **An icon description** (what it should look like, ideally its block) → go to **Phase 1**.
- **A capability question** ("what can you do?", "can an icon show …?") → answer from
  [references/features.md](references/features.md), then invite them to describe their icon.
- **Icon work is wanted but not described** → ask briefly for the block and the look, e.g.
  *"a motor icon for myModel/Motor that turns red when overheating"* or *"show the gain value
  on myModel/Gain"*.

---

## Phase 1: Create — Requirements Gathering

DO NOT present a rigid numbered questionnaire. Instead, say:

> Describe the icon you'd like to create — what it should look like, any dynamic behavior, and which block it's for. I'll ask follow-ups for anything I need.

Then based on what the user provides, identify what's missing and ask only for those. Key information needed:

- **Target block** — block path in an open model (**required — see below**)
- **Visual appearance** — what to draw (always needed)
- **Dynamic behavior** — only ask if user hints at it or the use case implies it
- **Port labels** — only ask if block has ports and user hasn't mentioned it

Be conversational. If user says "a motor icon for myModel/Motor that turns red when overheating", you already have: visual (motor), block (myModel/Motor), dynamic (red on overheat) — just clarify what parameter drives "overheating".

**The target block is required — do NOT generate without it.** Every later phase depends on
`inspect_block` output (canvas size, mask params, ports, Simscape detection), and the icon has
nowhere to go without a block. If the user hasn't named a block in an open model, ask for it
before doing anything else:

> Which block is this icon for? Give me its path in an open model (e.g. `myModel/Motor`).

Do not proceed to Phase 2 until you have a valid block path and `inspect_block` has succeeded on it.

**Inspect the block first.** Once you have the target block (and the model is open), run `inspect_block` via MATLAB MCP to ground the plan in facts instead of assumptions:

```matlab
% TEMPLATE — not executable
addpath('<this-skill>/scripts');   % absolute path to THIS skill's scripts/ dir
json = inspect_block('<block_path>');
```

It returns JSON (mask params, existing icon, ports, size, Simscape info). Use the results to:
- **Pre-fill dynamic options** — offer visibility/expression conditions from the actual mask `params` rather than guessing names.
- **Warn on existing icon** — if `existingIcon` is non-empty, tell the user the block already has an icon and confirm they want to replace it.
- **Seed port labels** — if `ports` is non-empty and the user wants labels, use the promoted `Label` values.
- **Set canvas size** — carry `size.width`/`size.height` into Phase 2 as the default canvas.
- **Detect Simscape** — if `isSimscape` is true, the block registers by a different mechanism (icon saved next to the component file, no mask). Skip the storage-mode question in Phase 5 and use `'simscape'` mode.

---

## Phase 2: Plan

Before generating, present a structured plan. Keep it readable:

> ## Icon Plan
>
> **Block:** `<path>`
> **Size:** W × H | **Frame:** type
>
> **Parts:**
> 1. `base` — always visible: [brief description]
>
> **Port labels:** [ports/faces to label — only if labels were requested]
> 
> **Dynamic behavior:** 
> [Visibility / Text rows that apply — omit if static]
> 
> **Behavior:** 
> [only if a specific resize/rotation/zoom/color behavior was requested]
>
> Does this look right? I'll generate the SVG on confirmation.

**Show only rows that apply — never print empty/placeholder rows.**
- **Port labels** is *content*, not dynamic behavior — list only if the block has ports *and* labels were requested.
- **Dynamic behavior**, each row only if used: **Visibility** (conditional elements), **Text** (live expressions). Omit the section (icon is static) if none apply.
- **Behavior** (resize/rotate/zoom/stroke/colors): defaults suit almost every icon — **do not surface unprompted**. Add a **Behavior** line only when the user asked for a specific behavior; otherwise omit it. Syntax + defaults: svg-format.md §10.

**Canvas size:** default the canvas (W × H) to the block's actual size from `inspect_block` (Phase 1). Only deviate if the user asks for a specific size.

**Default to a SINGLE part.** Put everything in one `base` part and drive per-element show/hide with element-level `d:visible`. Use multiple parts *only* for major visual-state changes (a fundamentally different layout per mode) or when the user explicitly asks for parts. See [references/parts.md](references/parts.md).

Wait for user confirmation.

---

## Phase 3: SVG Generation & DVG Prep

Author a **plain, flat SVG**, then convert it to a DVG-ready skeleton in one step. No `d:` dynamism attributes yet — those are layered in Phase 4.

1. Read [references/generation-guidelines.md](references/generation-guidelines.md) and internalize the rules before drawing.
2. Generate the SVG — focus on visual quality, correct geometry, flat solid colors only. Basic shapes: rect, circle/ellipse, path, line, text.
3. Write the raw SVG to a temp file.
4. Convert it to a DVG-ready skeleton with `svg_to_dvg` (one call that sanitizes **and** adapts). Run via MATLAB MCP (`scripts/` already on the path from Phase 1):

```matlab
% TEMPLATE — not executable
svg_to_dvg('<raw.svg>', '<dvg.svg>', '<name>', <W>, <H>);
```

- `<W>`/`<H>` = the block size from `inspect_block` (Phase 1). Omit (or pass `[]`) to leave the SVG dimensions unchanged.
- `<name>` = the base part name (default `base`).
- It assigns the element ids Phase 4 targets, so run it before adding dynamism.

**On failure:** the sanitize stage raises `svg_sanitize:InvalidSVG` whose message states the reason. Fix the SVG (close tags, quote attributes, remove malformed XML) and re-run. Limit to 2 fix attempts; if it still fails, regenerate the SVG.

For SVG format reference (agent use only): [references/svg-format.md](references/svg-format.md)

If the plan needs **multiple parts**, run `svg_to_dvg` on the base part here; the
additional parts are authored the same way and attached with `dvg_add_part` in Phase 4.

**Non-rectangle frame.** A shaped frame is a hidden `id="frame"` element authored here plus
`Frame:Adaptive` in Phase 4. When a user wants to customize the frame, offer the built-in
presets first and author a custom shape only if none fits — preset list, geometry, and
snippets are in svg-format.md §2. A plain rectangle is the default — emit no frame
token at all; `Frame:Off` needs no element, just the token.

---

## Phase 4: Apply Dynamism

Add DVG attributes with `dvg_set` — never hand-edit the XML (a malformed
attribute silently renders a blank icon). Target an element by its Phase-3 id:

```matlab
% TEMPLATE — not executable
dvg_set('<dvg.svg>', '<elementId>', {'d:visible','<expr>'; 'd:left','<expr>'});
dvg_set('<dvg.svg>', [], {'d:options','Frame:Off;'});  % [] → root <svg>
```

Set per the plan:

- `d:visible="expression"` on parts/elements
- `d:left/right/top/bottom/hcenter/vcenter` for layout constraints
- `d:textContent="expression"` on text
- Port labels: `d:options="Port:L0;"` binds a label to a port; `d:repeatFor` for variable port counts (niche) — see svg-format.md §8
- `d:options` on the root `<svg>` (frame) or per element (resize/rotate/zoom/stroke/foreground/background)

Equations: `dvg_add_equation('<dvg.svg>', '<latex>')` builds the `<math>` element and returns its id
— no hand-authored XML. See svg-format.md §6.

**Extra parts** — author each as a flat SVG, `svg_to_dvg` it, then attach with
`dvg_add_part('<dvg.svg>','<alt.svg>','<visibility expr>')`; it returns the new
ids to target with `dvg_set`. See svg-format.md §3.

**First Fit** — the Phase 3 `<dvg.svg>` is the largest tier; attach each smaller tier in
order with `dvg_add_part('<dvg.svg>','<tier.svg>',FirstFit=true)`. See svg-format.md §9.

**Parameter values.** A param by name resolves to its literal dialog *text* — compare quoted
against the exact option strings from `inspect_block` (`RotorCount === 'Four'`, never `=== 4`);
prefix `value_` for the evaluated value (`value_gain > 1.5`). Full rule + syntax:
[references/svg-format.md](references/svg-format.md); `dvg_validate` flags the common mistakes.

Write the resulting SVG to a **temp working path** (e.g. under `tempdir`), named from the
block (e.g. `<blockName>.svg`). Don't pick a durable location yet — that's the Phase 5
storage decision.

**Validate before registering.** Even well-formed `d:` expressions can carry a logic
error. Catch it before touching the block:

```matlab
% TEMPLATE — not executable
dvg_validate('<final_svg_path>', '<block_path>');   % scripts/ already on the path
```

It **throws `dvg_validate:Invalid`** for render-breaking problems (malformed XML, missing
namespaces etc.) — fix and re-run. It **prints
warnings** for likely-wrong-but-renders issues.

---

## Phase 5: Register

`register_icon` takes the **final SVG file** (Phase 4 output) plus a `mode` and does the rest;
there is no separate "save the SVG" step. The model must be open. **Registering a user's
existing SVG:** run it through `svg_to_dvg` and `dvg_validate` first, like a generated one.

```matlab
% TEMPLATE — not executable
addpath('<this-skill>/scripts');   % absolute path to THIS skill's scripts/ dir
register_icon('<block_path>', '<final_svg_path>', 'file');    % external file (default)
register_icon('<block_path>', '<final_svg_path>', 'model');   % save with model
register_icon('<block_path>', '<final_svg_path>', 'simscape'); % Simscape blocks
```

> SVG is ready — registering it on `<block>` now.

**Pick the mode:**

- **Simscape** (`inspect_block` reported `isSimscape: true`) — **no storage question**. The icon
  must sit next to the component file, so use `'simscape'` directly.
- **Masked/plain block** — ask the user how to store it:

  > How should the icon be saved?
  >
  > **1. As an external file** — a standalone `.svg` you can share across blocks and models.
  > Its folder must stay on the MATLAB path for the icon to render after a restart.
  > **2. With the model** — embedded in the model; always renders and travels with the model.
  > The model file grows slightly.

**`'file'` handoff.** This mode references the SVG **in place** (it isn't copied), so it must
already sit in its durable folder. Confirm the path with the user (default `pwd`), **copy the
Phase 4 temp SVG there**, then pass *that* path to `register_icon(..., 'file')`:

> I'll save the icon to `<full_svg_path>`. Is that the right location? For the icon to render,
> that folder must be on the MATLAB path — **now and each time you restart MATLAB** (add it via
> `savepath` or `startup.m`).

**Name clash (`'file'`).** If registration warns that the icon file name *is shadowing another
name in the MATLAB path*, another `.svg` with that name exists and the block may load the wrong
one after a restart. Tell the user, suggest a more specific name (e.g. `<model>_<block>.svg`) or
ask for one, save the copy under it, and re-register.

`'model'` and `'simscape'` **copy** the SVG, so the temp source is fine as-is.

**Simscape read-only folder.** If the component folder is locked, `register_icon` raises
`register_icon:ReadOnlyLocation`. **Don't change permissions yourself** (OS-specific, often needs
elevation) — ask the user, then re-run:

> The Simscape component folder `<dir>` is read-only, and the icon must be saved next to the
> component file there. Please grant write access to that folder,
> then let me know and I'll register again.

If it can't be made writable, stop and explain the icon can't be associated without writing there.

**A clean return means the icon rendered** (`register_icon` verifies before returning), so
proceed to wrap-up. On `register_icon:NotRendered` the SVG was rejected at render time — iterate
and re-register (Phase 6); never report a blank icon as done.

**Wrap up once `register_icon` returns successfully.** Close with a short message — three
parts only: a done line, the single storage line matching the mode chosen, and a
closing line. Keep it tight; don't recap features or dump the SVG.

> ✅ Done — the icon is registered on `<block>` and rendering.
>
> [Storage line — include only the one matching the chosen mode:]
> - **file:** Saved to `<full_svg_path>` — keep that folder on the MATLAB path (now and after restart) or the icon won't re-resolve.
> - **model:** Embedded in the model — **save the model** to persist it; it then travels with the model.
> - **simscape:** Saved as `<basename>.svg` next to the component — keep that folder on the MATLAB path so it re-resolves after restart.
>
> Want any changes? Describe them and I'll update the icon. You can also open it in
> the IconEditor to fine-tune it yourself — just ask and I'll open it there.

**Opening in the IconEditor (only on request).** The skill registers directly and iterates on
feedback, so do NOT open the editor by default. Only if the user explicitly asks to fine-tune
it there, run:

```matlab
% TEMPLATE — not executable
open_in_iconeditor('<block_path>');   % scripts/ already on the path from Phase 1
```

It opens the registered icon on the right surface by block type (masked/regular → Mask Editor's
Icon tab; Simscape → standalone IconEditor window). Requires a registered icon.

---

## Phase 6: Iteration

Route change requests to the appropriate phase:
- Visual changes → Phase 3
- Add/change dynamic behavior → Phase 4
- Structural redesign → Phase 2
- Register on different block → Phase 5
- Fine-tune manually in the IconEditor → `open_in_iconeditor('<block_path>')` (see Phase 5)

---

## References (Agent Use Only)

- Feature overview: [references/features.md](references/features.md)
- SVG format: [references/svg-format.md](references/svg-format.md)
- Script API: [references/script-api.md](references/script-api.md)
- Example: [references/examples/feature-showcase.svg](references/examples/feature-showcase.svg)

----

Copyright 2026 The MathWorks, Inc.

----
