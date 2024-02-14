## Copyright (C) 2023 BRAYO
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} trainLogicRegression (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: BRAYO <BRAYO@STUXSNET>
## Created: 2023-10-28

function retval = trainLogicRegression (X, y, alpha, num_iters)

% Initialize fitting parameters
theta = zeros(size(X, 2), 1);

% Gradient descent
for i = 1:num_iters
    % Cost and gradient calculation
    [cost, grad] = costFunction(X, y, theta);

    % Update parameters
    theta = theta - alpha * grad;
end

model = theta;
end

function p = predictLogisticRegression(model, X)
% Predict whether the label is 0 or 1 using learned logistic regression parameters
p = sigmoid(X * model) >= 0.5;
end

function [J, grad] = costFunction(X, y, theta)
% Compute cost and gradient for logistic regression
m = length(y); % number of training examples
h = sigmoid(X * theta);
J = (1 / m) * sum(-y' * log(h) - (1 - y)' * log(1 - h));
grad = (1 / m) * X' * (h - y);
end

function g = sigmoid(z)
% Compute sigmoid function
g = 1.0 ./ (1.0 + exp(-z));


endfunction
