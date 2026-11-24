%% Exercise 1 - Square wave from odd harmonics
% Prediction: adding odd harmonics makes the approximation more square-like.
% Overshoot near jumps persists (Gibbs phenomenon).
clear; clc; close all;
scriptFolder = fileparts(mfilename('fullpath'));
if isempty(scriptFolder), scriptFolder = pwd; end

t = linspace(-1,1,4000);
Hvalues = [1 3 9 25];
fig = figure('Color','w','Name','Exercise 1 - Fourier Series', ...
    'Position',[100 100 1050 660]);
for j = 1:numel(Hvalues)
    H = Hvalues(j);
    x = zeros(size(t));
    for k = 1:2:H
        x = x + (4/pi)*sin(2*pi*k*t)/k;
    end
    subplot(2,2,j);
    plot(t,x,'LineWidth',1.1); hold on;
    plot(t,ones(size(t)),'k:','LineWidth',0.7);
    plot(t,-ones(size(t)),'k:','LineWidth',0.7);
    xlabel('Time (s)'); ylabel('Amplitude');
    title(sprintf('Highest odd harmonic H = %d',H));
    axis([-1 1 -1.5 1.5]); grid on;
    fprintf('H = %d: used %d odd harmonics, max |value| = %.4f\n', ...
        H,numel(1:2:H),max(abs(x)));
end
sgtitle('Odd-harmonic Fourier series approximations');
exportgraphics(fig,fullfile(scriptFolder,'square-wave-comparison.png'),'Resolution',170);
disp('Saved exercise-1/square-wave-comparison.png');
