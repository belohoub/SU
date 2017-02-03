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
        
        % Calculate Ei = f(x(i)) - y(i) using (2). 
        % E(i) = b + sum (X(i, :) * (repmat(alphas.*Y,1,n).*X)') - Y(i);
        
        # f(x) = b + \sum \alpha_i y_i K(:, X_i) : "f(x) == Y(i)"
        # E(i) = b + \sum \alpha_i y_i K(:, X_i) - Y(i)
        #
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

            # f(x) = b + \sum \alpha_j y_j K(:, X_j) : "f(x) == Y(j)"
            # E(j) = b + \sum \alpha_j y_j K(:, X_j) - Y(j)
            #
            E(j) = b + sum (alphas.*Y.*K(:,j)) - Y(j);

            # Save old alphas
            alpha_i_old = alphas(i);
            alpha_j_old = alphas(j);
            
            % Compute L and H by (10) or (11). 
            if (Y(i) == Y(j)),
                L = max(0, alphas(j) + alphas(i) - C);
                H = min(C, alphas(j) + alphas(i));
            else
                L = max(0, alphas(j) - alphas(i));
                H = min(C, C + alphas(j) - alphas(i));
            end
           
            if (L == H),
                % continue to next i. 
                continue;
            end

            % Compute eta by (14).
            eta = 2 * K(i,j) - K(i,i) - K(j,j);
            if (eta >= 0),
                % continue to next i. 
                continue;
            end
            
            % Compute and clip new value for alpha j using (12) and (15).
            alphas(j) = alphas(j) - (Y(j) * (E(i) - E(j))) / eta;
            
            % Clip
            alphas(j) = min (H, alphas(j));
            alphas(j) = max (L, alphas(j));
            
            % Check if change in alpha is significant
            if (abs(alphas(j) - alpha_j_old) < tol),
                % continue to next i. 
                % replace anyway
                alphas(j) = alpha_j_old;
                continue;
            end
            
            % Determine value for alpha i using (16). 
            alphas(i) = alphas(i) + Y(i)*Y(j)*(alpha_j_old - alphas(j));
            
            % Compute b1 and b2 using (17) and (18) respectively. 
            b1 = b - E(i) ...
                 - Y(i) * (alphas(i) - alpha_i_old) *  K(i,j)' ...
                 - Y(j) * (alphas(j) - alpha_j_old) *  K(i,j)';
            b2 = b - E(j) ...
                 - Y(i) * (alphas(i) - alpha_i_old) *  K(i,j)' ...
                 - Y(j) * (alphas(j) - alpha_j_old) *  K(j,j)';

            % Compute b by (19). 
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

% Save the model
model.y = Y;
model.alphas = alphas;
model.w = ((alphas.*Y)'*X)';

end
