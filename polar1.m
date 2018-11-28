%Function for converting a given image to polar coordinates
function [P,r] = polar1(I)
C = centroid(I);
I = I - C;
P(:,1) = atan2(-I(:,1),I(:,2))+pi;
P(:,2) = sqrt(sum(I.^2,2));
r = min(P(:,2));
P(:,2) = P(:,2) - r;
r = [r max(P(:,2))];
P(:,2) = P(:,2)/r(2)*2*pi;
P = image(P(:,1),P(:,2),0);
P(:,2) = mod(P(:,2)-1,47) + 1;
end