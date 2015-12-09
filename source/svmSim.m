% Use an SVM to model the stock data

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Global set-up: load data, set training parameters
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% Load the sample data by quarter
load('dowjones3wkqt1.mat');
load('dowjones3wkqt2.mat');

% Convert Cell Arrays to matrices
% Ignore columns 1 and 2 (i.e. quarter number and stock ticker symbol)
qt1data = cell2mat(dowjones3wkqt1(:,3:end));
qt2data = cell2mat(dowjones3wkqt2(:,3:end));

% Ignore the auxiliary features in the data. Focus only on the meaningful ones.
data_cols  = [1 2 3 4 5 6 7 8 12];
multi_col  = 14;  % Use for multi-class classification
binary_col = 15;  % Use for binary classification
regr_col   = 13;
test_cols  = [regr_col binary_col];

% Data set parameters
frac_train  = 3/4;
frac_test   = 1/4;

% Money parameters
amountPerWager = 100.0; % $100.00 per wager

% Seed random number generator
seed = RandStream('mt19937ar','Seed',0);

% On average, how much could I expect to make on a single transaction in
% quarters 1 and 2 if I had a perfect predictor for each data sample.
meanSingleTransRoiQt1 = mean( abs(qt1data(:,regr_col) ) );
meanSingleTransRoiQt2 = mean( abs(qt2data(:,regr_col) ) );

fprintf('Perfect Predictor, Qt. 1, Mean ROI:   %.3f%%\n',   meanSingleTransRoiQt1);
fprintf('Perfect Predictor, Qt. 2, Mean ROI:   %.3f%%\n\n', meanSingleTransRoiQt2);




% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Use quarter 1 data to predict other quarter 1 actions
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% Randomly divide the quarter 1 data into training and testing data

% Determine the sizes of each data set (i.e. training and testing) given
% the amount of available quarter 1 data
qt1sample_size = size( qt1data, 1 );
qt1train_size  = floor( qt1sample_size * frac_train );
qt1test_size   = floor( qt1sample_size * frac_test  );

% Random arrangement of indices that correspond to rows in qt1data
perm = randperm(seed, qt1sample_size);
train_idxs = perm(1:qt1train_size);     % Use the first qt1train_size samples as training data
test_idxs  = perm(qt1train_size+1:end); % Use the rest for testing

% Partition training and testing data
qt1train_x = qt1data(train_idxs, data_cols);
qt1train_y = qt1data(train_idxs, binary_col);
qt1test_x  = qt1data(test_idxs, data_cols);
qt1test_y  = qt1data(test_idxs, test_cols);

% How well would I do using quarter 1 model?
[qt1profit, qt1roi] = performStockSVM(qt1train_x, qt1train_y, qt1test_x, qt1test_y, amountPerWager);

fprintf(' Mean profit (ROI) from quarter 1 model: $%.2f (%.3f%%)\n\n', qt1profit, qt1roi*100);






