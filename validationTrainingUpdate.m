#######################################
########## SCALE ALL SAMPLES ##########
#######################################

function [scaledTrainingSet] = validationTrainingUpdate(trainingSet, meanAge, maxFeature)

countRow = numel(trainingSet(:,1));
countColumn = numel(trainingSet(1,:));

# Add mean to missing values in parameter AGE
for i = 1:countRow
  if (trainingSet(i, 3) == 0)
    trainingSet(i, 3) = meanAge;
  endif
endfor

# Scale all values
scaledTrainingSet = scale(trainingSet, countRow, countColumn, maxFeature);

end