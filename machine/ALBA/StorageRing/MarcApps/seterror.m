function [qdx qdy]=seterror(dx,dy)
%  seterror(dx,dy)
%  set  random dx dy errorrs
global THERING;
global THERING;
BENDINDEX_nR = findcells(THERING, 'PassMethod', 'BndMPoleSymplectic4Pass');
QUADSEXTINDEX_nR = findcells(THERING,'PassMethod','StrMPoleSymplectic4Pass');
BENDINDEX_R = findcells(THERING, 'PassMethod', 'BndMPoleSymplectic4RadPass');
QUADSEXTINDEX_R = findcells(THERING,'PassMethod','StrMPoleSymplectic4RadPass');
mag_index=sort(unique([BENDINDEX_nR QUADSEXTINDEX_nR BENDINDEX_R QUADSEXTINDEX_R]));

% dy=50E-6;
% dx=50E-6;
qdx=dx*randn(1,length(mag_index));
qdy=dy*randn(1,length(mag_index));
setshift(mag_index, qdx, qdy);