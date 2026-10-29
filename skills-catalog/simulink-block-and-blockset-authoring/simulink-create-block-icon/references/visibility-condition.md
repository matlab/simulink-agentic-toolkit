# Visibility Conditions

Show or hide elements in the icon based on block parameters. You can define
conditions that control the visibility of certain icon parts so the icon adapts to
the block's dynamic behavior — for example, revealing a warning marker only when a
parameter crosses a threshold.

A condition ties an element or part to a block parameter: when the parameter matches
the condition, the element is shown; otherwise it is hidden. Conditions are checked
whenever the parameter changes, so the icon updates immediately on the canvas.

**When to use it**
- Reveal a status indicator, label, or overlay only in a specific mode or state.
- Swap between alternative appearances driven by a popup or checkbox parameter.
- Keep the icon uncluttered by hiding detail that only matters in certain
  configurations.

**Examples**
- A warning dot that appears only when a "ChargingStatus" parameter equals zero.
- A block that shows a "Detailed" set of elements in one mode and a "Simple" set in
  another.
- An optional label that appears only when a "Show labels" checkbox is turned on.

----

Copyright 2026 The MathWorks, Inc.

----
