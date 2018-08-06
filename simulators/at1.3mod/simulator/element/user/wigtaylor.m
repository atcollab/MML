function z=wigtaylor(fname,L,x,nx,px,npx,y,ny,py,npy,delta,ndelta,t,nt,t1,t2,method)

%WIGGLER('FAMILYNAME',Length [m], MapX, NumOfMonoX, MapPx, NumOfMonoPx, MapY, NumOfMonoY, 
%MapPy, NumOfMonoPy, MapT, NumOfMonoT, MapDelta, NumOfMonoDelta, 'METHOD')
%   creates a new family in the FAMLIST - a structure with fields
%   FamName         family name
%   Length          length [m]
%   MapX            Taylor map of final X
%   NumOfMonoX      number of monomials in MapX
%   MapPx           Taylor map of final Px
%   NumOfMonoPx     number of monomials in MapPx
%   MapY            Taylor map of final Y
%   NumOfMonoY      number of monomials in MapY
%   MapPy           Taylor map of final Py
%   NumOfMonoPy     number of monomials in MapPy
%   MapDelta        Taylor map of final Delta E
%   NumOfMonoDelta  number of monomials in MapDelta
%   MapT            Taylor map of final T
%   NumOfMonoT      number of monomials in MapT
%   PassMethod      name of the function to use for tracking
%                   returns assigned address in the FAMLIST that is uniquely
%                   identifies the family
%
% Weishi Wan, November 2002

NumOfColumns = 9;

ElemData.FamName     = fname;  % add check for existing identical family names
ElemData.Length      = L;

for i=1:nx
 for j=1:NumOfColumns
  ElemData.MapX(i,j) = x(i,j);
 end
end
ElemData.NumOfMonoX = nx;

for i=1:npx
 for j=1:NumOfColumns
  ElemData.MapPx(i,j) = px(i,j);
 end
end
ElemData.NumOfMonoPx = npx;

for i=1:ny
 for j=1:NumOfColumns
  ElemData.MapY(i,j) = y(i,j);
 end
end
ElemData.NumOfMonoY = ny;

for i=1:npy
 for j=1:NumOfColumns
  ElemData.MapPy(i,j) = py(i,j);
 end
end
ElemData.NumOfMonoPy = npy;

for i=1:ndelta
 for j=1:NumOfColumns
  ElemData.MapDelta(i,j) = delta(i,j);
 end
end
ElemData.NumOfMonoDelta = ndelta;

for i=1:nt
 for j=1:NumOfColumns
  ElemData.MapT(i,j) = t(i,j);
 end
end
ElemData.NumOfMonoT = nt;

ElemData.R1          = diag(ones(6,1));
ElemData.R2          = diag(ones(6,1));
ElemData.T1          = t1;
ElemData.T2          = t2;
ElemData.PassMethod  = method;

global FAMLIST
z = length(FAMLIST)+1; % number of declare families including this one
FAMLIST{z}.FamName = fname;
FAMLIST{z}.NumKids = 0;
FAMLIST{z}.KidsList= [];
FAMLIST{z}.ElemData= ElemData;
