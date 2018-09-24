clear;
close all;
load donnees;
figure('Name','Individu moyen et eigenfaces','Position',[0,0,0.67*L,0.67*H]);



% Calcul de l'individu moyen :
individu_moyen = mean(X);

% Centrage des donnees :
X_c = X - repmat(individu_moyen,n,1);

% Calcul de la matrice Sigma_2 (de taille n x n) :
Sigma_2 = (1/n) * X_c * (X_c');

% Calcul des vecteurs/valeurs propres de la matrice Sigma_2 :
[Vectp_Sigma_2,D] = eig(Sigma_2);


% Tri par ordre decroissant des valeurs propres de Sigma_2 :
[Vp_Sigma_2,Q] = sort(diag(D), 'descend');

% Tri des vecteurs propres de Sigma_2 dans le meme ordre :
Vectp_S2_tri = Vectp_Sigma_2(:,Q');

% Elimination du dernier vecteur propre de Sigma_2 :
Vectp_S2_tri = Vectp_S2_tri(:,1:(n-1)); 


% Vecteurs propres de Sigma (deduits de ceux de Sigma_2) :
W = (X_c)' * Vectp_S2_tri;


% Normalisation des vecteurs propres de Sigma :
W  = W ./ (ones(p,1) * sqrt(sum(W .^ 2))) ;


% Affichage de l'individu moyen et des eigenfaces sous forme d'images :
 colormap gray;
 img = reshape(individu_moyen,nb_lignes,nb_colonnes);
 subplot(nb_individus,nb_postures,1);
 imagesc(img);
 axis image;
 axis off;
 title('Individu moyen','FontSize',15);
 for k = 1:n-1
	img = reshape(W(:,k),nb_lignes,nb_colonnes);
	subplot(nb_individus,nb_postures,k+1);
	imagesc(img);
	axis image;
	axis off;
	title(['Eigenface ',num2str(k)],'FontSize',15);
 end

save exercice_1;
