---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 21
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Idealized baseband amplifier with gain, noise figure, and nonlinearity — use for system-level RF gain stages without full circuit detail. | Amplifier | RF Blockset |
| Idealized baseband filter (lowpass, highpass, bandpass) — use to shape the spectrum of a baseband RF signal at system level. | Filter | RF Blockset |
| Idealized baseband mixer that frequency-translates a signal — use to model up- or down-conversion in an RF chain. | Mixer | RF Blockset |
| Idealized baseband power amplifier with nonlinearity and memory effects — use to model PA distortion (AM/AM, AM/PM) at system level. | Power Amplifier | RF Blockset |
| Display the frequency spectrum of a circuit-envelope RF signal during simulation — use to inspect power, harmonics, and spurious content. | Spectrum Analyzer | RF Blockset |
| Idealized baseband amplifier with gain, noise figure, and nonlinearity — use for system-level RF gain stages without full circuit detail. | Amplifier | RF Blockset |
| Idealized baseband filter (lowpass, highpass, bandpass) — use to shape the spectrum of a baseband RF signal at system level. | Filter | RF Blockset |
| Idealized baseband mixer that frequency-translates a signal — use to model up- or down-conversion in an RF chain. | Mixer | RF Blockset |
| Idealized baseband power amplifier with nonlinearity and memory effects — use to model PA distortion (AM/AM, AM/PM) at system level. | Power Amplifier | RF Blockset |
| Model a component from its S-parameter data in idealized baseband — use to insert measured or simulated frequency-domain behavior into an RF chain. | Sparameters | RF Blockset |
| Model antenna and antenna arrays accounting for incident power wave (RX) and radiated power wave (TX). | Antenna | RF Blockset |
| Model an attenuator | Attenuator | RF Blockset |
| Model a linear capacitor. | C | RF Blockset |
| Mixer model using an Intermodulation Table (IMT) | IMT Mixer | RF Blockset |
| Model ideal transformer | Ideal Transformer | RF Blockset |
| RF amplifier described by a data source that consists of either an RFDATA object or data from a file. When there is no noise data in the data source, use the Noise Data tab to specify amplifier noise information. For a frequency-dependent noise, the Noise Data tab accepts a separate N-element vector of the corresponding frequency values. When there is no nonlinearity data in the data source, use the Nonlinearity Data tab to specify amplifier nonlinearity information. For a frequency-dependent nonlinearity, the Nonlinearity Data tab accepts a separate N-element vector of the corresponding frequency values. When the data source contains operating condition information, use the Operating Conditions tab to select operating condition settings for the simulation. Data interpolation is used during simulation. | General Amplifier | RF Blockset |
| RF amplifier described by frequency-dependent S-Parameters, noise data, and nonlinearity data. Use the Main tab to specify a 2x2xM array of S-Parameters, an M-element vector of the corresponding frequency values and a scalar or M-element vector of the corresponding reference impedance values. Use the Noise Data tab to specify amplifier noise information. For a frequency-dependent noise, the Noise Data tab accepts a separate N-element vector of the corresponding frequency values. Use the Nonlinearity Data tab to specify amplifier nonlinearity information. For a frequency-dependent nonlinearity, the Nonlinearity Data tab accepts a separate N-element vector of the corresponding frequency values. Data interpolation is used during simulation. | S-Parameters Amplifier | RF Blockset |
| RF amplifier described by frequency-dependent Y-Parameters, noise data, and nonlinearity data. Use the Main tab to specify a 2x2xM array of Y-Parameters and an M-element vector of the corresponding frequency values. Use the Noise Data tab to specify amplifier noise information. For a frequency-dependent noise, the Noise Data tab accepts a separate N-element vector of the corresponding frequency values. Use the Nonlinearity Data tab to specify amplifier nonlinearity information. For a frequency-dependent nonlinearity, the Nonlinearity Data tab accepts a separate N-element vector of the corresponding frequency values. Data interpolation is used during simulation. | Y-Parameters Amplifier | RF Blockset |
| RF amplifier described by frequency-dependent Z-Parameters, noise data, and nonlinearity data. Use the Main tab to specify a 2x2xM array of Z-Parameters and an M-element vector of the corresponding frequency values. Use the Noise Data tab to specify amplifier noise information. For a frequency-dependent noise, the Noise Data tab accepts a separate N-element vector of the corresponding frequency values. Use the Nonlinearity Data tab to specify amplifier nonlinearity information. For a frequency-dependent nonlinearity, the Nonlinearity Data tab accepts a separate N-element vector of the corresponding frequency values. Data interpolation is used during simulation. | Z-Parameters Amplifier | RF Blockset |
| Two-port passive network described by an RFDATA object or data from a file. Data interpolation is used during simulation. | General Passive Network | RF Blockset |
| Compute RF budget results for A chain of 2-port elements. | RF Budget | RF Blockset |
