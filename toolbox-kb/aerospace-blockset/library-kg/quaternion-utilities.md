---
type: Simulink Block Category
title: Quaternion utilities
description: Quaternion and 3x3 matrix math operations
tags: [quaternion, matrix, conjugate, normalize, cross product]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Quaternion utilities
block_count: 14
---

# Quaternion utilities

Use these blocks for quaternion utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Adjoint of 3x3 Matrix | aerolibutil/Adjoint of 3x3 Matrix | R2023a+ | Compute the classical adjoint (adjugate) of a 3x3 matrix — use in matrix inversion or Cramer's rule calculations |
| Invert  3x3 Matrix | aerolibutil/Invert  3x3 Matrix | R2023a+ | Compute the inverse of a 3x3 matrix — use for resolving body-axis equations or transforming between frames |
| Quaternion Conjugate | aerolibutil/Quaternion Conjugate | R2023a+ | Compute the conjugate of a unit quaternion — equivalent to inverse for unit quaternions, use for reverse rotations |
| Quaternion Division | aerolibutil/Quaternion Division | R2023a+ | Divide one quaternion by another — compute relative rotation between two orientations |
| Quaternion Inverse | aerolibutil/Quaternion Inverse | R2023a+ | Compute the multiplicative inverse of a quaternion — use for non-unit quaternions where conjugate alone is insufficient |
| Quaternion Multiplication | aerolibutil/Quaternion Multiplication | R2023a+ | Multiply two quaternions to compose sequential rotations — fundamental operation for quaternion-based attitude propagation |
| Quaternion Rotation | aerolibutil/Quaternion Rotation | R2023a+ | Rotate a 3D vector by a quaternion using the sandwich product — use for transforming vectors between reference frames |
| 3x3 Cross Product | aerolibutil/3x3 Cross Product | R2023a+ | Compute the cross product of two 3-element vectors — use for torque, angular momentum, or Coriolis calculations |
| Create 3x3 Matrix | aerolibutil/Create 3x3 Matrix | R2023a+ | Assemble a 3x3 matrix from nine scalar inputs or three row/column vectors |
| Determinant of 3x3 Matrix | aerolibutil/Determinant of 3x3 Matrix | R2023a+ | Compute the determinant of a 3x3 matrix — use for checking invertibility or computing volume scaling |
| Quaternion Interpolation | aerolibutil/Quaternion Interpolation | R2023a+ | Interpolate between two quaternions using SLERP — use for smooth attitude trajectory generation between waypoints |
| Quaternion Modulus | aerolibutil/Quaternion Modulus | R2023a+ | Compute the magnitude (norm) of a quaternion — use for normalization checks or quaternion health monitoring |
| Quaternion Norm | aerolibutil/Quaternion Norm | R2023a+ | Compute the squared norm of a quaternion — faster than modulus when only comparing magnitudes |
| Quaternion Normalize | aerolibutil/Quaternion Normalize | R2023a+ | Normalize a quaternion to unit length — essential after numerical integration to prevent attitude drift |
