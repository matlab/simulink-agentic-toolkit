---
type: Simulink Block Category
title: User interface
description: On-screen controls and display elements
tags: [user interface, button, switch, label, display]
status: stable
source: custom_library
library_root: Simulink Support Package for Apple iOS Devices
category_path: User interface
block_count: 3
---

# User interface

Use these blocks for user interface.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Button | iosuilib/Button | R2023a+ | Add a button widget to the generated app and read its state. The block outputs the state of the button as a boolean value. |
| Data Display | iosuilib/Data Display | R2023a+ | Numeric display of input values on device screen. The block accepts 1-D arrays of type boolean, uint8, int8, uint16, int16, uint32, int32, single, or double. |
| Slider | iosuilib/Slider | R2023a+ | Add a slider widget to the generated app and read its value. The block outputs the slider value as a single-precision value. The Resolution parameter controls the spacing between two adjacent slider positions. |
