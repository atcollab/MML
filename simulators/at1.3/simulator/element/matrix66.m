function z = matrix66(fname, L, M66, method)
%MATRIX66('FamName', M66, 'PassMethod')
%   creates a new family in the FAMLIST - a structure with fields
%		FamName			family name
%		M66		        6x6 transfer matrix
%		PassMethod		name of the function on disk to use for tracking
%   returns assigned address in the FAMLIST that is uniquely identifies the family

ElemData.FamName = fname;  % add check for identical family names
ElemData.Length = L;
ElemData.M66 = M66;
ElemData.PassMethod=method;

global FAMLIST
z = length(FAMLIST)+1; % number of declare families including this one
FAMLIST{z}.FamName = fname;
FAMLIST{z}.NumKids = 0;
FAMLIST{z}.KidsList= [];
FAMLIST{z}.ElemData= ElemData;


