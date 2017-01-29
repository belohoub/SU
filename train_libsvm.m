##########################################
########## TRAINING WITH LIBSVM ##########
##########################################
#
# when we use SVM with kernels, we have to
# use vector of similarity f^(i) instead of
# x^(i) from training set !!!
#
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

# for radial with precomputed landmarks

function SVMStruct = train_libsvm(f, y)

SVMStruct = svmtrain(y,f,'[-s 2 -t 2 -g 2 -e 0.001]');

end  