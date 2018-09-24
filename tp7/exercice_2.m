%--------------------------------------------------------------------------
% ENSEEIHT - 2IMA - Traitement des donnees Audio-Visuelles
% TP7 - Restauration d'images
% exercice_2.m : Debruitage avec modele d’inpainting par variation totale
%--------------------------------------------------------------------------

clear
close all
clc

% Mise en place de la figure pour affichage :
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Debruitage avec le modele de Tikhonov','Position',[0.06*L,0.1*H,0.9*L,0.7*H])

% Lecture de l'image :
u0 = double(imread('fleur.png'));
[nb_lignes,nb_colonnes,nb_canaux] = size(u0);
u_max = max(u0(:));

% Ajout d'un bruit gaussien :
sigma_bruit = 0.05;
u0 = u0 + sigma_bruit*u_max*randn(nb_lignes,nb_colonnes);

% Lecture du masque
nb_pixels = nb_lignes*nb_colonnes;

u_mask = double(imread('fleur_masque.png')) ./255;
W_prive_D = ones(size(u_mask)) - u_mask;
W_prive_D = spdiags(W_prive_D(:), 0, nb_pixels, nb_pixels);

% Affichage de l'image bruitee :
subplot(1,2,1)
	imagesc(max(0,min(1,u0/u_max)),[0 1])
	colormap gray
	axis image off
	title('Image bruitee','FontSize',20)

% Operateur gradient :
e = ones(nb_pixels,1);
Dx = spdiags([-e e],[0 nb_lignes],nb_pixels,nb_pixels);
Dx(nb_pixels-nb_lignes+1:nb_pixels,:) = 0;
Dy = spdiags([-e e],[0 1],nb_pixels,nb_pixels);
Dy(nb_lignes:nb_lignes:nb_pixels,:) = 0;

% Second menbre b du systeme : 
b = W_prive_D*reshape(u0, nb_pixels,nb_canaux);

% Matrice R de preconditionnement :
Lap = -Dx'*Dx - Dy'*Dy;
lambda = 15; % Poids de la regularisation
Ak = speye(nb_pixels) - lambda*Lap;
R = ichol(Ak,struct('droptol',1e-3));

% Resolution du systeme A*x = b (gradient conjugue preconditionne) :
epsilon = 0.01;
u_k= u0;
k = 1;
u_k_1 = u_k ;
 

    
while norm(u_k_1(:) -u_k(:)) > norm(u_k(:))/1000 || k==1
        for p=1:nb_canaux
            uc = u_k(:,:,p); 
            uc = uc(:); 
            bc = b(:,p); 
            diag_Wk = 1./sqrt((Dx*uc).^2 + (Dy*uc).^2 + epsilon);
            Wk = spdiags(diag_Wk,0,nb_pixels,nb_pixels);
            Lap_k = -Dx'*Wk*Dx - Dy'*Wk*Dy;
            Ak = W_prive_D - lambda * Lap_k;
            if k>1
                u_k(:,:,p) = u_k_1(:,:,p);
            end
            [u_k_1bis,flag] = pcg(Ak,bc,1e-5,50,R',R,uc);
            u_k_1(:,:,p) = reshape(u_k_1bis,nb_lignes,nb_colonnes);
        end
            % Affichage de l'image restauree :
            
            subplot(1,2,2)
            imagesc(max(0,min(1,u_k_1/u_max)),[0 1])
            colormap gray
            axis image off
            title('Image restauree  ',  'FontSize',20)
            % pause(0.1)

            drawnow nocallbacks;
            k = k+1; 
      
end
 