clearvars, clc, close all;

% List of audio and text file names
% audioFiles = {'./audios/1.wav', './audios/2.wav', './audios/3.wav', './audios/4.wav',  './audios/5.wav',  './audios/6.wav',  './audios/7.mp3',  './audios/8.mp3', './audios/9.mp3'};
% textFiles = {'./text/1.txt', './text/2.txt', './text/3.txt',  './text/4.txt',  './text/5.txt',  './text/6.txt',  './text/7.txt',  './text/8.txt', './text/9.txt'};
audioFiles = {'./audios/1.wav'};

for i = 1:length(audioFiles)

    [audioData, fs] = audioread(audioFiles{i});

    % Convert to mono if stereo
    if size(audioData, 2) > 1
        audioData = mean(audioData, 2);
    end

    N = length(audioData);
    mag_spectra = fftshift(abs(fft(audioData)));

    pRMS = rms(audioData).^2;
    powbp = bandpower(audioData);
    [wd,lo,hi,power] = obw(audioData,fs);
    powtot = power/0.99;

    [p, f, t] = pspectrum(audioData, fs, 'spectrogram');
    figure
        waterfall(f,t,p');
        xlabel('f');
        xlim([0 0.5*1e4]);
        ylabel('t');
        zlabel('p');

    figure;
        subplot(3, 1, 1)
            plot(linspace(0, N/fs, N), audioData);
        subplot(3, 1, 2)
            % plot(linspace(0, N/fs, N), (audioData));
        subplot(3, 1, 3)
            plot(-(N-1)/2:1:(N-1)/2, mag_spectra);
            
        
    
end
