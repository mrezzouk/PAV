function AD_RVB = attache_donnees_RVB(I,moyennes,variances_covariances)

N = size(moyennes,2);
AD_RVB = zeros(size(I,1),size(I,2),size(moyennes,2));

for c=1:N
    for i=1:size(I,1)
        for j=1:size(I,2)
            
            vect(1,1) = I(i,j,1) - moyennes(1,c);
            vect(2,1) = I(i,j,2) - moyennes(2,c);
            vect(3,1) = I(i,j,3) - moyennes(3,c);
            AD_RVB(i,j,c) = (1/2*log(2*pi) + log(det(variances_covariances(:,:,c))))...
                    * (-1/2 * vect' * (variances_covariances(:,:,c) \ vect));
                
        end
    end
end

end