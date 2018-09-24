clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Separation des canaux RVB','Position',[0,0,0.67*L,0.67*H]);

% Lecture et affichage d'une image RVB :
I = imread('pears.png');
figure(1);				% Premiere fenetre d'affichage
subplot(2,2,1);				% La fenetre comporte 2 lignes et 2 colonnes
imagesc(I);
axis off;
axis equal;
title('Image RVB d''origine','FontSize',20);

% Decoupage de l'image en trois canaux et conversion en doubles :
R = double(I(:,:,1));
V = double(I(:,:,2));
B = double(I(:,:,3));

 
% Matrice des donnees :
X = [R(:) V(:) B(:)];			% Les trois canaux sont vectorises et concatenes

% Matrice de variance/covariance :
n = size(X,1);
g = [sum(X(:,1)) sum(X(:,2)) sum(X(:,3))];
Xc =  X - g;
Sigma = (1/n) * (Xc') * Xc; 

% La matrice Sigma est symétrique réelle 
% Décomposition de Sigma suivant une base orthonormée de vecteurs/val
% propres
[W,D] = eig(Sigma); 
[Vp_Sigma,Q] = sort(diag(D), 'descend');

% Composantes principales de l'ACP
P = W(:,Q');
C = Xc * P;

% Decoupage de l'image en trois canaux et conversion en doubles :
[i,j,k] = size(I); 
Iacp = reshape(C, [i,j,k]);
Racp = double(Iacp(:,:,1));
Vacp = double(Iacp(:,:,2));
Bacp = double(Iacp(:,:,3));

% % Matrice de variance/covariance :
% n = size(C,1);
% m = [sum(C(:,1)) sum(C(:,2)) sum(C(:,3))];
% Cc =  C - m;
% Sigma_acp = (1/n) * (Cc') * Cc; 

% Affichage de la première composante principale :
colormap gray;				% Pour afficher les images en niveaux de gris
subplot(2,2,2);
imagesc(Racp);
axis off;
axis equal;
title('Première composante principale','FontSize',20);

% Affichage du canal (1/3)*(R+V+B) :
subplot(2,2,3);
imagesc((1/3)*(Racp+Vacp+Bacp));
axis off;
axis equal;
title('(1/3)*(R+V+B)','FontSize',20);

% Affichage du canal 0.2989 * R + 0.5870 * V + 0.1140 * B :
subplot(2,2,4);
imagesc(0.2989 * Racp + 0.5870 * Vacp + 0.1140 * Bacp);
axis off;
axis equal;
title('0.2989 * R + 0.5870 * V + 0.1140 * B','FontSize',20);