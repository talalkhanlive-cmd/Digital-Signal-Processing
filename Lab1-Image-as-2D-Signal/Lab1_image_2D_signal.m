%% Lab 1: Image as a 2D Signal
% Sampling, Quantization, Histograms, and Enhancement
% Run this script from any folder. The figures are saved beside this script.
close all; clear; clc;

scriptPath = mfilename('fullpath');
if isempty(scriptPath)
    outDir = pwd;
else
    outDir = fileparts(scriptPath);
end
fprintf('Lab 1 - Image as a 2D Signal\n');
fprintf('MATLAB version: %s\n', version);
if isempty(which('imresize')) || isempty(which('imadjust')) || isempty(which('imhist'))
    error('Image Processing Toolbox is required for this assignment.');
end

%% 0) Load and inspect image
if exist('peppers.png','file') == 2
    inputImage = imread('peppers.png');
    inputName = 'peppers.png';
elseif exist('cameraman.tif','file') == 2
    inputImage = imread('cameraman.tif');
    inputName = 'cameraman.tif';
else
    error(['Neither peppers.png nor cameraman.tif was found. ' ...
           'Add a permitted image to the MATLAB Current Folder and update the image filename.']);
end
if ndims(inputImage) == 3 && size(inputImage,3) == 3
    I_rgb = inputImage;
    I = rgb2gray(inputImage);
else
    I = inputImage;
    I_rgb = repmat(I, [1 1 3]);
end
fprintf('Image source: %s\n',inputName);
fprintf('Grayscale class: %s | Range: [%g, %g] | Size: %d x %d\n', ...
    class(I), double(min(I(:))), double(max(I(:))), size(I,1), size(I,2));

fig = figure('Name','Original and grayscale','Color','w');
tiledlayout(1,2,'Padding','compact');
nexttile; imshow(I_rgb); title('Original RGB (or RGB fallback)');
nexttile; imshow(I); title('Grayscale luminance');
exportgraphics(fig, fullfile(outDir,'01_original_grayscale.png'),'Resolution',180);

%% 1) Quantization and dynamic range
I8 = I;
I6 = uint8(floor(double(I)/4)*4);
I4 = uint8(floor(double(I)/16)*16);
fig = figure('Name','Quantization','Color','w');
tiledlayout(1,3,'Padding','compact');
nexttile; imshow(I8); title('8-bit (256 levels)');
nexttile; imshow(I6); title('Approx. 6-bit (64 levels)');
nexttile; imshow(I4); title('Approx. 4-bit (16 levels)');
sgtitle('Quantization: reduced gray-level precision');
exportgraphics(fig, fullfile(outDir,'02_quantization.png'),'Resolution',180);
fprintf('Quantization levels (theoretical): 8 bit = 256, 6 bit = 64, 4 bit = 16\n');

%% 2) Histogram and contrast stretching
I_norm = mat2gray(I);
I_stretch = imadjust(I,[0.2 0.8],[0 1]);
fig = figure('Name','Histograms','Color','w');
tiledlayout(1,2,'Padding','compact');
nexttile; imhist(I); title('Original histogram'); xlabel('Intensity'); ylabel('Pixel count');
nexttile; imhist(I_stretch); title('Contrast-stretched histogram'); xlabel('Intensity'); ylabel('Pixel count');
sgtitle('Histograms before and after contrast stretching');
exportgraphics(fig, fullfile(outDir,'03_histograms.png'),'Resolution',180);
fig = figure('Name','Contrast comparison','Color','w');
tiledlayout(1,3,'Padding','compact');
nexttile; imshow(I); title('Original');
nexttile; imshow(I_norm); title('Normalized (min-max)');
nexttile; imshow(I_stretch); title('Contrast-stretched');
exportgraphics(fig, fullfile(outDir,'04_contrast_stretching.png'),'Resolution',180);

%% 3) Gamma correction
I_gamma_low = imadjust(I,[],[],0.6);
I_gamma_high = imadjust(I,[],[],1.6);
fig = figure('Name','Gamma correction','Color','w');
tiledlayout(1,3,'Padding','compact');
nexttile; imshow(I); title('Original');
nexttile; imshow(I_gamma_low); title('Gamma = 0.6 (brighter)');
nexttile; imshow(I_gamma_high); title('Gamma = 1.6 (darker)');
sgtitle('Nonlinear gamma correction');
exportgraphics(fig, fullfile(outDir,'05_gamma_correction.png'),'Resolution',180);

%% 4) Image sampling and aliasing
scale = 0.1;
I_small = imresize(I, scale, 'nearest');
I_back = imresize(I_small, size(I), 'nearest');
fig = figure('Name','Sampling comparison','Color','w');
tiledlayout(1,3,'Padding','compact');
nexttile; imshow(I); title(sprintf('Original (%d x %d)',size(I,2),size(I,1)));
nexttile; imshow(I_small,'InitialMagnification','fit');
title(sprintf('10%% size (%d x %d)',size(I_small,2),size(I_small,1)));
nexttile; imshow(I_back); title('Upscaled with nearest neighbor');
sgtitle('Aggressive downsampling and upsampling');
exportgraphics(fig, fullfile(outDir,'06_sampling_aliasing.png'),'Resolution',180);

%% Summary
fprintf('Downsampled dimensions: %d x %d\n',size(I_small,1),size(I_small,2));
fprintf('Saved six figures to: %s\n',outDir);
fprintf('Inspect the plots to document image-specific observations.\n');
