function dl = TPS2DepritLie(t)
% function dl = TPS2DepritLie(tps)
% Convert TPS to DepritLie (linear-matrix M, non-linear-tps f)
% by setting vps = TPS2VPSbyLieTransformation(tps),
% then we have dl = VPS2DepritLie(vps).
% One can use BCH theorem to do it.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 15-May-2003
% Updated Date:
%  03-Jun-2003
% Source Files:
%  @TPS/TPS2DepritLie.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%------------------------------------------------------------------------------

% If the minimum order of TPS t < 3, TPS2VPSbyLieTransformation(t) is not a good way.
%[index,order,k] = NonZeroMinOrderTPS(t);
%if order < 3
%    if order < 2
%        error('The minimum-order of TPS < 2.')
%    end
%    cut = 20;
%    m = TPS2ndOrderMapMatrix(t,cut); % Linear part
%    .....   % Non-linear part ???
%else
v = TPS2VPSbyLieTransformation(t);
dl = VPS2DepritLie(v);
%end
clear v