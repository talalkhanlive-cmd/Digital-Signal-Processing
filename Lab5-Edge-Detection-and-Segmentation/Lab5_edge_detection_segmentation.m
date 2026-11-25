%% Lab 5: Edge Detection and Segmentation
% Course: Mathematical Algorithms (DSP) - Image Processing Labs
% Requires Image Processing Toolbox.
% Run this file to generate comparison figures and numerical observations.
close all; clear; clc;

% Save results beside this script, regardless of MATLAB's current folder.
scriptFolder = fileparts(mfilename('fullpath'));
if isempty(scriptFolder), scriptFolder = pwd; end

%% 0) Load the input image
if exist('peppers.png','file') == 2
    I0 = imread('peppers.png');
    sourceName = 'peppers.png';
elseif exist('cameraman.tif','file') == 2
    I0 = imread('cameraman.tif');
    sourceName = 'cameraman.tif (fallback)';
else
    error('No sample image found. Add peppers.png or cameraman.tif to the MATLAB path.');
end

if ndims(I0) == 3 && size(I0,3) == 3
    I = im2double(rgb2gray(I0));
else
    I = im2double(I0);
end
fprintf('Lab 5 input: %s | image size: %d x %d pixels\n', ...
    sourceName, size(I,1), size(I,2));

%% 1) Basic derivative filters: Sobel and Prewitt
edges_sobel = edge(I, 'Sobel');
edges_prewitt = edge(I, 'Prewitt');
fig1 = figure('Color','white', 'Name','Sobel vs Prewitt');
tiledlayout(1,2, 'Padding','compact','TileSpacing','compact');
nexttile; imshow(edges_sobel); title('Sobel edge map');
nexttile; imshow(edges_prewitt); title('Prewitt edge map');
sgtitle('Gradient-based edge detection');
exportgraphics(fig1, fullfile(scriptFolder,'01_sobel_prewitt.png'), 'Resolution',180);

%% 2) Multi-stage Canny detector
edges_canny = edge(I, 'Canny', [0.05 0.2]);
fig2 = figure('Color','white', 'Name','Canny edges');
imshow(edges_canny);
title('Canny edges (thresholds: 0.05, 0.20)');
exportgraphics(fig2, fullfile(scriptFolder,'02_canny_edges.png'), 'Resolution',180);

%% 3) Laplacian of Gaussian (LoG)
edges_log = edge(I, 'log');
fig3 = figure('Color','white', 'Name','LoG edges');
imshow(edges_log);
title('Laplacian of Gaussian (zero-crossing) edges');
exportgraphics(fig3, fullfile(scriptFolder,'03_log_edges.png'), 'Resolution',180);

%% 4) Otsu histogram-based thresholding
level = graythresh(I);
BW = imbinarize(I, level);
fig4 = figure('Color','white', 'Name','Otsu segmentation');
tiledlayout(1,2, 'Padding','compact','TileSpacing','compact');
nexttile; imshow(I,[]); title('Original grayscale image');
nexttile; imshow(BW); title(sprintf('Otsu binary mask (threshold %.4f)',level));
sgtitle('Global intensity-based segmentation');
exportgraphics(fig4, fullfile(scriptFolder,'04_otsu_segmentation.png'), 'Resolution',180);

%% 5) Label and visualize connected regions
[L,num] = bwlabel(BW, 8);
RGB = label2rgb(L, 'jet', 'k', 'shuffle');
fig5 = figure('Color','white', 'Name','Labeled regions');
imshow(RGB);
title(sprintf('Connected foreground regions (8-connectivity): %d',num));
exportgraphics(fig5, fullfile(scriptFolder,'05_labeled_regions.png'), 'Resolution',180);

%% Additional overview to simplify comparison
fig6 = figure('Color','white','Name','Edge method comparison');
tiledlayout(2,3,'Padding','compact','TileSpacing','compact');
nexttile; imshow(I,[]); title('Grayscale');
nexttile; imshow(edges_sobel); title('Sobel');
nexttile; imshow(edges_prewitt); title('Prewitt');
nexttile; imshow(edges_canny); title('Canny');
nexttile; imshow(edges_log); title('LoG');
nexttile; imshow(BW); title('Otsu segmentation');
sgtitle('Edge detection and threshold-based segmentation');
exportgraphics(fig6, fullfile(scriptFolder,'06_method_comparison.png'), 'Resolution',180);

%% Numerical summary (used to support observations)
imagePixels = numel(I);
fprintf('\n--- LAB 5 RESULTS ---\n');
fprintf('Sobel detected edge pixels:    %d (%.2f%%)\n', nnz(edges_sobel), 100*nnz(edges_sobel)/imagePixels);
fprintf('Prewitt detected edge pixels:  %d (%.2f%%)\n', nnz(edges_prewitt), 100*nnz(edges_prewitt)/imagePixels);
fprintf('Canny detected edge pixels:    %d (%.2f%%)\n', nnz(edges_canny), 100*nnz(edges_canny)/imagePixels);
fprintf('LoG detected edge pixels:      %d (%.2f%%)\n', nnz(edges_log), 100*nnz(edges_log)/imagePixels);
fprintf('Otsu threshold:               %.6f (normalized 0..1)\n', level);
fprintf('Otsu foreground pixels:       %d (%.2f%%)\n', nnz(BW), 100*nnz(BW)/imagePixels);
fprintf('Connected components (8-neighbor): %d\n', num);

metric = {'Sobel edge pixels'; 'Prewitt edge pixels'; 'Canny edge pixels'; ...
          'LoG edge pixels'; 'Otsu threshold'; 'Otsu foreground pixels'; ...
          'Connected foreground regions'};
value = [nnz(edges_sobel); nnz(edges_prewitt); nnz(edges_canny); ...
         nnz(edges_log); level; nnz(BW); num];
resultsTable = table(metric, value, 'VariableNames',{'Metric','Value'});
writetable(resultsTable, fullfile(scriptFolder,'lab5_measurements.csv'));
fprintf('Figures and lab5_measurements.csv saved to: %s\n', scriptFolder);
