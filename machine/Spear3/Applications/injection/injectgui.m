%=============================================================
function varargout = maingui(action, varargin)
%=============================================================
%  maingui contains routines to set up the main orbit control panel
%  for the 'orbit' program
global  THERING
injectfig = findobj(0,'tag','injectfig');   %injectfig "global"
ah.bpm=findobj(injectfig,'tag','ahbpm'); %handle for bpm display axes
lh.sim=findobj(injectfig,'tag','simorb'); %handle for fit orbit plot

switch action

%==========================================================
case 'InjectFig'                               %InjectFig
%==========================================================

[screen_wide, screen_high]=screensizecm;

fig_start = [0.13*screen_wide 0.16*screen_high];
fig_start = [0.1*screen_wide 0.1*screen_high];
fig_size = [0.78125*screen_wide 0.78125*screen_high];
fig_size = [0.8125*screen_wide 0.8*screen_high];

%%%
injectfig = figure('Visible','off',...
		'units','centimeters',...
		'tag','injectfig',... 
		'NumberTitle','off',...
        'Doublebuffer','on',...
		'Name','Injection Control Interface',...
		'PaperPositionMode','Auto');
set(injectfig,'MenuBar','None');
set(injectfig,'Position',[fig_start fig_size],'Visible','on','MenuBar','none');

%set(injectfig,'Pointer','arrow',...
%   'WindowButtonDownFcn','inj_maingui(''ShowPos'')');


%==========================================================
case 'ShowPos'                               %ShowPos
%==========================================================
cpa = get(ah.bpm,'CurrentPoint')

%==========================================================
case 'InjectAxes'                               %InjectAxes
%==========================================================
%InjectAxes to plot simulated injection bump
[screen_wide, screen_high]=screensizecm;

x0=0.08*screen_wide ; dx=0.35*screen_wide; y0=0.5*screen_high; dy=0.25*screen_high;
ah.bpm = axes('Units','centimeters',...
	          'tag', 'ahbpm', ...
	          'Color', [1 1 1], ...
              'Box','on','YGrid','on',...
              'NextPlot','add',...
	          'Position',[x0 y0 dx dy]);

set(get(ah.bpm,'Ylabel'),'string','Displacement (mm)');  %handle for xlabel
set(get(ah.bpm,'Xlabel'),'string','Position in Storage Ring (m)');
set(ah.bpm,'YLim',[-30,30]);


%==========================================================
case 'UIControls'                           %  UIControls
%==========================================================
[screen_wide, screen_high]=screensizecm;
x0=0.10*screen_wide ; dx=0.05*screen_wide; y0=0.3*screen_high; dy=0.025*screen_high; dely=0.03*screen_high;

%Set Knob and Reset
uicontrol('Style','PushButton',...
		'units', 'centimeters', ...
        'Position',[x0+0.20*screen_wide,y0-3*dely,2*dx,dy],...
        'HorizontalAlignment','center','Tag','setknob','String','Set Knob',...
        'UserData',[0 0 0],'Callback','simgui(''SetKnob'')');
    
uicontrol('Style','PushButton',...
		'units', 'centimeters', ...
        'Position',[x0+0.20*screen_wide,y0-4*dely,2*dx,dy],...
        'HorizontalAlignment','center','String','Reset Bump',...
        'Callback','simgui(''ResetBump'')');
    

%Amplitude
uicontrol('Style','text',...
		'units', 'centimeters', ...
        'Position',[x0,                 y0-3*dely,dx,dy],...
        'HorizontalAlignment','center','String','Amp');
uicontrol('Style','edit','units', 'centimeters', ...
        'Position',[x0+0.08*screen_wide,y0-3*dely,dx,dy],'tag','Amp','String',num2str(1));                 
 sh.scal=uicontrol('Style','slider','units', 'centimeters',...
        'Position',[x0+0.15*screen_wide,y0-3*dely,3*dx,dy],...
        'Min',0,'Max',2,'tag','scale','Value',1,...
        'SliderStep',[0.01,0.02],'Callback','simgui(''ScaleBump'')');
    
    
%K1
uicontrol('Style','text','units', 'centimeters', ...
        'Position',[x0,y0,dx,dy],...
        'HorizontalAlignment','center','String','K1');
uicontrol('Style','edit',...
		'units', 'centimeters', ...
        'Position',[x0+0.08*screen_wide,y0,dx,dy],'tag','k1','String',num2str(0));                 
sh.k1=uicontrol('Style','slider',...
        'units', 'centimeters', 'Position',[x0+0.15*screen_wide,y0,3*dx,dy],...
        'Min',-3,'Max',3,'tag','k1Slide','Value',0,...
        'SliderStep',[0.001,0.002],'Callback','simgui(''SetKick'',''k1'')');


%K2
uicontrol('Style','text',...
		'units', 'centimeters', ...
        'Position',[x0,                 y0+dely,dx,dy],...
        'HorizontalAlignment','center','String','K2');
uicontrol('Style','edit',...
		'units', 'centimeters', ...
        'Position',[x0+0.08*screen_wide,y0+dely,dx,dy],'tag','k2','String',num2str(0)); 
sh.k2=uicontrol('Style','slider',...
        'units', 'centimeters','Position',[x0+0.15*screen_wide,y0+dely,3*dx,dy], ...
        'Min',-3,'Max',3,'tag','k2Slide','Value',0,...
        'SliderStep',[0.001,0.002],'Callback','simgui(''SetKick'',''k2'')');


%K3
uicontrol('Style','text',...
		'units', 'centimeters','Position',[x0,y0+2*dely,dx,dy],...
        'HorizontalAlignment','center','String','K3');
uicontrol('Style','edit','units', 'centimeters', ...
        'Position',[x0+0.08*screen_wide,y0+2*dely,dx,dy],'tag','k3','String',num2str(0));      
sh.k3=uicontrol('Style','slider',...
	    'units', 'centimeters','Position',[x0+0.15*screen_wide,y0+2*dely,3*dx,dy], ...
        'Min',-3,'Max',3,'tag','k3Slide','Value',0,...
        'SliderStep',[0.001,0.002],'Callback','simgui(''SetKick'',''k3'')');


    
    
%Phase Space Controls
uicontrol('Style','text',...
		'units', 'centimeters', ...
        'Position',[x0+0.4*screen_wide,y0+2*dely,2*dx,dy],...
        'HorizontalAlignment','center','String','emittance');
uicontrol('Style','edit',...
		'units', 'centimeters', ...
        'Position',[x0+0.5*screen_wide,y0+2*dely,dx,dy],'tag','emit','String',num2str(0));  
    
  
    
uicontrol('Style','text',...
		'units', 'centimeters', ...
        'Position',[x0+0.4*screen_wide,y0+1*dely,2*dx,dy],...
        'HorizontalAlignment','center','String','x-peak');
   uicontrol('Style','edit',...
		'units', 'centimeters', ...
        'Position',[x0+0.5*screen_wide,y0+1*dely,dx,dy],'tag','xpeak','String',num2str(0)); 





uicontrol('Style','text',...
		'units', 'centimeters', ...
        'Position',[x0+0.4*screen_wide,y0+0*dely,2*dx,dy],...
        'HorizontalAlignment','center','String','x-septum');
uicontrol('Style','edit',...
     	'units', 'centimeters', ...
        'Position',[x0+0.5*screen_wide,y0+0*dely,dx,dy],'tag','xsept','String',num2str(0));
    
uicontrol('Style','text',...
   	  'units', 'centimeters', ...
	  'Position',[x0+0.4*screen_wide, y0-dely,2*dx,dy],...
      'HorizontalAlignment','center','String','septum bpm');
uicontrol('Style','edit',...
   	  'units', 'centimeters', ...
      'Position',[x0+0.5*screen_wide,y0-dely,dx,dy],'tag','septbpm','String',num2str(0),...
      'Callback','inj_maingui(''SeptBPM'')'); 


uicontrol('Style','PushButton',...
		'units', 'centimeters', ...
        'Position',[x0+0.5*screen_wide,y0-3*dely,3*dx,dy],...
        'HorizontalAlignment','center','String','phase space',...
        'Callback','simgui(''PhaseSpace'');');        

%==========================================================
case 'SeptBPM'                           %  SeptBPM
%==========================================================
%first zero out DC correctors
icor = getfield(FAMLIST{2}.KidsList);
kickindex = icor([11 12 13 14]);
for kk=1:length(kickindex)
  k=kickindex(kk);
	THERING{k}=setfield(THERING{k},'Strength',[0 0]); %set in mrad
end            

%fit 3-bump
val=str2num(get(findobj(injectfig,'tag','septbpm'),'String'));  %bpm offset  
set(findobj(injectfig,'tag','b16'),'Ydata',val);  %move bpm
val = val/1000;   %convert to mm

kickindex = [];
for kickfam=4:6
kickindex=[kickindex getfield(FAMLIST{kickfam}.KidsList)];
end
start_vec=[2 -1 2];   %initial guess at kicker amplitudes

bpmindx = getfield(FAMLIST{7}.KidsList);
ibpm=bpmindx([16 26 27]); %three bpms for constraint
expected=[val 0 0];       %expected orbit

region=[min([kickindex ibpm]) max([kickindex ibpm])];  
%jellyfish(start_vec,kickindex,expected,region,ibpm,kickindex);	
disp(['Fitting kickers for septum displacement... '...
num2str(expected(1)) ' m']);

[mrad min_val] = fminsearch('jellyfish',start_vec,...
  	optimset('TolX',1e-3,'Display','off'),kickindex,expected,...
   region,ibpm,kickindex);				%fit!
disp(['Final kicker values... ' num2str(mrad)]);

%update sliders and edit boxes
for ii=1:3
h1=findobj(injectfig,'tag',['k' num2str(ii) 'Slide']);
set(h1,'Value',mrad(ii));
h1=findobj(injectfig,'tag',['k' num2str(ii)]);
set(h1,'String',num2str(mrad(ii)));
end
set(findobj(injectfig,'tag','amp'),'String',num2str(1));
set(findobj(injectfig,'tag','scale'),'Value',1);
simgui('Update');
pause(1);

%now use four correctors to correct angle at septum
%same region covers both ac and dc bumps
kickindex = icor([11 12 13 14]); %FOUR DC correctors
ibpm=bpmindx([16 17 26 27]); %FOUR bpms for constraint
expected=[val val 0 0]; %value across septum remains the same: val
%corrector indices established above (initialized to zero)

disp(['Fitting correctors to level beam at septum ... ' num2str(expected(1)) ' m']);
mrad=[ ];  start_vec=[.2 .2 .2 .2];
[mrad min_val] = fminsearch('jellyfish',start_vec,...
  	optimset('TolX',1e-3,'Display','off'),kickindex,expected,...
   region,ibpm,kickindex)				%fit!
disp('Finished 4-corrector fit');
simgui('Update');


%==========================================================
case 'PlotIcons'                              %  PlotIcons
%==========================================================
%draw icons for bpms and kickers

ATindex=ATIndex(THERING);  %AT index structure

spos=getspos('BPMx');      %BPM positions (from Middle Layer)

nbpm=30;
for kk=1:nbpm 
line('parent',ah.bpm,'tag', ['b' num2str(kk)],...
'XData',spos(kk),'YData',0,...
'Marker','o','MarkerSize',6,'MarkerFaceColor','g');
end


kickindex=[ATindex.K1; ATindex.K2; ATindex.K3];
spos=findspos(THERING,kickindex);   %Kicker positions (from AT)

for ii=1:length(kickindex)        %load kicker lengths
len(ii)=THERING{kickindex(ii)}.Length;
end

for ii=1:length(kickindex)         %plot kicker icons
patch('parent',ah.bpm,'tag',['ki' num2str(ii)],...
      'XData',[spos(ii) spos(ii)+len(ii) spos(ii)+len(ii) spos(ii)],...
	  'YData',[5 5 -5 -5],'FaceColor','w');
end    

%=========================================
otherwise
disp('Warning: no CASE found in injectgui');
disp(action);
end  %end switchyard


