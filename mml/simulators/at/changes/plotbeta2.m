function varargout = plotbeta(varargin)
% PLOTBETA(RING) finds and plots bea-functions of RING
%  It calls FindOrbit4 and LinOpt which assume a lattice
%  with NO accelerating cavities and NO radiation
% 
% PLOTBETA with no argumnts uses THERING as a default RING
%
% See also PLOTCOD 
if nargin == 0
	global THERING
	RING = THERING;
end
L = length(RING);
spos = findspos(RING,1:L+1);
[twissdata, tunes, chrom] = twissring(RING,0,1:L+1,'chrom');
RINGLength = spos(L)+RING{L}.Length; 
betax = zeros(1,L);
betay = zeros(1,L);
for i =1:L 
   betax(i) = twissdata(i).beta(1);
   betay(i) = twissdata(i).beta(2);
end
betax(L+1) = betax(1);
betay(L+1) = betay(1);
fprintf('nux=%g, nuy=%g\n',tunes(1),tunes(2));
fprintf('chromaticity xix=%g, xiy=%g\n',chrom(1),chrom(2));

figure
% plot betax and betay in two subplots

subplot(2,1,1)
%plot(spos,betax,'.-b'); Laurent sometimes negative !
plot(spos,abs(betax),'.-b');
A= axis;
A(1) = 0;
A(2) = RINGLength;
axis(A);
xlabel('s - position [m]');
ylabel('\beta_x [m]');
grid on


title('beta-functions');

subplot(2,1,2)
%plot(spos,betay,'.-r'); Laurent sometimes negative !
plot(spos,abs(betay),'.-r');
A= axis;
A(1) = 0;
A(2) = RINGLength;
axis(A);
xlabel('s - position [m]');
ylabel('\beta_y [m]');
grid on
addlabel(datestr(now));

if nargout > 0
	varargout{1}=betax;
end
if nargout ==2
	varargout{2}=betay;
end