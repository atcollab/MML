function vps = TPS2VPSbyLieTransformation(t)
% function vps = TPS2VPSbyLieTransformation(tps)
% Return vps(i) = exp(:tps:) u(i) = Sum{(:tps:)^n/n!} u(i)
% Important Note: (Peace Chang)
% If the minimum order of tps < 3, in order to improve the accuracy, the efficiency is very low. 
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 08-May-2003
% Updated Date:
%  03-Jun-2003
% Source Files:
%  @TPS/SingleLieTaylorMapVPS.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  vps(i) = exp(:t:) u(i) = Sum_n [(:t:)^n/n!] u(i)
%  vps = SingleLieTaylorMapVPS(t) == vps(1:2*OSIP.CanonicalDimensions)
%------------------------------------------------------------------------------
global OSIP
[index,order,k] = NonZeroMinOrderTPS(t);
if index == 0
   %vps = VariablesOfTPS(TPS,1:OSIP.NumberOfVariables);
   vps = VariablesOfTPS(TPS,1:2*OSIP.CanonicalDimensions);
else
    if order > 2
        cut = 0; n = 1; h = t;
        nPB = (OSIP.MaximumOrder-1)/(order-2);
    else
        % The order of PoissonBracket [p,q] is (p.o+q.o-2).
        % When the q = u(i), the variable of TPS, and q.o = 1,
        % if p.o < 3, this case may cause problem happened !!!
        % 1) HomogeneousTPS(p,0) can be ignored without lossing anything.
        % 2) HomogeneousTPS(p,1) can be killed by the coordinate transformation
        %    vs. the referenced closed orbit defined by the Lorentz force equation.
        % 3) HomogeneousTPS(p,2) can be treated as a linear transformation matrix.
        disp('Warning in TPS2VPSbyLieTransformation(tps): MinOrder of TPS tps < 3.')
        disp('Note: In order to improve the accuracy, the efficiency is very low.')
        cut = 20; n = 2^cut; h = t/n;
        nPB = 30;
    end
    clear index order k
    u = VariablesOfTPS(TPS,1:2*OSIP.CanonicalDimensions);
    % 1PB
    for i=1:2*OSIP.CanonicalDimensions
        vps(i) = PoissonBracket(h,u(i));
    end
    % nPB > 1PB
    fac = 1;
    for i=2:nPB
        fac = fac*i;
        for i=1:2*OSIP.CanonicalDimensions
            vps(i) = vps(i)+PoissonBracket(h,vps(i))/fac;
        end
    end
    % 0PB
    for i=1:2*OSIP.CanonicalDimensions
        vps(i) = vps(i)+u(i);
    end
    for i=1:cut
        j = 1:2*OSIP.CanonicalDimensions;
        u(j) = vps(j);
        for k=1:2*OSIP.CanonicalDimensions
            vps(k) = ConcatenateTPSbyVPS(vps(k),u,1);
        end
    end
    clear cut n h u fac i nPB
end