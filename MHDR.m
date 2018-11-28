%Modified Hausdroff distance for images in polar coordinates
function [MH] = MHDR(I1,DM1,r1,I2,DM2,r2)
h1 = mean(DD(I1,DM2)'.*(I1(:,1)*r1(2)/2/pi + r1(1)).^0.1);
h2 = mean(DD(I2,DM1)'.*(I2(:,1)*r2(2)/2/pi + r2(1)).^0.1);
MH = max(h1,h2);
end