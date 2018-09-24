function moy = moyenne(im)


im = double(im); 
R = im(:,:,1); 
V = im(:,:,2);
B = im(:,:,3); 

% Transformation en niveaux de couleurs normalisés 
im_rvb = (1 ./ max(1,R+V+B)) .* im; 

r_barre = mean(mean(im_rvb(:,:,1)));
b_barre = mean(mean(im_rvb(:,:,2)));

moy = [r_barre b_barre];
    


