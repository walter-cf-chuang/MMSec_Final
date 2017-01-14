[y, fs] = audioread('Music/Canon_1min.wav');

y = y(:,1);

%% Original Signal in Time Domain

% time = (1:length(y)) / fs;
% figure;
% plot(time, y);

%% Original Signal in Frequency Domain

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

%% Enocde
encoded_music = Encode_SS(y, fs);

audiowrite('Output/Canon_encoded.wav', encoded_music, fs);
%sound(y, fs);

%% Decode
Decode_SS(encoded_music, fs);