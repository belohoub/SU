#########################################
########## SCALE ALL SYMPTOMS ###########
#########################################

function scaledTrainingSet = scale(trainingSet, countRow, countColumn, maxFeature)
  
for i = 1:countColumn
  for j = 1:countRow
    scaledTrainingSet(j,i) = trainingSet(j,i) / maxFeature(i);
  endfor
endfor     

end