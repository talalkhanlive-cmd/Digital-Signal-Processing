# Practical Digital Filtering — FIR/IIR Sensor and Audio Hum

**Report status:** Draft for verification. Replace bracketed measurements and listening observations after running `digital_filtering_assignment.m` in MATLAB. Do not submit the draft as if measurements were verified.

## 1. Objective and method

This experiment compares an FIR low-pass filter and a Butterworth IIR low-pass filter on a **known synthetic sensor signal**. A separate experiment uses a narrow 50 Hz band-stop filter to reduce controlled hum added to the built-in Handel recording. Both parts use `filtfilt` for an **offline, forward-backward, zero-phase** comparison; the effective magnitude response is the squared one-pass magnitude response.

**Software:** MATLAB version: [copy console output]. Signal Processing Toolbox availability: [copy console output].

### Part A: controlled sensor signal

The sampling rate is **1000 Hz**, the duration is **2 s**, and the clean reference is `sin(2π5t) + 0.35sin(2π12t)`. Added interference is a 50 Hz sinusoid of amplitude 0.35, a 137 Hz sinusoid of amplitude 0.20, and Gaussian noise with standard deviation 0.25, using `rng(7)`. The filters are a **60th-order FIR** (61 coefficients) designed by `fir1` and a **4th-order Butterworth IIR** designed by `butter`, both specified at 20 Hz. Both are applied with `filtfilt`.

**Prediction:** The 5 Hz and 12 Hz terms should be retained more strongly than the 50 Hz and 137 Hz components. Both filters should suppress high-frequency random noise. Because 12 Hz is closer to the 20 Hz cutoff than 5 Hz, it may also be affected; this must be checked in the measured spectrum.

## 2. Part A results

**Figure A1:** `results/01_sensor_time.png` — Clean, noisy, FIR and IIR curves for the first 0.2 s, on identical axes. **Figure A2:** `results/02_sensor_frequency_responses.png` — Single-pass magnitude response in dB with 20 Hz marked. **Figure A3:** `results/03_sensor_spectra.png` — Single-sided amplitude spectrum.

### RMSE against known reference

Use values from `results/sensor_rmse.csv`:

| Signal | RMSE |
|---|---:|
| Noisy input | [insert MATLAB value] |
| FIR output | [insert MATLAB value] |
| IIR output | [insert MATLAB value] |

At 5, 12, 50, and 137 Hz, copy and discuss the spectral amplitudes from `results/sensor_frequency_amplitudes.csv`. Identify which design best preserves the two desired components and reduces the two interference frequencies in your actual output.

**RMSE interpretation:** RMSE is the square root of the average squared pointwise error relative to the known clean signal. Smaller RMSE means a closer sample-by-sample match on this synthetic example, but not necessarily better subjective quality, phase behavior, preservation of particular features, or performance on real sensor data.

**Trade-off discussion:** A 61-tap FIR gives a finite impulse response with potentially linear one-pass phase, while the order-4 Butterworth IIR uses a recursive denominator and fewer coefficients. Their roll-off and transition-band behavior are not identical; `filtfilt` avoids intentional phase delay but doubles the effective filter order and requires noncausal processing. Check startup/end regions for differences caused by padding and transient behavior. For a streaming implementation, a causal FIR may be attractive for guaranteed stability and predictable delay, while a causal IIR can offer efficient filtering with few coefficients if nonlinear phase is acceptable.

**Measured Part A conclusion:** [Which filter had lower RMSE? Give values and refer to spectrum/response evidence.]

## 3. Part B: controlled audio hum

The example uses the MATLAB Handel recording with its supplied sample rate `Fs`. The experiment adds `0.15*sin(2π50t)` to the clean audio and uses two second-order Butterworth band-stop designs with stop bands **49–51 Hz** and **45–55 Hz**. Each filter is applied with `filtfilt`.

**Figure B1:** `results/04_audio_waveforms.png` — Same 0.1 s section before and after filtering; identical plot axes. **Figure B2:** `results/05_audio_spectra.png` — Low-frequency spectrum with the 50 Hz frequency marked. **Figure B3:** `results/06_audio_notch_response.png` — Filter attenuation and passband trade-off.

### Measurement method

To estimate the amplitude at exactly 50 Hz, the script fits **a sine, cosine, and constant offset** by least squares over the same recording interval. This avoids attributing the entire result to a single nearest FFT bin when the recording length is not coherent with 50 Hz. The value still includes any actual 50 Hz content already present in the clean recording; it does not isolate injected hum perfectly.

| Recording | Fitted 50 Hz amplitude |
|---|---:|
| Clean reference | [insert] |
| Hum-added | [insert] |
| Narrow notch, 49–51 Hz | [insert] |
| Wide notch, 45–55 Hz | [insert] |

Copy numbers from `results/audio_50hz_amplitudes.csv`. Calculate measured attenuation as **20 log10(filtered 50 Hz amplitude / hum-added 50 Hz amplitude)** dB. A negative number indicates reduction.

**Listening test — REQUIRED:** Run the script with `playAudio = true` after setting safe speaker volume. It plays the hum-added and narrow-filtered signals at one common gain. Record what you actually heard: [your observations]. Do **not** claim that the hum was audibly reduced or that music quality was unchanged without listening.

**Narrow vs wide:** A narrow 49–51 Hz notch can target a stable 50 Hz tone while removing less nearby audio content. A 45–55 Hz filter is more tolerant of frequency drift but can suppress useful low-frequency signal energy across a wider region.

## 4. Answers to five report questions

**1. Why 20 Hz?** The wanted components are 5 and 12 Hz; a low-pass at 20 Hz aims to retain those while attenuating 50 Hz and 137 Hz interference. It assumes the useful sensor information is concentrated below 20 Hz.

**2. Which filter is better?** [Select after verifying RMSE and frequency-domain attenuation. Cite at least two different measurements/figures.]

**3. What changes for live filtering?** `filtfilt` needs future samples and is unsuitable for strict real-time, low-latency processing. Use causal `filter`/streaming filter states, assess group delay and phase distortion, and balance filter order against delay and computing cost.

**4. Why a narrow 50 Hz notch?** A stable tone occupies a small frequency region, so a narrow stop band can remove it with less spectral collateral damage. For drift, widen the band slightly or track frequency using an adaptive notch; quantify additional loss of useful audio.

**5. Limitation and improvement:** A synthetic sensor reference and artificially added hum make errors measurable but simplify real interference, changing signal statistics, nonlinear sensor effects, and hum drift. A more realistic study would use multiple recordings/sensors, drift scenarios, boundary analyses, and held-out examples.

## 5. Reproducibility and AI assistance

Run `digital_filtering_assignment.m` from its project folder using MATLAB with Signal Processing Toolbox. The script saves six figures and three CSV files under `results/`; the playback test is opt-in. Sample rates and filter parameters are written in code and figure labels. **AI assistance:** AI was used to help structure the MATLAB code and this report draft. The student is responsible for execution, checking numerical results, writing actual listening observations, and explaining the work.
