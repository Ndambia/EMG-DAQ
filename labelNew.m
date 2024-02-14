clc;

pkg load signal;
data = csvread('biE.csv'); % Read the data from the fil
%data =normalize(data1);

% Extracting control and EMG data
control = data(:, 1);
emg1 = data(:, 2);
emg =normalize(emg);

% Replace missing or invalid values with a placeholder (e.g., -1)
#control(isnan(control)) = -1;

%% Finding consecutive control groups
control_diff = diff([control]);

start_indices = find(control_diff != 0);
disp(start_indices);

end_indices = find(control_diff([1:end-1]) == 1); % Adjusted the indices

% Assuming control_diff and control arrays are available

disp("Control values and their differences:");
%disp([control, control_diff]);

% Print the values of start_indices and end_indices

% Initializing the matrices to store the results
results = zeros(length(start_indices), 6);
labels = control(start_indices);
disp("Length os start");
disp(length(start_indices));
% Calculating features for each group
for i = 1:length(start_indices)
    %current_emg = emg(start_indices(i):end_indices(i));
    if i < length(start_indices)
    current_emg = emg(start_indices(i):min(start_indices(i + 1), length(emg)));
else
    current_emg = emg(start_indices(i):end);
end

    results(i, 1) = mean(current_emg);
    results(i, 2) = std(current_emg);
    results(i, 3) = median(current_emg);
    results(i, 4) = iqr(current_emg);
    results(i, 5) = rms(current_emg);
    %results(i, 6) =median_frequency(current_emg, 30);
    results(i, 6) = labels(i);

end
% Writing results to CSV
#csvwrite('results.csv', results);
% Writing results to a CSV file
fid = fopen('resultBie.csv', 'w');
fprintf(fid, 'Mean,Standard Deviation,Median,IQR,RMS,Label\n');
for i = 1:length(start_indices)
    fprintf(fid, '%.1f,%.1f,%.1f,%.1f,%.1f,%d\n', results(i, 1), results(i, 2), results(i, 3), results(i, 4), results(i, 5), results(i, 6));
end
fclose(fid);



