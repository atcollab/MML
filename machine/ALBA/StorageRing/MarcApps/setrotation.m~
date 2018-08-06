function setrotation(varargin)
%  seterror(dq, seed, factor)
%  set  random dq errorr
%  dq is the std(\psi_s) in radians
%  seed 
%  factor
%  applies it to  quads and sextupoles
dq=0.25E-3;
factor=1;
if  length(varargin)>0
    dq=cell2mat(varargin(1));
end
if length(varargin)>1
    seed=cell2mat(varargin(2));
  randn('state', seed);
end
if length(varargin)>2
    factor=(cell2mat(varargin(3)));
end
global THERING;
BENDINDEX_nR = [];%findcells(THERING, 'PassMethod', 'BndMPoleSymplectic4Pass');
QUADSEXTINDEX_nR = findcells(THERING,'PassMethod','StrMPoleSymplectic4Pass');
BENDINDEX_R = []; %findcells(THERING, 'PassMethod', 'BndMPoleSymplectic4RadPass');
QUADSEXTINDEX_R = findcells(THERING,'PassMethod','StrMPoleSymplectic4RadPass');
mag_index=sort([BENDINDEX_nR QUADSEXTINDEX_nR BENDINDEX_R QUADSEXTINDEX_R]);
qdq=dq*factor*randn(1,length(mag_index));
settilt(mag_index, qdq);