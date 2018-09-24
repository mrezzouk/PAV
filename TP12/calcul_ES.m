function ES = calcul_ES(S,indices_partition,valeurs_t,valeurs_f_S)

ES = []; 
% La première colonne de la matrice ES doit contenir des instants ti,
% la seconde les fréquences fi correspondantes

nb_bandes = length(indices_partition); 
for k=1:nb_bandes-1
    % Selection de la sous-bande
    select_bande = S(indices_partition(k):indices_partition(k+1)-1,:);
    % Calcul du maximum du module complexe de chaque colonne du sonagramme 
    [val_max, inds_max] = max(abs(select_bande)); 
    % Selection des maximas en fonction du seuil calculé
    moyenne = mean(val_max); 
    ecart_type = std(val_max); 
    seuil = moyenne + ecart_type; 
    inds_selected = find(val_max > seuil); 
    freq_selected = valeurs_f_S(indices_partition(k) + inds_max(inds_selected) -1);
    
    % Construction de ES
    ES = [ES ; valeurs_t(inds_selected)', freq_selected']; 
end