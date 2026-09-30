---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 27
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Publish messages to an MQTT broker from the Android device — use for IoT telemetry uplink. | MQTT Publish | Simulink Support Package for Android Devices |
| Subscribe to MQTT topics on the Android device — use to receive IoT commands or messages. | MQTT Subscribe | Simulink Support Package for Android Devices |
| Receive data over TCP/IP on the Android device — use to stream data or commands into a deployed model. | TCP/IP Receive | Simulink Support Package for Android Devices |
| Send data over TCP/IP from the Android device — use to stream results or telemetry out of a deployed model. | TCP/IP Send | Simulink Support Package for Android Devices |
| Read the Android device's magnetometer (magnetic field vector) — use for heading/compass and orientation sensing. | Magnetometer | Simulink Support Package for Android Devices |
| Read the Android device's fused orientation (roll/pitch/yaw) — use for attitude sensing in mobile apps. | Orientation | Simulink Support Package for Android Devices |
| Read a user-entered value from the Android app UI — use to feed interactive setpoints into the model. | Data Input | Simulink Support Package for Android Devices |
| Receive data from a method in the generated app. The block calls the specified method of the app's default Activity. The block outputs the values returned by the method as an [Nx1] array. | FromApp | Simulink Support Package for Android Devices |
| Pass data from the model to the companion Android app layer — use to hand model outputs to app UI or logic. | ToApp | Simulink Support Package for Android Devices |
| Capture audio from the device microphone. The block outputs an [Nx2] matrix of int16 values, where N is the number of samples per frame and the colums represent the left and right channels. | Audio Capture | Simulink Support Package for Android Devices |
| Play audio on the device speaker. The block accepts an [Nx2] int16 matrix, where N is the number of samples per frame and the columns represent the left and right channels. | Audio Playback | Simulink Support Package for Android Devices |
| Capture video using either the front or rear camera. Each R, G, B port outputs an image as a matrix of uint8 values. | Camera | Simulink Support Package for Android Devices |
| Display video on the device screen. Each R, G, B port accepts an image as a matrix of uint8 values. | Video Display | Simulink Support Package for Android Devices |
| Read audio samples from a file on the Android device — use as an audio source for on-device processing. | Audio File Read | Simulink Support Package for Android Devices |
| Receive BLE characteristic data from another BLE device. The Data port outputs the received characteristic data values as an [Nx1] int8 array.The Size port outputs the received characteristic data array length. Select the Mode for your device. Device acting as Central (Client) can connect to only another device acting as Peripheral (Server). In BLECentral mode, Click Scan to find nearby BLE devices and list their supported services and characteristics. In BLEPeripheral mode, select the Service and Characteristic for your device. | BLE Receive | Simulink Support Package for Android Devices |
| Send BLE Characteristic data to another BLE device. The block accepts a 1-D array of type uint8, int8, uint16, int16, uint32, int32, boolean, single-precision, or double-precision. Select the Mode for your device. Device acting as Central (Client) can connect to only another device acting as Peripheral (Server). In BLECentral mode, Click Scan to find nearby BLE devices and list their supported services and characteristics. In BLEPeripheral mode, select the Service and Characteristic for your device. | BLE Send | Simulink Support Package for Android Devices |
| Send data to ThingSpeak. Each input port accepts numeric scalars. Set Update interval parameter to the number of seconds to wait between two successive data send requests. The minimum update interval for a free channel is 15 seconds. | ThingSpeak Write | Simulink Support Package for Android Devices |
| Receive UDP packets from another UDP host on an Internet network. The block outputs the values received as an [Nx1] array. Set the Local IP port parameter to the port number used by the sending UDP host. | UDP Receive | Simulink Support Package for Android Devices |
| Send UDP packets to another UDP host on an Internet network. The block accepts 1-D arrays of type uint8, int8, uint16, int16, uint32, int32, single or double. Set the Remote IP address and Remote IP port parameters to the IP address and port number of the receiving UDP host, respectively. | UDP Send | Simulink Support Package for Android Devices |
| Measure linear acceleration along the X, Y and Z axes in m/s^2. Each X, Y, Z port outputs acceleration as a single-precision scalar. | Accelerometer | Simulink Support Package for Android Devices |
| Measure ambient temperature in degrees Celsius (C). The block outputs temperature as a single-precision value. | Ambient Temperature Sensor | Simulink Support Package for Android Devices |
| Measure rate of rotation around the X, Y and Z axes in rad/s. Each X, Y, Z port outputs the rate of rotation as a single-precision scalar. | Gyroscope | Simulink Support Package for Android Devices |
| Measure relative ambient humidity in percent (%). The block outputs humidity as a single-precision value. | Humidity Sensor | Simulink Support Package for Android Devices |
| Measure ambient light level in lux (lx). The block outputs light level as a single-precision value. | Light Sensor | Simulink Support Package for Android Devices |
| Add a button widget to the generated app and read its state. The block outputs the state of the button as a boolean value. | Button | Simulink Support Package for Android Devices |
| Numeric display of input values on device screen. The block accepts 1-D arrays of type boolean, uint8, int8, uint16, int16, uint32, int32, single or double. | Data Display | Simulink Support Package for Android Devices |
| Add a slider widget to the generated app and read its value. The block outputs the slider value as a single-precision value. The Resolution parameter controls the spacing between two adjacent slider positions. | Slider | Simulink Support Package for Android Devices |
