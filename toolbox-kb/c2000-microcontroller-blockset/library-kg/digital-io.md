---
type: Simulink Block Category
title: Digital io
description: GPIO digital input/output
tags: [digital, gpio, input, output]
status: stable
source: custom_library
library_root: C2000 Microcontroller Blockset
category_path: Digital io
block_count: 68
---

# Digital io

Use these blocks for digital io.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Digital Input | c2802xlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c2802xlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c2803xlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c2803xlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c280xlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c280xlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c281xlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c281xlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| QEP | c281xlib/QEP | R2023a+ | Configures quadrature encoder pulse circuit associated with the selected Event Manager module to decode and count quadrature encoded pulses applied to related input pins (QEP1 and QEP2 for EVA or QEP3 and QEP4 for EVB). Depending on the selected counting mode, the output is either the pulse count or the rotor speed (when a pulse signal comes from an optical encoder mounted on a rotating machine). |
| Digital Input | c2833xlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c2833xlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c2834xlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c2834xlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c2805xlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c2805xlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c2806xlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c2806xlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c280013xlib/Digital Input | R2023b+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c280013xlib/Digital Output | R2023b+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c280015xlib/Digital Input | R2023b+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c280015xlib/Digital Output | R2023b+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c28002xlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c28002xlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c28003xlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c28003xlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c28004xlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c28004xlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c2807xlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c2807xlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c2837xDlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c2837xDlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c2837xSlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c2837xSlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c2838xlib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c2838xlib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c2838x_M4_lib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c2838x_M4_lib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | f28M35x_C28x_lib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | f28M35x_C28x_lib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | f28M35x_M3_lib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | f28M35x_M3_lib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | f28M36x_C28x_lib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | f28M36x_C28x_lib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | f28M36x_M3_lib/Digital Input | R2023a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | f28M36x_M3_lib/Digital Output | R2023a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c28P55xlib/Digital Input | R2024b+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c28P55xlib/Digital Output | R2024b+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c28P65xlib/Digital Input | R2024a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c28P65xlib/Digital Output | R2024a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Digital Input | c29H85xlib/Digital Input | R2025a+ | Read the state of a digital (GPIO) input pin — use to sense external logic levels or switches. |
| Digital Output | c29H85xlib/Digital Output | R2025a+ | Set the state of a digital (GPIO) output pin — use to drive external logic, LEDs, or enables. |
| Absolute IQN | tiiqmathlib/Absolute IQN | R2023a+ | This block computes the absolute value of an IQ number. Both the input and the output are signed 32-bit fixed-point numbers. The respective IQNabs function is selected based on the Q value. |
| Arctangent IQN | tiiqmathlib/Arctangent IQN | R2023a+ | This block computes the 4-quadrant arctangent for two IQ numbers given in the same Q format. All inputs and outputs are signed 32-bit fixed-point numbers. Depending on the selected option, the output of the block is either in radians and varies from -pi to +pi or in per unit (PU) and varies from 0 to 1. The respective IQNatan function is selected by the input data type. |
| Float to IQN | tiiqmathlib/Float to IQN | R2023a+ | This block converts a floating-point input to the equivalent IQ value. The input is a single-precission floating-point number and the output is a signed 32-bit fixed-point number. The respective IQN function is selected based on the Q value specified for the output. |
| Fractional part IQN x int32 | tiiqmathlib/Fractional part IQN x int32 | R2023a+ | This block multiplies an IQ number with a long integer number and returns the fractional part of the result. First input and the output are signed 32-bit fixed-point numbers, while the second input is a long integer number. The respective IQNmpyI32frac function is selected based on the Q value of the input. |
| Fractional part IQN | tiiqmathlib/Fractional part IQN | R2023a+ | This block returns the fractional part of an IQ number. Both the input and output are signed 32-bit fixed-point numbers. The respective IQNfrac function is selected based on the Q value. |
| IQN / IQN | tiiqmathlib/IQN / IQN | R2023a+ | This block divides two IQN numbers using Newton-Raphson technique. All inputs and outputs are signed 32-bit fixed-point numbers that have the same Q value. The respective IQNdiv function is selected based on the Q value. |
| IQN to Float | tiiqmathlib/IQN to Float | R2023a+ | This block converts an IQ number to the equivalent floating-point value in IEEE 754 format. The input is a signed 32-bit fixed-point number and the output is a single-precission floating-point number. The respective IQNtoF function is selected based on the Q value. |
| IQN x int32 | tiiqmathlib/IQN x int32 | R2023a+ | This block multiplies an IQ number with a long integer. First input and the output are signed 32-bit fixed-point numbers, while the second input is a long integer number. The respective IQNmpyI32 function is selected based on the Q value of the first input. |
| IQN1 to IQN2 | tiiqmathlib/IQN1 to IQN2 | R2023a+ | This block converts an IQ number to a new IQ number in specified Q format. Both the input and output are signed 32-bit fixed-point numbers. The respective IQNtoIQx function is selected based on the Q value. |
| IQN1 x IQN2 | tiiqmathlib/IQN1 x IQN2 | R2023a+ | This block multiplies two IQ numbers that are represented in different IQ format. All inputs and outputs are signed 32-bit fixed-point numbers. The respective IQNmpyIQX function is selected based on the Q value specified for the output. |
| Integer part IQN x int32 | tiiqmathlib/Integer part IQN x int32 | R2023a+ | This block multiplies an IQ number with a long integer number and returns the integer part of the result. First input is a signed 32-bit fixed-point number, while the second input and the output are long integer numbers. The respective IQNmpyI32int function is selected based on the Q value of the input. |
| Integer part IQN | tiiqmathlib/Integer part IQN | R2023a+ | This block returns the integer part of an IQ number. The input is a signed 32-bit fixed-point number and the output is a long integer number. The respective IQNint function is selected based on the Q value. |
| Magnitude IQN | tiiqmathlib/Magnitude IQN | R2023a+ | This block computes the magnitude of two IQ numbers. All inputs and outputs are signed 32-bit fixed-point numbers in the same Q format. The respective IQNmag function is selected based on the Q value. |
| Saturate IQN | tiiqmathlib/Saturate IQN | R2023a+ | This block saturates the value of an IQ number to the given upper and lower limits. Both the input and the output are signed 32-bit fixed-point numbers. The respective IQsat function is selected based on the Q value. The upper and lower limits have to be given as real world values. |
| Square Root IQN | tiiqmathlib/Square Root IQN | R2023a+ | This block computes the square root and the inverse square root of an IQ number using table lookup and Newton-Raphson approximation. Both the input and the output are signed 32-bit fixed-point numbers. The respective IQNsqrt function is selected based on the Q value. |
| Trig Fcn IQN | tiiqmathlib/Trig Fcn IQN | R2023a+ | This block computes selected trigonometric functions of an IQ number. Both the input and the output are signed 32-bit fixed-point numbers. The respective trigonometric function is selected based on the Q value. |
| Hardware Profiler | c2000lib/Scheduling/Hardware Profiler | R2024b+ | Profiles functions using GPIO, ERAD or Timer measurement modes. GPIO: Selected pin is set and cleared before and after the execution of the downstream function-call subsystem. ERAD: The duration between the start and end of execution of the downstream function-call subsystem is measured. Timer: Timer 2 count is read before and after the execution of the downstream function-call subsystem. The difference between these timer reads is computed. |
