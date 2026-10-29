# Parts

Use Parts to render multiple variations of the same block icon. A part is a section
of the icon that you can show or hide on its own, so a single block can present
different appearances depending on its parameters.

Designing with parts lets you break the icon into smaller sections that are easier
to manage and edit, reuse common elements across variations, show or hide sections
based on block parameters, and control the stacking order of elements.

**Base part:** pin a part to make it the base part. Elements in the base part appear
in all other parts, so you do not need to replicate shared elements. You cannot
modify base elements or their positions from the other parts.

**When to use it**
- Split the icon into separate parts when it has major visual state changes — a
  fundamentally different layout for each mode of the block.
- For a small conditional element (a warning dot, a label, a color change), keep a
  single part and just show or hide that one element instead.

**Examples**
- A block that shows one layout in "Continuous" mode and a different layout in
  "Discrete" mode, with a shared frame kept in the base part.
- A controller icon whose common outline lives in the base part while each operating
  mode adds its own overlay.

----

Copyright 2026 The MathWorks, Inc.

----
