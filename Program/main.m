[y, fs] = audioread('Music/Canon_20s.wav');

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

% Parameters
frameSize = 4096;   % Same as codeword size
codebookSize = 2;
p = 0.5;
str = '_p05';

encodedDataSize = floor(length(y)/frameSize);

%% Generate Codebook
cb = randi([0 1], codebookSize, frameSize, 1);
cb(:, 1:floor(frameSize*3/10), 1) = 0;
cb(:, floor(frameSize*7/10):end, 1) = 0;

%% Encoded data
encodedData = randi([1 codebookSize], encodedDataSize, 1);

encodedBits = zeros(encodedDataSize*frameSize, 1);
for i=1:encodedDataSize
    bHead = (i-1)*frameSize+1;
    bTail = i*frameSize;
    encodedBits(bHead:bTail) = cb(encodedData(i), :, :);
end


%% Enocde

% output_signal = Encode_SS(y, fs, encodedBits, frameSize, param_p)
encoded_music = Encode_SS(y, fs, encodedBits, frameSize, p);

audiowrite(['Output/Canon_encoded' str '.wav'], encoded_music, fs);
%sound(y, fs);

save variable_p05.mat cb encodedBits encodedData frameSize;

%% Decode

load variable_p05.mat;

% decodedBits = Decode_SS(y, fs, cb, frameSize)
decodedBits = Decode_SS(encoded_music, fs, cb, frameSize);

decodedData = convertBitsToData(cb, decodedBits);

%% Calculate Bit Error Rate
numDiff = sum((encodedBits == decodedBits) == 0);
BER = numDiff / length(encodedBits);

numDiffData = sum((encodedData == decodedData) == 0);
DER = numDiffData / length(encodedData);

fprintf('BER = %.2f (%d / %d)\n', BER, numDiff, length(encodedBits));
fprintf('DER = %.2f (%d / %d)\n', DER, numDiffData, length(encodedData));