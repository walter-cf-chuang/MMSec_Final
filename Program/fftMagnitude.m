function x = fftMagnitude(y)

L = length(y);

Y = fft(y);

% the data type of fft = a+bi, use abs() to calculate the magnitude
P2 = abs(Y / L);

% The highest frequency = Fs/2(according to the Nyquist Rate), so we only need half of the frequency domain data
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

x = P1;

end

