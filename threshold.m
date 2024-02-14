% Clear the workspace and close any existing figures
clc;
clear all;
11;
% Initialize Arduino connection
comPort = 'COM3'; % Replace 'COMX' with your Arduino's port
arduino = serialport(comPort, 9600);

% Define the Hamming window of 20 samples
window_size = 20;
hamming_window = hamming(window_size);

% Define the number of samples and create an empty array for RMS values
num_samples = 10; % Change this to the number of samples you want to acquire
rms_values = zeros(1, num_samples);
1;
% Define the servo angle range
angle_min = 0;   % Minimum angle (corresponding to minimum RMS value)
angle_max = 180; % Maximum angle (corresponding to threshold RMS value)
2;
% Define the baseline period for threshold calculation
baseline_start = 10;
baseline_end = 90;
3;
% Calculate the threshold RMS value (average RMS during baseline period)
threshold_rms = 0; % Initialize the threshold value

% Sample analog data and process in real-time

for i = 1:num_samples
    % Sample analog data from Arduino's A0 pin
    write(arduino, 'R'); % Send a command to Arduino to request an analog reading
    analog_value = str2double(readline(arduino)); % Read the analog value from Arduino
 5;
    % Store the analog value in a buffer
    buffer = [buffer(2:end), analog_value];

    % Calculate the RMS value for the current window
    if i >= window_size
        % Apply the Hamming window to the buffer
        windowed_data = buffer(end - window_size + 1:end) .* hamming_window;

        % Calculate the RMS value
        rms_values(i) = sqrt(mean(windowed_data.^2));

        % Calculate the threshold RMS value (once)
        if i == baseline_end
            threshold_rms = mean(rms_values(baseline_start:baseline_end)) + 0.002;
        end

        % Map RMS value to servo angle
        servo_angle = angle_min + (rms_values(i) - threshold_rms) * (angle_max - angle_min) / (max(rms_values) - threshold_rms);

        % Constrain servo angle to the desired range (0° to 180°)
        servo_angle = max(angle_min, min(angle_max, servo_angle));

        % Send servo angle value to Arduino (you should implement the code)
        write(arduino, ['A' num2str(servo_angle)]); % Send the servo angle to Arduino

        % Display information
        fprintf('Analog Value: %f, RMS Value: %f, Servo Angle: %f\n', analog_value, rms_values(i), servo_angle);
    end
end

% Close the Arduino connection
clear arduino;

% Plot the RMS values
figure;
plot(rms_values);
xlabel('Sample');
ylabel('RMS Value');
title('RMS of EMG Data');

