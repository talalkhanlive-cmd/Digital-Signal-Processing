%% Tire Stud Detector - MATLAB Image Processing Lab
% Studded versus non-studded tire classification using image preprocessing,
% local bright-spot detection, morphology, and regionprops.
% Works on the two included demonstration images without editing paths.
% Requires Image Processing Toolbox.
clear; clc; close all;

projectDir = fileparts(mfilename('fullpath'));
if isempty(projectDir), projectDir = pwd; end
resultDir = fullfile(projectDir, 'results');
if ~isfolder(resultDir), mkdir(resultDir); end

imageFiles = {'studded_tire.jpeg', 'summer_tire.jpg'};
referenceLabels = {'STUDDED TIRE', 'NON-STUDDED TIRE'};
fileNames = strings(numel(imageFiles), 1);
reference = strings(numel(imageFiles), 1);
predicted = strings(numel(imageFiles), 1);
counts = zeros(numel(imageFiles), 1);
densities = zeros(numel(imageFiles), 1);

% Initial heuristic parameters: inspect the marked candidates for correctness.
minArea = 3;       % Minimum stud-candidate area (pixels)
maxArea = 90;      % Maximum stud-candidate area (pixels)
minCircularity = 0.65;
maxEccentricity = 0.90;
minSolidity = 0.55;
countThreshold = 20;   % Demo decision rule, not a calibrated universal threshold

for i = 1:numel(imageFiles)
    inputFile = fullfile(projectDir, imageFiles{i});
    % Also accept Windows duplicate filenames such as studded_tire (1).jpeg.
    if ~isfile(inputFile)
        [~, stem, ~] = fileparts(imageFiles{i});
        matches = dir(fullfile(projectDir, [stem '*.jp*']));
        matches = matches(~[matches.isdir]);
        if ~isempty(matches)
            inputFile = fullfile(projectDir, matches(1).name);
        end
    end
    assert(isfile(inputFile), ...
        'Required tire image missing from the script folder: %s', ...
        imageFiles{i});
    fprintf('Image loaded: %s\n', inputFile);

    %% 1. Read and resize
    original = imread(inputFile);
    resizeFactor = min(1, 700 / max(size(original,1),size(original,2)));
    if resizeFactor < 1
        original = imresize(original, resizeFactor);
    end

    %% 2. Convert to grayscale
    if size(original,3) == 3
        gray = im2double(rgb2gray(original));
    else
        gray = im2double(original);
    end

    %% 3. Isolate the dark tire region
    % Background is often brighter, so threshold and retain the largest region.
    tireMask = gray < 0.82;
    tireMask = imclose(tireMask, strel('disk', 6));
    tireMask = imfill(tireMask, 'holes');
    tireMask = bwareaopen(tireMask, max(30, round(numel(gray)*0.004)));
    if ~any(tireMask(:))
        warning('Tire region not found in %s; using the whole image.', imageFiles{i});
        tireMask = true(size(gray));
    else
        tireMask = bwareafilt(tireMask, 1);
    end
    tireInterior = imerode(tireMask, strel('disk', 3));

    %% 4. Detect locally bright stud candidates inside the tire
    enhanced = adapthisteq(gray, 'ClipLimit', 0.02);
    topHat = imtophat(enhanced, strel('disk', 8));
    threshold = max(0.14, graythresh(topHat));
    cand = topHat > threshold & tireInterior;
    cand = bwareaopen(cand, minArea);

    %% 5-6. Connected components and shape filters
    CC = bwconncomp(cand);
    stats = regionprops(CC, 'Area', 'Perimeter', 'Eccentricity', ...
                       'Solidity', 'Centroid', 'PixelIdxList');
    studMask = false(size(cand));
    studCount = 0;
    studCenters = zeros(0,2);
    for k = 1:numel(stats)
        area = stats(k).Area;
        perimeter = stats(k).Perimeter;
        circularity = 4*pi*area / max(perimeter^2, eps);
        valid = (area >= minArea) && (area <= maxArea) && ...
                (circularity >= minCircularity) && ...
                (stats(k).Eccentricity <= maxEccentricity) && ...
                (stats(k).Solidity >= minSolidity);
        if valid
            studCount = studCount + 1;
            studMask(stats(k).PixelIdxList) = true;
            studCenters(end+1,:) = stats(k).Centroid; %#ok<SAGROW>
        end
    end

    %% 7. Simple rule-based decision
    isStudded = studCount >= countThreshold;
    if isStudded
        resultLabel = 'STUDDED TIRE';
    else
        resultLabel = 'NON-STUDDED TIRE';
    end
    studDensity = studCount / max(nnz(tireInterior)/10000, eps);
    fprintf('%s: %s | %d candidates | %.2f candidates / 10k tire pixels\n', ...
        imageFiles{i}, resultLabel, studCount, studDensity);

    %% 8. Three-panel visualization
    fig = figure('Name', imageFiles{i}, 'Color', 'w', ...
                 'Position', [90 90 1350 480]);
    subplot(1,3,1);
    imshow(original);
    title('Original image', 'Color','k');
    subplot(1,3,2);
    imshow(cand);
    title('Candidate bright spots', 'Color','k');
    subplot(1,3,3);
    imshow(original); hold on;
    if ~isempty(studCenters)
        plot(studCenters(:,1), studCenters(:,2), 'g+', ...
             'MarkerSize', 7, 'LineWidth', 1.2);
    end
    title(sprintf('%s | %d candidates', resultLabel, studCount), ...
          'Color','k');
    sgtitle(['Tire stud candidate detection - ', imageFiles{i}], ...
            'Interpreter','none', 'Color','k');
    [~,baseName,~] = fileparts(imageFiles{i});
    exportgraphics(fig, fullfile(resultDir, [baseName '_detection.png']), ...
                   'Resolution', 170);
    close(fig);

    % Additional tire-region and accepted-component visual for verification.
    fig2 = figure('Name', [baseName ' inspection'], 'Color', 'w', ...
                  'Position', [100 100 900 400]);
    subplot(1,2,1); imshow(tireMask); title('Tire mask', 'Color','k');
    subplot(1,2,2); imshow(studMask); title('Accepted round components', 'Color','k');
    exportgraphics(fig2, fullfile(resultDir, [baseName '_masks.png']), ...
                   'Resolution', 150);
    close(fig2);

    fileNames(i) = string(imageFiles{i});
    reference(i) = string(referenceLabels{i});
    predicted(i) = string(resultLabel);
    counts(i) = studCount;
    densities(i) = studDensity;
end

%% Save CSV summary for the README and GitHub
T = table(fileNames, reference, predicted, counts, densities, ...
    'VariableNames', {'ImageFile','ExampleLabel','PredictedLabel', ...
                       'StudCandidates','CandidatesPer10000TirePixels'});
writetable(T, fullfile(resultDir,'detection_results.csv'));
disp(T);
fprintf('Saved figures and CSV inside: %s\n', resultDir);
fprintf('NOTE: Results are candidate counts, not verified metal-stud ground truth.\n');
