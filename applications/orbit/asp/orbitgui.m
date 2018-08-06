%============================
%Launch ASP Orbit Program 
%============================

disp('   Initializing orbit control panel...');

%Check to see AcceleratorObjects loaded
global THERING
if isempty(getao) | ~exist('THERING')
    disp('Warning: Load Accelerator Model and AcceleratorObjects first');
    return
end

%Clear any previous ORBIT figure
orbfig = findobj(0,'tag','orbfig');  %orbfig "global"
if ~isempty(orbfig) delete(orbfig); end

%goto orbit directory
cd(getfamilydata('Directory','Orbit'));

%Software operates in HW units
switch2hw;

%Clear global structures
clear global SYS BL BPM COR RSP
setappdata(0,'SYS',[]);
setappdata(0,'BPM',[]);
setappdata(0,'COR',[]);
setappdata(0,'RSP',[]);
setappdata(0,'BL' ,[]);

%Declare global structures
global SYS BL BPM COR RSP

%Load element names via AcceleratorObjects
BL=getblnames;                            %initialize BL names
BPM=getbpmnames;                          %initialize BPM names
COR=getcornames;                          %initialize COR names

%Initialize Structures for Orbit Program (no control parameters)
BL=blinit_orb(BL);    %do this first    
BPM=bpminit_orb(BPM);     
COR=corinit_orb(COR);


%SYS parameters required for initialization
SYS.machine='ASP';
SYS.restorefile='asprestore.m';
SYS.mode='ONLINE';
SYS.bpmode='Liberia';
SYS.plane=1;
SYS.cortype='HCM';  %consistent with SYS.plane=1
SYS.relative=2;
SYS.curr=0; SYS.engy=0; SYS.lt=0; SYS.ahr=0;
SYS.units='HW';   %default to hardware units

%open system log file

%Draw main figure
orbgui('OrbFig');               %Figure with tag 'orbfig'
SYS.handles.ahbpm=orbgui('Axes_1'); 
setappdata(0,'SYS',SYS);
orbgui('BPMAxes');              %establish upper axes for BPMs, use ah_1 for BPMs
orbgui('CorAxes');              %COR axes with tag 'SYS.ahbpm'
orbgui('SVDAxes');              %SVD axes with tag 'SYS.ahbpm'
orbgui('BPMbox');               %BPM information display box          
orbgui('CorBox');               %COR information display box                 
orbgui('SVDBox');               %SVD information display box                    
orbgui('LstBox');               %List Box to display program information
orbgui('PlotMenu');             %Menu for plot options
orbgui('BPMMenu');              %Menu for BPM options
orbgui('CORMenu');              %Menu for COR options
orbgui('BLMenu');               %Menu for Beam line options
orbgui('SimMenu');              %Menu for Simulation options
orbgui('RespMenu');             %Menu for Response Matrix options
orbgui('UIControls');           %UIControls
orbgui('MachineParameters');    %Text fields for system parameters, load initial values
orbgui('ZoomAxes');             %Used to zoom absicca
aspelementicons;             %initialize element icons (append fields to THERING)
[SYS.elhndl]=elementiconpatch(SYS.handles.ahpos,SYS.elemind,'ShowElem');    %draw initial element icons, return handles
orbgui('ZoomPatches');          %Initialize icons before zoom patchs (patches on top layer)

%Load Gain and offsets from Physdata
[BPM,COR,BL]=orbgui('LoadASPPhysData',BPM,COR,BL);

%Read reference orbit (initiates BPM.iref/.abs/.des/.ref)
BPM=reforb2zero(BPM);

%Restore user parameters, load response matrices, golden orbit
orbdir=getfamilydata('Directory','Orbit');
[SYS BPM BL COR RSP]=restoreorbit(orbdir,SYS.restorefile,'auto',SYS,BPM,BL,COR,RSP);  %no graphics commands


if strcmpi(SYS.datamode,'REAL')   %convert response matrix to 'real' units NOTE: expect response matrix in hardware units (mm/amp)
   set(SYS.handles.orbfig,'Name',[get(SYS.handles.orbfig,'Name') ':   Data units Real']);
   for k=1:2
   ib=RSP(k).ib;
   ic=RSP(k).ic;
   RSP(k).c(ib,ic)=diag(BPM(k).gain(ib))*RSP(k).c(ib,ic);
   end
end

    %raw: no change in RSP(k).c

Circumference=getfamilydata('Circumference');
BPM(1).phi=(15/Circumference)*BPM(1).z(:);        %...phase advance
BPM(2).phi= (6/Circumference)*BPM(2).z(:);
COR(1).phi=(15/Circumference)*COR(1).z(:);
COR(2).phi= (6/Circumference)*COR(2).z(:);

%begin hardware checkouts
disp('   Checking Beamlines...');
%BL(2).DevList=getlist('BLOpen',0);                %...valid photon BPMs in middlelayer
%BL(2).ElemList=dev2elem('BLOpen',BL(2).DevList);
%BL(2).status=getfamilydata('BLOpen','Status');
%BL=SortBLs(BL,RSP);                               %sort for avail, ifit

disp('   Checking BPMs...');
families={'BPMx'; 'BPMy'};
for k=1:2
  family=families{k};
  BPM(k).status=find(getfamilydata(family,'Status'));  %middle layer status indices
  BPM(k).avail=BPM(k).status;    %if status o.k. default to available
end
BPM=sortbpms(BPM,RSP);         %sort for avail, ifit

%Measure actual orbit
bpmgui('GetAct');              %mm for hardware, meters for physics

disp('   Checking Correctors...');
families={'HCM'; 'VCM'};
for k=1:2
family=families{k};
COR(k).status=find(getfamilydata(family,'Status'));  %middle layer status indices
COR(k).avail=COR(k).status;    %if status o.k. default to available
end



%corrector reference
corgui('GetAct');              %amps for hardware, rad for physics
% COR(1).act=0*COR(1).z;
% COR(2).act=0*COR(2).z;
COR(1).ref=COR(1).act;
COR(2).ref=COR(2).act;
COR=sortcors(COR,RSP);         %Get COR status, sort for avail, ifit
    
setappdata(0,'BPM',BPM);
setappdata(0,'BL',BL);
setappdata(0,'COR',COR);

%Plot initial BPM data
disp('   Initializing Plots...');
bpmgui('PlotRef_Init');                %...solid red/loaded in BPMInit
bpmgui('PlotDes_Init');                %...dashed red line
bpmgui('PlotIcons_Init');              %...hot circles
bpmgui('PlotAct_Init');                %...initialize blue actual orbit plot
bpmgui('PlotFit_Init');                %...initialize orbit fit plot
bpmgui('PlotResp_Init');               %...initialize response matrix plot
bpmgui('PlotEig_Init');                %...initialize eigenvector plot
bpmgui('PlotRef');                     %...solid red/loaded in BPMInit
bpmgui('PlotBPMs');                    %...hot circles/loaded in BPMInit
bpmgui('PlotAct');                     %...blue line/loaded in BPMInit

%Plot initial cor data
corgui('PlotCor_Init');                %...initialize corrector patches

%Plot initial SVD data
respgui('PlotSVD_Init');               %...initialize bpm and corrector eigenvector plots

%Set up program parameters: both planes
disp('   Setting up program parameters...');
SYS.plane=1;                           %start with horizontal plane
for ip=1:2
%COR=getappdata(0,'COR');
orbgui('Plane');                       %switch to vertical
corgui('SaveCorrs',ip);                %saves one plane only, all correctors
COR(ip).rst=COR(ip).act;               %default reset field for 'REMOVE' button
setappdata(0,'COR',COR);

orbgui('RescaleBPMAxis');
orbgui('RescaleCORAxis');
end

for k=2:-1:1
SYS.plane=k; 
setappdata(0,'SYS',SYS);
corgui('HidePlots');
end
corgui('ShowPlots');

%load golden orbit
readwrite('ReadBPMReference','B','Golden');  %load golden orbit, RefreshOrbGUI

orbgui('LBox',' Finished loading Restore File');


set(orbfig,'Visible','On');  drawnow; %make figure visible
disp('   Finished initializing orbit program');

clear k orbfig orbdir;

