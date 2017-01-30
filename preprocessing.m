########################################
########## DATA PREPROCESSING ##########
########################################

function [f_matrix, scaledTrainingSet, y, countRow, maxFeature] = preprocessing(data, sigma)

# Alone features and drop it from data-set
featuresOriginal = data(1,:);
data(1,:) = [];

# Do teachers answers alone
y = data(:,1);
y = cell2mat(y);
data(:,1) = [];

# Drop parameter NAME - It's like ID's
data(:,2) = [];

# Drop parameter CABIN - missing 77% values
data(:,8) = [];

featuresMeasured = data(1,:);
countRow = numel(y(:,1));
countColumn = numel(featuresMeasured(1,:));

# Convert MALE/FEMALE to BINARY
for i = 1:countRow
  if (strcmpi(data(i, 2), 'female'))
    data(i, 2) = 1;
  else
    data(i, 2) = 0;
  endif
endfor

# TICKET to NUMBER
for i = 1:countRow
  tmp = cell2mat(data(i, 6));
  if (!isnumeric(tmp))
    data(i, 6) = sum(toascii(tmp));
  endif
endfor

# EMBARKED to NUMBER
for i = 1:countRow
  data(i, 8) = sum(cell2mat (toascii(data(i, 8))));
endfor

# Convert to NUMERIC MATRIX
for i = 1:countColumn
  for j = 1:countRow
    tmp = cell2mat(data(j, i));
    if (isnumeric(tmp))
      trainingSet(j,i) = tmp;
    endif
  endfor
endfor  

# Add mean to missing values in parameter AGE
meanAge = mean(trainingSet(:,3));

for i = 1:countRow
  if (trainingSet(i, 3) == 0)
    trainingSet(i, 3) = meanAge;
  endif
endfor

# Scale all values
for i = 1:countColumn
   maxFeature(i) = max(trainingSet(:,i));
endfor  

scaledTrainingSet = scale(trainingSet, countRow, countColumn, maxFeature);

# Compute similarity
fprintf('\nSimilarity ...');
dots = 12;

for i = 1:countRow
  for j = 1:countRow
    # sample X
    x1 = scaledTrainingSet(i,:);
    # landmark
    x2 = scaledTrainingSet(j,:);
    
    # similarity matrix
    f_matrix(i,j) = gaussianKernel(x1, x2, sigma);
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

end