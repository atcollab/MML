function varargout = getbeta(varargin)
% GETBETA(RING) finds beta-functions of RING
%  It calls FindOrbit4 and LinOpt which assume a lattice
%  with NO accelerating cavities and NO radiation
% 
% GETBETA with no argumnts uses THERING as a default RING
%
% See also GETCOD 
if nargin == 0
	global THERING
	RING = THERING;
end
L = length(RING);
spos = findspos(RING,1:L+1);
[lopt, tunes] = linopt(RING,0,1:L);
RINGLength = spos(L)+RING{L}.Length; 
betax = zeros(1,L);
betay = zeros(1,L);
for i =1:L 
   betax(i) = lopt(i).beta(1);
   betay(i) = lopt(i).beta(2);
end
betax(L+1) = betax(1);
betay(L+1) = betay(1);

if nargout > 0
	varargout{1}=betax;
end
if nargout ==2
	varargout{2}=betay;
end