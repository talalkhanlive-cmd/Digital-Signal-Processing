# Image Processing Fundamentals – In-Class Exercises

## Objective

Investigate image quantization, sampling, degradation, enhancement, noise reduction, edge detection and segmentation using MATLAB and Image Processing Toolbox. Six separate sections are included in `exercises.m` for conversion into the required executed Live Script `exercises.mlx`.

## Source images and reproducibility

The experiments use MATLAB sample images `cameraman.tif`, `pout.tif` and `coins.png`. Do not upload these sample images. Noise is reproducible using `rng(42)`. This project was prepared for MATLAB R2026b; verify your actual version with `ver`.

Run `exercises.m` from MATLAB. Save the file as `exercises.mlx` in Live Editor, run all sections, review the results and export the **executed** Live Script as `exercises.pdf`. The `results/` directory is created automatically and will contain PNG figures and CSV tables. The `.mlx` and `.pdf` files must be generated in MATLAB to preserve actual output and user observations.

## Exercise 1 – Pixels and quantization

The 8-bit original is quantized to 4 bits (16 levels), 2 bits (4 levels) and 1 bit (2 levels). Lower bit depth removes fine intensity gradations. Objects may remain recognizable even at 1 bit because their outlines are distinctive, but shading and texture are strongly reduced. Directly selecting every eighth pixel skips the anti-aliasing low-pass step, so fine structures may show jagged edges or false patterns. `imresize` with antialiasing better suppresses high frequencies before shrinking.

## Exercise 2 – Image degradation

Gaussian noise changes pixel intensities additively and salt-and-pepper noise replaces individual pixels with extreme values. The brightness ramp multiplies the original intensities by a spatially varying factor. Motion blur is a spatial convolution with a point-spread function. A median filter is usually a good choice for isolated salt-and-pepper impulses because it suppresses extreme pixel values without averaging them into neighbors.

## Exercise 3 – Contrast and geometry

`imadjust` stretches the image intensity range, while `histeq` remaps the histogram to redistribute intensity values. Gamma 0.5 brightens midtones because values between 0 and 1 increase when raised to a power below 1. Gamma 2 darkens them. Nearest-neighbor enlargement preserves pixel values but produces blocky steps; bicubic interpolation uses neighboring pixels to produce smoother transitions, though it cannot recover lost original detail. Decide the best appearance after examining the plots.

## Exercise 4 – Filtering and comparison

Mean and Gaussian filters are linear smoothers; median is nonlinear. Compare the six **measured** PSNR values in `results/ex4_psnr_table.csv` to determine which filter worked best for each noise type; do not assume the winner without measurements. Gaussian/mean filtering tends to reduce Gaussian noise, whereas median often handles impulses better. In the Fourier magnitude spectrum, blurring generally weakens the high spatial-frequency content that represents rapid intensity changes and fine edges.

## Exercise 5 – Edge detection

Sobel detects intensity gradients, while Canny smooths and uses nonmaximum suppression and threshold linking. Increasing the Canny sigma generally suppresses fine-scale variations, producing fewer fine edges but potentially losing real narrow boundaries. The script reports `nnz` for Sobel and three Canny smoothing scales, and for Canny on Gaussian-noisy and pre-smoothed noisy images. The count of extra pixels relative to the clean reference edge map is a **proxy**, not a ground-truth measurement of false detections; smoothing might also delete genuine edges. Use the recorded numbers to describe what actually happened.

## Exercise 6 – Coin segmentation

Otsu's method finds an automatic grayscale threshold. Morphological opening removes small bright artifacts and breaks thin features. Hole filling closes dark holes inside segmented objects; removing small connected components discards tiny isolated regions. The labelled regions and measured areas are saved for inspection. The largest **detected region** is identified at runtime, but it is only the largest individual coin if the segmentation has separated all coins correctly. Touching coins can merge into one connected component and cause a misleading count or area.

## Limitations

Results depend on thresholding, smoothing and region sizes. PSNR measures pixel-level differences, not subjective quality. Edge-pixel counts alone do not indicate edge correctness. The coin segmentation cannot necessarily separate touching objects. Interpret all of the outputs using the actual MATLAB plots and counts.

## Submission checklist

The instructor requests a GitHub folder `exercises/` containing an **executed** `exercises.mlx` and an exported `exercises.pdf`. The script and generated outputs can remain alongside those required files. Submit the accessible GitHub repository URL in Moodle. The `rice.png` take-home mini project is not included here.
