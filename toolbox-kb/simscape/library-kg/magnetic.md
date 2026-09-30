---
type: Simulink Block Category
title: Magnetic
description: Magnetic-domain elements, sources, and sensors
tags: [magnetic]
status: stable
source: custom_library
library_root: Simscape
category_path: Magnetic
block_count: 12
---

# Magnetic

Use these blocks for magnetic.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Fundamental Reluctance | fl_lib/Magnetic/Magnetic Elements/Fundamental Reluctance | R2023a+ | Models a magnetic reluctance, that is a component that resists flux flow. The ratio of the magnetomotive force (mmf) across the component to the resulting flux that flows through the component is constant, and the ratio value is directly defined as the reluctance, R. The terminals of the reluctance are denoted by N and S, respectively. By convention, the mmf across the reluctance is given by mmf(N) - mmf(S), and the sign of the flux is positive when flowing through the device from the N to the S terminal. |
| Magnetic Reference | fl_lib/Magnetic/Magnetic Elements/Magnetic Reference | R2023a+ | Magnetic reference port. A model must contain at least one magnetic reference port. |
| Permanent Magnet | fl_lib/Magnetic/Magnetic Elements/Permanent Magnet | R2023b+ | Models a permanent magnet, which is a component that passively generates a magnetic field. When you subject the block to an external magnetic field, the block approximates the flux density B of the resultant magnetic field using one of these linear relationships: B = bR + muR*mu0*H = bR/hC(hC+H) = muR*mu0*(hC+H) where H is the strength of the external magnetic field, bR is the remanent flux density of the magnet, hC is the coercivity of the magnet, muR is the relative magnetic permeability of material, and mu0 is the magnetic permeability constant. N and S denote the north and south terminals of the permanent magnet, respectively. By convention, the mmf across the permanent magnet is given by mmf(N) - mmf(S). The flux is positive when the flux flows through the device from the N to the S terminal. |
| Reluctance | fl_lib/Magnetic/Magnetic Elements/Reluctance | R2023a+ | Models a magnetic reluctance, that is a component that resists flux flow. The ratio of the magnetomotive force (mmf) across the component to the resulting flux that flows through the component is constant, and the ratio value is defined as the reluctance, R. Reluctance depends on the geometry of the section modeled R = g/(mu0*mur*CSA) where g is the thickness of the section or air gap, mu0 is the magnetic permeability constant, mur is the relative magnetic permeability of the material, and CSA is the cross-sectional area The terminals of the reluctance are denoted by N and S, respectively. By convention, the mmf across the reluctance is given by mmf(N) - mmf(S), and the sign of the flux is positive when flowing through the device from the N to the S terminal. |
| Reluctance Force Actuator | fl_lib/Magnetic/Magnetic Elements/Reluctance Force Actuator | R2023a+ | Represents a generic magnetomotive device based on the reluctance force F = -0.5 * PHI^2 * dR/dx where R is the reluctance dependent on the thickness of, or length of, the air gap x, and PHI is the flux in the magnetic circuit. The magnetic force produced acts to close the air gap, i.e. the resulting force is negative acting from the mechanical C to R ports. |
| Variable Reluctance | fl_lib/Magnetic/Magnetic Elements/Variable Reluctance | R2023a+ | Models a variable reluctance, that is a component that resists flux flow. The ratio of the magnetomotive force (mmf) across the component to the resulting flux that flows through the component is defined as the reluctance, R, that is dependent on the physical signal port. R = X/(mu0*mur*CSA) where X is the value presented at the physical signal port, mu0 is the magnetic permeability constant, mur is the relative magnetic permeability of the material, and CSA is the cross-sectional area. Connections N and S are conserving magnetic ports. The flux is positive if it flows from N to S, and the mmf across the reluctance is given by mmf(N) - mmf(S). |
| Flux Sensor | fl_lib/Magnetic/Magnetic Sensors/Flux Sensor | R2023a+ | The block represents an ideal flux sensor, that is, a device that converts flux measured in any magnetic branch into a physical signal proportional to the flux. Connections N and S are conserving magnetic ports through which the sensor is inserted into the circuit. The physical signal port outputs the value of the flux, which is positive when the flux flows from the N to the S port. |
| MMF Sensor | fl_lib/Magnetic/Magnetic Sensors/MMF Sensor | R2023a+ | The block represents an ideal magnetomotive force (mmf) sensor, that is, a device that converts the mmf measured between any magnetic connections into a physical signal proportional to the mmf. Connections N and S are conserving magnetic ports through which the sensor is connected to the circuit. The physical signal port outputs the value of the mmf. |
| Controlled Flux Source | fl_lib/Magnetic/Magnetic Sources/Controlled Flux Source | R2023a+ | The block represents an ideal flux source that is powerful enough to maintain the specified flux through it regardless of the mmf across it. The output flux is PHI = PHIs, where PHIs is the numerical value presented at the physical signal port. |
| Controlled MMF Source | fl_lib/Magnetic/Magnetic Sources/Controlled MMF Source | R2023a+ | The block represents an ideal magnetomotive force (mmf) source that is powerful enough to maintain the specified mmf at its output regardless of the flux passing through it. The output mmf is MMF = MMFI, where MMFI is the numerical value presented at the physical signal port. |
| Flux Source | fl_lib/Magnetic/Magnetic Sources/Flux Source | R2023a+ | The ideal flux source maintains a constant flux through it, independent of the mmf across its terminals. The output flux is defined by the Constant flux parameter, and can be any real value. |
| MMF Source | fl_lib/Magnetic/Magnetic Sources/MMF Source | R2023a+ | The ideal magnetomotive force (mmf) source maintains a constant mmf across its output terminals, independent of the flux flowing through the source. The output mmf is defined by the Constant mmf parameter, and can be any real value. |
