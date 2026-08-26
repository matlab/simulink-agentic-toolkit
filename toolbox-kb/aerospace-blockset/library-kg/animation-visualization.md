---
type: Simulink Block Category
title: Animation visualization
description: 3D visualization, FlightGear interface, and flight animation
tags: [animation, FlightGear, visualization, 3D, Unreal]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Animation visualization
block_count: 33
---

# Animation visualization

Use these blocks for animation visualization.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Pilot Joystick | aerolibanimutils/Pilot Joystick | R2023a+ | Read a single-axis hardware joystick input for pilot-in-the-loop simulation |
| Pilot Joystick All | aerolibanimutils/Pilot Joystick All | R2023a+ | Read all axes and buttons from a hardware joystick simultaneously for full pilot-in-the-loop simulation |
| Simulation Pace | aerolibanimutils/Simulation Pace | R2023a+ | Slow simulation to real time for interactive visualization and pilot-in-the-loop testing |
| FlightGear Preconfigured 6DoF Animation | aerolibfltsims/FlightGear Preconfigured 6DoF Animation | R2023a+ | Send 6DOF vehicle state to FlightGear for real-time 3D flight visualization with minimal configuration |
| Generate Run Script | aerolibfltsims/Generate Run Script | R2023a+ | Generate platform-specific script to launch FlightGear with correct network settings for co-simulation |
| Receive net_ctrl Packet from FlightGear | aerolibfltsims/Receive net_ctrl Packet from FlightGear | R2023a+ | Receive pilot control inputs from FlightGear via UDP for hardware-in-the-loop scenarios |
| Send net_fdm Packet to FlightGear | aerolibfltsims/Send net_fdm Packet to FlightGear | R2023a+ | Transmit vehicle state to FlightGear via UDP for real-time 3D visualization |
| Pack net_fdm Packet for FlightGear | aerolibfltsims/Pack net_fdm Packet for FlightGear | R2023a+ | Serialize flight dynamics state into FlightGear's net_fdm binary protocol format |
| Unpack net_ctrl Packet from FlightGear | aerolibfltsims/Unpack net_ctrl Packet from FlightGear | R2023a+ | Deserialize FlightGear's net_ctrl binary packet into individual control input signals |
| 3DoF Animation | aerolibanim/3DoF Animation | R2023a+ | Visualize longitudinal-plane vehicle motion in a 2D MATLAB figure with trajectory and attitude |
| 6DoF Animation | aerolibanim/6DoF Animation | R2023a+ | Visualize full 3D vehicle motion in a MATLAB figure with position and orientation |
| MATLAB Animation | aerolibanim/MATLAB Animation | R2023a+ | Render custom 3D aircraft geometry in a MATLAB figure for flight path visualization |
| Simulation 3D Air Transport Pack | aerolibsim3d/Simulation 3D Air Transport Pack | R2023b+ | Load a large commercial transport aircraft 3D mesh for Unreal Engine visualization |
| Simulation 3D Aircraft | aerolibsim3d/Simulation 3D Aircraft | R2023a+ | Generic aircraft actor for Unreal Engine co-simulation — position and orient any aircraft mesh in the 3D scene |
| Simulation 3D Airliner Pack | aerolibsim3d/Simulation 3D Airliner Pack | R2023b+ | Load a regional airliner 3D mesh for Unreal Engine visualization |
| Simulation 3D CubeSat Pack | aerolibsim3d/Simulation 3D CubeSat Pack | R2024a+ | Load a CubeSat 3D mesh for Unreal Engine space visualization |
| Simulation 3D Custom Pack | aerolibsim3d/Simulation 3D Custom Pack | R2023b+ | Load a user-supplied custom 3D mesh into the Unreal Engine scene |
| Simulation 3D General Aviation Pack | aerolibsim3d/Simulation 3D General Aviation Pack | R2023b+ | Load a general aviation aircraft 3D mesh for Unreal Engine visualization |
| Simulation 3D Helicopter Pack | aerolibsim3d/Simulation 3D Helicopter Pack | R2023b+ | Load a helicopter 3D mesh for Unreal Engine visualization |
| Simulation 3D Light Helicopter Pack | aerolibsim3d/Simulation 3D Light Helicopter Pack | R2023b+ | Load a light helicopter 3D mesh for Unreal Engine visualization |
| Simulation 3D Multirotor Pack | aerolibsim3d/Simulation 3D Multirotor Pack | R2023b+ | Load a multirotor drone 3D mesh for Unreal Engine visualization |
| Simulation 3D Rotorcraft | aerolibsim3d/Simulation 3D Rotorcraft | R2023a+ | Generic rotorcraft actor for Unreal Engine co-simulation with main and tail rotor animation |
| Simulation 3D Sky Hogg Pack | aerolibsim3d/Simulation 3D Sky Hogg Pack | R2023b+ | Load the Sky Hogg experimental aircraft 3D mesh for Unreal Engine visualization |
| Simulation 3D SmallSat Pack | aerolibsim3d/Simulation 3D SmallSat Pack | R2024a+ | Load a small satellite 3D mesh for Unreal Engine space visualization |
| Simulation 3D Space Environment | aerolibsim3d/Simulation 3D Space Environment | R2026a+ | Configure a space environment scene in Unreal Engine with Earth, Sun, and star background |
| Simulation 3D Spacecraft | aerolibsim3d/Simulation 3D Spacecraft | R2024a+ | Generic spacecraft actor for Unreal Engine co-simulation — position and orient in 3D space scene |
| Simulation 3D Actor Transform Get | aerolibsim3d/Simulation 3D Actor Transform Get | R2023a+ | Read position and orientation of any actor in the Unreal Engine 3D scene |
| Simulation 3D Actor Transform Set | aerolibsim3d/Simulation 3D Actor Transform Set | R2023a+ | Set position and orientation of any actor in the Unreal Engine 3D scene |
| Simulation 3D Camera Get | aerolibsim3d/Simulation 3D Camera Get | R2023a+ | Capture rendered camera image from the Unreal Engine scene for perception algorithm testing |
| Simulation 3D Message Get | aerolibsim3d/Simulation 3D Message Get | R2023a+ | Receive custom data messages from actors in the Unreal Engine 3D simulation |
| Simulation 3D Message Set | aerolibsim3d/Simulation 3D Message Set | R2023a+ | Send custom data messages to actors in the Unreal Engine 3D simulation |
| Simulation 3D Scene Configuration | aerolibsim3d/Simulation 3D Scene Configuration | R2023a+ | Configure the Unreal Engine 3D scene including weather, time of day, and terrain |
| Simulation 3D Ultrasonic Sensor | aerolibsim3d/Simulation 3D Ultrasonic Sensor | R2023b+ | Simulate an ultrasonic proximity sensor returning range measurements from the 3D scene |
