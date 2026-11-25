---
type: Simulink Block Category
title: Advanced
description: Advanced app-integration blocks (2 blocks)
tags: [toolbox-kb, simulink-support-package-for-android-devices, advanced, toapp]
status: draft
sources:
  - resource: matlab:androidadvancedlib
source: toolbox_kb
managed_by: satk
library: Simulink Support Package for Android Devices
kb_folder: simulink-support-package-for-android-devices
category: advanced
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:32Z" }
---

# Advanced

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ToApp | androidadvancedlib/ToApp | R2023a+ | Pass data from the model to the companion Android app layer — use to hand model outputs to app UI or logic. |
| FromApp | androidadvancedlib/FromApp | R2023a+ | Receive data from a method in the generated app. The block calls the specified method of the app's default Activity. The block outputs the values returned by the method as an [Nx1] array. |
