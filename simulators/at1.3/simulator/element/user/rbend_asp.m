function z=rbend(fname,L,A,A1,A2,K,method, varargin)
%BEND('FAMILYNAME',  Length[m], BendingAngle[rad], EntranceAngle[rad],
%	ExitAngle[rad], K, 'METHOD')
%	creates a new family in the FAMLIST - a structure with fields
%		FamName        	family name
%		Length         	length of the arc for an on-energy particle [m]
%		BendingAngle		total bending angle [rad]
%		EntranceAngle		[rad] (0 - for sector bends)
%		ExitAngle			[rad] (0 - for sector bends)
%		ByError				error in the dipole field relative to the design value 
%		K						quadrupole K-value for combined funtion bends
%		PassMethod        name of the function to use for tracking
% returns assigned address in the FAMLIST that is uniquely identifies
% the family
% 
% Eugene 29/08/05 modified to be able to input Polynom data. 


ElemData.FamName = fname;  % add check for identical family names
ElemData.Length			= L;
ElemData.MaxOrder			= 3;
ElemData.NumIntSteps 	= 10;
ElemData.BendingAngle  	= A;
ElemData.EntranceAngle 	= A1;
ElemData.ExitAngle     	= A2;
ElemData.ByError     	= 0;
ElemData.K      			= K;

ElemData.R1 = diag(ones(6,1));
ElemData.R2 = diag(ones(6,1));
ElemData.T1 = zeros(1,6);
ElemData.T2 = zeros(1,6);

if nargin > 7
    PolynomA = varargin{1};
else
    PolynomA = [0 0 0 0];
end
if nargin > 8
    PolynomB = varargin{2};
else
    PolynomB = [0 K 0 0];
end

ElemData.PolynomA			= PolynomA;	 
ElemData.PolynomB			= PolynomB; 

% Eugene test s rotation method 25/08/05
% theta = pi/4;
% PolynomA			= [0 0 0 0];	 
% PolynomB			= [ElemData.BendingAngle/ElemData.Length K 0 0];
% ElemData.PolynomA= imag(exp(i*theta)*complex(PolynomB,PolynomA));	 
% ElemData.PolynomB= real(exp(i*theta)*complex(PolynomB,PolynomA)) - [ElemData.BendingAngle/ElemData.Length 0 0 0];

ElemData.PassMethod 		= method;

global FAMLIST
z = length(FAMLIST)+1; % number of declare families including this one
FAMLIST{z}.FamName = fname;
FAMLIST{z}.NumKids = 0;
FAMLIST{z}.KidsList= [];
FAMLIST{z}.ElemData= ElemData;

