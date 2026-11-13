clear
clc

M = 2; % B-PSK
constellation = cstl_psk(M, true);

u = [1, 1, 0, 1, 0] % msg
trellis = poly2trellis(3, [7, 5], 7); % Encoding

encoded_msg = cc_encode(u, trellis)

modulated_msg = mod_psk(encoded_msg, constellation);

% Channel

demod_msg = demod_psk(modulated_msg, constellation);

decoded_msg = viterbi_decode(demod_msg, trellis)



