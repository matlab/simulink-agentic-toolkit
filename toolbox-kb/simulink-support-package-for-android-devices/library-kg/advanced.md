---
type: Simulink Block Category
title: Advanced
description: Advanced app-integration blocks
tags: [advanced, toapp]
status: stable
source: custom_library
library_root: Simulink Support Package for Android Devices
category_path: Advanced
block_count: 2
---

# Advanced

Use these blocks for advanced.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ToApp | androidadvancedlib/ToApp | R2023a+ | Pass data from the model to the companion Android app layer — use to hand model outputs to app UI or logic. |
| FromApp | androidadvancedlib/FromApp | R2023a+ | Receive data from a method in the generated app. The block calls the specified method of the app's default Activity. The block outputs the values returned by the method as an [Nx1] array. |
