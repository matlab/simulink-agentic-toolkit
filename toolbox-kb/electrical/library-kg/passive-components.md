---
type: Simulink Block Category
title: Passive components
description: Resistors, capacitors, inductors, transformers, cables, and loads
tags: [resistor, capacitor, inductor, transformer, cable]
status: stable
source: mathworks_toolbox
library_root: Electrical
category_path: Passive components
block_count: 54
---

# Passive components

Use these blocks for passive components.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| S-Parameter Rational Fit | ee_lib/Passive/S-Parameter Rational Fit | R2024b+ | Model an RF component from measured S-parameter data using rational fitting — use for incorporating measured frequency-domain device behavior into time-domain simulation |
| Capacitor | ee_lib/Passive/Capacitor | R2023a+ | Model an ideal or lossy capacitor — use for energy storage, filtering, coupling, decoupling, or any circuit requiring capacitive behavior |
| Constant Current Load | ee_lib/Passive/Constant Current Load | R2023a+ | Model a load that draws constant current regardless of voltage — use for LED drivers, battery chargers, or constant-current electronic loads |
| Constant Current Load (Three-Phase) | ee_lib/Passive/Constant Current Load (Three-Phase) | R2023a+ | Model a three-phase load drawing constant current — use for power system studies with current-regulated loads or testing source regulation |
| Constant Power Load | ee_lib/Passive/Constant Power Load | R2023a+ | Model a load that consumes constant power regardless of voltage — use for regulated converters, motor drives seen from the supply, or grid load modeling |
| Constant Power Load (Three-Phase) | ee_lib/Passive/Constant Power Load (Three-Phase) | R2023a+ | Model a three-phase constant power load — use for power system studies with regulated loads that maintain constant power draw |
| Crystal | ee_lib/Passive/Crystal | R2023a+ | Model a piezoelectric crystal resonator — use for oscillator circuits, frequency reference design, or crystal filter analysis |
| Diffusion Resistor | ee_lib/Passive/Diffusion Resistor | R2023a+ | Model a resistor with frequency-dependent skin-effect behavior — use for accurate high-frequency conductor modeling or eddy-current resistance |
| Dynamic Load | ee_lib/Passive/Dynamic Load | R2023a+ | Model a single-phase dynamic load with voltage and frequency dependent characteristics — use for power system loads that change with operating conditions |
| Dynamic Load (Three-Phase) | ee_lib/Passive/Dynamic Load (Three-Phase) | R2023a+ | Model a three-phase dynamic load with voltage and frequency dependence — use for power system stability studies with realistic load behavior |
| Eddy Current | ee_lib/Passive/Eddy Current | R2023a+ | Model eddy current losses in a magnetic component — use alongside magnetic cores to capture frequency-dependent iron losses |
| Incandescent Lamp | ee_lib/Passive/Incandescent Lamp | R2023a+ | Model an incandescent lamp with nonlinear resistance varying with temperature — use for lighting circuit studies, inrush current analysis, or cold-start effects |
| Inductor | ee_lib/Passive/Inductor | R2023a+ | Model an ideal or lossy inductor — use for filtering, energy storage, magnetic coupling, or any circuit requiring inductive behavior |
| Magnetic Core | ee_lib/Passive/Magnetic Core | R2024b+ | Model a nonlinear magnetic core with saturation and hysteresis — use for transformer core modeling, inductor saturation studies, or magnetic circuit design |
| Nonlinear Inductor | ee_lib/Passive/Nonlinear Inductor | R2023a+ | Model an inductor with current-dependent or flux-dependent inductance — use for saturable reactors, magnetic amplifiers, or core saturation effects |
| Nonlinear Reluctance | ee_lib/Passive/Nonlinear Reluctance | R2023a+ | Model a nonlinear magnetic reluctance element — use as a building block for reluctance network magnetic circuit models with saturation |
| Passive Harmonic Filter (Three-Phase) | ee_lib/Passive/Passive Harmonic Filter (Three-Phase) | R2023a+ | Model a passive LC harmonic filter tuned to specific frequencies — use for power quality improvement, harmonic mitigation at converter outputs, or THD reduction |
| Potentiometer | ee_lib/Passive/Potentiometer | R2023a+ | Model a variable resistor with a wiper position input — use for user-adjustable gain, sensor simulation, or voltage divider circuits with manual control |
| Resistor | ee_lib/Passive/Resistor | R2023a+ | Model an ideal or temperature-dependent resistor — use for any circuit element requiring resistance: loads, voltage dividers, current sensing, or damping |
| Supercapacitor | ee_lib/Passive/Supercapacitor | R2023a+ | Model an electrochemical double-layer capacitor with ESR and voltage-dependent capacitance — use for energy storage, regenerative braking buffers, or power backup systems |
| Variable Capacitor | ee_lib/Passive/Variable Capacitor | R2023a+ | Model a capacitor whose capacitance is set by an external signal — use for varactor tuning, parametric circuits, or time-varying filter studies |
| Variable Inductor | ee_lib/Passive/Variable Inductor | R2023a+ | Model an inductor whose inductance is set by an external signal — use for tunable filters, saturable reactors under control, or parametric studies |
| Varistor | ee_lib/Passive/Varistor | R2023a+ | Model a metal-oxide varistor with nonlinear voltage-current characteristic — use for surge protection, voltage clamping, or transient voltage suppression studies |
| Winding | ee_lib/Passive/Winding | R2023a+ | Model an electrical winding on a magnetic core — use as a building block for custom transformer or inductor designs with explicit magnetic circuit models |
| AC Cable (Three-Phase) | ee_lib/Passive/Lines/AC Cable (Three-Phase) | R2023a+ | Model a three-phase AC cable with per-unit-length resistance, inductance, and capacitance — use for power distribution cable studies including voltage drop and losses |
| Coupled Lines (Three-Phase) | ee_lib/Passive/Lines/Coupled Lines (Three-Phase) | R2023a+ | Model three coupled transmission lines — use for three-phase transmission line studies including mutual coupling between phases |
| Coupled Lines (Pair) | ee_lib/Passive/Lines/Coupled Lines (Pair) | R2023a+ | Model a pair of electromagnetically coupled transmission lines — use for crosstalk analysis, differential pairs, or coupled microstrip studies |
| DC Cable | ee_lib/Passive/Lines/DC Cable | R2025a+ | Model a DC cable with resistance and inductance — use for DC distribution systems, battery interconnects, or EV charging cable studies |
| Frequency-Dependent Overhead Line (Three-Phase) | ee_lib/Passive/Lines/Frequency-Dependent Overhead Line (Three-Phase) | R2023a+ | Model a three-phase overhead transmission line with frequency-dependent parameters — use for electromagnetic transient studies of long lines |
| Multiphase Distributed Parameter Line | ee_lib/Passive/Lines/Multiphase Distributed Parameter Line | R2023a+ | Model a multiphase transmission line with distributed RLCG parameters — use for accurate wave propagation studies in long power or signal lines |
| Multiphase Coupled Lines | ee_lib/Passive/Lines/Multiphase Coupled Lines | R2023a+ | Model N coupled transmission lines with mutual electromagnetic coupling — use for multi-conductor cable or bus-bar systems with crosstalk |
| Transmission Line (Three-Phase) | ee_lib/Passive/Lines/Transmission Line (Three-Phase) | R2023a+ | Model a three-phase distributed-parameter transmission line — use for power system transient studies of overhead lines or underground cables |
| Transmission Line | ee_lib/Passive/Lines/Transmission Line | R2023a+ | Model a single-phase distributed-parameter transmission line — use for wave propagation, reflection studies, or long cable transient analysis |
| Delta-Connected Variable Load | ee_lib/Passive/RLC Assemblies/Delta-Connected Variable Load | R2023a+ | Model a delta-connected three-phase load with variable impedance — use for load-stepping studies, demand variation, or tap-changing load banks |
| Delta-Connected Load | ee_lib/Passive/RLC Assemblies/Delta-Connected Load | R2023a+ | Model a balanced or unbalanced delta-connected three-phase load — use for industrial motor equivalents, heater banks, or delta-wired equipment |
| RLC (Three-Phase) | ee_lib/Passive/RLC Assemblies/RLC (Three-Phase) | R2023a+ | Model a three-phase RLC series or parallel branch — use for balanced impedance loads, filter elements, or transmission line terminations |
| Wye-Connected Variable Load | ee_lib/Passive/RLC Assemblies/Wye-Connected Variable Load | R2023a+ | Model a wye-connected three-phase load with variable impedance — use for load variation studies or testing generator regulation under changing demand |
| Wye-Connected Variable Load (lagging) | ee_lib/Passive/RLC Assemblies/Wye-Connected Variable Load (lagging) | R2023a+ | Model a wye-connected variable load with lagging power factor — use for inductive load variation studies typical of motor-dominated industrial buses |
| Wye-Connected Load | ee_lib/Passive/RLC Assemblies/Wye-Connected Load | R2023a+ | Model a balanced or unbalanced wye-connected three-phase load — use for power system load representation with neutral access |
| Cauer Thermal Model | ee_lib/Passive/Thermal/Cauer Thermal Model | R2023a+ | Model thermal dynamics using a Cauer RC network with physical layer correspondence — use for semiconductor or machine thermal analysis with material-based parameters |
| Foster Thermal Model | ee_lib/Passive/Thermal/Foster Thermal Model | R2023a+ | Model thermal dynamics using a Foster RC network — use for semiconductor junction temperature estimation from datasheet thermal impedance curves |
| Heatsink | ee_lib/Passive/Thermal/Heatsink | R2023a+ | Model a heatsink thermal resistance and capacitance — use with semiconductor thermal models to study junction temperature under load cycling |
| Thermal Resistor | ee_lib/Passive/Thermal/Thermal Resistor | R2023a+ | Model thermal resistance between two temperature nodes — use for heat path modeling in thermal networks alongside electrical-thermal coupling |
| Center-Tapped Transformer | ee_lib/Passive/Transformers/Center-Tapped Transformer | R2023a+ | Model a transformer with a center-tapped secondary winding — use for full-wave rectifier supplies, balanced audio circuits, or split-rail power generation |
| Earthing Transformer | ee_lib/Passive/Transformers/Earthing Transformer | R2023a+ | Model a zigzag earthing transformer providing a neutral point for delta systems — use for grounding ungrounded three-phase systems |
| Mutual Inductor | ee_lib/Passive/Transformers/Mutual Inductor | R2023a+ | Model two magnetically coupled inductors — use for transformer modeling, coupled filter design, or wireless power transfer coils |
| Nonlinear Transformer | ee_lib/Passive/Transformers/Nonlinear Transformer | R2023a+ | Model a transformer with nonlinear magnetic core including saturation — use for inrush current studies, ferroresonance analysis, or CT saturation modeling |
| Phase-Shifting Transformer | ee_lib/Passive/Transformers/Phase-Shifting Transformer | R2023a+ | Model a transformer with adjustable phase angle between primary and secondary — use for power flow control, multi-pulse rectifier phase shifting, or grid regulation |
| Tap-Changing Transformer | ee_lib/Passive/Transformers/Tap-Changing Transformer | R2023a+ | Model a transformer with selectable tap positions for voltage regulation — use for distribution transformers, voltage regulators, or OLTC studies |
| Three-Winding Nonlinear Transformer | ee_lib/Passive/Transformers/Three-Winding Nonlinear Transformer | R2023a+ | Model a three-winding transformer with nonlinear magnetic core — use for multi-output power supplies or distribution transformers with saturation effects |
| Three-Winding Transformer (Three-Phase) | ee_lib/Passive/Transformers/Three-Winding Transformer (Three-Phase) | R2023a+ | Model a three-phase transformer with three windings per phase — use for autotransformers, tertiary stabilizing windings, or multi-voltage-level substations |
| Three-Winding Mutual Inductor | ee_lib/Passive/Transformers/Three-Winding Mutual Inductor | R2023a+ | Model three magnetically coupled inductors — use for three-winding transformer equivalent circuits or multi-coil coupling studies |
| Two-Winding Transformer (Three-Phase) | ee_lib/Passive/Transformers/Two-Winding Transformer (Three-Phase) | R2023a+ | Model a standard three-phase two-winding transformer — use for power distribution, voltage transformation, or industrial supply modeling |
| Zigzag-Delta-Wye Transformer | ee_lib/Passive/Transformers/Zigzag-Delta-Wye Transformer | R2023a+ | Model a complex multi-winding transformer with zigzag, delta, and wye connections — use for specialized grounding transformers or phase-shifting applications |
