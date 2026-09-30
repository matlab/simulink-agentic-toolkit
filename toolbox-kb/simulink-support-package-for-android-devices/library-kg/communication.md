---
type: Simulink Block Category
title: Communication
description: Network, cloud, and serial data exchange on Android
tags: [tcp, mqtt, http, serial, thingspeak, communication]
status: stable
source: custom_library
library_root: Simulink Support Package for Android Devices
category_path: Communication
block_count: 15
---

# Communication

Use these blocks for communication.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| BLE Receive | androidcommunicationlib/BLE Receive | R2023a+ | Receive BLE characteristic data from another BLE device. The Data port outputs the received characteristic data values as an [Nx1] int8 array.The Size port outputs the received characteristic data array length. Select the Mode for your device. Device acting as Central (Client) can connect to only another device acting as Peripheral (Server). In BLECentral mode, Click Scan to find nearby BLE devices and list their supported services and characteristics. In BLEPeripheral mode, select the Service and Characteristic for your device. |
| BLE Send | androidcommunicationlib/BLE Send | R2023a+ | Send BLE Characteristic data to another BLE device. The block accepts a 1-D array of type uint8, int8, uint16, int16, uint32, int32, boolean, single-precision, or double-precision. Select the Mode for your device. Device acting as Central (Client) can connect to only another device acting as Peripheral (Server). In BLECentral mode, Click Scan to find nearby BLE devices and list their supported services and characteristics. In BLEPeripheral mode, select the Service and Characteristic for your device. |
| HTTP Client | androidcommunicationlib/HTTP Client | R2023a+ | Perform HTTP GET/POST requests from the Android device — use to call REST or web services from a deployed model. |
| MQTT Publish | androidcommunicationlib/MQTT Publish | R2023a+ | Publish messages to an MQTT broker from the Android device — use for IoT telemetry uplink. |
| MQTT Subscribe | androidcommunicationlib/MQTT Subscribe | R2023a+ | Subscribe to MQTT topics on the Android device — use to receive IoT commands or messages. |
| Serial Receive | androidcommunicationlib/Serial Receive | R2023a+ | Receive data over a serial (USB/UART) connection on Android — use to read from an attached serial peripheral. |
| Serial Transmit | androidcommunicationlib/Serial Transmit | R2023a+ | Send data over a serial (USB/UART) connection on Android — use to drive an attached serial peripheral. |
| TCP/IP Receive | androidcommunicationlib/TCP/IP Receive | R2023a+ | Receive data over TCP/IP on the Android device — use to stream data or commands into a deployed model. |
| TCP/IP Send | androidcommunicationlib/TCP/IP Send | R2023a+ | Send data over TCP/IP from the Android device — use to stream results or telemetry out of a deployed model. |
| ThingSpeak Read | androidcommunicationlib/ThingSpeak Read | R2023a+ | Read channel data from ThingSpeak on the Android device — use to pull cloud-stored IoT data into the model. |
| ThingSpeak Write | androidcommunicationlib/ThingSpeak Write | R2023a+ | Send data to ThingSpeak. Each input port accepts numeric scalars. Set Update interval parameter to the number of seconds to wait between two successive data send requests. The minimum update interval for a free channel is 15 seconds. |
| UDP Receive | androidcommunicationlib/UDP Receive | R2023a+ | Receive UDP packets from another UDP host on an Internet network. The block outputs the values received as an [Nx1] array. Set the Local IP port parameter to the port number used by the sending UDP host. |
| UDP Send | androidcommunicationlib/UDP Send | R2023a+ | Send UDP packets to another UDP host on an Internet network. The block accepts 1-D arrays of type uint8, int8, uint16, int16, uint32, int32, single or double. Set the Remote IP address and Remote IP port parameters to the IP address and port number of the receiving UDP host, respectively. |
| TalkBack Read | androidcommunicationlib/TalkBack Read | R2023a+ | Read command from TalkBack ID on ThingSpeak.com, the MathWorks IoT Analytics platform. The hardware must be connected to the internet. The block outputs the commands in the TalkBack queue as a string or an ASCII vector from a TalkBack ID on the ThingSpeak channel. |
| TalkBack Write | androidcommunicationlib/TalkBack Write | R2023a+ | Write command to TalkBack ID on ThingSpeak.com, the MathWorks IoT Analytics platform. The hardware must be connected to the internet. The block accepts a triggered input. For a trigger input equal to zero, the block does not execute the option set for the “TalkBack endpoint” parameter. Otherwise, the block executes this option. |
