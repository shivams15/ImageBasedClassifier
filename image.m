%Function for converting a gesture into a 48x48 image
function [I] = image(X,Y,c)
if c == 1
    X = X - min(X);
    Y = Y - min(Y);
end
H = max(Y);             % Height of the Bounding Box
W = max(X);             %  Width of the Bounding Box

if H>W
    X = X/H*47;
    if c == 1
        X = X + (47 -max(X))/2;
    end
    Y = Y/H*47;
else
    Y = Y/W*47;
    if c == 1
        Y = Y + (47-max(Y))/2;
    end
    X = X/W*47;
end
X = round(X);
Y = round(Y);
I = unique([48-Y X+1],'rows','stable');
end