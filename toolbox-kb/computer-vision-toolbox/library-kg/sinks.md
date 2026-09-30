---
type: Simulink Block Category
title: Sinks
description: Display, record, and export images and video
tags: [sink, viewer, to multimedia, display, point cloud]
status: stable
source: custom_library
library_root: Computer Vision Toolbox
category_path: Sinks
block_count: 8
---

# Sinks

Use these blocks for sinks.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Frame Rate Display | visionsinks/Frame Rate Display | R2023a+ | Calculate and display the frame rate of the input signal. Use the Calculate and display rate every parameter to control how often the block updates the display. When this parameter is greater than 1, the block displays the average frame rate for the specified number of frames. |
| Point Cloud Viewer | visionsinks/Point Cloud Viewer | R2023a+ | Visualize a stream of 3-D point clouds during simulation — use to inspect lidar/depth output while debugging perception pipelines. |
| To Multimedia File | visionsinks/To Multimedia File | R2023a+ | Write video frames and/or audio to a media file — use to record simulation output to disk for playback or reporting. |
| To Video Display | visionsinks/To Video Display | R2023a+ | This block provides a lightweight, high performance display, which accepts RGB and YCbCr formatted videos. It also generates code. |
| Video To Workspace | visionsinks/Video To Workspace | R2023a+ | Writes the input to a specified array in the MATLAB workspace. The array is not available until the simulation stops. If the video signal is represented by intensity values, it appears in the workspace as a three-dimensional M-by-N-by-T array, where M and N are the number of rows and columns in a single video frame, and T is the number of frames in the video signal. If it is a color video signal, it appears in the workspace as a four-dimensional M-by-N-by-C-by-T array, where M and N are the number of rows and columns in a single video frame, C is the number of inputs to the block, and T is the number of frames in the video stream. |
| Video Viewer | visionsinks/Video Viewer | R2023a+ | Display a video or image stream in a viewer window during simulation — use to visually inspect frames while debugging vision algorithms. |
| Write Binary File | visionsinks/Write Binary File | R2023a+ | Write binary video data into file in the specified format. |
| Insert Text | visiontextngfix/Insert Text | R2023a+ | Draws formatted text on an image or video stream. Use the Text parameter to specify the text string to be drawn on the image or video stream. This parameter can be a single text string or a cell array of strings. If you enter a cell array, use the Select port to indicate which text string to display. The Text parameter also accepts ANSI C printf-style format specifications, such as %04d, %4.2f, etc. The block replaces the format specifications in the Text parameter with the elements from the vector input at the Variables port. |
