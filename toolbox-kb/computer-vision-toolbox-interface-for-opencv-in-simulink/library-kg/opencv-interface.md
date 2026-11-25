---
type: Simulink Block Category
title: Opencv interface
description: Data conversion blocks for interfacing Simulink with OpenCV C++ code (4 blocks)
tags: [toolbox-kb, computer-vision-toolbox-interface-for-opencv-in-simulink, opencv, conversion, matrix, image, interface]
status: stable
sources:
  - resource: matlab:opencvConverterBlockset
source: toolbox_kb
managed_by: satk
library: Computer Vision Toolbox Interface for OpenCV in Simulink
kb_folder: computer-vision-toolbox-interface-for-opencv-in-simulink
category: opencv-interface
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:16Z" }
---

# Opencv interface

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Image To Matrix | opencvConverterBlockset/Image To Matrix | R2023a+ | Convert a Simulink image signal into a MATLAB matrix format — use to prepare image data from Simulink sources for processing by OpenCV-based C++ code |
| Matrix To Image | opencvConverterBlockset/Matrix To Image | R2023a+ | Convert a MATLAB matrix back into a Simulink image signal — use to return processed results from OpenCV-based code back into the Simulink image pipeline |
| FromOpenCV | opencvConverterBlockset/FromOpenCV | R2023a+ | Convert an OpenCV cv::Mat data structure into Simulink signal format — use at the output boundary of custom OpenCV C++ S-Functions to pass results back to Simulink |
| ToOpenCV | opencvConverterBlockset/ToOpenCV | R2023a+ | Convert a Simulink signal into an OpenCV cv::Mat data structure — use at the input boundary of custom OpenCV C++ S-Functions to pass image data into OpenCV algorithms |
