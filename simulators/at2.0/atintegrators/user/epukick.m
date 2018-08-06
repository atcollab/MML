function z=epukick(fname,nx,ny,XEPU,YEPU,PXEPU,PYEPU,method)

%   epukick(fname,nx,ny,XEPU,YEPU,PXEPU,PYEPU,method)
%   creates a new family in the FAMLIST - a structure with fields
%   FamName         family name
%   nx              number of points in x
%   ny              number of points in y
%   XEPU            meshgrid of x
%   YEPU            meshgrid of y
%   PXEPU           meshgrid of px
%   PYEPU           meshgrid of py
%   PassMethod      name of the function to use for tracking
%
%   internally the additional structure fields are set:
%
%   R1              6 x 6 rotation matrix at the entrance
%   R2              6 x 6 rotation matrix at the entrance
%   T1              6 x 1 translation at entrance
%   T2              6 x 1 translation at exit4
%
%   returns assigned address in the FAMLIST that uniquely identifies
%   the family

ElemData.FamName = fname;  % add check for identical family names
ElemData.Length = 0;
ElemData.NumX = nx;
ElemData.NumY = ny;
for i=1:ny
    for j=1:nx
        ElemData.XGrid(i,j) = XEPU(i,j);
        ElemData.YGrid(i,j) = YEPU(i,j);
        ElemData.PxGrid(i,j) = PXEPU(i,j);
        ElemData.PyGrid(i,j) = PYEPU(i,j);
    end
end

ElemData.R1 = diag(ones(6,1));
ElemData.R2 = diag(ones(6,1));
ElemData.T1 = zeros(1,6);
ElemData.T2 = zeros(1,6);
ElemData.PassMethod=method;

global FAMLIST
z = length(FAMLIST)+1; % number of declare families including this one
FAMLIST{z}.FamName = fname;
FAMLIST{z}.NumKids = 0;
FAMLIST{z}.KidsList= [];
FAMLIST{z}.ElemData= ElemData;
