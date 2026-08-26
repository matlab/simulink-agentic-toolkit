---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 2
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Convert an OpenCV cv::Mat data structure into Simulink signal format — use at the output boundary of custom OpenCV C++ S-Functions to pass results back to Simulink | FromOpenCV | Computer Vision Toolbox Interface for OpenCV in Simulink |
| Convert a Simulink signal into an OpenCV cv::Mat data structure — use at the input boundary of custom OpenCV C++ S-Functions to pass image data into OpenCV algorithms | ToOpenCV | Computer Vision Toolbox Interface for OpenCV in Simulink |
