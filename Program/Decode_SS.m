function decodedBits = Decode_SS(y, fs, cb, frameSize)

L = length(y);
segLen = frameSize;

%% Critical Bands
nyquistRate = fs / 2;

criticalBands = [50 95 140 235 330 420 560 660 800 940 1125 1265 1500 1735 1970 2340 2720 3280 3840 4690 5440 6375 7690 9375 11625 15375 20250];

range = nyquistRate / segLen;
index_criticalBands = criticalBands / range;

indexRange_criticalBands = zeros(length(criticalBands)+1, 2);
lowerbound = 1;
for i=1:length(criticalBands)
    
    upperbound = floor(index_criticalBands(i));
    
    indexRange_criticalBands(i, 1) = lowerbound;
    indexRange_criticalBands(i, 2) = upperbound;
    
    lowerbound = upperbound+1;
end

indexRange_criticalBands(i+1, 1) = lowerbound;
indexRange_criticalBands(i+1, 2) = segLen;


%% Start decoding
n = segLen;

% Codebook
numCb = size(cb, 1);

%Precalculate some variables to improve speed
cbMagnitude = zeros(numCb, 1);
for i=1:numCb
    cbMagnitude(i) = sqrt(dot(cb(i, :, :), cb(i, :, :)));
end



decodedBits = zeros(floor(L/segLen) * segLen, 1);

upperBound = floor(L / segLen);
for i=1:upperBound
    
    segHead = (i-1)*segLen+1;
    segTail = i*segLen;
    
    segY = y(segHead: segTail);
    
    x = abs(dct(segY));
    
    normalized_x = zeros(n, 1);
    
    % Normalize x for each critical band
    for j=1:length(indexRange_criticalBands)
        
        cHead = indexRange_criticalBands(j,1);
        cTail = indexRange_criticalBands(j,2);
        
        maxVal = max(x(cHead:cTail));
        
        %alpha(cHead:cTail) = p * maxVal;
        for k=cHead:cTail
            normalized_x(k) = x(k) / maxVal;
        end
        
        
    end
    
    
    maxR = -Inf;
    possible_c = 0;
    % Correlation
    for j=1:numCb
        r = dot(normalized_x, cb(j, :, :)) / (sqrt(dot(normalized_x, normalized_x)) * cbMagnitude(j) );
        if r > maxR
            maxR = r;
            possible_c = j;
        end
    end
    
    decodedBits(segHead:segTail, 1) = cb(possible_c, :, 1);
    
    % Log
%     fprintf('i=%d, Possible c (%d) with r = %f:\n', i, possible_c, maxR);
%     fprintf('[');
%     for j=1:n
%         fprintf('%2d', cb(possible_c, j, 1));
%     end
%     fprintf(']\n');
%     fprintf('');
end

 fprintf('Finished Decoding\n');


end