%% Tire Stud Detector - Image Preprocessing and Connected Components
% MATLAB R2026b | Image Processing Toolbox
% Place studded_tire.jpeg and summer_tire.jpg in the same folder as this script.
% Results are illustrative candidates, not a certified tire classification.
clear; clc; close all;

projectDir = fileparts(mfilename('fullpath'));
if isempty(projectDir), projectDir = pwd; end
resultsDir = fullfile(projectDir, 'results');
if ~exist(resultsDir, 'dir'), mkdir(resultsDir); end

imageFiles = {'studded_tire.jpeg', 'summer_tire.jpg'};
missing = imageFiles(~cellfun(@(f) isfile(fullfile(projectDir,f)), imageFiles));
if ~isempty(missing)
    fprintf(2, 'Missing required teacher-provided image(s):\n');
    for j = 1:numel(missing)
        fprintf(2, '  %s\n', missing{j});
    end
    error(['Download both images from the Moodle assignment and save them in: ' projectDir]);
end

% Detector configuration; suitable values depend on the supplied photographs.
resizeScale = 0.5;
minA = 4;
maxA = 120;
minCirc = 0.60;
maxEcc = 0.85;
minimumCount = 10;  % Prototype rule, not calibrated against ground truth.

names = strings(numel(imageFiles),1);
counts = zeros(numel(imageFiles),1);
densities = zeros(numel(imageFiles),1);
labels = strings(numel(imageFiles),1);

for i = 1:numel(imageFiles)
    name = imageFiles{i};
    I = imread(fullfile(projectDir,name));
    I = imresize(I,resizeScale);
    if size(I,3) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end
    gray = im2double(Igray);
    [height,width] = size(gray);

    %% 1. Tire mask from dark region, then restrict to largest object
    % This assumes the tire is darker than the surrounding background.
    threshold = graythresh(gray);
    dark = gray < threshold;
    dark = imclose(dark, strel('disk',max(2,round(min(height,width)*0.012))));
    dark = imfill(dark,'holes');
    dark = bwareaopen(dark,max(40,round(numel(gray)*0.002)));
    if any(dark(:))
        CCtire = bwconncomp(dark);
        sizes = cellfun(@numel,CCtire.PixelIdxList);
        [~,biggest] = max(sizes);
        tireMask = false(size(dark));
        tireMask(CCtire.PixelIdxList{biggest}) = true;
    else
        warning('No dark tire region identified in %s.',name);
        tireMask = false(size(dark));
    end

    %% 2. Bright stud candidates: local contrast, limited to tire interior
    % Morphological white top-hat highlights points brighter than their vicinity.
    topHatRadius = max(3,round(min(height,width)*0.012));
    enhanced = imtophat(gray,strel('disk',topHatRadius));
    localValues = enhanced(tireMask);
    if ~isempty(localValues)
        % Adaptive to image intensity; avoid a zero threshold for flat regions.
        localThreshold = max(0.05,graythresh(localValues));
        cand = (enhanced > localThreshold) & tireMask;
    else
        cand = false(size(gray));
    end
    cand = bwareaopen(cand,minA);
    cand = imopen(cand,strel('disk',1));
    cand = cand & tireMask;

    %% 3. Connected components and size/shape filtering
    CC = bwconncomp(cand);
    stats = regionprops(CC,'Area','Perimeter','Eccentricity','Centroid','PixelIdxList');
    studMask = false(size(cand));
    centers = zeros(0,2);
    for k = 1:numel(stats)
        area = stats(k).Area;
        perim = stats(k).Perimeter;
        circularity = 4*pi*area/max(perim^2,eps);
        if area >= minA && area <= maxA && ...
                circularity >= minCirc && stats(k).Eccentricity <= maxEcc
            studMask(stats(k).PixelIdxList) = true;
            centers(end+1,:) = stats(k).Centroid; %#ok<SAGROW>
        end
    end
    studCount = size(centers,1);
    tireArea = nnz(tireMask);
    studDensity = studCount/max(tireArea,1)*10000; % detections per 10000 tire pixels
    isStudded = studCount > minimumCount;
    if isStudded
        resultLabel = "STUDDED TIRE";
    else
        resultLabel = "NON-STUDDED TIRE";
    end

    %% 4. Figure: original, candidate spots, final detections
    f = figure('Color','w','Name',sprintf('Tire analysis: %s',name), ...
        'Position',[100 100 1400 470]);
    subplot(1,3,1);
    imshow(I); title('Original tire image','Color','k');
    subplot(1,3,2);
    imshow(cand); title('Bright candidate mask','Color','k');
    subplot(1,3,3);
    imshow(I); hold on;
    if ~isempty(centers)
        plot(centers(:,1),centers(:,2),'go','MarkerSize',7,'LineWidth',1.25);
    end
    title(sprintf('%s | candidates passing shape checks: %d',resultLabel,studCount), ...
        'Color','k','Interpreter','none');
    hold off;
    [~,base] = fileparts(name);
    exportgraphics(f,fullfile(resultsDir,[base '_detection.png']),'Resolution',180);

    % Additional mask for inspection / verification
    f2 = figure('Color','w','Name',sprintf('Masks: %s',name), ...
        'Position',[130 130 1200 400]);
    subplot(1,3,1); imshow(tireMask); title('Estimated tire area','Color','k');
    subplot(1,3,2); imshow(enhanced,[]); title('Bright local detail (top-hat)','Color','k');
    subplot(1,3,3); imshow(studMask); title('Size/shape-filtered components','Color','k');
    exportgraphics(f2,fullfile(resultsDir,[base '_masks.png']),'Resolution',180);

    names(i) = string(name);
    counts(i) = studCount;
    densities(i) = studDensity;
    labels(i) = resultLabel;
    fprintf('%s: %d candidates, %.2f / 10000 tire pixels -> %s\n', ...
        name,studCount,studDensity,resultLabel);
end

results = table(names,counts,densities,labels, ...
    'VariableNames',{'File','DetectedCandidateCount','CandidatesPer10000TirePixels','PrototypeClassification'});
writetable(results,fullfile(resultsDir,'tire_detection_results.csv'));
disp(results);
fprintf('\nSaved all figures and the summary CSV in: %s\n',resultsDir);
fprintf('Check detected markers manually: bright reflections can be mistaken for studs.\n');
