---
type: Simulink Block Category
title: Error correction
description: Turbo and turbo-product forward error correction
tags: [error detection and correction, tpc, turbo]
status: stable
source: custom_library
library_root: Communications Toolbox
category_path: Error correction
block_count: 10
---

# Error correction

Use these blocks for error correction.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| LDPC Decoder | commblkcod2/LDPC Decoder | R2023a+ | Decode a binary low-density parity-check code using the message-passing algorithm. The parity-check matrix specifies the code. (N-K) and N are the number of rows and columns in the parity-check matrix. This block accepts a column vector input signal with N elements. Each element is the log-likelihood ratio for a received bit (more likely to be '0' if the log-likelihood ratio is positive). The first K elements correspond to the information part of a codeword. |
| TPC Decoder | commblkcod2/TPC Decoder | R2023a+ | Decode a turbo product code — use to correct errors on TPC-encoded blocks. |
| TPC Encoder | commblkcod2/TPC Encoder | R2023a+ | Encode data with a turbo product code — use to add strong block forward error correction. |
| Binary Cyclic Decoder | commblkcod2/Binary Cyclic Decoder | R2023a+ | Recover a message vector from a codeword vector of a binary systematic cyclic code. The message is of length K and the codeword is of length N. The input must contain exactly N elements. |
| Binary Cyclic Encoder | commblkcod2/Binary Cyclic Encoder | R2023a+ | Create a systematic cyclic code with message length K and codeword length N. The input must contain exactly K elements. |
| Hamming Decoder | commblkcod2/Hamming Decoder | R2023a+ | Recover a binary message vector from a binary Hamming codeword vector. The message is of length K and the codeword is of length N, where N has the form 2^M-1, for some integer M greater than or equal to 3. K must equal N-M. The input must contain exactly N elements. |
| Hamming Encoder | commblkcod2/Hamming Encoder | R2023a+ | Create a Hamming code with message length K and codeword length N. The number N must have the form 2^M-1, where M is an integer greater than or equal to 3. K must equal N-M. The input must contain exactly K elements. |
| LDPC Encoder | commblkcod2/LDPC Encoder | R2023a+ | Encode a message using a binary low-density parity-check code. The parity-check matrix specifies the code. (N-K) and N are the number of rows and columns in the parity-check matrix. This block accepts a column vector input signal with K elements. The output is a binary column vector with N elements. It is a solution to the parity-check equation, with the first K bits equal to the input. The last (N-K) columns of the parity-check matrix must form an invertible matrix in GF(2). If they form a triangular matrix, the parity-check equation will be solved by forward or backward substitution; otherwise, matrix inverse will be used (which may cause delays when updating or starting the model). |
| Turbo Decoder | commcnvcod2/Turbo Decoder | R2023a+ | Iteratively decode a turbo (parallel-concatenated convolutional) code — use for near-capacity error correction at the receiver. |
| Turbo Encoder | commcnvcod2/Turbo Encoder | R2023a+ | Encode data with a turbo (parallel-concatenated convolutional) code — use for near-capacity forward error correction. |
