clear;
close all;
load exercice_2;
load texture;
figure('Name','Simulation d''une flamme de bougie','Position',[0.33*L,0,0.67*L,H]);

I_max = 255;

% Simulation de flammes :
[nb_lignes_texture,nb_colonnes_texture] = size(texture);
largeur_col = 1000;				% Largeur de l'image
echelle_en_largeur = 0.5*largeur_col/(limites(4)-limites(3));
hauteur = 1000;				% Hauteur de l'image
h = round(0.85*hauteur);		% Hauteur de la flamme
y = 0:1/(h-1):1;			% Ordonnees normalisees entre 0 et 1
x_centre = (beta_0+gamma_0)/2;		% Abscisse du centre de la flamme
N = 40;					% Longueur de la sequence simulee
for k = 1:N
	I = zeros(hauteur,largeur_col);
	[x_gauche,x_droite] = simulation(y,beta_0,gamma_0,delta_moyen,sigma_delta,d);
    
    if all(x_gauche<=x_droite)
        for p=1:h
            
            colonne_min = round((L/2)+echelle_en_largeur*(x_gauche(p)-x_centre));
            colonne_max = round((L/2)+echelle_en_largeur*(x_droite(p)-x_centre));
            texture_ligne = round((nb_lignes_texture*(h-p)+ p)/h);
            largeur_col = colonne_max - colonne_min;
            
            if largeur_col ~= 0
                for colonne_I = colonne_min:colonne_max
                    texture_colonne = round((colonne_I-colonne_min)*(nb_colonnes_texture-1)/largeur_col);
                    I(p,colonne_I) = round(texture(texture_ligne,texture_colonne+1)*I_max);
                end
            end
        end
        imagesc(I);
        axis xy;
        axis off;
        colormap(hot);		% Table de couleurs donnant des couleurs chaudes (doc colormap)
        pause(0.1);
    end
end
