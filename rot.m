%Function that rotates an image about its centroid
function [I] = rot(I, ang, C)
R = [cos(ang), -sin(ang); sin(ang), cos(ang)];
I(:,1) = -I(:,1);
C(:,1) = -C(:,1);
I = C + (I - C)*R;
I = image(I(:,2),I(:,1),1);
end