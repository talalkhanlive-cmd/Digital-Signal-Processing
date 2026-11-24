%% Lecture 02 - Hearing and Seeing Aliasing
% Self-contained experiment: 7 kHz tone sampled at several rates.
% No Signal Processing Toolbox is required.
% Run this script in MATLAB. It saves figures in the same folder.
clear; close all; clc;

f0 = 7000;                 % original tone (Hz)
duration = 0.08;           % duration for experiment (seconds)
fsList = [48000 16000 12000 8000];
labels = {'48 kHz (reference)','16 kHz','12 kHz','8 kHz'};

% Use a deterministic tone. Generate each sampled version from its
% continuous-time formula, rather than resampling with anti-alias filters.
% This intentionally illustrates aliasing when sample rate is too low.

tRef = (0:round(duration*fsList(1))-1)' / fsList(1);
xRef = sin(2*pi*f0*tRef);

fprintf('LECTURE 02: HEARING AND SEEING ALIASING\n');
fprintf('Original tone: %.0f Hz | Duration: %.3f s\n',f0,duration);
fprintf('Nyquist requirement for an unambiguous 7 kHz tone: Fs > %.0f Hz\n\n', 2*f0);

%% Figure 1: waveform comparison, zoomed to 2 milliseconds
figure('Name','Sampled waveforms','Color','w','Position',[100 100 1000 700]);
tileDur = 0.002;
for i = 1:numel(fsList)
    fs = fsList(i);
    t = (0:round(duration*fs)-1)' / fs;
    x = sin(2*pi*f0*t);
    expectedAlias = abs(f0 - round(f0/fs)*fs);
    subplot(2,2,i);
    plot(tRef*1000,xRef,'Color',[0.65 0.65 0.65],'LineWidth',1.1); hold on;
    stem(t*1000,x,'filled','MarkerSize',3,'LineWidth',1);
    xlim([0 tileDur*1000]); ylim([-1.2 1.2]); grid on;
    title(sprintf('%s: apparent %.0f Hz',labels{i},expectedAlias));
    xlabel('Time (ms)'); ylabel('Amplitude');
    legend('7 kHz continuous-reference view','Sampled values','Location','best');
end
sgtitle('7 kHz tone sampled at different frequencies');
exportgraphics(gcf,'sampled_waveforms.png','Resolution',170);

%% Figure 2: one-sided amplitude spectra
figure('Name','FFT comparison','Color','w','Position',[130 130 1000 700]);
for i = 1:numel(fsList)
    fs = fsList(i);
    t = (0:round(duration*fs)-1)' / fs;
    x = sin(2*pi*f0*t);
    n = length(x);
    spectrum = abs(fft(x))/n;
    amp = spectrum(1:floor(n/2)+1);
    if mod(n,2)==0
        amp(2:end-1) = 2*amp(2:end-1);
    else
        amp(2:end) = 2*amp(2:end);
    end
    f = (0:floor(n/2))'*fs/n;
    [~,idx] = max(amp);
    fprintf('Fs = %5d Hz | Nyquist = %5d Hz | peak = %7.1f Hz | amplitude = %.3f\n', ...
        fs,fs/2,f(idx),amp(idx));
    subplot(2,2,i);
    plot(f,amp,'LineWidth',1.2); grid on;
    xlim([0 fs/2]); ylim([0 1.15]);
    xlabel('Frequency (Hz)'); ylabel('Single-sided amplitude');
    title(sprintf('%s: FFT peak %.0f Hz',labels{i},f(idx)));
end
sgtitle('Frequency changes caused by undersampling (without anti-alias filtering)');
exportgraphics(gcf,'aliasing_spectra.png','Resolution',170);

%% Figure 3: summary comparison
aliasFreqs = zeros(size(fsList));
for i = 1:numel(fsList)
    aliasFreqs(i) = abs(f0 - round(f0/fsList(i))*fsList(i));
end
figure('Name','Aliasing summary','Color','w');
bar(categorical(labels),aliasFreqs); grid on;
ylabel('Apparent (aliased) frequency (Hz)');
title('Apparent frequency of 7 kHz tone at each sampling rate');
exportgraphics(gcf,'aliasing_summary.png','Resolution',170);

%% Playback: listen at each signal's actual sample rate
% Playback is optional in case speakers are not available.
% Keep the same numeric amplitude (and volume setting) for fair comparison.
% A 7 kHz tone may be difficult to hear depending on age and speakers.
playAudio = true;
if playAudio
    fprintf('\nPlaying 4 tones. Lower your speaker volume before running.\n');
    for i = 1:numel(fsList)
        fs = fsList(i);
        t = (0:round(duration*fs)-1)' / fs;
        x = 0.15*sin(2*pi*f0*t); % safe starting amplitude
        fprintf('Playing %s\n',labels{i});
        sound(x,fs);
        pause(duration+0.35);
    end
end
fprintf('\nGenerated: sampled_waveforms.png, aliasing_spectra.png, aliasing_summary.png\n');
