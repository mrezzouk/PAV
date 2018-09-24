function [F_1_chapeau,F_2_chapeau,a_chapeau] = MV(xy_donnees_bruitees,x_F_aleatoire,y_F_aleatoire,a_aleatoire)

% Fonction qui calcule le maximum de vraisemblance 

minimum = inf;
indice = -1;
nb_tirages = size(x_F_aleatoire,2);
n = size(xy_donnees_bruitees,2);
for k=1:nb_tirages
    D_x(1,:) = (x_F_aleatoire(1,k) * ones(1,n) - xy_donnees_bruitees(1,:));
    D_x(2,:) = (y_F_aleatoire(1,k) * ones(1,n) - xy_donnees_bruitees(2,:));
    D_x = D_x.^2;
    distance_F1 = sqrt(sum(D_x));
    D_y(1,:) = (x_F_aleatoire(2,k) * ones(1,n) - xy_donnees_bruitees(1,:));
    D_y(2,:) = (y_F_aleatoire(2,k) * ones(1,n) - xy_donnees_bruitees(2,:));
    D_y = D_y.^2;
    distance_F2 = sqrt(sum(D_y));
    e = distance_F1 + distance_F2 -2*a_aleatoire(1,k);
    e = e.^2;
    somme_e = sum(e);
    if somme_e < minimum
        minimum = somme_e;
        indice = k;
    end
end

F_1_chapeau = [x_F_aleatoire(1,indice); y_F_aleatoire(1,indice)];
F_2_chapeau = [x_F_aleatoire(2,indice); y_F_aleatoire(2,indice)];
a_chapeau = a_aleatoire(1,indice);