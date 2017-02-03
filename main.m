#################################
########## MAIN METHOD ##########
#################################

# Reset and data loading
data = settings();
fprintf('### Load data and prepare environment ...\n');
# Input SIGMA
input("Choose SIGMA: ");
sigma = ans;
# Input C
input("Choose C: ");
C = ans; 
# Input size of TRAINING SET
fprintf("Split data to training set and validation set!\n");
input("Choose size of training se in \'%\':");
sizeOfTrainingSet = ans;

########## PREPROCESSING
fprintf('### Preprocessing ...\nPress ENTER to continue ...\n');
#pause();
[fTraining, fValidation, trainingY, validationY] = preprocessing(data, sigma, sizeOfTrainingSet);

########## TRAINING
fprintf('### Train via GAUSS KERNEL ...\nPress ENTER to continue ...\n');
#pause();
model = trainManual(fTraining, trainingY, C, @(x1, x2) gaussianKernel(x1, x2, sigma), 1e-3, 20);

########## PREDICTION
fprintf('### Compute prediction ...\nPress ENTER to continue ...\n');
#pause();
prediction = predictManual(model, fValidation);

########## STATISTICS
fprintf('### Compute statistics for training set ...\nPress ENTER to continue ...\n');
#pause();
stats = statistics(prediction, validationY)