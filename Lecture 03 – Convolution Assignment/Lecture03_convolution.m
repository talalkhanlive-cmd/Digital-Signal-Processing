%% Lecture 03 - Discrete-Time Signal Operations and Convolution
% Run this script from any working directory. Output images are saved next
% to the script, ready for GitHub upload.
clear; close all; clc;
rng(1);

% Resolve this script's folder, regardless of MATLAB's current folder.
scriptPath = mfilename('fullpath');
if isempty(scriptPath)
    outputDir = pwd;
else
    outputDir = fileparts(scriptPath);
end

%% Original signal and measurement noise
n = 0:100;
clean = sin(0.1*pi*n);
noise = 0.4*randn(size(n));
measured = clean + noise;

figure('Color','w','Name','Clean and noisy signals');
plot(n, clean, 'b-', 'LineWidth', 1.6); hold on;
plot(n, measured, '-', 'Color', [0.55 0.55 0.55]);
grid on; xlabel('Sample index n'); ylabel('Amplitude');
title('Clean and Noisy Discrete-Time Signals');
legend('Clean signal','Noisy measured signal','Location','best');
exportgraphics(gcf, fullfile(outputDir,'clean_noisy.png'), 'Resolution', 180);

%% Task 1: amplitude scaling by 2
scaled = 2*measured;
figure('Color','w','Name','Amplitude scaling');
plot(n, measured, 'Color', [0.40 0.40 0.40], 'LineWidth', 1.2); hold on;
plot(n, scaled, 'r-', 'LineWidth', 1.25);
grid on; xlabel('Sample index n'); ylabel('Amplitude');
title('Task 1: Amplitude Scaling by a Factor of Two');
legend('Noisy signal','Scaled signal (2 x amplitude)','Location','best');
exportgraphics(gcf, fullfile(outputDir,'signal_operations.png'), 'Resolution', 180);

%% Task 2: delay by five samples (zero-padding at the start)
delay = 5;
delayed = [zeros(1,delay), measured];
n_measured = 0:length(measured)-1;
n_delayed = 0:length(delayed)-1;
figure('Color','w','Name','Five-sample delay');
plot(n_measured, measured, 'Color',[0.40 0.40 0.40], 'LineWidth',1.1); hold on;
plot(n_delayed, delayed, 'm-', 'LineWidth',1.1);
grid on; xlabel('Sample index n'); ylabel('Amplitude');
title('Task 2: Signal Delayed by Five Samples');
legend('Original noisy signal','Delayed signal','Location','best');
exportgraphics(gcf, fullfile(outputDir,'signal_delay.png'), 'Resolution', 180);

%% Task 3: five-point moving average using convolution
h5 = ones(1,5)/5;
filtered5 = conv(measured,h5,'same');
figure('Color','w','Name','Five-point filtering');
plot(n, clean,'b-','LineWidth',1.5); hold on;
plot(n, measured,'Color',[0.70 0.70 0.70]);
plot(n, filtered5,'r-','LineWidth',1.5);
grid on; xlabel('Sample index n'); ylabel('Amplitude');
title('Task 3: Five-Point Moving-Average Filtering');
legend('Clean','Noisy','5-point moving average','Location','best');
exportgraphics(gcf, fullfile(outputDir,'noise_filtering.png'), 'Resolution', 180);

%% Task 4: compare five- and fifteen-point filters
h15 = ones(1,15)/15;
filtered15 = conv(measured,h15,'same');
figure('Color','w','Name','Moving-average comparison');
plot(n, clean,'b-','LineWidth',1.6); hold on;
plot(n, measured,'Color',[0.70 0.70 0.70]);
plot(n, filtered5,'r-','LineWidth',1.5);
plot(n, filtered15,'m--','LineWidth',1.7);
grid on; xlabel('Sample index n'); ylabel('Amplitude');
title('Task 4: 5-Point Versus 15-Point Moving Average');
legend('Clean signal','Noisy signal','5-point filter','15-point filter','Location','best');
exportgraphics(gcf, fullfile(outputDir,'filter_comparison.png'), 'Resolution', 180);

%% Additional numeric check to support the observations
rmseNoisy = sqrt(mean((measured-clean).^2));
rmse5 = sqrt(mean((filtered5-clean).^2));
rmse15 = sqrt(mean((filtered15-clean).^2));
fprintf('\nLECTURE 03 RESULTS\n');
fprintf('Samples in original signal: %d\n',numel(measured));
fprintf('Samples in delayed signal: %d\n',numel(delayed));
fprintf('Moving-average coefficients: 5-point = %s\n',mat2str(h5));
fprintf('RMSE noisy = %.6f\n',rmseNoisy);
fprintf('RMSE 5-point = %.6f\n',rmse5);
fprintf('RMSE 15-point = %.6f\n',rmse15);
fprintf('Figures saved to: %s\n',outputDir);
