function z=rbend_sirius(fname,L,A,A1,A2,gap,fint1,fint2,PolynomA,PolynomB,method)
%rbend_sirius('FAMILYNAME',  Length[m], BendingAngle[rad], EntranceAngle[rad],
%	ExitAngle[rad], Gap, FInt1, FInt2, PolyA, PolyB, 'METHOD')
%	creates a new family in the FAMLIST - a structure with fields
%		FamName        	family name
%		Length         	length of the arc for an on-energy particle [m]
%		BendingAngle	total bending angle [rad]
%		EntranceAngle	[rad] (0 - for sector bends)
%		ExitAngle		[rad] (0 - for sector bends)
%		ByError			error in the dipole field relative to the design value 
%		PolyA			skew multipoles
%       PolyB           normal multipoles
%		PassMethod      name of the function to use for tracking
% returns assigned address in the FAMLIST that is uniquely identifies
% the family

% garante que PolynomA e PolynomB tenham mesmo comprimento.
PolyA = zeros(1,max([length(PolynomA) length(PolynomB) 4]));
PolyA(1:length(PolynomA)) = PolynomA;
PolyB = zeros(1,max([length(PolynomA) length(PolynomB) 4]));
PolyB(1:length(PolynomB)) = PolynomB;    

ElemData.FamName = fname;  % add check for identical family names
ElemData.Length			= L;
ElemData.MaxOrder       = length(PolyA)-1;
ElemData.NumIntSteps 	= 20;
ElemData.BendingAngle  	= A;
ElemData.EntranceAngle 	= A1;
ElemData.ExitAngle     	= A2;
ElemData.ByError     	= 0;
ElemData.PolynomA       = PolyA;
ElemData.PolynomB       = PolyB;
ElemData.FullGap   		= gap;
ElemData.FringeInt1		= fint1; 
ElemData.FringeInt2		= fint2; 
%ElemData.K      		= PolyB(2);

ElemData.R1 = diag(ones(6,1));
ElemData.R2 = diag(ones(6,1));
ElemData.T1 = zeros(1,6);
ElemData.T2 = zeros(1,6);

ElemData.PassMethod = method;

global FAMLIST
z = length(FAMLIST)+1; % number of declare families including this one
FAMLIST{z}.FamName = fname;
FAMLIST{z}.NumKids = 0;
FAMLIST{z}.KidsList= [];
FAMLIST{z}.ElemData= ElemData;

