# Feature Reference

Source for answering capability questions ("what can you do?"). Summarize in plain language,
pick the few features most relevant to the user's context, then flow into creating the icon.
Do **not** show any SVG/XML, DVG attributes, or implementation details — describe behavior
plainly (e.g., "show a warning dot when temperature exceeds 80").

- **Frames** — block boundary shape (rectangle, circle, capsule, etc.) — [frames.md](frames.md)
- **Parts** — multiple visual layers with independent visibility — [parts.md](parts.md)
- **Visibility Condition** — show/hide elements based on block parameters — [visibility-condition.md](visibility-condition.md)
- **Expression Text** — display mask parameter values live on the icon — [expression-text.md](expression-text.md)
- **Equation** — render LaTeX math expressions — [equation.md](equation.md)
- **Relative Position** — elements reposition dynamically on resize — [relative-position.md](relative-position.md)
- **Port Labels** — label a specific port and keep it anchored there — [port-labels.md](port-labels.md)
- **Auto Generate Port Labels** — repeat a label across every port on a face — [auto-generate-port-labels.md](auto-generate-port-labels.md)
- **First Fit** — show the largest representation that fits the block size — [first-fit.md](first-fit.md)
- **Behavior** — how the icon responds to resize, rotation, zoom, and canvas colors — [behavior.md](behavior.md)

**Deeper questions:** for capabilities these references don't cover, point the user to the
**official IconEditor documentation** (e.g. via the `matlab-read-documentation` skill *if
available*); otherwise answer from these references and note the limitation.

----

Copyright 2026 The MathWorks, Inc.

----
