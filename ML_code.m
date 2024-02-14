clc;

% Load the split data from the CSV files
training_data = dlmread('testing2emg.csv', '\t');
validation_data = dlmread('testing2emg.csv', '\t');

X_train = training_data(:, 1:10); % Features for training
y_train = training_data(:, 11); % Labels for training

X_val = validation_data(:, 1:10); % Features for validation
y_val = validation_data(:, 11); % Labels for validation


% Train a logistic regression model
alpha = 0.7;  % Set your learning rate
num_iters = 1000;  % Define the number of iterations

model = trainLogisticRegression(X_train, y_train, alpha, num_iters);

% Make predictions on the validation set
y_pred = predictLogisticRegression(model, X_val);

% Calculate accuracy
accuracy = mean(double(y_pred == y_val)) * 100;
fprintf('Validation Accuracy: %f%%\n', accuracy);

% Plot results
figure;
scatter(1:length(y_val), y_val, 'filled', 'DisplayName', 'Actual');
hold on;
scatter(1:length(y_pred), y_pred, 'DisplayName', 'Predicted');
xlabel('Data Points');
ylabel('Labels');
ylim([-3,3]);
title('Actual vs. Predicted Labels');
legend;

% Plot epochs vs. accuracy
figure;
epochs = 1:num_iters;
plot(epochs, accuracy * ones(size(epochs)));
xlabel('Epochs');
ylabel('Accuracy');
title('Epochs vs. Accuracy');
