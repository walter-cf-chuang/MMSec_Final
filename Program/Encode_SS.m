function output_signal = Encode_SS(y, fs)

% Parameter
p = 0.5;

L = length(y);
segLen = 1000;
%freqLen = floor(segLen/2) + 1;

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

% Codeword
c = zeros(2, n, 1);
c(1, 1:10) = [0 1 0 1 0 1 0 0 0 1];
c(2, 1:10) = [1 0 1 0 1 0 1 1 0 0];

lastSegY = y(1:segLen);
lastX = dct(lastSegY);
minValDct = min(lastX);
shiftVal = -minValDct;
if (shiftVal > 0 )
    lastX = lastX + shiftVal;
end

output_signal = zeros(L,1);

upperBound = floor(L / segLen);
for i=2:upperBound
    
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
        
        maxVal = max(lastX(cHead:cTail));
        
        alpha(cHead:cTail) = p * maxVal;
        
    end
    
    index_c = 1;
    if i == 3 || i == 6 || i == 7
        index_c = 2;
    end
    
    output_y = zeros(n, 1);
    for j=1:n
        output_y(j) = x(j) + alpha(j)*c(index_c, j, 1);
    end
    
    if shiftVal > 0
        output_y = output_y - shiftVal;
    end
    
    % IDCT
    output_signal(segHead:segTail) = idct(output_y);
    
    lastX = x;
    
end

fprintf('Finished Encoding\n');


end