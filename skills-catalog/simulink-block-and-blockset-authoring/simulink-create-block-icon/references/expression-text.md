# Expression Text

Display text dynamically on a block icon based on parameter values. Instead of
manually labeling a value on each block, you can bind a text element to a parameter
so the icon shows the value directly.

When you bind a text element to a parameter, any change in the value of the parameter
is reflected immediately on the block. You can also allow the value to be edited on
the block directly, evaluate the parameter before displaying it, and auto-center the
text.

**When to use it**
- Show a live parameter value on the icon (a gain, a sample rate, a mode name) so it
  always matches the block's configuration.
- Build a label out of fixed text combined with a parameter value.
- Let users read — and optionally edit — a key setting straight from the block face.

**Examples**
- A gain block that displays its current gain value on the icon.
- A block labeled "Rate: 1000" where the number tracks a sample-rate parameter.
- A block showing "Mode: Normal" that updates as the mode parameter changes.

----

Copyright 2026 The MathWorks, Inc.

----
