function z = crabcavity(fname,phi0,V,F,method)
% CRABCAVITY('FAMILYNAME',phase [m],Voltage[V], Frequency[Hz], 'METHOD')
%	creates a new family (vertical crab cavity) in the FAMLIST - a structure with fields
%		FamName			family name
%		Phase			phase[m]
%		Voltage			peak voltage (V)
%		Frequency		RF frequency [Hz] 
% 		HarmNumber		Harmonic Number
%		PassMethod		name of the function on disk to use for tracking
% returns assigned address in the FAMLIST that uniquely identifies
% the family

global GLOBVAL

ElemData.FamName = fname;  % add check for identical family names
ElemData.TimeLag = phi0;
ElemData.Length = 0;
ElemData.Voltage = V;
ElemData.Frequency = F;
ElemData.Energy = GLOBVAL.E0;
ElemData.PassMethod=method;

global FAMLIST
z = length(FAMLIST)+1; % number of declare families including this one
FAMLIST{z}.FamName = fname;
FAMLIST{z}.NumKids = 0;
FAMLIST{z}.KidsList= [];
FAMLIST{z}.ElemData= ElemData;


