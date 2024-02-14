clc;

pkg load signal;
data = csvread('data20.csv'); % Read the data from the file


% Extracting control and EMG data
control = data(:, 1);
emg = data(:, 2);

% Replace missing or invalid values with a placeholder (e.g., -1)
#control(isnan(control)) = -1;

%% Finding consecutive control groups
control_diff = diff([control]);


start_indices = [1;find(control_diff != 0)];

disp("start index");
disp(start_indices);

end_indices = find(control_diff([1:end-1]) == 1); % Adjusted the indices

% Assuming control_diff and control arrays are available



% Print the values of start_indices and end_indices

% Initializing the matrices to store the results
results = zeros(length(start_indices), 6);
labels = control(start_indices);
disp("labells");
disp(labels);
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


    if ~isempty(current_emg)
        results(i, 1) = mean(current_emg);
        results(i, 2) = std(current_emg);
        results(i, 3) = median(current_emg);
        results(i, 4) = sum(diff(current_emg > 0) != 0);
        results(i, 5) = rms(current_emg);
        results(i, 6) = labels(i);
    end
end
% Writing results to CSV
#csvwrite('results.csv', results);

% Writing results to a CSV file
fid = fopen('results2.csv', 'w');
printf(fid, 'Mean,Standard Deviation,Median,Zero Crossings,RMS,Label\n');
for i = 1:length(start_indices)
    fprintf(fid, '%.1f,%.1f,%.1f,%.1f,%.1f, %d\n', results(i, 1), results(i, 2), results(i, 3), results(i, 4), results(i, 5), results(i,6));
end
fclose(fid);



