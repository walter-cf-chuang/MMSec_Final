%% Decode

[recordeded_music, fs] = audioread('Output/Feng0442.wav');

load variable0451.mat;

frameSize = 4096;
encodedData = convertBitsToData(cb, encodedBits);

%% Synchronization
[encoded_music, fs2] = audioread('Output/Canon_encoded.wav');

lagDiff = correlation(encoded_music, recordeded_music, fs);

%% Single round decode
start = (-lagDiff+1);
len = 2646000;

decodedBits = Decode_SS(recordeded_music(start:start+len-1), fs, cb, frameSize);
decodedData = convertBitsToData(cb, decodedBits);

%% Calculate Bit Error Rate
numDiff = sum((encodedBits == decodedBits) == 0);
BER = numDiff / length(encodedBits);

numDiffData = sum((encodedData == decodedData) == 0);
DER = numDiffData / length(encodedData);

fprintf('BER = %.2f (%d / %d)\n', BER, numDiff, length(encodedBits));
fprintf('DER = %.2f (%d / %d)\n', DER, numDiffData, length(encodedData));