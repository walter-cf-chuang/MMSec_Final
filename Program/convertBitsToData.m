function [data] = convertBitsToData(cb, bits)

cbNum = size(cb, 1);
cLen = size(cb, 2);

numData = (length(bits) / cLen);
data = zeros(numData, 1);

for i=1:numData
    
    bHead = (i-1)*cLen+1;
    bTail = i*cLen;
    
    iBits = bits(bHead:bTail, 1);
    
    for j=1:cbNum
        if iBits == transpose(cb(j, :, 1))
            data(i) = j;
        end
    end
    
end


end

