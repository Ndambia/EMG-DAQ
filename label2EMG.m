clc;

pkg load signal;
data = dlmread('dualComb.csv'); % Read the data from the file

% Extracting control and EMG data
control = data(:, 1);
emg1 = normalize(data(:, 2));
emg2 = normalize(data(:, 3));

% Replace missing or invalid values with a placeholder (e.g., -1)
% control(isnan(control)) = -1;

%% Finding consecutive control groups
control_diff = diff([control]);

start_indices = find(control_diff != 0);
disp(start_indices);

end_indices = find(control_diff([1:end-1]) == 1); % Adjusted the indices

% Assuming control_diff and control arrays are available

disp("Control values and their differences:");

% Initializing the matrices to store the results
results = zeros(length(start_indices), 13);
labels = control(start_indices);
disp("Length of start");
disp(length(start_indices));

% Calculating features for each group
for i = 1:length(start_indices)
    % Extracting the current window of data for emg1
    current_emg1 = emg1(start_indices(i):min(start_indices(i + 1), length(emg1)));
    % Extracting the current window of data for emg2
    current_emg2 = emg2(start_indices(i):min(start_indices(i + 1), length(emg2)));

    % Calculating features for emg1
    results(i, 1) = mean(current_emg1);
    results(i, 2) = std(current_emg1);
    results(i, 3) = median(current_emg1);
    results(i, 4) = iqr(current_emg1);
    results(i, 5) = rms(current_emg1);
    % Add more features for emg1 if needed

    % Calculating features for emg2
    results(i, 6) = mean(current_emg2);
    results(i, 7) = std(current_emg2);
    results(i, 8) = median(current_emg2);
    results(i, 9) = iqr(current_emg2);
    results(i, 10) = rms(current_emg2);
    % Add more features for emg2 if needed

    results(i, 11) = labels(i);
end

% Writing results to a CSV file
fid = fopen('result3EMG.csv', 'w');
fprintf(fid, 'Mean1,Std1,Median1,IQR1,RMS1,Mean2,Std2,Median2,IQR2,RMS2,Label\n');
for i = 1:length(start_indices)
    fprintf(fid, '%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,%d\n', results(i, :));
end
fclose(fid);

