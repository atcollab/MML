function R = tfat2mad(R)
%TFAT2MAD - Convert an AT 6x6 transfer matrix to MAD
%  Rmad = tfat2mad(Rat)
%
%        1   2  3   4    5    6
%  MAD:  x, px, y, py,  dL,  dp/p   (negative time lag)
%  AT:   x, px, y, py, dp/p, dL     (positive time lag)
%
%  See also tfmad2at

% MAD uses the same transverse variables if constant ddp is 0;

R(:,6) = -1 * R(:,6);
R(6,:) = -1 * R(6,:);
R = R(:,[1 2 3 4 6 5]);
R = R([1 2 3 4 6 5],:);
