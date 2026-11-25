%% Lab 2: 2D Convolution & FIR Filters (Blur, Sharpen, Edges)
% Course: Mathematical Algorithms (DSP) - Image Processing Labs
% Run this script from any working folder. Figures are saved beside the script.
close all; clear; clc;

scriptFile = mfilename('fullpath');
if isempty(scriptFile)
    outputDir = pwd;
else
    outputDir = fileparts(scriptFile);
end
fprintf('Lab 2: 2D Convolution and FIR Filters\n');
fprintf('MATLAB version: %s\n', version);
assert(~isempty(which('imfilter')) && ~isempty(which('fspecial')), ...
    'Image Processing Toolbox is needed for this lab.');

%% 0) Load image
if exist('peppers.png','file') == 2
    I0 = imread('peppers.png');
elseif exist('cameraman.tif','file') == 2
    base = imread('cameraman.tif');
    I0 = repmat(base,1,1,3);
else
    error('Neither peppers.png nor cameraman.tif is available. Add an image to the MATLAB path.');
end
if size(I0,3) == 3
    I = im2double(rgb2gray(I0));
else
    I = im2double(I0);
end
fprintf('Image dimensions: %d rows x %d columns\n', size(I,1), size(I,2));

%% 1) Delta image and impulse response
% Convolution of a unit impulse with the kernel reproduces the kernel.
delta = zeros(101,101);
delta(51,51) = 1;
h_avg = ones(3,3)/9;
H_vis = conv2(delta,h_avg,'same');
fig = figure('Color','w','Name','01 Impulse response');
imagesc(H_vis); axis image; axis on; colorbar;
colormap(gca,parula); title('Impulse response of a 3x3 averaging FIR kernel','Color','k');
xlabel('Column index'); ylabel('Row index');
exportgraphics(fig,fullfile(outputDir,'01_impulse_response.png'),'Resolution',180);

%% 2) Low-pass: box vs Gaussian, separability
h_box3 = ones(3,3)/9;
h_box7 = ones(7,7)/49;
sigma = 1.2;
g1d = fspecial('gaussian',[1 7],sigma);
h_gauss = g1d' * g1d;  % Outer product: separable 2D Gaussian
I_box3 = imfilter(I,h_box3,'replicate');
I_box7 = imfilter(I,h_box7,'replicate');
I_gauss = imfilter(I,h_gauss,'replicate');
% The following should agree numerically, apart from roundoff:
I_gauss_separate = imfilter(imfilter(I,g1d,'replicate'),g1d','replicate');
separabilityDiff = max(abs(I_gauss(:)-I_gauss_separate(:)));
fprintf('Gaussian full-2D vs two 1D passes, maximum difference = %.3g\n',separabilityDiff);
fig = comparisonFigure({I,I_box3,I_box7,I_gauss}, ...
    {'Original','Box 3x3','Box 7x7','Gaussian, sigma 1.2'}, ...
    'Low-pass filtering: box versus Gaussian');
exportgraphics(fig,fullfile(outputDir,'02_lowpass_comparison.png'),'Resolution',180);

%% 3) Unsharp masking / sharpening
I_blur = I_gauss;
mask = I - I_blur;  % Signed high-frequency component
gain = 1.0;
I_sharp = min(max(I + gain*mask,0),1);
% Display the signed mask on a neutral mid-gray scale (0 maps to 0.5).
mask_vis = min(max(0.5 + mask,0),1);
fig = comparisonFigure({I,I_blur,mask_vis,I_sharp}, ...
    {'Original','Gaussian blur','High-frequency mask (0=gray)','Sharpened'}, ...
    'Unsharp masking');
exportgraphics(fig,fullfile(outputDir,'03_sharpening.png'),'Resolution',180);

%% 4) Sobel and Laplacian edge responses
h_sobel_x = fspecial('sobel');
h_sobel_y = h_sobel_x';
Gx = imfilter(I,h_sobel_x,'replicate');
Gy = imfilter(I,h_sobel_y,'replicate');
Gmag = hypot(Gx,Gy);
h_lap = fspecial('laplacian',0.2);
I_lap = imfilter(I,h_lap,'replicate');
fig = comparisonFigure({mat2gray(Gx),mat2gray(Gy),mat2gray(Gmag),mat2gray(I_lap)}, ...
    {'Sobel Gx','Sobel Gy','Gradient magnitude','Laplacian'}, ...
    'Edge response comparisons (each panel normalized for display)');
exportgraphics(fig,fullfile(outputDir,'04_edge_detection.png'),'Resolution',180);

%% 5) Correlation vs convolution
% For the symmetric averaging kernel, flip does not change the kernel.
% Compare equal-size outputs using the SAME zero-padding convention.
C1 = conv2(I,h_box3,'same');
C2 = imfilter(I,h_box3,'conv','same',0);
diff_val = max(abs(C1(:)-C2(:)));
% Demonstrate that asymmetric kernels reveal a difference between
% convolution and correlation; only the central region is compared.
h_asym = [0 1 2; 0 0 0; -1 0 1];
Aconv = imfilter(I,h_asym,'conv','same',0);
Acorr = imfilter(I,h_asym,'corr','same',0);
asymmetricDiff = max(abs(Aconv(:)-Acorr(:)));
fprintf('Max difference, conv2 vs imfilter (same zero boundary): %.3g\n',diff_val);
fprintf('Max difference, asymmetric convolution vs correlation: %.3g\n',asymmetricDiff);
fig = comparisonFigure({mat2gray(Aconv),mat2gray(Acorr),mat2gray(abs(Aconv-Acorr))}, ...
    {'Convolution','Correlation','Absolute difference'}, ...
    'Convolution vs correlation with asymmetric kernel');
exportgraphics(fig,fullfile(outputDir,'05_convolution_vs_correlation.png'),'Resolution',180);

%% 6) Boundary handling
I_rep = imfilter(I,h_box7,'replicate');
I_sym = imfilter(I,h_box7,'symmetric');
I_cir = imfilter(I,h_box7,'circular');
fig = comparisonFigure({I_rep,I_sym,I_cir}, ...
    {'Replicate','Symmetric','Circular'}, ...
    'Boundary handling for 7x7 box filter');
exportgraphics(fig,fullfile(outputDir,'06_boundary_handling.png'),'Resolution',180);
borderWidth = 3;
borderMask = false(size(I));
borderMask(1:borderWidth,:) = true;
borderMask(end-borderWidth+1:end,:) = true;
borderMask(:,1:borderWidth) = true;
borderMask(:,end-borderWidth+1:end) = true;
fprintf('Mean border absolute difference, replicate vs symmetric: %.6f\n', ...
    mean(abs(I_rep(borderMask)-I_sym(borderMask))));
fprintf('Mean border absolute difference, replicate vs circular: %.6f\n', ...
    mean(abs(I_rep(borderMask)-I_cir(borderMask))));
fprintf('Saved six figures to: %s\n',outputDir);

%% Local helper for consistent, readable image comparison panels
function fig = comparisonFigure(images,labels,heading)
    nPanels = numel(images);
    fig = figure('Color','w','Name',heading,'Position',[120 120 1450 510]);
    tl = tiledlayout(fig,1,nPanels,'TileSpacing','compact','Padding','compact');
    title(tl,heading,'FontWeight','bold','Color','k');
    for q = 1:nPanels
        ax = nexttile(tl);
        imshow(images{q},'Parent',ax);
        title(ax,labels{q},'Color','k','FontSize',11);
    end
end
