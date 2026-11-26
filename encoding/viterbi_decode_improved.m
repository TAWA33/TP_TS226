function u = viterbi_decode_improved(y, trellis)
    S  = trellis.numStates;
    ns = log2(trellis.numOutputSymbols);
    L  = length(y)/ns;
    y  = reshape(y, ns, L);

    prevS = zeros(S,2); prevB = zeros(S,2);                          % <--
    Xp = zeros(ns, S, 2);                                            % <--
    cnt = zeros(S,1);                                                % <--
    for s = 0:S-1                                                    % <--
        for b = 0:1
            n = trellis.nextStates(s+1,b+1) + 1;                     % <--
            cnt(n) = cnt(n) + 1;  k = cnt(n);                        % <--
            prevS(n,k) = s + 1;                                      % <--
            prevB(n,k) = b;                                          % <--
            Xp(:,n,k)  = 1 - 2*int2bit(trellis.outputs(s+1,b+1), ns); % <--
        end
    end

    metrics = inf(S,1);  metrics(1) = 0;                             % <--
    choice  = zeros(S, L, 'uint8');                                  % <--
    for t = 1:L
        c1 = metrics(prevS(:,1)) - (y(:,t)' * Xp(:,:,1))';           % <--
        c2 = metrics(prevS(:,2)) - (y(:,t)' * Xp(:,:,2))';           % <--
        [metrics, k] = min([c1 c2], [], 2);                          % <--
        choice(:,t) = k;                                             % <--
    end

    u = zeros(1, L);  s = 1;                                         % <--
    for t = L:-1:1
        k    = choice(s,t);                                          % <--
        u(t) = prevB(s,k);                                           % <--
        s    = prevS(s,k);                                           % <--
    end
end