%Function for calculating distance map for an image in polar coordinates
function [D] = DistMap1(I)
L = length(I(:,1));
for i = 1:48
    for j = 1:47
        dm = +Inf;
        for k = 1:L
            dx = I(k,2) + 24 -j;
            if dx < 1
                dx = dx + 47;
            elseif dx > 47
                dx = dx - 47;
            end
            d = sqrt((dx-24)^2 + (I(k,1)-i)^2);
            if dm > d
                dm = d;
            end
        end
        D(i,j) = dm;
    end
end
end