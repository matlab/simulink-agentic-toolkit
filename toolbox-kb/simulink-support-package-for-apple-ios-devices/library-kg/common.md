---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 18
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Receive data over a TCP/IP network connection on an Apple iOS device — use to stream sensor data, setpoints, or commands into a model deployed to iPhone/iPad. | TCP/IP Receive | Simulink Support Package for Apple iOS Devices |
| Send data over a TCP/IP network connection from an Apple iOS device — use to stream results, telemetry, or commands out of a model deployed to iPhone/iPad. | TCP/IP Send | Simulink Support Package for Apple iOS Devices |
| Capture audio from the device microphone. The block outputs an [Nx2] int16 matrix, where N is the number of samples per frame and the columns represent the left and right channels. | Audio Capture | Simulink Support Package for Apple iOS Devices |
| Read audio frames from an audio file. The output data type is int16. The output dimension is [M N]: M is the frame size and N is the number of channels. | Audio File Read | Simulink Support Package for Apple iOS Devices |
| Play audio on the device speaker. The block accepts an [Nx2] int16 matrix, where N is the number of samples per frame and the columns represent the left and right channels. | Audio Playback | Simulink Support Package for Apple iOS Devices |
| Capture video using either the front or rear camera. Each R, G, B port outputs an image as a matrix of uint8 values. | Camera | Simulink Support Package for Apple iOS Devices |
| Display video on the device screen. Each R, G, B port accepts an image as a matrix of uint8 values. | Video Display | Simulink Support Package for Apple iOS Devices |
| Receive data from a method in the generated app. The block calls the specified method of the app's InfoViewController. The block outputs the values returned by the method as an [Nx1] array. | FromApp | Simulink Support Package for Apple iOS Devices |
| Send data to a method in the generated app. The block calls the specified method of the app's InfoViewController. The block accepts 1-D arrays of type uint8, int8, uint16, int16, uint32, int32, single or double. | ToApp | Simulink Support Package for Apple iOS Devices |
| Send data to ThingSpeak. Each input port accepts numeric scalars. Set Update interval parameter to the number of seconds to wait between two successive data send requests. The minimum update interval for a free channel is 15 seconds. | ThingSpeak Write | Simulink Support Package for Apple iOS Devices |
| Receive UDP packets from another UDP host on an Internet network. The block outputs the values received as an [Nx1] array. Set the Local IP port parameter to the port number used by the sending UDP host. | UDP Receive | Simulink Support Package for Apple iOS Devices |
| Send UDP packets to another UDP host on an Internet network. The block accepts 1-D arrays of type uint8, int8, uint16, int16, uint32, int32, single or double. Set the Remote IP address and Remote IP port parameters to the IP address and port number of the receiving UDP host, respectively. | UDP Send | Simulink Support Package for Apple iOS Devices |
| Measure linear acceleration along the X, Y and Z axes in m/s^2. The block outputs acceleration as a [1x3] vector of single-precision values. | Accelerometer | Simulink Support Package for Apple iOS Devices |
| Measure rotational speed around the X, Y, and Z axes in rad/s. The block outputs rotational speed as a [1x3] vector of single-precision values. | Gyroscope | Simulink Support Package for Apple iOS Devices |
| Measure GPS latitude, longitude in decimal degrees and altitude in meters. The block outputs the latitude, longitude and altitude as a [1x3] vector of single-precision values. | Location Sensor | Simulink Support Package for Apple iOS Devices |
| Add a button widget to the generated app and read its state. The block outputs the state of the button as a boolean value. | Button | Simulink Support Package for Apple iOS Devices |
| Numeric display of input values on device screen. The block accepts 1-D arrays of type boolean, uint8, int8, uint16, int16, uint32, int32, single, or double. | Data Display | Simulink Support Package for Apple iOS Devices |
| Add a slider widget to the generated app and read its value. The block outputs the slider value as a single-precision value. The Resolution parameter controls the spacing between two adjacent slider positions. | Slider | Simulink Support Package for Apple iOS Devices |
