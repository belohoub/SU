############################################
########## LOAD DATA AND PACKAGES ##########
############################################
# apt-get install liboctave-dev
# pkg install -forge io
pkg load io

# LOAD PREPROCESSED DATA titanic_preprocessing_2.csv FROM titanic.csv
# !!!CHECK CORECT PATH!!!
data = csv2cell('/home/dzejkob23/Documents/SU/titanic.csv');


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
    
    
########################################
########## ??? ##########
########################################    
    
    
    
    
    
    
    