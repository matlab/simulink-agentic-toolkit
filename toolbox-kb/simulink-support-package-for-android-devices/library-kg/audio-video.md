---
type: Simulink Block Category
title: Audio video
description: Audio and media I/O on Android
tags: [audio, video, camera]
status: stable
source: custom_library
library_root: Simulink Support Package for Android Devices
category_path: Audio video
block_count: 6
---

# Audio video

Use these blocks for audio video.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Audio File Read | androidaudiovideolib/Audio File Read | R2023a+ | Read audio samples from a file on the Android device — use as an audio source for on-device processing. |
| Audio File Write | androidaudiovideolib/Audio File Write | R2023a+ | Write audio samples to a file on the Android device — use to record processed audio to storage. |
| Audio Capture | androidaudiovideolib/Audio Capture | R2023a+ | Capture audio from the device microphone. The block outputs an [Nx2] matrix of int16 values, where N is the number of samples per frame and the colums represent the left and right channels. |
| Audio Playback | androidaudiovideolib/Audio Playback | R2023a+ | Play audio on the device speaker. The block accepts an [Nx2] int16 matrix, where N is the number of samples per frame and the columns represent the left and right channels. |
| Camera | androidaudiovideolib/Camera | R2023a+ | Capture video using either the front or rear camera. Each R, G, B port outputs an image as a matrix of uint8 values. |
| Video Display | androidaudiovideolib/Video Display | R2023a+ | Display video on the device screen. Each R, G, B port accepts an image as a matrix of uint8 values. |
