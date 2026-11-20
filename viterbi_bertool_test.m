function [ber, numBits] = viterbi_bertool_test(EbNo, maxNumErrs, maxNumBits)
% Wrapper BERTool pour viterbi_decode (décision dure, BPSK, AWGN)
%   EbNo        : Eb/N0 en dB (scalaire)
%   maxNumErrs  : limite d'erreurs (scalaire)
%   maxNumBits  : limite de bits    (scalaire)
%   ber, numBits : sorties attendues par BERTool

    % --- Paramètres système ---
    trellis  = poly2trellis(7, [171 133]);   % K=7, R=1/2
    codeRate = 1/2;
    k        = 1;                            % 1 bit/symbole (BPSK)

    % Eb/N0 -> Es/N0 -> variance du bruit (par dimension)
    snr      = EbNo + 10*log10(k) + 10*log10(codeRate);
    noiseVar = 10.^(-snr/10);                % = N0 (énergie symbole = 1)

    % --- Boucle Monte-Carlo ---
    totErr  = 0;
    numBits = 0;
    msgLen  = 1000;

    while (totErr < maxNumErrs) && (numBits < maxNumBits)
        % 1) bits info
        txBits = randi([0 1], msgLen, 1);            % colonne

        % 2) encodage + modulation BPSK
        codedBits = convenc(txBits, trellis);
        txSym     = 2*codedBits - 1;

        % 3) canal AWGN
        rxSym = txSym + sqrt(noiseVar/2) * randn(size(txSym));

        % 4) décision dure : 0/1 (double, colonne)
        rxBits = double(rxSym > 0);

        % 5) décodage Viterbi
        decodedBits = viterbi_decode(rxBits, trellis);

        % 6) alignement de forme
        decodedBits = decodedBits(:);                % colonne
        decodedBits = decodedBits(1:msgLen);

        % 7) compteurs (scalaires !)
        errs    = sum(decodedBits ~= txBits);
        totErr  = totErr + errs;
        numBits = numBits + msgLen;
    end

    ber = totErr / numBits;
end