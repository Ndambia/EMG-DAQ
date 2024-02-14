function [J, grad] = costFunction(X, y, theta)
% Compute cost and gradient for logistic regression
m = length(y); % number of training examples
h = sigmoid(X * theta);
J = (1 / m) * sum(-y' * log(h) - (1 - y)' * log(1 - h));
grad = (1 / m) * X' * (h - y);
end
