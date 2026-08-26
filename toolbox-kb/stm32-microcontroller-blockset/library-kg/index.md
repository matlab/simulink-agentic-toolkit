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

- STM32 Microcontroller Blockset

Common blocks: [common.md](common.md) (30 of 512 blocks)

## Categories

- [Interrupts system](interrupts-system.md) — 27 blocks; Interrupt management, math co-processors, and system-level utilities
- [Analog conversion](analog-conversion.md) — 49 blocks; Analog-to-digital and digital-to-analog conversion peripherals including comparators
- [Digital io](digital-io.md) — 48 blocks; General-purpose digital input and output pin control for GPIO
- [Timer pwm](timer-pwm.md) — 77 blocks; Hardware timer peripherals for timing, PWM generation, input capture, and encoder decoding
- [Can bus](can-bus.md) — 32 blocks; Controller Area Network peripherals for automotive and industrial communication
- [I2c interface](i2c-interface.md) — 48 blocks; I2C bus peripherals for multi-device communication with sensors and EEPROMs
- [Industrial protocols](industrial-protocols.md) — 44 blocks; MODBUS protocol peripherals for industrial automation over serial and RS485
- [Spi interface](spi-interface.md) — 69 blocks; SPI bus peripherals for high-speed synchronous communication with sensors and memory
- [Serial communication](serial-communication.md) — 48 blocks; Asynchronous serial communication interfaces for point-to-point data exchange
- [Audio interface](audio-interface.md) — 20 blocks; Digital audio streaming interfaces using I2S protocol and board audio drivers
- [Network iot](network-iot.md) — 30 blocks; Ethernet and wireless network communication using TCP, UDP, and MQTT protocols
- [Sensors](sensors.md) — 19 blocks; Pre-integrated sensor drivers for IMU, accelerometer, environmental, and distance
- [Uncategorized](uncategorized.md) — 1 blocks; blocks not yet assigned to a category
