# Script API Reference (Agent Only)

Usage reference for the bundled `scripts/`. The scripts ship as P-code, so `help` shows
nothing — use this file instead. Add the skill's `scripts/` folder to the MATLAB path
first (`addpath('<this-skill>/scripts')`). Path arguments accept char or string.

React to the **identifiers** below (`err.identifier` / `lastwarn`), not to message text.

---

## svg_to_dvg

Turn a raw, flat SVG into a DVG-ready skeleton (sanitize + adapt in one call).

```matlab
out = svg_to_dvg(inputPath)
out = svg_to_dvg(inputPath, outputPath)
out = svg_to_dvg(inputPath, outputPath, partName, width, height)
```

| Argument | Default | Meaning |
|---|---|---|
| `inputPath` | required | Raw SVG file |
| `outputPath` | `[]` | When non-empty, the result is written here |
| `partName` | `'base'` | Base part title |
| `width`, `height` | `[]` | Block size (number or char); `[]` leaves the SVG size unchanged |

- Returns the DVG-ready SVG text (`out`); not displayed when called without an output.
- What it does: strips unsupported/unsafe content, moves presentation attributes into
  inline `style`, adds the `xmlns`/`xmlns:d`/`xmlns:xlink` declarations and
  `version="1.1"`, sets `width`/`height`, assigns unique ids (`<tag>_<n>`) to drawables
  and plain `<g>` groups, and wraps the content in the base Part
  `<g title="<partName>" ie-elementType="Part" ie-base-part="true">`. A top-level
  `id="frame"` element and `<defs>` stay direct `<svg>` children.
- With a `viewBox`, `width`/`height` are taken from the viewBox (author it as `0 0 W H`).

| Identifier | Kind | Meaning / reaction |
|---|---|---|
| `svg_sanitize:InvalidSVG` | error | Not well-formed, no `<svg>` root, empty, or nothing valid left. Fix the SVG and retry |
| `dvg_adapt:InvalidSVG` | error | Sanitized SVG has no `<svg>` root or is empty (not expected in practice) |
| `dvg_adapt:ViewBoxSizeMismatch` | warning | Requested size differs from the viewBox; the viewBox size was used |
| `dvg_adapt:CanvasFitToFrame` | warning | The `id="frame"` bbox differs from the canvas; viewBox and width/height now follow the frame |

---

## dvg_set

Set `d:` / `ie-` attributes on one element (or the root) without hand-editing XML.

```matlab
dvg_set(svgPath, elementId, attrs)                       % batch
dvg_set(svgPath, elementId, attrs, outputPath)
dvg_set(svgPath, elementId, attrName, attrValue)         % single attribute
dvg_set(svgPath, elementId, attrName, attrValue, outputPath)
```

| Argument | Default | Meaning |
|---|---|---|
| `svgPath` | required | DVG SVG (the `svg_to_dvg` output) |
| `elementId` | required | Target id; `[]` or `''` targets the root `<svg>` |
| `attrs` | — | Nx2 cell `{name, value; ...}` or a single `{name, value}` |
| `attrName`, `attrValue` | — | Single-attribute form; both required |
| `outputPath` | `svgPath` | Write elsewhere (empty = in place) |

- No return value. An existing attribute is replaced; a new one is added.
- Setting `d:textContent` on a `<text>` also sets `ie-elementType="Expression"`.
- Setting `d:options` containing `Port:...` on a `<text>` also adds class
  `dvg-port-label`.

| Identifier | Kind | Meaning / reaction |
|---|---|---|
| `dvg_set:IdNotFound` | error | No element with that id; the message lists the available ids |
| `dvg_set:InvalidSVG` | error | `svgPath` has no `<svg>` root |
| `dvg_set:BadAttrs` | error | `attrs` is not an Nx2 cell, or a name is empty |
| `dvg_set:BadArgs` | error | Single form missing `attrValue`, or `outputPath` is not text |

---

## dvg_add_part

Attach a non-base Part, or a First Fit size tier, from a separate `svg_to_dvg` output.

```matlab
ids = dvg_add_part(targetSvgPath, partSvgPath)
ids = dvg_add_part(targetSvgPath, partSvgPath, visibleExpr)
ids = dvg_add_part(targetSvgPath, partSvgPath, visibleExpr, outputPath)
ids = dvg_add_part(___, FirstFit=true)
```

| Argument | Default | Meaning |
|---|---|---|
| `targetSvgPath` | required | The icon to add to |
| `partSvgPath` | required | A `svg_to_dvg` output; its first Part `<g>` is attached |
| `visibleExpr` | `''` | `d:visible` for the new part (`''` = always visible) |
| `outputPath` | `targetSvgPath` | Write elsewhere (empty = in place) |
| `FirstFit` | `false` | Add as a First Fit tier instead of a sibling Part |

- Returns the new part's element ids after insertion (ids colliding with the target get a
  `_<n>` suffix) — target these with `dvg_set`. Prints one `Added ...` line.
- The attached part loses `ie-base-part`.
- `FirstFit=true`: the first call wraps the target's existing Part(s) in
  `<g ie-elementType="FirstFit" d:options="Select:FirstFit;">` as the leading tier(s);
  later calls append inside it. Attach tiers **largest → smallest**. `ie-base-part` and
  `d:visible` are removed from every tier, and `Resize:Off` is set in the root
  `d:options`.
- The part file must be drawn on the target's canvas (same viewBox, else width/height).
- Nothing is written when an error is raised.

| Identifier | Kind | Meaning / reaction |
|---|---|---|
| `dvg_add_part:NoPart` | error | `partSvgPath` (or, for the first First Fit call, the target) has no Part `<g>`; run `svg_to_dvg` first |
| `dvg_add_part:InvalidSVG` | error | Either file has no `<svg>` root |
| `dvg_add_part:BadArgs` | error | `visibleExpr` combined with `FirstFit=true`; omit `visibleExpr` |
| `dvg_add_part:PartCanvasMismatch` | error | Part canvas differs from the icon's; redraw the part on the icon canvas |
| `dvg_add_part:ResizeOverridden` | warning | Root had another `Resize` value; it was changed to `Off` |

---

## dvg_add_equation

Add a LaTeX `<math>` equation to the base Part (falls back to the first Part).

```matlab
newId = dvg_add_equation(svgPath, latex)
newId = dvg_add_equation(svgPath, latex, Name=Value)
```

| Argument / option | Default | Meaning |
|---|---|---|
| `svgPath` | required | DVG SVG; its root width/height (else viewBox) give the icon size |
| `latex` | required | LaTeX markup; wrapped in `$$...$$` unless it already contains `$`, `\[` or `\(` |
| `CenterX` | icon width / 2 | Equation center x (`cx`) |
| `CenterY` | icon height / 2 | Equation center y (`cy`) |
| `FontSize` | size-appropriate default | Font size in px; override only on request |
| `OutputPath` | `svgPath` | Write elsewhere (empty = in place) |

- Returns the new element id (`eq_1`, `eq_2`, ...) — target it with `dvg_set` (e.g. to
  add `d:visible`). Prints one `Added equation ...` line.
- Writes `cx`/`cy`, `scalingFactors` and `font-size`; no width/height. These depend on the
  icon size, so add equations once the block size is final.

| Identifier | Kind | Meaning / reaction |
|---|---|---|
| `dvg_add_equation:InvalidSVG` | error | No `<svg>` root |
| `dvg_add_equation:NoIconSize` | error | Root has no positive width/height or viewBox; run `svg_to_dvg` with the block size |
| `dvg_add_equation:NoPart` | error | No Part `<g>` to hold the equation; run `svg_to_dvg` first |

---

## dvg_validate

Pre-registration check of a DVG SVG. `register_icon` also runs it.

```matlab
issues = dvg_validate(svgPath)
issues = dvg_validate(svgPath, blockPath)
```

| Argument | Default | Meaning |
|---|---|---|
| `svgPath` | required | DVG SVG to check |
| `blockPath` | `''` | When given, also checks `d:visible`/`d:textContent` comparisons against the block's popup options |

- Returns a struct array of issues with fields `severity` (`'error'`/`'warning'`) and
  `message`; not displayed when called without an output. On any error it throws instead
  of returning.
- **Errors:** not well-formed / no `<svg>` root; missing `xmlns` (always),
  `xmlns:d` / `xmlns:xlink` (when `d:` / `xlink:` attributes are used); unsupported
  element; missing required shape attribute (rect width/height, circle r, line
  x1/y1/x2/y2, path d, image x/y/width/height); rect width/height ≤ 0 or a negative
  dimension; `<image>` using `href` or missing `xlink:href`; a `Frame` token other than
  `Rectangle`/`Adaptive`/`Off`; any transform on `<svg>`/`<g>`, or a shape transform
  other than a single rotation.
- **Warnings:** unknown `d:` attribute; `rotate(a)` without a centre; malformed
  `d:options` segment; unrecognised `d:repeatFor`; a drawable or untitled `<g>` directly
  under `<svg>`; no Part at all; First Fit wrapper with a non-Part child or an
  `ie-base-part` tier; `Resize` other than `Off` with First Fit; root-level
  `Select:FirstFit`; `id="frame"` bbox not matching the canvas; (with `blockPath`) a popup
  compared to a non-option string, or to a number without the `value_` prefix.

| Identifier | Kind | Meaning / reaction |
|---|---|---|
| `dvg_validate:Invalid` | error | Lists every error; fix the SVG and re-run |
| `dvg_validate:Suspect` | warning | Lists every warning; review, fix if the icon is likely wrong |

---

## inspect_block

Gather the facts needed to plan an icon. Read-only; runs headless.

```matlab
json = inspect_block(blockPath)
json = inspect_block(blockPath, verbose)
```

| Argument | Default | Meaning |
|---|---|---|
| `blockPath` | required | Full block path; the model must be open |
| `verbose` | `true` | Also print the JSON; `false` = return it quietly |

Returns a JSON string (decode with `jsondecode`):

| Field | Content |
|---|---|
| `isMasked` | `true`/`false` |
| `params` | Mask parameters `{name, type, options}`; `options` holds popup/combobox/enumeration choices (empty when none or unmasked) |
| `existingIcon` | `{key, file}` of a registered DVG icon, else empty |
| `ports` | `{PortType, PortNumber, Label}` per port, including labels promoted from an underlying subsystem or referenced model |
| `size` | `{width, height}` in pixels, from the block position |
| `isSimscape` | `true` for a Simscape component block (has a `SourceFile`) |
| `sourceFile` | Resolved `.ssc`/`.sscp` path, or `''` |

| Identifier | Kind | Meaning / reaction |
|---|---|---|
| `inspect_block:BlockNotFound` | error | Block missing or model not open |

---

## register_icon

Register the final SVG on the block and verify it renders.

```matlab
iconKey = register_icon(blockPath, svgPath)          % mode 'file'
iconKey = register_icon(blockPath, svgPath, mode)    % 'file' | 'model' | 'simscape'
```

| Argument | Default | Meaning |
|---|---|---|
| `blockPath` | required | Full block path; the model must be open |
| `svgPath` | required | Final DVG SVG |
| `mode` | `'file'` | Storage mode (below) |

Runs `dvg_validate(svgPath, blockPath)` first, so nothing is changed if the SVG is
invalid. Returns the icon key; not displayed when called without an output. Prints an
`Icon registered (<mode>): ...` line on success.

| Mode | Behavior |
|---|---|
| `'file'` | Creates a mask if needed. References the SVG **in place** by file name, so its folder must stay on the MATLAB path; adds the folder for this session (`register_icon:PathAdded`) unless already on the path or `pwd`. Key `MaskBlockIcon.<name>` (suffixed if that key is taken by a different file) |
| `'model'` | Creates a mask if needed. **Copies** the SVG into the model (reusing the block's previous embedded file name if any); save the model to persist it. Key `MaskBlockIcon.<model>.<name>` |
| `'simscape'` | No mask. **Copies** the SVG next to the component file as `<component>.svg` and puts the package root on the path. If the model is saved and not dirty, reloads it (reopening it if it was open) and verifies the block resolves to the icon; otherwise writes the file and warns `register_icon:ReloadNeeded`. Key = the icon file path |

| Identifier | Kind | Meaning / reaction |
|---|---|---|
| `MATLAB:register_icon:unrecognizedStringChoice` | error | `mode` is not `'file'`, `'model'` or `'simscape'` |
| `register_icon:SvgNotFound` | error | `svgPath` does not exist |
| `register_icon:BlockNotFound` | error | Block missing or model not open |
| `dvg_validate:Invalid` | error | SVG failed validation; fix and re-run |
| `register_icon:NotRendered` | error | Icon did not render / block does not resolve to it; fix the SVG (Phase 6) and re-register |
| `register_icon:NoMaskCache` | error | `'model'` mode could not resolve the model's icon storage folder |
| `register_icon:NoSourceFile` | error | `'simscape'` on a block without a resolvable `SourceFile` |
| `register_icon:ReadOnlyLocation` | error | Simscape component folder (or existing `.svg`) is read-only; ask the user to grant write access |
| `register_icon:KeyExhausted` | error | No free `'file'` key for that file name; rename the SVG |
| `register_icon:PathAdded` | warning | Folder added to the path for this session only; tell the user to persist it (`savepath` / `startup.m`) |
| `register_icon:ReloadNeeded` | warning | Simscape icon written, but the model has unsaved changes; ask the user to save and reopen it |
| `dvg_validate:Suspect` | warning | Validation warnings (registration continues) |

---

## open_in_iconeditor

Open the block's registered icon for manual fine-tuning. Use only on explicit request.

```matlab
open_in_iconeditor(blockPath)
```

| Argument | Default | Meaning |
|---|---|---|
| `blockPath` | required | Full block path; the model must be open |

- No return value. Simscape blocks open in the standalone IconEditor window; other blocks
  open the Mask Editor on its Icon tab (the SVG icon tab when a DVG icon is registered,
  else the Icon & Ports tab).
- If the tab switch fails, the Mask Editor stays open and a message names the tab to
  click — no error.

| Identifier | Kind | Meaning / reaction |
|---|---|---|
| `open_in_iconeditor:BlockNotFound` | error | Block missing or model not open |

----

Copyright 2026 The MathWorks, Inc.

----
