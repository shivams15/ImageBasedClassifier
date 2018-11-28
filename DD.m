%Function for calculating directed distances
function [h] = DD(I1,DM2)
for i = 1:length(I1(:,1))
    h(i) = DM2(I1(i,1),I1(i,2));
end
end