function [Hs,dUds] = HamiltonianTPS(template,Br,hs,Ax,Ay,As,Uc)
%function [Hs,dUds] = Hamiltonian(TPS,Br,hs,Ax,Ay,As,Uc)
% Br: p = q*Br
% TPS: Hs,Ax,Ay,As
% TPS array: dUds(1:2*OSIP.CanonicalDimensions) functions of Delta only
% TPS array: Uc(1:OSIP.NumberOfVariables) functions of Delta only
% Purpose: Obtain the Hamiltonian data of ID at location s with reference orbit Uc.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 05-Jun-2003
% Updated Date:
%  05-Jun-2003
%  12-Jun-2003 Use mpower(tps,n) = tps^n.
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
%------------------------------------------------------------------------------
global OSIP

% Uc(1:OSIP.NumberOfVariables) is the reference orbit.
U = VariablesOfTPS(TPS,1:OSIP.NumberOfVariables);
% U(1) = X = VariableOfTPS(TPS,1);
% U(2) = PX = VariableOfTPS(TPS,2);
% U(3) = Y = VariableOfTPS(TPS,3);
% U(4) = PY = VariableOfTPS(TPS,4);
% U(5) = Delta = VariableOfTPS(TPS,5);

for i=1:OSIP.NumberOfVariables
    U(i) = U(i)+Uc(i);
end

D2 = (1+U(5))^2; %D2 = (1+Delta)^2;
PX2 = (U(2)-Ax/Br)^2; %PX2 = (PX-Ax/Br)^2;
PY2 = (U(4)-Ay/Br)^2; %PY2 = (PY-Ay/Br)^2;
T1 = As/Br;
T2 = sqrt(D2-PX2-PY2);
Hs = -T1-T2*(1+hs*U(1));

V(1) = TPS;
V(2) = TPS;
V(3) = TPS;
V(4) = TPS;
V(5) = VariableOfTPS(TPS,5);

dXds = DerivativeTPS(Hs,2); % dXds == D_Hs_PX
dUds(1) = ConcatenateTPSbyVPS(dXdst,V,0);
dPXds = -DerivativeTPS(Hs,1); % dPXds == D_Hs_X
dUds(2) = ConcatenateTPSbyVPS(dPXdst,V,0);
dYds = DerivativeTPS(Hs,4); % dYds == D_Hs_PY
dUds(3) = ConcatenateTPSbyVPS(dYds,V,0);
dPYds = -DerivativeTPS(Hs,3); % dPYds == D_Hs_Y
dUds(4) = ConcatenateTPSbyVPS(dPYds,V,0);

clear D2 PX2 PY2 T1 T2 U V dXds dPXds dYds dPYds