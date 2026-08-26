---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 13
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Pack signal values into a CAN message frame for transmission on the real-time target | CAN Pack | Simulink Real-Time |
| Unpack signal values from a received CAN message frame on the real-time target | CAN Unpack | Simulink Real-Time |
| Initialize the EtherCAT master and configure network parameters at startup | EtherCAT Init | Simulink Real-Time |
| Receive process data objects from EtherCAT subdevices in the cyclic data exchange | EtherCAT PDO Receive | Simulink Real-Time |
| Transmit process data objects to EtherCAT subdevices in the cyclic data exchange | EtherCAT PDO Transmit | Simulink Real-Time |
| Establish a TCP client connection from the real-time target to a remote host | TCP Client | Simulink Real-Time |
| Receive UDP datagrams on the real-time target | UDP Receive | Simulink Real-Time |
| Send UDP datagrams from the real-time target | UDP Send | Simulink Real-Time |
| Log signal data to a file on the real-time target for post-run analysis | File Log | Simulink Real-Time |
| Pack signals into a shared memory partition for inter-model data exchange | Shared Memory Pack | Simulink Real-Time |
| Unpack signals from a shared memory partition for inter-model data exchange | Shared Memory Unpack | Simulink Real-Time |
| Pack typed signals into a raw byte vector for custom protocol framing | Byte Packing | Simulink Real-Time |
| Unpack typed signals from a raw byte vector for custom protocol parsing | Byte Unpacking | Simulink Real-Time |
