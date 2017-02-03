########################################
########## COMPUTE SIMILARITY ##########
########################################

function [f] = similarity(trainingSet, validationSet, sigma)
  
 # Compute similarity
fprintf('Similarity ...');
dots = 14;

countRow = numel(validationSet(:,1));
countColumn = numel(trainingSet(:,1));

for i = 1:countRow
  for j = 1:countColumn
    # sample X
    x1 = validationSet(i,:);
    # landmark
    x2 = trainingSet(j,:);
    
    # similarity matrix
    f(i,j) = gaussianKernel(x1, x2, sigma);
  end
  
  fprintf('.');
  dots = dots + 1;
  if dots > 78
      dots = 0;
      fprintf('\n');
  end
  if exist('OCTAVE_VERSION')
      fflush(stdout);
  end
end

fprintf(' Done! \n\n');

# Added f_0 feature
f = [ones(rows(f),1),f];
f = [ones(1,columns(f));f];

end