clear;
close all;

exercice_2;

% Estimation des parametres par les moindres carres totaux :
x = transpose(xy_donnees_bruitees(1,:));
y = transpose(xy_donnees_bruitees(2,:));
% Calcul des moyennes et variances
moy_x = mean(x);
var_x = sqrt(sum(abs(x - moy_x).^2));
x = (x - moy_x)/var_x;

moy_y = mean(y);
var_y = sqrt(sum(abs(y - moy_y).^2));
y = (y - moy_y)/var_y; 

X_chapeau = MCT(x,y);
X_chapeau = X_chapeau ./ [(var_x)^2; var_x * var_y; (var_y)^2; var_x; var_y; 1];

[C_chapeau,theta_0_chapeau,a_chapeau,b_chapeau] = conversion(X_chapeau);
C_chapeau = C_chapeau + [moy_x;moy_y];

% Affichage de l'ellipse estimee par MCT :
affichage_ellipse(C_chapeau,theta_0_chapeau,a_chapeau,b_chapeau,theta_points_ellipse,'y-',3);
lg = legend(' Ellipse',' Donnees bruitees',' Estimation par MV',' Estimation par MCO', 'Estimation par MCT','Location','Best');
set(lg,'FontSize',20);

% Calcul du score de l'ellipse estimee par MCT :
R_chapeau = [cos(theta_0_chapeau) -sin(theta_0_chapeau) ; sin(theta_0_chapeau) cos(theta_0_chapeau)];
c_chapeau = sqrt(a_chapeau*a_chapeau-b_chapeau*b_chapeau);
F_1_chapeau = R_chapeau*[c_chapeau ; 0]+C_chapeau;
F_2_chapeau = R_chapeau*[-c_chapeau ; 0]+C_chapeau;
fprintf('Score de l''estimation par MCT = %.3f\n',score(F_1,F_2,a,F_1_chapeau,F_2_chapeau,a_chapeau));
