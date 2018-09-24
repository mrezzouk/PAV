clear;
close all;
load exercice_1;
figure('Name','Image tiree aleatoirement','Position',[0.2*L,0.2*H,0.6*L,0.5*H]);
s = 6.0e+03;			% Seuil de reconnaissance a regler convenablement

% Tirage aleatoire d'une image de test :
individu = randi(15);
posture = randi(6);
fichier = [chemin '/i' num2str(individu,'%02d') num2str(posture,'%1d') '.mat'];
load(fichier);
img = eval(['i' num2str(individu,'%02d') num2str(posture,'%1d')]);
image_test = double(img(:))';

% Affichage de l'image de test :
colormap gray;
imagesc(img);
axis image;
axis off;

% Calcul du nombre N de composantes principales a prendre en compte :
% Proportions de contraste :


trace_Sigma = sum(Vp_Sigma_2); 
p_c = 0;
N = 0;
while p_c < 0,95
    p_c = sum(Vp_Sigma_2(1:N))/trace_Sigma;
    N = N + 1; 
end

% N premieres composantes principales des images d'apprentissage :
C_N = C(:,1:N);

% N premieres composantes principales de l'image de test :
...

% Determination de l'image d'apprentissage la plus proche :
...

% Affichage du resultat :
% if ...<s
% 	individu_reconnu = ...
% 	title({['Posture numero ' num2str(posture) ' de l''individu numero ' num2str(individu)];...
% 		['Je reconnais l''individu numero ' num2str(individu_reconnu)]},'FontSize',20);
% else
% 	title({['Posture numero ' num2str(posture) ' de l''individu numero ' num2str(individu)];...
% 		'Je ne reconnais pas cet individu !'},'FontSize',20);
% end
