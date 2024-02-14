%data = csvread('dual7.csv'); % Read the data from the file
data = csvread('bie3.csv'); % Read the data from the file

#controlData = data(:, 1); % Extract the control data from the first row
emgData = data(:, 2); % Extract the EMG data from the second row
#emgData2 = data(:, 3);
#emgData1 = emgData -500;
emgData1 = zscore(emgData);


% Plotting the data

figure;
#subplot(2, 1, 1);
hold on
#plot((controlData*100)+400);
xlabel('Time');
%ylabel('Control Data');
title('Control Signal vs EMG');

#subplot(2, 1, 2);
plot(emgData1 );

xlabel('Samples');
xlim([0,1000]);
ylabel('EMG Amplitude');
#title('EMG Signal Variation');
#ylim([0, 1000]);


