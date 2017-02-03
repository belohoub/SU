#################################################
########## TRAINING WITH MANUAL KERNEL ##########
#################################################

function [model] = trainManual(X, Y, C, kernelFunction, tol, max_passes)

# Get size of matrix
# Columns
m = numel(X(:,1));
# Rows
n = numel(X(1,:));

# Change answers from 0/1 to -1/1
Y(Y==0) = -1;

# Variables
b = 0;
E = zeros(m, 1);
# Lagranges multiplayers
alphas = zeros(m, 1);
# Iterations
passes = 0;

eta = 0;
# Lower and Upper bound for alphas 
L = 0;
H = 0;

# Train
fprintf('\nTraining ...');
dots = 12;
K = X;
while passes < max_passes,
            
    num_changed_alphas = 0;
    for i = 1:m,
        
        # Calculate Ei = output error of i-th sample 
        E(i) = b + sum (alphas.*Y.*K(:,i)) - Y(i);
        
        # Conditions
        #     \alpha_i = 0 "=>" y_i f(X_i) >= 1
        # 0 < \alpha_i < C "=>" y_i f(X_i) = 1
        #     \alpha_i = C "=>" y_i f(X_i) =< 1
        #
        if ((Y(i)*E(i) < -tol && alphas(i) < C) || (Y(i)*E(i) > tol && alphas(i) > 0)),
            
            # Get random value => TOP/CEIL
            # We can do this by heuristic too
            j = ceil(m * rand());
            while j == i,  # i != j
                j = ceil(m * rand());
            end

            # Calculate Ei = output error of j-th sample
            E(j) = b + sum (alphas.*Y.*K(:,j)) - Y(j);

            # Save old alphas
            alpha_i_old = alphas(i);
            alpha_j_old = alphas(j);
            
            # Compute L and H
            if (Y(i) == Y(j)),
                L = max(0, alphas(j) + alphas(i) - C);
                H = min(C, alphas(j) + alphas(i));
            else
                L = max(0, alphas(j) - alphas(i));
                H = min(C, C + alphas(j) - alphas(i));
            end
           
            # If L eq H, go on next i
            if (L == H), 
                continue;
            end

            # Compute ETA
            eta = 2 * K(i,j) - K(i,i) - K(j,j);
            if (eta >= 0), 
                continue;
            end
            
            # Compute and clip new value for alpha(j) using
            alphas(j) = alphas(j) - (Y(j) * (E(i) - E(j))) / eta;
            
            # Clip
            alphas(j) = min (H, alphas(j));
            alphas(j) = max (L, alphas(j));
            
            # Check if change in alpha is significant
            if (abs(alphas(j) - alpha_j_old) < tol),
                alphas(j) = alpha_j_old;
                continue;
            end
            
            # Determine value for alpha(i) 
            alphas(i) = alphas(i) + Y(i)*Y(j)*(alpha_j_old - alphas(j));
            
            # Compute b1 and b2
            b1 = b - E(i) ...
                 - Y(i) * (alphas(i) - alpha_i_old) *  K(i,j)' ...
                 - Y(j) * (alphas(j) - alpha_j_old) *  K(i,j)';
            b2 = b - E(j) ...
                 - Y(i) * (alphas(i) - alpha_i_old) *  K(i,j)' ...
                 - Y(j) * (alphas(j) - alpha_j_old) *  K(j,j)';

            # Compute b
            if (0 < alphas(i) && alphas(i) < C),
                b = b1;
            elseif (0 < alphas(j) && alphas(j) < C),
                b = b2;
            else
                b = (b1+b2)/2;
            end

            num_changed_alphas = num_changed_alphas + 1;

        end
        
    end
    
    # If alpha doesn't changed, passes++. "while" will be quit, if algorithm
    # doesn't converge.
    if (num_changed_alphas == 0),
        passes = passes + 1;
    else
        passes = 0;
    end

    fprintf('.');
    dots = dots + 1;
    if dots > 78
        dots = 0;
        fprintf('\n');
    end
    if exist('OCTAVE_VERSION')
        fflush(stdout);
    end
end
fprintf(' Done! \n\n');

# Save result to the MODEL
model.y = Y;
model.alphas = alphas;
model.w = ((alphas.*Y)'*X)';

end
