---
type: Simulink Block Category
title: Modulation
description: Analog and digital baseband modulators/demodulators
tags: [modulation, fm, apsk, ofdm, qam, psk, dbpsk]
status: stable
source: custom_library
library_root: Communications Toolbox
category_path: Modulation
block_count: 48
---

# Modulation

Use these blocks for modulation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| FM Demodulator Baseband  | commanabbnd3/FM Demodulator Baseband  | R2023a+ | Demodulate an FM baseband signal back to the message — use in analog FM receivers. |
| FM Modulator Baseband | commanabbnd3/FM Modulator Baseband | R2023a+ | Frequency-modulate a message onto a baseband carrier — use in analog FM transmitters. |
| FM Broadcast Demodulator Baseband | commanabbnd3/FM Broadcast Demodulator Baseband | R2023a+ | Demodulate a broadcast-FM (stereo/RDS-capable) baseband signal — use for FM radio receiver models. |
| FM Broadcast Modulator Baseband | commanabbnd3/FM Broadcast Modulator Baseband | R2023a+ | Modulate audio into a broadcast-FM baseband signal with stereo multiplexing — use for FM radio transmitter models. |
| DSB AM Demodulator Passband | commanapbnd3/DSB AM Demodulator Passband | R2023a+ | Demodulate a double-sideband amplitude modulated signal. The input signal must be a scalar. |
| DSB AM Modulator Passband | commanapbnd3/DSB AM Modulator Passband | R2023a+ | Modulate the input signal using the double-sideband amplitude modulation method. The input signal must be a scalar. |
| DSBSC AM Demodulator Passband | commanapbnd3/DSBSC AM Demodulator Passband | R2023a+ | Demodulate a double-sideband suppressed carrier amplitude modulated signal. The input signal must be a scalar. |
| DSBSC AM Modulator Passband | commanapbnd3/DSBSC AM Modulator Passband | R2023a+ | Modulate the input signal using the double-sideband suppressed carrier amplitude modulation method. The input signal must be a scalar. |
| FM Demodulator Passband | commanapbnd3/FM Demodulator Passband | R2023a+ | Demodulate a frequency modulated signal with a discriminator. The input signal must be a scalar. |
| FM Modulator Passband | commanapbnd3/FM Modulator Passband | R2023a+ | Modulate the input signal using the frequency modulation method. The input signal must be a scalar. |
| PM Demodulator Passband | commanapbnd3/PM Demodulator Passband | R2023a+ | Demodulate a phase modulated signal. The input signal must be a scalar. |
| PM Modulator Passband | commanapbnd3/PM Modulator Passband | R2023a+ | Modulate the input signal using the phase modulation method. The input signal must be a scalar. |
| SSB AM Demodulator Passband | commanapbnd3/SSB AM Demodulator Passband | R2023a+ | Demodulate a single-sideband amplitude modulated signal. The input signal must be a scalar. |
| SSB AM Modulator Passband | commanapbnd3/SSB AM Modulator Passband | R2023a+ | Modulate the input signal using the single-sideband amplitude modulation method with Hilbert transform filter. The input signal must be a scalar. |
| M-APSK Demodulator Baseband | commdigbbndapm/M-APSK Demodulator Baseband | R2023a+ | Demodulate an M-ary amplitude-phase-shift-keying signal — use for APSK receivers such as DVB-S2. |
| M-APSK Modulator Baseband | commdigbbndapm/M-APSK Modulator Baseband | R2023a+ | Map bits to an M-ary amplitude-phase-shift-keying constellation — use for APSK transmitters such as DVB-S2. |
| CPM Demodulator Baseband | commdigbbndcpm2/CPM Demodulator Baseband | R2023a+ | Demodulate the CPM modulated input signal using the Viterbi algorithm. For the multirate processing option, this block accepts a scalar input signal. For the single-rate processing option, this block accepts a column vector input signal whose width is an integer multiple of the Samples per symbol parameter. The output signal can be either bits or integers. When you set the 'Output type' parameter to 'Bit', the output width is an integer multiple of the number of bits per symbol. |
| CPM Modulator Baseband | commdigbbndcpm2/CPM Modulator Baseband | R2023a+ | Output the complex envelope representation of the selected continuous phase modulation. The input signal can be either bits or integers. For the single-rate processing option with bit inputs, the input width must be an integer multiple of the number of bits per symbol. For the multirate processing option with bit inputs, the input width must equal the number of bits per symbol. For the single-rate processing option with integer inputs, this block accepts a scalar or column vector input signal. For the multirate processing option with integer inputs, this block accepts a scalar input signal. |
| CPFSK Demodulator Baseband | commdigbbndcpm2/CPFSK Demodulator Baseband | R2023a+ | Demodulate the CPFSK modulated input signal using the Viterbi algorithm. |
| CPFSK Modulator Baseband | commdigbbndcpm2/CPFSK Modulator Baseband | R2023a+ | Modulate the input signal using the continuous phase frequency shift keying method. |
| GMSK Demodulator Baseband | commdigbbndcpm2/GMSK Demodulator Baseband | R2023a+ | Demodulate the GMSK modulated input signal using the Viterbi algorithm. |
| GMSK Modulator Baseband | commdigbbndcpm2/GMSK Modulator Baseband | R2023a+ | Modulate the input signal using the Gaussian minimum shift keying method. |
| MSK Demodulator Baseband | commdigbbndcpm2/MSK Demodulator Baseband | R2023a+ | Demodulate the MSK modulated input signal using the Viterbi algorithm. |
| MSK Modulator Baseband | commdigbbndcpm2/MSK Modulator Baseband | R2023a+ | Modulate the input signal using the minimum shift keying method. |
| M-FSK Demodulator Baseband | commdigbbndfm2/M-FSK Demodulator Baseband | R2023a+ | Demodulate the input signal using the frequency shift keying method. For the multirate processing option, this block accepts a scalar input signal. For the single-rate processing option, this block accepts a column vector input signal whose width is an integer multiple of the Samples per symbol parameter. The output signal can be either bits or integers. When you set the 'Output type' parameter to 'Bit', the output width is an integer multiple of the number of bits per symbol. |
| M-FSK Modulator Baseband | commdigbbndfm2/M-FSK Modulator Baseband | R2023a+ | Modulate the input signal using the frequency shift keying method. The input signal can be either bits or integers. For the single-rate processing option with bit inputs, the input width must be an integer multiple of the number of bits per symbol. For the multirate processing option with bit inputs, the input width must equal the number of bits per symbol. For the single-rate processing option with integer inputs, this block accepts a scalar or column vector input signal. For the multirate processing option with integer inputs, this block accepts a scalar input signal. |
| OFDM Demodulator | commofdm/OFDM Demodulator | R2023a+ | Demodulate an OFDM signal back to subcarrier symbols (cyclic-prefix removal and FFT) — use in OFDM receivers. |
| OFDM Modulator | commofdm/OFDM Modulator | R2023a+ | Modulate subcarrier symbols into an OFDM waveform (IFFT and cyclic prefix) — use in OFDM transmitters. |
| BPSK Demodulator Baseband | commdigbbndpm3/BPSK Demodulator Baseband | R2023a+ | Demodulate the input signal using the binary phase shift keying method. |
| BPSK Modulator Baseband | commdigbbndpm3/BPSK Modulator Baseband | R2023a+ | Modulate the input signal using the binary phase shift keying method. |
| DBPSK Demodulator Baseband | commdigbbndpm3/DBPSK Demodulator Baseband | R2023a+ | Demodulate a differential BPSK baseband signal — use when a carrier phase reference is unavailable. |
| M-DPSK Demodulator Baseband | commdigbbndpm3/M-DPSK Demodulator Baseband | R2023a+ | Demodulate the input signal using the differential phase shift keying method. This block accepts a scalar or column vector input signal. When you set the 'Output type' parameter to 'Bit', the output width is an integer multiple of the number of bits per symbol. |
| M-DPSK Modulator Baseband | commdigbbndpm3/M-DPSK Modulator Baseband | R2023a+ | Modulate the input signal using the differential phase shift keying method. This block accepts a scalar or column vector input signal. The input signal can be either bits or integers. When you set the 'Input type' parameter to 'Bit', the input width must be an integer multiple of the number of bits per symbol. |
| M-PSK Demodulator Baseband | commdigbbndpm3/M-PSK Demodulator Baseband | R2023a+ | Demodulate the input signal using the phase shift keying method. This block accepts a scalar or column vector input signal. When you set the 'Output type' parameter to 'Integer', the block always performs Hard decision demodulation. When you set the 'Output type' parameter to 'Bit', the output width is an integer multiple of the number of bits per symbol. In this case, the 'Decision type' parameter allows you to select 'Hard decision' demodulation, 'Log-likelihood ratio' or 'Approximate log-likelihood ratio'. The output values for Log-likelihood ratio and Approximate log-likelihood ratio decision types are of the same data type as the input values. |
| M-PSK Modulator Baseband | commdigbbndpm3/M-PSK Modulator Baseband | R2023a+ | Modulate the input signal using the phase shift keying method. This block accepts a scalar or column vector input signal. The input signal can be either bits or integers. When you set the 'Input type' parameter to 'Bit', the input width must be an integer multiple of the number of bits per symbol. |
| QPSK Demodulator Baseband | commdigbbndpm3/QPSK Demodulator Baseband | R2023a+ | Demodulate the input signal using the quaternary phase shift keying method. |
| QPSK Modulator Baseband | commdigbbndpm3/QPSK Modulator Baseband | R2023a+ | Modulate the input signal using the quaternary phase shift keying method. |
| DBPSK Modulator Baseband | commdigbbndpm3/DBPSK Modulator Baseband | R2023a+ | Modulate the input signal using the differential binary phase shift keying method. |
| DQPSK Demodulator Baseband | commdigbbndpm3/DQPSK Demodulator Baseband | R2023a+ | Demodulate the input signal using the differential quaternary phase shift keying method. |
| DQPSK Modulator Baseband | commdigbbndpm3/DQPSK Modulator Baseband | R2023a+ | Modulate the input signal using the differential quaternary phase shift keying method. |
| OQPSK Demodulator Baseband | commdigbbndpm3/OQPSK Demodulator Baseband | R2023a+ | Jointly match filter and demodulate signals using the offset quadrature shift keying (OQPSK) method. Pulse shape options for the filter are: half sine, normal raised cosine, root raised cosine and custom. Specify the symbol mapping as Gray, Binary or as a custom value. Specify the output type as bit or integer. Also, a custom phase offset can be specified. |
| OQPSK Modulator Baseband | commdigbbndpm3/OQPSK Modulator Baseband | R2023a+ | Jointly modulate and pulse shape signals using the offset quadrature shift keying (OQPSK) method and customizable filtering. Pulse shape options are: half sine, normal raised cosine, root raised cosine and custom. Specify the symbol mapping as Gray, Binary or as a custom value. Specify the input type as bit or integer. Also, a custom phase offset can be specified. |
| MIL-188 QAM Demodulator Baseband | commdigbbndstd/MIL-188 QAM Demodulator Baseband | R2023a+ | Demodulate a MIL-STD-188-110 compliant QAM signal — use for military HF modem receivers. |
| MIL-188 QAM Modulator Baseband | commdigbbndstd/MIL-188 QAM Modulator Baseband | R2023a+ | Map bits to a MIL-STD-188-110 compliant QAM constellation — use for military HF modem transmitters. |
| M-PSK TCM Decoder | commdigbbndtcm2/M-PSK TCM Decoder | R2023a+ | Use the Viterbi algorithm to decode trellis-coded modulation data, modulated using the phase shift keying modulation method. The Trellis structure parameter must be a valid MATLAB trellis structure. To check if a structure is a valid trellis structure, use the istrellis function in MATLAB. |
| Rectangular QAM TCM Decoder | commdigbbndtcm2/Rectangular QAM TCM Decoder | R2023a+ | Use the Viterbi algorithm to decode trellis-coded modulation data, modulated using the quadrature amplitude modulation method. The Trellis structure parameter must be a valid MATLAB trellis structure. To check if a structure is a valid trellis structure, use the istrellis function in MATLAB. |
| M-PSK TCM Encoder | commdigbbndtcm2/M-PSK TCM Encoder | R2023a+ | Convolutionally encode binary data and modulate using the phase shift keying method. The Trellis structure parameter must be a valid MATLAB trellis structure. To check if a structure is a valid trellis structure, use the istrellis function in MATLAB. |
| Rectangular QAM TCM Encoder | commdigbbndtcm2/Rectangular QAM TCM Encoder | R2023a+ | Convolutionally encode binary data and modulate using the quadrature amplitude modulation method. The Trellis structure parameter must be a valid MATLAB trellis structure. To check if a structure is a valid trellis structure, use the istrellis function in MATLAB. |
