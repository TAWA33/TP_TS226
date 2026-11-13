clear
clc

u = [1, 1, 0, 1, 0];
c_th = [3, 2, 0, 2, 0, 2, 3];
trellis = poly2trellis(3, [7, 5], 7);

c_exp = cc_encode(u, trellis)

