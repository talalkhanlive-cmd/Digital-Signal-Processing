%% Lecture 02 - Sampling and Aliasing Investigation
% Digital Signal Processing | 10 Hz vibration signal
% Run this script from any MATLAB working directory.
% Figures are saved in the same folder as this script.
clear; clc; close all;

scriptPath = mfilename('fullpath');
if isempty(scriptPath)
    outputDir = pwd;
else
    outputDir = fileparts(scriptPath);
end

fSignal = 10;             % Hz
T = 1;                    % seconds
fsReference = 10000;      % Hz, dense reference for visual comparison
tRef = 0:1/fsReference:T;
xRef = sin(2*pi*fSignal*tRef);
fsList = [15, 20, 25, 50, 100];

%% Task 1 - Reference signal
fig = figure('Name','Original 10 Hz signal','Color','w','Position',[100 100 1100 420]);
plot(tRef,xRef,'b-','LineWidth',1.4);
grid on; xlim([0 T]); ylim([-1.2 1.2]);
xlabel('Time (s)'); ylabel('Amplitude');
title('Original 10 Hz sine wave (dense time reference)');
legend('10 Hz reference signal','Location','northeast');
exportgraphics(fig,fullfile(outputDir,'original_signal.png'),'Resolution',180);

%% Task 2 - Sampling comparisons: one composite and five individual figures
figAll = figure('Name','Sampling frequency comparison','Color','w','Position',[100 100 1150 1450]);
for idx = 1:numel(fsList)
    fs = fsList(idx);
    ts = 0:1/fs:T-1/fs;       % Exactly one second: N = fs samples
    xs = sin(2*pi*fSignal*ts);
    figure(figAll);
    subplot(5,1,idx);
    plot(tRef,xRef,'b-','LineWidth',1.0); hold on;
    stem(ts,xs,'r','filled','LineWidth',1.0,'MarkerSize',3);
    hold off; grid on;
    xlim([0 T]); ylim([-1.25 1.25]);
    xlabel('Time (s)'); ylabel('Amplitude');
    title(sprintf('Sampling at %d Hz (%d samples in 1 s)', fs, numel(ts)));
    legend('10 Hz reference','Samples','Location','northeast');

    figSingle = figure('Name',sprintf('Sampling %d Hz',fs),'Color','w','Position',[100 100 1050 420]);
    plot(tRef,xRef,'b-','LineWidth',1.2); hold on;
    stem(ts,xs,'r','filled','LineWidth',1.1,'MarkerSize',4);
    hold off; grid on;
    xlim([0 T]); ylim([-1.25 1.25]);
    xlabel('Time (s)'); ylabel('Amplitude');
    title(sprintf('10 Hz sine wave sampled at %d Hz',fs));
    legend('10 Hz reference','Sampled points','Location','northeast');
    exportgraphics(figSingle, fullfile(outputDir,sprintf('sampling_%dHz.png',fs)),'Resolution',180);
    close(figSingle);
end
figure(figAll);
sgtitle('Sampling and aliasing: original 10 Hz signal versus sampled values');
exportgraphics(figAll, fullfile(outputDir,'sampling_comparison.png'),'Resolution',180);

%% Tasks 3-4 - Nyquist and engineering interpretation
fprintf('\n=== Lecture 02: Sampling and Aliasing ===\n');
fprintf('Signal frequency: %g Hz; theoretical Nyquist rate: 2*%g = %g Hz\n',fSignal,fSignal,2*fSignal);
for fs = fsList
    fprintf('Fs = %3d Hz | Ts = %8.5f s | N = %3d | above Nyquist: %s\n', ...
        fs,1/fs,fs,string(fs > 2*fSignal));
end
fprintf('\n15 Hz: alias of 10 Hz appears at 5 Hz (with phase/sign difference).\n');
fprintf('20 Hz: samples of a zero-phase 10 Hz sine are all approximately zero.\n');
fprintf('25, 50, 100 Hz: satisfy strict >20 Hz criterion; higher rates provide denser samples.\n');
fprintf('Recommended among tested rates: 100 Hz when data/memory/bandwidth permit.\n');
fprintf('All images saved to: %s\n',outputDir);
