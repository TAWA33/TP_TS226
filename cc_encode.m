function c = cc_encode(u, trellis)
    state = 0;
    c_int = zeros(length(u)+log2(trellis.numStates), 1);
    for i = 1:length(u) % Encoding
        c_int(i) = trellis.outputs(state+1, u(i)+1);
        state = trellis.nextStates(state+1, u(i)+1);
    end
    for i = 1:log2(trellis.numStates) % Closing
        if trellis.nextStates(state+1, 1) < trellis.nextStates(state+1, 2) % is nextstate with input bit 0 < output of bit 1
            u_close = 0;
        else
            u_close = 1;
        end
        c_int(length(u)+i) = trellis.outputs(state+1, u_close+1);
        state = trellis.nextStates(state+1, u_close+1);
    end
    c = int2bit(c_int, trellis.numInputSymbols);
end
