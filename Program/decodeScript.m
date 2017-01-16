%% Decode

[recordeded_music, fs] = audioread('Record/canon_p05.wav');

%load variable_p05.mat;

frameSize = 4096;
encodedData = convertBitsToData(cb, encodedBits);

%% Synchronization
[original_music, fs2] = audioread('Music/Canon_20s.wav');

lagDiff = correlation(original_music, recordeded_music, fs);

%% Single round decode
start = (-lagDiff+1);
len = 882000;

decodedBits = Decode_SS(recordeded_music(start:start+len-1), fs, cb, frameSize);
decodedData = convertBitsToData(cb, decodedBits);

%% Calculate Bit Error Rate
numDiff = sum((encodedBits == decodedBits) == 0);
BER = numDiff / length(encodedBits);

numDiffData = sum((encodedData == decodedData) == 0);
DER = numDiffData / length(encodedData);

fprintf('BER = %.2f (%d / %d)\n', BER, numDiff, length(encodedBits));
fprintf('DER = %.2f (%d / %d)\n', DER, numDiffData, length(encodedData));