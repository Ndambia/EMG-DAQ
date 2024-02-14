% Replace 'emg1.csv' with the filename of your CSV file containing the single-channel EMG data
clc; clear all;
data1 = csvread('emg1.csv');
data = zscore(data1);

num_samples = size(data, 1);

% Define the Hamming window of 20 samples
window_size = 20;
hamming_window = hanning(window_size);

% Apply the Hamming window in overlapping windows
num_windows = num_samples - window_size + 1;
windowed_data = zeros(num_windows, window_size);
for i = 1:num_windows
    windowed_data(i, :) = data(i:i+window_size-1) .* hamming(window_size);
end

% Calculate the Root Mean Square (RMS) for each window
rms_values = sqrt(mean(windowed_data.^2, 2));

baseline_start =100 ;  % Replace with the starting index of your baseline period
baseline_end = 900;    % Replace with the ending index of your baseline period

% Calculate the threshold RMS value (average RMS during baseline period)
threshold_rms = mean(rms_values(baseline_start:baseline_end)) +0.002;

fprintf('Threshold RMS value: %f\n', threshold_rms);

% Create a time vector for the RMS values
sampling_rate = 1000; % Replace this with your actual sampling rate
time = (0:num_windows-1) / sampling_rate + (window_size-1) / (2*sampling_rate);

% Find RMS values that are greater than the threshold
above_threshold_rms = rms_values(rms_values > threshold_rms);
above_threshold_time = time(rms_values > threshold_rms);

% Plot the RMS values greater than the threshold
figure;
plot(time, rms_values);
hold on;
plot(above_threshold_time, above_threshold_rms, 'ro');
hold off;

xlabel('Time (s)');
ylabel('RMS');
title('RMS of EMG Data');
legend('RMS', 'RMS Above Threshold');

%

% Convert RMS values to servo angles
% You can map the RMS values to the desired servo angle range (e.g., 0° to 180°)
% For this example, we'll use a simple linear mapping


% Define the servo angle range
angle_min = 0;   % Minimum angle (corresponding to minimum RMS value)
angle_max = 180; % Maximum angle (corresponding to threshold RMS value)

% Map RMS values to servo angles (linear mapping)
servo_angles = angle_min + (rms_values - threshold_rms) * (angle_max - angle_min) / (max(rms_values) - threshold_rms);

% Constrain servo angles to the desired range (0° to 180°)
servo_angles = max(angle_min, min(angle_max, servo_angles));

% Simulate communication with the Arduino (sending servo angle values to Arduino)
% This is just a demonstration of how data might be sent to Arduino
% Replace this with actual communication code for your setup

% Simulate sending servo angle values to Arduino
for i = 1:num_windows
    % Check if the RMS value is above the threshold before sending the servo angle
    if rms_values(i) > threshold_rms
        % Send the servo angle value to Arduino (not shown here, you should implement the communication code)
        fprintf('Sending Servo Angle to Arduino: %f\n', servo_angles(i));
          angle_scaled1 = servo_angles(i)/180;
          %writePosition(myServo1, angle_scaled1)
         % writePosition(myServo2, angle_scaled1)
          %writePosition(myServo3, angle_scaled1)
            %pause(0.1);
            %figure(3)


            hold on;

    else
        % If the RMS value is below the threshold, do not send any angle command to the servo
        fprintf('RMS value is below threshold. Servo will not move.\n');
        pause(0);
    end

    % Simulate a delay (similar to serial communication time delay)
   % Adjust the pause duration based on your communication speed
end
figure;
plot(servo_angles)
