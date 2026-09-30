---
type: Simulink Block Category
title: Filtering
description: Spatial filtering and noise reduction on images
tags: [filter, median, blur, smoothing]
status: stable
source: custom_library
library_root: Computer Vision Toolbox
category_path: Filtering
block_count: 9
---

# Filtering

Use these blocks for filtering.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Median Filter | visionanalysis/Median Filter | R2023a+ | Apply a 2-D median filter to remove salt-and-pepper (impulse) noise while preserving edges — use for noise cleanup before detection, segmentation, or measurement. |
| 2-D Convolution | visionfilter/2-D Convolution | R2023a+ | Performs two-dimensional convolution on two inputs. Use the Output size parameter to specify the dimensions of the output. Assume that the input at port I1 has dimensions (Ma, Na) and the input at port I2 has dimensions (Mb, Nb). If you choose Full, the output is the full two-dimensional convolution with dimensions (Ma+Mb-1, Na+Nb-1). If you choose Same as input port I1, the output is the central part of the convolution with the same dimensions as the input at port I1. If you choose Valid, the output is only those parts of the convolution that are computed without the zero-padded edges of any input. This output has dimensions (Ma-Mb+1, Na-Nb+1). You can normalize the output only when the input is floating point. |
| 2-D FIR Filter | visionfilter/2-D FIR Filter | R2023a+ | Performs two-dimensional FIR filtering of input matrix I using filter coefficient matrix H. You can use the Filtering based on parameter to specify whether your filtering is based on convolution or correlation. Use the Output size parameter to specify the dimensions of the output. Assume that the input at port I has dimensions (Mi, Ni) and the input at port H has dimensions (Mh, Nh). If you choose Full, the output has dimensions (Mi+Mh-1, Ni+Nh-1). If you choose Same as input port I, the output has the same dimensions as the input at port I. If you choose Valid, the block filters the input image only where the coefficient matrix fits entirely within it, so no padding is required. The output has dimensions (Mi-Mh+1, Ni-Nh+1). |
| Median Filter | visionfilter/Median Filter | R2023a+ | Apply a 2-D median filter to remove salt-and-pepper (impulse) noise while preserving edges — use for noise cleanup before detection, segmentation, or measurement. |
| Resize | visiongeotforms/Resize | R2023a+ | Change the size of an image or a region of interest within an image. Use the Specify parameter to designate the parameters you want to use to resize your image. You can specify a scalar percentage that is applied to both rows and columns, or you can specify a two-element vector to scale the rows and columns differently. You can specify the number of rows and/or columns you want your output image to have, and you can preserve or change the image's aspect ratio. Use the Interpolation method parameter to specify the type of interpolation performed by the block when it is resizing a image. If you select the Perform antialiasing when resize factor is between 0 and 100 check box, the block performs lowpass filtering on the input image before shrinking it. |
| Bottom-hat | visionmorphops/Bottom-hat | R2023a+ | Perform morphological bottom-hat filtering on an intensity or binary image. Use the Neighborhood or structuring element parameter to define the neighborhood or structuring element that the block applies to the image. Specify a neighborhood by entering a matrix or vector of ones and zeros. Specify a structuring element using the strel function. Alternatively, you can specify neighborhood values using the Nhood port. For further information on structuring elements, type doc strel at the MATLAB command prompt. |
| Top-hat | visionmorphops/Top-hat | R2023a+ | Perform morphological top-hat filtering on an intensity or binary image. Use the Neighborhood or structuring element parameter to define the neighborhood or structuring element that the block applies to the image. Specify a neighborhood by entering a matrix or vector of ones and zeros. Specify a structuring element using the strel function. Alternatively, you can specify neighborhood values using the Nhood port. For further information on structuring elements, type doc strel at the MATLAB command prompt. |
| 2-D Median | visionstatistics/2-D Median | R2023a+ | Compute the median value along the specified dimension of the input or across time (running median). The 'Product output' and 'Accumulator' parameters apply only for complex fixed-point inputs. |
| Gaussian Pyramid | visiontransforms/Gaussian Pyramid | R2023a+ | This block computes Gaussian pyramid reduction or expansion. The input is either upsampled or downsampled and a lowpass filter is applied pre- or post-sampling. |
