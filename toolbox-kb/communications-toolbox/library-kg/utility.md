---
type: Simulink Block Category
title: Utility
description: Conversions and measurement blocks
tags: [utility blocks, converter, measurement, power meter, db conversion, sequence operations, source coding]
status: stable
source: custom_library
library_root: Communications Toolbox
category_path: Utility
block_count: 26
---

# Utility

Use these blocks for utility.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Deinterlacer | commsequence2/Deinterlacer | R2023a+ | Separate the elements of the input signal to generate the output signals. The odd-numbered elements of the input signal become the first output signal, while the even-numbered elements of the input signal become the second output signal. This block accepts an even length column vector input signal. |
| Derepeat | commsequence2/Derepeat | R2023a+ | Derepeat by an integer factor. The value of each output sample is the mean value of N consecutive input samples. |
| Descrambler | commsequence2/Descrambler | R2023a+ | Descramble the input data using a linear feedback shift register whose configuration you specify using the 'Scramble polynomial' parameter. This block accepts a scalar or column vector input signal. |
| Interlacer | commsequence2/Interlacer | R2023a+ | Combine the elements of the input signals to generate the output signal. The elements of the first input signal become the odd-numbered elements of the output signal, while the elements of the second input signal become the even-numbered elements of the output signal. Both input ports accept scalars or column vectors with the same number of elements. |
| Puncture | commsequence2/Puncture | R2023a+ | Output the elements which correspond to 1s in the binary Puncture vector. The length of the input must be an integer multiple of the length of the Puncture vector parameter. The block repeats the Puncture vector, when necessary, to output all input elements. |
| Repeat | commsequence2/Repeat | R2023a+ | Repeat each sample N times to increase the sample rate — use for zero-order-hold upsampling. |
| Scrambler | commsequence2/Scrambler | R2023a+ | Scramble the input data using a linear feedback shift register whose configuration you specify using the 'Scramble polynomial' parameter. This block accepts a scalar or column vector input signal. |
| A-Law Compressor | commsrccod2/A-Law Compressor | R2023a+ | Compress the input signal using A-law compression. This block processes each element independently. |
| A-Law Expander | commsrccod2/A-Law Expander | R2023a+ | Expand the signal using inverse A-law compression. This block processes each element independently. |
| Mu-Law Compressor | commsrccod2/Mu-Law Compressor | R2023a+ | Compress the input signal using mu-law compression. This block processes each element independently. |
| Mu-Law Expander | commsrccod2/Mu-Law Expander | R2023a+ | Expand the signal using inverse mu-law compression. This block processes each element independently. |
| Quantizers Library Link | commsrccod2/Quantizers Library Link | R2023a+ | Link to the library of source-coding quantizer blocks — use to browse and insert scalar/vector quantizers. |
| Quantizing Decoder | commsrccod2/Quantizing Decoder | R2023a+ | Decode the quantizer encoded index using a codebook. The input signal is the index from the Quantization codebook vector. The output signal is the quantized signal. The values for the quantized signal are taken from the Quantization codebook vector. |
| Quantizing Encoder | commsrccod2/Quantizing Encoder | R2023a+ | Quantize the input signal using a partition and a codebook. The input signal is quantized according to the Quantization partition vector and encoded according to the Quantization codebook vector. The first output is the index from the Quantization codebook vector. The second output is the quantized signal. The values for the quantized signal are taken from the Quantization codebook vector. |
| Bit to Integer Converter | commutil2/Bit to Integer Converter | R2023a+ | Group bits into integers of a specified word size — use to pack bits into symbols. |
| EVM Measurement | commutil2/EVM Measurement | R2023a+ | Measure error vector magnitude between received and reference symbols — use to quantify modulation accuracy. |
| Integer to Bit Converter | commutil2/Integer to Bit Converter | R2023a+ | Expand integers into their constituent bits — use to unpack symbols into a bit stream. |
| MER Measurement | commutil2/MER Measurement | R2023a+ | Measure the modulation error ratio of received symbols — use to assess signal quality (common in digital TV). |
| Power Meter | commutil2/Power Meter | R2023a+ | Measure the average and peak power of a signal — use to monitor signal levels in a chain. |
| dB Conversion | commutil2/dB Conversion | R2023a+ | Convert a linear quantity to decibels (or dBm) — use to express power or amplitude on a logarithmic scale. |
| Bipolar to Unipolar Converter | commutil2/Bipolar to Unipolar Converter | R2023a+ | Convert a bipolar signal into a unipolar signal in the range [0, M-1], where M is the M-ary number. |
| Complex Phase Difference | commutil2/Complex Phase Difference | R2023a+ | Output the phase difference between the two complex input signals. The range of the phase difference is from -pi to pi. |
| Complex Phase Shift | commutil2/Complex Phase Shift | R2023a+ | Shift the phase of the complex input signal by the "Ph" input value. |
| Data Mapper | commutil2/Data Mapper | R2023a+ | Map integer symbols from one coding scheme to another. |
| Find Delay | commutil2/Find Delay | R2023a+ | Find the delay between two signals sRef and sDel by finding the maximum of the cross-correlation function between them. The signal sDel should be delayed relative to sRef, or else the computed delay will be incorrect. The optional "change signal" output port emits an impulse at the time instant when the current computed delay changes from the previous computed delay. |
| Unipolar to Bipolar Converter | commutil2/Unipolar to Bipolar Converter | R2023a+ | Convert a unipolar signal in the range [0, M-1], where M is the M-ary number, into a bipolar signal. |
