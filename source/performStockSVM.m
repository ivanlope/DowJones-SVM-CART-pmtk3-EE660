function [  profit, roi  ] = performStockSVM( x_train, y_train, x_test, y_test, betAmount )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Initiliaze the output
profit = 0;
roi    = 0;

% Start timer
tic;

% Number of test samples
numTestTransactions = size(y_test,1);

% Check is the necessary PMTK modules are installed/in-PATH.
if ~svmInstalled
    fprintf('cannot run %s without svmFit; skipping\n', mfilename());
    return;
end

% Build the SVM model. Use the polynomial kernel of order d = 2.
% Use CV to optimize the model regularizer.
% Use the PMTK Quadraptic Programming solver to minimize the loss function,
% which by default is a mean misclassification measure.
model = svmFit(x_train, y_train, ...
               'kernel', @kernelPoly, ...
               'kernelParam', 2, ...
               'C', logspace(-1,1,10), ...
               'fitFn', @svmQPclassifFit);

% Produce a vector of predictions that correspond to the test samples in x_test
y_hat = svmPredict(model, x_test);
test_error_rate = mean( y_hat ~= (y_test(:,2)+1)/2 );

[accumProfit, missedProfit, wrongLosses, amountInvested] = ...
    modelWagers(y_hat, y_test, betAmount);

profit = accumProfit;
roi    = accumProfit / amountInvested;

% Print summary; where did the model work? where did it lead me astray.
fprintf('    E_test:  %f\n', test_error_rate);
fprintf('    Forest Accum. Profit: $%.2f\n', accumProfit);
fprintf('    Lost Potential: $%.2f, $%.2f\n\n', missedProfit, wrongLosses);

% Report the overall simulation time.
toc;


end    % END of fn: performStockSVM

