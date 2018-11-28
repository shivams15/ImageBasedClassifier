%Function for calculating Distance Map
function [D] = DistMap(I)
L = length(I(:,1));
for i = 1:48
    for j = 1:48
        dm = +Inf;
        for k = 1:L
            d = sqrt((I(k,1)-i)^2 + (I(k,2)-j)^2);
            if dm > d
                dm = d;
            end
        end
        D(i,j) = dm;
    end
end
end