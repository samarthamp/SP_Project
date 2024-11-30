clearvars; clc; close all;

% List of audio and text file names
audioFiles = {'./audios/8.mp3'};
textFiles = {'./text/8.txt'};

% Initialize results container
allIntervals = [];

for i = 1:length(audioFiles)
    % Read the audio file
    [audioData, fs] = audioread(audioFiles{i});

    % Convert to mono if stereo
    if size(audioData, 2) > 1
        audioData = mean(audioData, 2);
    end

    % Read the corresponding text file
    fileID = fopen(textFiles{i}, 'r');
    textData = textscan(fileID, '%s %f %f'); % Read word, start time, end time
    fclose(fileID);
    
    % Extract text data
    words = textData{1};
    startTimes = textData{2};
    endTimes = textData{3};
    
    % Analyze loudness for each interval
    numIntervals = length(endTimes);
    intervalResults = zeros(numIntervals, 3); % Preallocate storage
    for j = 1:numIntervals
        % Extract segment based on start and end times
        startSample = max(1, floor(startTimes(j) * fs));
        endSample = min(length(audioData), ceil(endTimes(j) * fs));
        segment = audioData(startSample:endSample);
        
        % Calculate loudness
        loudness = integratedLoudness(segment, fs); % Requires Audio Toolbox
        
        % Store results as [start time, end time, loudness]
        intervalResults(j, :) = [startTimes(j), endTimes(j), loudness];
    end

    % Append results for all files
    allIntervals = [allIntervals; intervalResults];
end

% Sort intervals by loudness in descending order
sortedIntervals = sortrows(allIntervals, -3);

% Calculate the average loudness
averageLoudness = mean(sortedIntervals(:, 3)); % Adjust logic if needed

% Add a new column: 1 if loudness > average, else 0
aboveAverage = sortedIntervals(:, 3) > averageLoudness;
sortedIntervals = [sortedIntervals, aboveAverage];

% Display results
disp('Start Time | End Time | Loudness | Is it Loud');
disp(sortedIntervals);

% Save to file
outputFile = 'sorted_intervals.txt';
fileID = fopen(outputFile, 'w');
fprintf(fileID, '%f %f %f %d\n', sortedIntervals');
fclose(fileID);

disp(['Results saved to ', outputFile]);
disp(['Mean = ', num2str(mean(sortedIntervals(:, 3)))]);
disp(['STD = ', num2str(std(sortedIntervals(:, 3)))]);
