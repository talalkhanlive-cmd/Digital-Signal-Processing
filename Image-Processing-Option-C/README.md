# Individual Assignment — Image Processing Fundamentals

## Selected option

**Option C — Compare edge detectors.** MATLAB sample image: `cameraman.tif`. The sample image is loaded from the MATLAB installation and is **not uploaded to GitHub**.

## Research question

How do different smoothing settings affect edge detection on clean and Gaussian-noisy versions of an image?

## Procedure and settings

The MATLAB Live Script uses `cameraman.tif` and generates a noisy version with `rng(42); In = imnoise(I,'gaussian',0,0.01);`. Three methods are applied to **both** images, without manually setting detector thresholds:

| Method | Settings |
|---|---|
| Sobel | Apply `imgaussfilt(image,1)` before `edge(...,'Sobel')` |
| Canny | `edge(image,'Canny',[],1)` |
| Canny | `edge(image,'Canny',[],3)` |

Each edge map is binary. The experiment counts its edge pixels with `nnz`, producing six counts in `results/edge_pixel_counts.csv`. All six maps are displayed together in `results/edge_maps_six.png`.

## Interpretation

Sobel estimates local intensity gradients after Gaussian smoothing. Canny uses smoothing and additional edge-detection steps to identify thin boundaries. With larger sigma, fine image variations tend to be suppressed more strongly. This can reduce noise-related edges, but it can also erase meaningful fine image details.

An edge-pixel count describes how many pixels were marked as edges; it **does not establish whether they are correct**. Review the six output images and compare both edge continuity and details that disappear or appear. In particular, inspect the camera and tripod boundaries and a relatively uniform background area. The final conclusion should refer to the generated maps and actual counts rather than assuming a detector is always best.

## Limitations

No manually labelled ground-truth edge map is supplied, so precision, recall, and detection correctness cannot be calculated from these counts. Noise is synthetic, and findings from this one image cannot automatically be generalized to other scenes or noise conditions.

## MATLAB and reproducibility

Designed for **MATLAB R2026b with Image Processing Toolbox**. The experiment uses the sample image `cameraman.tif` provided by MATLAB.

Open `analysis.m` in MATLAB, select **Save As** and save it as `analysis.mlx` (MATLAB Live Script). Open `analysis.mlx`, click **Run All**, inspect its generated figure and table, and save the executed Live Script. Export that executed Live Script as `analysis.pdf`. The code saves image and CSV outputs in `results/`. Include the executed `analysis.mlx`, `analysis.pdf`, `results/`, and this README in GitHub. Keep `analysis.m` if useful as an editable source copy.

## Conclusion

After executing the experiment, compare the displayed results and the counts to decide whether additional Canny smoothing suppresses unwanted edges enough to justify losing finer details. Record a specific location where an edge was either lost or invented, based on what you actually see in the plots.

## Assistance and verification

This project was prepared with ChatGPT assistance for the MATLAB code and documentation. The code and its outputs must be executed and checked in MATLAB; do not report unverified counts or observations as measured results.
