%Returns modified Hausdroff distance
function [MH] = MHD(I1, DM1, I2, DM2)
h1 = mean(DD(I1,DM2));
h2 = mean(DD(I2,DM1));
MH = max(h1,h2);
end