########################################
########## COMPUTE STATISTICS ##########
########################################

function [stats] = statistics(prediction, y)
  
  # Who survived in training set
  stats.sumY1 = sum(y(:));
  # Who survived in prediction set
  stats.sumPredict1 = sum(prediction(:));
  
  # Where row of training set equal to row of prediction set 
  prediction(y(:)==prediction(:)) = 1;
  
  # Count of equal rows
  stats.similarRowsPredictAndY = sum(prediction);
  # How much percents were predicted right
  stats.similarPercent = 100 / (y) * stats.similarRowsPredictAndY;
  
end