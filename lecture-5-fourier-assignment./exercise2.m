%% Exercise 2 - Two frequencies aligned with the FFT grid
clear; clc; close all;
scriptFolder = fileparts(mfilename('fullpath'));
if isempty(scriptFolder), scriptFolder = pwd; end
fs = 200; T = 1;
t = 0:1/fs:T-1/fs;
x = 0.8*sin(2*pi*15*t) + 0.4*sin(2*pi*40*t);
N = numel(x);
Y = fft(x);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:N/2)/N;

fig1 = figure('Color','w','Name','Exercise 2 - Time domain');
plot(t,x,'LineWidth',1); xlabel('Time (s)'); ylabel('Amplitude');
title('Sum of 15 Hz and 40 Hz sinusoids'); grid on;
exportgraphics(fig1,fullfile(scriptFolder,'two-frequency-time-domain.png'),'Resolution',170);

fig2 = figure('Color','w','Name','Exercise 2 - FFT spectrum');
stem(f,P1,'filled','MarkerSize',3); xlim([0 70]);
xlabel('Frequency (Hz)'); ylabel('Single-sided amplitude');
title('Single-sided FFT amplitude spectrum (1 s)'); grid on;
exportgraphics(fig2,fullfile(scriptFolder,'two-frequency-spectrum.png'),'Resolution',170);

[~,idx15] = min(abs(f-15)); [~,idx40] = min(abs(f-40));
fprintf('N = %d, fs = %.0f Hz, bin spacing = fs/N = %.4f Hz\n',N,fs,fs/N);
fprintf('15 Hz component: bin %.4f Hz, amplitude %.6f (expected 0.8)\n',f(idx15),P1(idx15));
fprintf('40 Hz component: bin %.4f Hz, amplitude %.6f (expected 0.4)\n',f(idx40),P1(idx40));
fid=fopen(fullfile(scriptFolder,'fft_measurements.txt'),'w');
if fid<0, error('Could not write measurement file'); end
fprintf(fid,'N = %d\nfs = %.0f Hz\nBin spacing = %.4f Hz\n',N,fs,fs/N);
fprintf(fid,'15 Hz bin: frequency %.4f Hz, amplitude %.6f\n',f(idx15),P1(idx15));
fprintf(fid,'40 Hz bin: frequency %.4f Hz, amplitude %.6f\n',f(idx40),P1(idx40));
fclose(fid);
