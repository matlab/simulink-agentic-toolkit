# Application Catalog

> Maps application intent to architecture. The agent selects a base pattern + features
> from this catalog, then builds the model using `wiring-topologies.md` + `block-configurations.md`
> + `composition-rules.md`. Agent composes via `model_edit` — no scripts needed.

---

## How to Use This Catalog

1. User describes their application or motor control need
2. Search this table by keywords (application, motor type, feature)
3. Identify the **Base Pattern** (A-H) and **Features** (+FW, +SMO, etc.)
4. Build the model:
   - Start with the base pattern from `wiring-topologies.md`
   - Add each feature per `composition-rules.md`
   - Configure blocks per `block-configurations.md`
   - Compute parameters per `parameter-computation.md`
   - Verify constraints per `critical-constraints.md`

---

## Catalog Table

| Application | Keywords | Pattern | Features | Motor | Load Model |
|------------|----------|---------|----------|-------|------------|
| **Basic FOC (SI units)** | speed control, foc, si, basic, starter, beginner | A | — | IPMSM | Step |
| **Basic FOC (PU units)** | speed control, foc, pu, per-unit, normalized | A | — | IPMSM | Step |
| **Basic FOC (FOC CC block)** | speed control, foc cc, official pattern | B | — | IPMSM | Step |
| **MTPA FOC (SI, high-level)** | mtpa, control reference, si, optimal torque | B | +MTPA | IPMSM | Step |
| **Torque-only FOC** | torque control, no speed loop, direct torque command | C | — | IPMSM | Step |
| **Field Weakening (voltage feedback)** | field weakening, fwc, above base speed, cpsr | A | +FW | IPMSM | Step |
| **Field Weakening (LUT-based)** | field weakening, lut, pre-computed, fem data, nonlinear | A | +FW(LUT) | IPMSM | Step |
| **Deep Field Weakening** | deep fw, extended speed, voltage limited | A | +FW+OVM | IPMSM | Step |
| **Overmodulation** | overmodulation, ovm, hexagon boundary, six-step transition | B | +OVM | IPMSM | Step |
| **Position Control** | position, servo, cascaded, p-pi-pi, robot, cnc | D | +FF | IPMSM | Step |
| **S-Curve Position** | s-curve, jerk-limited, motion profile, trajectory | D | +FF+SCurve | IPMSM | Step |
| **Valve Position** | valve, fast positioning, downhole, 4-quadrant | D | — | SPMSM | Step |
| **Crane Hoist** | crane, hoist, lifting, gravitational, resolver | D | — | IPMSM | Gravitational |
| **Elevator Door** | elevator door, soft motion, smooth | D | +SCurve | IPMSM | Friction |
| **Elevator Traction** | elevator, traction, vertical transport, high inertia | D | +SCurve | IPMSM | Gravitational |
| **Sensorless FOC (SMO)** | sensorless, smo, sliding mode observer, encoder-free | A | +SMO+IF | IPMSM | Step |
| **Sensorless FOC (SMO, PU)** | sensorless, smo, pu, per-unit, encoder-free | A | +SMO+IF | IPMSM | Step |
| **Sensorless FOC (EEMF)** | sensorless, eemf, extended emf observer | A | +EEMF+IF | IPMSM | Step |
| **Sensorless FOC (Flux Observer)** | sensorless, flux observer, encoder-free | A | +FluxObs+IF | IPMSM | Step |
| **I/f Startup + SMO** | i/f startup, open-loop, smo, handoff | A | +SMO+IF(manual) | SPMSM | Step |
| **I-F Controller + SMO** | i-f controller, mcb, smo, smooth startup | A | +SMO+IF(block) | IPMSM | Step |
| **I-F Controller + EEMF** | i-f controller, eemf, sensorless | A | +EEMF+IF(block) | IPMSM | Step |
| **I/f + Flux Observer** | i/f startup, flux observer, sensorless | A | +FluxObs+IF | IPMSM | Step |
| **HFI Startup** | hfi, high-frequency injection, standstill | A | +HFI+IF | IPMSM | Step |
| **Hybrid HFI+SMO** | hfi, smo, hybrid, full speed range | A | +HFI+SMO+IF | IPMSM | Step |
| **Gain Scheduling (Nonlinear)** | gain scheduling, nonlinear, lut gains, fem | A | +GainSched | IPMSM(FEM) | Step |
| **Gain Scheduling (Temperature)** | temperature, gain scheduling, thermal | A | +GainSched(Temp) | IPMSM | Step |
| **FeedForward + PWM RefGen** | feedforward, pwm, svm, decoupling | A | +FF+PWM | IPMSM | Step |
| **Drone/Propeller** | drone, propeller, quadratic load, high speed | A | +FF+PWM | SPMSM | Quadratic |
| **Multi-Rotor Mixing** | multirotor, drone, mixing matrix | A | +FF+PWM | SPMSM | Quadratic |
| **Fixed Wing Prop** | fixed wing, propeller, cruise | A | +FF | SPMSM | Quadratic |
| **eVTOL Tiltrotor** | evtol, tiltrotor, transition, high speed | A | +FF+FW | IPMSM | Quadratic |
| **E-Bike Hub Motor** | e-bike, hub motor, pedal assist | A | — | IPMSM | Step |
| **Consumer E-Bike** | consumer, e-bike, hill climb, comfort | A | — | IPMSM | Variable Step |
| **Cordless Drill** | drill, cordless, power tool, high torque | A | — | IPMSM | Step |
| **Consumer Power Tool** | power tool, high speed, consumer | A | +FW | IPMSM | Step |
| **AGV Wheel** | agv, wheel, mobile robot, bidirectional | A | — | IPMSM | Friction |
| **Robot AGV Wheel** | robot, agv, mobile, wheel | A | — | IPMSM | Friction |
| **EV Traction** | ev, traction, electric vehicle, high power | A | +FW | IPMSM | Variable Step |
| **EV Cruise Control** | ev, cruise control, highway | A | +FW | IPMSM | Quadratic |
| **EV Drive Cycle** | ev, drive cycle, wltp, nedc | A | +FW | IPMSM | Profile |
| **EV Throttle Mode** | ev, throttle, acceleration modes | A | +FW | IPMSM | Quadratic |
| **EV Traction Control** | traction control, slip detection, anti-slip | A | +SlipDetect | IPMSM | Variable Step |
| **Train Traction** | train, traction, railway, high power | A | +FW | IPMSM | Quadratic |
| **EPS Steering** | eps, steering, torque assist, automotive | C | — | IPMSM | Friction |
| **Gimbal Stabilization** | gimbal, camera, stabilization, low speed | D | — | SPMSM | Friction |
| **Robot Joint Position** | robot, joint, servo, high precision | D | +FF | IPMSM | Step |
| **Robot Impedance** | robot, impedance control, compliance | C(+impedance) | +FF | IPMSM | Step |
| **Robot Haptic** | haptic, force feedback, torque rendering | C | — | SPMSM | Step |
| **Cobot Torque** | cobot, collaborative, torque control | C | +FF | IPMSM | Step |
| **Exoskeleton Joint** | exoskeleton, joint, assist, complete | D | +FF+FW | IPMSM | Gravitational |
| **CNC Spindle** | cnc, spindle, high speed, precision | A | +FW+FF | IPMSM | Step |
| **Industrial Spindle** | industrial, spindle, machining | A | +FW+FF | IPMSM | Step |
| **Textile Spindle** | textile, spindle, constant tension | A | — | IPMSM | Linear |
| **Industrial Conveyor** | conveyor, belt, transport, constant speed | A | — | IPMSM | Friction |
| **Mining Conveyor** | mining, conveyor, heavy load, high inertia | A | — | IPMSM | Friction |
| **Conveyor Reversal** | conveyor, reversal, bidirectional, sorting | A | — | IPMSM | Friction |
| **Steel Rolling Mill** | steel, rolling mill, high torque, reversing | A | +FW | IPMSM | Step |
| **Paper Winder** | paper, winder, tension control, diameter | A(+tension) | — | IPMSM | Linear |
| **Tension Control** | tension, winding, unwinding, web | A(+tension) | — | IPMSM | Linear |
| **HVAC Compressor** | hvac, compressor, scroll, variable speed | A | — | IPMSM | Periodic |
| **Consumer HVAC Blower** | hvac, blower, fan, consumer | A | — | IPMSM | Quadratic |
| **Scroll Compressor** | scroll, compressor, refrigeration | A | — | IPMSM | Periodic |
| **Ceiling Fan (BLDC)** | ceiling fan, bldc, low cost | F | — | BLDC | Quadratic |
| **Consumer Ceiling Fan** | ceiling fan, consumer, silent | F | — | BLDC | Quadratic |
| **Centrifuge** | centrifuge, high speed, deceleration | A | +FW | IPMSM | Quadratic |
| **Washing Machine (Direct Drive)** | washer, direct drive, variable speed, reversal | A | — | IPMSM | Periodic |
| **Consumer Washing Machine** | washing machine, consumer, drum | A | — | IPMSM | Periodic |
| **Generator (PMSG)** | generator, pmsg, braking, negative iq | A(gen) | — | SPMSM | Constant |
| **Wind Turbine PMSG** | wind turbine, pmsg, mppt, renewable | A(gen) | +MPPT | SPMSM | Quadratic |
| **Generator Diesel Genset** | genset, diesel, generator, constant freq | A(gen) | +Governor | IPMSM | Step |
| **Genset Speed Regulation** | genset, speed regulation, droop, frequency | A(gen) | +Droop | IPMSM | Step |
| **Generator Regen Brake** | regenerative braking, generator mode | A(gen) | +FW | IPMSM | Step |
| **Ship Propulsion** | ship, marine, propulsion, high torque | A | +FW | IPMSM | Quadratic |
| **ESP Sensorless** | esp, submersible pump, linear load | A | +SMO | SPMSM | Linear |
| **ESP Long Cable V/f** | esp, long cable, v/f startup, submersible | E(→A) | +VfStartup | SPMSM | Linear |
| **Downhole Adaptive** | downhole, adaptive, oil and gas | A | +Adaptive | IPMSM | Variable |
| **Top Drive Stick-Slip** | top drive, stick-slip, drilling | A | +Vibration | IPMSM | Periodic |
| **Pumpjack Cyclic Load** | pumpjack, cyclic, oil pump | A | — | IPMSM | Periodic |
| **Industrial Pump V/f** | pump, v/f, open loop, simple | E | — | ACIM | Quadratic |
| **Pump V/f Energy Opt** | pump, energy optimization, v/f | E | +EnergyOpt | ACIM | Quadratic |
| **Ultra-High Speed (>50k RPM)** | ultra high speed, surgical, dental, turbo | A | +FW+MultiRate | SPMSM | Quadratic |
| **Surgical Tool UHF** | surgical, ultra high frequency, dental | A | +FW | SPMSM | Quadratic |
| **Ultra-Low Power** | micro motor, mw-scale, insulin pump, mems | C | — | SPMSM | Constant |
| **High Accel Servo** | high acceleration, fast servo, pick-place | D | +FF | IPMSM | Step |
| **DTC (Direct Torque Control)** | dtc, direct torque, flux control, hysteresis | H | — | IPMSM | Step |
| **BLDC Hall Six-Step** | bldc, hall sensor, six step, trapezoidal | F | — | BLDC | Constant |
| **BLDC Sensorless Six-Step** | bldc, sensorless, bemf zero crossing | F | +BEMF | BLDC | Constant |
| **BEMF Zero Crossing BLDC** | bemf, zero crossing, sensorless bldc | F | +BEMF | BLDC | Constant |
| **ACIM RFOC** | acim, induction motor, rfoc, indirect | A(ACIM) | — | ACIM | Step |
| **ACIM Sensorless RFOC** | acim, sensorless, mras, induction | A(ACIM) | +MRAS | ACIM | Step |
| **ACIM Simscape RFOC** | acim, simscape, high fidelity, induction | G(ACIM) | — | ACIM | Step |
| **ACIM V/f Open-Loop** | acim, v/f, open loop, induction, simple | E | — | ACIM | Quadratic |
| **Washer IM FOC** | washing machine, induction, acim | A(ACIM) | — | ACIM | Periodic |
| **SynRM FOC** | synrm, synchronous reluctance, no magnets | A | — | SynRM | Step |
| **EESM FOC** | eesm, wound field, excitation control | A(EESM) | +Excitation | EESM | Step |
| **DPWM Efficiency** | dpwm, discontinuous pwm, efficiency, switching loss | B | +DPWM | IPMSM | Step |
| **Acoustic Noise Shaping PWM** | acoustic, noise shaping, spread spectrum, pwm | A | +NoiseShape | IPMSM | Step |
| **Dead-Time Compensation** | dead time, compensation, distortion | A | +DeadtimeComp | IPMSM | Step |
| **DC Bus Precharge** | dc bus, precharge, soft start, inrush | A | +Precharge | IPMSM | Step |
| **Cogging Torque Compensation** | cogging, torque compensation, smoothness | A | +CoggingComp | IPMSM | Step |
| **Torque Ripple Minimization** | torque ripple, minimization, harmonic | A | +TorqueRipple | IPMSM | Step |
| **Vibration Suppression** | vibration, suppression, notch filter, resonance | A | +VibSuppress | IPMSM | Periodic |
| **Repetitive Control** | repetitive, periodic disturbance, harmonic | A | +Repetitive | IPMSM | Periodic |
| **Disturbance Observer** | disturbance observer, dob, rejection | A | +DOB | IPMSM | Step |
| **Sliding Mode Speed** | sliding mode, robust speed control | A(SMC) | — | IPMSM | Step |
| **Backstepping Speed** | backstepping, nonlinear, lyapunov | A(Backstep) | — | IPMSM | Step |
| **ADRC Speed** | adrc, active disturbance rejection | A(ADRC) | — | IPMSM | Step |
| **Deadbeat Current** | deadbeat, predictive current, one-step | A(Deadbeat) | — | IPMSM | Step |
| **Predictive Current** | predictive, mpc, model predictive, current | A(Predictive) | — | IPMSM | Step |
| **Resonant Current** | resonant, pr controller, harmonic current | A(Resonant) | — | IPMSM | Periodic |
| **Autotuner** | autotuner, auto-tune, adaptive pi | A | +Autotuner | IPMSM | Step |
| **Parameter Estimation** | parameter estimation, online, automated | A | +ParamEst | IPMSM | Step |
| **Inertia Estimation** | inertia, estimation, commissioning | A | +InertiaEst | IPMSM | Step |
| **Dual Motor Sync** | dual motor, synchronization, parallel | A×2 | — | IPMSM | Step |
| **Dual Motor Torque Vector** | dual motor, torque vectoring, ev, differential | A×2 | +TorqueVector | IPMSM | Step |
| **Dual Observer** | dual observer, redundancy, fault tolerant | A | +DualObs | IPMSM | Step |
| **Fault Tolerant** | fault tolerant, open phase, degraded mode | A | +FaultTolerant | IPMSM | Step |
| **Open Phase Fault** | open phase, fault, single phase, limp mode | A | +OpenPhase | IPMSM | Step |
| **Active Short Circuit** | active short circuit, safety, fault mitigation | A | +ASC | IPMSM | Step |
| **Protection Relay** | protection, overcurrent, relay, fault detect | A | +Protection | IPMSM | Step |
| **Thermal Derating** | thermal, derating, temperature limit | A | +ThermalDerate | IPMSM | Step |
| **Robust Derating** | robust, derating, conservative, safety | A | +Derating | IPMSM | Step |
| **Robust Anti-Stall** | anti-stall, stall protection, overload | A | +AntiStall | IPMSM | Step |
| **Regen Braking** | regenerative, braking, energy recovery | A | +RegenBrake | IPMSM | Step |
| **Regen Voltage Clamp** | regen, voltage clamp, bus overvoltage | A | +VoltageClamp | IPMSM | Step |
| **Variable Vdc** | variable dc bus, battery sag, wide input | A | +VarVdc | IPMSM | Step |
| **Sensorless Vdc/Temp** | sensorless, vdc compensation, temperature | A | +SMO+VdcComp | IPMSM | Step |
| **DQ Limiter** | dq limiter, voltage limit, current limit circle | A | +DQLimiter | IPMSM | Step |
| **Torque Estimator** | torque estimation, observer, sensorless torque | A | +TorqueEst | IPMSM | Step |
| **Quadrature Encoder** | encoder, quadrature, incremental, index | A | +Encoder | IPMSM | Step |
| **Resolver SPMSM** | resolver, spmsm, rdc, analog sensor | A | +Resolver | SPMSM | Step |
| **PLL Grid Sync** | pll, grid sync, grid-tied, inverter | A(Grid) | +PLL | IPMSM | Step |
| **Dyno Test Bench** | dynamometer, test bench, torque control | A(Dyno) | — | IPMSM | Step |
| **Dyno Road Load** | dyno, road load simulation, drive cycle | A(Dyno) | +RoadLoad | IPMSM | Profile |
| **Dyno Drive Cycle Playback** | dyno, drive cycle, playback, wltp | A(Dyno) | +DriveProfile | IPMSM | Profile |
| **Dyno Virtual Inertia** | dyno, virtual inertia, emulation | A(Dyno) | +VirtualInertia | IPMSM | Step |
| **Escalator** | escalator, constant speed, conveyor | A | — | IPMSM | Gravitational |
| **Industrial Extruder** | extruder, constant torque, plastic | A | — | IPMSM | Constant |
| **Position Generator** | position, generator, encoding | D(gen) | — | IPMSM | Step |

---

## Pattern Key

| Pattern | Description | See |
|---------|------------|-----|
| A | Manual PI current loop (speed FOC) | `wiring-topologies.md` § Pattern A |
| A(ACIM) | Pattern A adapted for ACIM (slip calc, sigma tuning) | `wiring-topologies.md` § Pattern A + ACIM notes |
| A(gen) | Pattern A in generator mode (negative iq, braking) | Same topology, reversed torque sign |
| A(SMC/Backstep/ADRC/Deadbeat) | Pattern A with non-PI speed/current controller | Unique controller, same plant+sensor path |
| B | FOC CC block current loop | `wiring-topologies.md` § Pattern B |
| C | Torque-only (no speed loop) | `wiring-topologies.md` § Pattern C |
| D | Position control (cascaded P-PI-PI) | `wiring-topologies.md` § Pattern D |
| E | V/f open-loop | `wiring-topologies.md` § Pattern E |
| F | BLDC six-step Hall commutation | `wiring-topologies.md` § Pattern F |
| G | Simscape electrical plant | `wiring-topologies.md` § Pattern G |
| H | Direct Torque Control | `wiring-topologies.md` § Pattern H |
| A×2 | Two parallel Pattern A chains | Duplicate topology, shared reference |

## Feature Key

| Feature | Description | See |
|---------|------------|-----|
| +FW | Field weakening (voltage feedback PI) | `composition-rules.md` § Field Weakening |
| +FW(LUT) | Field weakening via LUT Control Reference | `composition-rules.md` § FW Option B |
| +OVM | Overmodulation (extends voltage) | `composition-rules-infrastructure.md` § PWM Strategy |
| +SMO | Sliding Mode Observer sensorless | `composition-rules.md` § Sensorless (SMO) |
| +EEMF | Extended EMF observer sensorless | Similar to SMO, different observer |
| +FluxObs | MCB Flux Observer sensorless | Similar to SMO, different observer |
| +MRAS | Model Reference Adaptive System (ACIM) | ACIM-specific sensorless |
| +HFI | High-Frequency Injection (standstill) | `composition-rules.md` § HFI + SMO |
| +IF | I/f startup (MCB I-F Controller block) | `composition-rules.md` § I/f Startup |
| +IF(manual) | Manual I/f frequency ramp | `composition-rules.md` § I/f Startup Option B |
| +FF | FeedForward decoupling | `composition-rules.md` § FeedForward |
| +GainSched | LUT-based PI gain scheduling | `composition-rules.md` § Gain Scheduling |
| +PWM | PWM Reference Generator (SVM/DPWM) | `composition-rules-infrastructure.md` § PWM Strategy |
| +DPWM | Discontinuous PWM mode | `composition-rules-infrastructure.md` § PWM Strategy |
| +SCurve | S-curve motion profile | `composition-rules-integration.md` § Custom Speed Profile |
| +Protection | Overcurrent/fault protection layer | `composition-rules-infrastructure.md` § Protection |
| +MultiRate | Explicit multi-rate with Rate Transitions | `composition-rules-infrastructure.md` § Multi-Rate |
| +DOB | Disturbance observer | Parallel observer, adds compensation |
| +ThermalDerate | Temperature-based current derating | Gain block on I_max |
| +SlipDetect | Traction slip detection + torque limiting | Compare speed diff, switch torque |
| +Precharge | DC bus soft-start sequence | Ramp Vdc reference |
| +RegenBrake | Regenerative braking mode | Negative torque command logic |
| +VoltageClamp | Bus overvoltage protection | Comparator + brake resistor enable |

## Motor Type Key

| Motor | Block | Key Difference |
|-------|-------|---------------|
| IPMSM | Interior PMSM | Ld != Lq, reluctance torque, MTPA needed |
| SPMSM | Surface Mount PMSM | Ld = Lq, id_ref = 0 (no MTPA needed) |
| BLDC | BLDC | Trapezoidal back-EMF, six-step commutation |
| ACIM | Induction Machine | Slip-based control, rotor time constant |
| SynRM | Synchronous Reluctance | No magnets, Ld >> Lq, pure reluctance torque |
| EESM | Externally Excited SM | Wound field, excitation current control |

## Load Model Key

| Load | Formula | Typical Application |
|------|---------|-------------------|
| Step | TL = constant (applied at t_step) | Disturbance testing |
| Constant | TL = fixed value | Extruder, conveyor (flat) |
| Quadratic | TL = k * w^2 | Fan, pump, propeller |
| Linear | TL = k * w | Submersible pump, viscous |
| Gravitational | TL = m*g*r (direction-dependent) | Crane, elevator |
| Friction | TL = Tc*sign(w) + B*w | Conveyor, AGV |
| Periodic | TL = T_mean + T_ripple*sin(theta) | Compressor, pumpjack |
| Variable Step | TL changes at multiple times | Hill climb, load test |
| Profile | TL from timeseries (drive cycle) | EV, dyno |

----
Copyright 2026 The MathWorks, Inc.
----
