---
type: Simulink Block Category
title: Control blocks
description: Controllers for machines, converters, and power systems including exciters and governors
tags: [controller, pi, foc, exciter, governor]
status: stable
source: mathworks_toolbox
library_root: Electrical
category_path: Control blocks
block_count: 95
---

# Control blocks

Use these blocks for control blocks.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| BLDC Commutation Logic | ee_sl_lib/BLDC Control/BLDC Commutation Logic | R2023a+ | Generate six-step commutation signals for a BLDC motor from Hall sensor inputs — use as the core commutation logic in trapezoidal BLDC drives |
| BLDC Current Controller | ee_sl_lib/BLDC Control/BLDC Current Controller | R2023a+ | Regulate DC bus current for a BLDC drive — use to implement current-mode control for torque regulation in six-step BLDC systems |
| BLDC Current Controller with PWM Generation | ee_sl_lib/BLDC Control/BLDC Current Controller with PWM Generation | R2023a+ | Regulate BLDC current and generate PWM gate signals — use as a complete current-loop controller with integrated PWM for BLDC drives |
| Bridge Cycloconverter Voltage Controller (Three-Phase) | ee_sl_lib/Converter Control/Bridge Cycloconverter Voltage Controller (Three-Phase) | R2023a+ | Control a three-phase bridge cycloconverter output voltage — use for low-frequency high-power AC drive control or large motor speed regulation |
| DC-DC Voltage Controller | ee_sl_lib/Converter Control/DC-DC Voltage Controller | R2023a+ | Regulate output voltage of a DC-DC converter — use for closed-loop voltage control of buck, boost, or buck-boost topologies |
| PFC Rectifier Controller (Three-Phase)  | ee_sl_lib/Converter Control/PFC Rectifier Controller (Three-Phase)  | R2023a+ | Control a three-phase power factor correction rectifier — use for unity power factor front-end regulation in AC-DC converters |
| Thyristor Rectifier Voltage Controller (Three-Phase) | ee_sl_lib/Converter Control/Thyristor Rectifier Voltage Controller (Three-Phase) | R2023a+ | Control output voltage of a three-phase thyristor rectifier via firing angle — use for DC motor drives, battery chargers, or industrial rectifier regulation |
| Change Detector | ee_sl_lib/General Control/Change Detector | R2023a+ | Detect when an input signal changes value — use for event-based triggering, edge detection, or state change notification in control logic |
| Counter | ee_sl_lib/General Control/Counter | R2023a+ | Count events or clock cycles — use for pulse counting, frequency division, or sequencing logic in power electronics control |
| Filtered Derivative (Discrete or Continuous) | ee_sl_lib/General Control/Filtered Derivative (Discrete or Continuous) | R2023a+ | Compute a band-limited derivative of a signal — use for rate feedback, damping injection, or speed estimation from position without amplifying noise |
| Fourier Analysis | ee_sl_lib/General Control/Fourier Analysis | R2023a+ | Extract magnitude and phase of a specific harmonic from a periodic signal — use for THD measurement, harmonic monitoring, or PLL frequency tracking |
| Integrator (Discrete or Continuous) | ee_sl_lib/General Control/Integrator (Discrete or Continuous) | R2023a+ | Integrate a signal with configurable reset and saturation — use for PI controller integral paths, energy accumulation, or angle from angular velocity |
| Integrator with Wrapped State (Discrete or Continuous) | ee_sl_lib/General Control/Integrator with Wrapped State (Discrete or Continuous) | R2023a+ | Integrate with state wrapping at specified limits — use for angle integration that wraps at 2*pi or phase accumulation in PLLs |
| Lead-Lag (Discrete or Continuous) | ee_sl_lib/General Control/Lead-Lag (Discrete or Continuous) | R2023a+ | Implement a lead-lag compensator transfer function — use for phase margin improvement, voltage regulator compensation, or power system stabilizers |
| Low-Pass Filter (Discrete or Continuous) | ee_sl_lib/General Control/Low-Pass Filter (Discrete or Continuous) | R2023a+ | Filter a signal with a first-order low-pass response — use for noise attenuation, measurement smoothing, or removing switching ripple from feedback signals |
| Low-Pass Filter (Variable Time Constant, Discrete or Continuous) | ee_sl_lib/General Control/Low-Pass Filter (Variable Time Constant, Discrete or Continuous) | R2023a+ | Filter with a dynamically adjustable time constant — use when filter bandwidth must adapt to operating frequency or conditions |
| Model Reference Adaptive Controller | ee_sl_lib/General Control/Model Reference Adaptive Controller | R2023a+ | Implement model-reference adaptive control adjusting gains to match a reference model — use for adaptive speed or position control with uncertain plant parameters |
| Monostable Flip-Flop | ee_sl_lib/General Control/Monostable Flip-Flop | R2023a+ | Generate a fixed-duration pulse on each trigger edge — use for debouncing, minimum pulse width enforcement, or timed event generation |
| Moving Average | ee_sl_lib/General Control/Moving Average | R2023a+ | Compute the moving average of a signal over one fundamental period — use for extracting DC content from switching waveforms or ripple-free power measurements |
| Moving Average (Variable Frequency) | ee_sl_lib/General Control/Moving Average (Variable Frequency) | R2023a+ | Compute moving average with window tracking a variable fundamental frequency — use when grid or machine frequency varies and averaging must stay synchronized |
| On-Off Delay | ee_sl_lib/General Control/On-Off Delay | R2023a+ | Implement configurable turn-on and turn-off delays for a Boolean signal — use for debouncing, timed interlocks, or delayed enable logic in protection schemes |
| PI Controller (Discrete or Continuous) | ee_sl_lib/General Control/PI Controller (Discrete or Continuous) | R2023a+ | Implement a proportional-integral controller — use for current, voltage, speed, or position regulation loops in power electronics and drives |
| PI Controller with Integral Anti-Windup (Discrete or Continuous) | ee_sl_lib/General Control/PI Controller with Integral Anti-Windup (Discrete or Continuous) | R2023a+ | Implement a PI controller with anti-windup limiting — use for regulators that must handle saturation without integral buildup causing overshoot |
| Programmable Signal Generator (Three-Phase) | ee_sl_lib/General Control/Programmable Signal Generator (Three-Phase) | R2023a+ | Generate three-phase reference signals with programmable amplitude, frequency, and phase — use for testing controllers, grid emulation, or injection-based methods |
| RST Controller | ee_sl_lib/General Control/RST Controller | R2023a+ | Implement a discrete RST polynomial controller — use for high-performance current or voltage loops designed via pole-placement or model-based methods |
| Second-Order Low-Pass Filter (Discrete or Continuous) | ee_sl_lib/General Control/Second-Order Low-Pass Filter (Discrete or Continuous) | R2023a+ | Filter a signal with a second-order low-pass response — use for smoother attenuation with configurable damping ratio and natural frequency |
| Second-Order Filter | ee_sl_lib/General Control/Second-Order Filter | R2023a+ | Implement a configurable second-order transfer function filter — use for bandpass, notch, or resonant filtering in power electronics control |
| Serial-In Parallel-Out Shift Register | ee_sl_lib/General Control/Serial-In Parallel-Out Shift Register | R2023a+ | Convert a serial bit stream to parallel output — use for decoding serial communication, PWM pattern generation, or digital control sequencing |
| Set-Reset Flip-Flop | ee_sl_lib/General Control/Set-Reset Flip-Flop | R2023a+ | Implement an SR flip-flop with set and reset inputs — use for latching fault conditions, hold logic, or memory elements in protection schemes |
| Signal Sample and Hold | ee_sl_lib/General Control/Signal Sample and Hold | R2023a+ | Sample a signal on trigger and hold until next trigger — use for synchronized measurement capture, ADC modeling, or PWM duty cycle latching |
| Sine Wave Generator (Three-Phase) | ee_sl_lib/General Control/Sine Wave Generator (Three-Phase) | R2023a+ | Generate balanced three-phase sinusoidal reference signals — use for inverter reference generation, grid synchronization testing, or AC source emulation |
| Sliding Mode Controller | ee_sl_lib/General Control/Sliding Mode Controller | R2023a+ | Implement a sliding mode controller for robust regulation — use for variable structure control of converters or drives under parameter uncertainty |
| Smith Predictor Controller | ee_sl_lib/General Control/Smith Predictor Controller | R2023a+ | Implement a Smith predictor for processes with significant time delay — use for dead-time compensation in slow electrical or thermal control loops |
| Stair Generator | ee_sl_lib/General Control/Stair Generator | R2023a+ | Generate a staircase reference signal with programmable step timing — use for step-response testing, sweep characterization, or graduated load profiles |
| State-Feedback Controller | ee_sl_lib/General Control/State-Feedback Controller | R2023a+ | Implement a full-state feedback controller — use for multivariable regulation of motor drives, converters, or coupled electrical systems |
| Variable-Frequency Second-Order Filter | ee_sl_lib/General Control/Variable-Frequency Second-Order Filter | R2023a+ | Implement a second-order filter whose center frequency tracks an external signal — use for adaptive filtering that follows varying grid or machine frequency |
| Washout (Discrete or Continuous) | ee_sl_lib/General Control/Washout (Discrete or Continuous) | R2023a+ | Implement a washout high-pass filter — use for removing DC offsets in power system stabilizers or extracting transient components from signals |
| DC Current Controller | ee_sl_lib/General Machine Control/DC Current Controller | R2023a+ | Regulate DC current in a converter or motor drive — use for inner current loops in DC motor drives or battery charging controllers |
| DC Voltage Controller | ee_sl_lib/General Machine Control/DC Voltage Controller | R2023a+ | Regulate DC bus voltage via converter control — use for DC link voltage regulation in inverter systems or DC-DC converter output control |
| Hysteresis Current Controller (Three-Phase) | ee_sl_lib/General Machine Control/Hysteresis Current Controller (Three-Phase) | R2023a+ | Control three-phase currents using hysteresis band switching — use for simple high-bandwidth current control in motor drives or active filters |
| Velocity Controller | ee_sl_lib/General Machine Control/Velocity Controller | R2023a+ | Regulate rotational speed of an electric machine — use as the outer speed loop in cascaded motor drive control with inner current loop |
| Induction Machine Current Controller | ee_sl_lib/Induction Machine Control/Induction Machine Current Controller | R2023a+ | Regulate stator current of an induction machine in rotating frame — use for inner current loop in indirect or direct vector control of induction drives |
| Induction Machine Direct Torque Control | ee_sl_lib/Induction Machine Control/Induction Machine Direct Torque Control | R2023a+ | Implement direct torque control for a three-phase induction machine — use for high-dynamic torque regulation without a rotor position sensor |
| Induction Machine Direct Torque Control (Single-Phase) | ee_sl_lib/Induction Machine Control/Induction Machine Direct Torque Control (Single-Phase) | R2023a+ | Implement DTC for a single-phase induction machine — use for torque control of single-phase motors in appliance or pump applications |
| Induction Machine Direct Torque Control with Space Vector Modulator | ee_sl_lib/Induction Machine Control/Induction Machine Direct Torque Control with Space Vector Modulator | R2023a+ | Implement DTC with SVM for an induction machine — use for constant switching frequency DTC with reduced torque ripple |
| Induction Machine Field-Oriented Control | ee_sl_lib/Induction Machine Control/Induction Machine Field-Oriented Control | R2023a+ | Implement field-oriented control for a three-phase induction machine — use for high-performance speed and torque regulation in industrial drives |
| Induction Machine Field-Oriented Control (Single-Phase) | ee_sl_lib/Induction Machine Control/Induction Machine Field-Oriented Control (Single-Phase) | R2023a+ | Implement FOC for a single-phase induction machine — use for variable-speed control of single-phase induction motors |
| Induction Machine Scalar Control | ee_sl_lib/Induction Machine Control/Induction Machine Scalar Control | R2023a+ | Implement V/f scalar control for an induction machine — use for simple open-loop speed control in pumps, fans, or conveyors |
| PMSM Current Controller | ee_sl_lib/PMSM Control/PMSM Current Controller | R2023a+ | Regulate d-axis and q-axis stator currents of a PMSM — use as the inner current loop in field-oriented PMSM drives for torque control |
| PMSM Current Controller with Pre-Control | ee_sl_lib/PMSM Control/PMSM Current Controller with Pre-Control | R2023a+ | Regulate PMSM dq currents with feedforward decoupling — use for improved dynamic response by compensating cross-coupling and back-EMF terms |
| PMSM Current Reference Generator | ee_sl_lib/PMSM Control/PMSM Current Reference Generator | R2023a+ | Generate optimal d-q current references for a PMSM — use for maximum-torque-per-ampere operation or field-weakening trajectory generation |
| PMSM Field-Oriented Control | ee_sl_lib/PMSM Control/PMSM Field-Oriented Control | R2023a+ | Implement complete field-oriented control for a PMSM — use as a ready-to-use FOC controller with speed loop, current loop, and coordinate transforms |
| PMSM Field-Weakening Controller | ee_sl_lib/PMSM Control/PMSM Field-Weakening Controller | R2023a+ | Extend PMSM operation above base speed by injecting negative d-axis current — use for EV traction drives or spindle motors requiring wide speed range |
| PMSM Torque Estimator | ee_sl_lib/PMSM Control/PMSM Torque Estimator | R2023a+ | Estimate electromagnetic torque of a PMSM from measured currents and flux parameters — use for torque monitoring, sensorless control, or efficiency estimation |
| d-q Voltage Limiter | ee_sl_lib/Protection/d-q Voltage Limiter | R2023a+ | Limit d-q voltage commands to stay within the inverter voltage hexagon — use to prevent overmodulation and maintain linear control of AC machine drives |
| Impedance Scan (Three-Phase) | ee_sl_lib/Renewables Control/Impedance Scan (Three-Phase) | R2026a+ | Perform frequency-domain impedance measurement on a three-phase system — use for stability analysis of grid-connected converters or impedance-based design |
| Solar PV Controller (Three-Phase) | ee_sl_lib/Renewables Control/Solar PV Controller (Three-Phase) | R2024a+ | Control a three-phase grid-connected PV inverter with MPPT — use for solar energy conversion with maximum power tracking and grid synchronization |
| SM AC10C | ee_sl_lib/SM Control/SM AC10C | R2023a+ | Implement IEEE AC10C excitation system model for synchronous machines — use for generator voltage regulation in power system stability studies |
| SM AC11C | ee_sl_lib/SM Control/SM AC11C | R2023a+ | Implement IEEE AC11C excitation system model — use for detailed exciter modeling in power system transient stability |
| SM AC1C | ee_sl_lib/SM Control/SM AC1C | R2023a+ | Implement IEEE AC1C excitation system model — use for thyristor-based exciter regulation in stability studies |
| SM AC2C | ee_sl_lib/SM Control/SM AC2C | R2023a+ | Implement IEEE AC2C excitation system model — use for high-initial-response excitation in stability studies |
| SM AC3C | ee_sl_lib/SM Control/SM AC3C | R2023a+ | Implement IEEE AC3C excitation system model — use for self-excited alternator-rectifier excitation in stability |
| SM AC4C | ee_sl_lib/SM Control/SM AC4C | R2023a+ | Implement IEEE AC4C excitation system model — use for alternator-supplied controlled-rectifier excitation |
| SM AC5C | ee_sl_lib/SM Control/SM AC5C | R2023a+ | Implement IEEE AC5C excitation system model — use for brushless excitation systems in stability studies |
| SM AC6C | ee_sl_lib/SM Control/SM AC6C | R2023a+ | Implement IEEE AC6C excitation system model — use for alternator-rectifier excitation with non-controlled rectifier |
| SM AC7C | ee_sl_lib/SM Control/SM AC7C | R2023a+ | Implement IEEE AC7C excitation system model — use for high-performance excitation with inner-loop regulation |
| SM AC8C | ee_sl_lib/SM Control/SM AC8C | R2023a+ | Implement IEEE AC8C excitation system model — use for alternator-rectifier excitation with PID voltage regulation |
| SM AC9C | ee_sl_lib/SM Control/SM AC9C | R2023a+ | Implement IEEE AC9C excitation system model — use for advanced excitation systems in stability simulations |
| SM Current Controller | ee_sl_lib/SM Control/SM Current Controller | R2023a+ | Regulate field current of a synchronous machine — use for direct field current control in excitation system implementations |
| SM Current Reference Generator | ee_sl_lib/SM Control/SM Current Reference Generator | R2023a+ | Generate current references for synchronous machine field-oriented control — use for torque and flux reference generation in SM drives |
| SM DC1C | ee_sl_lib/SM Control/SM DC1C | R2023a+ | Implement IEEE DC1C excitation system model — use for DC commutator exciter representation in stability studies |
| SM DC2C | ee_sl_lib/SM Control/SM DC2C | R2023a+ | Implement IEEE DC2C excitation system model — use for DC exciter with stabilizing feedback in stability studies |
| SM DC4C | ee_sl_lib/SM Control/SM DC4C | R2023a+ | Implement IEEE DC4C excitation system model — use for DC exciter without stabilizer in simplified stability studies |
| SM Field-Oriented Control | ee_sl_lib/SM Control/SM Field-Oriented Control | R2023a+ | Implement field-oriented control for a wound-field synchronous machine — use for high-performance SM drives with decoupled torque and flux control |
| SM Governor with Droop | ee_sl_lib/SM Control/SM Governor with Droop | R2023a+ | Implement a governor with droop characteristic for prime mover control — use for generator frequency regulation and load sharing in multi-machine systems |
| SM PSS1A | ee_sl_lib/SM Control/SM PSS1A | R2023a+ | Implement IEEE PSS1A power system stabilizer — use for damping low-frequency oscillations in synchronous generators via excitation modulation |
| SM PSS2C | ee_sl_lib/SM Control/SM PSS2C | R2023a+ | Implement IEEE PSS2C dual-input power system stabilizer — use for enhanced damping with both speed and power inputs |
| SM PSS7C | ee_sl_lib/SM Control/SM PSS7C | R2023a+ | Implement IEEE PSS7C power system stabilizer — use for advanced stabilizer designs in modern generator excitation systems |
| SM ST10C | ee_sl_lib/SM Control/SM ST10C | R2023a+ | Implement IEEE ST10C static excitation system model — use for solid-state excitation with high-bandwidth regulation |
| SM ST1C | ee_sl_lib/SM Control/SM ST1C | R2023a+ | Implement IEEE ST1C static excitation system model — use for potential-source controlled-rectifier excitation in stability |
| SM ST2C | ee_sl_lib/SM Control/SM ST2C | R2023a+ | Implement IEEE ST2C static excitation system model — use for compound-source rectifier excitation |
| SM ST3C | ee_sl_lib/SM Control/SM ST3C | R2023a+ | Implement IEEE ST3C static excitation system model — use for potential or compound source excitation with PI regulation |
| SM ST4C | ee_sl_lib/SM Control/SM ST4C | R2023a+ | Implement IEEE ST4C static excitation system model — use for compound-source excitation with inner voltage regulation loop |
| SM ST5C | ee_sl_lib/SM Control/SM ST5C | R2023a+ | Implement IEEE ST5C static excitation system model — use for potential-source excitation with rate feedback stabilization |
| SM ST6C | ee_sl_lib/SM Control/SM ST6C | R2023a+ | Implement IEEE ST6C static excitation system model — use for field-controlled alternator-rectifier excitation |
| SM ST7C | ee_sl_lib/SM Control/SM ST7C | R2023a+ | Implement IEEE ST7C static excitation system model — use for thyristor-bridge excitation with high ceiling voltage |
| SM ST8C | ee_sl_lib/SM Control/SM ST8C | R2023a+ | Implement IEEE ST8C static excitation system model — use for static excitation fed from machine terminals with power system stabilizer |
| SM ST9C | ee_sl_lib/SM Control/SM ST9C | R2023a+ | Implement IEEE ST9C static excitation system model — use for bus-fed static excitation in stability studies |
| SRM Commutation Logic | ee_sl_lib/SRM Control/SRM Commutation Logic | R2023a+ | Generate phase excitation signals for a switched reluctance machine based on rotor position — use for basic angle-controlled SRM commutation |
| SRM Current Controller | ee_sl_lib/SRM Control/SRM Current Controller | R2023a+ | Regulate phase current of a switched reluctance machine — use for torque control via current profiling in SRM drives |
| SRM Current Controller with PWM Generation | ee_sl_lib/SRM Control/SRM Current Controller with PWM Generation | R2023a+ | Regulate SRM phase current and generate PWM switching signals — use as a complete current-loop controller with integrated PWM for SRM drives |
| SRM Hysteresis Current Controller | ee_sl_lib/SRM Control/SRM Hysteresis Current Controller | R2023a+ | Control SRM phase current using hysteresis band switching — use for simple high-bandwidth current regulation in switched reluctance drives |
| Controller LCFB1 | ee_sl_lib/Turbine-Governors/Controller LCFB1 | R2023a+ | Implement a load controller with frequency bias for generator governing — use for automatic generation control or load-frequency regulation |
| Governor Type 1 | ee_sl_lib/Turbine-Governors/Governor Type 1 | R2023a+ | Implement a Type 1 turbine governor model — use for steam or gas turbine speed regulation in power system stability studies |
| Governor Type 3 | ee_sl_lib/Turbine-Governors/Governor Type 3 | R2023a+ | Implement a Type 3 turbine governor model — use for diesel engine or gas turbine governing with detailed fuel system dynamics |
