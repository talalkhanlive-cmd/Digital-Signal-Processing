# Lab 5: Edge Detection and Segmentation

## Objective

This MATLAB experiment explores how image edges relate to changes in pixel intensity. It compares gradient-based edge detection (Sobel and Prewitt), the multistage Canny detector, and a Laplacian-of-Gaussian (LoG) zero-crossing method. It also uses Otsu thresholding to create a binary segmentation and connected-component labeling to identify foreground regions.

## Image preparation

The experiment uses `peppers.png` and converts the image to grayscale with `rgb2gray` and `im2double`. If the image is unavailable, `cameraman.tif` serves as a fallback. Working with grayscale intensity allows the different methods to operate on the same two-dimensional signal.

## 1. Sobel and Prewitt edge detection

Both methods approximate image intensity gradients using small spatial filters. Edges appear where the pixel intensity changes quickly. Sobel uses a slightly different weighting from Prewitt, producing different responses around boundaries and noisy areas. Neither method, by itself, fully separates connected objects from their background.

**Observation to check:** Compare the continuity and thickness of the detected boundaries, including the outlines of the peppers and fine details. The stronger-looking detector can vary with image content and automatic thresholds.

## 2. Canny edge detection

Canny combines Gaussian smoothing, gradient estimation, non-maximum suppression, and thresholding with edge tracking. Non-maximum suppression helps produce thin edges, while its two-threshold approach can preserve connected weak edges associated with stronger ones.

**Observation to check:** Compare how many meaningful contours remain and whether fine texture or background noise causes unwanted detections. The example uses thresholds `[0.05 0.2]`.

## 3. Laplacian of Gaussian (LoG)

The LoG method first smooths the image and then uses second-derivative behavior to identify zero crossings. These can indicate transitions between different image regions. Since the method is based on second derivatives rather than the gradient magnitude alone, its detections may differ from those of Sobel, Prewitt, and Canny.

**Observation to check:** Examine whether contours are broken, doubled, or sensitive to small image structures.

## 4. Otsu segmentation

Otsu's method, implemented by `graythresh`, estimates a single global intensity threshold from the image histogram. It chooses a threshold that separates two intensity classes by maximizing between-class variance (equivalently minimizing weighted within-class variance). `imbinarize` then creates a foreground/background mask using that threshold.

**Observation to check:** A global intensity threshold need not correspond exactly to individual peppers. Foreground pixels can include unrelated bright regions, while an object with changing brightness may be split across the mask.

## 5. Connected-region labeling

`bwlabel(BW,8)` identifies connected groups of foreground pixels using 8-neighbor connectivity. `label2rgb` displays different labels using different colors. The printed number counts connected regions of white pixels; it does **not** necessarily count the number of physical objects in the image.

## Reflection questions

### Which operator gives the thinnest and cleanest edges?

Canny is generally designed to generate thinner, better-localized edges through non-maximum suppression and to reduce false detections with smoothing and hysteresis thresholds. Whether it looks cleanest for this specific image must be checked against the produced plots. The edge-pixel counts in `lab5_measurements.csv` provide additional descriptive evidence, although fewer edge pixels alone do not prove greater accuracy.

### Why can Canny outperform simple gradient filters?

Sobel and Prewitt primarily estimate local intensity changes. Canny combines additional stages: smoothing suppresses some noise, non-maximum suppression reduces thick responses, and two-threshold edge tracking helps link meaningful contours. These steps often give more continuous and selective boundaries, at the cost of more processing and parameter tuning.

### How does Otsu relate to histogram-based thresholding?

Otsu uses the grayscale intensity histogram to select a threshold automatically. It separates pixels into two classes based on intensity statistics instead of requiring a manually chosen threshold. It works best when the histogram supports a useful separation into foreground and background. Shadows, overlapping intensity ranges, and uneven illumination can limit the segmentation quality.

## Conclusions

Edge detectors highlight spatial intensity changes, while segmentation converts intensity information into a binary region map. The Canny method generally offers stronger edge localization than simple gradient thresholding, whereas Otsu provides an automatic global threshold for region segmentation. The best approach depends on image texture, illumination, noise, and whether the engineering goal is to find contours or identify entire regions.

## MATLAB execution

Open `Lab5_edge_detection_segmentation.m` in MATLAB and run the entire script with **Image Processing Toolbox** available. Inspect the figures and the printed numeric measurements, then compare the observations above against the actual results before submitting.
