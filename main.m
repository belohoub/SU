#################################
########## MAIN METHOD ##########
#################################

sigma = 1;
C = 1;

data = settings();
fprintf('### Load data and prepare environment ...\n');

fprintf('### Preprocessing ...\n');
[scaledTrainingSet, y, countRow] = preprocessing(data);

#fprintf('### Train via LIBSVM ...\nPress ENTER to continue ...\n');
#pause();
#SVMStruct = trainLibsvm(scaledTrainingSet, y);

fprintf('### Train via MANUAL GAUSS KERNEL ...\nPress ENTER to continue ...\n');
pause();
model = trainManual(scaledTrainingSet, y, C, @(x1, x2) gaussianKernel(x1, x2, sigma), 1e-3, 20);

fprintf('### Compute statistics for training set ...\nPress ENTER to continue ...\n');
pause();
stats = statistics(model, y, scaledTrainingSet)
