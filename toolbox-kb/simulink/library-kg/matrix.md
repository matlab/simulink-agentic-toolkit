---
type: Simulink Block Category
title: Matrix
description: Matrix and array operations
tags: [matrix, array, transpose, diagonal, multiply, submatrix]
status: stable
source: custom_library
library_root: Simulink
category_path: Matrix
block_count: 19
---

# Matrix

Use these blocks for matrix.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Array Processing Subsystem | simulink/Matrix Operations/Array Processing Subsystem | R2024a+ | Subsystem that processes each element of an array through the same logic — use for element-wise array algorithms. |
| Create Diagonal Matrix | simulink/Matrix Operations/Create Diagonal Matrix | R2023a+ | Build a diagonal matrix from a vector — use to place a vector on a matrix diagonal. |
| Cross Product | simulink/Matrix Operations/Cross Product | R2023a+ | Compute the cross product of two 3-element vectors — use for vector geometry and torque/moment calculations. |
| Expand Scalar | simulink/Matrix Operations/Expand Scalar | R2024a+ | Expand a scalar into an array of a given size — use to broadcast a scalar to matrix dimensions. |
| Extract Diagonal | simulink/Matrix Operations/Extract Diagonal | R2023a+ | Extract the main diagonal of a matrix as a vector — use to read diagonal elements. |
| Hermitian Transpose | simulink/Matrix Operations/Hermitian Transpose | R2023a+ | Compute the complex-conjugate transpose of a matrix — use in linear-algebra signal processing. |
| IdentityMatrix | simulink/Matrix Operations/IdentityMatrix | R2023a+ | Generate an identity matrix of a given size — use to initialize matrix computations. |
| IsHermitian | simulink/Matrix Operations/IsHermitian | R2023a+ | Test whether a matrix equals its conjugate transpose — use to check the Hermitian property. |
| IsSymmetric | simulink/Matrix Operations/IsSymmetric | R2023a+ | Test whether a matrix equals its transpose — use to check symmetry. |
| IsTriangular | simulink/Matrix Operations/IsTriangular | R2023a+ | Test whether a matrix is upper or lower triangular — use to check triangular structure. |
| Matrix Square | simulink/Matrix Operations/Matrix Square | R2023a+ | Compute the matrix square (A*A or A*A') — use for matrix power/Gram computations. |
| Matrix Multiply | simulink/Matrix Operations/Matrix Multiply | R2023a+ | Multiply matrices or matrix-vector products — use for linear transforms. |
| Neighborhood Processing Subsystem | simulink/Matrix Operations/Neighborhood Processing Subsystem | R2023a+ | Apply a subsystem over a sliding neighborhood of an array — use for windowed/stencil operations such as image filtering. |
| Permute Matrix | simulink/Matrix Operations/Permute Matrix | R2023a+ | Reorder the rows or columns of a matrix — use to rearrange matrix structure. |
| Pixel Processing Subsystem | simulink/Matrix Operations/Pixel Processing Subsystem | R2024a+ | Process an image pixel-by-pixel through a subsystem — use for streaming pixel-based algorithms. |
| Submatrix | simulink/Matrix Operations/Submatrix | R2023a+ | Extract a rectangular submatrix by row/column range — use to select a block of a matrix. |
| Transpose | simulink/Matrix Operations/Transpose | R2023a+ | Transpose a matrix signal — use to swap rows and columns. |
| Matrix Multiply | simulink/Quick Insert/Math Operations/Matrix Multiply | R2023a+ | Multiply matrices or matrix-vector products — use for linear transforms. |
| Transpose | simulink/Quick Insert/Math Operations/Transpose | R2023a+ | Transpose a matrix signal — use to swap rows and columns. |
