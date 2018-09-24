function [mu, Sigma] = estimation_mu_Sigma(X)


n = size(X,1);     

mu = mean(X);    
X_c = X - mu;
Sigma = (1/n) * (X_c' * X_c);