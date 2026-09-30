---
type: Simulink Block Category
title: Interleaving block
description: Blocks for interleaving block.
status: draft
source: custom_library
library_root: Communications Toolbox
category_path: Interleaving block
block_count: 10
---

# Interleaving block

Use these blocks for interleaving block.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| General Block Deinterleaver | commblkintrlv2/General Block Deinterleaver | R2023a+ | Reorder the elements of the input vector. y(k) = u. The length of the permutation vector must match the input signal width. |
| General Block Interleaver | commblkintrlv2/General Block Interleaver | R2023a+ | Reorder the elements of the input vector. y = u(k). The length of the permutation vector must match the input signal width. |
| Algebraic Deinterleaver | commblkintrlv2/Algebraic Deinterleaver | R2023a+ | Deinterleave the elements of the input vector using an algebraically derived permutation table. For the Takeshita-Costello type interleaver, the Number of elements N must be a power of 2, the Multiplicative factor must be an odd integer less than N, and the Cyclic shift must be a nonnegative integer less than N. For the Welch-Costas type interleaver, the Number of elements N must be specified such that N+1 is prime and the Primitive element must be a primitive element from GF(N+1). In each case, the Number of elements must match the input signal width. |
| Algebraic Interleaver | commblkintrlv2/Algebraic Interleaver | R2023a+ | Interleave the elements of the input vector using an algebraically derived permutation table. For the Takeshita-Costello type interleaver, the Number of elements N must be a power of 2, the Multiplicative factor must be an odd integer less than N, and the Cyclic shift must be a nonnegative integer less than N. For the Welch-Costas type interleaver, the Number of elements N must be specified such that N+1 is prime and the Primitive element must be a primitive element from GF(N+1). In each case, the Number of elements must match the input signal width. |
| Matrix Deinterleaver | commblkintrlv2/Matrix Deinterleaver | R2023a+ | Deinterleave the input vector by writing the elements into a matrix column-by-column and reading them out row-by-row. The product of Number of rows and Number of columns must match the input signal width. |
| Matrix Helical Scan Deinterleaver | commblkintrlv2/Matrix Helical Scan Deinterleaver | R2023a+ | Restore the ordering of symbols permuted by a matching helical scan interleaver. The helical scan interleaver writes input elements row-by-row into an array with a specified number of rows and columns. The interleaver output is then read by scanning along diagonals of this array. The pitch of the diagonal scans is determined by the array step size. The array step size must be a nonnegative integer less than the specified number of rows. An array step size of zero indicates no interleaving. The product of Number of rows and Number of columns must match the input signal width. |
| Matrix Helical Scan Interleaver | commblkintrlv2/Matrix Helical Scan Interleaver | R2023a+ | Interleave input vector by writing elements row-by-row into an array with a specified number of rows and columns and then reading them out by scanning along diagonals of this array. The pitch of the diagonal scans is determined by the array step size. The array step size must be a nonnegative integer less than the specified number of rows. An array step size of zero indicates no interleaving. The product of Number of rows and Number of columns must match the input signal width. |
| Matrix Interleaver | commblkintrlv2/Matrix Interleaver | R2023a+ | Interleave the input vector by writing the elements into a matrix row-by-row and reading them out column-by-column. The product of Number of rows and Number of columns must match the input signal width. |
| Random Deinterleaver | commblkintrlv2/Random Deinterleaver | R2023a+ | Deinterleave the elements of the input vector using a random permutation. The Number of elements must match the input signal width. |
| Random Interleaver | commblkintrlv2/Random Interleaver | R2023a+ | Interleave the elements of the input vector using a random permutation. The Number of elements must match the input signal width. |
