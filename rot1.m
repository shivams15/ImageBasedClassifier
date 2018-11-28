%Function for finding the best rotation 
function [ang,dm] = rot1(I1,DM1,r1,I2,DM2,r2)
dm = +Inf;
ang = 0;
for i = 1:47
    I = [I1(:,1) mod(I1(:,2)+i-2,47)+1];
    DM = circshift(DM1, [0,i-1]);
    MH = MHDR(I,DM,r1,I2,DM2,r2);
    if dm > MH
        dm = MH;
        ang = i-1;
    end
end
ang = ang*2*pi/47;
end