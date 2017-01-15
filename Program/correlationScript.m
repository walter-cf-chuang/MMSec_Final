%% Decode

[y1, fs1] = audioread('Output/Canon_encoded.wav');
[y2, fs2] = audioread('Output/canon_feng.wav');

lagDiff = correlation(y1, y2, fs1);