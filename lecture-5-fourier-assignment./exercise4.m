%% Exercise 4 - DTFT versus DFT (4 and 64 FFT points)
clear; clc; close all;
scriptFolder = fileparts(mfilename('fullpath'));
if isempty(scriptFolder), scriptFolder = pwd; end
x = [1 1 1 1];
n = 0:numel(x)-1;
w = linspace(-pi,pi,1000);
X = x * exp(-1j*(n.'*w));

% Frequency samples of DFT, centered on [-pi, pi).
N4 = 4; N64 = 64;
X4 = fftshift(fft(x,N4));
X64 = fftshift(fft(x,N64));
w4 = (-N4/2:N4/2-1)*(2*pi/N4);
w64 = (-N64/2:N64/2-1)*(2*pi/N64);

fig=figure('Color','w','Name','Exercise 4 - DTFT and DFT', ...
    'Position',[100 100 1000 820]);
subplot(3,1,1); plot(w,abs(X),'LineWidth',1.3); grid on;
xlabel('Angular frequency (rad/sample)'); ylabel('|X(e^{j\omega})|');
title('DTFT: continuous function of angular frequency'); xlim([-pi pi]);
subplot(3,1,2); plot(w,abs(X),'Color',[.65 .65 .65]); hold on;
stem(w4,abs(X4),'filled','LineWidth',1.2); grid on;
xlabel('Angular frequency (rad/sample)'); ylabel('Magnitude');
title('DFT: fft(x,4) samples of the DTFT'); xlim([-pi pi]);
subplot(3,1,3); plot(w,abs(X),'Color',[.65 .65 .65]); hold on;
stem(w64,abs(X64),'filled','MarkerSize',2); grid on;
xlabel('Angular frequency (rad/sample)'); ylabel('Magnitude');
title('DFT: fft(x,64) samples of the SAME DTFT'); xlim([-pi pi]);
sgtitle('DTFT and DFT comparison for x = [1 1 1 1]');
exportgraphics(fig,fullfile(scriptFolder,'dtft-dft-comparison.png'),'Resolution',170);
fprintf('Original x contains %d samples\n',numel(x));
fprintf('fft(x,4) has %d frequency samples, spacing 2*pi/4 = %.6f rad/sample\n',N4,2*pi/N4);
fprintf('fft(x,64) has %d frequency samples, spacing 2*pi/64 = %.6f rad/sample\n',N64,2*pi/N64);
fprintf('DTFT zeros in [-pi,pi] occur at w = -pi, -pi/2, pi/2 and pi.\n');
