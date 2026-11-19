function constellation = cstl_psk(M, is_gray)
    % Fonction qui génère un tableau ordonné de la constellation 
    % M       : (int) ordre de la modulation
    % is_gray : (bool) type du mapping
    %           true => "Gray", false => "Naturel"
    cstl=zeros(1,M);
    phi_ini=(2*pi)/M;
    if not(is_gray)
        for k=1:M
            cstl(k)=exp((k-1)*1j*phi_ini);
        end
    else
        index=zeros(1,M); %Liste des bits (Mapping de Gray)
        index(2)=1;
        for k=1:log2(M)-1
            index(2^k+1 : 2^(k+1))=index(2^k:-1:1)+2^k;
        end
        index(:)=index(:)+1;
        for k=1:M
            cstl(index(k))=exp((k-1)*1j*phi_ini);
        end
        
    end
    constellation=cstl;
end