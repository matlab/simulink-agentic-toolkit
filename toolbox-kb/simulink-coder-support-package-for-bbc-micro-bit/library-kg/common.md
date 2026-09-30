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
| Read an analog voltage from a micro:bit pin (ADC) — use to sense analog inputs like light level or a potentiometer. | Analog Input | Simulink Coder Support Package for BBC micro:bit |
| Read the digital state (0/1) of a micro:bit pin — use to sense buttons or digital sensors. | Digital Read | Simulink Coder Support Package for BBC micro:bit |
| Set a micro:bit pin high or low — use to drive LEDs, relays, or other digital outputs. | Digital Write | Simulink Coder Support Package for BBC micro:bit |
| Generate a PWM signal on a micro:bit pin — use for dimming LEDs, driving servos, or tone generation. | PWM Output | Simulink Coder Support Package for BBC micro:bit |
| Drive the full 5×5 LED display from a matrix input — use to show custom patterns or animations. | LED Matrix output | Simulink Coder Support Package for BBC micro:bit |
| Receive data over the micro:bit 2.4 GHz radio — use for wireless communication between micro:bits. | Radio Receive | Simulink Coder Support Package for BBC micro:bit |
| Send data over the micro:bit 2.4 GHz radio — use for wireless communication between micro:bits. | Radio Transmit | Simulink Coder Support Package for BBC micro:bit |
| Output the X, Y and Z value in g (9.8 m/s^2) to different output ports. | Accelerometer X-Y-Z | Simulink Coder Support Package for BBC micro:bit |
| Output the X, Y and Z value in g (9.8 m/s^2) to different output ports. | LSM 303 Accelerometer X-Y-Z | Simulink Coder Support Package for BBC micro:bit |
| Detect shake, return "1" or "true" when it is higher than the value determined by sensitivity in g (9.8 m/s^2). | Shake detection | Simulink Coder Support Package for BBC micro:bit |
| Detect the microbit tilted downward by sensitivity in g (9.8 m/s^2). | Tilt down | Simulink Coder Support Package for BBC micro:bit |
| Detect the microbit tilted to the left by sensitivity in g (9.8 m/s^2). | Tilt left | Simulink Coder Support Package for BBC micro:bit |
| Generates a musical note at specified scale. The scale can be selected as 'High' 'Mid' or 'Low' and the Note can be selected from A to G#. The block outputs the frequency of the particular note chosen. | Note Generator | Simulink Coder Support Package for BBC micro:bit |
| Plays a musical note or a variable frequecy signal on the specified pin. Use the Pin parameter to select the pin on which the sound needs to be produced. Connect a speaker on the specified pin to hear the audio. The block accepts frequency as the input. A Note Generator block can be connected to this block to generate various notes. | Play Note | Simulink Coder Support Package for BBC micro:bit |
| When button A is held for more than 0.5s send a momentary "1" or "true" - commonly used as a trigger to another system. | Button A Hold | Simulink Coder Support Package for BBC micro:bit |
| When button A is pressed, send a momentary "1" or "true" - commonly used as a trigger to another system. | Button A Pressed | Simulink Coder Support Package for BBC micro:bit |
| When button A is released send a momentary "1" or "true" - commonly used as a trigger to another system. | Button A Released | Simulink Coder Support Package for BBC micro:bit |
| When button B is held for more than 0.5s send a momentary "1" or "true" - commonly used as a trigger to another system. | Button B Hold | Simulink Coder Support Package for BBC micro:bit |
| When button B is pressed, send a momentary "1" or "true" - commonly used as a trigger to another system. | Button B Pressed | Simulink Coder Support Package for BBC micro:bit |
| Read bytes from an I2C peripheral as bus master — use to get data from I2C sensors or devices. | I2C Master Read | Simulink Coder Support Package for BBC micro:bit |
| Write bytes to an I2C peripheral as bus master — use to configure or command I2C devices. | I2C Master Write | Simulink Coder Support Package for BBC micro:bit |
| Read bytes from the serial (UART) port — use to receive data from a host or serial device. | SCI Read | Simulink Coder Support Package for BBC micro:bit |
| Write bytes to the serial (UART) port — use to send data or logging to a host or serial device. | SCI Write | Simulink Coder Support Package for BBC micro:bit |
| Exchange bytes with an SPI peripheral as bus master — use for full-duplex SPI communication. | SPI Master Transfer | Simulink Coder Support Package for BBC micro:bit |
| Outputs a 5x5 LED image on the Micro:bit board based on the 5x5 matrix specified at the input port. | 5x5 LED Matrix | Simulink Coder Support Package for BBC micro:bit |
| Take an input of min 5x5 matrix, shift it by one down every timestep and output a 5x5 matrix. | Scroll down | Simulink Coder Support Package for BBC micro:bit |
| Take an input of min 5x5 matrix, shift it by one to the left every timestep and output a 5x5 matrix. | Scroll left | Simulink Coder Support Package for BBC micro:bit |
| Take an input of min 5x5 matrix, shift it by one to the right every timestep and output a 5x5 matrix. | Scroll right  | Simulink Coder Support Package for BBC micro:bit |
| Take an input of min 5x5 matrix, shift it by one up every timestep and output a 5x5 matrix. | Scroll up | Simulink Coder Support Package for BBC micro:bit |
| Output an all-off 5×5 pattern — use to clear the LED display. | Empty matrix | Simulink Coder Support Package for BBC micro:bit |
