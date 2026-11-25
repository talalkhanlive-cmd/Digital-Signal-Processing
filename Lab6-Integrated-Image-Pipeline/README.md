# Lab 6 – Mini Project: Integrated Image Processing Pipeline

## Objective

This project combines image denoising, intensity enhancement, edge extraction, and two-dimensional Fourier filtering into one reproducible DSP workflow. The demonstration uses a photograph of a coffee cup and related objects, provided as `sample_image.jpg`.

## Input and problem

The goal is to make image structures easier to inspect while reducing isolated pixel fluctuations and exploring how smoothing affects fine details. The included photograph is a **sample image**, not a photograph taken by the student. Source: the `coffee` sample image distributed with [scikit-image](https://scikit-image.org/docs/stable/api/skimage.data.html#skimage.data.coffee). To use a personal photograph instead, replace `sample_image.jpg` with your own JPEG under the same filename.

## Processing pipeline

### 1. Convert to grayscale

The color image is converted into one luminance channel using `rgb2gray`, then into floating-point values between 0 and 1 using `im2double`. This simplifies later two-dimensional signal operations.

### 2. Median filtering

A 3 × 3 median filter replaces each pixel with a neighborhood median. This nonlinear method is especially useful for suppressing impulse noise while often preserving sharp transitions better than a simple averaging filter. On an image without strong impulse noise, the change may be small.

### 3. Contrast enhancement

`imadjust` linearly remaps intensities from the range [0.2, 0.8] to [0, 1], clipping values outside the chosen range. This can increase visible contrast, but clipped highlights or shadows may lose intensity detail.

### 4. Canny edge detection

The Canny algorithm detects image-intensity transitions through smoothing, gradient analysis, nonmaximum suppression, and threshold-based edge linking. The edge map highlights structural boundaries rather than directly identifying objects.

### 5. Frequency-domain low-pass filtering

The enhanced image is transformed using `fft2`, and `fftshift` centers the low-frequency components. A circular ideal low-pass mask with radius 60 retains lower spatial frequencies and suppresses higher ones. The inverse FFT reconstructs a smoothed image. The hard cutoff may introduce ringing around high-contrast edges. The displayed result is clipped to the valid grayscale range.

## How each stage relates to DSP

An image is a two-dimensional signal of pixel intensities. Median filtering is a nonlinear neighborhood operation. Contrast adjustment remaps sample amplitudes. Edge detection responds to strong spatial intensity changes, which are often associated with higher spatial frequencies. Fourier-domain filtering modifies spatial-frequency components by multiplying the image spectrum by a transfer function.

## Discussion: Improvements and limitations

The stages illustrate complementary goals, but they do not guarantee better results for every image. Median filtering can remove small details, contrast stretching can clip data, Canny depends on threshold selection, and the ideal low-pass filter can produce ringing. Also, because the input image has no separate clean reference or manually labeled features, these figures alone cannot establish objective improvements in quality or edge-detection accuracy.

Possible improvements include comparing several median-filter sizes, using adaptive contrast enhancement, testing Gaussian frequency filtering as a smoother alternative to the ideal circular cutoff, and calculating objective measurements on images with known references.

## Reproducibility

Run `Lab6_image_pipeline.m` in MATLAB with Image Processing Toolbox installed. The script reads the bundled photograph from its own folder and saves the comparison, histogram, and frequency-domain figures to that folder. Review the figures and ensure the discussion matches the outputs before submitting the GitHub repository link.
