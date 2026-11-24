# Lecture 6 — Practical Digital Filtering Assignment

MATLAB implementation for **Part A (sensor FIR vs IIR)** and **Part B (50 Hz hum reduction in Handel audio)**, with a report draft.

## How to run

1. Open `digital_filtering_assignment.m` in MATLAB R2026b or another recent MATLAB release with **Signal Processing Toolbox**.
2. Set MATLAB's Current Folder to this project's folder. Click **Run** (not Run Section).
3. Inspect the PNG files and CSV tables created in `results/`.
4. For the required listening comparison, set `playAudio = true` near the end of the script, lower speaker volume, and rerun. The script uses one common playback scaling for a fair comparison.
5. Replace bracketed entries in `REPORT.md` with the values from the CSV files, compare the actual plots, and write *your own* listening observations.
6. Prepare a **3–5 page final report PDF** from the completed report, and upload that PDF, the `.m` file and figures to GitHub or the requested submission platform.

## Outputs

- `01_sensor_time.png` — clean, noisy, FIR and IIR over 0.2 s
- `02_sensor_frequency_responses.png` — single-pass filter magnitude responses
- `03_sensor_spectra.png` — single-sided FFT spectra
- `04_audio_waveforms.png` — clean, hum-added, narrow/wide notch outputs
- `05_audio_spectra.png` — 20–90 Hz comparison
- `06_audio_notch_response.png` — narrow/wide notch designs
- `sensor_rmse.csv`, `sensor_frequency_amplitudes.csv`, `audio_50hz_amplitudes.csv`

## Verification and limitations

**Not yet MATLAB-executed in this package.** The images and CSVs are generated on your computer when you run the script. `REPORT.md` is a draft, **not** an executed final report. The reference sample audio is MATLAB's `handel.mat`; audio is not redistributed. `filtfilt` is offline, not real-time, and filter magnitude responses shown by `freqz` are one-pass responses, not the squared-magnitude `filtfilt` response. No unverified claim of improved sound quality is made.

## Course / AI disclosure

AI was used to assist with code organization, explanations and documentation. Numerical results and listening observations must be verified and supplied by the student.
