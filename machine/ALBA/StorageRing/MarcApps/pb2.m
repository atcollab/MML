function varargout = plotbeta(varargin)
%PLOTBETA plots UNCOUPLED! beta-functions
% PLOTBETA(RING) calculates beta functions of the lattice RING
% PLOTBETA with no argumnts uses THERING as the default lattice
%  Note: PLOTBETA uses FINDORBIT4 and LINOPT which assume a lattice
%  with NO accelerating cavities and NO radiation
%
% See also PLOTCOD 
global THERING

    RING = THERING;

L = length(RING);
twiss=gettwiss();
betax=twiss.betax;
betay=twiss.betay;
s=twiss.s;
etax=twiss.etax;
for i=1:length(RING), 
    L(i)=RING{i}.Length; 
end;

[TD, tune] = twissring(RING,0,1:(length(RING)+1));
BETA = cat(1,TD.beta);
S  = cat(1,TD.SPos);
betax=BETA(:,1);
betay=BETA(:,2);


%tune=[twiss.phix(length(twiss.phix)),twiss.phiy(length(twiss.phiy))] ;
disp(tune)

if nargin > 0 
    sim=varargin{1};
else
   sim=1
end
if nargin > 1
    step = varargin{2};
else
    step=0.2;
end
range=[0  max(s)];
np=floor((range(2)-range(1))/step);
ss=range(1)+[(0:np)*step max(s)/4];
bxs=spline(s(L>0), betax(L>0), ss);
bys=spline(s(L>0), betay(L>0), ss);
etaxs=spline(s(L>0), etax(L>0), ss);
% plot betax and betay in two subplots

subplot(32,1,[1 25])
hold off
plot(s, betax, '.r');
hold on
plot(s, betay,'.b');
plot(s, 10*etax,'.g');
plot(ss, bxs,'r-');
plot(ss, bys,'b-');
plot(ss, 10*etaxs,'g-');
ylabel('\beta_{x,y} [m]');
grid on
hold on
%plot(S,BETA(:,2),'.-r');

title('\beta-functions');

legend('\beta_x','\beta_y','10*D_x');
xaxis([0 max(s)/sim])
subplot(32,1,[28 32])
hold off
drawlattice()
xaxis([0 max(s)/sim])

set(gca,'ytick',[])
set(gca,'xtick',[])
% Set the same horizontal scale as beta x plot

