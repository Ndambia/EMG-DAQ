clc;
clear;
pkg load arduino;
pkg load instrument-control;

% Parameters
numSamples = 100;
numChannels = 2;
numFeaturesPerChannel = 5;

% Load the trained SVM model
load('modelSvm.mat'); % Assuming you saved your SVM model

% Open serial connection to the second Arduino
s2 = serialport("com13", 9600); % Replace 'COMy' with your second Arduino port

while true
    % Open serial connection to the first Arduino (EMG signal source)
    s = serialport("com6", 9600);  % Replace "/dev/ttyUSB0" with your actual port

    % Initialize matrices to store raw and feature data
    rawData = zeros(numSamples, numChannels);
    featureData = zeros(numSamples, numChannels * numFeaturesPerChannel);

    % Read raw EMG data
    for i = 1:numSamples
        data = str2double(readline(s));
        rawData(i, :) = data;
    end

    % Close serial connection to the first Arduino


    % Calculate features for each channel
    for channel = 1:numChannels
        channelData = rawData(:, channel);

        % Example: Calculate mean, std, min, max, and median
        meanVal = mean(channelData);
        stdVal = std(channelData);
        minVal = min(channelData);
        maxVal = max(channelData);
        medianVal = median(channelData);

        % Store the computed features for the current channel
        featureData(:, (channel - 1) * numFeaturesPerChannel + 1) = meanVal;
        featureData(:, (channel - 1) * numFeaturesPerChannel + 2) = stdVal;
        featureData(:, (channel - 1) * numFeaturesPerChannel + 3) = minVal;
        featureData(:, (channel - 1) * numFeaturesPerChannel + 4) = maxVal;
        featureData(:, (channel - 1) * numFeaturesPerChannel + 5) = medianVal;
        fclose(s);
    end

    % Perform SVM classification
    [predicted_label, ~, ~] = svmpredict(zeros(size(featureData, 1), 1), featureData, model);

    % Send classification result to the second Arduino
    %fprintf(s2, '%d', predicted_label(1)); % Assuming only one prediction for simplicity
    disp(predicted_label(1));

    % Pause for a moment before the next iteration
    pause(5);
    clc;
end

% Close serial connection to the second Arduino


