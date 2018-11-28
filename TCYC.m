%Returns Tanimoto and Yule coefficients
function [TC, YC] = TCYC(I1,DM1,I2,DM2)
na = length(I1(:,1));
nb = length(I2(:,1));
nab = 0;
for i = 1:na
    if DM2(I1(i,1),I1(i,2)) == 0
        nab = nab + 1;
    end
end
n00 = 48*48 - (na + nb - nab);
TC1 = -nab/(na + nb - nab);
TC2 = -n00/(na + nb - 2*nab + n00);
alpha = 0.75 - 0.25/2*(na + nb)/48^2;
TC = alpha*TC1 + (1-alpha)*TC2;
YC = -(nab*n00 - (na - nab)*(nb - nab))/(nab*n00 + (na - nab)*(nb - nab));
end