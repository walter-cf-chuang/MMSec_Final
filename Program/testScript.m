
%% Calculate SNR
% [y, fs] = audioread('Music/Canon_20s.wav');
% [y1, fs1] = audioread('Output/Canon_encoded_p02.wav');
% [y2, fs2] = audioread('Output/Canon_encoded_p03.wav');
% [y3, fs3] = audioread('Output/Canon_encoded_p04.wav');
% [y4, fs4] = audioread('Output/Canon_encoded_p05.wav');
% 
% SNRs = [snr(y, y1), snr(y, y2), snr(y, y3), snr(y, y4)];


%% Plot chart
p = [0.2 0.3 0.4 0.5];
DER = [0.01 0.00 0.00 0.00];
SNRs = [-0.0029,-0.0060,-0.0105,-0.0155];

figure;
plot(p, SNRs, 'x-');08;
title('p - SNR');
xlabel('p');
ylabel('SNR');
axis([0.1 0.6 -0.02 0]);


%% Plot chart for audio in time domain and frequency domain
% [y, fs] = audioread('Music/Canon_1min.wav');
% 
% time = 20;
% y = y(1:44100*20,1);
% 
% audiowrite('Music/Canon_20s.wav', y, fs);

% %% Original Signal in Time Domain
% 
% time = (1:length(y)) / fs;
% figure;
% plot(time, y);
% 
% %% Original Signal in Frequency Domain
% 
% L = length(y);
% P1 = fftMagnitude(y);
% 
% % calculate the label(scale) of X axis
% fx = fs * (0:(L/2)) / L;
% figure;
% plot(fx, P1);
% title('Single-Sided Amplitude Spectrum of X(t)');
% xlabel('f (Hz)');
% ylabel('|P1(f)|');