---
type: Simulink Block Category
title: Quantizers
description: Amplitude quantization
tags: [quantizer, quantizers]
status: stable
source: custom_library
library_root: DSP System Toolbox
category_path: Quantizers
block_count: 8
---

# Quantizers

Use these blocks for quantizers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| G.711 Codec | dspquant2/G.711 Codec | R2023a+ | Implements the ITU-T G.711 recommendation for encoding, decoding, or converting speech signals. The block encodes int16 PCM signals using A-law or mu-law into uint8 codewords. The input is assumed to be a 13-bit (A-law) or 14-bit (mu-law) PCM signal. The block decodes uint8 codewords into 13-bit (A-law) or 14-bit (mu-law) PCM signals of type int16. The block converts between A-law and mu-law uint8 codewords. |
| Quantizer | dspquant2/Quantizer | R2023a+ | Quantize a signal to discrete amplitude levels — use to model ADC quantization or reduce precision. |
| Scalar Quantizer Decoder | dspquant2/Scalar Quantizer Decoder | R2023a+ | For each input index value, the block outputs the corresponding codeword. Each element of the Codebook parameter represents a codeword. The output values have the same data type as the codebook values. |
| Scalar Quantizer Encoder | dspquant2/Scalar Quantizer Encoder | R2023a+ | The block maps each input value to a quantization region by comparing the input value to the user-specified boundary points. Then, the block outputs the index of the associated region. If you want the block to output the quantized value or the associated quantization error, you must provide the codebook. If the Codebook parameter is defined as [c1 c2 c3 ... cN] and the Boundary points parameter is denoted by [p0 p1 p2 p3 ... pN], then p0 must be less than c1 which must be less than p1 which must be less than c2 and etc. through pN for a regular quantizer. If your quantizer is bounded, you need to specify [p0 p1 p2 p3 ... pN]. For any input less than p0 or greater than pN, you can optionally output the clipping status. If your quantizer is unbounded, you need to specify [p1 p2 p3 ... p(N-1)] and the block sets p0=-Inf and pN = +Inf. You must enter the boundary points in ascending order. |
| Uniform Decoder | dspquant2/Uniform Decoder | R2023a+ | Uniformly decode the input with positive and negative Peak value. Saturate or wrap the input in overflow. The output datatype is double or single. |
| Uniform Encoder | dspquant2/Uniform Encoder | R2023a+ | Uniformly quantize and encode the input into specified number of bits. The input is saturated at positive and negative Peak value. Output datatype is either 8, 16, or 32-bit signed or unsigned integer, based on the least number of bits needed. |
| Vector Quantizer Decoder | dspquant2/Vector Quantizer Decoder | R2023a+ | For each input index value, the block outputs the corresponding codeword. Each column of the Codebook parameter represents a codeword. The output values have the same data type as the codebook values. |
| Vector Quantizer Encoder | dspquant2/Vector Quantizer Encoder | R2023a+ | For each input column vector, the block outputs a zero-based index value of the nearest codeword. You can choose to output the nearest codeword and corresponding quantization error for each input column vector. Each column of the Codebook parameter represents a codeword. If you choose to specify a weighting factor, it must be a vector having length equal to the number of rows of your input. The block applies the same codebook and weighting factor to each input column vector. All the inputs to the block must be the same data type. The output index values can be signed or unsigned integers. All other outputs have the same data type as the inputs. |
