# SVG Format Reference for IconEditor/DVG Icons (Agent Only)

This is the single implementation reference for the on-disk DVG markup. It is organized
feature by feature. **On-disk tokens are not the UI labels** — always emit the on-disk
token shown here.

The `value_`/`value@` rule is stated once, under **Visibility conditions**; other
sections link to it rather than restating it.

---

## 1. Root element & structure

```xml
<svg xmlns="http://www.w3.org/2000/svg"
     xmlns:d="http://www.mathworks.com/blockgraphics"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     version="1.1"
     width="W" height="H">
```

- The `xmlns:d` namespace is required for all DVG-specific attributes; `xmlns:xlink`
  is required for image references.
- `d:options` on the `<svg>` root carries **icon-level** options (see
  **Behavior in Simulink Editor** and **Frames**). **Omit any option whose value equals the
  default** — write only values that differ from it. A plain rectangular block
  needs no `d:options` at all (the default frame is `Rectangle`, so no `Frame`
  token is written).

Structure:

```
<svg>
  ├── <ellipse|rect|path id="frame">       ← optional custom frame, at icon level
  └── <g title="..." ie-elementType="Part" ie-base-part="true">   ← Part group(s)
        ├── <rect>, <ellipse>, <path>, <line>, <text>, <image>, <math>
        └── <g> (nested groups)
```

Part group markup:

```xml
<g title="base" ie-elementType="Part" ie-base-part="true">
    <!-- always-visible elements -->
</g>
<g title="active" ie-elementType="Part" d:visible="mode === 'Active'">
    <!-- shown only when active -->
</g>
```

Parts render in document order (first = back, last = front).

**Transforms:** only a single rotation on a leaf shape — `rotate(a cx cy)` or an equivalent
pure-rotation `matrix(...)`. No `transform` on `<g>`/Part/First Fit/`<svg>`, and no
translate/scale/skew; `dvg_validate` errors on these (`rotate(a)` without a centre warns).

---

## 2. Frames — `Frame` key in `d:options` on the `<svg>` root

**Valid on-disk `Frame` tokens** (the only values written to the SVG):

| Token | UI label | Meaning |
|-------|----------|---------|
| `Rectangle` | Rectangle | Standard rectangular border (default) |
| `Adaptive`  | *(custom shapes)* | Boundary follows a custom shape / the icon content |
| `Off`       | None     | No frame; icon sits directly on the canvas |

> The UI shape names **Circle, Capsule, Triangle, Trapezium, Hexagon, Chart are NOT `Frame:` values.** On disk they all serialize as `Frame:Adaptive` plus a boundary element carrying `id="frame"` — a `<rect>`, `<ellipse>`, `<path>`, `<polygon>`, `<polyline>`, or `<line>` that defines the shape (all six tags are valid frame elements). The `class="customBlockFrame"` is written **only for the built-in PRESET frames** (Circle/Capsule/Triangle/Trapezium/Hexagon/Chart). A **hand-authored** custom frame needs only `id="frame"` — no class required. The frame element sits at the icon level (a direct `<svg>` child), NOT inside a Part. `Frame:Adaptive` alone (no frame element) makes the frame adapt to the outermost path of the content.

> The `id="frame"` element is hidden (`visibility="hidden"`); it only defines the boundary geometry — Simulink draws the actual adaptive frame from it.

```xml
<!-- default rectangle: omit the Frame token entirely (Rectangle is the default) -->
<svg ...>

<!-- no frame (UI "None") -->
<svg ... d:options="Frame:Off;">

<!-- hand-authored custom frame: Adaptive + a hidden boundary element id="frame" -->
<svg ... d:options="Frame:Adaptive;">
  <path id="frame" visibility="hidden" d="M 0,0 L 30,15 L 0,30 Z"/>
  <g title="base" ie-elementType="Part" ie-base-part="true">
    <!-- icon content -->
  </g>
</svg>
```

Note `visibility="hidden"` is an XML attribute, not a `style` property.

> **Stateflow chart blocks** default to the `Chart` preset, not `Rectangle` — on disk
> that is `Frame:Adaptive` plus a `<rect id="frame" rx="10" ry="10">` (a rounded
> rectangle). Emit `Frame:Rectangle` only to explicitly override it.

### Preset frame shapes

The IconEditor offers a fixed set of boundary presets. When a user asks to customize the
frame, **offer these presets first**; author a custom shape only if none fits. Each preset
is a single hidden `id="frame"` element plus `d:options="Frame:Adaptive;"` on the `<svg>`
root. Add `class="customBlockFrame"` to match a built-in preset (a purely
hand-authored frame needs only `id="frame"`). Every frame element also carries
`style="fill:#ffffff;"` and `visibility="hidden"`.

Geometry below is each preset's **native template box** — copy it verbatim, or scale the
coordinates to your icon's W×H (the element defines the boundary the block adapts to).

| Preset | UI availability | Tag | Native geometry (template box) |
|--------|-----------------|-----|--------------------------------|
| Rectangle | default (normal block) | — | *no element* — omit the Frame token (default) |
| None | all | — | *no element* — use `Frame:Off` |
| Circle | all | `ellipse` | `cx="200" cy="200" rx="200" ry="200"` (box 400×400) |
| Capsule | all | `path` | `d="M 400,100 C 400,155.5 355,200 318.8,200 Q 282.56,200 200,200 Q 117.43,200 81.2,200 C 45,200 0,155.75 0,100 C 0,44.22 45,0 81.2,0 Q 117.43,0 200,0 Q 282.56,0 318.8,0 C 355,0 400,45 400,100 Z"` (box 400×200) |
| Triangle | all | `path` | `d="M 0,0 L 400,200 L 0,400 L 0,0 Z"` (box 400×400) |
| Trapezium | all | `path` | `d="M 0,0 L 160,104 L 160,296 L 0,400 L 0,0 Z"` (box 160×400) |
| Hexagon | all | `path` | `d="M 0,0 L 80,0 L 160,96 L 160,304 L 80,400 L 0,400 L 0,0 Z"` (box 160×400) |
| Chart | Stateflow default | `rect` | `x="0" y="0" width="400" height="400" rx="10" ry="10"` |

- **All presets serialize as `Frame:Adaptive`** — the preset name is not stored; the
  shape is encoded entirely by the `id="frame"` element's geometry.
- **The frame is the icon's outermost boundary — its bounding box must span the full
  canvas** (`viewBox` / `width` / `height`, i.e. `0..W, 0..H`). A frame smaller than the
  canvas (e.g. `r=30` circle on an 80×60 canvas) validates but renders the default
  rectangle. Scale the native coordinates to the canvas — e.g. Triangle →
  `M 0,0 L W,H/2 L 0,H Z`, Circle → `cx="W/2" cy="H/2" rx="W/2" ry="H/2"` (as computed
  literals). Presets have a natural aspect ratio (Circle/Triangle/Chart 1:1, Capsule 2:1,
  Trapezium/Hexagon 2:5); to keep it undistorted, **size the canvas to the frame**. `svg_to_dvg` enforces this —
  if the frame's bbox differs from the canvas it sets the viewBox and width/height to the
  frame bbox and warns `dvg_adapt:CanvasFitToFrame`; `dvg_validate` warns on a mismatch.
- Example (custom triangle for a 60×40 block):

```xml
<svg ... d:options="Frame:Adaptive;">
  <path id="frame" class="customBlockFrame" style="fill:#ffffff;" visibility="hidden"
        d="M 0,0 L 60,20 L 0,40 L 0,0 Z"/>
  <g title="base" ie-elementType="Part" ie-base-part="true"><!-- content --></g>
</svg>
```

- **The only valid `Frame:` tokens are `Rectangle`, `Adaptive`, `Off`.** There is **no**
  `Cylinder`, `Rounded`, `Circle`, etc. token — a shaped frame is always `Frame:Adaptive`
  plus the geometry element above.

For all resize/rotate/stroke-scaling/foreground/background options (formerly listed here), see **Behavior in Simulink Editor** below.

---

## 3. Parts

Each part is a `<g>`:

```xml
<g title="base" ie-elementType="Part" ie-base-part="true">...</g>
<g title="advanced" ie-elementType="Part" d:visible="mode === 'Advanced'">...</g>
```

- `title` — part name, unique within the icon.
- `ie-elementType="Part"` — **case-sensitive; capital `P`**. A lowercase or misspelled
  value is **not** recognized as a Part marker; such a `<g>` is treated as a plain
  Group unless it independently qualifies for the legacy fallback below.
- `ie-base-part="true"` — the base part; always rendered, drawn first, its elements
  appear in every other part.
- **Legacy fallback:** a `<g title="...">` with **no** `transform` is still treated as
  a part even without `ie-elementType`. Do not rely on this — always emit
  `ie-elementType="Part"`.
- `ie-ports="left:simulink,..."` may appear on Parts of existing icons — do **not**
  hand-author it; omit it.
- **One canvas.** A Part has no geometry of its own; all parts share the icon's canvas.
  Draw every part file on the icon's `viewBox` — `dvg_add_part` copies its coordinates
  as-is and raises `dvg_add_part:PartCanvasMismatch` on a different canvas.

---

## 4. Visibility conditions — `d:visible`

Applied to a part `<g>` or an individual element:

```xml
<g d:visible="mode === 'Advanced'">...</g>
<rect d:visible="value_temperature > 80"/>
```

The expression evaluates against the block's mask parameter workspace at render time.
Applied to a part, it shows/hides the whole part and its children; applied to an
element, only that element.

**`value_` (disk) vs `value@` (UI) — canonical rule (stated here once):**

- **Direct (default):** a param referenced by name resolves to its **literal dialog
  string**. Compare quoted — `mode === 'Advanced'`; a popup with options
  `{'Two','Four'}` needs `RotorCount === 'Four'`, never `=== 4` (numeric-vs-popup is
  always false and the element silently never renders). This holds even when option
  labels look numeric (options `{'1','2','4'}` → `n === '4'`).
- **Evaluated:** prefix the param with **`value_`** and compare unquoted —
  `value_RotorCount === 4`, `value_gain > 1.5`.
- **On disk the prefix is `value_`.** The IconEditor UI shows it as `value@` (`@` is
  not a valid identifier char). **Always emit `value_`.** This rule applies equally to `d:textContent` (see **Expression text**).

**Operators:** prefer `===` / `!==` (these are what the Condition Builder generates).
Also valid, evaluated as raw JavaScript: `==`, `!=`, `<`, `>`, `<=`, `>=`, `&&`,
`||`, `!`.

**Geometry references (applies equally to the layout constraints in section 7).** Both
`d:visible` and the relative-position constraints accept full JS arithmetic and geometry
references, evaluated (deferred) at render time:

- `iconBlock` geometry — e.g. switch layout by aspect ratio with
  `d:visible="(iconBlock.bottom - iconBlock.top) < 25"`.
- element geometry — `.height` / `.width` / `.top` / `.bottom` / `.left` / `.right`
  (and `.hcenter` / `.vcenter`) of any referenced element.
- self-references — an element may reference its own `.height` (etc.).

---

## 5. Expression text — `d:textContent`

```xml
<text id="display" d:textContent="'Gain: ' + gainValue"
      x="50" y="30" width="40" height="12">
    <tspan dx="0" dy="0" x="50">Gain: K</tspan>
</text>
```

- `d:textContent` — JavaScript expression evaluated at render time against the mask
  workspace.
- The `<tspan>` content is the design-time fallback only (shown while editing).
- Direct vs. evaluated parameter values follow the **`value_` rule** in section 4
  (`RotorCount` → `Four`; `value_RotorCount` → `4`).

**Object-literal dispatch.** Because `d:textContent` is evaluated as general JavaScript,
a value-map (object-literal) dispatch is supported — index a literal map by a parameter:

```xml
<text ... d:textContent="{'Element':Gain,'Matrix_Ku':Gain+'*u'}[multType]">
    <tspan dx="0" dy="0" x="15">K</tspan>
</text>
```

**Edit-on-block (`d:clientData`).** Adding
`d:clientData="{'blockParam':'ParamName'}"` on a text/expression element lets a user
double-click the label on the Simulink canvas to edit that parameter inline. Place it on
the same element as `d:textContent`. Optional; omit for read-only text.

---

## 6. Equation — `<math>`

Build equations with `dvg_add_equation('<dvg.svg>', '<latex>', Name=Value…)` — it emits the
`source=math` form below (sets `cx`/`cy` and `scalingFactors` from the icon size, wraps
`$$…$$`, omits width/height) and returns the element id. Prefer the helper; this section is
the on-disk reference behind it.

An equation is a `<math>` element. Two forms:

```xml
<!-- source=math (current). width/height OMITTED. -->
<math id="eq_1" class="equation" cx="…" cy="…" scalingFactors="…"
      style="font-size:…px">$$\frac{1}{s}$$</math>

<!-- source=text (legacy), math wrapped in CDATA inside a <text> -->
<text cx="40" cy="30" scalingFactors="4" source="text"
      ><![CDATA[<math style="font-size:13px">$\frac{1}{s}$</math>]]></text>
```

- Positioning is by **center**: `cx`/`cy` (NOT `x`/`y`). `cx`/`cy` may also be `middle` or
  a percentage like `40%`. Prefer numeric.
- **`width`/`height` are OPTIONAL — omit them.** When absent, the equation is sized from
  its LaTeX and font size and centered on `cx`/`cy`. A written width/height is used
  verbatim and mis-sizes the equation, so don't guess them.
- **`scalingFactors` is NOT a constant** — it depends on the `<svg>` root size, so never
  hand-write it or copy it between icons; `dvg_add_equation` sets it (if the icon size
  changes, rebuild the icon so the equation is added again at the new size). It is a separate XML attribute (no hyphen), **not** a CSS property —
  inside `style` it is ignored.
- **Default font size:** `dvg_add_equation` sets a size-appropriate default font size;
  override with `FontSize=` only on request.
- **The LaTeX must be delimited by `$...$` or `$$...$$`** (double = display style); content
  without `$` does not render. The helper adds `$$…$$` automatically.
- Equations accept `d:visible` and relative-position constraints like any element.

> **LEGACY — DO NOT EMIT.** `ie-elementType="Equation"` together with `data-latex` /
> `data-font-size` is a **legacy** form. Never write it. Always emit the
> `<math>` form above.

---

## 7. Relative position — `d:left/right/top/bottom/hcenter/vcenter`

Applied to elements (not part `<g>` groups):

```xml
<rect id="box" x="10" y="10" width="80" height="60"/>
<text d:hcenter="box.hcenter" d:vcenter="box.vcenter"
      x="50" y="40" width="20" height="10">
    <tspan dx="0" dy="0" x="50">Hi</tspan>
</text>
```

- Constraint attributes: `d:left`, `d:right`, `d:top`, `d:bottom`, `d:hcenter`,
  `d:vcenter`. Reference attributes also include `height` and `width`.
- Query syntax: `<id>.<attr>[+/-offset]` — e.g. `box.right+10`, `label.top`,
  `iconBlock.vcenter`.
- Special reference `iconBlock` = the block boundary (canvas edge).
- `x`/`y`/`width`/`height` remain as design-time fallbacks; constraints override at
  render. Both `d:left`+`d:right` stretch horizontally; `d:top`+`d:bottom` stretch
  vertically.
- Constraints accept full JS arithmetic, `iconBlock`/element geometry, and
  self-references — see **Geometry references** in section 4.

> **Gotcha:** only element IDs within the **first Part** are resolvable by a
> constraint. A constraint that references an id in another part will not
> resolve.

---

## 8. Port labels / binding

Two distinct mechanisms — **do not conflate them:**

- **Bind a label to a specific port** — the common case. A static text element tied
  to one known port. Use this to label named ports (e.g. `in`/`out`).
- **Auto-generate labels across a face** (`d:repeatFor`) — a niche case for a
  *variable* number of ports, where one label is generated **per port**
  automatically.

### Bind a label to a specific port (common)

```xml
<text class="dvg-port-label" style="font-size:7px;"
      d:options="Port:L0;"
      x="2" y="35" width="16" height="7">
    <tspan dx="0" dy="0" x="2">in</tspan>
</text>
```

- **Port encoding:** `L`/`R`/`T`/`B` + 0-based index (`L0`, `R2`, `T0`, `B1`, …).
- The binding **anchors** the element to that port, so it tracks the port as the
  block resizes — no layout constraints needed.
- Port-label `<text>` elements carry the CSS class `dvg-port-label` — it makes them port
  labels (readable orientation, anchor offset) rather than plain port-anchored elements.
  `dvg_set` adds it when it binds a `<text>` to a port.
- `AnchorDistance` offsets the label from the port face
  (`d:options="Port:R1;AnchorDistance:15"`); written **only when ≠ 0**, omit
  otherwise.
- Any element can be bound, not just text — e.g. a connector graphic:
  `<g d:options="Port:L0;AnchorDistance:15"><path style="stroke:#0072bd;" d="M 0,0 L 5,0"/></g>`.

> **Simscape:** port labels are disabled for Simscape blocks (labels for Simscape
> blocks come from the `.ssc` file). Port *binding* itself still applies.

### Auto-generate labels across a face (niche) — `d:repeatFor`

Use **only** when the port count is variable and you want one auto-generated label
per port. A `d:repeatFor` group is instantiated once per port on the chosen face;
each copy **must** carry layout constraints to position it:

```xml
<g d:repeatFor="port in ports.leftPorts"
   d:left="iconBlock.left+2"
   d:vcenter="ports.left(repeatFor.index).y">
    <text style="font-size:7px;" x="2" y="0" width="16" height="7">
        <tspan dx="0" dy="0" x="2">In</tspan>
    </text>
</g>
```

- **Iterator collection** is `Ports`-suffixed: `ports.leftPorts`, `ports.rightPorts`,
  `ports.topPorts`, `ports.bottomPorts`.
- **Position constraint** uses the **un-suffixed** side name + `repeatFor.index`:
  `ports.left(repeatFor.index).y` / `ports.right(...).y` (left/right) or
  `ports.top(repeatFor.index).x` / `ports.bottom(...).x` (top/bottom). Note the
  asymmetry — iterator `ports.leftPorts`, constraint `ports.left(...)`.
- **Three generation algorithms** differ *only* in the text each copy shows:

  | Algorithm | `d:repeatFor` | `d:textContent` | Each copy shows |
  |---|---|---|---|
  | **Duplicate** | `port in ports.leftPorts` | *(none)* | the static `<tspan>` text, identical on every port |
  | **Increment** | `port in ports.leftPorts` | `'In' + (repeatFor.index + 1)` | `In1`, `In2`, `In3`, … (a param name may replace the `'In'` literal) |
  | **Use Parameter Value** | `myParam.split(';', ports.leftPorts.length)` | `repeatFor.item` | the `;`-split tokens of mask parameter `myParam` |

- **`repeatFor.item` is a string only in the split (Use Parameter Value) form.** With
  `port in ports.<side>Ports` it is the port *object* — binding text to it renders
  `[object Object]`. For **Duplicate** omit `d:textContent` (the `<tspan>` is used);
  for numbering use `repeatFor.index` (0-based). `port.y` / `port.x` / `port.label`
  do **not** exist.

---

## 9. First Fit

On-disk, First Fit **wraps** Part groups. The wrapper is a direct `<svg>` child `<g>` with
`ie-elementType="FirstFit"`; its children are `<g ie-elementType="Part">` size tiers,
ordered **largest → smallest** (the first tier, in document order, that fits is
shown). Build it with `dvg_add_part(..., FirstFit=true)` rather than by hand:

```xml
<g ie-elementType="FirstFit" d:options="Select:FirstFit;">
    <g ie-elementType="Part"><!-- largest / most detailed tier --></g>
    <g ie-elementType="Part"><!-- medium tier --></g>
    <g ie-elementType="Part"><!-- smallest / simplest tier --></g>
</g>
```

- At render, the first (largest) tier that fits the current block size is shown; nothing
  is shrunk or cropped.
- **Always emit the wrapper `<g>`.** `Select:FirstFit` on the root `<svg>` (no wrapper)
  is **not** recognised by the IconEditor.
- **Requires `Resize:Off`** at the icon level. `Off` is the default, but write
  `Resize:Off` explicitly in the root `d:options` for First Fit icons (`dvg_add_part`
  does this). First Fit chooses the tier by block size itself, so it does not combine
  with `FitToBlock`/`ShrinkOnly` resize — `dvg_validate` warns if resize is not `Off`.
- **No base part inside First Fit.** The tiers are mutually exclusive (only the largest
  that fits is shown), so none is a base part — do not set `ie-base-part` (or
  `d:visible`) on a tier.
- Draw each tier on the icon canvas, content centred; a smaller tier just uses less of
  it (§3 One canvas).
- A separate inline First Fit group mechanism exists for child-switching *inside*
  a single Part (advanced; rarely authored).

---

## 10. Behavior in Simulink Editor — `d:options`

These options control resize, rotation, zoom/stroke scaling, orientation, and
foreground/background behavior. Icon-level options go on the `<svg>` root; element
context options go on the element (or its group). A token that equals the default is
simply omitted.

### Icon context (options on the `<svg>` root)

| UI label | `d:options` key | On-disk tokens (→ UI) | Default (omit when) |
|---|---|---|---|
| Rotate | `Rotate` | `On`, `Off` | `On` |
| Resize | `Resize` | `Off`, `FitToBlock` (On), `ShrinkOnly` (Shrink Only) | `Off` |
| Resize Limit | `ScalingOnResizeMax` | float | `0` |
| Scale Stroke with Ports | `StrokeScaling` | `PortStyled` (On), `None` (Off) | `Off` |
| Scale Stroke with Zoom | `StrokeScalingOnZoom` | `Linear` (On), `ConstantIn` (Off) | `On` |
| Scale Stroke on Resize | `StrokeScalingOnResize` | `NonScaling` (Off), `Linear` (On), `ShrinkOnly` | `On` |
| Normalize Stroke | `PreAdjustStrokeWidth` | `Normalized` (On), `None` (Off) | `Off` |
| Foreground | `Foreground` | `On` (Allow), `Off` (Disallow), `PortStyled` (Inherit from Ports) | `Allow` |
| Background | `Background` | `On` (Allow), `Off` (Disallow), `Transparent` | `Allow` |

`Foreground`/`Background` are icon-only.

> **Simscape defaults & style override:** for Simscape blocks, `Foreground` defaults to
> `PortStyled` (inherit from ports); `Background` still defaults to `Allow` (`Transparent`
> is often *recommended*, but it is **not** the default — do not assume it). While `Foreground` is `PortStyled`, authored `fill`,
> `stroke`, opacity, and font colors on shapes are **overridden at render** by the
> Simscape subdomain colors — setting them in the SVG has no effect. (This lock applies
> to pure Simscape component blocks; subsystems merely wired for Simscape keep their
> authored styles.)

### Element context (options on the element)

| UI label | `d:options` key | On-disk tokens (→ UI) | Default |
|---|---|---|---|
| Rotate (dropdown) | `Orientation` | `WithParent`, `Readable`, `Fixed`, `WithPorts` | `WithParent` |
| Resize | `ScalingOnResize` | `Constant` (Off), `WithParent` (On), `ShrinkOnly`, `Adaptive` | `On` |
| Resize Limit | `ScalingOnResizeMax` | float | `0` |
| Horizontal Scaling | `ScalingOnResizeX` | `Constant` (Off), `WithParent` (On), `ShrinkOnly` | `On` |
| Vertical Scaling | `ScalingOnResizeY` | `Constant` (Off), `WithParent` (On), `ShrinkOnly` | `On` |
| Scale on Zoom | `ScalingOnZoom` | `Constant` (Off), `Linear` (On), `ShrinkOnly` | `On` |
| Scale Stroke with Ports | `StrokeScaling` | `PortStyled` (On), `None` (Off) | Inherit (absent) |
| Scale Stroke with Zoom | `StrokeScalingOnZoom` | `Linear` (On), `ConstantIn` (Off) | Inherit (absent) |
| Scale Stroke on Resize | `StrokeScalingOnResize` | `NonScaling` (Off), `Linear` (On), `ShrinkOnly` | Inherit (absent) |
| Normalize Stroke | `PreAdjustStrokeWidth` | `Normalized` (On), `None` (Off) | Inherit (absent) |
| Inherit Background Color | `ClosedShapeFill` | `On`, `Off` | `Off` |

Notes: `ScalingOnResizeX`/`Y` and `ScalingOnZoom` are element-only. The Horizontal/
Vertical Scaling rows apply only when `ScalingOnResize` ≠ `Off`. `Adaptive`
(`ScalingOnResize`) scales port labels with the block.

### Other `d:options` not in the Behavior pane (advanced/programmatic)

`PreserveAspect` `On`/`Off` (icon + element; default `Off`); `Clipping`
`None`/`Block`; `PreRotate` `None`/`CW90`/`CW180`/`CW270`; `TextScalingOnResize`
`Linear`/`Constant`; `Geometric` `Off`/`On`; `PixelAlign` `Off`/`On`/`Start`/`End`;
`LineExtension` `Off`/`On`; `Edit` `None`/`ByClient`; `LegacyPainting` `Off`/`On`;
`Port` `None`/`L0..`/`Auto Majority`. Also `d:onBlockClip="hide"` on an element hides
it when the block is clipped.

---

## 11. Styling and element IDs

**Shape class + inline style.** Elements carry a shape `class` (`rect`, `ellipse`,
`path`, `line`, `text`) and an inline `style` for anything that differs from that
class's default:

```xml
<rect class="rect" style="fill:#0072bd;stroke:#333333;stroke-width:2;"/>
```

- **Keep the shape class.** `rect`/`ellipse`/`path`/`line`/`text` map to real rules in
  the DVG stylesheet that supply the default fill/stroke/font. Inline `style` only
  needs to specify what *differs* from the default (redundant defaults are stripped by
  the sanitizer).
- Use hex colors only (no named colors, no `currentColor`, no `transparent`).
- No gradients, filters, masks, clipPaths, or patterns.

**Markers (arrowheads / line decorations).**

To draw arrowheads or other line-end decorations, author a `<defs>` containing
`<marker>` children and reference each from a drawable via the **`marker-start` /
`marker-end` presentation attribute**. Do **not** put the reference in `style` and do
**not** add an `ie-marker` class: that class is reserved for the IconEditor's own
parameter-encoded markers (which also carry `data-start-params`/`data-end-params`), and
adding it without that encoding breaks the marker if the user later opens the icon in
the IconEditor.

```xml
<defs>
    <marker id="arrowEnd" orient="auto" refX="0" refY="0" style="overflow:visible">
        <path d="M 8.7,4 L -2.2,0 L 8.7,-4 C 7,-1.6 7,1.6 8.7,4 z"
              style="fill:#000000;stroke:#000000;stroke-width:0.6;"/>
    </marker>
</defs>
<path class="path" style="stroke:#000000;" marker-end="url(#arrowEnd)"
      d="M 5,15 L 25,15"/>
```

- Reference the marker with a plain `id` (`url(#arrowEnd)`) — no per-icon prefix is
  needed on disk.
- Only `<marker>` defs are supported. No `filter`, `linearGradient`/`radialGradient`,
  `clipPath`, `pattern`, or `style` inside `<defs>` — the sanitizer strips them.
- A surviving `<defs>` is emitted as the **first** child of `<svg>` (a sibling of the
  content group), because `<defs>` is only recognised at the top level.

**Element IDs.**

- IDs are **optional** — an element without one still renders.
- Assign a unique `id` to any element **referenced** by another element's layout
  constraint or expression (e.g. `d:left="body.right+10"`), so the reference resolves.
  Remember the first-Part resolution gotcha in section 7.
- Use descriptive, short, alphabet-only names where possible.
- The `svg_to_dvg` prep step assigns descriptive ids to drawables that lack one.

---

## Complete Example

```xml
<svg xmlns="http://www.w3.org/2000/svg"
     xmlns:d="http://www.mathworks.com/blockgraphics"
     version="1.1" width="100" height="80">

    <g title="base" ie-elementType="Part" ie-base-part="true">
        <rect id="body" style="fill:#4dbeee;stroke:#0072bd;stroke-width:1;"
              x="10" y="10" width="80" height="60" rx="4" ry="4"/>
        <text id="label" style="fill:#333333;font-size:12px;"
              d:textContent="blockName || 'Block'"
              d:hcenter="body.hcenter" d:vcenter="body.vcenter"
              x="50" y="40" width="60" height="15">
            <tspan dx="0" dy="0" x="50">Block</tspan>
        </text>
    </g>

    <g title="warning" ie-elementType="Part"
       d:visible="value_temperature > 80">
        <ellipse id="indicator" style="fill:#ff0000;"
                 d:right="body.right-5" d:top="body.top+5"
                 cx="85" cy="15" rx="5" ry="5"/>
    </g>
</svg>
```

----

Copyright 2026 The MathWorks, Inc.

----
