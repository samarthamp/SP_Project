clearvars, clc, close all;

% List of audio and text file names
% audioFiles = {'./audios/1.wav', './audios/2.wav', './audios/3.wav', './audios/4.wav',  './audios/5.wav',  './audios/6.wav',  './audios/7.mp3',  './audios/8.mp3', './audios/9.mp3'};
% textFiles = {'./text/1.txt', './text/2.txt', './text/3.txt',  './text/4.txt',  './text/5.txt',  './text/6.txt',  './text/7.txt',  './text/8.txt', './text/9.txt'};
audioFiles = {'./audios/2.wav'};

for i = 1:length(audioFiles)

    [audioData, fs] = audioread(audioFiles{i});
    audioData = audioData';

    N = length(audioData);
    mag_spectra = fftshift(abs(fft(audioData)));

    % Defining segment/window
    segment = ones(1, ceil(N/1e5));
    seglen = length(segment);

    seg_energy = zeros(1, N);

    % Append zeros of length seglen-1 to allow overflow of window (slide all the way to the end)
    sq_signal = [audioData.^2 zeros(1, seglen-1)];
    
    % Peak amplitude in a segment
    seg_peak = zeros(1, N);

    for ix = 1:N
        seg_energy(ix) = sum(sq_signal(ix:ix+seglen-1));
        seg_peak(ix) = max(sq_signal(ix:ix+seglen-1));
    end

    avg_seg_energy = mean(seg_energy);
    normalized_seg_energy =  seg_energy./max(seg_energy);

    figure;
        subplot(3, 1, 1)
            plot(linspace(0, N/fs, N), seg_energy);
        subplot(3, 1, 2)
            plot(linspace(0, N/fs, N), avg_seg_energy);
        subplot(3, 1, 3)
            plot(linspace(0, N/fs, N), seg_peak);
end

