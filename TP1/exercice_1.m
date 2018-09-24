clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Separation des canaux RVB','Position',[0,0,0.67*L,0.67*H]);
figure('Name','Nuage de pixels dans le repere RVB','Position',[0.67*L,0,0.33*L,0.45*H]);

% Lecture et affichage d'une image RVB :
I = imread('gantrycrane.png');
figure(1);				% Premiere fenetre d'affichage
subplot(2,2,1);				% La fenetre comporte 2 lignes et 2 colonnes
imagesc(I);
axis off;
axis equal;
title('Image RVB','FontSize',20);

% Decoupage de l'image en trois canaux et conversion en doubles :
R = double(I(:,:,1));
V = double(I(:,:,2));
B = double(I(:,:,3));

% Affichage du canal R :
colormap gray;				% Pour afficher les images en niveaux de gris
subplot(2,2,2);
imagesc(R);
axis off;
axis equal;
title('Canal R','FontSize',20);

% Affichage du canal V :
subplot(2,2,3);
imagesc(V);
axis off;
axis equal;
title('Canal V','FontSize',20);

% Affichage du canal B :
subplot(2,2,4);
imagesc(B);
axis off;
axis equal;
title('Canal B','FontSize',20);

% Affichage du nuage de pixels dans le repere RVB :
figure(2);				% Deuxieme fenetre d'affichage
plot3(R,V,B,'b.');
axis equal;
xlabel('R');
ylabel('V');
zlabel('B');
rotate3d;

% Matrice des donnees :
X = [R(:) V(:) B(:)];			% Les trois canaux sont vectorises et concatenes

% Matrice de variance/covariance :
n = size(X,1);
g = [sum(X(:,1)) sum(X(:,2)) sum(X(:,3))];
Xc =  X - g;
Sigma = (1/n) * (Xc') * Xc; 

% Coefficients de correlation lineaire :
var_R = Sigma(1,1)
var_V = Sigma(2,2) 
var_B = Sigma(3,3) 

r_RV = Sigma(1,2) / sqrt(var_R * var_V);
r_RB = Sigma(1,3) / sqrt(var_R * var_B);
r_BV = Sigma(2,3) / sqrt(var_B * var_V);

% Proportions de contraste :
sum_var = var_R + var_V + var_B;
c_R = var_R / sum_var
c_V = var_V / sum_var
c_B = var_B / sum_var


