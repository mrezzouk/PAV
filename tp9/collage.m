function u = collage(r,s,interieur)


[nb_lignes_r,nb_colonnes_r,nb_canaux] = size(r);
% Convertir s et r en double
r = double(r);
s = double(s);

% La liste d'indices des bords
matrice_bords = ones(nb_lignes_r, nb_colonnes_r);
matrice_bords(2:end-1, 2:end-1) = 0;

bord_r = find(matrice_bords == 1);
nb_bord_r = length(bord_r);

% Le gradient :
nb_pixels = nb_lignes_r*nb_colonnes_r;
e = ones(nb_pixels,1);
Dx = spdiags([-e e],[0 nb_lignes_r],nb_pixels,nb_pixels);
Dx(nb_pixels-nb_lignes_r+1:nb_pixels,:) = 0;
Dy = spdiags([-e e],[0 1],nb_pixels,nb_pixels);
Dy(nb_lignes_r:nb_lignes_r:nb_pixels,:) = 0;

% Le Laplacien
A = -Dx'*Dx - Dy'*Dy;
A(bord_r,:) = sparse(1:nb_bord_r,bord_r,ones(nb_bord_r,1),nb_bord_r,nb_pixels);

u = r;
for k = 1:nb_canaux
  	u_k = u(:,:,k);
  	s_k = s(:,:,k);
    r_k = r(:,:,k);
    
    % Calcul des gradients
    g_k_x = Dx * r_k(:);
    g_k_y = Dy * r_k(:);
    g_s_x = Dx * s_k(:);
    g_s_y = Dy * s_k(:);
    g_k_x(interieur) = g_s_x(interieur);
    g_k_y(interieur) = g_s_y(interieur);

    % Calcul de b
    b_k = - Dx' * g_k_x  - Dy' * g_k_y ;
    b_k(bord_r) = u_k(bord_r);
    
    % Resolution 
  	u_k  = A \ b_k;
  	u(:,:,k) = reshape(u_k, nb_lignes_r, nb_colonnes_r);
end
