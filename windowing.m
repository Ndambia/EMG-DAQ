% Replace 'emg1.csv' with the filename of your CSV file containing the single-channel EMG data
data1 = csvread('emg1.csv');

% If your data contains a header row, you can use the following line instead:
% data = csvread('emg1.csv', 1);
data = zscore(data1);
% Extract the number of samples
num_samples = size(data, 1);

% Create a time vector assuming the sampling rate is 1000 Hz (modify accordingly)
sampling_rate = 900;  % Replace this with your actual sampling rate
time = (0:num_samples-1) / sampling_rate;

% Define the Hamming window of 20 samples
window_size = 55;
hamming_window = hamming(window_size);

% Apply the Hamming window in overlapping windows
num_windows = num_samples - window_size + 1;
windowed_data = zeros(num_windows, window_size);
for i = 1:num_windows
    windowed_data(i, :) = data(i:i+window_size-1) .* hamming(window_size);
end

% Calculate the Root Mean Square (RMS) for each window
rms_values = sqrt(mean(windowed_data.^2, 2));

% Create a time vector for the windowed RMS values
rms_time = (0:num_windows-1) / sampling_rate + (window_size-1) / (2*sampling_rate);

% Plot the windowed RMS values
figure(1);
%subplot(2,1,1),
plot(time,data);
hold on;
xlabel('Time (s)');
ylabel('Amplitude');
title('Raw Signal Analysis');

% Plot the windowed RMS values

%subplot(2,1,1),
plot(rms_time, rms_values);
xlabel('Time (s)');
ylabel('RMS');
title('Windowed RMS of EMG Data vs Raw Signal Analysis');
legend('Raw EMG','Windowed RMS EMG ');


