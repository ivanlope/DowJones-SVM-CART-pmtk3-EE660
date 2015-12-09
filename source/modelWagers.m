function [accumProfit, missedProfit, wrongLosses, totalInvestment] = modelWagers( predictions, truth, amountPerWager )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
% Initialize outputs
accumProfit     = 0; 
missedProfit    = 0;
wrongLosses     = 0;

% Determine how many wagers there are
numOfWagers = size(predictions,1);
totalInvestment = numOfWagers * amountPerWager;

% % % fprintf('Number of wagers: %d\n\n', numOfWagers);

% Iterate over all predictions and determine how much money would be
% gained/lossed as a result of the predictions.
for w = 1:numOfWagers
% % %    fprintf('  Wager no: %d\n', w);
   
    if( predictions(w) )
       % Model says to buy
% % %        disp('    BUY');
% % %        fprintf('      percent: %f, profit: %f\n', truth(w,1)/100, amountPerWager * (truth(w,1)/100));
       accumProfit = accumProfit + amountPerWager * (truth(w,1)/100);
    else
       %Model says to sell
% % %        disp('    SELL');
% % %        fprintf('      percent: %f, profit: %f\n', truth(w,1)/100, amountPerWager * (truth(w,1)/100));
       accumProfit = accumProfit - amountPerWager * (truth(w,1)/100);
    end
    
% % %     if( truth(w,2) )
% % %         disp('      Should BUY');
% % %     else
% % %         disp('      Should SELL');
% % %     end
    
    % When the prediction model says no, but in reality the answer
    if( truth(w,2) && ~predictions(w) )
       missedProfit = missedProfit + amountPerWager * truth(w,1)/100;
    elseif ( ~truth(w,2) && predictions(w) )
       wrongLosses  = wrongLosses  - amountPerWager * truth(w,1)/100;
    end
end

end

