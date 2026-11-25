Lab 3: Frequency-Domain Filtering with fft2
Objective
This lab studies two-dimensional frequency-domain image filtering in MATLAB. The goal is to inspect the frequency spectrum of a grayscale image, compare ideal and Gaussian low-pass filters, extract high-frequency image details, and investigate the relationship between spatial convolution and frequency-domain multiplication.

Input and method
The MATLAB script uses peppers.png where available, otherwise cameraman.tif. It converts the image to grayscale and floating-point values in the range 0–1. The two-dimensional Fourier transform is computed with fft2, then centered with fftshift for visualization. A logarithmic magnitude display makes both strong and weak frequency components easier to see.

1. Image magnitude spectrum
In a centered spectrum, the zero-frequency (DC) component is near the middle. Low spatial frequencies describe slow variations in brightness and broad regions of the image. Higher spatial frequencies represent faster changes, including sharp edges and fine textures. The logarithmic display reduces the large intensity difference between the central components and weaker frequencies.

2. Ideal and Gaussian low-pass filters
The ideal low-pass mask passes frequency components within a radius of 40 frequency bins and abruptly removes those outside it. The Gaussian low-pass mask uses a smooth frequency response with standard deviation 20 bins. Both suppress spatial high-frequency detail, but their transition shapes are different.

3. Low-pass results and ringing
Low-pass filtering smooths the image by attenuating rapid spatial changes. A hard cutoff in the ideal filter corresponds to an oscillatory spatial impulse response, so ringing can appear near sharp edges (the Gibbs phenomenon). A Gaussian has a smoother transition in frequency and tends to create less ringing. The actual extent of blurring depends on the filter parameters.

4. Gaussian high-pass filter
The complementary mask, 1 - H_gauss_LP, removes low-frequency brightness variations while retaining high-frequency details. Edges and fine textures become more prominent. Since the high-pass output can contain negative values, it is displayed both with automatic contrast and after mapping to the 0–1 range. That display mapping is for visualization; it changes the appearance of the output, not the filter itself.

5. Spatial versus frequency-domain Gaussian filtering
The starter lab compares a 7×7 spatial Gaussian with sigma = 1.2 pixels against a frequency-domain Gaussian with sigma = 20 frequency bins. They do not represent the same transfer function and use different effective boundary conditions; their results need not be close. This is a parameter/boundary mismatch rather than a contradiction of the convolution theorem.

The script also makes a controlled comparison using the same 7×7 Gaussian kernel for both spatial convolution and Fourier multiplication, with circular boundary handling in each. When the kernel is positioned correctly, the outputs should match up to floating-point rounding. MATLAB prints the maximum absolute difference and RMSE so the claim can be checked against actual execution.

Reflection questions
1. Why does an ideal low-pass filter cause ringing?
The abrupt frequency cutoff introduces oscillations in the corresponding spatial-domain impulse response. At abrupt image transitions, those oscillations can produce visible bright and dark ripples near edges. This is the Gibbs phenomenon. A smoothly tapered frequency response, such as a Gaussian, reduces the effect.

2. What does fftshift do visually?
fftshift rearranges the Fourier transform output so that the zero-frequency component appears in the center rather than at the array corner. This makes the distribution of low and high spatial frequencies easier to interpret. It does not change the underlying Fourier-transform values; it changes their arrangement.

3. When is frequency-domain filtering computationally preferable?
Frequency-domain filtering can be advantageous for large images and large convolution kernels, especially when filtering can be done with FFT multiplication rather than evaluating many spatial kernel operations for each pixel. For small kernels, direct spatial convolution may be faster and simpler because FFTs involve extra computation and memory. Care is needed with padding and boundaries: unpadded FFT multiplication implements circular convolution, not linear convolution.

Conclusion
The lab illustrates that low-pass filtering smooths images, high-pass filtering emphasizes spatial detail, and sharp frequency-domain cutoffs can introduce ringing. Spatial and frequency-domain filtering are consistent through the convolution theorem when equivalent kernels and boundary assumptions are used. Filter selection therefore depends on the intended detail preservation, smoothing behavior, computational cost, and edge treatment.

Running the experiment
Open Lab3_frequency_domain_filtering.m in MATLAB with Image Processing Toolbox and run the whole script. Inspect the plots and compare the printed numerical difference in the matched-kernel test with the explanation above before submitting your work.
