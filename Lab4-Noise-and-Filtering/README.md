# Lab 4: Noise and Filtering

## Objective

This experiment examines Gaussian noise and salt-and-pepper noise in grayscale images. It compares linear mean and Gaussian filters with a nonlinear median filter and evaluates the outputs using mean squared error (MSE) and signal-to-noise ratio (SNR).

## Experiment setup

The MATLAB script loads `peppers.png` and converts it to double-precision grayscale values in the interval [0, 1]. If `peppers.png` is unavailable, it uses `cameraman.tif`. The random-number generator is initialized using `rng(7)` for reproducibility.

Noise is added in two separate experiments:

- **Gaussian noise:** mean 0 and variance 0.01.
- **Salt-and-pepper noise:** density 0.05, introducing randomly located black and white pixels.

The script uses a 3×3 averaging filter, a 3×3 Gaussian filter with standard deviation 0.7, and a 3×3 median filter.

## 1. Noise types

Gaussian noise introduces random intensity variations across the image. Salt-and-pepper noise produces isolated extreme-intensity pixels. These types of corruption have different statistical properties, so the same filter may not work equally well on both.

## 2. Quality metrics: MSE and SNR

MSE measures the average squared difference from the original image:

\[\mathrm{MSE}=\frac{1}{MN}\sum_{i=1}^{M}\sum_{j=1}^{N}(I_{ij}-\hat{I}_{ij})^2\]

A lower MSE indicates a closer pixel-level match to the clean reference. The script calculates signal-to-noise ratio as:

\[\mathrm{SNR}=10\log_{10}\left(\frac{\operatorname{mean}(I^2)}{\mathrm{MSE}}\right)\ \mathrm{dB}\]

Here, the difference between the processed image and clean reference is treated as error. A higher SNR indicates less error relative to the clean-signal power. Neither metric fully measures human-perceived image quality or edge preservation.

The actual values are calculated during execution and saved to `filter_metrics.csv`. Random results should be taken from that file rather than guessed.

## 3. Linear filtering: mean and Gaussian

The 3×3 **mean filter** replaces a pixel with the average of its neighborhood. It smooths rapid intensity changes, including some noise, but also blurs edges and fine details.

The **Gaussian filter** computes a weighted local average, placing greater weight on nearby pixels. It generally produces smoother, more natural blur than a uniform box filter at comparable settings, but it can still soften edges.

## 4. Nonlinear filtering: median

The **median filter** replaces a pixel with the median intensity in its local neighborhood. This is particularly effective for salt-and-pepper noise because extreme-valued impulse pixels often do not influence the neighborhood median. It can preserve sharp boundaries better than simple averaging in many circumstances, although it may also modify small structures.

## 5. Results and comparison

The script compares the original, noisy, mean-filtered, Gaussian-filtered, and median-filtered images. It calculates MSE and SNR for every condition and summarizes the MSE results in a comparison chart.

**After running the MATLAB script, review `filter_metrics.csv` and compare the actual results.** The filter with the best numerical score is not automatically best at retaining all visually useful structures.

## 6. Reflections

### Which noise is best removed by a median filter, and why?

The median filter is especially appropriate for **salt-and-pepper noise**. It can reject isolated black or white outliers by selecting the middle value of neighboring pixels instead of averaging the extreme values into nearby locations.

### Why does linear filtering blur edges more?

Mean and Gaussian filtering combine neighboring intensities. At an edge, the neighborhood contains pixels from both sides of the boundary, so weighted averaging creates intermediate values and reduces edge sharpness. A median filter often resists isolated extreme pixels without blending the two sides of an edge to the same extent.

### How could adaptive filters preserve detail?

An adaptive method could estimate local noise or edge strength and vary its behavior accordingly. For example, it could smooth flat regions more strongly but apply weaker smoothing near detected edges, or adjust the median neighborhood size based on the amount of impulse noise. This could improve noise reduction while preserving structural details.

## 7. Engineering conclusion

Filter selection should depend on the type of noise and the image features that need to be preserved. Median filtering is a sensible starting point for impulse noise, while mean or Gaussian filtering can be useful for Gaussian-like fluctuations. MSE and SNR provide reproducible numerical comparisons, and the images help assess whether important edges and textures remain visible.

## Running the experiment

Open `Lab4_noise_filtering.m` in MATLAB with the Image Processing Toolbox available and select **Run**. The script saves its figures and a metrics table to the current folder. Check the generated outputs before using them as evidence in GitHub.
