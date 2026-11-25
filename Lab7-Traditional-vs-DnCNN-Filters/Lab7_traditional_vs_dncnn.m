%% Lab 7: Traditional versus DnCNN Gaussian Denoising
% Course: Mathematical Algorithms (DSP) - Image Processing Labs
% Requires Image Processing Toolbox for imnoise, wiener2, etc.
% DnCNN comparison additionally requires the relevant installed MATLAB
% deep-learning functionality and pretrained network support files.
% Figures and measurements are saved beside this script.
close all; clear; clc;
rng(7);  % Reproducible Gaussian noise realization

projectDir = fileparts(mfilename('fullpath'));
if isempty(projectDir), projectDir = pwd; end
imageFile = fullfile(projectDir, 'camera_image.png');
if ~isfile(imageFile)
    error('Bundled file camera_image.png is missing. Extract the whole ZIP.');
end
outputDir = fullfile(projectDir, 'results');
if ~exist(outputDir,'dir'), mkdir(outputDir); end

%% 1) Load image and add Gaussian noise
originalImage = im2double(imread(imageFile));
if size(originalImage,3)==3, originalImage = rgb2gray(originalImage); end
noiseSigma = 0.04;
noisyImage = imnoise(originalImage, 'gaussian', 0, noiseSigma^2);

%% 2) Traditional denoising methods
% Include the instructor's 5x5 adaptive Wiener filter plus mean, median,
% and Gaussian filters listed in the learning outcomes.
traditionalFiltered = wiener2(noisyImage, [5 5], noiseSigma^2);
meanFiltered = imfilter(noisyImage, fspecial('average',[3 3]), 'replicate');
medianFiltered = medfilt2(noisyImage, [3 3], 'symmetric');
gaussianFiltered = imgaussfilt(noisyImage, 0.8, 'Padding','replicate');

%% 3) Pretrained DnCNN (optional if the network is available)
dncnnAvailable = false;
dncnnMessage = '';
aiFiltered = [];
try
    if exist('denoisingNetwork','file') == 0 || exist('denoiseImage','file') == 0
        error('denoisingNetwork or denoiseImage is not available in this MATLAB installation.');
    end
    net = denoisingNetwork('DnCNN');
    aiFiltered = denoiseImage(noisyImage, net);
    dncnnAvailable = true;
catch ME
    dncnnMessage = ME.message;
    fprintf('\nDnCNN skipped: %s\n', dncnnMessage);
    fprintf('Install the required toolbox/network support package to include DnCNN results.\n');
end

%% 4) Compute quality metrics relative to the known clean image
methods = {'Noisy'; 'Mean 3x3'; 'Median 3x3'; 'Gaussian blur'; 'Wiener 5x5'};
images = {noisyImage, meanFiltered, medianFiltered, gaussianFiltered, traditionalFiltered};
if dncnnAvailable
    methods{end+1,1} = 'DnCNN';
    images{end+1} = aiFiltered;
end
numMethods = numel(methods);
mseValues = zeros(numMethods,1);
psnrValues = zeros(numMethods,1);
ssimValues = zeros(numMethods,1);
for k=1:numMethods
    candidate = min(max(double(images{k}), 0), 1);
    mseValues(k) = immse(candidate, originalImage);
    psnrValues(k) = psnr(candidate, originalImage);
    ssimValues(k) = ssim(candidate, originalImage);
end
metrics = table(methods, mseValues, psnrValues, ssimValues, ...
    'VariableNames', {'Method','MSE','PSNR_dB','SSIM'});
disp('--- Image quality comparison (higher PSNR/SSIM and lower MSE are better) ---');
disp(metrics);
writetable(metrics, fullfile(outputDir,'quality_metrics.csv'));

%% 5) Overview of the input and traditional methods
fig1 = figure('Name','Lab 7: Traditional filter comparison','Color','w');
labels = {'Original image','Gaussian noisy','Mean 3x3', ...
          'Median 3x3','Gaussian blur','Wiener 5x5'};
views = {originalImage,noisyImage,meanFiltered,medianFiltered, ...
         gaussianFiltered,traditionalFiltered};
for k=1:6
    subplot(2,3,k);
    imshow(views{k}, [0 1]);
    title(labels{k},'Color','k');
end
sgtitle('Gaussian noise: traditional denoising methods','Color','k');
exportgraphics(fig1,fullfile(outputDir,'01_traditional_filters.png'),'Resolution',170);

%% 6) Requested original / noisy / Wiener / DnCNN comparison
if dncnnAvailable
    fig2 = figure('Name','Lab 7: Wiener versus DnCNN','Color','w');
    comps = {originalImage,noisyImage,traditionalFiltered,aiFiltered};
    compLabels = {'Original','Gaussian noise','Wiener 5x5','DnCNN'};
    for k=1:4
        subplot(1,4,k); imshow(comps{k},[0 1]);
        title(compLabels{k},'Color','k');
    end
    sgtitle('Traditional (Wiener) versus pretrained DnCNN','Color','k');
    exportgraphics(fig2,fullfile(outputDir,'02_wiener_vs_dncnn.png'),'Resolution',170);
else
    fprintf('Figure 02 not generated because the pretrained DnCNN could not run.\n');
end

%% 7) Quantitative comparisons
fig3 = figure('Name','Lab 7: Quality metrics','Color','w');
subplot(1,3,1); bar(mseValues); title('MSE (lower is better)','Color','k');
ylabel('Mean squared error'); grid on;
subplot(1,3,2); bar(psnrValues); title('PSNR (higher is better)','Color','k');
ylabel('PSNR (dB)'); grid on;
subplot(1,3,3); bar(ssimValues); title('SSIM (higher is better)','Color','k');
ylabel('SSIM'); grid on;
for a=1:3
    subplot(1,3,a); xticks(1:numMethods); xticklabels(methods);
    xtickangle(45);
end
sgtitle('Quality metrics measured against the clean reference','Color','k');
set(fig3,'Position',[100 100 1400 530]);
exportgraphics(fig3,fullfile(outputDir,'03_quality_metrics.png'),'Resolution',170);

%% 8) Model details for reproducibility
fid = fopen(fullfile(outputDir,'run_summary.txt'),'w');
if fid ~= -1
    fprintf(fid,'MATLAB version: %s\n',version);
    fprintf(fid,'Input image: camera_image.png\n');
    fprintf(fid,'Noise: Gaussian, variance %.6f, sigma %.4f, RNG seed 7\n',noiseSigma^2,noiseSigma);
    fprintf(fid,'DnCNN ran successfully: %d\n',dncnnAvailable);
    if ~dncnnAvailable, fprintf(fid,'DnCNN unavailable: %s\n',dncnnMessage); end
    fclose(fid);
end
fprintf('\nResults saved in: %s\n',outputDir);
if ~dncnnAvailable
    fprintf('IMPORTANT: The required DnCNN comparison is incomplete until the network runs.\n');
end
