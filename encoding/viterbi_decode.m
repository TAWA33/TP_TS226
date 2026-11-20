function u = viterbi_decode(y, trellis)
    numStates = trellis.numStates;
    numInputSymbols = trellis.numInputSymbols;
    numOutputSymbols = trellis.numOutputSymbols;
    ns = log2(numOutputSymbols);
    L = length(y) / ns;
    y = reshape(y, ns, L)';   % L x ns

    metrics = inf(numStates, L + 1);
    paths = zeros(numStates, L + 1); % previous state
    metrics(1, 1) = 0; % initial state = 0

    % --- Forward recursion ---
    for t = 1:L
        for s = 0:numStates-1
            if isinf(metrics(s+1, t))
                continue; 
            end
            for b = 0:numInputSymbols-1
                sNext = trellis.nextStates(s+1, b+1);
                out = int2bit(trellis.outputs(s+1, b+1), ns)';   % 0/1

                bm = sum(y(t,:) ~= out);

                nm = metrics(s+1, t) + bm;
                if nm < metrics(sNext+1, t+1)
                    metrics(sNext+1, t+1) = nm;
                    paths(sNext+1, t+1)   = s;
                end
            end
        end
    end

    % --- Final optimal state ---
    [~, idx]    = min(metrics(:, L+1));
    states      = zeros(1, L+1);
    states(L+1) = idx - 1;

    % --- traceback ---
    for t = L:-1:1
        states(t) = paths(states(t+1)+1, t+1);
    end

    % --- Take entry bits ---
    u = zeros(1, L);
    for t = 1:L
        u(t) = find(trellis.nextStates(states(t)+1, :) == states(t+1), 1) - 1;
    end
end