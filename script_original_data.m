############################################
########## LOAD DATA AND PACKAGES ##########
############################################
# apt-get install liboctave-dev
# pkg install -forge io
pkg load io

# LOAD PREPROCESSED DATA titanic_preprocessing_2.csv FROM titanic.csv
# !!!CHECK CORECT PATH!!!
data = csv2cell('/home/dzejkob23/Documents/Git/SU/titanic.csv');

#####################################
########## ADD SVM LIBRARY ##########
#####################################

# type "make" in ./libsvm-3.22/matlab
# type => "addpath './libsvm-3.22/matlab'";

########################################
########## DATA PREPROCESSING ##########
########################################

# DROP NAMES - It's like ID's
data(:,3) = [];

# DROP CABIN (missing 77% values)
data(:,9) = [];

# TMP COUNT CELLS IN ONE COLUMN
count = numel(data(:, 1));

# CONVERT MALE/FEMALE TO BINARY
for i = 2:count
  if (strcmpi(data(i, 3), 'female'))
    data(i, 3) = 1;
  else
    data(i, 3) = 0;
  endif
endfor

# EMBARKED TO NUMBER
for i = 2:count
  data(i, 9) = sum(cell2mat (toascii(data(i, 9))));
endfor

# TICKET TO NUMBER
for i = 2:count
  tmp = cell2mat(data(i, 7));
  if (!isnumeric(tmp))
    data(i, 7) = sum(toascii(tmp));
  endif
endfor

# CONVERT TO NUMERIC MATRIX
for i = 1:9
  for j = 2:count
    tmp = cell2mat(data(j, i));
    if (isnumeric(tmp))
      training_set(j,i) = tmp;
    endif
  endfor
endfor  

# ADD MEAN TO MISSING VALUES IN AGE
mean_age = mean(training_set(:,4));

for i = 1:count
  if (training_set(i, 4) == 0)
    training_set(i, 4) = mean_age;
  endif
endfor
    
#########################################
########## SCALE ALL SYMPTOMS ###########
#########################################     
    
for i = 2:9
  for j = 1:count
    scaled_training_set(j,i) = training_set(j,i) / max(training_set(:,i));
  endfor
endfor    
    
########################################
########## COMPUTE SIMILARITY ##########
########################################    

# INITIALIZE THETA AND MATRIX OF SIMILARITY
f_int = zeros (count, count, "uint8");

# SIGMA
sigma = 1;

for i = 1:count
  for j = 1:count
    # sample X
    x_1 = scaled_training_set(i,:);
    # landmark
    x_2 = scaled_training_set(j,:);
    
    # similarity of sample X is in ROW
    # rounding to DOUBLE
    f_double(i,j) = exp(-norm(x_1 - x_2)^2 / 2 * sigma^2);
    # rounding to INTEGER
    f_int(i,j) = f_double(i,j);
  endfor
endfor

##########################################
########## TRAINING WITH LIBSVM ##########
##########################################

# get answares from teacher
answers_y = scaled_training_set(:,1);
# drop answers from training set
scaled_training_set (:,1) = [];

# Usage: model = svmtrain(training_label_vector, training_instance_matrix, 'libsvm_options');
# libsvm_options:
# -s svm_type : set type of SVM (default 0)
#         0 -- C-SVC              (multi-class classification)
#         1 -- nu-SVC             (multi-class classification)
#         2 -- one-class SVM
#         3 -- epsilon-SVR        (regression)
#         4 -- nu-SVR             (regression)
# -t kernel_type : set type of kernel function (default 2)
#         0 -- linear: u'*v
#         1 -- polynomial: (gamma*u'*v + coef0)^degree
#         2 -- radial basis function: exp(-gamma*|u-v|^2)
#         3 -- sigmoid: tanh(gamma*u'*v + coef0)
#         4 -- precomputed kernel (kernel values in training_instance_matrix)
# -d degree : set degree in kernel function (default 3)
# -g gamma : set gamma in kernel function (default 1/num_features)
# -r coef0 : set coef0 in kernel function (default 0)
# -c cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR (default 1)
# -n nu : set the parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)
# -p epsilon : set the epsilon in loss function of epsilon-SVR (default 0.1)
# -m cachesize : set cache memory size in MB (default 100)
# -e epsilon : set tolerance of termination criterion (default 0.001)
# -h shrinking : whether to use the shrinking heuristics, 0 or 1 (default 1)
# -b probability_estimates : whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)
# -wi weight : set the parameter C of class i to weight*C, for C-SVC (default 1)
# -v n : n-fold cross validation mode
# -q : quiet mode (no outputs)

# EXAMPLES:
# SVMStruct = svmtrain(answers_y,scaled_training_set);
# SVMStruct = svmtrain(answers_y,scaled_training_set,'['-s 3 -t 2 -c 1 -p 0.001 -g 1 -v 5']');

