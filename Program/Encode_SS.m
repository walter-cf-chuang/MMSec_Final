function Encode_SS(y, fs)

% Parameter
p = 0.5;

L = length(y);
segLen = 1000;
freqLen = floor(segLen/2) + 1;

% Critical Bands
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

indexRange_criticalBands(i, 1) = lowerbound;
indexRange_criticalBands(i, 2) = freqLen;


% Start encoding
n = freqLen;

% Codeword
c = zeros(n, 1);
c(2) = 1; c(4) = 1; c(5) = 1;

lastSegY = y(1:segLen);
lastX = fftMagnitude(lastSegY);

upperBound = floor(L / segLen);
for i=2:upperBound
    
    segY = y((i-1)*segLen+1 : i*segLen);
    
    x = fftMagnitude(segY);
    
    % Calculate alpha for each critical band
    alpha = zeros(n, 1);
    for j=1:length(indexRange_criticalBands)
        
        cHead = indexRange_criticalBands(j,1);
        cTail = indexRange_criticalBands(j,2);
        
        maxVal = max(lastX(cHead:cTail));
        
        alpha(cHead:cTail) = p * maxVal;
        
    end
    
    for j=1:n
        output_y(i) = x(i) + alpha(i)*c(i);
    end
    
    % IFFT
    
end




end