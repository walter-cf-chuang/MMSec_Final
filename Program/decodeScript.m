%% Decode

[encoded_music, fs] = audioread('Output/canon_feng.wav');

load variable.mat;

frameSize = 4096;
encodedData = convertBitsToData(cb, encodedBits);

% minI = -1;
% minBER = 100.0;
% minDER = 100.0;
% for i=88200:114661
%     % decodedBits = Decode_SS(y, fs, cb, frameSize)
%     decodedBits = Decode_SS(encoded_music(i:i+2646000-1), fs, cb, frameSize);
%     decodedData = convertBitsToData(cb, decodedBits);
% 
%     %% Calculate Bit Error Rate
%     numDiff = sum((encodedBits == decodedBits) == 0);
%     BER = numDiff / length(encodedBits);
%     
%     numDiffData = sum((encodedData == decodedData) == 0);
%     DER = numDiffData / length(encodedData);
%     
%     if BER < minBER
%         minBER = BER;
%         minI = i; 
%     end
%     
%     if DER < minDER
%         minDER = DER;
%     end
% 
%     fprintf('BER = %.2f (%d / %d)\n', BER, numDiff, length(encodedBits));
%     fprintf('DER = %.2f (%d / %d)\n', DER, numDiffData, length(encodedData));
% end

% % decodedBits = Decode_SS(y, fs, cb, frameSize)
% decodedBits = Decode_SS(encoded_music, fs, cb, frameSize);
% 
% %% Calculate Bit Error Rate
% numDiff = sum((encodedBits == decodedBits) == 0);
% BER = numDiff / length(encodedBits);
% 
% fprintf('BER = %.2f (%d / %d)\n', BER, numDiff, length(encodedBits));


    

    %% Single round decode
    lagDiff = -33296;
    start = (-lagDiff+1);
    len = 2646000;
    
    decodedBits = Decode_SS(encoded_music(start:start+len-1), fs, cb, frameSize);
    decodedData = convertBitsToData(cb, decodedBits);

    %% Calculate Bit Error Rate
    numDiff = sum((encodedBits == decodedBits) == 0);
    BER = numDiff / length(encodedBits);
    
    numDiffData = sum((encodedData == decodedData) == 0);
    DER = numDiffData / length(encodedData);
    
    fprintf('BER = %.2f (%d / %d)\n', BER, numDiff, length(encodedBits));
    fprintf('DER = %.2f (%d / %d)\n', DER, numDiffData, length(encodedData));