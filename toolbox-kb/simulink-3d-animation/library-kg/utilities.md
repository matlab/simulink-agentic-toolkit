---
type: Simulink Block Category
title: Utilities
description: Scene utilities and data exchange (7 blocks)
tags: [toolbox-kb, simulink-3d-animation, transform, message, video, configuration, scene]
status: stable
sources:
  - resource: matlab:sl3dlib
source: toolbox_kb
managed_by: satk
library: Simulink 3D Animation
kb_folder: simulink-3d-animation
category: utilities
block_count: 7
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:29Z" }
---

# Utilities

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Simulation 3D Scene Configuration | sl3dlib/Simulation 3D/Environment/Simulation 3D Scene Configuration | R2023a+ | Configure the 3D simulation environment — use for selecting scene, weather, lighting, and rendering options for the virtual world |
| Simulation 3D Actor Transform Get | sl3dlib/Simulation 3D/Utilities/Simulation 3D Actor Transform Get | R2023a+ | Read the position and orientation of a 3D actor — use for getting ground-truth pose of objects in the scene |
| Simulation 3D Actor Transform Set | sl3dlib/Simulation 3D/Utilities/Simulation 3D Actor Transform Set | R2023a+ | Set the position and orientation of a 3D actor — use for programmatically moving objects in the virtual scene |
| Simulation 3D Camera Get | sl3dlib/Simulation 3D/Utilities/Simulation 3D Camera Get | R2023a+ | Read the viewport camera position and settings — use for querying the observer camera state in the 3D scene |
| Simulation 3D Message Get | sl3dlib/Simulation 3D/Utilities/Simulation 3D Message Get | R2025a+ | Receive messages from the 3D simulation engine — use for reading events or custom data from the Unreal Engine scene |
| Simulation 3D Message Set | sl3dlib/Simulation 3D/Utilities/Simulation 3D Message Set | R2025a+ | Send messages to the 3D simulation engine — use for triggering events or passing custom data to the Unreal Engine scene |
| Simulation 3D Video Writer | sl3dlib/Simulation 3D/Utilities/Simulation 3D Video Writer | R2025a+ | Record video from the 3D simulation scene — use for capturing rendered footage for review or documentation |
