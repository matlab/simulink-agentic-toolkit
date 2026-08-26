---
type: Simulink Block Category
title: Opencv interface
description: Data conversion blocks for interfacing Simulink with OpenCV C++ code
tags: [opencv, conversion, matrix, image, interface]
status: stable
source: mathworks_toolbox
library_root: Computer Vision Toolbox Interface for OpenCV in Simulink
category_path: Opencv interface
block_count: 4
---

# Opencv interface

Use these blocks for opencv interface.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Image To Matrix | opencvConverterBlockset/Image To Matrix | R2023a+ | Convert a Simulink image signal into a MATLAB matrix format — use to prepare image data from Simulink sources for processing by OpenCV-based C++ code |
| Matrix To Image | opencvConverterBlockset/Matrix To Image | R2023a+ | Convert a MATLAB matrix back into a Simulink image signal — use to return processed results from OpenCV-based code back into the Simulink image pipeline |
| FromOpenCV | opencvConverterBlockset/FromOpenCV | R2023a+ | Convert an OpenCV cv::Mat data structure into Simulink signal format — use at the output boundary of custom OpenCV C++ S-Functions to pass results back to Simulink |
| ToOpenCV | opencvConverterBlockset/ToOpenCV | R2023a+ | Convert a Simulink signal into an OpenCV cv::Mat data structure — use at the input boundary of custom OpenCV C++ S-Functions to pass image data into OpenCV algorithms |
