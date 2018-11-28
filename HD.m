%Returns Hausdroff distance
function [H] = HD(I1, DM1, I2, DM2)
h1 = DD(I1,DM2);
h1 = sort(h1,'Descend');
h1 = h1(floor(0.03*length(h1)) + 1);
h2 = DD(I2,DM1);
h2 = sort(h2,'Descend');
h2 = h2(floor(0.03*length(h2)) + 1);
H = max(h1,h2);
end