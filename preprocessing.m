########################################
########## DATA PREPROCESSING ##########
########################################

function [fTraining, fValidation, trainingY, validationY] = preprocessing(data, sigma, sizeOfTrainingSet)

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
      trainingSetAll(j,i) = tmp;
    endif
  endfor
endfor  

# Split data to TRAINING_SET and VALIDATION_SET
countData = numel(trainingSetAll(:,1));
countTrainingSet = int32(countData / 100 * sizeOfTrainingSet);

trainingX = trainingSetAll([1:1:countTrainingSet],:);
validationX = trainingSetAll([countTrainingSet:1:numel(trainingSetAll(:,1))],:);

trainingY = y([1:1:countTrainingSet],:);
validationY = y([countTrainingSet:1:numel(y(:,1))],:);

meanAge = mean(trainingX(:,3));

for i = 1:countColumn
   maxFeature(i) = max(trainingX(:,i));
endfor 

# Scale matrices
scaledTrainingX = validationTrainingUpdate(trainingX, meanAge, maxFeature);
scaledValidationX = validationTrainingUpdate(validationX, meanAge, maxFeature);

# Compute matrices of similarity
fprintf("\nTraining set compute:\n");
fTraining = similarity(scaledTrainingX, scaledTrainingX, sigma);

fprintf("\nValidation set compute:\n");
fValidation = similarity(scaledTrainingX, scaledValidationX, sigma);

# Split teachers answers
trainingY = [ones(1,columns(trainingY));trainingY];
validationY = [ones(1,columns(validationY));validationY];

end