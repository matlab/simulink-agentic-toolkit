---
type: Simulink Block Category
title: Uncategorized
description: Blocks for uncategorized.
status: draft
source: custom_library
library_root: Utilities
category_path: Uncategorized
block_count: 3
---

# Uncategorized

Use these blocks for uncategorized.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| PS-Simulink Converter | nesl_utility/PS-Simulink Converter | R2023a+ | Converts the input Physical Signal to a Simulink output signal. Format of Simulink output signal matches the format of Physical Signal. 'Vector format' provides an option for outputting vector Physical Signals as Simulink 1-D arrays. The unit expression in 'Output signal unit' parameter must match or be commensurate with the unit of the Physical Signal and determines the conversion from the Physical Signal to the Simulink output signal. 'Apply affine conversion' check box is only relevant for units with offset (such as temperature units). |
| Simulink-PS Converter | nesl_utility/Simulink-PS Converter | R2023a+ | Converts the Simulink input signal to a Physical Signal. The unit expression in 'Input signal unit' parameter is associated with the Simulink input signal and determines the unit assigned to the Physical Signal. 'Apply affine conversion' check box is only relevant for units with offset (such as temperature units). If the selected solver requires input derivatives, you can either provide them explicitly through additional signal ports, or turn on input filtering to calculate time derivatives. The first-order filter provides one derivative, while the second-order filter provides the first and second derivatives. For piecewise-constant signals, you can also explicitly set the input derivatives to zero. |
| Solver Configuration | nesl_utility/Solver Configuration | R2023a+ | Defines solver settings to use for simulation. |
