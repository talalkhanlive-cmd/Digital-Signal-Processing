# Z-Transform Problem Assignment

## Objective
Connect discrete-time samples and a one-sample delay to the Z-transform, then implement and compare two two-tap discrete-time systems in MATLAB.

## Files
- `z_transform_assignment.m` — complete, reproducible MATLAB code for both parts and the changed filter.
- `ANSWERS.md` — short answers to Tasks 1–6, including manual calculations.
- `results/` — created by running the MATLAB script. Includes three labeled PNG figures, an output CSV, and a text summary.

## Run
1. Open `z_transform_assignment.m` in MATLAB (including MATLAB Online).
2. Click **Run** to execute the entire script. No Symbolic Math Toolbox is required.
3. Inspect the three figures and the Command Window. Expand the `results/` folder.
4. Confirm the results: **[0.5, 1.5, 1.5, 0.5]** and **[0.8, 1.8, 1.2, 0.2]**.
5. Upload the complete folder, including `results/`, to the existing Digital-Signal-Processing GitHub repository.

## Calculated results

| n | Input x[n] | 0.5x[n] + 0.5x[n−1] | 0.8x[n] + 0.2x[n−1] |
|---:|---:|---:|---:|
| 0 | 1 | 0.5 | 0.8 |
| 1 | 2 | 1.5 | 1.8 |
| 2 | 1 | 1.5 | 1.2 |
| 3 | 0 | 0.5 | 0.2 |

## Main conclusion
Multiplication by `z^(-1)` corresponds to delaying a causal sequence by one sample (under the zero-initial-condition convention used here). The coefficients in `H(z)` set how strongly the present and previous input samples contribute. Changing `[0.5 0.5]` to `[0.8 0.2]` gives the current sample more weight.

## Limitation
The experiment uses a short, finite signal with zero input outside the listed samples; it does not evaluate how the filters act on long, noisy real-world signals.

## AI assistance
ChatGPT helped draft and organize the MATLAB script, explanations, and documentation. The mathematical outputs were independently checked algebraically in the preparation step. MATLAB figures in `results/` are only considered MATLAB-verified after the script is run and inspected in MATLAB.

## Submission status
The Moodle assignment displayed an overdue date and a previous grade of 0/100. Uploading to GitHub alone does not confirm that the instructor will accept a late submission; check Moodle submission permissions or contact the instructor.
