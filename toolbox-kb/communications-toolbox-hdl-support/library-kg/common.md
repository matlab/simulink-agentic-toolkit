---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 24
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Raised-cosine transmit pulse-shaping filter with upsampling — use to band-limit transmitted symbols and control inter-symbol interference. | Raised Cosine Transmit Filter | Communications Toolbox HDL Support |
| HDL-optimized CRC generator that appends a checksum to a frame — use for hardware error detection at the transmitter. | General CRC Generator HDL Optimized | Communications Toolbox HDL Support |
| Encode a bit stream with a convolutional code — use ahead of a Viterbi decoder for forward error correction in hardware links. | Convolutional Encoder | Communications Toolbox HDL Support |
| Decode a convolutionally-encoded stream with the Viterbi algorithm — use to correct errors in hardware receivers. | Viterbi Decoder | Communications Toolbox HDL Support |
| Demodulate a QPSK baseband signal to bits — use in hardware QPSK receivers. | QPSK Demodulator Baseband | Communications Toolbox HDL Support |
| Map bits to a QPSK baseband constellation — use in hardware QPSK transmitters. | QPSK Modulator Baseband | Communications Toolbox HDL Support |
| Remove the DC (zero-frequency) component of a signal with a high-pass filter — use to eliminate DC offset before demodulation. | DC Blocker | Communications Toolbox HDL Support |
| Matched raised-cosine receive filter with optional decimation — use for matched filtering at the receiver to limit inter-symbol interference. | Raised Cosine Receive Filter | Communications Toolbox HDL Support |
| Plot received symbols on an IQ constellation — use to visualize modulation quality and channel impairments. | Constellation Diagram | Communications Toolbox HDL Support |
| Compare transmitted and received bits/symbols to compute bit- or symbol-error rate — use to measure link performance. | Error Rate Calculation | Communications Toolbox HDL Support |
| Overlay signal traces into an eye diagram — use to assess inter-symbol interference, jitter, and timing margin. | Eye Diagram | Communications Toolbox HDL Support |
| Generate a pseudonoise (maximal-length LFSR) sequence — use for spreading, scrambling, or as a repeatable test bit source. | PN Sequence Generator | Communications Toolbox HDL Support |
| HDL-optimized Reed-Solomon encoder taking integer symbols — use to add RS forward error correction in hardware. | Integer-Input RS Encoder HDL Optimized | Communications Toolbox HDL Support |
| HDL-optimized Reed-Solomon decoder producing integer symbols — use to correct symbol errors with RS FEC in hardware. | Integer-Output RS Decoder HDL Optimized | Communications Toolbox HDL Support |
| HDL-optimized CRC checker that flags frames failing the checksum — use for hardware error detection at the receiver. | General CRC Syndrome Detector HDL Optimized | Communications Toolbox HDL Support |
| Restore original symbol order after convolutional interleaving — use at the receiver to undo burst-error spreading. | Convolutional Deinterleaver | Communications Toolbox HDL Support |
| Permute symbols with a convolutional interleaver to spread burst errors — use at the transmitter to strengthen FEC against bursts. | Convolutional Interleaver | Communications Toolbox HDL Support |
| Undo a general multiplexed interleaver using per-branch delays — use to restore symbol order at the receiver. | General Multiplexed Deinterleaver | Communications Toolbox HDL Support |
| Interleave symbols across branches with configurable delays — use to protect a stream against burst errors. | General Multiplexed Interleaver | Communications Toolbox HDL Support |
| Demodulate a rectangular-QAM baseband signal to bits/symbols — use in hardware QAM receivers. | Rectangular QAM Demodulator Baseband | Communications Toolbox HDL Support |
| Map bits/symbols to a rectangular-QAM baseband constellation — use in hardware QAM transmitters. | Rectangular QAM Modulator Baseband | Communications Toolbox HDL Support |
| Demodulate a BPSK baseband signal to bits — use in hardware BPSK receivers. | BPSK Demodulator Baseband | Communications Toolbox HDL Support |
| Map bits to a BPSK baseband constellation — use in hardware BPSK transmitters. | BPSK Modulator Baseband | Communications Toolbox HDL Support |
| Demodulate an M-ary PSK baseband signal to bits/symbols — use in hardware PSK receivers. | M-PSK Demodulator Baseband | Communications Toolbox HDL Support |
