########################################
########## DATA PREPROCESSING ##########
########################################

function [training_set, y, features, count] = preprocessing(data)
  
# ALONE FEATURES AND DROP IT FROM DATASET
features = data(1,:);
data(1,:) = [];

# MAKE TEACJERS ANSWERS ALONE
y = data(:,1);
y = cell2mat(y);
data(:,1) = [];

# DROP NAMES - It's like ID's
data(:,2) = [];

# DROP CABIN (missing 77% values)
data(:,8) = [];

# TMP COUNT CELLS IN ONE COLUMN
count = numel(y(:,1));

# CONVERT MALE/FEMALE TO BINARY
for i = 1:count
  if (strcmpi(data(i, 2), 'female'))
    data(i, 2) = 1;
  else
    data(i, 2) = 0;
  endif
endfor

# TICKET TO NUMBER
for i = 1:count
  tmp = cell2mat(data(i, 6));
  if (!isnumeric(tmp))
    data(i, 6) = sum(toascii(tmp));
  endif
endfor

# EMBARKED TO NUMBER
for i = 1:count
  data(i, 8) = sum(cell2mat (toascii(data(i, 8))));
endfor

# CONVERT TO NUMERIC MATRIX
for i = 1:8
  for j = 1:count
    tmp = cell2mat(data(j, i));
    if (isnumeric(tmp))
      training_set(j,i) = tmp;
    endif
  endfor
endfor  

# ADD MEAN TO MISSING VALUES IN AGE
mean_age = mean(training_set(:,3));

for i = 1:count
  if (training_set(i, 3) == 0)
    training_set(i, 3) = mean_age;
  endif
endfor

end