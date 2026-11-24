%% Lecture 6 - Practical Digital Filtering: FIR/IIR Sensor + Audio Hum
% Part A follows the specified synthetic signal and filters exactly.
% Part B uses the built-in Handel sample if available.
% MATLAB Signal Processing Toolbox required.
% Run from the folder containing THIS script, with write permission.
clear; clc; close all;

% Outputs are saved beside this script (NOT in a temporary Editor directory).
projectDir = fileparts(mfilename('fullpath'));
if isempty(projectDir), projectDir = pwd; end
outDir = fullfile(projectDir, 'results');
if ~exist(outDir,'dir'), mkdir(outDir); end
fprintf('MATLAB version: %s\n', version);
fprintf('Signal Processing Toolbox installed: %d\n', license('test','signal_toolbox'));
assert(license('test','signal_toolbox') == 1, 'Signal Processing Toolbox is required.');

%% Part A 1 - Create sensor signal (exact assignment settings)
FsSensor = 1000;
t = (0:1/FsSensor:2-1/FsSensor)';
rng(7);
clean = sin(2*pi*5*t) + 0.35*sin(2*pi*12*t);
noise = 0.35*sin(2*pi*50*t) + 0.20*sin(2*pi*137*t) + 0.25*randn(size(t));
x = clean + noise;

%% Part A 2 - Filter designs, zero-phase offline processing
fc = 20;
bFIR = fir1(60, fc/(FsSensor/2), 'low');
[bIIR,aIIR] = butter(4, fc/(FsSensor/2), 'low');
yFIR = filtfilt(bFIR, 1, x);
yIIR = filtfilt(bIIR, aIIR, x);

%% Part A 3 - Time-domain comparison (same axes, units)
select = t <= 0.2;
fig = figure('Color','w','Name','Sensor: time-domain comparison');
plot(t(select),clean(select),'k','LineWidth',1.3); hold on;
plot(t(select),x(select),'Color',[0.65 0.65 0.65]);
plot(t(select),yFIR(select),'b','LineWidth',1.2);
plot(t(select),yIIR(select),'r--','LineWidth',1.2);
xlabel('Time (s)'); ylabel('Sensor amplitude (arbitrary units)');
title('Part A: sensor signals, first 0.2 seconds');
legend('Clean reference','Noisy input','FIR filtfilt','IIR filtfilt','Location','best'); grid on;
exportgraphics(fig,fullfile(outDir,'01_sensor_time.png'),'Resolution',180);

%% Part A 4 - Frequency response of one-pass filters
[HFIR,fResp] = freqz(bFIR,1,4096,FsSensor);
[HIIR,~] = freqz(bIIR,aIIR,4096,FsSensor);
fig=figure('Color','w','Name','Sensor: frequency response');
plot(fResp,20*log10(max(abs(HFIR),1e-12)),'b','LineWidth',1.3); hold on;
plot(fResp,20*log10(max(abs(HIIR),1e-12)),'r--','LineWidth',1.3);
xline(fc,':k','20 Hz cutoff');
xlim([0 180]); ylim([-110 5]); grid on;
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
title('Part A: single-pass frequency responses (filtfilt squares magnitude)');
legend('FIR order 60, 61 taps','Butterworth IIR order 4','Location','southwest');
exportgraphics(fig,fullfile(outDir,'02_sensor_frequency_responses.png'),'Resolution',180);

%% Part A 5 - Single-sided amplitude spectra
N=length(x); fSensor=(0:floor(N/2))'*FsSensor/N;
SX=abs(fft(x)/N); SF=abs(fft(yFIR)/N); SI=abs(fft(yIIR)/N);
SX=SX(1:numel(fSensor)); SF=SF(1:numel(fSensor)); SI=SI(1:numel(fSensor));
if rem(N,2)==0, ids=2:numel(fSensor)-1; else, ids=2:numel(fSensor); end
SX(ids)=2*SX(ids); SF(ids)=2*SF(ids); SI(ids)=2*SI(ids);
fig=figure('Color','w','Name','Sensor: spectra');
plot(fSensor,SX,'Color',[0.5 0.5 0.5]); hold on;
plot(fSensor,SF,'b','LineWidth',1.1);
plot(fSensor,SI,'r--','LineWidth',1.1);
xlim([0 165]); grid on;
xlabel('Frequency (Hz)'); ylabel('Single-sided amplitude (arbitrary units)');
title('Part A: FFT amplitude spectrum');
legend('Noisy','FIR output','IIR output','Location','northeast');
exportgraphics(fig,fullfile(outDir,'03_sensor_spectra.png'),'Resolution',180);

%% Part A 6 - RMSE and selected frequency amplitudes
rmse = @(v,ref) sqrt(mean((v(:)-ref(:)).^2));
methodA = ["Noisy input";"FIR filtfilt";"IIR filtfilt"];
rmseA = [rmse(x,clean);rmse(yFIR,clean);rmse(yIIR,clean)];
rmseTable = table(methodA,rmseA,'VariableNames',{'Method','RMSE'});
writetable(rmseTable,fullfile(outDir,'sensor_rmse.csv'));
disp('Part A sensor RMSE:'); disp(rmseTable);
keyHz = [5 12 50 137]';
ampX=zeros(numel(keyHz),1); ampF=ampX; ampI=ampX;
for k=1:numel(keyHz)
    [~,ind]=min(abs(fSensor-keyHz(k)));
    ampX(k)=SX(ind); ampF(k)=SF(ind); ampI(k)=SI(ind);
end
ampTable = table(keyHz,ampX,ampF,ampI,'VariableNames',...
    {'Frequency_Hz','NoisyAmplitude','FIRAmplitude','IIRAmplitude'});
writetable(ampTable,fullfile(outDir,'sensor_frequency_amplitudes.csv'));
disp('Part A amplitude at requested frequencies:'); disp(ampTable);

%% Part B 1 - Load Handel audio with its OWN sampling frequency
% MATLAB's built-in Handel sample is commonly accessible with load handel.
% If missing, MATLAB will report an error; do not substitute unrelated audio silently.
try
    handelData = load('handel.mat','y','Fs');
    xClean = handelData.y(:);
    FsAudio = handelData.Fs;
catch ME
    error(['Built-in Handel audio was not found: ' ME.message newline ...
        'Provide a licensed audio file and explicitly adapt the loading section.']);
end
assert(FsAudio>102,'Audio Fs must exceed 102 Hz for [49 51] Hz stop band.');
tAudio=(0:numel(xClean)-1)'/FsAudio;
xHum=xClean + 0.15*sin(2*pi*50*tAudio);

%% Part B 2 - Narrow and wide Butterworth band-stop comparisons
[bN,aN] = butter(2,[49 51]/(FsAudio/2),'stop');
[bW,aW] = butter(2,[45 55]/(FsAudio/2),'stop');
yAudio = filtfilt(bN,aN,xHum);
yWide  = filtfilt(bW,aW,xHum);

%% Part B 3 - Identical time interval and axes
idxAudio=tAudio<=0.1;
fig=figure('Color','w','Name','Audio: waveform comparison');
plot(tAudio(idxAudio),xClean(idxAudio),'k'); hold on;
plot(tAudio(idxAudio),xHum(idxAudio),'Color',[0.6 0.6 0.6]);
plot(tAudio(idxAudio),yAudio(idxAudio),'b','LineWidth',1.1);
plot(tAudio(idxAudio),yWide(idxAudio),'r--','LineWidth',1.1);
xlabel('Time (s)'); ylabel('Amplitude (linear audio units)'); grid on;
title('Part B: first 0.1 s (same scales)');
legend('Clean','Hum-added','49-51 Hz notch','45-55 Hz notch','Location','best');
exportgraphics(fig,fullfile(outDir,'04_audio_waveforms.png'),'Resolution',180);

%% Part B 4 - Comparable single-sided spectra; no normalization per recording
Na=numel(xClean); fAudio=(0:floor(Na/2))'*FsAudio/Na;
specData=[xClean xHum yAudio yWide];
specMag=zeros(numel(fAudio),4);
for j=1:4
    tmp=abs(fft(specData(:,j))/Na);
    tmp=tmp(1:numel(fAudio));
    if rem(Na,2)==0, ii=2:numel(tmp)-1; else, ii=2:numel(tmp); end
    tmp(ii)=2*tmp(ii); specMag(:,j)=tmp;
end
fig=figure('Color','w','Name','Audio: low-frequency spectrum');
plot(fAudio,specMag(:,1),'k'); hold on;
plot(fAudio,specMag(:,2),'Color',[0.55 0.55 0.55]);
plot(fAudio,specMag(:,3),'b','LineWidth',1.2);
plot(fAudio,specMag(:,4),'r--','LineWidth',1.2);
xlim([20 90]); xlabel('Frequency (Hz)');
ylabel('Single-sided amplitude (linear audio units)'); grid on;
title('Part B: low-frequency audio spectrum, no per-curve normalization');
xline(50,':k','50 Hz');
legend('Clean','Hum-added','49-51 Hz','45-55 Hz','Location','northeast');
exportgraphics(fig,fullfile(outDir,'05_audio_spectra.png'),'Resolution',180);

%% Part B 5 - Filter response + attenuation at 50 Hz
[HN,fNotch]=freqz(bN,aN,8192,FsAudio);
[HW,~]=freqz(bW,aW,8192,FsAudio);
fig=figure('Color','w','Name','Audio: notch designs');
plot(fNotch,20*log10(max(abs(HN),1e-12)),'b','LineWidth',1.2); hold on;
plot(fNotch,20*log10(max(abs(HW),1e-12)),'r--','LineWidth',1.2);
xlim([35 65]); ylim([-90 5]); grid on;
xlabel('Frequency (Hz)'); ylabel('Single-pass magnitude (dB)');
title('Part B: narrow versus wide band-stop filters');
legend('49-51 Hz','45-55 Hz','Location','southwest');
exportgraphics(fig,fullfile(outDir,'06_audio_notch_response.png'),'Resolution',180);

% 50-Hz amplitude measurement via least-squares fit of sin/cos plus DC.
% Unlike selecting one FFT bin, this measures exactly 50 Hz even when the
% recording does not contain an integer number of 50 Hz cycles.
A50=[sin(2*pi*50*tAudio),cos(2*pi*50*tAudio),ones(size(tAudio))];
amplitude50=zeros(4,1);
for j=1:4
    beta=A50\specData(:,j);
    amplitude50(j)=hypot(beta(1),beta(2));
end
labels50=["Clean reference";"Hum-added";"49-51 Hz notch";"45-55 Hz notch"];
amp50Table=table(labels50,amplitude50,'VariableNames',{'Method','AmplitudeAt50Hz'});
writetable(amp50Table,fullfile(outDir,'audio_50hz_amplitudes.csv'));
disp('Part B: 50 Hz sine/cosine projection amplitude:'); disp(amp50Table);
if amplitude50(2)>0
    fprintf('49-51 Hz notch measured 50-Hz amplitude reduction: %.3f dB\n',...
        20*log10(max(amplitude50(3),eps)/amplitude50(2)));
    fprintf('45-55 Hz notch measured 50-Hz amplitude reduction: %.3f dB\n',...
        20*log10(max(amplitude50(4),eps)/amplitude50(2)));
end

%% Part B 6 - Listening experiment at the SAME gain
% The script does not automatically play audio. Set playAudio=true and rerun
% after checking your computer's speaker volume. Do not use soundsc separately:
% it would change the playback gain between recordings.
playAudio = false;
if playAudio
    commonGain=max([1;abs(xHum);abs(yAudio);abs(yWide)]);
    fprintf('Playing hum-added audio; next is narrow-notch filtered audio.\n');
    sound(xHum/commonGain,FsAudio);
    pause(numel(xHum)/FsAudio + 0.6);
    sound(yAudio/commonGain,FsAudio);
end

%% Summary
fprintf('\nAll calculations finished. Figures and CSVs saved in:\n%s\n',outDir);
fprintf(['Review figures, listen at matching gain, and enter your own ' ...
         'measured values/observations in REPORT.md before submission.\n']);
ver
