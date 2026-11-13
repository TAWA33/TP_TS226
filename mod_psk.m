function s = mod_psk(b, constellation)
    % b             : (vecteur) vecteur contenant les bits à moduler
    % constellation : (vecteur) vecteur la constellation (ordre M)
    % s             : (vecteur) vecteur de symboles modulés
    M = length(constellation);         
    n_b = log2(M);                      
    N_symbols = length(b) / n_b;
    s = zeros(1, N_symbols);
    for k = 1:N_symbols
        bits = b((k-1)*n_b + 1 : k*n_b); %On choisi tous les bits pour former un symbole (ettiquette binaire)

        index = bin2dec(sprintf('%d', bits)) + 1; %On passe de binaire à int. A cause des indices Matlab, on ajoute 1 
        
        s(k) = constellation(index); % On écrit le symbole associé à chaque etiquette
    end
end
