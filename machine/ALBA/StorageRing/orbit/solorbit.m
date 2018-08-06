% GUI for orbit correction
%
%=============================================================
% Instruction sequence to launch orbit program for SOLEIL
% Laurent S. Nadolski 
% Adaptation from William J. Corbett SPEAR3 application
%=============================================================
%
% TODO Amman's Factor not take off of the R-matrix: to do in the future
%
% See Alsp orbgui, bpmgui, corgui

disp('   Initializing orbit control panel...');

%Check to see AcceleratorObjects loaded
global THERING
if isempty(getao) || ~exist('THERING','var')
    disp('Warning: Load Accelerator Model and AcceleratorObjects first');
    return
end

%Software operates in HW units
switch2hw;

%change directory to SOLEIL
vpath = getfamilydata('Directory','Orbit');
cd(vpath);

%Clear global structures
clear global SYS BPM COR RSP
setappdata(0,'SYS',[]);
setappdata(0,'BPM',[]);
setappdata(0,'COR',[]);
setappdata(0,'RSP',[]);

%Declare global structures
global SYS BPM COR RSP %... in the command window workspace for timer

%Clear previous ORBIT figure
orbfig = findobj(0,'tag','orbfig');  %orbfig "global"
if ~isempty(orbfig), delete(orbfig); end

%Initialize Structures for Orbit Program (no control parameters)
BPM = BPMInit_Orb;
COR = CORInit_Orb;

%SYS parameters are required for initialization
SYS.machine    = 'SOLEIL';
SYS.restorefile= 'soleilrestore';
SYS.localdata  = [vpath 'localdata/'];
SYS.reffile    = 'silver.dat';
SYS.bpmode     = 'slowacquisition'; 
SYS.plane      = 1;          % H-plane
SYS.cortype    = COR(SYS.plane).AOFamily; % consistent with SYS.plane=1
SYS.relative   = 1;          % Absolute mode
SYS.current    = getdcct;        % Amperes
SYS.energy     = getenergy;  % In GeV
SYS.lifetime   = 15;         % Lifetime in hours 
SYS.units      ='HW';        %default to hardware units

%Draw main figure
orbgui('OrbFig');               %Figure with tag 'orbfig'
% SYS.ahbpm = orbgui('Axes_1');   % Create handles for  Axes for BPM
% setappdata(0,'SYS',SYS);
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
orbgui('RespMenu');             %Menu for Response Matrix options
orbgui('EtaMenu');              %Dispersion control panel
orbgui('OptMenu');              %Menu for Optics options
orbgui('SimMenu');              %Menu for Simulation options
orbgui('SuperperiodMenu');      %Menu for Response Matrix options
orbgui('SYSMenu');              %Menu for System options
orbgui('UIControls');           %UIControls
%orbgui('AlgorithmMenu');       %Algo choice
%orbgui('BumpSlider');          %Bump height adjustment
orbgui('MachineParameters');    %Text fields for system parameters, load initial values


% init maximum x-scale
SYS.xlimax = getcircumference;
setappdata(0,'SYS',SYS);
  
orbgui('LoadRaw2Real'); %Load Raw2Real coefficients from physdata
orbgui('LatticeAxes');  %Used to zoom abscissa
orbgui('plotxaxis','allmachine');   %set default xaxis 

%Read reference orbit (to load iref; .abs and .des=.ref in routine)
BPM = RefOrb2Zero(BPM);

%Restore user parameters, load response matrices, golden orbit
[SYS BPM COR RSP] = restoreorbit(vpath,SYS.restorefile,'auto',SYS,BPM,COR,RSP);  %no graphics commands

%% Determine the mode used in the workspace
switch getmode(COR(1).AOFamily);
    case 'Online'
        SYS.mode   = 'Online';
        set(SYS.online, 'Checked', 'On');
        set(SYS.orbfig,'Name', ...
            'SOLEIL Storage Ring Orbit Correction Interface (Online)');
        set(SYS.modecolor,'BackGroundColor','r','String','Online');       
    otherwise % Assume simulator mode
        SYS.mode   = 'Simulator';
        set(SYS.sim, 'Checked', 'On');
        set(SYS.orbfig,'Name', ...
            'SOLEIL Storage Ring Orbit Correction Interface (Simulator)');
        set(SYS.modecolor,'BackGroundColor','g','String','Simulator');
end

%% Get phase advanced for machine state
optics     = gettwiss(THERING,0.0);
BPM(1).phi = optics.phix(BPM(1).ATindex);
BPM(2).phi = optics.phix(BPM(2).ATindex);
COR(1).phi = optics.phix(COR(1).ATindex);
COR(2).phi = optics.phix(COR(2).ATindex);
clear optics;
%NOTE: expect response matrix in hardware units (mm/amp)

%%begin hardware checkouts
%% BPM checking

disp('   Checking BPMs...');
[BPM(1).status BPM(2).status] = soleilbpmcheck; %get status from TANGO or sim
BPM(1).avail = BPM(1).status;    %if status o.k. default to available
BPM(2).avail = BPM(2).status;
BPM = SortBPMs(BPM,RSP);         %sort for avail, ifit
% BPM(1).status = family2status('BPMx'); % added at ALBA
% BPM(2).status = family2status('BPMy'); % added at ALBA

% Measure actual orbit
bpmgui('GetAct');   % mm for hardware, meters for physics

%% Corrector checking
disp('   Checking corrector magnets...');
[COR(1).status COR(2).status] = soleilcorcheck;
COR(1).avail = COR(1).status;     %if status o.k. default to available
COR(2).avail = COR(2).status;
COR          = sortcors(COR,RSP); %Get COR status, sort for avail, ifit

%Measure actual correctors
corgui('GetAct');              %amps for hardware, rad for physics
COR(1).ref = COR(1).act;
COR(2).ref = COR(2).act;

%Updates data in workspace
BPM = orderfields(BPM);
COR = orderfields(COR);
setappdata(0,'BPM',BPM);
setappdata(0,'COR',COR);

%% Plot initial BPM data
disp('   Initializing Plots...');
bpmgui('PlotRef_Init');                %...solid red/loaded in BPMInit
bpmgui('PlotIcons_Init');              %...hot circles
bpmgui('PlotDes_Init');                %...dashed red line
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
SYS = orderfields(SYS);
disp('   Setting up program parameters...');
SYS.plane = 1;                           %start with horizontal plane
for ip = 1:2
    orbgui('Plane');                   %switch to vertical
    corgui('SaveCors',ip);            %saves one plane only, all correctors
    COR(ip).rst = COR(ip).act;         %default reset field for 'REMOVE' button
    setappdata(0,'COR',COR);
end

for ip = 2:-1:1
    SYS.plane=ip;
    setappdata(0,'SYS',SYS);
    corgui('HidePlots');
end
corgui('ShowPlots');
%orbgui('RefreshOrbGUI');
readwrite('ReadBPMReference','XZ','Golden');  %load golden orbit, calls RefreshOrbGUI

orbgui('InitialSaveSet');              %load data for restore
orbgui('LBox',' Finished loading Restore File');

%% Orbit in micron {default}
orbgui('BPMChangeUnits','1000xHardware');
%% Corrector in Harwareunits {default}
orbgui('CORChangeUnits','Hardware');

%make figure visible
set(orbfig,'Visible','On');  drawnow;
% pause(1.0); set(orbfig,'Visible','On');  drawnow;   %why repeat??
disp('   Finished initializing orbit program');
set(findobj(0,'Tag','orbfig'),'Visible','On');

%% Cleaning up
clear ip vpath AO orbfig;
