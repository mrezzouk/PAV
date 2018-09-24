function AD = attache_donnees(I,moyennes,variances)

N = size(moyennes,2);
AD = zeros(size(I,1), size(I,2), N); 

% for c=1:N
%     AD(:,:,c) =  0.5 * (log(variances(c)) + (I(:,:) - (moyennes(c))).^2/variances(c));
% end

for k=1:length(moyennes)
    AD(:,:,k) = 0.5*log(variances(k)) + 0.5*((I(:,:) - moyennes(k))/sqrt(variances(k))).^2;
end
end