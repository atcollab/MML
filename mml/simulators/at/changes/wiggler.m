function z=wiggler(fname,L,nz,nx,B,lambdaz,phasez,kx,method)

%WIGGLER('FAMILYNAME',Length [m], NumOfLongHarm, NumOfTranHarm, B-field, LAMBDAZ [m], Phase, KX,'METHOD')
%   creates a new family in the FAMLIST - a structure with fields
%   FamName         family name
%   Length          length [m]
%   NumOfLongHarm   number of longitudinal harmonics
%   NumOfTranHarm   number of transverse harmonics associated with each longitudinal
%                   harmonics
%   Lambdaz         wave length [m]
%   Phasez          phase of longitudinal harmonics [deg]
%   Bfield          Peak magnetic field of each harmonics [1/m]
%   Kx              horizontal wave number
%   PassMethod      name of the function to use for tracking
%                   returns assigned address in the FAMLIST that is uniquely
%                   identifies the family
%
% Weishi Wan, November 2002

ElemData.FamName     = fname;  % add check for existing identical family names
ElemData.Length      = L;
ElemData.NumOfLongHarm = nz;
ElemData.NumOfTranHarm = nx;
lambdaz_max = lambdaz(1);
for i=1:nz
 ElemData.Lambdaz(i) = lambdaz(i);
 ElemData.Phasez(i) = phasez(i);
 for j=1:nx
  ElemData.Kx(i,j)      = kx(i,j);
  ElemData.Bfield(i,j) = B(i,j);
 end
 if (lambdaz(i)>lambdaz_max);
     lambdaz_max = lambdaz(i);
 end
end

ElemData.NumIntSteps = floor(10*L/lambdaz_max)
ElemData.R1          = diag(ones(6,1));
ElemData.R2          = diag(ones(6,1));
ElemData.T1          = zeros(1,6);
ElemData.T2          = zeros(1,6);
ElemData.PassMethod  = method;

global FAMLIST
z = length(FAMLIST)+1; % number of declare families including this one
FAMLIST{z}.FamName = fname;
FAMLIST{z}.NumKids = 0;
FAMLIST{z}.KidsList= [];
FAMLIST{z}.ElemData= ElemData;
