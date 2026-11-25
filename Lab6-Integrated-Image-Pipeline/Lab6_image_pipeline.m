%% Lab 6 - Mini Project: Integrated Image Processing Pipeline
% Demonstration subject: a photograph of a coffee cup (sample_image.jpg).
% The image is included in this project folder, so no editing is needed.
% Requires MATLAB Image Processing Toolbox.
close all; clear; clc;

%% Locate this script's folder and the bundled sample photograph
projectDir = fileparts(mfilename('fullpath'));
if isempty(projectDir), projectDir = pwd; end
imageFile = fullfile(projectDir,'sample_image.jpg');
assert(isfile(imageFile), 'Missing sample_image.jpg in %s', projectDir);
Irgb = imread(imageFile);
if size(Irgb,3) == 3
    I = im2double(rgb2gray(Irgb));
else
    I = im2double(Irgb);
end
[M,N] = size(I);

%% 1) Preprocessing - 3x3 median filter
I_filt = medfilt2(I,[3 3], 'symmetric');

%% 2) Contrast enhancement - linear intensity mapping
I_enh = imadjust(I_filt,[0.2 0.8],[0 1]);

%% 3) Edge extraction - Canny detector
edges = edge(I_enh,'Canny',[0.1 0.25]);

%% 4) Frequency-domain ideal low-pass (circular frequency mask)
F = fftshift(fft2(I_enh));
[u,v] = meshgrid(-floor(N/2):ceil(N/2)-1, ...
                 -floor(M/2):ceil(M/2)-1);
cutoffRadius = 60;
H = double(hypot(u,v) < cutoffRadius);
I_lp = real(ifft2(ifftshift(F.*H)));
I_lp_display = min(max(I_lp,0),1); % only for display

%% 5) Main pipeline comparison
fig1 = figure('Color','white','Name','Lab 6 - Complete Image Pipeline', ...
    'Position',[80 120 1500 450]);
tiledlayout(1,5,'TileSpacing','compact','Padding','compact');
nexttile; imshow(I); title('1. Original','Color','k');
nexttile; imshow(I_filt); title('2. Median filter','Color','k');
nexttile; imshow(I_enh); title('3. Enhanced','Color','k');
nexttile; imshow(edges); title('4. Canny edges','Color','k');
nexttile; imshow(I_lp_display); title('5. Frequency LP','Color','k');
exportgraphics(fig1,fullfile(projectDir,'01_pipeline_comparison.png'),'Resolution',180);

%% 6) Grayscale histograms, before and after contrast enhancement
fig2 = figure('Color','white','Name','Lab 6 - Contrast Histograms', ...
    'Position',[150 150 1000 430]);
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');
nexttile; imhist(I); title('Original image histogram','Color','k');
xlabel('Pixel intensity'); ylabel('Pixel count'); grid on;
nexttile; imhist(I_enh); title('Enhanced image histogram','Color','k');
xlabel('Pixel intensity'); ylabel('Pixel count'); grid on;
exportgraphics(fig2,fullfile(projectDir,'02_contrast_histograms.png'),'Resolution',180);

%% 7) Display Fourier magnitude and filtering mask
fig3 = figure('Color','white','Name','Lab 6 - Frequency Domain', ...
    'Position',[150 150 1000 430]);
tiledlayout(1,2,'TileSpacing','compact','Padding','compact');
nexttile; imshow(log1p(abs(F)),[]); title('Centered log FFT magnitude','Color','k');
nexttile; imshow(H,[]); title('Ideal LP frequency mask','Color','k');
exportgraphics(fig3,fullfile(projectDir,'03_frequency_domain.png'),'Resolution',180);

%% 8) Print basic reproducible measurements
fprintf('Lab 6 complete. Input: %s\n', imageFile);
fprintf('Image dimensions: %d x %d pixels\n',M,N);
fprintf('Grayscale std dev: original %.5f; median %.5f; enhanced %.5f\n', ...
    std(I(:)),std(I_filt(:)),std(I_enh(:)));
fprintf('Canny edge pixels: %d (%.2f%% of image)\n', ...
    nnz(edges),100*nnz(edges)/numel(edges));
fprintf('Frequency-domain mask cutoff radius: %d frequency pixels\n', cutoffRadius);
fprintf('Saved three PNG figures next to the MATLAB script.\n');
