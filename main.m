#################################
########## MAIN METHOD ##########
#################################

sigma = 2;
C = 5;

data = settings();
fprintf('### Load data and prepare environment ...\n');

fprintf('### Preprocessing ...\nPress ENTER to continue ...\n');
pause();
[f_matrix, scaledTrainingSet, y, countRow, maxFeature] = preprocessing(data, sigma);

fprintf('### Train via MANUAL GAUSS KERNEL ...\nPress ENTER to continue ...\n');
pause();
model = trainManual(f_matrix, y, C, @(x1, x2) gaussianKernel(x1, x2, sigma), 1e-3, 20);

fprintf('### Compute statistics for training set ...\nPress ENTER to continue ...\n');
pause();
stats = statistics(model, y, f_matrix)

fprintf('### Predict new value ...\nPress ENTER to continue ...\n');
pause();

# survived,pclass,name,sex,age,sibsp,parch,ticket,fare,cabin,embarked
example.survived = 1;
example.pclass = 1;
example.name = 'Cumings, Mrs. John Bradley (Florence Briggs Thayer)';
example.sex = 'female';
example.age = 38;
example.sibsp = 1;
example.parch = 0;
example.ticket = 'PC 17599';
example.fare = 71.2833;
example.cabin = 'C85';
example.embarked = 'C';

# Sample
exampleSimilarityVector = evaluateSample(example, maxFeature, scaledTrainingSet, sigma);

# Prediction
prediction = predictManual(model, exampleSimilarityVector)




