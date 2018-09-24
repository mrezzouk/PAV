% Reconnaissance des phonèmes : 
% path = '/mnt/n7fs/ens/tp_queau/Apprentissage';
path = '/Users/maryarez/Documents/tav/TP13_TAV/Apprentissage/';

noms_phonemes = {'a', 'e', 'e_aigu', 'e_grave', 'i', 'o', 'o_ouvert', 'ou', 'u'}; 
nb_coefficients = 882;


d_spec = []; 
d_ceps = []; 
spec_means = [];
ceps_means = [];
bonne_classification = [];

% 
for i=1:length(noms_phonemes)
    % 
    for j=1:5
        filename = strcat(path, noms_phonemes{i},'_',num2str(j),'.wav');
        [signal,f_echantillonnage] = audioread(filename); 
        
        [coefficients_spectre,coefficients_cepstre] = spec_ceps(signal, nb_coefficients,f_echantillonnage);
        
        d_spec = [d_spec; mean(coefficients_spectre)]; 
        d_ceps = [d_ceps; mean(coefficients_cepstre)]; 
        
        bonne_classification = [bonne_classification ; i];
    end
    
    spec_means = [spec_means; mean(d_spec(1+(i-1)*5:i*5,:))];
    ceps_means = [ceps_means; mean(d_ceps(1+(i-1)*5:i*5,:))];
end 

[Idx_spec, C_spec] = kmeans(d_spec, length(noms_phonemes),'emptyaction', 'error', 'start', spec_means);
[Idx_ceps, C_ceps] = kmeans(d_ceps, length(noms_phonemes),'emptyaction', 'error', 'start', ceps_means);
taux_bonnes_class_spec = (sum(Idx_spec == bonne_classification) / 45) * 100;
disp(taux_bonnes_class_spec); 
taux_bonnes_class_ceps = (sum(Idx_ceps == bonne_classification) / 45) * 100;
disp(taux_bonnes_class_ceps);

% Transformation par ACP
X_ceps = d_ceps;  
g = mean(X_ceps); 
Xc = X_ceps - g; 
Sigma = (1/size(X_ceps,1))* (Xc') * Xc; 
[W,D] = eig(Sigma);
[D,J] = sort(diag(D),'descend');
W = W(:,J);
C_ceps = Xc * W; 

% X_spec = d_spec;  
% g = mean(X_spec); 
% Xc_spec = X_spec - g; 
% Sigma = (1/size(X_spec,1))* (Xc_spec') * Xc_spec; 
% [W,D] = eig(Sigma);
% [D,J] = sort(diag(D),'descend');
% W = W(:,J);
% C_spec = Xc * W; 
% 
% % Affichage des classes
% choix_couleurs = {'* r','* g','* b','* m','+ r','+ g','+ b','+ m','+ y'}; 
% figure('Name', 'classification non supervisée de phonèmes - spec')
% hold on; 
% for k=1:size(C_spec(:,1), 1)
%     if (Idx_spec(k) == bonne_classification(k))
%         color = choix_couleurs{Idx_spec(k)};
%     else
%         color = 'o k';
%     end
%     plot(C_spec(k,1), C_spec(k,2), color);   
% end 

% Affichage des classes - ceps
choix_couleurs = {'* r','* g','* b','* m','+ r','+ g','+ b','+ m','+ y'}; 
figure('Name', 'classification non supervisée de phonèmes - ceps')
hold on; 
for k=1:size(C_ceps(:,1), 1)
    if (Idx_ceps(k) == bonne_classification(k))
        color = choix_couleurs{Idx_ceps(k)};
    else
        color = 'o k';
    end
    plot(C_ceps(k,1), C_ceps(k,2), color);   
end 

