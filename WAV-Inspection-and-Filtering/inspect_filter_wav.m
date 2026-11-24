%% Lecture 6: In-class task — Inspect and filter a WAV file
% This standalone script uses a bundled MATLAB example if no external WAV
% is supplied. It adds a KNOWN 50 Hz hum to create a reproducible example.
% The hum is synthetic; it is not claimed to be present in the clean source.
% Requires Signal Processing Toolbox (butter, filtfilt, spectrogram).
% MATLAB R2026b compatible. Run from any working folder.
clear; clc; close all;

%% Output and source paths
scriptPath = mfilename('fullpath');
if isempty(scriptPath)
    outputDir = fullfile(pwd, 'results');
else
    outputDir = fullfile(fileparts(scriptPath), 'results');
end
if ~exist(outputDir, 'dir'), mkdir(outputDir); end

%% 1. Prepare a reproducible WAV input and read it with audioread
% The original example is distributed with MATLAB. If a teacher-supplied
% WAV file is available, this script can instead be adapted to that file.
example = load('handel.mat');
FsSource = example.Fs;
xClean = double(example.y(:));
xClean = xClean ./ max(1, max(abs(xClean))); % scale reference to <= 1

% Controlled unwanted component: steady 50 Hz electrical hum.
tSource = (0:numel(xClean)-1)' ./ FsSource;
humLevel = 0.12;
xInput = xClean + humLevel*sin(2*pi*50*tSource);
% Keep playback and WAV in range without independently normalizing outputs.
gain = min(1, 0.98/max(abs(xInput)));
xInput = gain*xInput;
xClean = gain*xClean;

inputPath = fullfile(outputDir, 'example_with_50hz_hum.wav');
audiowrite(inputPath, xInput, FsSource);
[x, Fs] = audioread(inputPath);  % Required WAV-loading step
[nSamples, nChannels] = size(x);
duration = nSamples/Fs;

fprintf('WAV sample rate: %d Hz\n', Fs);
fprintf('WAV duration: %.3f s\n', duration);
fprintf('WAV channels: %d\n', nChannels);
fprintf('Unwanted component: synthetic steady 50 Hz hum\n');

% Handel example is mono; average channels only if input source is stereo.
if nChannels > 1
    x = mean(x, 2);
    fprintf('Converted multichannel WAV to mono for analysis.\n');
end
assert(Fs > 102, 'Sampling frequency is too low for 49-51 Hz notch.');

%% 2. Spectrogram and short-time waveform BEFORE filtering
% A narrow band-stop filter is appropriate for a stable 50 Hz tone.
stopBand = [49, 51];
[b,a] = butter(2, stopBand/(Fs/2), 'stop');
yFiltered = filtfilt(b,a,x);  % Offline zero-phase filtering

%% 3. Estimate unwanted 50 Hz tone amplitude before and after
% Least-squares sine/cosine fit at precisely 50 Hz on whole recording.
% This estimates the 50 Hz Fourier component, which may include audio.
t = (0:numel(x)-1)'/Fs;
M = [sin(2*pi*50*t), cos(2*pi*50*t), ones(numel(x),1)];
coefBefore = M\x;
coefAfter = M\yFiltered;
ampBefore = hypot(coefBefore(1),coefBefore(2));
ampAfter = hypot(coefAfter(1),coefAfter(2));
attenuationDB = 20*log10(max(ampAfter,eps)/max(ampBefore,eps));
fprintf('50 Hz fitted amplitude before: %.6f\n',ampBefore);
fprintf('50 Hz fitted amplitude after:  %.6f\n',ampAfter);
fprintf('Measured 50 Hz attenuation: %.2f dB\n',attenuationDB);
fprintf('Filter: order-2 Butterworth band-stop 49-51 Hz with filtfilt\n');

%% 4. Comparison figure: waveform, spectrogram, spectrum
showSec = min(0.25,duration);
nShow = max(2, round(showSec*Fs));
plotTime = (0:nShow-1)/Fs;
waveLim = max(abs([x(1:nShow);yFiltered(1:nShow)]));
waveLim = max(waveLim,0.1);

% Spectrograms use identical parameters and color limits.
winLength = min(1024, max(128, 2^floor(log2(numel(x)/8))));
winLength = min(winLength, numel(x));
overlap = floor(0.75*winLength);
nfftSpec = max(4096, 2^nextpow2(winLength));
[Sx,Fspec,Tspec] = spectrogram(x,hann(winLength,'periodic'),overlap,nfftSpec,Fs);
[Sy,~,~] = spectrogram(yFiltered,hann(winLength,'periodic'),overlap,nfftSpec,Fs);
SxdB = 20*log10(abs(Sx)+eps);
SydB = 20*log10(abs(Sy)+eps);
commonMax = max([SxdB(:);SydB(:)]);
cl = [commonMax-80,commonMax];

fig = figure('Name','WAV inspection and filter comparison','Color','w', ...
    'Position',[120 80 1250 900]);
tiledlayout(3,2,'TileSpacing','compact','Padding','compact');

nexttile;
plot(plotTime,x(1:nShow),'b','LineWidth',1);
grid on; xlabel('Time (s)'); ylabel('Amplitude');
title('Before filtering: hum-added WAV'); ylim([-waveLim waveLim]); xlim([0 showSec]);
nexttile;
plot(plotTime,yFiltered(1:nShow),'r','LineWidth',1);
grid on; xlabel('Time (s)'); ylabel('Amplitude');
title('After 49-51 Hz band-stop filtering'); ylim([-waveLim waveLim]); xlim([0 showSec]);

nexttile;
imagesc(Tspec,Fspec,SxdB); axis xy; ylim([0 min(500,Fs/2)]); clim(cl);
xlabel('Time (s)'); ylabel('Frequency (Hz)'); title('Before: spectrogram'); colorbar;
nexttile;
imagesc(Tspec,Fspec,SydB); axis xy; ylim([0 min(500,Fs/2)]); clim(cl);
xlabel('Time (s)'); ylabel('Frequency (Hz)'); title('After: spectrogram'); colorbar;

% Plot 0-200 Hz FFT amplitudes with consistent axes.
N = numel(x); nHalf=floor(N/2)+1;
f = (0:nHalf-1)'*(Fs/N);
Xmag=abs(fft(x)/N); Ymag=abs(fft(yFiltered)/N);
Xmag=Xmag(1:nHalf); Ymag=Ymag(1:nHalf);
if mod(N,2)==0
    Xmag(2:end-1)=2*Xmag(2:end-1);
    Ymag(2:end-1)=2*Ymag(2:end-1);
else
    Xmag(2:end)=2*Xmag(2:end);
    Ymag(2:end)=2*Ymag(2:end);
end
maxF = min(200,Fs/2);
sel = f<=maxF;
sharedTop = max([Xmag(sel);Ymag(sel)]);
sharedTop = max(sharedTop,1e-6)*1.05;
nexttile;
plot(f(sel),Xmag(sel),'b'); grid on; xlim([0 maxF]); ylim([0 sharedTop]);
xline(50,'--k','50 Hz');
xlabel('Frequency (Hz)'); ylabel('Single-sided amplitude'); title('Before: low-frequency spectrum');
nexttile;
plot(f(sel),Ymag(sel),'r'); grid on; xlim([0 maxF]); ylim([0 sharedTop]);
xline(50,'--k','50 Hz');
xlabel('Frequency (Hz)'); ylabel('Single-sided amplitude'); title('After: low-frequency spectrum');

exportgraphics(fig,fullfile(outputDir,'original_vs_filtered.png'),'Resolution',180);

%% 5. Listening comparison at SAME gain
% Playback is intentional; no auto-normalization is applied to either file.
fprintf('\nListen to the two clips at the same speaker volume.\n');
fprintf('Playing first 5 seconds: hum-added...\n');
playSamples=min(numel(x),5*Fs);
soundscDisabled = true; %#ok<NASGU> % No soundsc: it auto-scales each clip.
sound(x(1:playSamples),Fs);
pause(playSamples/Fs+0.5);
fprintf('Playing first 5 seconds: filtered...\n');
sound(yFiltered(1:playSamples),Fs);
pause(playSamples/Fs+0.5);

%% 6. Save numerical evidence
results = table(Fs,duration,nChannels,49,51,ampBefore,ampAfter,attenuationDB, ...
    'VariableNames',{'SampleRate_Hz','Duration_s','Channels','StopLow_Hz','StopHigh_Hz', ...
    'Measured50HzBefore','Measured50HzAfter','Attenuation_dB'});
writetable(results,fullfile(outputDir,'filter_measurements.csv'));
fprintf('\nCompleted. Figure: %s\n',fullfile(outputDir,'original_vs_filtered.png'));
fprintf('Measurement table: %s\n',fullfile(outputDir,'filter_measurements.csv'));
fprintf('Review the plots and listen before concluding that useful audio is preserved.\n');
