#######################################
########## MANUAL PREDICTION ##########
#######################################

function pred = predictManual(model, X)
  
if (size(X, 2) == 1)
    # Examples should be in rows
    X = X';
end

# Number of features in predicated sample 
m = size(X, 1);
# Prepare result vector/matrix
p = zeros(m, 1);
# Prepare prediction
pred = zeros(m, 1);

# Times predicated sample by teachers answers
K = bsxfun(@times, model.y', X);
# Times predicated sample by alphas
K = bsxfun(@times, model.alphas', K);
# Suma on each rows of predictManual samples and get result in <-1;1>
p = sum(K, 2);

# Convert predictions into 0 / 1 and get answers
pred(p >= 0) =  1;
pred(p <  0) =  0;

end

