#####################################
########## GAUSSIAN KERNEL ##########
#####################################

function f = gaussianKernel(x1, x2, sigma)
  f = exp(-norm(x1 - x2)^2 / 2 * sigma^2); 
end
