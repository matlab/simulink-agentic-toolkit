---
type: Simulink Block Category
title: Multi object trackers
description: Complete multi-object tracking algorithms
tags: [tracker, gnn, jpda, phd, mht]
status: stable
source: mathworks_toolbox
library_root: Sensor Fusion and Tracking Toolbox
category_path: Multi object trackers
block_count: 8
---

# Multi object trackers

Use these blocks for multi object trackers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Global Nearest Neighbor Multi Object Tracker | motalgorithmslib/Global Nearest Neighbor Multi Object Tracker | R2023a+ | Track multiple objects using GNN data association — use for simple multi-target tracking when targets are well-separated |
| Grid-Based Multi Object Tracker | motalgorithmslib/Grid-Based Multi Object Tracker | R2023a+ | Track objects on a spatial occupancy grid — use for tracking extended targets or dense environments with grid-based representations |
| Joint Probabilistic Data Association Multi Object Tracker | motalgorithmslib/Joint Probabilistic Data Association Multi Object Tracker | R2023a+ | Track multiple objects using JPDA soft association — use for cluttered environments where detections may originate from multiple targets |
| Probability Hypothesis Density Tracker | motalgorithmslib/Probability Hypothesis Density Tracker | R2023a+ | Track unknown number of objects using PHD filter — use when target count varies and explicit track management is impractical |
| Track-Oriented Multi-Hypothesis Tracker | motalgorithmslib/Track-Oriented Multi-Hypothesis Tracker | R2023a+ | Track objects using multiple hypothesis trees — use for high-accuracy tracking in dense clutter with deferred association decisions |
| Track-To-Track Fuser | motalgorithmslib/Track-To-Track Fuser | R2023a+ | Fuse tracks from multiple trackers into a unified track set — use for combining outputs from distributed sensors or tracking nodes |
| Generalized Optimal Subpattern Assignment Metric | trackmetricslib/Generalized Optimal Subpattern Assignment Metric | R2023a+ | Evaluate tracker performance using GOSPA metric — use for quantifying tracking accuracy including missed and false tracks |
| Optimal Subpattern Assignment Metric | trackmetricslib/Optimal Subpattern Assignment Metric | R2023a+ | Evaluate tracker performance using OSPA metric — use for measuring the overall distance between estimated and ground-truth track sets |
