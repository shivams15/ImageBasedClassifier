%Function for calculating the centroid
function [C] = centroid(I)
L = 0;
dx = 0;
dy = 0;
for i = 2:length(I(:,1))
    y = 0.5*(I(i,1) + I(i-1,1));
    x = 0.5*(I(i,2) + I(i-1,2));
    l = sqrt((I(i,1)-I(i-1,1))^2 + (I(i,2)-I(i-1,2))^2);
    dx = dx + l*x;
    dy = dy + l*y;
    L = L + l;
end
C = [dy/L dx/L];
end