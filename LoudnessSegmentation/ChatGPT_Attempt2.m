clearvars, clc, close all;

% List of audio and text file names
audioFiles = {'./audios/7.mp3', './audios/8.mp3', './audios/9.mp3'};
textFiles = {'./text/7.txt', './text/8.txt', './text/9.txt'};

for i = 1:length(audioFiles)

% Initialize results container
allIntervals = [];

    % Read the audio file
    [audioData, fs] = audioread(audioFiles{i});
    N = length(audioData);
    mag_spectra = fftshift(abs(fft(audioData)));
    figure
        subplot(2, 1, 1)
            plot(linspace(0, N/fs, N), audioData);
            title("Signal " + num2str(i) + " in time")
        subplot(2, 1, 2)
            plot((-N/2:N/2-1) * (fs / N), mag_spectra);
            xlim([-1e4 1e4]);
            title("Magnitude Spectrum of signal "+ num2str(i))

    % Convert to mono if stereo
    if size(audioData, 2) > 1
        audioData = mean(audioData, 2);
    end

    % Read the corresponding text file
    fileID = fopen(textFiles{i}, 'r');
    textData = textscan(fileID, '%s %f %f'); % Read word, start time, end time
    fclose(fileID);
    
    words = textData{1}(1:2:length(textData{1}));
    startTimes = textData{2}(1:2:length(textData{2}));
    endTimes = textData{3}(1:2:length(textData{3}));
    % Analyze loudness for each interval
    arr = [];
    for j = 1:length(endTimes)
        % Extract segment based on start and end times
        startSample = max(1, floor(startTimes(j) * fs));
        endSample = min(length(audioData), ceil(endTimes(j) * fs));
        segment = audioData(startSample:endSample);
        
        % Calculate loudness
            % RMS
               % loudness = sqrt(mean(abs(segment)));

            % Frequency Weighting
                aWeighting = weightingFilter('A-weighting', fs);
                
            % Filter the signal
                weighted_signal = aWeighting(segment);
                loudness = rms(weighted_signal);

            % acousticLoudness
                % loudness = acousticLoudness(segment, fs);

            % integratedloudness
                % loudness = integratedLoudness(segment, fs);
        
        % Store results as [start time, end time, loudness]
        allIntervals = [allIntervals; [startTimes(j), endTimes(j), loudness]];
    end

    % Sort intervals by loudness in descending order
    sortedIntervals = sortrows(allIntervals, -3);
    
    % Calculate the average loudness
    averageLoudness = mean(sortedIntervals(:, 3));
    
    % Add a new column: 1 if loudness > average, else 0
    aboveAverage = sortedIntervals(:, 3) > averageLoudness;
    sortedIntervals = [sortedIntervals, aboveAverage];
    
    % Display or save results
    disp('Start Time | End Time | Loudness | Is it Loud');
    disp(sortedIntervals);

    % % Optionally, save to a file
    % outputFile = ['Audiofile_' num2str(i) '.txt'];
    % fileID = fopen(outputFile, 'w');
    % fprintf(fileID, 'Start Time  |    End Time   |    Loudness |  Is it Loud\n');
    % fprintf(fileID, '_______________________________________________________\n');
    % fprintf(fileID, '%f \t %f \t %f \t %d\n', sortedIntervals');
    % fprintf(fileID, '\n\n\n');
    % fclose(fileID);
    % disp(['Results saved to ', outputFile]);
end

disp(['Mean = ', num2str(mean(sortedIntervals(:, 3)))]);
disp(['Standard Deviation = ', num2str(std(sortedIntervals(:, 3)))]);