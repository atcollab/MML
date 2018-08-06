function z=idthickkickmap(fname,len,NumIntSteps,XEPU,YEPU,PXEPU,PYEPU,method)

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

ElemData.FamName     = fname;  % add check for identical family names
ElemData.Length      = len;
ElemData.NumIntSteps = NumIntSteps;
ElemData.NumX        = size(XEPU,2);
ElemData.NumY        = size(XEPU,1);
ElemData.XGrid       = XEPU;
ElemData.YGrid       = YEPU;
ElemData.PxGrid      = PXEPU;
ElemData.PyGrid      = PYEPU;
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
