%% Option C - Compare Edge Detectors
% Individual Image Processing Experiment | MATLAB R2026b
% Save this file as analysis.mlx in MATLAB Live Editor, Run All,
% and export the executed Live Script to analysis.pdf.
% Image Processing Toolbox required. Input: MATLAB sample cameraman.tif.

clear; close all; clc;

%% 1. Research question and image
% How do Sobel with Gaussian preprocessing, Canny sigma 1, and Canny
% sigma 3 respond to clean and noisy versions of the same image?
imageName = 'cameraman.tif';
assert(exist(imageName, 'file') ~= 0, ...
    'MATLAB sample image cameraman.tif was not found on the MATLAB path.');
I = imread(imageName);
if ndims(I) == 3
    I = rgb2gray(I);
end
assert(ismatrix(I), 'Expected a grayscale image.');
rng(42);
In = imnoise(I, 'gaussian', 0, 0.01);

%% 2. Apply exactly the assigned detectors with default thresholds
% Sobel runs on the image smoothed by a sigma-1 Gaussian.
% The other two runs use Canny's internally controlled sigma value.
methods = {'Sobel + Gaussian (sigma=1)', 'Canny (sigma=1)', 'Canny (sigma=3)'};
Eclean = cell(1,3); Enoisy = cell(1,3);
Eclean{1} = edge(imgaussfilt(I,1), 'Sobel');
Enoisy{1} = edge(imgaussfilt(In,1), 'Sobel');
Eclean{2} = edge(I,'Canny',[],1);
Enoisy{2} = edge(In,'Canny',[],1);
Eclean{3} = edge(I,'Canny',[],3);
Enoisy{3} = edge(In,'Canny',[],3);

%% 3. Display all six maps in one figure
fig1 = figure('Color','white', 'Name','Six edge maps', 'Position',[80 80 1200 720]);
tiledlayout(2,3,'TileSpacing','compact','Padding','compact');
for k = 1:3
    nexttile(k); imshow(Eclean{k});
    title(['Clean: ', methods{k}], 'Interpreter','none');
    nexttile(k+3); imshow(Enoisy{k});
    title(['Noisy: ', methods{k}], 'Interpreter','none');
end
sgtitle('Option C: Edge Detectors on Clean and Noisy cameraman.tif');

%% 4. Numerical evaluation: edge-pixel counts
cleanCount = cellfun(@nnz,Eclean);
noisyCount = cellfun(@nnz,Enoisy);
delta = noisyCount - cleanCount;
pctChange = 100 * delta ./ max(cleanCount,1);
T = table(string(methods(:)),cleanCount(:),noisyCount(:),delta(:),pctChange(:), ...
    'VariableNames', {'Detector','CleanEdgePixels','NoisyEdgePixels', ...
    'Difference','PercentChange'});
disp('Edge pixel counts (not a direct measure of correctness):');
disp(T);

%% 5. Show original image and its noisy version for reference
fig2 = figure('Color','white','Name','Input images','Position',[100 100 900 430]);
tiledlayout(1,2,'TileSpacing','compact');
nexttile; imshow(I); title('Original cameraman.tif');
nexttile; imshow(In); title('Gaussian noise: mean 0, variance 0.01');
sgtitle('Same reference image for all edge detectors');

%% 6. Save reproducible results
outDir = fullfile(fileparts(mfilename('fullpath')),'results');
if ~isfolder(outDir), mkdir(outDir); end
exportgraphics(fig1,fullfile(outDir,'edge_maps_six.png'),'Resolution',180);
exportgraphics(fig2,fullfile(outDir,'original_vs_noisy.png'),'Resolution',180);
writetable(T,fullfile(outDir,'edge_pixel_counts.csv'));
fprintf('\nSaved results in: %s\n',outDir);

%% 7. Interpretation - review against the actual output
% Compare changes in the number and connectivity of edges, not just counts.
% Sigma 3 usually suppresses fine detail and some noise-driven edges more
% strongly than sigma 1, but may discard legitimate thin boundaries.
% Inspect the camera/tripod edges or the background to identify ONE specific
% edge which disappears or is introduced, then describe it in your own words.
% A count alone cannot establish whether a detected edge is correct.
