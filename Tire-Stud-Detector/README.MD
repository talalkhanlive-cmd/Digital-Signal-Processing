# Tire Stud Detector — MATLAB Image Processing

## Project overview
This MATLAB project demonstrates tire-stud candidate detection using grayscale image processing, dark-region segmentation, bright local-feature extraction, morphological cleanup, connected-component analysis, and a simple count-based classification rule.

## Example data included
The two bundled images (`studded_tire.jpeg` and `summer_tire.jpg`) are **synthetic demonstration images**, not photographs supplied by the teacher. They are included to allow the complete script to run without needing external files. The project has **not** been validated on real tire photographs. To meet the teacher's requirement to use the provided images, replace these two images with the original Moodle attachments, keeping the filenames unchanged, then run the script again.

## Processing pipeline
1. Load the two images and resize to half resolution.
2. Convert RGB to grayscale when appropriate.
3. Use Otsu thresholding and morphology to estimate a dark tire region.
4. Highlight locally bright features using white top-hat filtering.
5. Clean the candidate mask with morphology.
6. Use `bwconncomp` and `regionprops` to measure candidate area, perimeter and eccentricity; calculate circularity to reject elongated or oversized detections.
7. Apply a prototype count threshold (>10 accepted components) to label the result.
8. Display input, candidates and detected-feature overlays, and save figures and a CSV summary to `results/`.

## Observations and limitations
Small, round, reflective points can be candidate studs, but not every bright region is metal. Highlights, tread patterns and surface dirt can cause false positives; dark studs and low contrast can cause false negatives. The fixed thresholds and binary rule are illustrative and require calibration and independent validation on multiple real tire images before classification results can be trusted.

## Execution
Open `tire_stud_detector.m` in MATLAB with Image Processing Toolbox and press **Run**. The script reads the image files from the same project directory and writes outputs to `results/`.
