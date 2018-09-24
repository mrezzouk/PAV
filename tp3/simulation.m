function [x_gauche,x_droite] = simulation(y,beta_0,gamma_0,delta_moyen,sigma_delta,d)

delta_aleatoire = (randn(1,2*d-1) .* sigma_delta + delta_moyen)';

beta_est = [delta_aleatoire(1:d-1); delta_aleatoire(2*d-1)];
gamma_est = delta_aleatoire(d:(2*d-1));


x_droite = bezier(y,gamma_0,gamma_est);
x_gauche = bezier(y,beta_0,beta_est);

end