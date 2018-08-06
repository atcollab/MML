%=============================================================
function varargout = simgui(action, varargin)
%=============================================================
%  bpmgui controls orbit manipulation and plotting

global FAMLIST THERING
injfig = findobj(0,'tag','injfig');  %injfig "global"
ah.bpm=findobj(injfig,'tag','ahbpm'); %handle for bpm display axes
lh.sim=findobj(injfig,'tag','simorb'); %handle for fit orbit plot

switch action

%==========================================================
case 'plotsim_init'                        %...plotsim_init
%==========================================================
%blue, solid dynamic line for actual orbit.
spos=findspos(THERING,1:length(THERING));
set(ah.bpm,'Color',[1 1 1],'NextPlot','add');
set(injfig,'currentaxes',ah.bpm)
% plot(spos(imin:imax),randn(1,imax-imin+1),...
% 	  'LineStyle','-','Color','b','tag', 'simorb'); %does this tag axes or line?


%==========================================================
case 'plotsim'                             %...plotsim
%==========================================================
%blue, solid dynamic line for actual orbit.
simgui('ylimits');


%==========================================================
case 'SetKnob'                             %...SetKnob
%==========================================================
h1=findobj(injfig,'tag','k1Slide');
mrad(1)=get(h1,'Value');

h1=findobj(injfig,'tag','k2Slide');
mrad(2)=get(h1,'Value');

h1=findobj(injfig,'tag','k3Slide');
mrad(3)=get(h1,'Value');

h1=findobj(injfig,'tag','scale');
set(h1,'Value',1);
h1=findobj(injfig,'tag','amp');
set(h1,'String',1);
h1=findobj(injfig,'tag','setknob');
set(h1,'Userdata',mrad);

%==========================================================
case 'ResetBump'                             %...ResetBump
%==========================================================
h1=findobj(injfig,'tag','setknob');
mrad=get(h1,'Userdata');
h1=findobj(injfig,'tag','scale');
set(h1,'Value',1);
h1=findobj(injfig,'tag','amp');
set(h1,'String',1);

for ii=1:3
h1=findobj(injfig,'tag',['k' num2str(ii) 'Slide']);
%set(h1,'Value',mrad(ii));
h1=findobj(injfig,'tag',['k' num2str(ii)]);
%set(h1,'String',num2str(mrad(ii)));=
end

simgui('ScaleBump');

%==========================================================
case 'ScaleBump'                           %...ScaleBump
%==========================================================
%get kicker strengths
scale=get(findobj(injfig,'tag','scale'),'Value');
set(findobj(injfig,'tag','amp'),'String',num2str(scale));

%get kicker strengths
h1=findobj(injfig,'tag','setknob');
mrad=get(h1,'Userdata');

%update kicks in lattice
setsp('Kicker',mrad);    %watch units

%update sliders and edit boxes
for ii=1:3
h1=findobj(injfig,'tag',['k' num2str(ii) 'Slide']);
set(h1,'Value',mrad(ii)*scale);
h1=findobj(injfig,'tag',['k' num2str(ii)]);
set(h1,'String',num2str(mrad(ii)*scale));
end

simgui('Update');

%==========================================================
case 'SetKick'                             %...SetKick
%==========================================================
name=varargin(1);
tag=name{:};
%disp(tag);
%update display box
h1=findobj(injfig,'tag',[tag 'Slide']);
val=get(h1,'Value');
h1=findobj(injfig,'tag',tag);
set(h1,'String',num2str(val));

ATindex=ATIndex(THERING);  %AT index structure

%update lattice
corindx = ATindex.COR;
kickindx=[ATindex.K1; ATindex.K2; ATindex.K3];;

if tag(1)=='c' ii=corindx(str2num(tag(2)));  end
if tag(1)=='k' ii=kickindx(1); end

setsp('KickerAmp',val);
simgui('Update')

%============================================================
case 'Update'
%============================================================
%update trajectory
torb=[0 0 0 0 0 0]';          % initialize
orb=torb;
% for jj=1:length(THERING)                      
%    T{1}=THERING{jj};
%    torb=RingPass(T,torb);          %temporary, can be vectorized
%    orb=[orb torb];
% end
orb = LINEPASS(THERING,torb,1:length(THERING));
  
%update plot
set(injfig,'currentaxes',ah.bpm)
set(ah.bpm,'Color',[1 1 1],'NextPlot','add');
set(lh.sim,'XData',findspos(THERING,imin:imax));
set(lh.sim,'LineWidth',1.0,'YData',1000*orb(1,imin:imax)');


indx = FINDCELLS(FAMLIST, 'FamName', ['KICK' num2str(2)]);
kickindx=FAMLIST{indx}.KidsList';

xsept=orb(1,kickindx(1)+2)*1000.0;
h1=findobj(injfig,'tag','xsept');
set(h1,'String',num2str(xsept));


%===========================================================
otherwise
disp('Warning: no CASE found in simgui');
disp(action);
end  %end switchyard


