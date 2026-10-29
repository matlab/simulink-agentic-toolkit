# SVG Generation Guidelines

Read this BEFORE generating any SVG.

---

## Visual Quality

- Accurately represent the real-world object and its key components.
- Internally identify the key visual components of the object before drawing.
- Ensure correct proportions and spatial relationships between elements.
- Use only flat solid colors.
- Prefer clean edges and strong visual contrast.
- Prefer basic shapes over complex paths.

---

## Strictly Forbidden

- Gradients.
- Gradient simulation using multiple adjacent shades.
- Filters.
- Masks.
- clipPath.
- Patterns.
- Defs.
- <style>.
- <scripts>.
- <title>.
- Shadows.
- Highlights intended to mimic lighting.
- Decorative details that do not improve recognition.
- `transform`, except a single rotation on one shape — `rotate(a cx cy)` about the shape's
  centre. Never on `<g>`/`<svg>`; never translate/scale/skew. Position and size every shape
  with its own geometry (x, y, width, height, cx/cy/r, points, path data).

---

## Output

- Output SVG code only. No explanations, no markdown, no backticks.
- Each SVG must be a complete `<svg>` element with a `viewBox="0 0 W H"` attribute, where
  W×H is the planned canvas (block) size. The viewBox sets the icon's size; a viewBox of a
  different size overrides the requested block size.

----

Copyright 2026 The MathWorks, Inc.

----
