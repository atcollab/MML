function R = tfmad2at(R)
%TFMAD2AT - Convert a MAD 6x6 transfer matrix to AT
%  Rat = tfmad2at(Rmad)
%
%        1   2  3   4    5    6
%  MAD:  x, px, y, py,  dL,  dp/p   (negative time lag)
%  AT:   x, px, y, py, dp/p, dL     (positive time lag)
%
%  See also tfat2mad


% MAD uses the same transverse variables if constant ddp is 0

R = R(:,[1 2 3 4 6 5]);
R = R([1 2 3 4 6 5],:);
R(:,6) = -1 * R(:,6);
R(6,:) = -1 * R(6,:);
