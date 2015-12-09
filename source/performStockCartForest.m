function [ mean_profit, mean_roi ] = performStockCartForest( x_train, y_train, x_test, y_test, forestSizes, iterations, bagSize, betAmount )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Initialize output
mean_profit = 0;

% Start timer one.
tic;

% Characterize the CART forests and training process
maxForestSize = forestSizes(end);

errors_test  = zeros(iterations, maxForestSize);
errors_train = zeros(iterations, maxForestSize);
profits      = zeros(iterations, maxForestSize);
rois         = zeros(iterations, maxForestSize);

for forestSize = forestSizes
    fprintf('Forest Size: %d\n', forestSize); %%% DEBUG
   
    for i = 1:iterations
        fprintf('  Iteration: %d\n', i);  %%% DEBUG
        iterStart = tic;
        % Generate a tree for each training iteration
        model = fitForest(x_train, y_train, 'randomFeatures', 8, 'bagSize', bagSize, 'ntrees', forestSize);
   
        % Calculate testing and training error
        y_hat_test  = predictForest(model, x_test);
        errors_test(i, forestSize)  = mean(y_test(:,2) ~= y_hat_test);
        
        % Determine how much would be made/lost using the current forest model
        [accumProfit, missedProfit, wrongLosses, amountInvested] = modelWagers(y_hat_test, y_test, betAmount);
        profits(i, forestSize) = accumProfit;
        rois(i, forestSize)    = accumProfit / amountInvested; 
        
        y_hat_train = predictForest(model, x_train);
        errors_train(i, forestSize) = mean(y_train ~= y_hat_train);
                
        % Print summary        
        iterElapsed = toc(iterStart);
        fprintf('    E_train: %f\n',   errors_train(i, forestSize));
        fprintf('    E_test:  %f\n', errors_test (i, forestSize));
        fprintf('    Iteration time: %f\n', iterElapsed);
        fprintf('    Forest Accum. Profit: $%.2f\n', accumProfit);
        fprintf('    Lost Potential: $%.2f, $%.2f\n\n', missedProfit, wrongLosses);
   end
   
end


% Plot the model performance
std_vs_ntree         = std(errors_test,1);
mean_vs_ntree_test   = mean(errors_test,1);
mean_vs_ntree_train  = mean(errors_train,1);

mean_profit_vs_ntree = mean(profits(:,forestSizes),1);
mean_rois_vs_ntree   = mean(rois(:,forestSizes), 1);

mean_profit = mean(mean_profit_vs_ntree);
mean_roi    = mean(mean_rois_vs_ntree);

figure;
plot(std_vs_ntree,'g*');
hold on;
plot(mean_vs_ntree_test,'r*');
hold on;
plot(mean_vs_ntree_train,'*');
hold off;

title('Mean and Variance of Error Rates for Random Forest');
legend('std of test error','mean test error', 'mean train error');
xlabel('Number of Trees in Forest');

figure;
hold on;
plot(mean_profit_vs_ntree,'*');
title('Mean Profits from Random Forest Model');
xlabel('Number of Trees in Forest');
hold off;

% Report the overall simulation time.
toc;


end

