# Tire Stud Detector Using MATLAB

## 1. Project Overview

This project uses MATLAB image processing to identify possible metal studs on tires. The program checks whether a tire is studded or non-studded by finding and counting small bright spots on its surface.

## 2. Objective

The main goal is to detect possible metal studs using image processing techniques such as grayscale conversion, thresholding, morphological operations, and connected-component analysis.

## 3. Images Used

Two tire images are used:

- **studded_tire.jpeg** – Studded tire example.
- **summer_tire.jpg** – Non-studded tire example.

These examples are from the provided dataset archive, rather than the original Moodle attachments.

## 4. Methodology

### Step 1: Load and Resize

First, MATLAB loads both tire images and reduces their size if necessary to make processing easier.

### Step 2: Convert to Grayscale

The images are converted into grayscale so MATLAB can analyze the brightness of different areas.

### Step 3: Detect the Tire Area

The program separates the dark tire from the lighter background using a threshold. It also removes unwanted regions and fills holes in the detected area.

### Step 4: Find Possible Studs

The program searches for small bright spots on the tire. A white top-hat filter helps highlight these details.

### Step 5: Remove Unwanted Spots

The program removes small unwanted regions and checks the size and shape of the remaining bright spots.

### Step 6: Count the Studs

MATLAB uses the `regionprops()` function to measure the detected components and count the spots that match the selected rules.

### Step 7: Tire Classification

The program uses a simple decision rule:

- **20 or more detected candidates:** STUDDED TIRE
- **Fewer than 20 detected candidates:** NON-STUDDED TIRE

This is an experimental threshold that needs to be checked against real images.

## 5. Results

The program displays the original image, the detected bright spots, and the final classification.

The results are also saved automatically in the `results` folder.

The detected spots are possible studs, so the results must be checked visually before confirming the classification.

## 6. Limitations

The system may sometimes detect bright reflections or tire patterns as studs. It may also miss studs that are too small or not clearly visible.

Lighting conditions, image quality, and the selected thresholds can affect the accuracy.

## 7. Conclusion

This project demonstrates how MATLAB image processing can be used to identify possible metal studs on tires.

The program converts the image to grayscale, isolates the tire, detects bright spots, and counts suitable components.

The method is simple and useful for understanding image preprocessing, morphology, and object detection.

## 8. Running the Project

Open `tire_stud_detector.m` in MATLAB with Image Processing Toolbox installed.

Keep both tire images in the same folder as the MATLAB script and click **Run**.

The figures and detection measurements will be saved automatically.
