%% Exercise 3 - Spectral leakage and zero-padding
% IMPORTANT: Replace d with YOUR OWN student number's last digit (0-9).
% Never include your full student number in the repository.
clear; clc; close all;
scriptFolder = fileparts(mfilename('fullpath'));
if isempty(scriptFolder), scriptFolder = pwd; end

d = 4;  % TODO: CHANGE THIS to your own last digit before submission!
assert(isscalar(d) && isfinite(d) && d == floor(d) && d>=0 && d<=9, ...
    'd must be an integer between 0 and 9');
f2 = 13.2 + 0.17*d;
fs = 200;

% Both recordings have the same sample rate and frequency components.
t1 = 0:1/fs:1-1/fs;
t4 = 0:1/fs:4-1/fs;
x1 = 0.8*sin(2*pi*15*t1) + 0.4*sin(2*pi*f2*t1);
x4 = 0.8*sin(2*pi*15*t4) + 0.4*sin(2*pi*f2*t4);

% Single-sided FFT spectra; use the SAME amplitude normalization convention.
[f1,A1] = localSpectrum(x1,fs,numel(x1));
[f4,A4] = localSpectrum(x4,fs,numel(x4));
[fpad,Apad] = localSpectrum(x1,fs,4*numel(x1));

fig1=figure('Color','w','Name','Exercise 3 - 1 second');
plot(f1,A1,'-o','MarkerSize',3); xlim([8 21]); ylim([0 0.9]);
xlabel('Frequency (Hz)'); ylabel('Single-sided amplitude');
title(sprintf('1 second, d=%d, f2=%.2f Hz, bin=%.2f Hz',d,f2,fs/numel(x1)));
grid on;
exportgraphics(fig1,fullfile(scriptFolder,'leakage-one-second.png'),'Resolution',170);

fig2=figure('Color','w','Name','Exercise 3 - 4 seconds');
plot(f4,A4,'-o','MarkerSize',2); xlim([8 21]); ylim([0 0.9]);
xlabel('Frequency (Hz)'); ylabel('Single-sided amplitude');
title(sprintf('4 seconds, d=%d, f2=%.2f Hz, bin=%.2f Hz',d,f2,fs/numel(x4)));
grid on;
exportgraphics(fig2,fullfile(scriptFolder,'leakage-four-seconds.png'),'Resolution',170);

fig3=figure('Color','w','Name','Exercise 3 - zero-padded 1 second');
plot(f1,A1,'o-','MarkerSize',3); hold on;
plot(fpad,Apad,'-','LineWidth',1.2);
xlim([8 21]); ylim([0 0.9]); grid on;
legend('1 s native FFT','1 s zero padded 4x','Location','best');
xlabel('Frequency (Hz)'); ylabel('Single-sided amplitude');
title('Zero-padding interpolates the displayed spectrum, not the measured signal');
exportgraphics(fig3,fullfile(scriptFolder,'leakage-zero-padded.png'),'Resolution',170);

fig4=figure('Color','w','Name','Exercise 3 - Comparison');
plot(f1,A1,'o-','MarkerSize',3); hold on;
plot(f4,A4,'-','LineWidth',1.2);
plot(fpad,Apad,'--','LineWidth',1.1);
xlim([8 21]); ylim([0 0.9]); grid on;
legend('1 s, N=200','4 s, N=800','1 s, zero padded NFFT=800','Location','best');
xlabel('Frequency (Hz)'); ylabel('Single-sided amplitude');
title(sprintf('Spectral leakage comparison: f2=%.2f Hz (d=%d)',f2,d));
exportgraphics(fig4,fullfile(scriptFolder,'leakage-comparison.png'),'Resolution',170);

fprintf('d=%d, f2=%.4f Hz\n',d,f2);
fprintf('1 second: N=%d, bin spacing %.4f Hz\n',numel(x1),fs/numel(x1));
fprintf('4 seconds: N=%d, bin spacing %.4f Hz\n',numel(x4),fs/numel(x4));
fprintf('1 second 4x zero-padded: NFFT=%d, displayed FFT grid spacing %.4f Hz\n', ...
    4*numel(x1),fs/(4*numel(x1)));
fid=fopen(fullfile(scriptFolder,'leakage_measurements.txt'),'w');
if fid<0, error('Could not write measurements'); end
fprintf(fid,'d = %d\nf2 = %.4f Hz\n1 s: N=%d, bin spacing %.4f Hz\n',d,f2,numel(x1),fs/numel(x1));
fprintf(fid,'4 s: N=%d, bin spacing %.4f Hz\n',numel(x4),fs/numel(x4));
fprintf(fid,'Zero padded 1 s: NFFT=%d, FFT display spacing %.4f Hz\n', ...
    4*numel(x1),fs/(4*numel(x1)));
fprintf(fid,'Zero padding changes FFT grid, NOT underlying 1-second observation duration.\n');
fclose(fid);

function [f,A] = localSpectrum(x,fs,nfft)
    N=numel(x);
    Y=fft(x,nfft);
    A=abs(Y(1:nfft/2+1))/N; % Normalize by actual number of samples, NOT nfft
    A(2:end-1)=2*A(2:end-1);
    f=fs*(0:nfft/2)/nfft;
end
