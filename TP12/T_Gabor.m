function TG = T_Gabor(signal,nb_echantillons_par_mesure)
    
    nb_echantillons = length(signal);
    ind_start = 1;   
    ind_end = nb_echantillons_par_mesure;
    
    TG = [];
    while ind_end < nb_echantillons
        TG = [TG fft(signal(ind_start:ind_end))];
        
        ind_start = ind_start + nb_echantillons_par_mesure;
        ind_end = ind_end + nb_echantillons_par_mesure;
    end
end