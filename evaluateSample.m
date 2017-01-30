########################################
########## SAMPLE EVALUATING ###########
########################################

function exampleSimilarityVector = evaluateSample(example, maxFeature, scaledTrainingSet, sigma)
  
  # Prepare values to data structure
  examplePreprocessing = zeros(1,8);
  examplePreprocessing(1) = example.pclass;
  
  if (strcmpi(example.sex, 'female'))
    examplePreprocessing(2) = 1;
  else
    examplePreprocessing(2) = 0;
  endif
  
  examplePreprocessing(3) = example.age;
  examplePreprocessing(4) = example.sibsp;
  examplePreprocessing(5) = example.parch;
  examplePreprocessing(6) = sum(toascii(example.ticket));
  examplePreprocessing(7) = example.fare;
  examplePreprocessing(8) = sum(toascii(example.embarked));

  # Scale data structure
  for i = 1:numel(maxFeature)
    examplePreprocessing(i) = examplePreprocessing(i) / maxFeature(i);
  end
  
  # Compute similarity vector
  for i = 1:numel(scaledTrainingSet(:,1))
    exampleSimilarityVector(i) = gaussianKernel(examplePreprocessing, scaledTrainingSet(i,:), sigma);
  end
  
end