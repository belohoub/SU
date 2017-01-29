#############################################################
########## Create landmarks and create similarity ###########
#############################################################

function [f_double] = similarityMatrix(training_set, count, sigma)
  
#########################################
########## SCALE ALL SYMPTOMS ###########
#########################################     

for i = 1:8
  for j = 1:count
    max_feature(i) = max(training_set(:,i));
    scaled_training_set(j,i) = training_set(j,i) / max_feature(i);
  endfor
endfor     
    
########################################
########## COMPUTE SIMILARITY ##########
########################################    

# INITIALIZE THETA AND MATRIX OF SIMILARITY

for i = 1:count
  for j = 1:count
    # sample X
    x_1 = scaled_training_set(i,:);
    # landmark
    x_2 = scaled_training_set(j,:);
    
    # similarity of sample X is in ROW
    # rounding to DOUBLE
    f_double(i,j) = exp(-norm(x_1 - x_2)^2 / 2 * sigma^2);
  endfor
endfor

end