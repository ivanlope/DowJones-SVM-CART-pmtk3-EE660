function [ K_xx ] = polynomialKernel( X1, X2, varargin )
%djStockKernel Kernel function tailored for the SVM-based Dow Jones stock
% model. Form is best guess, based off inspection of sample data.

% Defaults:
%  c = 1; bias
%  d = 2; quadratic polynomial in X1*X2'
[ c, d ] = process_options(varargin, 'c', 1, 'd', 2, {});

% Polynonmial kernel
K_xx = (X1*X2' +  c) ^ d;

end

