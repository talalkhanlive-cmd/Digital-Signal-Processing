%% In-class image-processing exercises (six sections)
% MATLAB R2026b | Image Processing Toolbox
% Run all sections, check plots and text, then save as exercises.mlx.
% This script creates a results folder next to itself.
clear; close all; clc;
scriptDir = fileparts(mfilename('fullpath'));
if isempty(scriptDir), scriptDir = pwd; end
resultDir = fullfile(scriptDir, 'results');
if ~exist(resultDir,'dir'), mkdir(resultDir); end
rng(42);

%% Exercise 1 - Pixels, quantization, and sampling
Iu = imread('cameraman.tif');
I = im2double(Iu);
fprintf('\nEXERCISE 1: cameraman.tif size = %d x %d, class = %s\n', size(Iu,1),size(Iu,2),class(Iu));
% Quantize using uniformly spaced reconstruction levels in [0,1].
I4 = round(I*15)/15;    % 4 bits: 16 levels
I2 = round(I*3)/3;      % 2 bits: 4 levels
I1 = round(I);          % 1 bit: 2 levels
figure('Color','w','Name','Exercise 1 - Quantization');
subplot(2,2,1); imshow(I); title('Original (8 bit)');
subplot(2,2,2); imshow(I4); title('4 bit (16 levels)');
subplot(2,2,3); imshow(I2); title('2 bit (4 levels)');
subplot(2,2,4); imshow(I1); title('1 bit (2 levels)');
sgtitle('Exercise 1: Pixel quantization');
exportgraphics(gcf,fullfile(resultDir,'ex1_quantization.png'),'Resolution',160);
I_decimated = I(1:8:end, 1:8:end);
I_resized = imresize(I,1/8,'bicubic','Antialiasing',true);
figure('Color','w','Name','Exercise 1 - Downsampling');
subplot(1,3,1); imshow(I); title('Original');
subplot(1,3,2); imshow(imresize(I_decimated,8,'nearest')); title('Every 8th pixel (no prefilter)');
subplot(1,3,3); imshow(imresize(I_resized,size(I),'nearest')); title('imresize with antialiasing');
sgtitle('Exercise 1: Sampling by a factor of 8');
exportgraphics(gcf,fullfile(resultDir,'ex1_sampling.png'),'Resolution',160);
% Think about: recognizable objects can persist at 1 bit, but shading is lost.
% Decimation without prefiltering can create jagged/false fine structures.

%% Exercise 2 - Additive and multiplicative degradation
I_gauss = imnoise(I,'gaussian',0,0.01);
I_sp = imnoise(I,'salt & pepper',0.05);
h_motion = fspecial('motion',15,30);
I_motion = imfilter(I,h_motion,'replicate');
ramp = repmat(linspace(0.35,1,size(I,2)),size(I,1),1);
I_ramp = I .* ramp;
figure('Color','w','Name','Exercise 2 - Degradation');
subplot(2,3,1); imshow(I); title('Original');
subplot(2,3,2); imshow(I_gauss); title('Gaussian variance 0.01');
subplot(2,3,3); imshow(I_sp); title('Salt & pepper density 0.05');
subplot(2,3,4); imshow(I_motion); title('Motion blur 15 px, 30 deg');
subplot(2,3,5); imshow(I_ramp); title('Multiplicative brightness ramp');
subplot(2,3,6); imagesc(ramp,[0,1]); axis image off; colorbar; title('Applied brightness ramp');
sgtitle('Exercise 2: Image degradation');
exportgraphics(gcf,fullfile(resultDir,'ex2_degradations.png'),'Resolution',160);
% Think about: Gaussian and salt-and-pepper noise are added/replaced at
% pixel level. The brightness ramp is multiplicative. Median filtering
% targets isolated salt-and-pepper impulses effectively.

%% Exercise 3 - Contrast and interpolation
P = im2double(imread('pout.tif'));
P_adjust = imadjust(P);
P_gamma05 = imadjust(P,[],[],0.5);
P_gamma2 = imadjust(P,[],[],2);
P_equalized = histeq(P);
figure('Color','w','Name','Exercise 3 - Contrast');
subplot(2,3,1); imshow(P); title('Original pout.tif');
subplot(2,3,2); imshow(P_adjust); title('imadjust');
subplot(2,3,3); imshow(P_gamma05); title('Gamma 0.5');
subplot(2,3,4); imshow(P_gamma2); title('Gamma 2');
subplot(2,3,5); imshow(P_equalized); title('Histogram equalization');
subplot(2,3,6); imhist(P); title('Original histogram');
sgtitle('Exercise 3: Contrast transformations');
exportgraphics(gcf,fullfile(resultDir,'ex3_contrast_histogram.png'),'Resolution',160);
patch = P(51:90,51:90);
patchNearest = imresize(patch,6,'nearest');
patchBicubic = imresize(patch,6,'bicubic');
figure('Color','w','Name','Exercise 3 - Interpolation');
subplot(1,3,1); imshow(patch); title('40 x 40 original patch');
subplot(1,3,2); imshow(patchNearest); title('Nearest (6x)');
subplot(1,3,3); imshow(patchBicubic); title('Bicubic (6x)');
sgtitle('Exercise 3: Patch enlargement');
exportgraphics(gcf,fullfile(resultDir,'ex3_interpolation.png'),'Resolution',160);
% Think about: gamma below 1 brightens midtones because x^gamma > x for
% x in (0,1). Bicubic interpolates neighboring values for smoothness;
% nearest-neighbor copies pixel values and creates blocky boundaries.

%% Exercise 4 - Filters, PSNR and spectra
h_mean = fspecial('average',[3 3]);
% Fixed Gaussian kernel, sigma 1, 5 by 5.
h_g = fspecial('gaussian',[5 5],1);
methodNames = {'Mean 3x3';'Gaussian 5x5 sigma=1';'Median 3x3'};
noiseNames = {'Gaussian';'SaltPepper'};
inputs = {I_gauss,I_sp};
filtered = cell(2,3);
psnrValues = zeros(6,1);
labels = cell(6,1);
for j = 1:2
    A = inputs{j};
    filtered{j,1} = imfilter(A,h_mean,'replicate');
    filtered{j,2} = imfilter(A,h_g,'replicate');
    filtered{j,3} = medfilt2(A,[3 3]);
    for k = 1:3
        idx = (j-1)*3+k;
        labels{idx} = sprintf('%s / %s',noiseNames{j},methodNames{k});
        psnrValues(idx) = psnr(filtered{j,k},I);
    end
end
T = table(string(labels),psnrValues,'VariableNames',{'Method','PSNR_dB'});
disp('EXERCISE 4: PSNR compared with original image'); disp(T);
writetable(T,fullfile(resultDir,'ex4_psnr_table.csv'));
figure('Color','w','Name','Exercise 4 - Denoising comparisons');
for j=1:2
    for k=1:3
        subplot(2,3,(j-1)*3+k); imshow(filtered{j,k});
        title(sprintf('%s / %s\nPSNR %.2f dB',noiseNames{j},methodNames{k},psnrValues((j-1)*3+k)),'Interpreter','none');
    end
end
sgtitle('Exercise 4: Three filters applied to two noise types');
exportgraphics(gcf,fullfile(resultDir,'ex4_filter_comparison.png'),'Resolution',160);
I_blur = imfilter(I,h_g,'replicate');
Sf = log1p(abs(fftshift(fft2(I))));
Sb = log1p(abs(fftshift(fft2(I_blur))));
smax = max([Sf(:);Sb(:)]);
figure('Color','w','Name','Exercise 4 - Spectrum');
subplot(1,2,1); imagesc(Sf,[0,smax]); axis image off; colormap gray; title('Original log-spectrum');
subplot(1,2,2); imagesc(Sb,[0,smax]); axis image off; colormap gray; title('Blurred log-spectrum');
sgtitle('Exercise 4: Frequency content after blur');
exportgraphics(gcf,fullfile(resultDir,'ex4_spectra.png'),'Resolution',160);
% Think about: compare PSNR table rather than assuming one method always
% wins. Blurring suppresses high spatial-frequency content in the spectrum.

%% Exercise 5 - Edge maps, effect of sigma and smoothing
E_sobel = edge(I,'Sobel');
E_canny1 = edge(I,'Canny',[],1);
E_canny2 = edge(I,'Canny',[],2);
E_canny3 = edge(I,'Canny',[],3);
E_noisy = edge(I_gauss,'Canny',[],1);
E_smooth = edge(imgaussfilt(I_gauss,1),'Canny',[],1);
edgeMasks = {E_sobel,E_canny1,E_canny2,E_canny3,E_noisy,E_smooth};
edgeNames = {'Sobel clean','Canny clean sigma 1','Canny clean sigma 2', ...
             'Canny clean sigma 3','Canny noisy sigma 1','Canny smoothed noisy sigma 1'};
counts = cellfun(@nnz,edgeMasks);
ET = table(string(edgeNames(:)),counts(:),'VariableNames',{'Method','EdgePixels'});
disp('EXERCISE 5: Edge-pixel counts');disp(ET);
writetable(ET,fullfile(resultDir,'ex5_edge_counts.csv'));
figure('Color','w','Name','Exercise 5 - Edges');
for k=1:6
    subplot(2,3,k); imshow(edgeMasks{k});
    title(sprintf('%s (%d pixels)',edgeNames{k},counts(k)),'Interpreter','none');
end
sgtitle('Exercise 5: Sobel, Canny and noise smoothing');
exportgraphics(gcf,fullfile(resultDir,'ex5_edges.png'),'Resolution',160);
% Reference-based estimate, not a ground-truth measure of false edges.
addedBefore = nnz(E_noisy & ~E_canny1);
addedAfter = nnz(E_smooth & ~E_canny1);
fprintf('Pixels not in clean Canny sigma 1 map: noisy=%d, smoothed=%d; reduction=%d\n', ...
    addedBefore,addedAfter,addedBefore-addedAfter);
% Think about: larger Canny sigma generally smooths small features but can
% miss fine edges. Extra pixels compared with a clean edge map are only a
% proxy for false edges, not a definitive error count.

%% Exercise 6 - Otsu coin segmentation and connected components
C = im2double(imread('coins.png'));
level = graythresh(C);
BW = imbinarize(C,level);
BWopen = imopen(BW,strel('disk',2));
BWfill = imfill(BWopen,'holes');
BWclean = bwareaopen(BWfill,40);
CC = bwconncomp(BWclean,8);
stats = regionprops(CC,'Area','Centroid');
areas = [stats.Area]';
coinIds = (1:numel(areas))';
CT = table(coinIds,areas,'VariableNames',{'RegionID','Area_pixels'});
disp('EXERCISE 6: Detected region areas (not guaranteed one region per coin)');disp(CT);
writetable(CT,fullfile(resultDir,'ex6_region_areas.csv'));
figure('Color','w','Name','Exercise 6 - Coin segmentation');
subplot(2,3,1); imshow(C); title('Original coins.png');
subplot(2,3,2); imshow(BW); title(sprintf('Otsu (threshold %.3f)',level));
subplot(2,3,3); imshow(BWopen); title('Opening');
subplot(2,3,4); imshow(BWfill); title('Fill holes');
subplot(2,3,5); imshow(BWclean); title('Remove small regions');
subplot(2,3,6); imshow(label2rgb(labelmatrix(CC),'jet','k','shuffle'));
title(sprintf('Connected regions: %d',CC.NumObjects));
sgtitle('Exercise 6: Threshold, clean and label coins');
exportgraphics(gcf,fullfile(resultDir,'ex6_coins.png'),'Resolution',160);
if ~isempty(areas)
    [largestArea, largestId] = max(areas);
    fprintf('Largest detected region: ID %d, area %.0f pixels\n',largestId,largestArea);
else
    fprintf('No coin regions detected with current cleaning parameters.\n');
end
% Think about: opening removes narrow protrusions/small bright spots;
% imfill fills interior holes; bwareaopen discards small connected objects.
% Touching coins may merge into one connected component.

fprintf('\nFinished. Figures and CSV tables saved to: %s\n',resultDir);
