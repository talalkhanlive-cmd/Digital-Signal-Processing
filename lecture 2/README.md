# Lecture 02 – Sampling and Aliasing

## Objective

Investigate how different sampling rates represent a 10 Hz sine-wave vibration measurement over one second. Compare the sampled values with a dense time reference and assess aliasing and practical sampling choices.

## MATLAB script and figures

Run `Lecture02_sampling_aliasing.m` in MATLAB. The script saves `original_signal.png`, five figures named `sampling_15Hz.png` through `sampling_100Hz.png`, and an additional `sampling_comparison.png` showing all five cases. All figures are saved beside the script. The reference uses 10,000 samples per second for plotting; this dense reference is not an analog measurement.

## Nyquist Analysis

The highest signal frequency is **10 Hz**, so the theoretical Nyquist rate is:

\[
f_s \geq 2f_{max} = 2 \times 10 = 20\ \text{Hz}.
\]

- **15 Hz:** below the theoretical limit; aliasing occurs.
- **20 Hz:** exactly at the limit; it meets the numerical Nyquist-rate boundary, but this particular zero-phase 10 Hz sine sampled at `t = n/20` gives `sin(πn) = 0` at every sample. Therefore, the samples cannot reveal the actual oscillation reliably.
- **25 Hz, 50 Hz, 100 Hz:** above the limit; the sampled frequencies are not aliased for the given 10 Hz sinusoid.

Sampling *exactly* at the Nyquist rate is not recommended for this practical task. Phase dependence, limited samples per cycle, uncertainty in the highest signal frequency, and real-world anti-aliasing filter transitions favor a margin above 20 Hz.

## Results

| Sampling rate | Samples per cycle (fs/10) | Observation |
|---|---:|---|
| 15 Hz | 1.5 | Insufficient samples. The 10 Hz tone aliases to an apparent 5 Hz discrete-time oscillation (up to phase/sign). |
| 20 Hz | 2 | The selected zero-phase sine samples at its zeros and appears flat, even though the original oscillates. |
| 25 Hz | 2.5 | Above Nyquist but relatively sparse; shape is less visually intuitive. |
| 50 Hz | 5 | Clearer outline of the original 10 Hz signal. |
| 100 Hz | 10 | Dense sampling closely follows the oscillation in the plot. |

These are analytically expected observations; compare them with the PNGs generated when the MATLAB script is run.

## Aliasing Discussion (under 200 words)

Aliasing occurs at **15 Hz** because the 10 Hz signal is above the sampling system's 7.5 Hz Nyquist frequency. Its samples can be interpreted as a lower-frequency 5 Hz oscillation, which is not the actual source frequency. At **20 Hz**, the sample rate equals the Nyquist rate: the selected sine phase produces only zero-valued samples, demonstrating why sampling at the theoretical boundary is fragile. At **25, 50, and 100 Hz**, a 10 Hz sine is below the corresponding Nyquist frequencies, so this single tone is not aliased. If real vibration measurements contain frequencies higher than expected, they can still alias unless an analog anti-aliasing filter limits the input bandwidth before conversion. For this particular test, **100 Hz** offers ten samples per cycle and a useful margin above the 10 Hz signal. The trade-off is more samples to store, transfer, and process than with 25 or 50 Hz sampling.

## Engineering Recommendation

For the stated single 10 Hz component, choose **100 Hz** from the tested rates where storage and processing requirements allow. It provides ten samples per cycle and more margin for small variations in frequency. In a real machine-monitoring system, first measure the highest relevant vibration frequency, then choose the sample rate and analog anti-aliasing filter together. A 100 Hz sampling rate is **not** automatically sufficient for a machine with significant vibration components above 50 Hz.

## Verification

The MATLAB script uses `sin(2*pi*10*t)`, generates exactly one second of samples at each required sample rate, prints the Nyquist-rate calculation, and saves labeled time-domain figures. Confirm the five sampling rates and the resulting figures in MATLAB before submission.

## AI Usage

- **AI tool used:** ChatGPT.
- **Prompt summary:** Prepare MATLAB code and a README for the supplied Lecture 02 sampling and aliasing assignment.
- **Response summary:** Proposed code for plotting a 10 Hz reference signal and five sample-rate comparisons, plus Nyquist and aliasing explanations.
- **What I modified:** [Fill in only changes you actually made after reviewing and running the script.]
- **How I verified the results:** [After running MATLAB, describe the plots you checked and the calculations you confirmed.]

The two bracketed entries must be completed based on your own actions before submitting.
