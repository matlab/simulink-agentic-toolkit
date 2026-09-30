---
type: Simulink Block Category
title: Linear algebra
description: Matrix factorizations, solvers, and operations
tags: [matrices, linear algebra, qr, cholesky, svd, pseudoinverse, matrix]
status: stable
source: custom_library
library_root: DSP System Toolbox
category_path: Linear algebra
block_count: 35
---

# Linear algebra

Use these blocks for linear algebra.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Cumulative Product | dspmathops/Cumulative Product | R2023a+ | Cumulative product of input matrix or input vector elements along the specified dimension: rows, columns, or channels. |
| Cumulative Sum | dspmathops/Cumulative Sum | R2023a+ | Cumulative sum of input matrix or input vector elements along the specified dimension: rows, columns, or channels. |
| Normalization | dspmathops/Normalization | R2023a+ | Normalize the input over the specified dimension by the vector 2-norm, sqrt(u'u)+b, or by the squared 2-norm, u'u+b, where b is a bias used to protect against divide-by-zero. Normalization is performed over rows, columns, or the dimension of the input signal specified in the 'Dimension' parameter. |
| Backward Substitution | dspsolvers/Backward Substitution | R2023a+ | Solve UX=B where U is an upper (or unit-upper) triangular matrix. U must be square. B must have the same number of rows as U. |
| Forward Substitution | dspsolvers/Forward Substitution | R2023a+ | Solve LX=B where L is a lower (or unit-lower) triangular matrix. L must be square. B must have the same number of rows as L. |
| QR Solver | dspsolvers/QR Solver | R2023a+ | Solve a (least-squares) linear system using QR factorization — use for robust solutions of overdetermined systems. |
| Cholesky Solver | dspsolvers/Cholesky Solver | R2023a+ | Solve SX=B using Cholesky factorization. S must be a square, symmetric (Hermitian) positive definite matrix. B must have the same number of rows as S. |
| LDL Solver | dspsolvers/LDL Solver | R2023a+ | Solve SX=B using LDL' factorization. Only for use with a symmetric (Hermitian) positive definite input matrix S. S must be square. B must have the same number of rows as S. |
| LU Solver | dspsolvers/LU Solver | R2023a+ | Solve AX=B using LU decomposition. A must be square. B must have the same number of rows as A. |
| SVD Solver | dspsolvers/SVD Solver | R2023a+ | Solve AX=B using Singular Value Decomposition. B must have the same number of rows as A. If A is not square, the output is a least squares solution. Select the 'Show error status port (E)' check box to send the SVD convergence error status to an output port. |
| Cholesky Factorization | dspfactors/Cholesky Factorization | R2023a+ | Factor a symmetric positive-definite matrix as R'R — use for efficient solves and covariance factorization. |
| LDL Factorization | dspfactors/LDL Factorization | R2023a+ | Computes unit lower triangular L and diagonal D such that S=LDL' for square, symmetric/Hermitian, positive definite input matrix S. Uses only the lower triangle of S. |
| LU Factorization | dspfactors/LU Factorization | R2023a+ | LU factorization with row pivoting. Only for use with a square input matrix A. Stores L (a unit-lower triangular matrix) in the lower triangle and U in the upper triangle of the output matrix. Permutation vector P is output separately. Optionally, the block signals the singularity status of the input matrix. |
| QR Factorization | dspfactors/QR Factorization | R2023a+ | Factor a matrix into orthogonal Q and upper-triangular R — use for least-squares and numerically-stable solves. |
| Singular Value Decomposition | dspfactors/Singular Value Decomposition | R2023a+ | Compute the SVD of a matrix — use for rank, conditioning, pseudoinverse, and subspace analysis. |
| Pseudoinverse | dspinverses/Pseudoinverse | R2023a+ | Compute the Moore-Penrose pseudoinverse — use for least-squares solutions of rank-deficient systems. |
|  LU Inverse | dspinverses/ LU Inverse | R2023a+ | Matrix inverse using LU factorization. |
| Cholesky Inverse | dspinverses/Cholesky Inverse | R2023a+ | Matrix inverse using Cholesky factorization. |
| LDL Inverse | dspinverses/LDL Inverse | R2023a+ | Matrix inverse using LDL factorization. |
| Array-Vector Add | dspmtrx3/Array-Vector Add | R2023a+ | Add the elements of vector V to the input array A along the specified dimension. Note that unoriented input signals are treated as oriented column vectors. The output of this block is always oriented. |
| Array-Vector Divide | dspmtrx3/Array-Vector Divide | R2023a+ | Divide the input array A by the elements of vector V along the specified dimension. In the two-dimensional case, this is equivalent to dividing a full matrix (A) by a diagonal (V). Note that unoriented input signals are treated as oriented column vectors. The output of this block is always oriented. |
| Array-Vector Multiply | dspmtrx3/Array-Vector Multiply | R2023a+ | Multiply the input array A by the elements of vector V along the specified dimension. In the two-dimensional case, this is equivalent to multiplying a full matrix (A) by a diagonal (V). Note that unoriented input signals are treated as oriented column vectors. The output of this block is always oriented. |
| Array-Vector Subtract | dspmtrx3/Array-Vector Subtract | R2023a+ | Subtract the elements of vector V from the input array A along the specified dimension. Note that unoriented input signals are treated as oriented column vectors. The output of this block is always oriented. |
| Extract Triangular Matrix | dspmtrx3/Extract Triangular Matrix | R2023a+ | Extract the upper or lower triangular part of a matrix — use to isolate a triangular factor. |
| Matrix Concatenate | dspmtrx3/Matrix Concatenate | R2023a+ | Concatenate inputs into a larger matrix along a dimension — use to assemble block matrices. |
| Matrix Product | dspmtrx3/Matrix Product | R2023a+ | Multiply the elements of a matrix along its rows, its columns, or over all its elements. Note that 1-D input signals produce a single scalar output equal to the product of the individual elements. |
| Matrix Sum | dspmtrx3/Matrix Sum | R2023a+ | Sum matrix elements along a dimension or add matrices — use for row/column sums or matrix addition. |
| Matrix  1-Norm | dspmtrx3/Matrix  1-Norm | R2023a+ | Compute the matrix 1-norm, which is the largest column sum of absolute values. Note that unoriented input signals are treated as oriented column vectors. The output of this block is always oriented. |
| Matrix Multiply | dspmtrx3/Matrix Multiply | R2023a+ | Multiply matrices (or matrix-vector) — use for linear transforms and weighted combinations. |
| Toeplitz | dspmtrx3/Toeplitz | R2023a+ | Generate a symmetric or asymmetric Toeplitz matrix. If Symmetric is selected, a symmetric (or Hermitian) Toeplitz matrix is generated. If Symmetric is not selected, an asymmetric Toeplitz matrix is generated. The columns and rows are specified by the first and second inputs, respectively. The first matrix element is inherited from the column. |
| Matrix Exponential | dspmtrx3/Matrix Exponential | R2023a+ | Compute the matrix exponential, using a scaling and squaring algorithm with a Pade approximation. Matrix must be square. |
| Reciprocal Condition | dspmtrx3/Reciprocal Condition | R2023a+ | Estimates the reciprocal of the condition of a square input matrix in the 1-norm. If input is well conditioned, the output is near 1.0. If input is badly conditioned, output is near 0.0. |
| Triggered Signal From Workspace | dspsigops/Triggered Signal From Workspace | R2023a+ | Output successive signal samples obtained from the MATLAB workspace when a trigger event occurs. A signal matrix is interpreted as having one channel per column. Signal columns may be buffered into frames by specifying a number of samples per frame greater than 1. An M x N x P signal array outputs M x N matrices when a trigger event occurs. The samples per frame must be equal to 1 for 3 dimensional signal arrays. |
| Signal From Workspace | dspsrcs4/Signal From Workspace | R2023a+ | Output signal samples obtained from the MATLAB workspace at successive sample times. A signal matrix is interpreted as having one channel per column. Signal columns may be buffered into frames by specifying a number of samples per frame greater than 1. An M x N x P signal array outputs M x N matrices at successive sample times. The samples per frame must be equal to 1 for three-dimensional signal arrays. |
| Sort | dspstat3/Sort | R2023a+ | Value and/or index of sorted elements in vector or matrix. For matrix inputs, the elements are sorted columnwise. The 'Product output' and 'Accumulator' parameters apply only for complex fixed-point inputs. |
