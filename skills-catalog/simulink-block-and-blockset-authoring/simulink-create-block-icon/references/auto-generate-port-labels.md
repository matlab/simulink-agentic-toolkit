# Auto Generate Port Labels

Automatically repeat an element across multiple ports on a block icon without having to
manually repeat the element at each port, which avoids clutter on the canvas. You choose
the face to label — right, left, top, or bottom ports — and a generation algorithm. As
you add or remove ports, the labels update automatically.

The **generation algorithm** decides what each label shows:

- **Increment** — number the ports in sequence (for example, `In1`, `In2`, `In3`, …).
- **Duplicate** — place the same label on every port.
- **Use Parameter Value** — take the labels from a mask parameter, one label per port.

**When to use it**
- Label every port on a face and have the labels update automatically when the port
  count changes.
- Repeat a marker or small graphic at each port without drawing it many times.

**Examples**
- Numbered labels (`In1`, `In2`, `In3`, …) that grow and shrink with the number of ports.
- Per-port labels driven by a mask parameter the user edits.

----

Copyright 2026 The MathWorks, Inc.

----
