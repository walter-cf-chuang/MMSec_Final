function output_signal = Encode_SS(y, fs, encodedBits, frameSize, param_p)

% Parameters
p = param_p;

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


%% Start encoding
n = segLen;

output_signal = y;

upperBound = floor(L / segLen);
for i=1:upperBound
    
    segHead = (i-1)*segLen+1;
    segTail = i*segLen;
    
    segY = y(segHead: segTail);
    
    x = dct(segY);
    
    minValDct = min(x);
    shiftVal = -minValDct;
    if (shiftVal > 0 )
        x = x + shiftVal;
    end
    
    % Calculate alpha for each critical band
    alpha = zeros(n, 1);
    for j=1:length(indexRange_criticalBands)
        
        cHead = indexRange_criticalBands(j,1);
        cTail = indexRange_criticalBands(j,2);
        
        maxVal = max(x(cHead:cTail));
        
        alpha(cHead:cTail) = p * maxVal;
        
    end
    
    
    c = encodedBits(segHead:segTail);
    
    output_y = zeros(n, 1);
    for j=1:n
        output_y(j) = x(j) + alpha(j)*c(j);
    end
    
    if shiftVal > 0
        output_y = output_y - shiftVal;
    end
    
    % IDCT
    output_signal(segHead:segTail) = idct(output_y);
    
    
end

fprintf('Finished Encoding\n');


end