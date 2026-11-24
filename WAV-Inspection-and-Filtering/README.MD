# In-class Task: Inspect and Filter a WAV File

## Objective

Inspect a WAV recording and reduce an unwanted component with a suitable digital filter, then compare the waveform, spectrogram, and spectral amplitude before and after filtering.

## Recording and unwanted sound

The script uses the **Handel example** included with MATLAB. To make the experiment reproducible without a separate teacher-provided recording, it deliberately adds a **synthetic 50 Hz sinusoidal hum** and saves the resulting WAV file. The hum is **added for the experiment**, not claimed to be naturally present in the example.

The script uses `audioread` to load that WAV and reports its sample rate, duration, and channel count.

## Filter design

- **Type:** 2nd-order Butterworth band-stop filter
- **Stop band:** 49–51 Hz
- **Application:** `filtfilt` for offline forward–backward filtering, avoiding a net phase shift
- **Reason:** A narrow band-stop targets a stable electrical-hum tone while limiting the frequencies removed from the rest of the recording.

## Evidence and comparison

Running `inspect_filter_wav.m` creates `results/original_vs_filtered.png`, showing original and filtered time-domain waveforms, spectrograms, and single-sided frequency spectra. The before/after comparisons use matching waveform limits, spectrogram color scales, and spectrum amplitude axes.

It also creates `results/filter_measurements.csv` with the sample rate, duration, channel count, fitted 50 Hz amplitudes, and attenuation in dB. The **50 Hz amplitude is estimated by least-squares fitting sine and cosine components** at 50 Hz across the whole recording. This measure can include any real audio energy at exactly 50 Hz.

## Interpretation

A 49–51 Hz band-stop filter is expected to reduce the steady added 50 Hz component. Because the filter suppresses energy in that band regardless of its source, legitimate low-frequency audio near 50 Hz may also be changed. Inspect the saved figure and listen to both clips at the **same playback gain** to determine how much the hum was reduced and whether the useful recording remains recognizable.

The graph and measurement results should be inspected after running the script; successful preservation of useful audio cannot be established from the filter specification alone.

## Files

- `inspect_filter_wav.m` — complete MATLAB experiment
- `results/original_vs_filtered.png` — generated comparison figure
- `results/filter_measurements.csv` — generated numerical evidence
- `results/example_with_50hz_hum.wav` — temporary example input, **not needed for submission**

The WAV example is generated locally when the script runs. The assignment only requires submitting the `.m` script, one comparison figure and a short explanation; do not upload the WAV file unless requested.

## Requirements

