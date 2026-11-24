# Lecture 5 — Fourier Assignment (MATLAB)

**Course:** Digital Signal Processing  
**Exercises:** Fourier Series, FFT/DFT, spectral leakage, DTFT vs DFT  
**MATLAB:** Run each `.m` script in MATLAB; no Symbolic Math Toolbox is needed.

> **Submission checklist:** Before submitting, edit `exercise-3/exercise3.m` to use the last digit **of your own student number**, run every script in MATLAB, inspect the PNGs, and replace the unfinished details below with your verified observations. Do not upload your full student number.

## How to run

1. Download and extract this folder.
2. Open MATLAB and set the current folder to `lecture-5-fourier-assignment`.
3. Open `exercise-3/exercise3.m` and replace `d = 4` with **your** last digit (0–9). The supplied value 4 is just an example and may be wrong for you.
4. Run each `exercise1.m`, `exercise2.m`, `exercise3.m`, and `exercise4.m` (opening them and clicking **Run**). Each script saves its figures beside itself.
5. Check that every PNG opened and the numeric output matched the theory. Update the notes and values marked **VERIFY** below using your actual MATLAB run.
6. Upload the project to a **new, public** GitHub repository named `lecture-5-fourier-assignment`, and submit its URL in Moodle if permitted.

## Exercise 1 — Square wave from harmonics

**Prediction written before running (model example; adapt to your own words):** As the highest odd harmonic goes from `H=1` to `H=3`, `H=9`, and `H=25`, the rounded sine-wave-like approximation should develop flatter levels and sharper transitions.

The script uses `t=linspace(-1,1,4000)` and sums `(4/pi)*sin(2*pi*k*t)/k` over odd `k` up to H.

**Explanation:** More odd harmonics approximate the square wave better away from discontinuities. Near abrupt jumps, oscillatory overshoot and undershoot persist; this is the Gibbs phenomenon. Adding harmonics concentrates the oscillations closer to the discontinuity, rather than eliminating the overshoot completely.

**VERIFY after running:** Inspect `exercise-1/square-wave-comparison.png` and describe where the overshoot is most visible.

![Square wave comparison](exercise-1/square-wave-comparison.png)

## Exercise 2 — Find two frequencies with the FFT

**Prediction:** The signal consists of a **15 Hz** sinusoid at amplitude **0.8** and a **40 Hz** sinusoid at amplitude **0.4**.

Sampling uses `fs=200 Hz`, `T=1 s`, and therefore `N=200` samples. The FFT bin spacing is:

`delta_f = fs/N = 200/200 = 1 Hz`.

Because both frequencies are integer multiples of the 1 Hz bin spacing, the single-sided amplitude spectrum should show clear peaks at 15 Hz (~0.8) and 40 Hz (~0.4), subject to numerical roundoff.

**VERIFY after running:** Compare these predicted peaks with the exact MATLAB numbers in `exercise-2/fft_measurements.txt` and the plotted spectrum.

![Time-domain signal](exercise-2/two-frequency-time-domain.png)

![Two-frequency FFT](exercise-2/two-frequency-spectrum.png)

## Exercise 3 — Investigate spectral leakage

**Last student-number digit `d`:** **[REPLACE WITH YOUR DIGIT, 0–9]** (never show your full student number).  
**Your frequency:** `f2 = 13.2 + 0.17*d = [CALCULATE FROM YOUR DIGIT] Hz`.

**Prediction (example):** A non-bin-centered sinusoid spreads its energy across several nearby DFT bins instead of creating just one discrete bin peak. Since the 15 Hz tone and f2 are close, their spectral contributions may overlap.

For `fs=200 Hz`:

| Experiment | Samples | FFT grid spacing | Observation duration |
|---|---:|---:|---:|
| One second, no padding | 200 | 1 Hz | 1 s |
| Four seconds, no padding | 800 | 0.25 Hz | 4 s |
| One second, zero-padded to 800 FFT points | 200 actual + 600 zeros | 0.25 Hz | **Still 1 s** |

**Explanation:** The four-second recording has a longer observation interval, providing finer genuine frequency resolution. Zero-padding the one-second signal makes the plotted FFT smoother and samples the same underlying one-second spectrum on a finer frequency grid; it does not add observed cycles or improve the physical resolution of the original one-second recording. Leakage can remain in both recordings if the tones are not centered on the respective DFT grids.

**VERIFY after running:** Update `d`, `f2`, compare the actual peaks and shapes in the three PNGs, and note any overlap with 15 Hz.

![Leakage comparison](exercise-3/leakage-comparison.png)

## Exercise 4 — Compare DTFT and DFT

Sequence: `x=[1 1 1 1]` with four original time samples.

The DTFT is:

`X(exp(j*w)) = 1 + exp(-j*w) + exp(-j*2*w) + exp(-j*3*w)`.

The 1000-point plot approximates a smooth, continuous DTFT magnitude as a function of angular frequency. The 4-point DFT samples this frequency response at **4** equally spaced frequencies. `fft(x,64)` zero-pads the **same** four time samples, so it produces **64** more closely spaced frequency points but **no new measured signal samples**.

The DTFT magnitude is zero at `w = ±pi/2` and `w = ±pi` within the specified `[-pi,pi]` interval. FFT-based results should match those zeros up to floating-point error.

**VERIFY after running:** Inspect `exercise-4/dtft-dft-comparison.png` and explain how many DFT markers fall along the smooth DTFT curve.

![DTFT-DFT comparison](exercise-4/dtft-dft-comparison.png)

## AI-use disclosure

AI assistance was used to prepare MATLAB code structure, explain Fourier-series/DFT concepts, and draft the README. **MATLAB execution, student-specific parameter selection, plot inspection and final verification must be carried out by the student.**

## Limitations

The plots use synthetic signals and selected sampling settings, so results are illustrative rather than evidence about all real-world signals. A short observation window can prevent separation of nearby tones, and zero-padding does not create information. In the square-wave experiment, finite-harmonic approximations exhibit ringing near discontinuities.

## Files expected after running

```text
lecture-5-fourier-assignment/
├── README.md
├── exercise-1/
│   ├── exercise1.m
│   └── square-wave-comparison.png
├── exercise-2/
│   ├── exercise2.m
│   ├── two-frequency-time-domain.png
│   ├── two-frequency-spectrum.png
│   └── fft_measurements.txt
├── exercise-3/
│   ├── exercise3.m
│   ├── leakage-one-second.png
│   ├── leakage-four-seconds.png
│   ├── leakage-zero-padded.png
│   ├── leakage-comparison.png
│   └── leakage_measurements.txt
└── exercise-4/
    ├── exercise4.m
    └── dtft-dft-comparison.png
```

**Note:** The source scripts and README are provided ready for testing. Images and measurement files in the tree above are created by running MATLAB and are not included as verified MATLAB outputs in the starting ZIP.
