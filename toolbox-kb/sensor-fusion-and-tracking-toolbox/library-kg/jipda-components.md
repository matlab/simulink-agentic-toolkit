---
type: Simulink Block Category
title: Jipda components
description: Modular JIPDA tracker building blocks (6 blocks)
tags: [toolbox-kb, sensor-fusion-and-tracking-toolbox, jipda, assigner, initiator, predictor, updater]
status: stable
sources:
  - resource: matlab:jipdatrackercomponentslib
source: toolbox_kb
managed_by: satk
library: Sensor Fusion and Tracking Toolbox
kb_folder: sensor-fusion-and-tracking-toolbox
category: jipda-components
block_count: 6
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:27Z" }
---

# Jipda components

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| JIPDA Track Assigner | jipdatrackercomponentslib/JIPDA Track Assigner | R2023a+ | Assign detections to tracks using JIPDA probabilities — use as a modular component in custom JIPDA tracker pipelines |
| JIPDA Track Initiator | jipdatrackercomponentslib/JIPDA Track Initiator | R2023a+ | Initiate new tracks from unassigned detections — use as a modular component for track birth in JIPDA tracker designs |
| JIPDA Track Maintainer | jipdatrackercomponentslib/JIPDA Track Maintainer | R2023a+ | Manage track lifecycle based on existence probability — use for confirming or deleting tracks in modular JIPDA pipelines |
| JIPDA Track Outputter | jipdatrackercomponentslib/JIPDA Track Outputter | R2023a+ | Output confirmed tracks from the JIPDA tracker — use for extracting finalized track estimates from modular JIPDA designs |
| JIPDA Track Predictor | jipdatrackercomponentslib/JIPDA Track Predictor | R2023a+ | Predict track states forward in time — use for the prediction step in modular JIPDA tracker pipelines |
| JIPDA Track Updater | jipdatrackercomponentslib/JIPDA Track Updater | R2023a+ | Update track states with new measurements — use for the measurement update step in modular JIPDA tracker pipelines |
