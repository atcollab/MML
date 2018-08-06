function OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions)
% function OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions)
% Generate the One-Step Index Pointer (OSIP) database which is the nerves of TPSA.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  No. 101, Hsin-ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 11-Dec-2002
% Updated Date:
%  30-Apr-2003
%  13-May-2003
% Source Files:
%  OSIP_Nerve.m
% Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  OSIP is the Nerve of TPSA and TPS is the basic class of TPSA.
%  Declare the OSIP data structure and use it as "global OSIP".
%  And then, build up the Nerve of TPSA, i.e. the database of OSIP.
%  Which is unique in one's program/package/project using TPSA.
%  In MATLAB, the index of array works FORTRAN-like.
%------------------------------------------------------------------------------
% Fileds-Names:
%  OSIP.PowerVector[NumberOfVariable]
%  (~= js)
%  OSIP.UnitVectors(i)
%  (~= makeVariable(i))
%  OSIP.NumberOfMonomials(1:NumberOfVariables,1:MaximumOrder)
%  (== nmo)
%  OSIP.MonomialPowerVector(1:NumberOfMonomials,1:NumberOfVariables)
%  (~= jv)
%  OSIP.IndexByOrderOfVariables(1:MaximumOrder,1:NumberOfVariables)
%  (~= jpek ~= nmov != jt)
%  OSIP_MonomialsBeginIndex(NumberOfVariables,Order)
%  (== nmob)
%  OSIP_MonomialsEndedIndex(NumberOfVariables,Order)
%  (== nmoe)
%  OSIP_PowerVector2Monomial(PowerVector[NumberOfVariable])
%  (~= jpek)
%------------------------------------------------------------------------------
% Note: Monomials of Power Series Expansion of Multi-variables Polynomial
% Definitions:
%  OSIP.IndexShift (== I) is 0 for FORTRAN, MATHLAB and -1 for C/C++.
%  NumberOfVariables == n > 0
%  Variables, Ex. x_(1+I), x_(2+I), ... , x_(n+I)
%  Order == o >= 0
%  (1)
%  OSIP_NumberOfMonomials(n,o)
%  == number of monomials with orders from 0 up to o
%  == NOM(n,o) = nchoosek((n+o),o) = (n+o)!/n!/o!
%  (2a)
%  OSIP.MonomialPowerVector(NOM(n,o),1:OSIP.NumberOfVariables)
%  == the powe-vectors of the monomials.
%  (2b)
%  OSIP.IndexByOrderOfVariables(1:OSIP.MaximumOrder,1:OSIP.NumberOfVariables)
%  == the BeginIndex of A(o,i:n) for i = 1:n.
%  (2c)
%  N = OSIP.NumberOfVariables
%  O = OSIP.MaximumOrder
%  OSIP.MasterIndices{n=1:N,o=1:O}(1:OSIP_NumberOfMonomials(N-n,o))
%  == Tno(1:OSIP_NumberOfMonomials(N-n,o))
%------------------------------------------------------------------------------
% Reference: TPSA_OSIP_Note.doc
%------------------------------------------------------------------------------
global OSIP

if NumberOfVariables < 1
   error('Input argument NumberOfVariables should >= 1')
end
if MaximumOrder < 0
   error('Input argument MaximumOrder should >= 0')
end
if CanonicalDimensions < 0
   error('Input argument CanonicalDimension should >= 0')
end

OSIP.NumberOfVariables = NumberOfVariables;
OSIP.MaximumOrder = MaximumOrder;
OSIP.CanonicalDimensions = floor(NumberOfVariables/2);
if CanonicalDimensions < OSIP.CanonicalDimensions
   OSIP.CanonicalDimensions = CanonicalDimensions;
end

% The IndexShift == I
% = -0 for MATLAB and FORTRAN
% = -1 for C and C++
OSIP.IndexShift = -0;
% In MATLAB, we ignore the +I since I = 0.

% Create the UnitVectors by MATLAB's 'eye' function.
% Each vector represents a variable.
% OSIP.UnitVectors(i) == x(i), i = 1,2,...
OSIP.UnitVectors = eye(NumberOfVariables);

% Create the PowerVector by MATLAB's 'zeros' function.
% The ith-component of PowerVector represents the order of the ith-variable.
% OSIP.PowerVector(i) == o(i), i = 1,2,...
% Example: OSIP.UnitVectors(i)^OSIP.PowerVector(i) == x(i)^o(i)
OSIP.PowerVector = zeros(1,NumberOfVariables);

% Prepare Monomials
% (1) NumberOfMonomials
% NumberOfMonomials(1:NumberOfVariables,1:MaximumOrder) with
% NumberOfMonomials(i,j) = (i+j)!/(i!j!) = nchoosek((i+j),j)
% Total number of i variables monomials with orders from 0 upto j.
%tic
%OSIP.NumberOfMonomials = ones(NumberOfVariables,MaximumOrder);
%for i = 1:NumberOfVariables
%    for j = 1:MaximumOrder
%        OSIP.NumberOfMonomials(i,j) = nchoosek(i+j,j);
%    end
%end
%toc
%>>> elapsed_time(1) = 0.0200

%tic
i = 1:OSIP.NumberOfVariables;
OSIP.NumberOfMonomials(i,1) = i+1;
for i = 1:OSIP.NumberOfVariables
    for j = 2:OSIP.MaximumOrder
        OSIP.NumberOfMonomials(i,j) = OSIP.NumberOfMonomials(i,j-1)*(i+j)/j;
    end
end
%clear i j
%toc
%>>> elapsed_time(2) = 0.0100

%tic
%OSIP.NumberOfMonomials = mxNumberOfMonomials(OSIP.NumberOfVariables,OSIP.MaximumOrder);
%toc
%>>> elapsed_time(3) > elapsed_time(2)

% (2a) MonomialPowerVector
% MonomialPowerVector(NumberOfMonomials(NumberOfVariables,MaximumOrder),NumberOfVariables)
% MonomialPowerVector(kth-monomial,kth-monomial's power-vector)
m = OSIP.NumberOfMonomials(NumberOfVariables,MaximumOrder);
OSIP.MonomialPowerVector = zeros(m,NumberOfVariables);
% (2b) IndexByOrderOfVariables == the BeginIndex of A(o,i:n) for i = 1:n
% IndexByOrderOfVariables(MaximumOrder,NumberOfVariables)
OSIP.IndexByOrderOfVariables = ones(MaximumOrder,NumberOfVariables);
%
% Order = 0,
% A) the 1th monomial's power-vector = zero-vector
% B) OSIP.IndexByOrderOfVariables(0,NumberOfVariables) == contant-term's index is 1+I 
%
% Order = 1,
% A) i = OSIP.MonomialsBeginIndex(NumberOfVariables,1);
%    j = OSIP.MonomialsEndedIndex(NumberOfVariables,1);
%    OSIP.MonomialPowerVector(i:j) = OSIP.UnitVectors(1:NumberOfVariables);
OSIP.MonomialPowerVector(2:NumberOfVariables+1,:) = OSIP.UnitVectors(1:NumberOfVariables,:);
% B) i = the i'th variable
%    OSIP.IndexByOrderOfVariables(1,i) = 1+i+I;
for i = 1:NumberOfVariables
    OSIP.IndexByOrderOfVariables(1,i) = 1+i;
end
%
% Order > 1,
for k = 2:MaximumOrder
    k1 = k-1;
    m = OSIP.NumberOfMonomials(NumberOfVariables,k1);
    for i = 1:NumberOfVariables
        n = NumberOfVariables-i+1;
        k2 = k-2;
        if k2 == 0
           d = OSIP.NumberOfMonomials(n,k1)-1;
        else
           d = OSIP.NumberOfMonomials(n,k1)-OSIP.NumberOfMonomials(n,k2);
        end
        p = OSIP.NumberOfMonomials(NumberOfVariables,k1)-d;
        OSIP.IndexByOrderOfVariables(k,i) = m+1;
        for j = 1:d
            m = m+1;
            p = p+1;
            OSIP.MonomialPowerVector(m,:) = OSIP.UnitVectors(i,:)+OSIP.MonomialPowerVector(p,:);
        end
    end
end
%clear f i j k m n np1 o

% (2c) OSIP.Master_Indices{N,O}
% for n=1:N and o=1:O
% OSIP.MasterIndices{n,o}(OSIP.NumberOfMonomials(OSIP.NumberOfVariables+1-n,o))
np1 = OSIP.NumberOfVariables+1;
OSIP.MasterIndices = cell(OSIP.NumberOfVariables,OSIP.MaximumOrder);
for n=1:OSIP.NumberOfVariables
    for o=1:OSIP.MaximumOrder
        m = np1-n;
        OSIP.MasterIndices{n,o} = ones(1,OSIP.NumberOfMonomials(m,o));
        for j=1:o
            i = OSIP_MonomialsBeginIndex(m,j);
            f = OSIP_MonomialsEndedIndex(m,j);
            for k=i:f
                OSIP.MasterIndices{n,o}(k) = OSIP.IndexByOrderOfVariables(j,n)+k-i;
            end
        end
    end
end
%clear d i j k k1 k2 m n p

clear d f i j k k1 k2 m n np1 o

% Prepare some coefficients of functions in Taylor expansion
OSIP_TaylorExpanCoeOfFuns;