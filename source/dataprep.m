% load the swing data
load( 'swing.mat' );

% Create x vector, that correpsonds to time
x = [0 1 2 3];
x_c = linspace(0,3);

% Initialize matrix that will hold the polynomial-fit params for each
% samples, as well as the column vector for the polynomial derivatives.
dim_swing = size(swing);
P = zeros(dim_swing);
d = zeros(dim_swing(1), 1);

% For each data sample in swing, create a corresponding set of
% polynomial-fit parameters, and store them in P
for row = 1:dim_swing(1)
    high = max( swing(row,:) );
    P(row,:) = polyfit(x, swing(row,:)/high, 3);
end

% Find the derivative of the calculate polynomial fit at the time of
% interest, i.e. x(3), the latest date.
for i = 1:dim_swing(1)
    f1 = polyval(P(i,:), x_c);
    d(i) = 3*P(i,1)*x(3)^2 + 2*P(i,2)*x(3) + P(i,3);
end

% Augment the input data with the additional derivative feature. 
data = [swing d];
csvwrite('MarCapMomentum.csv', data);
