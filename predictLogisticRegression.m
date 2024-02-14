function p = predictLogisticRegression(model, X)
% Predict whether the label is 0 or 1 using learned logistic regression parameters
p = sigmoid(X * model) >= 0.5;
end
