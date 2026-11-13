function c = cc_encode(u, trellis)
    state = 0;
    c_int = zeros(length(u), 1);
    for i = 1:length(u)
        c_int(i) = trellis.outputs(state+1, u(i)+1);
        state = trellis.nextStates(state+1, u(i)+1);
    end
    c = int2bit(c_int, trellis.numInputSymbols);
end
