clearvars, clc, close all;
[a1, fs1] = audioread('./audios/1.wav');

q = zeros(1, length(a1)-1);
for ix = 1:length(q)
    q(ix) = abs(a1(ix+1))-abs(a1(ix));
end

q = 20*log(1./q);

sq = a1.^2;
figure
    subplot(2, 2, 1)
        plot(a1);

    subplot(2, 2, 2)
        plot(sq);
    
    subplot(2, 2, 3)
        plot(sq./max(sq))

    subplot(2, 2, 4)
        plot(q);
