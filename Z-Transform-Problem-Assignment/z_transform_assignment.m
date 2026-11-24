
%% Z-Transform Problem Assignment
% Parts 1 and 2 - Discrete-Time Signals and Systems
clear; clc; close all;

%% Part 1: Original signal and one-sample delay

x = [1 2 1];
n = 0:length(x)-1;

xDelayed = [0 x];
nDelayed = 0:length(xDelayed)-1;

figure('Name','Original and Delayed Signal');

subplot(2,1,1);
stem(n,x,'filled');
title('Original Signal x[n]');
xlabel('Sample n');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
stem(nDelayed,xDelayed,'filled');
title('One-Sample Delay x[n-1]');
xlabel('Sample n');
ylabel('Amplitude');
grid on;

% Save first figure
saveas(gcf,'01_original_and_delayed.png');

%% Part 2: Averaging filter

b = [0.5 0.5];
a = 1;

xInput = [x 0];
nOutput = 0:length(xInput)-1;

y = filter(b,a,xInput);

figure('Name','Input and Output');

subplot(2,1,1);
stem(nOutput,xInput,'filled');
title('Input Signal x[n]');
xlabel('Sample n');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
stem(nOutput,y,'filled');
title('Output Signal y[n]');
xlabel('Sample n');
ylabel('Amplitude');
grid on;

saveas(gcf,'02_input_and_output.png');

disp('Output samples for b = [0.5 0.5]:');
disp(y);

%% Part 3: Modified filter

bModified = [0.8 0.2];

yModified = filter(bModified,a,xInput);

figure('Name','Filter Comparison');

stem(nOutput,y,'filled','LineWidth',1.2);
hold on;

stem(nOutput,yModified,'--','LineWidth',1.2);

title('Original vs Modified Filter');
xlabel('Sample n');
ylabel('Amplitude');

legend('H(z) = 0.5 + 0.5z^{-1}', ...
    'H(z) = 0.8 + 0.2z^{-1}');

grid on;

saveas(gcf,'03_filter_comparison.png');

disp('Output samples for b = [0.8 0.2]:');
disp(yModified);

disp('Assignment completed successfully.');

