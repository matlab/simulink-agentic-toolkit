# Behavior in Simulink Editor

Control how the icon and its elements respond to changes in the Simulink Editor —
when the block is resized or rotated, when the canvas is zoomed, and how the icon
interacts with the block's foreground and background colors. These settings apply
either to the whole icon or to individual elements.

**Resize and rotation**
- Choose whether the icon rotates with the block, and whether it resizes with the
  block, only shrinks, or stays a fixed size.
- Set a resize limit so an element stops scaling past a chosen point, and control
  horizontal and vertical scaling independently.

**Zoom and stroke**
- Keep line thickness readable as the canvas is zoomed or the block is resized,
  rather than letting strokes grow or vanish.
- Optionally scale stroke width along with the block's ports for a consistent look.

**Foreground and background colors**
- Allow, disallow, or inherit the block's foreground color, and choose whether an
  element fills with the block's background color.
- Set the background to allow color, disallow it, or be transparent so the canvas
  shows through — useful for icons meant to blend into the diagram.

**When to use it**
- Make an icon that stays crisp and correctly proportioned as users resize or zoom
  the block.
- Keep a logo or label upright even when the block is rotated.
- Let an icon pick up the block's colors, or sit transparently on the canvas.

**Examples**
- A label that stays the same size and orientation while the block around it is
  resized and rotated.
- An icon that shrinks with the block but never grows beyond its design size.
- A shape that inherits the block's background color so it matches the diagram theme.

----

Copyright 2026 The MathWorks, Inc.

----
