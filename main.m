#################################
########## MAIN METHOD ##########
#################################

#sigma = 1;

#fprintf('### Load data and prepare environment ...\n')
#data = settings();

#fprintf('### Preprocessing ...\n')
#[training_set, y, features, count] = preprocessing(data);

#fprintf('### Scaling data and create similarity matrix ...\n')
#f_double = similarityMatrix(training_set,count, sigma);

fprintf('### Train ...\n')
#SVMStruct = train_libsvm(f_double, y);