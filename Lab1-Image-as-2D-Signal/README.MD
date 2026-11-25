# Lab 1: Image as a 2D Signal

## Overview

This lab explores how digital images can be processed as two-dimensional signals using MATLAB. The experiment focuses on image sampling, quantization, histograms, contrast enhancement, and gamma correction.

The main objective is to understand how different image processing operations affect image quality, brightness, contrast, and the visibility of details.

## 1. Loading and Grayscale Conversion

The experiment begins by loading the `peppers.png` image in MATLAB.

The original image is represented using three color channels: red, green, and blue (RGB). It is then converted into grayscale using the `rgb2gray()` function.

The grayscale image contains intensity information rather than color information. The shapes and structures of the peppers remain visible, but their colors are represented by different shades of gray.

## 2. Image Quantization

Quantization reduces the number of intensity levels available to represent an image.

Three quantization levels are investigated:

- **8-bit:** 256 possible intensity levels.
- **6-bit:** 64 possible intensity levels.
- **4-bit:** 16 possible intensity levels.

As the bit depth decreases, fewer intensity levels are available.

The 8-bit image preserves smoother intensity transitions, while lower bit depths can introduce visible banding and reduce subtle image details.

This effect is called **posterization**.

## 3. Histogram and Contrast Enhancement

An image histogram represents the distribution of pixel intensity values.

In this experiment, the original histogram is compared with the histogram after contrast stretching.

Contrast stretching remaps intensity values to increase the difference between darker and brighter regions.

The `imadjust()` function is used to enhance the image contrast.

This operation can improve the visibility of details, although excessively strong contrast adjustment may cause information loss in very dark or bright regions.

## 4. Gamma Correction

Gamma correction is a nonlinear operation that changes image brightness.

Two gamma values are investigated:

**Gamma = 0.6**

A gamma value below 1 brightens the image and can make darker regions more visible.

**Gamma = 1.6**

A gamma value above 1 darkens the image and reduces the brightness of many midtone pixels.

Unlike linear contrast stretching, gamma correction changes intensity values through a nonlinear relationship.

Gamma correction is useful for adjusting image brightness while controlling the appearance of different intensity regions.

## 5. Image Sampling and Aliasing

Image sampling determines how many spatial samples, or pixels, are used to represent an image.

In this experiment, the grayscale image is reduced to 10% of its original width and height using nearest-neighbor interpolation.

The smaller image is then enlarged to its original dimensions.

After enlargement, the image appears more pixelated, and fine details may be lost.

Aggressive downsampling can also produce aliasing when high-frequency image patterns are sampled without sufficient filtering.

According to the Nyquist principle, the spatial sampling frequency must be sufficiently high to represent the spatial frequencies present in the original image.

Applying an anti-aliasing filter before downsampling can reduce unwanted artifacts.

## 6. Discussion and Reflection

### 6.1 How does bit depth affect image quality?

Bit depth determines the number of intensity levels used to represent pixel values.

Higher bit depth allows smoother intensity transitions and better representation of subtle brightness differences.

Lower bit depth reduces the number of available intensity levels, which can cause posterization and loss of detail.

### 6.2 How does contrast stretching affect the histogram and image details?

Contrast stretching redistributes pixel intensities over a wider output range.

This can improve the visibility of details by increasing differences between dark and bright regions.

However, values outside the selected input range may become clipped, causing some information to be lost.

### 6.3 Why does aggressive downsampling cause aliasing?

Aggressive downsampling reduces the number of pixels available to represent image details.

When the sampling rate is insufficient for high-frequency spatial patterns, those patterns can be represented incorrectly.

This produces aliasing artifacts such as false patterns, jagged edges, or distorted textures.

Nearest-neighbor enlargement also makes individual pixels more noticeable but cannot recover details lost during downsampling.

## 7. Applications

The image processing techniques investigated in this lab are useful in several engineering applications:

- Medical image enhancement
- Industrial quality inspection
- Digital photography
- Computer vision
- Image compression
- Remote sensing and satellite imaging

## 8. Conclusion

This experiment demonstrates that digital images can be analyzed and modified using signal processing techniques.

Quantization controls the number of available intensity levels, contrast stretching adjusts the intensity range, and gamma correction changes brightness nonlinearly.

Sampling affects spatial resolution, while excessive downsampling can remove important image details and introduce aliasing.

Understanding these operations is important when designing image processing systems that balance image quality, computational requirements, and storage efficiency.
