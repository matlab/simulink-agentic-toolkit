---
type: Simulink Block Category
title: Conversions utilities
description: Convert between Simulink Image types and matrices
tags: [utilities, conversion, simulink image, color space]
status: stable
source: custom_library
library_root: Computer Vision Toolbox
category_path: Conversions utilities
block_count: 12
---

# Conversions utilities

Use these blocks for conversions utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Autothreshold | visionconversions/Autothreshold | R2023a+ | Automatically converts an intensity image to a binary image. This block uses Otsu's method, which determines the threshold by splitting the histogram of the input image such that the variance for each of the pixel groups is minimized. Optionally, the block can output a metric that indicates effectiveness of thresholding of the input image. The lower bound of the metric (zero) is attainable only by images having a single gray level, and the upper bound (one) is attainable only by two-valued images. |
| Chroma Resampling | visionconversions/Chroma Resampling | R2023a+ | Downsample or upsample chroma components of a YCbCr signal to reduce the bandwidth and/or storage requirements. |
| Color Space  Conversion | visionconversions/Color Space  Conversion | R2023a+ | Converts color information between color spaces. All conversions support double-precision floating-point and single-precision floating-point inputs. The conversions from R'G'B' to intensity, R'G'B' to B'G'R', B'G'R' to R'G'B', B'G'R' to intensity, and R'G'B' and Y'CbCr color spaces also support 8-bit unsigned integer inputs. |
| Demosaic | visionconversions/Demosaic | R2023a+ | This block performs Demosaicing of an input image in Bayer format with the specified alignment. The alignment is identified as the sequence of R, G and B pixels in the top-left four pixels of the image in row-wise order. |
| Gamma Correction | visionconversions/Gamma Correction | R2023a+ | Apply or remove gamma correction. |
| Image Complement | visionconversions/Image Complement | R2023a+ | Computes the complement of a binary or intensity image. For binary images, the block replaces zeros with ones and ones with zeros. In the output image, black and white are reversed. For intensity images, the block subtracts each pixel value from the maximum value that can be represented by the input data type and outputs the difference. In the output image, dark areas become lighter and light areas become darker. |
| Image Data Type Conversion | visionconversions/Image Data Type Conversion | R2023a+ | Converts and scales input image to specified output data type. When converting between floating-point data types, the block casts the input into the output data type and clips values outside the range to 0 or 1. When converting between all other data types, the block casts the input into the output data type and scales the data type values into the dynamic range of the output data type. For double- and single-precision floating-point data types, the dynamic range is between 0 and 1. For fixed-point data types, the dynamic range is between the minimum and maximum values that can be represented by the data type. |
| From Simulink Image | visionutilities/From Simulink Image | R2023a+ | Convert a Simulink Image data type into the matrix signal used by vision blocks — use at the boundary between Image-typed signals and array processing. |
| Image Attributes | visionutilities/Image Attributes | R2023a+ | Output attributes of input Simulink image signal. |
| Image Pad | visionutilities/Image Pad | R2023a+ | Pad a two-dimensional image. Pad your image by adding rows, columns, or rows and columns. You can pad your image by using a constant value (Constant), repeating its border values (Replicate), using its mirror image (Symmetric), or using circular repetition of its elements (Circular). |
| To Simulink Image | visionutilities/To Simulink Image | R2023a+ | Package a matrix signal into the Simulink Image data type — use to produce interoperable Image-typed output. |
| Block Processing | visionutilities/Block Processing | R2023a+ | Repeats a user-specified operation on submatrices of the input matrix. This block extracts submatrices of a user-specified size from the input matrix. It sends each submatrix to a subsystem for processing, and then reassembles each subsystem output into the output matrix. Use the Block size and Overlap parameters to specify the size and overlap of each submatrix in cell array format. |
