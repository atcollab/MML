function g = VPS2SingleLieTPS(vps)
% function sl = VPS2SingleLieTPS(vps)
% Convert VPS(Order >= 2 part) to SingleLieTPS g which is a TPS.
% Used for VPS2DepritLie.
% Ref. "The Use of Lie Algebra Methods to Analyze and Design Accelerator Beamlines"
% Author: Yiton T. Yan, SLAC
% Section. 3.6.2
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 27-May-2003
% Updated Date:
%  30-May-2003
%  03-Jun-2003
% Source Files:
%  @TPS/VPS2SingleLieTPS.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  vps(i) = M exp(:g:) u(i) or written as vps(i) = R exp(:f:) u(i) 
%  vps = TPS2VPSbyLieTransformation(tps) == vps(1:2*OSIP.CanonicalDimensions)
% u = ConcatenateVPSbyMatrix(v,inv(M));
%  g = VPS2SingleLieTPS(u)
%------------------------------------------------------------------------------
global OSIP
M = LinearSquareMatrixOfVPS(vps); %JacobianMatrixOfVPS(vps);
% How to check if M is identity matrix? (which should be an identity matrix).
row = length(M(:,1));
col = length(M(1,:));
if (row ~= col) | (row ~= OSIP.NumberOfVariables) | (col ~= OSIP.NumberOfVariables)
    error('In VPS2SingleLieTPS(vps), bug of LinearSquareMatrixOfVPS causes  row ~= column.')
end
D = M-eye(OSIP.NumberOfVariables);
SumAbs = 0;
for i=1:OSIP.NumberOfVariables
    a = abs(D(i,:));
    s = sum(a);
    SumAbs = SumAbs+s;
end
if SumAbs > 1e-5
    error('In VPS2SingleLieTPS(vps), LinearSquareMatrixOfVPS M is not a identity matrix.')
end
clear row col D a s SumAbs
dimension = length(vps);
order = vps(1).o;
for i=2:dimension
    order = max(order,vps(i).o);
end
order = min(OSIP.MaximumOrder,order+1);
% Define W(n-1,m,:) == Wnm(:), where m=1:n,
% is the vector homogeneous polynomials of order n.
n = 2; % W(n-1,m=1,:) = 2nd-order Homogeneous of vps(:), g_(n+1) = g3
for j=1:dimension
    W(n-1,1,j) = HomogeneousTPS(vps(j),n);
end
g = NoteOfVPS2DepritLie(W(n-1,1,:),n);
% n >= 3
for n=3:order
    for j=1:dimension
        W(n-1,1,j) = HomogeneousTPS(vps(j),n);
    end
    for m=2:(n-1)
        i = 1;
        gHomogeneous = HomogeneousTPS(g,i+2);
        for j=1:dimension
            W(n-1,m,j) = PoissonBracket(gHomogeneous,W(n-1,m-1,j));
        end
        for i=2:(n-m)
            gHomogeneous = HomogeneousTPS(g,i+2);
            for j=1:dimension
                W(n-1,m,j) = W(n-1,m,j)+PoissonBracket(gHomogeneous,W(n-i,m-1,j));
            end
        end
        for j=1:dimension
            W(n-1,m,j) = W(n-1,m,j)/m;
            W(n-1,1,j) = W(n-1,1,j)-W(n-1,m,j);
        end
    end
    g = g+NoteOfVPS2DepritLie(W(n-1,1,:),n);
end