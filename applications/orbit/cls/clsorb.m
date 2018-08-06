%=============================================================
%Instruction sequence to launch orbit program
%=============================================================

%Initialization Message
disp('Initializing CLS Orbit Control Panel');
disp(' ');

%Check to see AcceleratorObjects loaded
global THERING
if isempty(getao) | ~exist('THERING')
    disp('Warning: Load Accelerator Model and AcceleratorObjects first');
    return
end

%Software operates in HW units
switch2HW;

%change directory to CLS
ad=getad;
d=ad.Directory.Orbit;
cd(d);

%Clear global structures
clear global SYS BL BPM COR RSP

%Declare global structures
global       SYS BL BPM COR RSP S  %...S in the command window workspace for timer

%Clear previous ORBIT figure
orbfig = findobj(0,'tag','orbfig');  %orbfig "global"
if ~isempty(orbfig) delete(orbfig); end

%open system log file
%%%%%%%%%%%[SYS.SYSLogfid]=OpenSYSLog('Orbit');

%default accelerator model - to this before initializing icons
refreshthering;      

%Load element names via AcceleratorObjects
BL =getblnames;                            %initialize BL names
BPM=getbpmnames;                          %initialize BPM names
COR=getcornames;                          %initialize COR names

%Initialize main structures for orbit program
BL=BLInit_Orb(BL);     
BPM=BPMInit_Orb(BPM);
COR=CORInit_Orb(COR);

%SYS parameters are required for initialization
SYS.machine='CLS';
SYS.restorefile='clsrestore.m';
SYS.reffile='silver.dat';
SYS.mode='SIMULATOR';
SYS.bpmode='BERGOZ';
SYS.plane=1;
SYS.cortype='HCM';  %consistent with SYS.plane=1
SYS.relative=1;
SYS.curr=0;
SYS.engy=0;
SYS.lt=0;
SYS.ahr=0;
SYS.units='HW';   %default to hardware units


%Draw main figure
orbgui('OrbFig');               %Figure with tag 'orbfig'
SYS.handles.ahbpm=orbgui('Axes_1'); 
orbgui('BPMAxes');  %establish upper axes for BPMs, use ah_1 for BPMs
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
clselementicons;                %initialize element icons (create ElementIcons)
[SYS.elhndl]=elementiconpatch(SYS.handles.ahpos,SYS.elemind,'ShowElem');    %draw initial element icons, return handles
orbgui('ZoomPatches');          %Initialize icons before zoom patchs (patches on top layer)

%Load Gain and offsets from Physdata
[BPM,COR,BL]=orbgui('LoadCLSPhysData',BPM,COR,BL);

%Read reference orbit (to load iref; .abs and .des=.ref in routine)
BPM=RefOrb2Zero(BPM);

%Restore user parameters, load response matrices, golden orbit
[SYS BPM BL COR RSP]=RestoreOrbit(d,SYS.restorefile,'auto',SYS,BPM,BL,COR,RSP);  %no graphics commands
BPM(1).phi=(16/ad.Circumference)*BPM(1).z(:);        %...phase advance
BPM(2).phi= (4/ad.Circumference)*BPM(2).z(:);
COR(1).phi=(16/ad.Circumference)*COR(1).z(:);
COR(2).phi= (4/ad.Circumference)*COR(2).z(:);

%NOTE: expect response matrix in hardware units (mm/amp)

%begin hardware checkouts
disp('Checking Beamlines...');
% BL(2).iopen=getam('BLOpen');   %arrays iopen, iauto contain zeros (uncompressed)
% BL(2).iavail=BL(2).iopen;      %arrays open, auto are compressed
% BL=SortBLs(BL,RSP);          %iopen, iavail, ifit

disp('Checking BPMs...');
[BPM(1).status BPM(2).status]=SPEARBPMCheck;   
BPM(1).avail=BPM(1).status;    %if status o.k. default to available
BPM(2).avail=BPM(2).status;  
BPM=SortBPMs(BPM,RSP);       %sort for avail, ifit

%Measure actual orbit
BPM(1).act=getam('BPMx');   %meters for physics, mm for hardware
BPM(2).act=getam('BPMy');

disp('Checking Correctors...');
[COR(1).status COR(2).status]=SPEARCorCheck;  
COR(1).avail=COR(1).status;    %if status o.k. default to available
COR(2).avail=COR(2).status;  
COR=SortCORs(COR,RSP);         %Get COR status, sort for avail, ifit
    
%Measure actual correctors
COR(1).act=getsp('HCM');      %rad for physics, amps for hardware
COR(1).ref=COR(1).act;
COR(2).act=getsp('VCM');    
COR(2).ref=COR(2).act;

%Plot initial BPM data
disp('Initializing Plots...');
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
disp('Setting up program parameters...');
SYS.plane=1;                           %start with horizontal plane
for ip=1:2
orbgui('Plane');                       %switch to vertical
corgui('SaveCorrs',ip);                %saves one plane only, all correctors
COR(ip).rst=COR(ip).act;               %default reset field for 'REMOVE' button
end

for ip=2:-1:1
SYS.plane=ip; 
corgui('HidePlots');
end
corgui('ShowPlots');
orbgui('RefreshOrbGUI');

orbgui('LBox',' Finished loading Restore File');

%make figure visible
set(orbfig,'Visible','On');  drawnow;
pause(1.0); set(orbfig,'Visible','On');  drawnow;   %why repeat??
disp('Done');
set(findobj(0,'Tag','orbfig'),'Visible','On');
disp('set(findobj(0,''Tag'',''orbfig''),''Visible'',''On'')');

clear ip d path AO orbfig;

