Lab 7 — Traditional Filters vs Pretrained DnCNN
Objective
This lab investigates denoising of a grayscale image contaminated with additive Gaussian noise. The clean reference is retained so that output quality can be compared using mean-square error (MSE), peak signal-to-noise ratio (PSNR), and structural similarity (SSIM). The experiment compares several traditional filters, including the adaptive Wiener filter specified in the lab, against a pretrained DnCNN model when available.

Image and Experimental Settings
The project includes camera_image.png, a grayscale example image from the scikit-image sample dataset, so the experiment can be run even when MATLAB's built-in cameraman.tif is not on the image path. MATLAB converts it to double precision before processing.

Gaussian noise is added using a standard deviation of 0.04 (variance 0.0016) and a fixed random seed of 7. Using the same reference and noise sample allows fair numerical comparisons.

Processing Methods
Mean filtering
A 3 × 3 average filter replaces each pixel with a local neighborhood mean. It suppresses random variations but can blur boundaries and fine details.

Median filtering
A 3 × 3 median filter replaces each pixel with the median of nearby pixels. It is particularly useful for impulsive noise. For Gaussian noise, its performance must be judged against the measured results rather than assumed.

Gaussian blur
Gaussian smoothing averages neighboring pixels with weights that decrease with distance from the center. It removes high-frequency variations but can soften image features.

Adaptive Wiener filtering
The 5 × 5 Wiener filter estimates local image statistics to adjust smoothing. In relatively uniform regions it can suppress noise, while in regions with more local variation it may preserve structure better than a simple average.

Pretrained DnCNN
DnCNN is a learned image-denoising model. The MATLAB script attempts to load the pretrained DnCNN model through denoisingNetwork and apply it using denoiseImage. This step requires the necessary MathWorks toolbox and pretrained network support to be installed. If the model cannot be loaded, the script reports the exact reason and does not fabricate an output or a metric for DnCNN.

Image Quality Evaluation
The output images are compared against the same original image using:

MSE: Average squared pixel difference from the original; lower is better.
PSNR: Logarithmic measure based on reconstruction error and image peak value; higher is better.
SSIM: Structural similarity measure that reflects local brightness, contrast, and structure; higher is better, with 1 representing identical images.
The MATLAB script calculates these values and writes them to results/quality_metrics.csv. Compare the actual measurements before deciding which method performed best. A visually smoother result does not necessarily preserve the most useful detail.

Results and Observations
The noisy image contains fine, randomly distributed intensity variation. Local smoothing filters are expected to reduce some of this noise, while potentially suppressing fine textures. The Wiener filter uses local statistics to make the amount of smoothing adaptive. DnCNN may better preserve image details, but this is not guaranteed: its actual performance should be established from the generated images and quality metrics.

Use the MATLAB-generated comparison and CSV file to complete the experiment-specific conclusion:

Best measured method: Determine from the lowest MSE and the highest PSNR and SSIM values in the CSV. If the metrics disagree, explain the trade-off rather than making an unsupported overall ranking.

DnCNN availability: Check results/run_summary.txt. If DnCNN could not run, its comparison remains incomplete and the required model/support files need to be installed.

Limitations and Improvements
The experiment uses a single example image and one synthetic Gaussian-noise realization. It therefore cannot establish that a particular filter is best for every image or type of noise. Results may differ with noise strength, image texture, filter parameters, or neural-network training conditions.

A stronger evaluation would repeat the test on multiple images, use several noise levels and random seeds, compare runtimes, and inspect detail-rich image regions at a consistent display scale.

Running the Project
Open Lab7_traditional_vs_dncnn.m in MATLAB and click Run. Keep camera_image.png beside the script. The script saves comparison figures and measured results to a results subfolder. MATLAB Image Processing Toolbox is needed for the traditional processing operations, while the DnCNN comparison requires the additional pretrained network functionality.

Conclusion
Traditional image filters offer simple and interpretable ways to reduce noise but often trade noise removal for lost detail. Adaptive Wiener filtering adjusts its response according to local image statistics. A trained denoising network can be compared fairly only when it runs on the same noisy input and its output is evaluated using the same reference and metrics. This lab illustrates the importance of combining visual inspection with numerical measurements when selecting a denoising method.
