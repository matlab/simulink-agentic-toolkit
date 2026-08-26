# Library Reuse Index

## Priority

1. Custom library blocks (highest priority)
2. Toolbox KB blocks

## Policy

- Always use custom library blocks when available.
- Never fall back to built-in primitives if the same block exists in a declared library.
- Only use built-in blocks when NO equivalent exists in any declared library after searching this index.
- Do not invent custom block names.
- If uncertain, inspect the relevant category page or ask the user.

## Libraries

- Simulink Real-Time

Common blocks: [common.md](common.md) (13 of 86 blocks)

## Categories

- [Async triggers](async-triggers.md) — 1 blocks; Asynchronous event and thread triggers for interrupt-driven execution
- [Dds communication](dds-communication.md) — 2 blocks; DDS publish-subscribe communication for distributed real-time systems
- [Ethercat](ethercat.md) — 18 blocks; EtherCAT fieldbus communication, PDO exchange, and subdevice management
- [Ip networking](ip-networking.md) — 9 blocks; TCP, UDP, and raw Ethernet communication on the real-time target
- [J1939 protocol](j1939-protocol.md) — 5 blocks; SAE J1939 heavy-vehicle network protocol messaging
- [Lin protocol](lin-protocol.md) — 2 blocks; LIN bus frame packing and unpacking for body electronics
- [Data logging](data-logging.md) — 4 blocks; File logging and execution profiling on the real-time target
- [Hardware io](hardware-io.md) — 2 blocks; Physical hardware I/O devices and time synchronization
- [Serial communication](serial-communication.md) — 14 blocks; Serial port communication with FIFO buffering and ASCII/binary parsing
- [Shared memory](shared-memory.md) — 3 blocks; Shared memory inter-model data exchange on the real-time target
- [Target management](target-management.md) — 3 blocks; Real-time target management including overload handling and persistent storage
- [Utilities](utilities.md) — 7 blocks; Byte and bit manipulation utilities for custom protocol framing
- [Xcp protocol](xcp-protocol.md) — 12 blocks; XCP measurement and calibration protocol over CAN, CAN FD, and UDP
