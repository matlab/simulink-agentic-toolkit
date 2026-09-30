---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 30
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Receive raw Ethernet frames on the real-time target — use for low-level custom-protocol input. | Ethernet Receive | Simulink Real-Time |
| Send raw Ethernet frames from the real-time target — use for low-level custom-protocol output. | Ethernet Send | Simulink Real-Time |
| Receive a J1939 parameter group (PGN) message on the target — use to read decoded J1939 signals. | J1939 Receive | Simulink Real-Time |
| Transmit a J1939 parameter group (PGN) message from the target — use to publish J1939 signals. | J1939 Transmit | Simulink Real-Time |
| Acquire (measure) signals from an XCP slave over CAN — use to read measurement/calibration variables during real-time runs. | XCP CAN Data Acquisition | Simulink Real-Time |
| Acquire signals from an XCP slave over UDP/Ethernet — use for high-rate XCP measurement over Ethernet. | XCP UDP Data Acquisition | Simulink Real-Time |
| Stimulate signals to an XCP slave over UDP/Ethernet — use to inject values into an ECU over Ethernet. | XCP UDP Data Stimulation | Simulink Real-Time |
| Call the downstream function-call subsystem when the chosen input edge transition is seen | Thread Trigger | Simulink Real-Time |
| Pack data into CAN and CAN FD messages. Specify signals manually, or using definitions from DBC and ARXML files. | CAN FD Pack | Simulink Real-Time |
| Unpack data from CAN and CAN FD messages. Specify signals manually, or using definitions from DBC and ARXML files. | CAN FD Unpack | Simulink Real-Time |
| Pack data into a CAN message. Specify signals manually, or using definitions from DBC and ARXML files. | CAN Pack | Simulink Real-Time |
| Unpack data from a CAN message. Specify signals manually, or using definitions from DBC and ARXML files. | CAN Unpack | Simulink Real-Time |
| Receives a DDS message on a selected DDS topic. This block allows to attach a Simulink Data Dictionary containing DDS definitions with the model. Choose a DDS topic, DataReader, and QoS from the available options in the Data Dictionary. | DDS Receive | Simulink Real-Time |
| Sends a DDS message for a selected topic. This block allows to attach a Simulink Data Dictionary containing DDS definitions with the model. Choose a DDS topic, DataWriter, and QoS from the available options in the Data Dictionary. | DDS Send | Simulink Real-Time |
| Write parameters to an EtherCAT subdevice asynchronously via SDO protocol | EtherCAT Async SDO Download | Simulink Real-Time |
| Read parameters from an EtherCAT subdevice asynchronously via SDO protocol | EtherCAT Async SDO Upload | Simulink Real-Time |
| Write parameters to a SERCOS-over-EtherCAT subdevice asynchronously | EtherCAT Async SSC/SoE Download | Simulink Real-Time |
| Read parameters from a SERCOS-over-EtherCAT subdevice asynchronously | EtherCAT Async SSC/SoE Upload | Simulink Real-Time |
| EtherCAT Get Emergency Message | EtherCAT Get Emergency | Simulink Real-Time |
| Configure TCP Client | TCP Client | Simulink Real-Time |
| Receive data over TCP network from a remote device. | TCP Receive | Simulink Real-Time |
| Send data over TCP network to a remote device. | TCP Send | Simulink Real-Time |
| Configure TCP Server | TCP Server | Simulink Real-Time |
| Receive multicast data over UDP network from a remote device. Bind to either 0.0.0.0 or a multicast address. | UDP Multicast Receive | Simulink Real-Time |
| Implement the J1939 transport protocol over CAN for multi-packet messages — use to send/receive J1939 PGNs larger than 8 bytes. | J1939 CAN Transport Layer | Simulink Real-Time |
| Configure the J1939 network (database, baud rate) for the target — required once to set up J1939 messaging. | J1939 Network Configuration | Simulink Real-Time |
| Define a J1939 node (address, name) on the network — use to establish this ECU's identity for J1939 traffic. | J1939 Node Configuration | Simulink Real-Time |
| Pack signals as a selected LIN data frame | LIN Pack | Simulink Real-Time |
| Unpack a LIN data frame into signals | LIN Unpack | Simulink Real-Time |
| Enable or disable the file logging service. When the input port value is true, the block enables the file logging service on the target computer, and the File Log blocks record data. When the input port value is false, the block disables file logging on the target computer, and the File Log blocks do not record data. | Enable File Log | Simulink Real-Time |
