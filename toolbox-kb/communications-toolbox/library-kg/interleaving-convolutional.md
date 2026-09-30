---
type: Simulink Block Category
title: Interleaving convolutional
description: Blocks for interleaving convolutional.
status: draft
source: custom_library
library_root: Communications Toolbox
category_path: Interleaving convolutional
block_count: 6
---

# Interleaving convolutional

Use these blocks for interleaving convolutional.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| General Multiplexed Deinterleaver | commcnvintrlv2/General Multiplexed Deinterleaver | R2023a+ | A general multiplexed deinterleaver consists of N registers. With each new input symbol, a commutator switches to a new register and the new symbol is shifted in while the oldest symbol in that register is shifted out. When the commutator reaches the Nth register, upon the next new input, it returns to the first register. The multiplexed deinterleaver associated with a general multiplexed interleaver has the same number of registers as the interleaver. The delay in a particular deinterleaver register depends on the largest interleaver delay minus the interleaver delay for the given register. |
| General Multiplexed Interleaver | commcnvintrlv2/General Multiplexed Interleaver | R2023a+ | A general multiplexed interleaver consists of N registers, each with a specified delay. With each new input symbol, a commutator switches to a new register and the new symbol is shifted in while the oldest symbol in that register is shifted out. When the commutator reaches the Nth register, upon the next new input, it returns to the first register. |
| Convolutional Deinterleaver | commcnvintrlv2/Convolutional Deinterleaver | R2023a+ | A convolutional deinterleaver consists of N shift registers. The ith register has delay (N-i)*B where B is a specified register length step. With each new input symbol, a commutator switches to a new register and the new symbol is shifted in while the oldest symbol in that register is shifted out. When the commutator reaches the Nth register, upon the next new input, it returns to the first register. |
| Convolutional Interleaver | commcnvintrlv2/Convolutional Interleaver | R2023a+ | A convolutional interleaver consists of N shift registers. The ith register has delay (i-1)*B where B is a specified register length step. With each new input symbol, a commutator switches to a new register and the new symbol is shifted in while the oldest symbol in that register is shifted out. When the commutator reaches the Nth register, upon the next new input, it returns to the first register. |
| Helical Deinterleaver | commcnvintrlv2/Helical Deinterleaver | R2023a+ | Restore the ordering of symbols input to a matching helical interleaver. The operation of a helical deinterleaver is defined by a helical array with C columns. The input to the helical deinterleaver must have width C*N. Received symbols are entered row-by-row into the helical array. The block processes the symbols in the helical array in groups of size N and assigns an index k to each group, beginning with k=1 at the start of the simulation. After a delay, the kth output group is read sequentially down column k mod C of the helical array and beginning in row 1+(k-1)*s, where s is the helical array step size. The helical array step size must be a nonnegative integer and the initial condition must be a scalar. |
| Helical Interleaver | commcnvintrlv2/Helical Interleaver | R2023a+ | Permute input vector using a helical array with C columns. The input to the helical interleaver must have width C*N. The block processes the input in groups of size N and assigns an index to each group, beginning with k=1 at the start of the simulation. The kth group of N symbols is entered sequentially down column k mod C of the helical array and beginning in row 1+(k-1)*s, where s is the helical array step size. The helical interleaver output is then read row-by-row from the helical array. The helical array step size must be a nonnegative integer and the initial condition must be a scalar. |
