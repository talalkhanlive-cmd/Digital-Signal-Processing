%% Lab 4: Noise and Filtering
% Mathematical Algorithms (DSP) - Image Processing Labs
% Requires MATLAB Image Processing Toolbox.
% This script creates reproducible noise, compares denoising filters,
% measures MSE and SNR, and saves labelled figures/results.
close all; clear; clc;
rng(7);  % Reproducible random experiment

%% 0. Load reference image
if exist('peppers.png','file')
    I0 = imread('peppers.png');
elseif exist('cameraman.tif','file')
    I0 = imread('cameraman.tif');
else
    error('Neither peppers.png nor cameraman.tif was found. Add an image to this folder.');
end
if ndims(I0) == 3 && size(I0,3) == 3
    I = im2double(rgb2gray(I0));
else
    I = im2double(I0);
end

%% 1. Add Gaussian and salt-and-pepper noise
I_gauss = imnoise(I, 'gaussian', 0, 0.01);
I_sp = imnoise(I, 'salt & pepper', 0.05);

fig = figure('Color','w','Name','Noise types','Position',[100 100 1200 420]);
subplot(1,3,1); imshow(I); title('Original grayscale');
subplot(1,3,2); imshow(I_gauss); title('Gaussian noise: variance 0.01');
subplot(1,3,3); imshow(I_sp); title('Salt-and-pepper noise: density 0.05');
exportgraphics(fig,'01_noise_types.png','Resolution',180);

%% 2. Quality metrics before filtering
mseGauss = immse(I_gauss,I);
mseSP = immse(I_sp,I);
% SNR is calculated using clean-signal power / error power.
% This is an image-based signal-to-noise ratio, not PSNR.
signalPower = mean(I(:).^2);
snrGauss = 10*log10(signalPower/mseGauss);
snrSP = 10*log10(signalPower/mseSP);

%% 3. Linear filtering
h_avg = fspecial('average',3);
h_gauss = fspecial('gaussian',[3 3],0.7);
I_avg_gauss = imfilter(I_gauss,h_avg,'replicate');
I_avg_sp = imfilter(I_sp,h_avg,'replicate');
I_gauss_gauss = imfilter(I_gauss,h_gauss,'replicate');
I_gauss_sp = imfilter(I_sp,h_gauss,'replicate');

%% 4. Nonlinear median filtering
I_med_gauss = medfilt2(I_gauss,[3 3]);
I_med_sp = medfilt2(I_sp,[3 3]);

fig = figure('Color','w','Name','Filtering comparison','Position',[100 100 1100 820]);
subplot(2,3,1); imshow(I_sp); title('S&P noisy input');
subplot(2,3,2); imshow(I_avg_sp); title('S&P: 3x3 mean');
subplot(2,3,3); imshow(I_med_sp); title('S&P: 3x3 median');
subplot(2,3,4); imshow(I_gauss); title('Gaussian noisy input');
subplot(2,3,5); imshow(I_avg_gauss); title('Gaussian: 3x3 mean');
subplot(2,3,6); imshow(I_med_gauss); title('Gaussian: 3x3 median');
exportgraphics(fig,'02_mean_median_comparison.png','Resolution',180);

fig = figure('Color','w','Name','Gaussian smoothing','Position',[100 100 1200 700]);
subplot(2,3,1); imshow(I); title('Clean reference');
subplot(2,3,2); imshow(I_gauss); title('Gaussian noise');
subplot(2,3,3); imshow(I_gauss_gauss); title('Gaussian noise + Gaussian filter');
subplot(2,3,4); imshow(I); title('Clean reference');
subplot(2,3,5); imshow(I_sp); title('S&P noise');
subplot(2,3,6); imshow(I_gauss_sp); title('S&P noise + Gaussian filter');
exportgraphics(fig,'03_gaussian_filter.png','Resolution',180);

%% 5. Compare MSE/SNR for each condition
names = {'Clean';'Gaussian noisy';'Gaussian + mean';'Gaussian + median'; ...
         'Gaussian + Gaussian filter';'S&P noisy';'S&P + mean'; ...
         'S&P + median';'S&P + Gaussian filter'};
images = {I,I_gauss,I_avg_gauss,I_med_gauss,I_gauss_gauss, ...
          I_sp,I_avg_sp,I_med_sp,I_gauss_sp};
mseValues = zeros(numel(images),1);
snrValues = zeros(numel(images),1);
for k = 1:numel(images)
    mseValues(k) = immse(images{k},I);
    if mseValues(k) == 0
        snrValues(k) = Inf;
    else
        snrValues(k) = 10*log10(signalPower/mseValues(k));
    end
end
results = table(string(names),mseValues,snrValues, ...
    'VariableNames',{'Condition','MSE','SNR_dB'});
disp(results);
writetable(results,'filter_metrics.csv');

fig = figure('Color','w','Name','MSE metrics','Position',[100 100 1100 560]);
bar(categorical(results.Condition(2:end)),results.MSE(2:end));
ylabel('Mean squared error (normalized intensity^2)');
title('Image quality relative to original (lower MSE is better)');
grid on; xtickangle(35);
exportgraphics(fig,'04_mse_comparison.png','Resolution',180);

fprintf('\nOriginal image: %d x %d pixels\n',size(I,1),size(I,2));
fprintf('Gaussian noisy: MSE %.6f | SNR %.2f dB\n',mseGauss,snrGauss);
fprintf('Salt-and-pepper noisy: MSE %.6f | SNR %.2f dB\n',mseSP,snrSP);
fprintf('Salt-and-pepper after mean: MSE %.6f\n',immse(I_avg_sp,I));
fprintf('Salt-and-pepper after median: MSE %.6f\n',immse(I_med_sp,I));
fprintf('\nSaved four figures and filter_metrics.csv to: %s\n',pwd);
