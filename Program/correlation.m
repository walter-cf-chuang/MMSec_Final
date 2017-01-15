function [lagDiff] = correlation(s1, s2, fs)

%% plot two signals
t1 = (0:length(s1)-1)/fs;
t2 = (0:length(s2)-1)/fs;

subplot(2, 1, 1);
plot(t1, s1);
title('s_1');

subplot(2, 1, 2);
plot(t2, s2);
title('s_2');
xlabel('Time (s)');

%% start correlation
[acor, lag] = xcorr(s1, s2);
[~, I] = max(abs(acor));
lagDiff = lag(I)
timeDiff = lagDiff/fs

figure
plot(lag, acor);
a3 = gca;
a3.XTick = sort([-3000:1000:3000 lagDiff]);

end

