# Lecture 03 – Discrete-Time Signal Operations and Convolution

## Objective

This experiment creates a 101-sample sine wave, adds reproducible Gaussian noise (`rng(1)`), applies amplitude scaling and a five-sample delay, and tests two moving-average filters using MATLAB's `conv()` command. The goal is to understand how the operations change the signal and how filter length affects noise removal and signal preservation.

## MATLAB script

Run `Lecture03_convolution.m` in MATLAB. It produces the required `signal_operations.png`, `noise_filtering.png`, and `filter_comparison.png` plots, plus `clean_noisy.png` and `signal_delay.png` for additional evidence. The script prints RMSE measurements in the Command Window. The figures included with this project are illustrative reproductions; running MATLAB regenerates them with MATLAB's own `rng(1)` noise values.

## Questions and explanations

**1. Which operation changed the signal amplitude?**  Multiplying `measured` by two doubles every sample value, including positive peaks, negative peaks and noise. The frequency and sample positions do not change.

**2. How did the five-sample delay change the signal?**  Prefixing five zeros shifts the original sequence five sample positions to the right. The sample order and shape of the original data remain the same after the shift; the resulting array contains 106 samples instead of 101. Delays can arise from acquisition, buffering or processing systems.

**3. What does the impulse response `h[n]` represent?**  It is the output of a linear time-invariant filter in response to a unit impulse and describes how input samples are weighted. Here `h5 = ones(1,5)/5`, so each of five samples contributes an equal weight of 0.2 to a full moving-average window.

**4. How did convolution change the noisy signal?**  Convolution with a moving-average impulse response replaces fast sample-to-sample variations with local averages. This suppresses some random noise while also smoothing features of the desired sine wave. With `'same'`, the output retains 101 samples; the ends are affected by the implicit zero-padding.

**5. What differences do the 5-point and 15-point filters show?**  The 5-point curve generally follows the clean sine wave more closely. The 15-point curve is smoother but its peaks are reduced more strongly and the transition around extrema is more rounded. The figures make the trade-off visible.

**6. Which filter removed more noise?**  A 15-point average has stronger suppression of rapid random fluctuations in principle, because it combines more samples. However, apparent smoothness alone is not the same as accuracy relative to the clean reference.

**7. Did the longer filter distort useful information?**  Yes. The wanted sine wave has angular frequency `0.1*pi` radians/sample, and a 15-point average substantially attenuates it. The five-point average also attenuates it, but less. This explains why excessive smoothing is not always preferable.

**8. Which filter would you recommend?**  For this specific 10-samples-per-cycle sine wave, the 5-point moving-average filter is the better starting choice: it reduces noise while preserving more signal amplitude than the 15-point version. Compare the printed RMSE values and the plots after running MATLAB to verify the actual performance, including effects at the edges.

**9. Give one engineering application.**  A moving-average filter can smooth a noisy temperature-sensor measurement so that short fluctuations do not trigger unnecessary control actions. Filter length must match the real rate of temperature change.



