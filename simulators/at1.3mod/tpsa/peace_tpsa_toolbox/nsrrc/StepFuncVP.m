function [Ax,Ay,As,Bx,By,Bs] = StepFuncVP(template,ID,ss,Uc,Envelope)
%function [Ax,Ay,As,Bx,By,Bs] = StepFuncVP(TPS,ID,ss,Uc,Envelope)
% TPS: Ax,Ay,As,Bx,By,Bs
% double: s, Uc(1:OSIP.NumberOfVariables)
% structure: ID = DataOfID = IDofNSRRC(NameOfID,GapOrPhaseOrCurrentOfID)
% Purpose: Obtain the Magnetic Field and Vector Potential of ID at location s with reference orbit Uc.
% Note: Linear end-poles model is used.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 12-Jun-2003
% Updated Date:
%  13-Jun-2003
%  11-Jul-2003
%  15-Jul-2003
%  02-Sep-2003
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

% Magnetic Field Bx, By, Bs
Bx = TPS; Bx = Bx+ID.f0;
By = TPS; By = By+ID.g0;
Bs = TPS; Bs = Bs+ID.h0;
% Vector Potential Ax, Ay and As = 0 (TPS)
Ax = TPS; Ax = Ax+ID.G+ID.g0*ss;
Ay = TPS; Ay = Ay+ID.F+ID.f0*ss;
As = TPS;

% Note ID.Maximum_Harmonic_Number == n = 1 for ideal IDs 
for n=1:ID.Maximum_Harmonic_Number
    ID.nk1xx = n*ID.k1x(n)*U(1);
    ID.nk2xx = n*ID.k2x(n)*U(1);
    ID.nk1yy = n*ID.k1y(n)*U(3);
    ID.nk2yy = n*ID.k2y(n)*U(3);
    % In y direction, sinh(n*kmny*y) and cosh(n*kmny*y) are used.
    ID.s1y = sinh(ID.nk1yy);
    ID.s2y = sinh(ID.nk2yy);
    ID.c1y = cosh(ID.nk1yy);
    ID.c2y = cosh(ID.nk2yy);
    if ID.Mode == 0 % knmx^2 + ks^2 = kmny^2
        % In x directory, sin(n*knmx*x) and cos(n*kmnx*x) are used.
        ID.s1x = sin(ID.nk1xx);
        ID.s2x = sin(ID.nk2xx);
        ID.c1x = cos(ID.nk1xx);
        ID.c2x = cos(ID.nk2xx);
        ID.f1(n) = ID.k2x(n)*(ID.a2(n)*ID.s2x-ID.b2(n)*ID.c2x)*(ID.r2(n)*ID.c2y+ID.d2(n)*ID.s2y);
        ID.f2(n) = ID.k1x(n)*(-ID.a1(n)*ID.s1x+ID.b1(n)*ID.c1x)*(ID.r1(n)*ID.c1y+ID.d1(n)*ID.s1y);
    elseif ID.Mode == 1 % knmx^2 + kmny^2 = ks^2
        % In x directory, sinh(n*knmx*x) and cosh(n*kmnx*x) are used.
        ID.s1x = sinh(ID.nk1xx);
        ID.s2x = sinh(ID.nk2xx);
        ID.c1x = cosh(ID.nk1xx);
        ID.c2x = cosh(ID.nk2xx);
        ID.f1(n) = -ID.k2x(n)*(ID.a2(n)*ID.s2x+ID.b2(n)*ID.c2x)*(ID.r2(n)*ID.c2y+ID.d2(n)*ID.s2y);
        ID.f2(n) = ID.k1x(n)*(ID.a1(n)*ID.s1x+ID.b1(n)*ID.c1x)*(ID.r1(n)*ID.c1y+ID.d1(n)*ID.s1y);
    else
        error('Mode of ID ~= 0 or 1.')
    end
    ID.g1(n) = -ID.k2y(n)*(ID.a2(n)*ID.c2x+ID.b2(n)*ID.s2x)*(ID.r2(n)*ID.s2y+ID.d2(n)*ID.c2y);
    ID.g2(n) = ID.k1y(n)*(ID.a1(n)*ID.c1x+ID.b1(n)*ID.s1x)*(ID.r1(n)*ID.s1y+ID.d1(n)*ID.c1y);
    ID.h1(n) = ID.ks*(ID.a1(n)*ID.c1x+ID.b1(n)*ID.s1x)*(ID.r1(n)*ID.c1y+ID.d1(n)*ID.s1y);
    ID.h2(n) = ID.ks*(ID.a2(n)*ID.c2x+ID.b2(n)*ID.s2x)*(ID.r2(n)*ID.c2y+ID.d2(n)*ID.s2y);

    nk = n*ID.ks; nks = nk*ss; snks = sin(nk*ss); cnks = cos(nk*ss);
    Bx = Bx+ID.f1(n)*cnks+ID.f2(n)*snks;
    By = By+ID.g1(n)*cnks+ID.g2(n)*snks;
    Bs = Bs+ID.h1(n)*cnks+ID.h2(n)*snks;
    Ax = Ax+(ID.g1(n)*snks-ID.g2(n)*cnks)/nk;
    Ay = Ay-(ID.f1(n)*snks-ID.f2(n)*cnks)/nk;
end
Bx = Envelope*Bx;
By = Envelope*By;
Bs = Envelope*Bs;
Ax = Envelope*Ax;
Ay = Envelope*Ay;
As = Envelope*As;

clear U n nk nks snks cnks