function [ K_xx ] = djStockKernel( X1, X2, varargin )
%djStockKernel Kernel function tailored for the SVM-based Dow Jones stock
% model. Form is best guess, based off inspection of sample data.

% Filler
K_xx = X1*X2';

end

