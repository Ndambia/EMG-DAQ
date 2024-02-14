% Specify the correct path to the libsvm MATLAB directory
clc;clear;
addpath("E:/Ai/libsvm/libsvm-3.32/matlab");

% Load the statistics package
pkg load statistics;

% Generate random data for training and testing
rng(42);
data = randn(10000, 2); % 200 samples, 2 features
labels = ones(10000, 1);
labels(data(:, 1) < 0 & data(:, 2) < 0) = -1; % Assigning labels based on quadrant

% Split the data into training and testing sets
trainRatio = 0.8;
idx = randperm(size(data, 1));
trainData = data(idx(1:round(trainRatio * end)), :);
trainLabels = labels(idx(1:round(trainRatio * end)));

testData = data(idx(round(trainRatio * end) + 1:end), :);
testLabels = labels(idx(round(trainRatio * end) + 1:end));

% Train the SVM model using libsvm
model = svmtrain(trainLabels, trainData, '-t 2'); % '-t 0' specifies a linear kernel

% Make predictions on the test set
[predictions, accuracy, decision_values] = svmpredict(testLabels, testData, model);

% Display accuracy
fprintf('Accuracy: %.2f%%\n', accuracy(1));

% Visualize the data and decision boundary
% Create a meshgrid for visualization
[X, Y] = meshgrid(linspace(min(data(:, 1)), max(data(:, 1)), 100), ...
                   linspace(min(data(:, 2)), max(data(:, 2)), 100));
gridPoints = [X(:), Y(:)];

% Use the SVM decision function to get decision values
[~, ~, decisionValues] = svmpredict(zeros(size(gridPoints, 1), 1), gridPoints, model, '-q');

% Plot the data points
figure;
scatter(data(:, 1), data(:, 2), 20, labels, 'filled');
colormap([0 0 0.8; 0.8 0 0]); % Blue for label 1, Red for label -1
hold on;

% Plot the decision boundary
contour(X, Y, reshape(decisionValues, size(X)), [0 0], 'LineWidth', 2, 'LineColor', 'k');

title('SVM Decision Boundary');
xlabel('Feature 1');
ylabel('Feature 2');
legend('Label 1', 'Label -1', 'Decision Boundary');
hold off;

% Remove libsvm from the path to avoid conflicts with other functions
rmpath("E:/Ai/libsvm/libsvm-3.32/matlab");

