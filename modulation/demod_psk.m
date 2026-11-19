function bh = demod_psk(y, constellation)
    % y             : (vecteur) vecteur du signal reçu
    % constellation : (vecteur) vecteur de la constellation
    % bh            : (vecteur) vecteur des bits démodulés
    N_b=log2(length(constellation));
    index=zeros(1,length(y));
    bh=zeros(1, length(y)*N_b);

    for k=1:length(y)
        min_dist=inf; %Valeur la plus grande possible pour qu'au premier passage de boucle la 
                        % valeur soit directement changée
        for l=1:length(constellation)
            dist = abs(y(k) - constellation(l));
            if dist<min_dist
                min_dist=dist;
                index(k)=l;
            end
        end

    end

    for k = 1:length(y)
        idx = index(k) - 1; % De 0 à M-1
        bits = de2bi(idx, N_b, 'left-msb'); % Génère un vecteur de bits
                                            % left pour dire que le bit de
                                            % poids fort est à gauche
        bh((k-1)*N_b + 1:k*N_b) = bits;
    end
   

end