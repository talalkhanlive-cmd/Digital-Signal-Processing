%% Lab 3: Frequency-Domain Filtering with fft2
% Mathematical Algorithms (DSP) - Image Processing Labs
% Run in MATLAB with Image Processing Toolbox.
% Saves all figures beside this .m file automatically.
clear; close all; clc;

scriptPath = mfilename('fullpath');
if isempty(scriptPath)
    outputDir = pwd;
else
    outputDir = fileparts(scriptPath);
end

%% Load and inspect image
if exist('peppers.png','file')
    I0 = imread('peppers.png');
elseif exist('cameraman.tif','file')
    I0 = imread('cameraman.tif');
else
    error('Neither peppers.png nor cameraman.tif is available. Add an image to the MATLAB Current Folder.');
end
if size(I0,3) == 3
    I = im2double(rgb2gray(I0));
else
    I = im2double(I0);
end
[M,N] = size(I);
fprintf('MATLAB version: %s\n', version);
fprintf('Image dimensions: %d rows x %d columns\n', M, N);

%% Section 1: Centered log-magnitude spectrum
F = fft2(I);
Fshift = fftshift(F);
S = log(1 + abs(Fshift));
fig = figure('Color','w','Name','1 - Magnitude spectrum');
subplot(1,2,1); imshow(I,[]); title('Original grayscale image','Color','k');
subplot(1,2,2); imshow(S,[]); title('Centered log-magnitude spectrum','Color','k');
colormap(gca,gray); colorbar;
exportgraphics(fig,fullfile(outputDir,'01_magnitude_spectrum.png'),'Resolution',180);

%% Section 2: Ideal and Gaussian low-pass transfer functions
[u,v] = meshgrid(-floor(N/2):ceil(N/2)-1, -floor(M/2):ceil(M/2)-1);
D = hypot(u,v);
D0 = 40;
sigmaFreq = 20;
H_ideal_LP = double(D <= D0);
H_gauss_LP = exp(-(D.^2)/(2*sigmaFreq^2));
fig = figure('Color','w','Name','2 - Frequency filters');
subplot(1,2,1); imagesc(H_ideal_LP); axis image off; colorbar; title('Ideal low-pass, radius = 40','Color','k');
subplot(1,2,2); imagesc(H_gauss_LP); axis image off; colorbar; title('Gaussian low-pass, sigma = 20 bins','Color','k');
exportgraphics(fig,fullfile(outputDir,'02_frequency_masks.png'),'Resolution',180);

%% Section 3: Frequency-domain low-pass filtering
G_ideal = real(ifft2(ifftshift(H_ideal_LP.*Fshift)));
G_gauss = real(ifft2(ifftshift(H_gauss_LP.*Fshift)));
fig = figure('Color','w','Name','3 - Low pass filters');
subplot(1,3,1); imshow(I,[0 1]); title('Original','Color','k');
subplot(1,3,2); imshow(G_ideal,[0 1]); title('Ideal low-pass (ringing)','Color','k');
subplot(1,3,3); imshow(G_gauss,[0 1]); title('Gaussian low-pass','Color','k');
exportgraphics(fig,fullfile(outputDir,'03_low_pass_comparison.png'),'Resolution',180);

%% Section 4: Gaussian high-pass complement
H_gauss_HP = 1-H_gauss_LP;
G_hp = real(ifft2(ifftshift(H_gauss_HP.*Fshift)));
fig = figure('Color','w','Name','4 - High pass');
subplot(1,3,1); imshow(I,[0 1]); title('Original','Color','k');
subplot(1,3,2); imshow(G_hp,[]); title('High-pass response (auto contrast)','Color','k');
subplot(1,3,3); imshow(mat2gray(G_hp),[0 1]); title('High-pass remapped to [0,1]','Color','k');
exportgraphics(fig,fullfile(outputDir,'04_high_pass_comparison.png'),'Resolution',180);

%% Section 5: Spatial vs frequency-domain Gaussian filters
% First reproduce the TWO DIFFERENT filters given in the lab starter code.
% Their outputs are not expected to match because blur widths differ.
g1d = fspecial('gaussian',[1 7],1.2);
h7 = g1d'*g1d;
I_spatial_gauss = imfilter(I,h7,'replicate');
fig = figure('Color','w','Name','5 - Starter code comparison');
subplot(1,3,1); imshow(I,[0 1]); title('Original','Color','k');
subplot(1,3,2); imshow(I_spatial_gauss,[0 1]); title('7x7 Gaussian, replicate','Color','k');
subplot(1,3,3); imshow(G_gauss,[0 1]); title('Frequency Gaussian, sigma=20','Color','k');
exportgraphics(fig,fullfile(outputDir,'05_spatial_vs_frequency_gaussian.png'),'Resolution',180);

% FAIR mathematical verification of convolution theorem:
% Use the SAME 7x7 kernel with circular boundary handling in BOTH domains.
% padarray and circshift position the centered spatial kernel for an FFT.
hPadded = zeros(M,N);
hPadded(1:7,1:7) = h7;
hPadded = circshift(hPadded,[-3 -3]);
H_matched = fft2(hPadded);
I_freq_matched = real(ifft2(fft2(I).*H_matched));
I_spatial_circular = imfilter(I,h7,'circular','conv');
err = max(abs(I_spatial_circular(:) - I_freq_matched(:)));
rmse = sqrt(mean((I_spatial_circular(:)-I_freq_matched(:)).^2));
fprintf('Max abs difference, matched circular Gaussian: %.12g\n',err);
fprintf('RMSE, matched circular Gaussian: %.12g\n',rmse);

fig = figure('Color','w','Name','6 - Matched Gaussian verification');
subplot(1,3,1); imshow(I_spatial_circular,[0 1]); title('Spatial: 7x7, circular','Color','k');
subplot(1,3,2); imshow(I_freq_matched,[0 1]); title('FFT: same kernel, circular','Color','k');
subplot(1,3,3); imshow(abs(I_spatial_circular-I_freq_matched),[]); title('Absolute difference','Color','k'); colorbar;
exportgraphics(fig,fullfile(outputDir,'06_matched_gaussian_verification.png'),'Resolution',180);

%% Section 6: Print metrics for README verification
fprintf('Parameters: ideal cutoff radius = %g bins; frequency Gaussian sigma = %g bins\n',D0,sigmaFreq);
fprintf('Spatial Gaussian = 7x7, sigma = 1.2 pixels.\n');
fprintf('Saved six PNG figures in: %s\n',outputDir);
