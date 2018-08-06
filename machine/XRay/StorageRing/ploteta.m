function varargout = plotbeta(varargin)
%PLOTBETA plots UNCOUPLED! beta-functions
% PLOTBETA(RING) calculates beta functions of the lattice RING
% PLOTBETA with no argumnts uses THERING as the default lattice
%  Note: PLOTBETA uses FINDORBIT4 and LINOPT which assume a lattice
%  with NO accelerating cavities and NO radiation
%
% See also PLOTCOD 
if nargin == 0
	global THERING
	RING = THERING;
end
L = length(RING);
spos = findspos(RING,1:L+1);

[TD, tune, chrom] = twissring(THERING,0,1:(length(THERING)+1), 'chrom');
BETA = cat(1, TD.beta);
ETA  = cat(1, TD.Dispersion);
ETA  = num2cell([eta_x(1:TD.SPos), eta_xp(1:TD.SPos),
                 eta_y(1:TD.SPos), eta_yp(1:TD.SPos)], 4); 
S    = cat(1, TD.SPos);

disp(tune)

figure
% plot betax and betay in two subplots

plot(S, ETA(:,1),'.-b');

A = axis;
A(1) = 0;
A(2) = S(end);
axis(A);
%xlabel('s - position [m]');
ylabel('\eta_x [m]');
grid on


title('Dispersion');
