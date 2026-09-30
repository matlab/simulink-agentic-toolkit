---
type: Simulink Block Category
title: Audio video
description: Camera, microphone, and media I/O on iOS
tags: [audio, video, camera, microphone, image]
status: stable
source: custom_library
library_root: Simulink Support Package for Apple iOS Devices
category_path: Audio video
block_count: 5
---

# Audio video

Use these blocks for audio video.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Audio Capture | iosaudiovideolib/Audio Capture | R2023a+ | Capture audio from the device microphone. The block outputs an [Nx2] int16 matrix, where N is the number of samples per frame and the columns represent the left and right channels. |
| Audio File Read | iosaudiovideolib/Audio File Read | R2023a+ | Read audio frames from an audio file. The output data type is int16. The output dimension is [M N]: M is the frame size and N is the number of channels. |
| Audio Playback | iosaudiovideolib/Audio Playback | R2023a+ | Play audio on the device speaker. The block accepts an [Nx2] int16 matrix, where N is the number of samples per frame and the columns represent the left and right channels. |
| Camera | iosaudiovideolib/Camera | R2023a+ | Capture video using either the front or rear camera. Each R, G, B port outputs an image as a matrix of uint8 values. |
| Video Display | iosaudiovideolib/Video Display | R2023a+ | Display video on the device screen. Each R, G, B port accepts an image as a matrix of uint8 values. |
