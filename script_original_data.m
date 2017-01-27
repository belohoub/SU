############################################
########## LOAD DATA AND PACKAGES ##########
############################################
# apt-get install liboctave-dev
# pkg install -forge io
pkg load io

# LOAD PREPROCESSED DATA titanic_preprocessing_2.csv FROM titanic.csv
# !!!CHECK CORECT PATH!!!
data = csv2cell('/home/dzejkob23/Documents/Git/SU/titanic.csv');


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
    
for i = 1:9
  for j = 1:count
    scaled_training_set(j,i) = training_set(j,i) / max(training_set(:,i));
  endfor
endfor    
    
########################################
########## COMPUTE SIMILARITY ##########
########################################    

# INITIALIZE THETA AND MATRIX OF SIMILARITY
theta_vector = [1;1;1;1;1;1;1;1;1];
# f = zeros (count, count, "uint8");

# SIGMA
sigma = 1;

for i = 1:count
  for j = 1:count
    # sample X
    x_1 = scaled_training_set(i,:);
    # landmark
    x_2 = scaled_training_set(j,:);
    
    # similarity of sample X is in ROW
    f(i,j) = exp(-norm(x_1 - x_2)^2 / 2 * sigma^2);
  endfor
endfor

# CREATE LANDMARKS
# NOMALIZE LANDAMRKS/X
# COMPUTE KERNELS BY LIBSVM OR OTHER LIBRARY (KERNEL, EXP, SIMILARITY, ...)