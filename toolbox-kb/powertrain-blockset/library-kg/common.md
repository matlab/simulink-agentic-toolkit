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
| Model an open differential splitting torque equally to two outputs — use as a standard axle differential in a driveline. | Open Differential | Powertrain Blockset |
| Model a spark-ignition (gasoline) engine from lookup maps — use for map-based gasoline powertrain simulation. | Mapped SI Engine | Powertrain Blockset |
| Model an electric motor and inverter from efficiency/torque maps — use for fast system-level EV powertrain studies. | Mapped Motor | Powertrain Blockset |
| Model an idealized multi-speed transmission with instantaneous gear selection — use for lightweight transmission studies. | Ideal Fixed Gear Transmission | Powertrain Blockset |
| Model longitudinal vehicle motion with a single degree of freedom — use for simple straight-line acceleration/braking studies. | Vehicle Body 1DOF Longitudinal | Powertrain Blockset |
| Output a standard or custom drive-cycle speed reference versus time — use to drive powertrain and fuel-economy simulations. | Drive Cycle Source | Powertrain Blockset |
| Model a driver that produces accelerator and brake commands to track a speed reference — use to close the loop on a drive cycle. | Longitudinal Driver | Powertrain Blockset |
| Implements a reduced Lundell (claw-pole) alternator and voltage regulator. The back-EMF is proportional to the input speed and field current. The machine operates as a torque source to the combustion engine. | Reduced Lundell Alternator | Powertrain Blockset |
| Implements a DC to DC converter supporting bidirectional boost and buck operation. Specify the DC to DC transient response, power limit, and losses. Output voltage tracks the voltage command unless the DC to DC converter is power limiting. Specify electrical losses using measured losses or measured efficiency. | Bidirectional DC-DC | Powertrain Blockset |
| Implements a model for a lithium ion, lithium polymer, or lead acid battery based off of discharge characteristics taken at different temperatures. The model can be parameterized using a typical battery datasheet or through experimental measurement. | Datasheet Battery | Powertrain Blockset |
| Implements a resistor-capacitor (RC) circuit battery that you can parameterize using equivalent circuit modeling (ECM). To simulate the state-of-charge (SOC) and terminal voltage, the block uses load current and internal core temperature. Calculates the combined network battery voltage using lookup tables that are functions of the SOC and battery temperature. Use the Estimation Equivalent Circuit Battery block to help create the lookup tables. | Equivalent Circuit Battery | Powertrain Blockset |
| Implements a resistor-capacitor (RC) circuit battery model that determines the combined voltage of a network battery using parameter lookup tables that are functions of the state-of-charge (SOC). Recommend using the block for estimating battery voltage and SOC, not in system-level models. | Estimation Equivalent Circuit Battery | Powertrain Blockset |
| Implements an idealized dry friction clutch. | Disc Clutch | Powertrain Blockset |
| Implements an ideal planetary gear coupling consisting of a rigidly coupled sun, ring and carrier. Torque inputs are provided in order to produce the corresponding velocity response. | Planetary Gear | Powertrain Blockset |
| Model a fixed-ratio gearbox with inertia and efficiency losses — use to represent a gear reduction in a driveline. | Gearbox | Powertrain Blockset |
| Model a motorcycle final-drive chain with ratio and compliance — use to couple the transmission to the rear wheel. | Motorcycle Chain | Powertrain Blockset |
| Add lumped rotational inertia (with optional damping) to a driveline shaft — use to represent spinning mass. | Rotational Inertia | Powertrain Blockset |
| Field-oriented controller for a flux-based permanent-magnet motor — use to command torque/current in a flux-based PMSM drive. | Flux-Based PM Controller | Powertrain Blockset |
| Model a permanent-magnet synchronous motor from flux-linkage maps — use for high-fidelity PMSM simulation that captures saturation. | Flux-Based PMSM | Powertrain Blockset |
| Model a three-phase induction machine with electrical and mechanical dynamics — use as an ACIM traction motor. | Induction Motor | Powertrain Blockset |
| Model an interior-permanent-magnet synchronous motor with saliency and reluctance torque — use for IPMSM traction drives. | Interior PMSM | Powertrain Blockset |
| Model a surface-mount permanent-magnet synchronous motor — use for SPMSM traction and drive simulation. | Surface Mount PMSM | Powertrain Blockset |
| Model an automated manual transmission with clutch and gear-shift logic — use for AMT driveline studies. | Automated Manual Transmission | Powertrain Blockset |
| Model a CVT with a continuously variable gear ratio — use for CVT powertrain simulation. | Continuously Variable Transmission | Powertrain Blockset |
| Model a dual-clutch transmission with two clutches for seamless shifts — use for DCT driveline studies. | Dual Clutch Transmission | Powertrain Blockset |
| Bundle component power and energy signals into a power-accounting bus — use to track energy flow for efficiency analysis. | Power Accounting Bus Creator | Powertrain Blockset |
| Bridge a Simscape physical two-way connection into a Powertrain Blockset signal interface — use to link physical and signal domains. | Two-Way Connection | Powertrain Blockset |
| Expose a physical connection port on a Powertrain subsystem — use to create a physical pin on a masked subsystem. | Connection Port | Powertrain Blockset |
| Model in-plane longitudinal motorcycle body dynamics — use for motorcycle acceleration and braking studies. | Motorcycle Body Longitudinal In-Plane | Powertrain Blockset |
| Model vehicle longitudinal, vertical, and pitch dynamics (3 DOF) — use for ride and load-transfer studies in the longitudinal plane. | Vehicle Body 3DOF Longitudinal | Powertrain Blockset |
