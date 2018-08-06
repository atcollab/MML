%=============================================================
function varargout = orbgui(action, varargin)
%=============================================================
%  orbgui contains routines to set up the main orbit control panel
%  for the 'orbit' program
%'case' routines contained in orbgui switchyard are:
%...OrbFig//BPMAxes//CorAxes//SVDAxes
%...Menus//UIControls//Sliders
%...BPMBox
%...CorBox
%...SVDBox
%...Plane//Relative
%...StartLoc/NewStart/StopLoc/NewStop/

%graphics handles

%globals
global BPM BL COR RSP SYS
orbfig = findobj(0,'tag','orbfig');

plane=SYS.plane;

switch action

%==========================================================
case 'OrbFig'                               %OrbFig
%==========================================================
%orbfig sets up the main figure for the Orbit program.
%orbit and corrector plots, uicontrols and uimenus fit into orbfig.
%to print graphics activate menubar
%PaperPosition sets orientation of figure on print page

%screen size call. If width/height > 2 assume two screens.
[screen_wide, screen_high]=screensizecm;
if screen_wide/screen_high > 2
    screen_wide = screen_wide/2;
end

fig_start = [0.13*screen_wide 0.16*screen_high];
fig_start = [0.1*screen_wide 0.1*screen_high];
fig_size = [0.78125*screen_wide 0.78125*screen_high];
fig_size = [0.8125*screen_wide 0.8*screen_high];
SYS.handles.orbfig = figure('Visible','off',...
		'units','centimeters',...
		'NumberTitle','off',...
        'Doublebuffer','on',...
        'Tag','orbfig',...
		'Name','Orbit Control Interface',...
		'PaperPositionMode','Auto');

set(SYS.handles.orbfig,'MenuBar','None');
set(SYS.handles.orbfig,'Position',[fig_start fig_size]);
set(SYS.handles.orbfig,'Visible','on');
set(SYS.handles.orbfig,'Resize','off');
set(SYS.handles.orbfig,'CloseRequestFcn',['global SYS;' 'SYS.plane=1;' 'orbgui(''CloseMainFigure'');']);
%set(SYS.handles.orbfig,'DeleteFcn',['st=fclose(''all'');' 'CloseCAQuery'],'Resize','off');

%==========================================================
case 'Axes_1'                               %Axes_1
%==========================================================
%Establish top axes

[screen_wide, screen_high]=screensizecm; 
if screen_wide/screen_high > 2
    screen_wide = screen_wide/2;
end

x0=0.0478*screen_wide; y0=0.5*screen_high; dx=0.7383*screen_wide; dy=0.2*screen_high;

SYS.handles.ah1 = axes('Units','centimeters',...
    'Color', [1 1 1], ...
    'Box','on',...
    'YGrid','on',...
    'Position',[x0 y0 dx dy]);

set(SYS.handles.ah1,'xticklabelmode','manual');
set(SYS.handles.ah1,'xticklabel',[]);
varargout{1}=SYS.handles.ah1;

%==========================================================
case 'BPMAxes'                               %BPMAxes
%==========================================================
%BPMAxes is the axes to plot: reference, desired, actual, predicted
%columns of response matrix and svd orbit eigenvectors (columns of U: R=UWVt)
%need NextPlot add to prevent PLOT from resetting fields to default (incl tag)
%DrawMode

set(SYS.handles.ah1,'NextPlot','add');
set(SYS.handles.ah1,'ButtonDownFcn','bpmgui(''BPMSelect'')');
set(SYS.handles.ah1,'xticklabelmode','manual');
set(SYS.handles.ah1,'xticklabel',[]);

label=['BPM Value  (',  getfamilydata('BPMx','Monitor','HWUnits'), ')'];

set(get(SYS.handles.ah1,'Ylabel'),'string',label);  %handle for xlabel
  
%==========================================================
case 'ZoomAxes'                                   %ZoomAxes
%==========================================================
%Position Axes is for slider that controls zoom of display windows

[screen_wide, screen_high]=screensizecm;
if screen_wide/screen_high > 2
    screen_wide = screen_wide/2;
end

x0=0.0478*screen_wide; y0=0.473*screen_high; dx=0.7383*screen_wide; dy=0.025*screen_high;

SYS.handles.ahpos = axes('Units','centimeters',...
    'Color', [1 1 1],...
    'Box','on',...
    'Position',[x0 y0 dx dy],...
    'xticklabelmode','manual',...
    'yticklabelmode','manual',...
    'xtickmode','manual','xtick',[],...
    'ytickmode','manual','ytick',[],...
    'Xlim',[0 1],...
    'Ylim',[0 1]);

setappdata(0,'SYS',SYS);

%==========================================================
case 'ZoomPatches'                             %ZoomPatches
%==========================================================
%create patch for start of horizontal axes scale
SYS.handles.startpatch=patch('parent',SYS.handles.ahpos,...
    'XData',[0 0.01 0],...
    'YData',[0 0.5 1],...
    'Tag','startpatch',...
    'ButtonDownFcn','orbgui(''StartPatchActive'')',...
    'FaceColor',[0.8 0 0.8]);
%     'vertices',vert,...

%create patch for stop of horizontal axes scale
SYS.handles.stoppatch=patch('parent',SYS.handles.ahpos,...
    'XData',[1 0.99 1],...
    'YData',[0 0.5 1],...
    'Tag','stoppatch',...
    'ButtonDownFcn','orbgui(''StopPatchActive'')',...
    'FaceColor',[0.8 0 0.8]);

setappdata(0,'SYS',SYS);

%==========================================================
case 'CorAxes'                               %CorAxes
%==========================================================
%CorAxes are the axes to plot: actual, fit correctors
%and svd corrector eigenvectors (columns of V: R=UWVt)

[screen_wide, screen_high]=screensizecm;
if screen_wide/screen_high > 2
    screen_wide = screen_wide/2;
end

x0=0.0478*screen_wide; y0=0.27*screen_high; dx=0.7383*screen_wide; dy=0.2*screen_high;

SYS.handles.ahcor = axes('Units','centimeters',...
    'NextPlot','add',...
    'Color', [1 1 1], ...
    'Box','on',...
    'YGrid','on',...
    'Position',[x0 y0 dx dy],...
    'ButtonDownFcn','corgui(''CorSelect'')');

label=['Corrector Value  (',  getfamilydata('HCM','Setpoint','HWUnits'), ')'];

set(get(SYS.handles.ahcor,'Ylabel'),'string',label);  %handle for xlabel
set(get(SYS.handles.ahcor,'Xlabel'),'string','Position in Storage Ring (m)');
  
setappdata(0,'SYS',SYS);

%==========================================================
case 'MachineParameters'              %...MachineParameters
%==========================================================
%Create field boxes to display beam energy and current
[screen_wide, screen_high]=screensizecm;
if screen_wide/screen_high > 2
    screen_wide = screen_wide/2;
end

% x0=0.046*screen_wide; x02=0.12*screen_wide;     dx=0.07*screen_wide;
% y0=0.706*screen_high; dy=0.02*screen_high;
 

x0=0.43*screen_wide; y0=0.76*screen_high; dx=0.06*screen_wide; dy=0.02*screen_high;

uicontrol('Style','text',...                            %Current Text
    'units', 'centimeters','Position',[x0+0*dx y0 dx dy],...
    'HorizontalAlignment','right',...
    'ToolTipString','Electron Beam Current (Amperes)',...
    'String','Current  (mA):');

SYS.handles.current=uicontrol('Style','PushButton',...  %Current Display
	'units', 'centimeters','Position',[x0+1.1*dx y0+0.005*screen_high dx/1.5 dy],...
    'BackGroundColor',[0.77 0.91 1.00],...
    'ToolTipString','Electron Beam Current (Amperes)',...	
    'CallBack','orbgui(''UpdateParameters'')',...
	'String',num2str(SYS.curr, '%6.1f'));

uicontrol('Style','text',...                           %Energy Text
    'units', 'centimeters','Position',[x0+0*dx y0-dy dx dy],...
    'HorizontalAlignment','right',...
    'ToolTipString','Electron Beam Energy (GeV)',...	
    'String','Energy (GeV):');

SYS.handles.energy=uicontrol('Style','PushButton',...   %Energy Display
    'units', 'centimeters','Position',[x0+1.1*dx y0-dy+0.005*screen_high dx/1.5 dy],...
    'BackGroundColor',[0.77 0.91 1.00],...
    'ToolTipString','Electron Beam Energy (GeV)',...
    'CallBack','orbgui(''UpdateParameters'')',...
    'String',num2str(SYS.engy, '%6.1f'));                


uicontrol('Style','text',...                            %Lifetime Text
    'units', 'centimeters','Position',[x0+2.1*dx y0 dx dy],...
    'HorizontalAlignment','right',...
    'ToolTipString','Electron Beam Lifetime (hr)',...
    'String','Lifetime  (hr):');

SYS.handles.lifetime=uicontrol('Style','PushButton',... %Lifetime Display
	'units', 'centimeters','Position',[x0+3.2*dx y0+0.005*screen_high dx/1.5 dy],...
    'BackGroundColor',[0.77 0.91 1.00],...
    'ToolTipString','Electron Beam Lifetime (hr)',...
    'CallBack','orbgui(''UpdateParameters'')',...
	'String',num2str(SYS.lt, '%6.3f')); 

uicontrol('Style','text',...                            %Amp-hr Text
    'units', 'centimeters','Position',[x0+2.1*dx y0-dy dx dy],...
    'HorizontalAlignment','right',...
    'ToolTipString','Electron beam amp-hours',...
    'String','Amp-hr:');

SYS.handles.amphr=uicontrol('Style','PushButton',...     %Amp-hr Display
	'units', 'centimeters','Position',[x0+3.2*dx y0-dy+0.005*screen_high dx/1.5 dy],...
    'BackGroundColor',[0.77 0.91 1.00],...
    'ToolTipString','Electron beam amp-hours',...
    'CallBack','orbgui(''UpdateParameters'')',...
	'String',num2str(SYS.ahr, '%6.3f'));                

setappdata(0,'SYS',SYS);

%==========================================================
case 'UpdateParameters'              %...UpdateParameters
%==========================================================
%Update field boxes that display machine parameters

if strcmp(SYS.machine,'SPEAR3') & strcmpi(getfamilydata('HCM','Monitor','Mode'),'ONLINE')
[SYS.beam, SYS.engy,SYS.curr,SYS.lt,SYS.ahr]=GetSPEAR3Params(SYS.mode);
elseif strcmp(SYS.machine,'AnotherMachine')
end
setappdata(0,'SYS',SYS);

set(SYS.handles.energy,  'String',num2str(SYS.engy, '%6.1f'));
set(SYS.handles.current, 'String',num2str(SYS.curr, '%6.1f'));
set(SYS.handles.lifetime,'String',num2str(SYS.lt,   '%6.3f'));
set(SYS.handles.amphr,   'String',num2str(SYS.ahr,  '%6.3f'));

%==========================================================
case 'SVDAxes'                               %SVDAxes
%==========================================================
%SVDAxes are the axes to plot singular value spectrum/logarithmic

%screen size call
[screen_wide, screen_high]=screensizecm;
if screen_wide/screen_high > 2
    screen_wide = screen_wide/2;
end

x0=0.6*screen_wide; dx=0.19*screen_wide; y0=0.0495*screen_high; dy=0.14*screen_high;

SYS.handles.ahsvd = axes('Units','centimeters','YScale','log','NextPlot','add','Color', [1 1 1],'Box','on','Position',[x0 y0 dx dy]);

setappdata(0,'SYS',SYS);

set(get(SYS.handles.ahsvd,'Ylabel'),'string','Singular Value');
set(get(SYS.handles.ahsvd,'Xlabel'),'string','Singular Value Index');  

%==========================================================
case 'PlotMenu'                               %  PlotMenu
%==========================================================
%*** PLOT MENU ***
mh.plot = uimenu('Label','Plot    ');
uimenu(mh.plot,'Label','BPM Plot Scale',                'Callback','orbgui(''BPMPlotScale'')');
uimenu(mh.plot,'Label','Corrector Plot Scale',          'Callback','orbgui(''CorPlotScale'')');

%==========================================================
case 'BPMMenu'                               %  BPMMenu
%==========================================================
%*** BPM MENU ***
mh.bpms = uimenu('Label','BPMs');
uimenu(mh.bpms,'Label','Select All BPMs','Callback','bpmgui(''SelectAll'');');
uimenu(mh.bpms,'Label','Select No BPMs','Callback','bpmgui(''SelectNone'');');
uimenu(mh.bpms,'Label','Remove BPM Drag Changes','Callback','bpmgui(''ClearOffsets'');');
uimenu(mh.bpms,'Label','Show BPM State','Callback','bpmgui(''ShowBPMState'');');
uimenu(mh.bpms,'Label','     ');
uimenu(mh.bpms,'Label','Archive X/Y-Orbit',        'Callback','readwrite(''ArchiveBPMOrbit'',''B'');');
uimenu(mh.bpms,'Label','     ');
uimenu(mh.bpms,'Label','Load X/Y-Reference Orbit', 'Callback','readwrite(''ReadBPMReference'',''B'');');
uimenu(mh.bpms,'Label','     ');
uimenu(mh.bpms,'Label','Archive Golden X/Y-Orbit', 'Callback','readwrite(''ArchiveBPMOrbit'',''B'',''Golden'');');
uimenu(mh.bpms,'Label','     ');
uimenu(mh.bpms,'Label','Load Golden X/Y-Reference','Callback','readwrite(''ReadBPMReference'',''B'',''Golden'');');
uimenu(mh.bpms,'Label','     ');

%Select horizontal BPM weights
cback=['rload(''GenFig'', BPM(1).name,BPM(1).avail,BPM(1).ifit,BPM(1).wt,'];
cback=[cback '''Horizontal BPM Weights'',''xbwt'');'];
%instructions are used during 'load' procedure of rload window
instructions=[...
'   global BPM;',...
'   tlist = get(gcf,''UserData'');',...    
'   BPM(1).wt=tlist{4};',...
'   setappdata(0,''BPM'',BPM);',...
'   orbgui(''RefreshOrbGUI'');'];
uimenu(mh.bpms,'Label','Select X-BPM Weights','Callback',cback,'Tag','xbwt','Userdata',instructions);

%Select vertical BPM weights
cback=['rload(''GenFig'', BPM(2).name,BPM(2).avail,BPM(2).ifit,BPM(2).wt,'];
cback=[cback '''Vertical BPM Weights'',''ybwt'');'];
%instructions are used during 'load' procedure of rload window
instructions=[...
'   global BPM;',...
'   tlist = get(gcf,''UserData'');',...    
'   BPM(2).wt=tlist{4};',...
'   setappdata(0,''BPM'',BPM);',...
'   orbgui(''RefreshOrbGUI'');'];

uimenu(mh.bpms,'Label','Select Y-BPM Weights','Callback',cback,'Tag','ybwt','Userdata',instructions);
uimenu(mh.bpms,'Label','   ');

%uimenu(mh.bpms,'Label','Refresh Calibration', 'Callback','orbgui(''RefreshCalibration'');');               %Refresh Calibration

uimenu(mh.bpms,'Label','   ');
uimenu(mh.bpms,'Label','Help with BPM Functions','Callback','readwrite(''OpenHelp'');');

%==========================================================
case 'CORMenu'                               %  CORMenu
%==========================================================
%*** CORRECTOR MENU ***
mh.cors = uimenu('Label','Correctors');
uimenu(mh.cors,'Label','Update Correctors','Callback','corgui(''UpdateCorrs'');');
uimenu(mh.cors,'Label','    ');
uimenu(mh.cors,'Label','Select All Correctors','Callback','corgui(''SelectAll'');');
uimenu(mh.cors,'Label','Select No Correctors','Callback','corgui(''SelectNone'');');
uimenu(mh.cors,'Label','     ');

%Select horizontal corrector weights
cback=['rload(''GenFig'', COR(1).name,COR(1).status,COR(1).ifit,COR(1).wt,'];
cback=[cback '''Horizontal Corrector Weights'',''xcwt'');'];
%instructions are used during 'load' procedure of rload window
instructions=[...
'   global COR;',...
'   tlist = get(gcf,''UserData'');',...    
'   COR(1).wt=tlist{4};',...
'   setappdata(0,''COR'',COR);',...
'   orbgui(''RefreshOrbGUI'');'];

uimenu(mh.cors,'Label','Select X-Corrector Weights','Callback',cback,'Tag','xcwt','Userdata',instructions);
uimenu(mh.cors,'Label','    ');

%Select vertical corrector weights
cback=['rload(''GenFig'', COR(2).name,COR(2).status,COR(2).ifit,COR(2).wt,'];
cback=[cback '''Vertical Corrector Weights'',''ycwt'');'];
%instructions are used during 'load' procedure of rload window
instructions=[...
'   global COR;',...
'   tlist = get(gcf,''UserData'');',...    
'   COR(2).wt=tlist{4};',...
'   setappdata(0,''COR'',COR);',...
'   orbgui(''RefreshOrbGUI'');'];

uimenu(mh.cors,'Label','Select Y-Corrector Weights','Callback',cback,'Tag','ycwt','Userdata',instructions);
uimenu(mh.cors,'Label','    ');
uimenu(mh.cors,'Label','Show Corrector State','Callback','corgui(''ShowCORState'');');
uimenu(mh.cors,'Label','Help with Corrector Functions','Callback','readwrite(''OpenHelp'');');

%==========================================================
case 'BLMenu'                               %  BLMenu
%==========================================================
%*** BEAMLINE MENU ***
mh.bline = uimenu('Label','Beamlines');
cback=['toggle(''GenFig'',BL(2).name,BL(2).open,BL(2).avail,'];
cback=[cback 'BL(2).ifit,''Vertical Photon BPMs in Correction'',''blsel'');'];
%instructions are used during 'load' procedure of toggle window
instructions=[...
'   global BL RSP;',...
'   tlist = get(gcf,''UserData'');',...    
'   BL(2).ifit=tlist{4};',...
'   [BL]=SortBLs(BL,RSP);',...
'   setappdata(0,''BL'',BL);',...
'   orbgui(''RefreshOrbGUI'');'];
uimenu(mh.bline,'Label','Select Beam Lines','Callback',cback,'Tag','blsel','Userdata',instructions);

%Select vertical photon BPM weights
cback=['rload(''GenFig'', BL(2).name,BL(2).avail,BL(2).ifit,BL(2).wt,'];
cback=[cback '''Vertical Photon BPM Weights'',''ypwt'');'];
%instructions are used during 'load' procedure of rload window
instructions=[...
'   global BL;',...
'   tlist = get(gcf,''UserData'');',...    
'   BL(2).wt=tlist{4};',...
'   setappdata(0,''BL'',BL);',...
'   orbgui(''RefreshOrbGUI'');'];

uimenu(mh.bline,'Label','Select Y-Photon BPM Weights','Callback',cback,'Tag','ypwt','Userdata',instructions);

%Update Beamlines
cback=['bpmgui(''GetSP2BL'');', 'BL=SortBLs(BL,RSP);'];
uimenu(mh.bline,'Label','Update Photon Beamline Data','Callback',cback);

%==========================================================
case 'OptMenu'                               %  OptMenu
%==========================================================
%*** OPTICS MENU ***
mh.opt = uimenu('Label','Optics');
uimenu(mh.opt,'Label','Display Optics Parameters','Callback','orbgui(''DisplayOptics'')');
uimenu(mh.opt,'Label','Display Optics Parameters in EXCEL','Callback','orbgui(''DisplayOpticsEXCEL'')');
uimenu(mh.opt,'Label','Plot Betafunctions','Callback','orbgui(''PlotBetaFunctions'')');
uimenu(mh.opt,'Label','Plot Ring Elements','Callback','orbgui(''PlotRingElements'')');

%==========================================================
case 'SimMenu'                               %  SimMenu
%==========================================================
% %*** SIMULATION MENU ***
mh.sim = uimenu('Label','Simulator');
uimenu(mh.sim,'Label','New Quad Alignment (both plane)','Callback','orbgui(''QuadOffset'')');
uimenu(mh.sim,'Label','Make New Reference Orbit (this plane)','Callback','orbgui(''MakeNewRef'')');
uimenu(mh.sim,'Label','Corrector strengths to zero (this plane)','Callback','orbgui(''Cor2Zero'')');
uimenu(mh.sim,'Label','Quad alignment to zero (both planes)','Callback','orbgui(''Quad2Zero'')');
uimenu(mh.sim,'Label','Update Optics (LinOpt)','Callback','orbgui(''UpdateOptics'')');
uimenu(mh.sim,'Label','Fit Tunes to 14.19/5.23','Callback','orbgui(''settune'')');

%==========================================================
case 'Cor2Zero'                             %...Quad2Zero
%==========================================================
%Callback of Simulator/'Corrector Strengths to Zero'

%set correctos to zero
if plane==1
  setsp('HCM',0.0);   %only sets correctors with valid status
elseif plane==2
  setsp('VCM',0.0);
end

%orbgui('PlotAlign')
orbgui('RefreshOrbGUI');

%==========================================================
case 'Quad2Zero'                             %...Quad2Zero
%==========================================================
%Callback of Simulator/'Quadrupole Strenths to Zero'

%set quadrupole offsets to zero
quadalign(0.0,0.0);
orbgui('RefreshOrbGUI');

%==========================================================
case 'QuadOffset'                            %...QuadOffset
%==========================================================
%Callback of Simulator/'New Quad Alignment'

%apply quadrupole offsets
quadalign(0.00005,0.00005);  %units are meters
orbgui('RefreshOrbGUI')

%==========================================================
case 'MakeNewRef'                            %...MakeNewRef
%==========================================================
%callback of Simulation 'Make New Reference Orbit'

%record present quad positions for reset
global THERING
AO = getappdata(0,'AcceleratorObjects');

ATindx=[] ;
aofields=fieldnames(AO);
for ii=1:length(aofields)
    if strcmpi(AO.(aofields{ii}).FamilyType,'quad')
        ATindx=[AO.(aofields{ii}).AT.ATIndex];
    end
end
ATindx=unique(ATindx)';

mx0=getcellstruct(THERING,'T1',ATindx,1);
my0=getcellstruct(THERING,'T1',ATindx,3);

%set quads to zero
quadalign(0.0,0.0);  %units are meters

%produce a new random orbit
quadalign(0.00001,0.00001);  %units are meters

%load new reference orbit
bpmgui('GetRef');
BPM(1).des=BPM(1).ref;
BPM(1).abs=BPM(1).ref;
BPM(2).des=BPM(2).ref;
BPM(2).abs=BPM(2).ref;

if SYS.relative==1    %Absolute orbit mode
BPM(1).abs=zeros(size(BPM(1).name,1),1);
BPM(2).abs=zeros(size(BPM(2).name,1),1);
end

setappdata(0,'BPM',BPM);


%put quads back to original position
setshift(ATindx,-mx0,-my0);

orbgui('RefreshOrbGUI');

%==========================================================
case 'PlotAlign'                            %...PlotAlign
%==========================================================
%update graphics after alignments changed
bpmgui('GetRef');
BPM(1).des=BPM(1).ref;
BPM(1).abs=BPM(1).ref;
BPM(2).des=BPM(2).ref;
BPM(2).abs=BPM(2).ref;

if SYS.relative==1
BPM(1).abs=zeros(size(BPM(1).name,1),1);
BPM(2).abs=zeros(size(BPM(2).name,1),1);
end 

setappdata(0,'BPM',BPM);

orbgui('RefreshOrbGUI');

%==========================================================
case 'SetTune'                    %...SetTune
%==========================================================
%set tune back to nominal values
t=getphysdata;
fittune2([t.TUNE.Golden(1),t.TUNE.Golden(2)],'QF','QD');
bpmgui('UpdateAct');

%==========================================================
case 'UpdateOptics'                    %...UpdateOptics
%==========================================================
%recompute linear optics
global THERING
[LinData, Nu, Ksi]=linopt(THERING,0.0,1:length(THERING));
disp(['Nux: ' num2str(Nu(1)) '       Nuy: ' num2str(Nu(2))])

%==========================================================
case 'DisplayOpticsEXCEL'            %...DisplayOpticsEXCEL
%==========================================================
ring2excel

%==========================================================
case 'DisplayOptics'                      %...DisplayOptics
%==========================================================
%Display Optics to command window
global THERING
NR=length(THERING);
orbgui('LBox','Calculating Accelerator Optics...');
optics=gettwiss(THERING,0.0);
orbit=findorbit4(THERING,0.0,1:NR);
orbgui('LBox','Begin Writing Twiss Parameters');
fprintf('%s\n','     index name   length s      betx   alfx   phix   dx     dpx    bety   alfy   phiy   dy     dpy    x      xp     y      yp')
for ii=1:NR
    name =optics.name(ii,:);
    len  =optics.len(ii);
    s    =optics.s(ii);
    betx =optics.betax(ii);
    alfx =optics.alfax(ii);
    phix =optics.phix(ii);
    etax =optics.etax(ii);
    etapx=optics.etapx(ii);

    bety =optics.betay(ii);
    alfy =optics.alfay(ii);
    phiy =optics.phiy(ii);
    etay =optics.etay(ii);
    etapy=optics.etapy(ii);
    
    x=orbit(1,ii);  xp=orbit(2,ii);
    y=orbit(3,ii);  yp=orbit(4,ii);
    
    fprintf('%6d %8s %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n',...
        ii,name,s,len,betx,alfx,phix,etax,etapx,bety,alfy,phiy,etay,etapy,x,xp,y,yp)
   %     'one',1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
end
disp(['Nux: ' num2str(phix) '       Nuy: ' num2str(phiy)])
orbgui('LBox','Finished Writing Twiss Parameters');

%==========================================================
case 'PlotBetaFunctions'               % PlotBetaFunctions
%==========================================================
%plot betafunctions
figure;
plotbeta;

%==========================================================
case 'PlotRingElements'                % PlotRingElements
%==========================================================
%call intlat
intlat;

%==========================================================
case 'RespMenu'                               %  RespMenu
%==========================================================
%response matrix
mh.rsp = uimenu('Label','R-Matrix');
uimenu(mh.rsp,'Label','Read Response Matrix','Callback','readwrite(''ReadResponse'')');

uimenu(mh.rsp,'Label','Write Response Matrix',...
'Callback','readwrite(''DialogBox'',''Write Response Matrix'',''WriteResponse'')');

uimenu(mh.rsp,'Label','    ');
SYS.handles.showeig =uimenu(mh.rsp,'Label','Show Eigenvectors','UserData',0,'Callback','corgui(''ShowEig'')');
SYS.handles.showresp=uimenu(mh.rsp,'Label','Show Response'    ,'UserData',0,'Callback','corgui(''ShowResp'')');

uimenu(mh.rsp,'Label','    ');
%Select corrector currents for horizontal response to eBPMs
cback=['rload(''GenFig'', COR(1).name,COR(1).status,COR(1).ifit,COR(1).ebpm,'];
cback=[cback '''Horizontal Correctors to Electron BPMs'',''hbpm'');'];
%instructions are used during 'load' procedure of rload window
instructions=[...
'   global COR;',...
'   tlist = get(gcf,''UserData'');',...    
'   COR(1).ebpm=tlist{4};',...
'   setappdata(0,''COR'',COR);'];
uimenu(mh.rsp,'Label','Select X-Corrector Strengths (BPM)',...
   'Callback',cback,...
   'Tag','hbpm',...
   'Userdata',instructions);

%Measure Horizontal
uimenu(mh.rsp,'Label','Measure Horizontal to BPMs (all valid correctors)',...
   'Callback','corgui(''MeasureXResp'')');
%==============
%VERTICAL PLANE
%==============
uimenu(mh.rsp,'Label','    ');
%Select corrector currents for vertical response to eBPMs
cback=['rload(''GenFig'', COR(2).name,COR(2).status,COR(2).ifit,COR(2).ebpm,'];
cback=[cback '''Vertical Correctors to Electron BPMs'',''vbpm'');'];
instructions=[...
'   global COR;',...
'   tlist = get(gcf,''UserData'');',...    
'   COR(2).ebpm=tlist{4};',...
'   setappdata(0,''COR'',COR);'];
uimenu(mh.rsp,'Label','Select Y-corrector Strengths (BPM)',...
   'Callback',cback,...
   'Tag','vbpm',...
   'Userdata',instructions);

%Select corrector currents for vertical response to BLs
cback=['rload(''GenFig'', COR(2).name,COR(2).status,COR(2).ifit,COR(2).pbpm,'];
cback=[cback '''Vertical Correctors to Photon BPMs'',''vbl'');'];
instructions=[...
'   global COR;',...
'   tlist = get(gcf,''UserData'');',...    
'   COR(2).BL=tlist{4};',...
'   setappdata(0,''COR'',COR);'];
uimenu(mh.rsp,'Label','Select Y-Corrector Strengths (Beamlines)',...
   'Callback',cback,...
   'Tag','vbl',...
   'Userdata',instructions);

%Measure Vertical
uimenu(mh.rsp,'Label','Measure Vertical to BPMs (all valid correctors)',...
   'Callback','corgui(''MeasureYResp'')');
uimenu(mh.rsp,'Label','Measure Vertical to Beamlines (all valid correctors)',...
   'Callback','corgui(''MeasureYPhotonResp'')');
uimenu(mh.rsp,'Label','    ');

%==========================================================
case 'UIControls'                           %  UIControls
%==========================================================
%pushbuttons located above main orbit display
%other pushbuttons in routines OrbBox, CorBox

[screen_wide, screen_high]=screensizecm;
if screen_wide/screen_high > 2
    screen_wide = screen_wide/2;
end

x0=0.047*screen_wide; y0=0.7318*screen_high; dx=0.74*screen_wide; dy=0.06378*screen_high;
uicontrol('Style','frame',...
	'units', 'centimeters', ...
	'Position',[x0 y0 dx dy]);            %main frame

x0=0.057*screen_wide; y0=0.739*screen_high; dx=0.117*screen_wide; dy=0.021*screen_high;
dely=0.03*screen_high;   delx=0.15*screen_wide;

uicontrol('Style','pushbutton',...	
    'Units', 'centimeters', ...
    'Position', [x0+0*delx y0+1*dely dx dy], ...
    'String','Update Display','FontSize',9,'FontWeight','demi',...
    'ToolTipString','Update Measured Orbit (blue line)',...	
    'Callback','bpmgui(''UpdateAct'')');     %Update Orbit
uicontrol('Style','pushbutton',...  
    'units', 'centimeters', ...
    'Position', [x0+0*delx y0+0*dely dx dy], ...        
    'String','Update Reference','FontSize',9,'FontWeight','demi',...
    'ToolTipString','Update Reference Orbit, both planes (red line)',...	
    'Callback','bpmgui(''UpdateRef'')');        %Update Reference Orbit

if plane==1 val=1; else val=0; end
SYS.handles.xplane=uicontrol('Style','checkbox',...	  
    'Units', 'centimeters', ...
    'Position', [0.25*screen_wide y0+1*dely 0.06*screen_wide dy], ...         
    'String','Horizontal','Value',val,...
    'FontSize',9,'FontWeight','demi',...
    'ToolTipString','Horizontal Display and Control',...
    'Callback','orbgui(''Plane'')');  %Toggle Plane-Horizontal

if plane==2 val=1; else val=0; end
SYS.handles.yplane=uicontrol('Style','checkbox',...	  
    'Units', 'centimeters', ...
    'Position', [0.32*screen_wide y0+1*dely 0.06*screen_wide dy], ...         
    'String','Vertical','Value',val,...
    'FontSize',9,'FontWeight','demi',...
    'ToolTipString','Vertical Display and Control',...
    'Callback','orbgui(''Plane'')');  %Toggle Plane-Vertical

if SYS.relative==1 val=1; else val=0; end
SYS.handles.abs=uicontrol('Style','checkbox','units', 'centimeters', ...
    'Position', [0.25*screen_wide y0+0*dely 0.06*screen_wide dy], ...
    'String','Absolute','FontSize',9,'FontWeight','demi','Value',val,...
    'ToolTipString','Absolute BPM Display',...	
    'Callback','orbgui(''Relative'')');   %Relative/Absolute-Absolute

if SYS.relative==2 val=1; else val=0; end
SYS.handles.rel=uicontrol('Style','checkbox','units', 'centimeters', ...
    'Position', [0.32*screen_wide y0+0*dely 0.06*screen_wide dy], ...
    'String','Relative','FontSize',9,'FontWeight','demi','Value',val,...
    'ToolTipString','Relative BPM Display',...	
    'Callback','orbgui(''Relative'')');   %Relative/Absolute-Relative

uicontrol('Style','pushbutton',...	                      
    'units', 'centimeters','ForeGroundColor','k',...
    'Position', [0.41*screen_wide 0.11*screen_high 0.45*dx dy], ...
    'String','Apply',...
    'ToolTipString','Apply Corrector Solution: Blue Dash Line = Predicted Orbit',...	
    'FontSize',9,'FontWeight','demi',...
    'Callback','corgui(''ApplyCorrection'');');                  %Apply Correction

uicontrol('Style','pushbutton',...	                      
    'units', 'centimeters','ForeGroundColor','k',...
    'Position', [0.47*screen_wide 0.11*screen_high 0.45*dx dy], ...
    'String','Remove',...
    'ToolTipString','Remove Previous Corrector Solution or Feedback Addition',...	
    'FontSize',9,'FontWeight','demi',...
    'Callback','corgui(''RemoveCorrection'');');                 %Remove Correction

uicontrol('Style','pushbutton',...	                             
    'units', 'centimeters','ForeGroundColor','k',...
    'Position', [0.41*screen_wide 0.08*screen_high 0.97*dx dy], ...
    'String','Refresh Fit',...
    'ToolTipString','Acquire Orbit, Correctors, Fit, Refresh all Plots & Fields',...	
    'FontSize',9,'FontWeight','demi',...
    'Callback','orbgui(''RefreshOrbGUI'');');                    %Refresh Fit

x0=0.788*screen_wide; dx=0.015*screen_wide; dy=0.031*screen_high; y0=0.583*screen_high;   
% SYS.handles.BPMScale=uicontrol('Style','slider','Units','centimeters',...
% 	'Position',[x0 y0 dx dy],'Callback','orbgui(''ScaleBPMAxis'');',...
%     'Max',1,'Min',-1,'SliderStep',[5e-011 5e-011],'Value',0);                             %ScaleBPMAxis
SYS.handles.BPMScale=uicontrol('Style','slider','Units','centimeters',...
	'Position',[x0 y0 dx dy],'Callback','disp(''here'')',...
    'Max',1,'Min',-1,'SliderStep',[5e-011 5e-011],'Value',0);                             %ScaleBPMAxis

     uicontrol('Style','pushbutton','Units','centimeters',...
    'ToolTipString','Rescale BPM axes',...	
	'Position',[x0 y0-dy dx dy/2],'Callback','orbgui(''RescaleBPMAxis'');');              %RescaleBPMAxis

y0=0.355*screen_high;
SYS.handles.CORScale=uicontrol('Style','slider','Units','centimeters',...                 
	'Position',[x0 y0 dx dy],'Callback','orbgui(''ScaleCORAxis'');',...
    'Max',1,'Min',-1,'SliderStep',[5e-011 5e-011],'Value',0);                              %ScaleCORAxis

     uicontrol('Style','pushbutton','Units','centimeters',...
    'ToolTipString','Rescale COR axes',...	
	'Position',[x0 y0-dy dx dy/2],'Callback','orbgui(''RescaleCORAxis'');');              %RescaleBPMAxis



setappdata(0,'SYS',SYS);

%==========================================================
case 'BPMbox'                               %  BPMbox
%==========================================================
%BPM Dialog Box
%located at bottom of main frame
[screen_wide, screen_high]=screensizecm;
if screen_wide/screen_high > 2
    screen_wide = screen_wide/2;
end

x0=0.013*screen_wide; dx=0.1640*screen_wide; y0=0.0158*screen_high; dy=0.17*screen_high;
uicontrol('Style','frame','units', 'centimeters','Position',[x0 y0 dx dy]);     %main frame

%Static BPM text fields (labels)
dx2=0.0888*screen_wide; dy2=0.017*screen_high; dely=0.0175*screen_high;

x0=0.7*screen_wide; dx=0.07*screen_wide; y0=0.675*screen_high; 
uicontrol('Style','Frame','Units','centimeters','Position', [x0-0.05 y0-0.05 dx+0.075 dy2+0.075]);  %frame around toggle

SYS.handles.togglebpm=uicontrol('Style','checkbox',...
    'units', 'centimeters', ...
    'Position',[x0 y0 dx dy2],...	
    'String','Toggle BPMs',...
    'ToolTipString','Toggle BPMs between fit (green) and no-fit (yellow)',...	
    'Callback','bpmgui(''ToggleMode'')');     %Radio BPM: Toggle Mode

uicontrol('Style','Frame','Units','centimeters','Position', [x0-0.05 y0-1.1*dely-0.05 dx+0.075 dy2+0.075]);  %frame around drag

SYS.handles.dragbpm=uicontrol('Style','checkbox',...
    'units', 'centimeters', ...
    'Position', [x0 y0-1.1*dely dx dy2], ...
    'String','Drag BPMs',...
    'ToolTipString','Enable BPMs for interactive drag',...	
    'Callback','bpmgui(''DragMode'')');      %Radio BPM: Drag Mode


x0=0.01856*screen_wide; dx=0.0576*screen_wide; y0=0.0247*screen_high; dy=0.01562*screen_high; 
uicontrol('Style','text',...
    'units', 'centimeters',...
    'Position',[x0 y0+1.7*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','BPM weight',...	
    'String','Weight:');

uicontrol('Style','text',...
    'units', 'centimeters',...
    'Position',[x0 y0+2.7*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Predicted Orbit (blue dash line value at BPM site)',...	
    'String','Prediction:');

uicontrol('Style','text',...
    'units', 'centimeters',...
    'Position',[x0 y0+3.7*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Requested orbit (BPM icon value at BPM site)',...	
    'String','Request:');

uicontrol('Style','text',...
    'units', 'centimeters',...
    'Position',[x0 y0+4.7*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Difference between BPM icon and red line at BPM site',...	
    'String','Difference:');

uicontrol('Style','text',...
    'units', 'centimeters',...
    'Position',[x0 y0+6*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Reference orbit (red line value at BPM site)',...	
    'String','Reference:');

uicontrol('Style','text',...
    'units', 'centimeters',...
    'Position',[x0 y0+7*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Measured orbit (blue line value at BPM site)',...	
    'String','Measured:');

uicontrol('Style','text',...
    'units', 'centimeters',...
    'Position',[x0 y0+8*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Selected BPM name',...	
    'String','BPM Name:');

SYS.handles.rftoggle=uicontrol('Style','checkbox',...
    'units', 'centimeters', ...
    'Position', [x0 y0+0.7*dely 2.5*dx dy], ...
    'Callback','respgui(''RFToggle'')','Value',0,...
    'ToolTipString','Toggle for RF frequency fitting',...	
    'String',['                ' '0.0 kHz']);       %display rf offset

uicontrol('Style','text',...
    'units', 'centimeters', ...
    'Position', [x0 y0-0.3*dely dx dy], ...
    'HorizontalAlignment','left',...
    'ToolTipString','RF frequency',...	
    'String','RF frequency: ');       %display rf frequency

%Dynamic BPM text fields (data)
x0=.09647*screen_wide; dx=0.063*screen_wide; y0=0.0247*screen_high; dy=0.0156*screen_high; 
dx2=0.00037*screen_wide; dely=0.0175*screen_high;

SYS.handles.rffrequency=uicontrol('Style','text',...
	'units', 'centimeters',...
	'Position',[x0 y0-0.3*dely dx dy],...
    'FontName','times','FontSize',8,...
	'String','');                 %RF frequency


SYS.handles.bpmfit=uicontrol('Style','text',...
	'units', 'centimeters',...
	'Position',[x0 y0+2.7*dely dx dy],...
    'BackGroundColor',[0.77 0.91 1.00],...
	'String','');                 %BPMfit

SYS.handles.bpmdes=uicontrol('Style','text',...
	'units', 'centimeters',...
	'Position',[x0 y0+3.7*dely dx dy],...
	'BackGroundColor',[0.77 0.91 1.00],...
	'String','');                 %BPMdes

%offset edit box
SYS.handles.bpmedit=uicontrol('Style','edit',...
	'units', 'centimeters',...
	'Position',[x0 y0+4.7*dely dx 1.2*dy],...
    'FontName','times','FontSize',8,...
	'Callback','bpmgui(''EditDesOrb'')',...
	'String','');                 %EditDesOrb

SYS.handles.editbpmweight=uicontrol('Style','edit',...
	'units', 'centimeters',...
	'Position',[x0 y0+1.7*dely dx 1.2*dy],...
    'FontName','times','FontSize',8,...
	'Callback','bpmgui(''EditBPMWeight'')',...
	'String','');                 %EditBPMWeight

SYS.handles.bpmref=uicontrol('Style','text',...
	'units', 'centimeters',...
	'Position',[x0 y0+6*dely dx dy],...
	'BackGroundColor',[0.77 0.91 1.00],...
	'String','');                 %BPMref


SYS.handles.bpmact=uicontrol('Style','text',...
	'units', 'centimeters',...
	'Position',[x0 y0+7*dely dx dy],...
    'BackGroundColor',[0.77 0.91 1.00],...
	'String','');                 %BPMact

SYS.handles.bpmname=uicontrol('Style','text',...
    'units', 'centimeters',...
    'Position',[x0 y0+8*dely dx dy],...
    'BackGroundColor',[0.77 0.91 1.00],...
    'String','');                 %bpmname

%RMS Display
x0=0.055*screen_wide; dx=0.035*screen_wide; y0=0.675*screen_high; dy=0.0175*screen_high;

uicontrol('Style','frame','Units','centimeters','Position',[x0-0.025 y0-0.025 2.2*dx+0.05 dy+0.05]); %frame around RMS

uicontrol('Style','text',...
    'Units','centimeters',...
    'Position',[x0 y0 dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','RMS deviation of actual orbit from desired orbit',...	
    'String',' RMS:');                         %Display RMS value

x0=0.085*screen_wide; dx=0.04*screen_wide;
SYS.handles.bpmrms=uicontrol('Style','text',...
	'units','centimeters',...
	'Position',[x0 y0 dx dy],...
	'String','');                              %RMS dynamic

setappdata(0,'SYS',SYS);

%==========================================================
case 'CorBox'                      % *** CorrectBox ***
%==========================================================
%frame for corrector uicontrols
%located at bottom of main frame
[screen_wide, screen_high]=screensizecm;
if screen_wide/screen_high > 2
    screen_wide = screen_wide/2;
end

x0=0.2*screen_wide; dx=0.1650*screen_wide; y0=0.016*screen_high; dy=0.17*screen_high;
uicontrol('Style','frame','Units','centimeters','Position',[x0 y0 dx dy]);  %main frame

%Static Corrector text fields (labels)
x0=0.21*screen_wide;
dx=0.06*screen_wide; y0=0.025*screen_high; dy=0.015*screen_high; 
dx2=0.1*screen_wide; dy2=0.017*screen_high; dely=0.0175*screen_high;

SYS.handles.rfcortoggle=uicontrol('Style','checkbox',...
    'units', 'centimeters', ...
    'Position', [1*x0 y0+2.8*dely 1.1*dx2 dy], ...
    'String','Remove RF Component',...
    'Callback','respgui(''RFCORToggle'')','Value',1,...
    'ToolTipString','Toggle for RF corrector fitting component');       %rf component in correctors

uicontrol('Style','pushbutton',...	           %Save Correctors
    'Units','centimeters',...
    'Position',[1.1*x0 y0+1.8*dely dx2 dy],...
    'ForeGroundColor','k',...
    'String','Save Correctors',...
    'ToolTipString','Save corrector strengths in active plane',...	
    'Callback','corgui(''SaveCorrs'',SYS.plane);');   %save correctors for bump generation and restore

uicontrol('Style','pushbutton',...	            %Restore Correctors
    'Units','centimeters',...
    'Position',[1.1*x0 y0+0.8*dely dx2 dy],...
    'ForeGroundColor','k',...
    'String','Restore Correctors',...
    'ToolTipString','Restore corrector strengths in active plane',...	
    'Callback','corgui(''RestoreCorrs'');');   %Restore Correctors

uicontrol('Style','pushbutton',...	            %MakeOrbitSlider
    'Units','centimeters',...
    'Position',[1.1*x0 y0-0.2*dely dx2 dy],...
    'ForeGroundColor','k',...
    'String','Make Slider',...
    'ToolTipString','Create Orbit Slider/Save File to Disk',...	
    'Callback','corgui(''MakeOrbitSlider'');'); %MakeOrbitSlider


uicontrol('Style','text',...
    'Units','centimeters',...
    'Position',[x0 y0+4*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Requested corrector strength (red bar at corrector site)',...	
    'String','Request:');   

uicontrol('Style','text',...
    'Units','centimeters',...
    'Position',[x0 y0+5*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Incremental corrector strength (red bar - green bar)',...	
    'String','Fit Increment:');

uicontrol('Style','text',...
    'Units','centimeters',...
    'Position',[x0 y0+6*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Saved corrector value',...	
    'String','Reference:');

uicontrol('Style','text',...
    'Units','centimeters',...
    'Position',[x0 y0+7*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Measured corrector value (green/yellow bar at corrector site)',...	
    'String','Measured:');

uicontrol('Style','text',...
    'Units','centimeters',...
    'Position',[x0 y0+8*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Selected corrector name',...	
    'String','Corr Name:');

%Dynamic corrector text fields (data)
x0=0.28*screen_wide; dx=0.065*screen_wide;      
SYS.handles.correq=uicontrol('Style','text',...
	'units','centimeters',...
	'Position',[x0 y0+4*dely dx dy],...
    'BackGroundColor',[0.77 0.91 1.00],...
	'String','');                 %CORreq

SYS.handles.coroffset=uicontrol('Style','text',...
	'units','centimeters',...
	'Position',[x0 y0+5*dely dx dy],...
    'BackGroundColor',[0.77 0.91 1.00],...
	'String','');                 %CORoffset

SYS.handles.corref=uicontrol('Style','text',...
	'units','centimeters',...
	'Position',[x0 y0+6*dely dx dy],...
    'BackGroundColor',[0.77 0.91 1.00],...
	'String','');                 %CORref

SYS.handles.coract=uicontrol('Style','text',...
	'units','centimeters',...
	'Position',[x0 y0+7*dely dx dy],...
    'BackGroundColor',[0.77 0.91 1.00],...
	'String','');                 %CORact

SYS.handles.corname=uicontrol('Style','text',...
	'units','centimeters',...
	'Position',[x0 y0+8*dely dx dy],...
    'BackGroundColor',[0.77 0.91 1.00],...
	'String','');                 %CORname

x0=0.7*screen_wide; dx=0.07*screen_wide; y0=0.445*screen_high; dy=0.0175*screen_high;
uicontrol('Style','Frame','Units','centimeters','Position', [x0-0.05 y0-0.05 dx+0.075 dy+0.075]);  %frame

SYS.handles.togglecor=uicontrol('Style','checkbox','units', 'centimeters','Position', [x0 y0 dx dy],...
    'String','Toggle Corrs',...
    'ToolTipString','Toggle correctors for fit (green)/nofit (yellow)',...	
    'Callback','corgui(''ToggleCor'')');          %Radio Corr: Toggle


%RMS Display
x0=0.055*screen_wide; y0=0.45*screen_high; dx=0.035*screen_wide; dy=0.013*screen_high;
uicontrol('Style','frame','Units','centimeters','Position',[x0-0.025 y0-0.025 2.2*dx+0.05 dy+0.05]); %frame around RMS

uicontrol('Style','text','Units','centimeters','Position',[x0 y0 dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','RMS value of correctors used for fit',...	
    'String',' RMS:');                             %rms static

uicontrol('Style','frame','Units','centimeters','Position',[x0-0.025 y0-(1.2*dy+0.025) 2.2*dx+0.05 dy+0.05]); %frame around AVG

uicontrol('Style','text','Units','centimeters','Position',[x0 y0-1.2*dy dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Average value of correctors used for fit',...	
    'String',' AVG:');                             %avg static

SYS.handles.corrms=uicontrol('Style','text','units','centimeters','Position',[x0+dx y0    dx dy],'String','');   %rms dynamic
SYS.handles.coravg=uicontrol('Style','text','units','centimeters','Position',[x0+dx y0-1.2*dy dx dy],'String','');   %avg dynamic

setappdata(0,'SYS',SYS);

%==========================================================
case 'SVDBox'                               %  SVDBox
%==========================================================
%SVD Dialog Box
%located at bottom of main frame
[screen_wide, screen_high]=screensizecm;
if screen_wide/screen_high > 2
    screen_wide = screen_wide/2;
end

x0=0.385*screen_wide; dx=0.16*screen_wide; y0=0.0158*screen_high; dy=0.17*screen_high;

uicontrol('Style','frame','Units','centimeters','Position',[x0 y0 dx dy]);     %main frame

x0=0.39*screen_wide; dx=0.09375*screen_wide; y0=0.018*screen_high; dy=0.02*screen_high;
dy2=0.022*screen_high; dely=0.02353*screen_high;

uicontrol('Style','text',...
    'units','centimeters',...
    'Position',[x0 y0+6*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Choose number of singular values for fit',...	
    'String','# Singular Values:');

uicontrol('Style','text',...
    'units','centimeters',...
    'Position',[x0 y0+5*dely dx dy],...
    'HorizontalAlignment','left',...
    'ToolTipString','Fractional multiplier applied to all correctors (but not shown in fit)',...	
    'String','Fraction of Correction:');


x0=0.50*screen_wide; dx=0.032*screen_wide;
default_nsvd=10;  
% Edit box for number of singular values
SYS.handles.svdedit=uicontrol('Style','edit',...
	'Units','centimeters',...
	'Position',[x0+dx/2 y0+6*dely dx/1.5 dy],...
	'Callback','respgui(''SVDEdit'');',...
	'String',num2str(default_nsvd));   %default to one singular value

%Slider for number of singlar values  see %matlab help/slider
SYS.handles.svdslide=uicontrol('Style','slider',...
	'Units','centimeters',...
	'Position',[x0-dx/2 y0+6*dely dx/1.2 dy],...
	'Callback','respgui(''SVDSlider'');',...
    'Max',default_nsvd,'Min',1,...
    'SliderStep',[1/(default_nsvd-1),1/(default_nsvd-1)],...
	'Value',round(default_nsvd/2));

%Edit box for fraction of correction          
SYS.handles.fract=uicontrol('Style','edit',...
	'Units','centimeters',...
	'Position',[x0+dx/2 y0+5*dely dx/1.5 dy],...
	'Callback','corgui(''Fract'');',...
	'String',num2str(1));  

setappdata(0,'SYS',SYS);


%=============================================================
case 'Plane'                             % *** Plane ***
%=============================================================
%Toggle the x/y fitting displays
corgui('HidePlots');        %Note: separate handles for corrector icons in each plane
                            %hide existing icons before switching planes (visible/off)

if     get(SYS.handles.xplane,'Value')==0 & SYS.plane==1     %was in horizontal mode, stay in horizontal
  set(SYS.handles.xplane,'Value',1);
elseif get(SYS.handles.yplane,'Value')==0 & SYS.plane==2     %%was in vertical mode, stay in vertical
  set(SYS.handles.yplane,'Value',1);
elseif get(SYS.handles.yplane,'Value')==1 & SYS.plane==1     %%was in horizontal mode, switch to vertical
  SYS.plane=2;           %horizontal
  set(SYS.handles.xplane,'Value',0);
elseif get(SYS.handles.xplane,'Value')==1 & SYS.plane==2     %%was in vertical mode, switch to horizontal
  SYS.plane=1;           %horizontal
  set(SYS.handles.yplane,'Value',0);
end

setappdata(0,'SYS',SYS);

corgui('ShowPlots');        %visible/on
orbgui('RefreshOrbGUI');

%=============================================================
case 'TogglePlane'                       % *** TogglePlane ***
%=============================================================
%Toggle plane flag
SYS.plane=1+mod(SYS.plane,2);
setappdata(0,'SYS',SYS);

%=============================================================
case 'RefreshOrbGUI'                   % *** RefreshOrbGUI ***
%=============================================================
bpmgui('GetAct');                     % acquire both planes
corgui('GetAct');                     % acquire both planes

respgui('SolveSystem');               % 75 ms in simulator
respgui('UpdateFit');

% Set defaults
set(SYS.handles.togglebpm,'Value',0);                          % default to display only
set(SYS.handles.dragbpm,'Value',0);                            % default to no drag
set(SYS.handles.togglecor,'Value',0);                          % default to no toggle
set(SYS.handles.showresp,'UserData',0);                        % default to no resp display
set(SYS.handles.showeig, 'UserData',0);                        % default to no eig display
set(SYS.handles.rftoggle,'Value',0,'String',['RF control                ' '0.0 kHz']);  % default to no rf orbit subtraction
set(SYS.handles.fract,'String',num2str(COR(plane).fract));

% re-write text fields
if BPM(plane).mode==1 set(SYS.handles.togglebpm,'Value',1); end;     % toggle
if BPM(plane).mode==2 set(SYS.handles.dragbpm,'Value',1); end;       % drag
if COR(plane).mode==1 set(SYS.handles.togglecor,'Value',1); end;     % toggle
if RSP(plane).disp(1:2)=='on'  set(SYS.handles.showresp,'UserData',1); end;
if RSP(plane).eig(1:2) =='on'  set(SYS.handles.showeig, 'UserData',1); end;

if RSP(plane).rfflag ==1  & plane==1
    set(SYS.handles.rftoggle,'Value',RSP(plane).rfflag,'String',['RF control          '  num2str(BPM(plane).drf, '%11.3f') ' ' BPM(plane).disprfUnits]); 
end

% units for bpm and corrector plot abscissa
if strcmp(SYS.xscale,'meter')
SYS.xlimax=SYS.mxs;
elseif strcmp(SYS.xscale,'phase')
SYS.xlimax=SYS.mxphi(plane);
end

setappdata(0,'SYS',SYS);

% plot from start-patch to stop-patch
xd=get(findobj(0,'Tag','startpatch'),'Xdata');    start=xd(1)*SYS.xlimax;
xd=get(findobj(0,'Tag','stoppatch') ,'Xdata');    stop= xd(1)*SYS.xlimax;

% Update BPM Displays (100 ms in simulator)
bpmgui('ClearPlots');            %remove eigenvector, response and fit plots
set(SYS.handles.ahbpm,'XLim',[start stop]); 
if BPM(plane).scalemode==0                         %manual
set(SYS.handles.ahbpm,'YLim',[-BPM(plane).ylim,BPM(plane).ylim]);   
end
bpmgui('RePlot');                %ref, des, act, fit, icons, limits, bar
bpmgui('UpdateBPMBox');

% Update Corrector Displays (100 ms in simulator)
set(SYS.handles.ahcor,'Xlim',[start stop]);
if COR(plane).scalemode==0     %manual
set(SYS.handles.ahcor,'YLim',[-COR(plane).ylim,COR(plane).ylim]);   end
corgui('RePlot');                %clear, actual, fit, bar, limits
corgui('UpdateCorBox');

switch SYS.algo
    
case 'SVD'
% Update SVD Displays
respgui('PlotSVD');
set(SYS.handles.svdedit,'String',num2str(RSP(plane).nsvd));

% slider_step=[arrow_step, trough_step] normalized to range
if RSP(plane).nsvdmx>1
    slider_step=[1/(RSP(plane).nsvdmx-1),1/(RSP(plane).nsvdmx-1)];
    set(SYS.handles.svdslide,'Visible','On','Value',RSP(plane).nsvd,'Max',RSP(plane).nsvdmx,'Min',1,'SliderStep',slider_step);
    set(SYS.handles.svdedit,'Value',RSP(plane).nsvd);
else
    set(SYS.handles.svdslide,'Visible','Off');
end

end   %end algo case

orbgui('UpdateParameters');

orbgui('LBox',' Finished acquisition and display refresh');


%=============================================================
case 'LoadPhysData'                     % *** LoadPhysData ***
%=============================================================
%load gain and offset into BPM, COR, BL structures
BPM=varargin{1};
COR=varargin{2};
BL =varargin{3};

PhysData=getphysdata;
BPMFamilies={'BPMx'; 'BPMy'};
CORFamilies={'HCM';  'VCM' };

for k=1:2
    
% BPM gain and offset
BPM(k).gain  =PhysData.(BPMFamilies{k}).Gain.Data;
BPM(k).offset=PhysData.(BPMFamilies{k}).Offset.Data;

% Dispersion data
BPM(k).disprf=PhysData.(BPMFamilies{k}).Dispersion.ActuatorDelta;    % rf change to generate dispersion orbit
BPM(k).disp  =PhysData.(BPMFamilies{k}).Dispersion.Data;             % mm per MHz. vector size full length (all BPMs)
BPM(k).disp  =BPM(k).disp*BPM(k).disprf;                             % mm per unit of rf frequency used in dispersion measurement

% Corrector gain and offset
% COR(k).gain  =PhysData.(CORFamilies{k}).Gain.Data;
% COR(k).offset=PhysData.(CORFamilies{k}).Offset.Data;


end

if isfield(PhysData,'BL')
BL(2).gain   =PhysData.BL.Error.Gain;
BL(2).offset =PhysData.BL.Error.Offset;
end

varargout{1}=BPM;
varargout{2}=COR;
varargout{3}=BL;

%=============================================================
case 'LoadCLSPhysData'                     % *** LoadCLSPhysData ***
%=============================================================
%load gain and offset into BPM, COR, BL structures
BPM=varargin{1};
COR=varargin{2};
BL =varargin{3};

BPMFamilies={'BPMx'; 'BPMy'};
CORFamilies={'HCM';  'VCM' };

ao=getao;
for k=1:2
BPM(k).gain  =ao.BPMx.Gain;
BPM(k).offset=ao.BPMx.Offset;
end

varargout{1}=BPM;
varargout{2}=COR;
varargout{3}=BL;

%=============================================================
case 'LoadALBAPhysData'                     % *** LoadALBAPhysData ***
%=============================================================
%load gain and offset into BPM, COR, BL structures
BPM=varargin{1};
COR=varargin{2};
BL =varargin{3};

PhysData=getphysdata;
BPMFamilies={'BPMx'; 'BPMy'};
CORFamilies={'HCM';  'VCM' };

for k=1:2
BPM(k).gain  =PhysData.(BPMFamilies{k}).Gain.Data;
BPM(k).offset=PhysData.(BPMFamilies{k}).Offset.Data;
% COR(k).gain  =PhysData.(CORFamilies{k}).Gain.Data;
% COR(k).offset=PhysData.(CORFamilies{k}).Offset.Data;
end

varargout{1}=BPM;
varargout{2}=COR;
varargout{3}=BL;

%=============================================================
case 'LoadASPPhysData'                     % *** LoadASPPhysData ***
%=============================================================
%load gain and offset into BPM, COR, BL structures
BPM=varargin{1};
COR=varargin{2};
BL =varargin{3};

PhysData=getphysdata;
BPMFamilies={'BPMx'; 'BPMy'};
CORFamilies={'HCM';  'VCM' };

for k=1:2
    BPM(k).gain  =getgain(BPMFamilies{k}, family2dev(BPMFamilies{k}, 0));
    BPM(k).offset=getoffset(BPMFamilies{k}, family2dev(BPMFamilies{k}, 0));
end

varargout{1}=BPM;
varargout{2}=COR;
varargout{3}=BL;


%=============================================================
case 'Relative'                             % *** Relative ***
%=============================================================
%Toggles orbit display absolute/relative
%If reference orbit read from file then subtract
%Otherwise reference orbit is zero
   

if     get(SYS.handles.abs,'Value')==0 & SYS.relative==1        %was in absolute mode, stay in absolute
  set(SYS.handles.abs,'Value',1);
elseif get(SYS.handles.rel,'Value')==0 & SYS.relative==2        %was in relative mode, stay in relative
  set(SYS.handles.rel,'Value',1);
elseif get(SYS.handles.rel,'Value')==1 & SYS.relative==1        %was in absolute mode, switch to relative
  SYS.relative=2;           %relative mode
  set(SYS.handles.abs,'Value',0);
  BPM(1).abs=BPM(1).ref;     %BPM.act and BPM.des have BPM.abs subtracted off at plot time
  BPM(2).abs=BPM(2).ref;
elseif get(SYS.handles.abs,'Value')==1 & SYS.relative==2        %was in relative mode, switch to absolute
  SYS.relative=1;           %absolute mode
  set(SYS.handles.rel,'Value',0);
  BPM(1).abs=zeros(size(BPM(1).name,1),1);
  BPM(2).abs=zeros(size(BPM(2).name,1),1);
end

setappdata(0,'SYS',SYS);
setappdata(0,'BPM',BPM);

bpmgui('RePlot');     %do not replot correctors for relative
bpmgui('BPMBar');

%==========================================================
case 'ScaleBPMAxis'                  % *** ScaleBPMAxis ***
%==========================================================
axes(SYS.handles.ah1);
a = axis;
ChangeFactor = 1.1;
if get(SYS.handles.BPMScale,'Value') < 0
    del = (ChangeFactor-1)*(a(4)-a(3));
else
    del = (1/ChangeFactor-1)*(a(4)-a(3));
end
axis([a(1) a(2) a(3)-del/2 a(4)+del/2]);
set(SYS.handles.BPMScale, 'Value', 0);

BPM(plane).ylim=a(4)+del/2;
setappdata(0,'BPM',BPM);

%rescale BPMBar
yd=[-BPM(plane).ylim/4,BPM(plane).ylim/4];
set(SYS.handles.lhbid,'YData',yd);
bpmgui('BPMBar');

%==========================================================
case 'RescaleBPMAxis'                  % *** ScaleBPMAxis ***
%==========================================================
axes(SYS.handles.ah1);
BPM(plane).scalemode=1;
bpmgui('ylimits');
BPM(plane).scalemode=0;

a = axis;
BPM(plane).ylim=a(4);
setappdata(0,'BPM',BPM);

%rescale BPMBar
yd=[-BPM(plane).ylim/4,BPM(plane).ylim/4];
set(SYS.handles.lhbid,'YData',yd);
bpmgui('BPMBar');

%==================================================================
case 'AutoScaleBPMAxis'                  % *** AutoScaleBPMAxis ***
%==================================================================

% Auto-scale y-axis of BPM plot
axis(SYS.handles.ah1, 'auto');
a = axis(SYS.handles.ah1);
axis(SYS.handles.ah1, [a(1) a(2) a(3) a(4)]);

%==================================================================
case 'AutoScaleCORAxis'                  % *** AutoScaleCORAxis ***
%==================================================================

% Auto-scale y-axis of COR plot
axis(SYS.handles.ahcor, 'auto');
a = axis(SYS.handles.ahcor);
axis(SYS.handles.ahcor, [a(1) a(2) a(3) a(4)]);

%==========================================================
case 'ScaleCORAxis'                  % *** ScaleCORAxis ***
%==========================================================
axes(SYS.handles.ahcor);
a = axis;
ChangeFactor = 1.1;
if get(SYS.handles.CORScale,'Value') < 0
    del = (ChangeFactor-1)*(a(4)-a(3));
else
    del = (1/ChangeFactor-1)*(a(4)-a(3));
end
axis([a(1) a(2) a(3)-del/2 a(4)+del/2]);
set(SYS.handles.CORScale, 'Value', 0);

COR(plane).ylim=a(4)+del/2;
setappdata(0,'COR',COR);

%rescale CORBar
yd=[-COR(plane).ylim/4,COR(plane).ylim/4];
set(SYS.handles.lhcid,'YData',yd);
corgui('CorBar');

%==========================================================
case 'RescaleCORAxis'                  % *** ScaleCORAxis ***
%==========================================================
axes(SYS.handles.ahcor);
COR(plane).scalemode=1;
corgui('ylimits');
COR(plane).scalemode=0;

a = axis;
COR(plane).ylim=a(4);
setappdata(0,'COR',COR);

%rescale BPMBar
yd=[-COR(plane).ylim/4,COR(plane).ylim/4];
set(SYS.handles.lhcid,'YData',yd);
corgui('CorBar');

%===========================================================
case 'StartLoc'              %*** StartLoc ***
%===========================================================
%cross cursor to select a new start location on Z axis.
%must put bpms into 'Select' mode (display only) so
%bpm nearest cursor will not get toggled or dragged
%NOTE: tried setting mode to zero and then reset after sizing plot but still toggles bpm state.

mode=BPM(plane).mode;     %save mode for after NewStart            
BPM(plane).mode=0;        %put in select mode
setappdata(0,'BPM',BPM);

set(orbfig,'Pointer','fullcross',...
   'WindowButtonDownFcn','orbgui(''NewStart'')');
BPM(plane).mode=mode;     %restore mode
setappdata(0,'BPM',BPM);

%===========================================================
case 'NewStart'              %*** NewStart ***
%===========================================================
%sets the current cursor position as the new Start Location of the plot.
cpa = get(SYS.handles.ahbpm,'CurrentPoint');
limits = get(SYS.handles.ahbpm,'XLim');                 
set(SYS.handles.ahbpm,'XLim',[cpa(1,1) limits(1,2)]);   %Change start, leave stop alone
set(SYS.handles.ahcor,'XLim',[cpa(1,1) limits(1,2)]);   %Change start, leave stop alone
set(orbfig, 'Pointer','arrow',...
   'WindowButtonDownFcn','');

%===========================================================
case 'StopLoc'              %*** StopLoc ***
%===========================================================
%creates a cross cursor for the user to select a new stopping location on Z axis.
mode=BPM(plane).mode;     %save mode for after NewStart            
BPM(plane).mode=0;        %put in select mode
setappdata(0,'BPM',BPM);

set(orbfig,'Pointer','fullcross',...
   'WindowButtonDownFcn','orbgui(''NewStop'')');
BPM(plane).mode=mode;     %restore mode
setappdata(0,'BPM',BPM);

%===========================================================
case 'NewStop'              %*** NewStop ***
%===========================================================
%set the current cursor position as the new Stop Location of the plot.
cpa = get(SYS.handles.ahbpm,'CurrentPoint');
limits = get(SYS.handles.ahbpm,'XLim');                      
set(SYS.handles.ahbpm,'XLim',[limits(1,1) cpa(1,1)]);    %Change stop, leave start alone
set(SYS.handles.ahcor,'XLim',[limits(1,1) cpa(1,1)]);    %Change stop, leave start alone
set(orbfig, 'Pointer','arrow',...
   'WindowButtonDownFcn','');

%===========================================================
case 'ResetAxes'              %*** ResetAxes ***
%===========================================================
%Reset the start/stop z-position to full span on bpms and correctors.
%Since 'auto' for correctors caused negative-z, use bpm plot limits.
set(SYS.handles.ahbpm,'XLimMode','auto');
xlim=get(SYS.handles.ahbpm,'XLim');
set(SYS.handles.ahcor,'Xlim',xlim);

%move Start/Stop position icons back if they exist

incr=0.005;
h1=findobj(0,'Tag','startpatch');
if ~isempty(h1) orbgui('SetStartPatch',incr); end;
h2=findobj(0,'Tag','stoppatch');
if ~isempty(h2) orbgui('SetStopPatch' ,1.0-incr); end;

%===========================================================
case 'BPMPlotScale'                    %*** BPMPlotScale ***
%===========================================================
%Select vertical limit for BPM plot

%Clear previous  figure
bpmscalefig = findobj(0,'tag','bpmplotscale');
if ~isempty(bpmscalefig) delete(bpmscalefig); end

figure('Position',[600 600 400 200],...
    'NumberTitle','off',...
    'Name','BPM Plot Control',...
    'Tag','bpmplotscale',...
    'MenuBar','none');

val=0;
if BPM(plane).scalemode==0; val=1; end              %manual
uicontrol('Style','radio',...
    'Position',[20 150 120 20],...	
    'String','Manual Scale',...
    'Tag','bpmmanual',...
    'Value',val,...
    'ToolTipString','BPM plot scale Manual',...	
    'Callback','orbgui(''BPMScaleType'', ''0'')');

uicontrol('Style','text',...
    'String','Vertical Axis Limit: ','HorizontalAlignment','left',...
    'Position',[150 150 100 20]);

uicontrol('Style','edit',...
    'tag','bpmscale',...
    'String',num2str(BPM(plane).ylim),'HorizontalAlignment','left',...
    'Position',[250 150 50 20]);


val=0;
if BPM(plane).scalemode==1; val=1; end              %auto   
uicontrol('Style','radio',...
    'Position',[20 120 120 20],...	
    'String','Auto Scale','HorizontalAlignment','left',...
    'Tag','bpmauto',...
    'Value',val,...
    'ToolTipString','BPM plot scale Auto',...	
    'Callback','orbgui(''BPMScaleType'', ''1'')');

val=0;
if strcmp(SYS.xscale,'meter'); val=1; end           %s-position
uicontrol('Style','radio',...
    'Position',[20 90 150 20],...	
    'String','Plot vs. s-position',...
    'Tag','plotspos',...
    'Value',val,...
    'ToolTipString','Plot BPM vs. the s-position',...	
    'Callback','orbgui(''PlotSPosition'')');  

val=0;
if strcmp(SYS.xscale,'phase'); val=1; end          %betatron phase
uicontrol('Style','radio',...
    'Position',[20 60 150 20],...	
    'String','Plot vs. Phase',...
    'Tag','plotphase',...
    'Value',val,...
    'ToolTipString','Plot BPMs vs. the phase',...	
    'Callback','orbgui(''PlotPhase'')');  

uicontrol('Style','pushbutton',...                  %apply
    'String','Apply',...
    'Position',[150 20 50 20],...
    'Callback','orbgui(''ProcessBPMScale'');');

uicontrol('Style','pushbutton',...                  %cancel
    'String','Cancel',...
    'Callback','delete(gcf)',...
    'Position',[210 20 50 20]);

%===========================================================
case 'ProcessBPMScale'              %*** ProcessBPMScale ***
%===========================================================
%select vertical limits for BPM axis (symetric limits)

h=findobj(0,'Tag','bpmscale');
ylim=str2num(get(h,'String'));

if isempty(ylim) 
    ylim=BPM(plane).ylim; 
end

hmanual=findobj(0,'Tag','bpmmanual');
set(h,'Value',1);
hauto=findobj(0,'Tag','bpmauto');
if BPM(plane).scalemode==0  %manual mode
    BPM(plane).ylim=ylim;
    
    set(SYS.handles.ahbpm,'YLim',[-ylim,ylim]);
    
    set(hmanual,'Value',1);
    set(hauto,'Value',0);
else                        %auto mode
    BPM(plane).ylim=ylim;
    
    set(hmanual,'Value',0);
    set(hauto,'Value',1);
end

setappdata(0,'BPM',BPM);

bpmgui('BPMBar');

%delete(gcf);


%===========================================================
case 'PlotSPosition'                    %*** PlotSPosition ***
%===========================================================
%plot BPMs and correctors in terms of s-position
h1=findobj(0,'tag','plotspos');
h2=findobj(0,'tag','plotphase');

if get(h1,'Value')==0 & get(h2,'Value')==0   %...default to meters
    set(h2,'Value',1);
    SYS.xscale='phase';
    SYS.xlimax=SYS.mxphi(plane);
    set(get(SYS.handles.ahcor,'Xlabel'),'string','Betatron Phase (rad)');
else
    SYS.xscale='meter';
    set(h1,'Value',1);
    set(h2,'Value',0);
    SYS.xlimax=SYS.mxs;
    set(get(SYS.handles.ahcor,'Xlabel'),'string','Position in Storage Ring (m)');
end

setappdata(0,'SYS',SYS);

h=findobj(0,'Tag','startpatch');
xd=get(h,'Xdata');
start=xd(1)*SYS.xlimax;
h=findobj(0,'Tag','stoppatch');
xd=get(h,'Xdata');
stop= xd(1)*SYS.xlimax;

set(SYS.handles.ahbpm,'XLim',[start stop]);  %go from startpatch to stop patch
bpmgui('RePlot');
set(SYS.handles.ahcor,'Xlim',[start stop]);
corgui('RePlot');

%===========================================================
case 'PlotPhase'                    %*** PlotPhase ***
%===========================================================
%plot BPMs and correctors in terms of phase
h1=findobj(0,'tag','plotspos');
h2=findobj(0,'tag','plotphase');

if get(h1,'Value')==0 & get(h2,'Value')==0   %...default to meters
    set(h1,'Value',1);
    SYS.xscale='meter';
    SYS.xlimax=SYS.mxs;
    set(get(SYS.handles.ahcor,'Xlabel'),'string','Position in Storage Ring (m)');

else
    SYS.xscale='phase';
    set(h1,'Value',0);
    set(h2,'Value',1);
    SYS.xlimax=SYS.mxphi(plane);
    set(get(SYS.handles.ahcor,'Xlabel'),'string','Betatron Phase (rad)');
end

setappdata(0,'SYS',SYS);

h=findobj(0,'Tag','startpatch');
xd=get(h,'Xdata');
start=xd(1)*SYS.xlimax;
h=findobj(0,'Tag','stoppatch');
xd=get(h,'Xdata');
stop= xd(1)*SYS.xlimax;

set(SYS.handles.ahbpm,'XLim',[start stop]);  %go from startpatch to stop patch
bpmgui('RePlot');
set(SYS.handles.ahcor,'Xlim',[start stop]);
corgui('RePlot');

%===========================================================
case 'BPMScaleType'                    %*** BPMScaleType ***
%===========================================================
%toggle to manual mode for BPM vertical axis
stype=varargin(1);
stype=str2num(stype{1});    % stype=0 for manual,   stype=1 for auto

%presently in manual mode, toggle to auto
if (BPM(plane).scalemode==0 & stype==0) |...
   (BPM(plane).scalemode==0 & stype==1)
h=findobj(0,'Tag','bpmmanual');
set(h,'Value',0);
h=findobj(0,'Tag','bpmauto');
set(h,'Value',1);
BPM(plane).scalemode=1;
setappdata(0,'BPM',BPM);
bpmgui('ylimits');
bpmgui('RePlot');
return
end

%presently in auto mode, toggle to manual
if (BPM(plane).scalemode==1 & stype==0) |...
   (BPM(plane).scalemode==1 & stype==1)
h=findobj(0,'Tag','bpmmanual');
set(h,'Value',1);
h=findobj(0,'Tag','bpmauto');
set(h,'Value',0);
BPM(plane).scalemode=0;
setappdata(0,'BPM',BPM);
ylim=BPM(plane).ylim;
set(SYS.handles.ahbpm,'YLim',[-ylim,ylim]);
bpmgui('RePlot');
return
end

%===========================================================
case 'CorPlotScale'                    %*** CorPlotScale ***
%===========================================================
%Select vertical limit for Corrector plot

%Clear previous  figure
corscalefig = findobj(0,'tag','corplotscale');
if ~isempty(corscalefig) delete(corscalefig); end

figure('Position',[600 600 400 200],...
    'NumberTitle','off','Tag','corplotscale',...
    'Name','COR Vertical Axis Limits',...
    'MenuBar','none');

val=0;
if COR(plane).scalemode==0; val=1; end              %manual
uicontrol('Style','radio',...
    'Position',[20 150 120 20],...	
    'String','Manual Scale',...
    'Tag','cormanual',...
    'Value',val,...
    'ToolTipString','Corrector plot scale Manual',...	
    'Callback','orbgui(''CORScaleType'', ''0'')');

val=0;
if COR(plane).scalemode==1; val=1; end
uicontrol('Style','radio',...
    'Position',[20 120 120 20],...	
    'String','Auto Scale','HorizontalAlignment','left',...
    'Tag','corauto',...
    'Value',val,...
    'ToolTipString','Corrector plot scale Auto',...	
    'Callback','orbgui(''CORScaleType'', ''1'')');     %auto   

uicontrol('Style','text',...
    'String','Vertical Axis Limit: ','HorizontalAlignment','left',...
    'Position',[150 150 100 20]);

uicontrol('Style','edit',...
    'tag','corscale',...
    'String',num2str(COR(plane).ylim),'HorizontalAlignment','left',...
    'Position',[250 150 50 20]);

uicontrol('Style','pushbutton',...                    %apply
    'String','Apply',...
    'Position',[150 20 50 20],...
    'Callback','orbgui(''ProcessCORScale'');');

uicontrol('Style','pushbutton',...                    %cancel
    'String','Cancel',...
    'Callback','delete(gcf)',...
    'Position',[210 20 50 20]);

%===========================================================
case 'CORScaleType'                    %*** CORScaleType ***
%===========================================================
%toggle to manual mode for COR vertical axis
stype=varargin(1);
stype=str2num(stype{1});    % stype=0 for manual,   stype=1 for auto

hmanual=findobj(0,'Tag','cormanual');
hauto=findobj(0,'Tag','corauto');

%presently in manual mode, toggle to auto
if (COR(plane).scalemode==0 & stype==0) |...
   (COR(plane).scalemode==0 & stype==1)
set(hmanual,'Value',0);
set(hauto,'Value',1);
COR(plane).scalemode=1;
setappdata(0,'COR',COR);
corgui('ylimits');
corgui('RePlot');
return
end

%presently in auto mode, toggle to manual
if (COR(plane).scalemode==1 & stype==0) |...
   (COR(plane).scalemode==1 & stype==1)
set(hmanual,'Value',1);
set(hauto,'Value',0);
COR(plane).scalemode=0;
setappdata(0,'COR',COR);
ylim=COR(plane).ylim;
set(SYS.handles.ahcor,'YLim',[-ylim,ylim]);
corgui('RePlot');
return
end

%===========================================================
case 'ProcessCORScale'              %*** ProcessCORScale ***
%===========================================================
h=findobj(0,'Tag','corscale');
ylim=str2num(get(h,'String'));
if isempty(ylim); 
ylim=COR(plane).ylim; end

if COR(plane).scalemode==0;  %manual mode
COR(plane).ylim=ylim;
setappdata(0,'COR',COR);
set(SYS.handles.ahcor,'YLim',[-ylim,ylim]);

h=findobj(0,'Tag','cormanual');
set(h,'Value',1);
h=findobj(0,'Tag','corauto');
set(h,'Value',0);


else                        %auto mode
    COR(plane).ylim=ylim;
    setappdata(0,'COR',COR);
    h=findobj(0,'Tag','cormanual');
    set(h,'Value',0);
    h=findobj(0,'Tag','corauto');
    set(h,'Value',1);
end

corgui('CorBar');

%delete(gcf);

%=============================================================
case 'LstBox'                               %  LstBox
%==========================================================
%create list box to display program output dialog
ts = ['Program Start-Up: ' datestr(now,0)];
[screen_wide, screen_high]=screensizecm;
if screen_wide/screen_high > 2
    screen_wide = screen_wide/2;
end

x0=0.013*screen_wide; y0=0.2000*screen_high; dx=0.3061*screen_wide; dy=0.04817*screen_high;

SYS.handles.lstbox=uicontrol('Style','list','Units','centimeters','Position',[x0 y0 dx dy],'String',{ts});

%===========================================================
case 'LBox'                          %*** LBox ***
%===========================================================
%load latest sequence of strings into graphical display listbox
comment=varargin{1};
ts = datestr(now,0);
addstr={[ts  ': ' comment]};
h=SYS.handles.lstbox;  
str=get(h,'String');
str=[str; addstr];
[ione,itwo]=size(str);
nentry=50;
if ione>=nentry                %keep only top entries
str=str(ione-nentry+1:ione,1);
[ione,itwo]=size(str);
end
set(h,'String',str,'listboxtop',ione);

% % % if ~isempty(SYS.SYSLogfid)              %write to log file
% % %    str=char(addstr{1});
% % %    fprintf(SYS.SYSLogfid,'%s\n',str);
% % % end

%==========================================================
case 'StartPatchActive'                  % StartPatchActive
%==========================================================
%activate start patch in element icon/zoom bar
set(orbfig,'WindowButtonMotionFcn','orbgui(''MoveStartPatch'')',...
		   'WindowButtonUpFcn',    'orbgui(''StartPatchUp'')');

%==========================================================
case 'MoveStartPatch'                    % MoveStartPatch
%==========================================================
xpos=orbgui('GetStartPos',0.02);
orbgui('SetStartPatch',xpos);

%==========================================================
case 'GetStartPos'                    % GetStartPos
%==========================================================
%find starting position and check agains stop position
stoplim=varargin(1); stoplim=stoplim{1};
%check requested point to right of zero
cpa = get(SYS.handles.ahpos, 'CurrentPoint');
xpos = cpa(1);
if xpos<=0.0055
   xpos=0.0055;
end

%check requested point to left of stop patch
h=findobj(0,'Tag','stoppatch');
xlim=get(h,'XData');   %x-positions of three patch corners
if xpos>=xlim(1)-stoplim;
   xpos =xlim(1)-stoplim;
end
varargout{1}=xpos;

%==========================================================
case 'SetStartPatch'                     % SetStartPatch
%==========================================================
%move the patch to mouse position
xpos=varargin{1};
h=findobj(orbfig,'tag','startpatch');
xdata = [xpos-0.005 xpos+0.005 xpos-0.005];
set(h, 'XData', xdata);  

%==========================================================
case 'StartPatchUp'                       %StartPatchUp
%==========================================================
%sequence to execute when startpatch let up
xpos=orbgui('GetStartPos',0.01);
orbgui('SetStartPatch',xpos);

%change BPM and corrector plot limits
limits = get(SYS.handles.ahbpm,'XLim');                 
set(SYS.handles.ahbpm,'XLim',[SYS.xlimax*xpos limits(1,2)]);   %Change start, leave stop alone
set(SYS.handles.ahcor,'XLim',[SYS.xlimax*xpos limits(1,2)]);
corgui('PlotAct');
corgui('PlotFit');
set(orbfig, 'Pointer','arrow',...
   'WindowButtonMotionFcn','','WindowButtonUpFcn','');

%==========================================================
case 'StopPatchActive'                  % StopPatchActive
%==========================================================
set(orbfig,'WindowButtonMotionFcn','orbgui(''MoveStopPatch'')',...
		   'WindowButtonUpFcn',    'orbgui(''StopPatchUp'')');

%==========================================================
case 'MoveStopPatch'                    % MoveStopPatch
%==========================================================
xpos=orbgui('GetStopPos',0.01);
orbgui('SetStopPatch',xpos);

%==========================================================
case 'GetStopPos'                    % GetStopPos
%==========================================================
stoplim=varargin(1); stoplim=stoplim{1};
%check requested point to left of the x-limit
cpa = get(SYS.handles.ahpos, 'CurrentPoint');
xpos = cpa(1);
if xpos>=(1.0 - 0.005)
   xpos =(1.0 - 0.005);
end

%check requested point to right of start patch
h=findobj(orbfig,'tag','startpatch');
xlim=get(h,'XData');   %x-positions of three patch corners
if xpos<=xlim(1)+stoplim
   xpos=xlim(1)+stoplim+0.01;
end
varargout{1}=xpos;

% %check requested point to left of stop patch
% h=findobj(orbfig,'tag','stoppatch');
% xlim=get(h,'XData');   %x-positions of four patch corners
% if xpos>=xlim(1)-stoplim;
%    xpos=xlim(1)-stoplim;
% end
% varargout{1}=xpos;

%==========================================================
case 'SetStopPatch'                     % SetStopPatch
%==========================================================
xpos=varargin{1};
h=findobj(orbfig,'tag','stoppatch');
xdata = [xpos+0.005 xpos-0.005 xpos+0.005];
set(h, 'XData', xdata);  %move the patch to mouse position

%==========================================================
case 'StopPatchUp'                       %StopPatchUp
%==========================================================
xpos=orbgui('GetStopPos',0.01);
orbgui('SetStopPatch',xpos);

%change BPM and corrector plot limits
limits = get(SYS.handles.ahbpm,'XLim');                 
set(SYS.handles.ahbpm,'XLim',[limits(1,1) SYS.xlimax*xpos]);   %Change stop, leave start alone
set(SYS.handles.ahcor,'XLim',[limits(1,1) SYS.xlimax*xpos]);
corgui('PlotAct');
corgui('PlotFit');
set(orbfig, 'Pointer','arrow',...
   'WindowButtonMotionFcn','','WindowButtonUpFcn','');

%==========================================================
case 'GetAbscissa'                          %...GetAbscissa
%==========================================================
%return coordinates for abscissa
SYS=varargin{1};
plane=SYS.plane;
elem=varargin{2};

switch SYS.xscale
case 'meter'
    if strcmp(upper(elem),'BPM') xd=BPM(plane).z; end
    if strcmp(upper(elem),'COR') xd=COR(plane).z; end
case 'phase'
    if strcmp(upper(elem),'BPM') xd=BPM(plane).phi; end
    if strcmp(upper(elem),'COR') xd=COR(plane).phi; end
end

varargout={xd};

%==========================================================
case 'CloseMainFigure'                    %CloseMainFigure
%==========================================================

answer = questdlg('Close Orbit GUI?',...
                  'Exit Orbit Control Program',...
                  'Yes','No','Yes');
switch answer
    
case 'Yes'
    
    delete(findobj('tag','makeorbitslider'));
    delete(findobj('tag','bpmplotscale'));
    delete(findobj('tag','corplotscale'));
    
    delete(findobj('tag','rload_xbwt'));
    delete(findobj('tag','rload_xclim'));
    delete(findobj('tag','rload_xcwt'));
    delete(findobj('tag','rload_hbpm'));
    delete(findobj('tag','rload_etawtx'));
        
    delete(findobj('tag','rload_ybwt'));
    delete(findobj('tag','rload_yclim'));
    delete(findobj('tag','rload_ycwt'));
    delete(findobj('tag','rload_ypwt'));
    delete(findobj('tag','rload_vbpm'));
    delete(findobj('tag','rload_etawty'));
    
    delete(findobj('tag','rload_vbl'));
    delete(findobj('tag','toggle_blsel'));

    delete(findobj('tag','dispersionpanel'));
    delete(findobj('tag','orbfig'));
    return
    
otherwise
    return   
end

%===========================================================
otherwise
disp(['   Warning: CASE not found in ORBGUI: ' action]);

end  %end switchyard


