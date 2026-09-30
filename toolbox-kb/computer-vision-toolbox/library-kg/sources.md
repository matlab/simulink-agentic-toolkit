---
type: Simulink Block Category
title: Sources
description: Bring images and video into the model
tags: [source, from multimedia, from image, read]
status: stable
source: custom_library
library_root: Computer Vision Toolbox
category_path: Sources
block_count: 6
---

# Sources

Use these blocks for sources.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Deinterlacing | visionanalysis/Deinterlacing | R2023a+ | Removes motion artifacts from images composed of weaved top and bottom fields of an interlaced signal. |
| From Multimedia File | visionsources/From Multimedia File | R2023a+ | Read frames and/or audio from a media file as a source — use to feed recorded video into a vision pipeline for offline testing. |
| Read Binary File | visionsources/Read Binary File | R2023a+ | Read binary video data from file in the specified format. |
| Video From Workspace | visionsources/Video From Workspace | R2023a+ | Outputs video frames from the MATLAB workspace at successive sample times. If the video signal is a M-by-N-by-T workspace array, the block outputs an intensity video signal, where M and N are the number of rows and columns in a single video frame, and T is the number of frames in the video signal. If the video signal is a M-by-N-by-C-by-T workspace array, the block outputs a color video signal, where M and N are the number of rows and columns in a single video frame, C is the number of outputs from the block, and T is the number of frames in the video stream. |
| Image From File | visionsources/Image From File | R2023a+ | Reads an image from a file. Use the File name parameter to specify the image file you want to import into your model. Use the Sample time parameter to set the sample period of the block. |
| Image From Workspace | visionsources/Image From Workspace | R2023a+ | Imports an image from the MATLAB workspace. Use the Value parameter to specify the MATLAB workspace variable that contains or an expression that specifies the image you want to import into your model. Use the Sample time parameter to set the sample period of the block. |
