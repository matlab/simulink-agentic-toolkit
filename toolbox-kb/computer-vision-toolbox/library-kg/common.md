---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 6
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Analyze and enhance images with edge detection, histogram equalization, contrast adjustment, and blob analysis — use for preprocessing steps that improve feature visibility before detection or recognition | Analysis & Enhancement | Computer Vision Toolbox |
| Apply spatial filters (median, Gaussian, bilateral, custom kernels) to images — use for noise reduction, smoothing, or sharpening as part of an image processing pipeline | Filtering | Computer Vision Toolbox |
| Apply geometric operations (resize, rotate, warp, crop, affine/projective transforms) to images — use for image registration, perspective correction, or preparing images for fixed-size network inputs | Geometric Transformations | Computer Vision Toolbox |
| Display images and video with annotations in viewer windows — use to visualize intermediate or final results of a vision processing pipeline during simulation | Sinks | Computer Vision Toolbox |
| Read images and video from files, cameras, or frame generators — use as input to vision processing pipelines for offline analysis or real-time camera capture | Sources | Computer Vision Toolbox |
| Overlay text, shapes, bounding boxes, and markers onto images — use to annotate detection results, draw ROIs, or add labels for visualization and debugging | Text & Graphics | Computer Vision Toolbox |
