function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  ModeNumber = 1. 1.9 GeV, Top Off
%               2. 1.9 GeV, Ramping from 1.353 GeV
%               3. 1.9 GeV, Ramping from 1.230 GeV
%               4. 1.9 GeV, High Tune
%               5. 1.9 GeV, Low  Tune
%               6. 1.9 GeV, 2-Bunch
%               7. 1.5 GeV, High Tune
%               8. 1.5 GeV, Isochronous Sections
%               9. 1.5 GeV, Ramping from 1.353 GeV
%              10. 1.9 GeV, Low Emittance (Sextupole Upgrade)
%              99. 1.9 GeV, High Tune Study (Sextupole Upgrade)
%             101. 1.9 GeV, Model

%             888. Pseudo-Single Bunch Mode (0.18, 0.25)
%             999. Greg's Mode
%            9999. Tom's Mode
%             100. Christoph's Mode
%             200. Walter's Mode
%
%  See also aoinit, updateatindex, alsinit


global THERING

% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    ModeNumber = [];
end

% if isempty(ModeNumber)
%     ModeCell = {
%         '1.9 Gev, 2-Bunch', ... 
%         '1.5 Gev, High Tune', ... 
%         '1.9 GeV, Pseudo Single Bunch (0.18, 0.25)'
%         };
%     [ModeNumber, OKFlag] = listdlg('Name','ALS','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 200]);
%     if OKFlag ~= 1
%         fprintf('   Operational mode not changed\n');
%         return
%     end
% end

if isempty(ModeNumber)
    ModeCell = {
        '1.9 GeV, Top Off', ... 
        '1.9 GeV, Inject at 1.353 GeV', ... 
        '1.9 GeV, Inject at 1.230 GeV', ... 
        '1.9 Gev, High Tune', ... 
        '1.9 Gev, Low Tune', ... 
        '1.9 Gev, 2-Bunch', ... 
        '1.5 Gev, High Tune', ... 
        '1.5 GeV, Isochronous Sections', ... 
        '1.5 GeV, Inject at 1.353 GeV', ... 
        '1.9 GeV, Low Emittance (Sextupole Upgrade)', ... 
        '1.9 GeV, High Tune Study (Sextupole Upgrade)', ... 
        '1.9 GeV, Model', ... 
        'Greg''s Mode', ... 
        'Tom''s Mode', ... 
        'Christoph''s Mode', ... 
        'Walter''s Mode',...
        '1.9 GeV, Pseudo Single Bunch (0.18, 0.25)    >>> STANDARD USER MODE <<<'
        };
    [ModeNumber, OKFlag] = listdlg('Name','ALS','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 250]);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
    if ModeNumber == 11
        ModeNumber = 99;  % low e
    elseif ModeNumber == 12
        ModeNumber = 101;  % Model
    elseif ModeNumber == 13
        ModeNumber = 999;  % Greg
    elseif ModeNumber == 14
        ModeNumber = 9999; % Tom
    elseif ModeNumber == 15
        ModeNumber = 100;  % Christoph
    elseif ModeNumber == 16
        ModeNumber = 200;  % Walter
    elseif ModeNumber == 17
        ModeNumber = 888;  % PSB
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'ALS';               % Will already be defined if setpathmml was used
AD.SubMachine = 'StorageRing';    % Will already be defined if setpathmml was used
AD.MachineType = 'StorageRing';   % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.PseudoSingleBunch = '';          % Gets filled in later
AD.HarmonicNumber = 328;
AD.BSCRampRate = 0.8;

% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-6;


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.  Setpv will wait
% 2.2 * TuneDelay to be guaranteed a fresh data point.
AD.TuneDelay = 3.0; %this works for Libera based tune measurement with SR Bumps triggering normally
%AD.TuneDelay = 5.0; %use this for old tune measurement system with 5 averages


% BuildOffsetAndGoldenOrbits was here


% SP-AM Error level
% AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
%                       -1 -> SP-AM errors are Matlab warnings
%                       -2 -> SP-AM errors prompt a dialog box
%                       -3 -> SP-AM errors are ignored (ErrorFlag=-1 is returned)
AD.ErrorWarningLevel = 0;


% Set the status of all the corrector on
% This is needed because some operational modes may have changed the .Status field
%setfamilydata(ones(size(family2dev('HCM',0),1),1),'HCM','Status');   Remove the HCM converted to skew quad before uncommenting this.
%setfamilydata(ones(size(family2dev('VCM',0),1),1),'VCM','Status');

%i = findrowindex([3 10; 5 10; 10 10], HCMlist);
% i = findrowindex([5 10], HCMlist);
% AO.HCM.Status(i) = 0;
% i = findrowindex([10 10], HCMlist);
% AO.HCM.Status(i) = 0;

%i = findrowindex([3 10; 5 10; 10 10], VCMlist);
% i = findrowindex([5 10], VCMlist);
% AO.VCM.Status(i) = 0;
% i = findrowindex([10 10], VCMlist);
% AO.VCM.Status(i) = 0;

% Pseudo single bunch (Cam kicker)
AD.PseudoSingleBunch = 0;


%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
AD.PseudoSingleBunch = 'Off';
if ModeNumber == 1
    % User mode - High Tune, Top Off injection
    AD.OperationalMode = '1.9 GeV, TopOff';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.89086196873342;
    ModeName = 'TopOff';
    OpsFileExtension = '_TopOff';

    AD.PseudoSingleBunch = 'Off';   % Special feature

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_124bpms';
    alslat_loco_3sb_disp_nuy9_124bpms;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.6; 1.6];   % Moved up for IVID  ([.4; 1] to .8 h & 1.6 to 1.8 v or [-.6;-1.5] in hardware units)

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

    % Turn off chicane correctors when getting a response matrix
    %setfamilydata(0, 'HCM', 'Status', [6 1;10 8; 11 1]);

elseif ModeNumber == 2
    % High Tune, 1.353 Injection
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.353; %changed during 9-10-07 physics when BR was tuned for higher injection energy - T.Scarvie,C.Steier
    AD.OperationalMode = '1.9 GeV, Inject at 1.353';  % Keep the mode name the same since it's used in srcontrol, etc.
    ModeName = 'HighTune_Inj1p353';
    OpsFileExtension = '_LowEnergyInj';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

    % Turn off chicane correctors when getting a response matrix
    %setfamilydata(0, 'HCM', 'Status', [6 1;10 8; 11 1]);

elseif ModeNumber == 3
    % High Tune, 1.23 Injection
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.230;
    AD.OperationalMode = '1.9 GeV, Inject at 1.23';
    ModeName = 'HighTune_Inj1p230';
    OpsFileExtension = '_LowEnergyInj';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

    % Turn off chicane correctors when getting a response matrix


elseif ModeNumber == 4
    % High Tune, 1.522 Injection
    AD.OperationalMode = '1.9 GeV, High Tune';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'HighTune';
    OpsFileExtension = '_HighTune';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    %AD.ATModel = 'alslat_122bpmsInQuads';
    %alslat_122bpmsInQuads;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

    % Turn off chicane correctors when getting a response matrix
    %setfamilydata(0, 'HCM', 'Status', [6 1;10 8; 11 1]);

elseif ModeNumber == 5
    % 1.9 GeV - Low Tune
    AD.OperationalMode = '1.9 GeV, Low Tune';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'LowTune';
    OpsFileExtension = '_LowTune';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family (This could have been in alsphysdata)
    % 14.25 / 8.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

elseif ModeNumber == 6
        
    % 1.9 GeV, 2-Bunch
    AD.OperationalMode = '1.9 GeV, Two-Bunch';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.89086196873342;  %%% changed to 1.522 for use with old BR Bend supply - 3-17-08 - T.Scarvie
%    AD.InjectionEnergy = 1.522;
    %AD.InjectionEnergy = 1.353;
    ModeName = 'TwoBunch';
    OpsFileExtension = '_TwoBunch';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nux16p18_nuyp25_124bpms.m';
    alslat_loco_3sb_disp_nux16p18_nuyp25_124bpms;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.165
        0.25
        NaN];  
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.8; 1.6];  % New TFB allow to use lower, multibunch chromaticities in two bunch mode (2015-08-05)

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

    % SP-AM Error level
    % AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
    %                       -1 -> SP-AM errors are Matlab warnings
    %                       -2 -> SP-AM errors prompt a dialog box
    %                       -3 -> SP-AM errors are ignored
    AD.ErrorWarningLevel = 0; 
    
elseif ModeNumber == 7
    % 1.5 - High Tune
    AD.OperationalMode = '1.5 GeV, High Tune';
    AD.Energy = 1.522;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.89086196873342;
    ModeName = '1_5HighTune';
    OpsFileExtension = '_15HighTune';

    % AT lattice
%     AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
%     alslat_loco_3sb_disp_nuy9_122bpms;
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_124bpms';
    alslat_loco_3sb_disp_nuy9_124bpms;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Upper';

    switch2hw;

elseif ModeNumber == 8
    % 1.522 GeV, Isochronous Sections
    AD.OperationalMode = '1.5 GeV, Isochronous Sections';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'IsochronousSections';
    OpsFileExtension = '_IsochronousSections';

    if 1
        % AT lattice
        AD.ATModel = 'alslat_isochronous_sections_122bpms';
        alslat_isochronous_sections_122bpms;

        % Golden TUNE is with the TUNE family
        % 8.39 / 7.15
        AO = getao;
        AO.TUNE.Monitor.Golden = [
            0.39
            0.15
            NaN];
        setao(AO);

    else
        AD.ATModel = 'alslat_isochronous_sections_122bpms_2520tune';
        alslat_isochronous_sections_122bpms_2520tune;

        % Golden TUNE is with the TUNE family
        % 8.25 / 7.20
        AO = getao;
        AO.TUNE.Monitor.Golden = [
            0.25
            0.20
            NaN];
        setao(AO);
    end

    AD.Energy = 1.522;
    AD.InjectionEnergy = 1.522;


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];

    % Hysteresis branch
    AD.HysteresisBranch = 'Upper';

    switch2hw;

elseif ModeNumber == 9
    % 1.5 GeV High Tune, 1.353 Injection
    AD.Energy = 1.52322;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.353;
    AD.OperationalMode = '1.5 GeV, Inject at 1.353';
    ModeName = '15_HighTuneLowEnergyInj';
    OpsFileExtension = '_15LowEnergyInj';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    switch2hw;

    % Turn off chicane correctors when getting a response matrix
    %setfamilydata(0, 'HCM', 'Status', [6 1;10 8; 11 1]);

elseif ModeNumber == 10
    % Low Emittance
    AD.OperationalMode = '1.9 GeV, Low Emittance Mode';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.89086196873342;
    ModeName = 'LowEmittance';
    OpsFileExtension = '_LowEmittance';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nux16_124bpms';
    alslat_loco_3sb_disp_nux16_124bpms;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1.0; 1.5];

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

%    AD.TuneDelay = 11.0;
    
    % switch2physics;
    switch2hw;

    % SP-AM Error level
    % AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
    %                       -1 -> SP-AM errors are Matlab warnings
    %                       -2 -> SP-AM errors prompt a dialog box
    %                       -3 -> SP-AM errors are ignored
    AD.ErrorWarningLevel = 0; 

elseif ModeNumber == 888
    % Pseudo single bunch operation mode
    AD.OperationalMode = 'Pseudo-Single Bunch (0.18,0.25)';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.89086196873342;
    %AD.InjectionEnergy = 1.522;

    ModeName = 'PseudoSingleBunch';
    OpsFileExtension = '_LowEmittance';

    % AT lattice
    %AD.ATModel = 'alslat_loco_3sb_disp_nux16p11_nuyp25_122bpms.m';
    %alslat_loco_3sb_disp_nux16p11_nuyp25_122bpms;
    
    %AD.ATModel = 'alslat_loco_3sb_disp_nux16p12_nuyp25_122bpms.m';
    %alslat_loco_3sb_disp_nux16p12_nuyp25_122bpms;
    
    AD.ATModel = 'alslat_loco_3sb_disp_nux16p18_nuyp25_124bpms.m';
    alslat_loco_3sb_disp_nux16p18_nuyp25_124bpms;
    
    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.165
        0.25
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.8; 1.6];

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

%    AD.TuneDelay = 11.0;
    
    % switch2physics;
    switch2hw;

    % SP-AM Error level
    % AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
    %                       -1 -> SP-AM errors are Matlab warnings
    %                       -2 -> SP-AM errors prompt a dialog box
    %                       -3 -> SP-AM errors are ignored
    AD.ErrorWarningLevel = 0; 

    
elseif ModeNumber == 99
    % Low Emittance
    AD.OperationalMode = '1.9 GeV, High Tune Mode';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.89086196873342;
    ModeName = 'LowEmittanceTest';
    OpsFileExtension = '_LowEmittanceTest';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms_nux_16_etax_0';
    alslat_loco_3sb_disp_nuy9_122bpms_nux_16_etax_0;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    AD.TuneDelay = 0.0;

   % switch2physics;
   switch2hw;

    % SP-AM Error level
    % AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
    %                       -1 -> SP-AM errors are Matlab warnings
    %                       -2 -> SP-AM errors prompt a dialog box
    %                       -3 -> SP-AM errors are ignored
    AD.ErrorWarningLevel = 0; 

elseif ModeNumber == 101
    % Model mode
    AD.OperationalMode = '1.9 GeV, Model';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'Model';
    OpsFileExtension = '';

    % AT lattice
    %AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    %alslat_loco_3sb_disp_nuy9_122bpms;

    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms_splitdipole';
    alslat_loco_3sb_disp_nuy9_122bpms_splitdipole;

    % Golden TUNE is with the TUNE family
    % 14.25 / 9.20
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    AD.TuneDelay = 0.0;

    switch2hw;

elseif ModeNumber == 999
    % Greg's mode
    AD.OperationalMode = '1.9 GeV, Greg Mode';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.89086196873342;  %1.522;
    ModeName = 'Greg';
    OpsFileExtension = '';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;
setsp('QF',QFnew,[],0);setsp('QD',QDnew,[],0);setsp('QFA',QFAnew,[],0),;setsp('QDA',QDAnew,[],0);
    %AD.ATModel = 'alslat_MultipleRings';
    %alslat_MultipleRings; %(3);  % Concatenation occurs later

    %AD.ATModel = 'alslat_symp_3sb_disp_ID';
    %alslat_symp_3sb_disp_ID

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units
setsp('QF',QFnew,[],0);setsp('QD',QDnew,[],0);setsp('QFA',QFAnew,[],0),;setsp('QDA',QDAnew,[],0);
    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    AD.TuneDelay = 0.0;

    switch2hw;

    % SP-AM Error level
    % AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
    %                       -1 -> SP-AM errors are Matlab warnings
    %                       -2 -> SP-AM errors prompt a dialog box
    %                       -3 -> SP-AM errors are ignored
    AD.ErrorWarningLevel = 0;

elseif ModeNumber == 9999
    % Tom's mode
    AD.OperationalMode = '1.9 GeV, Tom Mode';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'Tom';
    OpsFileExtension = '';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    AD.TuneDelay = 0.0;

    switch2hw;

elseif ModeNumber == 100
    % Christoph's mode
    AD.OperationalMode = '1.9 GeV, Christoph Mode';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'Christoph';
    OpsFileExtension = '';

    % AT latticesetsp('QF',QFnew,[],0);setsp('QD',QDnew,[],0);setsp('QFA',QFAnew,[],0),;setsp('QDA',QDAnew,[],0);
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];   % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    AD.TuneDelay = 0.0;

    switch2hw;

elseif ModeNumber == 200
    % Walter's mode

    disp('   This mode switches HCM(5,4) & HCM(6,4) to SQSF(5,1) & SQSF(6,1)');

    AD.OperationalMode = '1.9 GeV, Walter Mode';
    AD.Energy = 1.89086196873342;     % Make sure this is the same as bend2gev at the production lattice!
    AD.InjectionEnergy = 1.522;
    ModeName = 'Walter';
    OpsFileExtension = '_HighTune';

    % AT lattice
    AD.ATModel = 'alslat_loco_3sb_disp_nuy9_122bpms';
    alslat_loco_3sb_disp_nuy9_122bpms;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.25
        0.20
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [.4; 1];  % approx.  [-.6;-1.5] in hardware units

    % Hysteresis branch
    AD.HysteresisBranch = 'Lower';

    AD.TuneDelay = 0.0;

    switch2hw;

else
    error('Operational mode unknown');
end


% Set MMLRoot to the standard local path when in standalone mode (must end in a file separator)
% Otherwise it will be set to someplace in the standalone directory location
if isdeployed
    if ispc
        AD.MMLRoot = 'N:\';
    elseif ismac
        AD.MMLRoot = '/Volumes/physbase/';
    else
        AD.MMLRoot = '/home/als/physbase/';
    end
end
setad(AD);

% The offset and golden orbits are stored at the end of this file
BuildOffsetAndGoldenOrbits;  % Local function (note: adds to the AO)


MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;


% ALS specific path changes

% Hysteresis loop files
%if any(ModeNumber == 1)         
if any(ModeNumber == [1 10 999])  
    % On-energy injection needs a different lattice for magnet cycling
    AD.OpsData.HysteresisLoopUpperLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, AD.OpsData.LatticeFile];
    if ModeNumber == 10
        AD.OpsData.HysteresisLoopLowerLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, 'CyclingConfig_LowEmittance'];
    else
        AD.OpsData.HysteresisLoopLowerLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, 'InjectionConfig_HighTune'];
    end
    AD.HysteresisLoopUpperEnergy = AD.Energy;
    AD.HysteresisLoopLowerEnergy = 1.522;
elseif ModeNumber == 7
    % 1.5 GeV injection needs a different lattice for magnet cycling
    % Hysteresis loop files: 1.5 GeV modes use the 1.9 High Tune upper lattice
    %AD.OpsData.HysteresisLoopUpperLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, 'TopOff', filesep, 'GoldenConfig_TopOff'];   % Uses the TopOff mode file
    AD.OpsData.HysteresisLoopUpperLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, AD.OpsData.InjectionFile];
    AD.OpsData.HysteresisLoopLowerLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, AD.OpsData.LatticeFile];
    AD.HysteresisLoopUpperEnergy = 1.89086196873342;
    AD.HysteresisLoopLowerEnergy = 1.522;
elseif any(ModeNumber == [6 888])  % Pseduo-single bunch & Two Bunch modes
    % On-energy injection needs a different lattice for magnet cycling
    AD.OpsData.HysteresisLoopUpperLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, AD.OpsData.LatticeFile];
    AD.OpsData.HysteresisLoopLowerLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, 'CyclingConfig_LowEmittance'];
    
    AD.HysteresisLoopUpperEnergy = AD.Energy;
    AD.HysteresisLoopLowerEnergy = 1.522;
else
    AD.OpsData.HysteresisLoopUpperLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, AD.OpsData.LatticeFile];
    AD.OpsData.HysteresisLoopLowerLattice = [MMLROOT, 'machine', filesep, AD.Machine, filesep, AD.SubMachine, 'OpsData', filesep, ModeName, filesep, AD.OpsData.InjectionFile];
    AD.HysteresisLoopUpperEnergy = AD.Energy;
    AD.HysteresisLoopLowerEnergy = AD.InjectionEnergy;
end

% LTB
AD.OpsData.LFBFile = ['LFBConfig', OpsFileExtension];
AD.Default.LFBArchiveFile = 'LFBConfig';

% TFB
AD.OpsData.TFBFile = ['TFBConfig', OpsFileExtension];
AD.Default.TFBArchiveFile = 'TFBConfig';

% THC
AD.OpsData.THCFile = ['THCConfig', OpsFileExtension];
AD.Default.THCArchiveFile = 'THCConfig';

AD.Default.ChicaneRespFile  = 'ChicaneRespMat'; % File in AD.Directory.BPMResponse    BPM/Chicane response matrice
AD.OpsData.ChicaneRespFile = ['GoldenChicaneResp', OpsFileExtension];
AD.OpsData.RespFiles{length(AD.OpsData.RespFiles)+1} = {[AD.Directory.OpsData, AD.OpsData.ChicaneRespFile]};


% DataRoot Location
% This is a bit of a cluge to know if the user is on the ALS filer
% If so, the location of DataRoot will be different from the middle layer default
if isempty(findstr(lower(MMLROOT),'physbase')) && isempty(findstr(lower(MMLROOT),'n:\'))
    % Keep the normal middle layer directory structure and using the simulator
    OnlineFlag = 0;
    
else
    % Use MMLROOT and DataRoot on the ALS filer
    % If using the ALS filer, I'm assuming you want to be online
    OnlineFlag = 1; 

    if ispc
       %AD.Directory.DataRoot = ['m:\matlab\',                   AD.SubMachine, 'Data', filesep, ModeName, filesep];
        AD.Directory.DataRoot = ['\\als-filer\physdata\matlab\', AD.SubMachine, 'Data', filesep, ModeName, filesep];
    elseif ismac
        AD.Directory.DataRoot = ['/Volumes/physdata/matlab/', AD.SubMachine, 'Data', filesep, ModeName, filesep];        
    else
        AD.Directory.DataRoot = ['/home/als/physdata/matlab/', AD.SubMachine, 'Data', filesep, ModeName, filesep];
    end

    % Data Archive Directories
    AD.Directory.BPMData        = [AD.Directory.DataRoot, 'BPM', filesep];
    AD.Directory.TuneData       = [AD.Directory.DataRoot, 'Tune', filesep];
    AD.Directory.ChroData       = [AD.Directory.DataRoot, 'Chromaticity', filesep];
    AD.Directory.DispData       = [AD.Directory.DataRoot, 'Dispersion', filesep];
    AD.Directory.ConfigData     = [AD.Directory.DataRoot, 'MachineConfig', filesep];
    AD.Directory.LFBData        = [AD.Directory.DataRoot, 'LFB', filesep];
    AD.Directory.TFBData        = [AD.Directory.DataRoot, 'TFB', filesep];
    AD.Directory.THCData        = [AD.Directory.DataRoot, 'THC', filesep];
    AD.Directory.QMS            = [AD.Directory.DataRoot, 'QMS', filesep];

    % Response Matrix Directories
    AD.Directory.BPMResponse    = [AD.Directory.DataRoot, 'Response', filesep, 'BPM', filesep];
    AD.Directory.TuneResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Tune', filesep];
    AD.Directory.ChroResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Chromaticity', filesep];
    AD.Directory.DispResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Dispersion', filesep];
    AD.Directory.SkewResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Skew', filesep];
end
setad(AD);


% This function runs at the end of setmachineconfig & getmachineconfig
AD.setmachineconfigfunction = @setmachineconfig_sr;
AD.getmachineconfigfunction = @setmachineconfig_sr;


% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);
setad(AD);


% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% Set the model energy
setenergymodel(AD.Energy);


% Cavity and radiation
setcavity off;
setradiation off;
fprintf('   Radiation and cavities are off.  Use setradiation / setcavity to modify. \n');


% Momentum compaction factor
try
    %AD.MCF = 0.00137038;  % was 0.0013884;
    MCF = getmcf('Model');
    if isnan(MCF)
        AD.MCF = 8.8195e-004; % was 0.00137038;  % was 0.0013884;
        fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
    else
        AD.MCF = MCF;
        fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
    end
catch
    AD.MCF = 8.8195e-004; % was 0.00137038;  % was 0.0013884;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
end
setad(AD);


if OnlineFlag
    switch2online;
    
    % labca setup
    if islabca
        % Note: for some weird reason, for Matlab 2017b setlabcadefaults must be called after findorbit4(THERING,0) (like in getmcf)!!!???
        setlabcadefaults;
        
        % Time zone difference from UTC [hours]
        try
            % Best to base this on a PV
            AD.TimeZone = gettimezone('cmm:beam_current');
        catch
            AD.TimeZone = gettimezone;
            fprintf('  Time zone difference not based on a PV!\n');
            fprintf('  Set to %.1f hours from UTC.\n', AD.TimeZone);
        end
    else
        % MCA doesn't actually use it.
        AD.TimeZone = -8 + isdaylightsavings;
    end
else
    switch2sim;
    
    % Time zone difference from UTC [hours]
    AD.TimeZone = gettimezone;
end
setad(AD);


%%%%%%%%%%%%%%%%%%%%%%
% Final mode changes %
%%%%%%%%%%%%%%%%%%%%%%
if any(ModeNumber == [1 2 3 4 10])
    % User mode - 1.9 GeV, High Tune

    % Add Gain & Offsets for magnet families (just MML)
    fprintf('   Magnet gains set based on the production lattice settings.\n');
    setgainsandoffsets;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     'Nominal'    - Sets nominal gains (1) / rolls (0) to the model.
    %     'SetGains'   - Set gains/coupling from a LOCO file.
    %     'SetModel'   - Set the model from a LOCO file.  But it only changes
    %                    the part of the model that does not get corrected
    %                    in 'Symmetrize' (also does a SetGains).
    %     'LOCO2Model' - Set the model from a LOCO file (also does a SetGains).
    %                    This uses the LOCO AT model!!! And sets all lattice 
    %                    machines fit in the LOCO run to the model.
    %
    % Basically, use 'SetGains' or 'SetModel' if the LOCO run was applied to the accelerator
    %            use 'LOCO2Model' if the LOCO run was made after the final setup

    % Store the LOCO file in the opsdata directory
    %AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production_72SkewQuads_1Bend'];
    AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production_72SkewQuads_4Bends'];
    setad(AD);

    try
        setlocodata('Nominal');
%        setlocodata('SetGains', AD.OpsData.LOCOFile); % was used before we added BPM [6 11;6 12]
        %setlocodata('SetModel', AD.OpsData.LOCOFile);
        %setlocodata('LOCO2Model', AD.OpsData.LOCOFile);
        %buildramptable;

        % setsp('SQSF', 0, 'Simulator', 'Physics');
        % setsp('SQSD', 0, 'Simulator', 'Physics');
        %
        % setsp('HCM', 0, 'Simulator', 'Physics');
        % setsp('VCM', 0, 'Simulator', 'Physics');
    catch
        fprintf('\n%s\n\n', lasterr);
        fprintf('   WARNING: there was a problem calibrating the model based on LOCO file %s.\n', AD.OpsData.LOCOFile);
    end
    
    % % The Analog monitors have an addition gain from LOCO
    % AO = getao;
    %
    % LOCOGain = AO.HCM.Gain;
    % [Gain, Offset, DeviceList] = HCMMonitorGainOffset;
    % ii = findrowindex(DeviceList, AO.HCM.DeviceList);
    % AO.HCM.Monitor.Gain(ii,:) = LOCOGain(ii,:) .* Gain;
    % AO.HCM.Monitor.Offset(ii,:) = Offset;
    %
    % LOCOGain = AO.VCM.Gain;
    % [Gain, Offset, DeviceList] = VCMMonitorGainOffset;
    % ii = findrowindex(DeviceList, AO.VCM.DeviceList);
    % AO.VCM.Monitor.Gain(ii,:) = LOCOGain(ii,:) .* Gain;
    % AO.VCM.Monitor.Offset(ii,:) = Offset;
    %
    % setao(AO);

elseif ModeNumber == 5
    % 1.9 GeV, Low Tune

    % Add Gain & Offsets for magnet family
    fprintf('   Magnet gains set based on the production lattice settings.\n');
    setgainsandoffsets;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %setlocodata('Nominal');
    %LocoFileDirectory = getfamilydata('Directory','OpsData');
    %setlocodata('SetModel',[LocoFileDirectory,'LocoData']);

    %setsp('SQSF', 0, 'Simulator', 'Physics');
    %setsp('SQSD', 0, 'Simulator', 'Physics');
    %setsp('HCM',  0, 'Simulator', 'Physics');
    %setsp('VCM',  0, 'Simulator', 'Physics');

% elseif ModeNumber == 6
%     % 1.9 GeV, 2-Bunch
% 
%     % Add Gain & Offsets for magnet family
%     fprintf('   Magnet gains set based on the production lattice settings.\n');
%     setgainsandoffsets;
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Add LOCO Parameters to AO and AT-Model %
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     % Store the LOCO file in the opsdata directory
%     %AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LocoData_PostSymmetrize'];
%     %AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production_72SkewQuads_1Bend'];
%     %AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LocoData'];
%     AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production_72SkewQuads_4Bends'];
%     
%     setad(AD);
% 
%     try
%         %setlocodata('SetGains', AD.OpsData.LOCOFile);
%         %setlocodata('SetModel', AD.OpsData.LOCOFile);
%         % setlocodata('LOCO2Model', AD.OpsData.LOCOFile); % was used before we added BPM [6 11;6 12]
%         setlocodata('Nominal');
%         %buildramptable;
% 
%         % setsp('SQSF', 0, 'Simulator', 'Physics');
%         % setsp('SQSD', 0, 'Simulator', 'Physics');
%         %
%         % setsp('HCM', 0, 'Simulator', 'Physics');
%         % setsp('VCM', 0, 'Simulator', 'Physics');
%     catch
%         fprintf('\n%s\n\n', lasterr);
%         fprintf('   WARNING: there was a problem calibrating the model based on LOCO file %s.\n', AD.OpsData.LOCOFile);
%     end
% 
%     
%     %buildramptable;
% 
%     %setsp('SQSF', 0, 'Simulator', 'Physics');
%     %setsp('SQSD', 0, 'Simulator', 'Physics');
%     %setsp('HCM',  0, 'Simulator', 'Physics');
%     %setsp('VCM',  0, 'Simulator', 'Physics');

elseif ModeNumber == 7
    % 1.5 GeV, High Tune
    
    % Add Gain & Offsets for magnet family
    fprintf('   Magnet gains set based on the production lattice settings.\n');
    setgainsandoffsets;

    %SP = getinjectionlattice;
    %SP = rmfield(SP, 'BEND');
    %setmachineconfig(SP, 'Simulator');

    % Set energy in the model
    setenergymodel(1.522);

    %setsp('SQSF', 0, 'Simulator', 'Physics');
    %setsp('SQSD', 0, 'Simulator', 'Physics');
    %setsp('HCM', 0, 'Simulator', 'Physics');
    %setsp('VCM', 0, 'Simulator', 'Physics');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production_72SkewQuads_4Bends'];
    setad(AD);
    try
        %setlocodata('SetGains', AD.OpsData.LOCOFile);
        %setlocodata('SetModel', AD.OpsData.LOCOFile);
        % setlocodata('LOCO2Model', AD.OpsData.LOCOFile);
        setlocodata('Nominal');
        %buildramptable;

        % setsp('SQSF', 0, 'Simulator', 'Physics');
        % setsp('SQSD', 0, 'Simulator', 'Physics');
        %
        % setsp('HCM', 0, 'Simulator', 'Physics');
        % setsp('VCM', 0, 'Simulator', 'Physics');
    catch
        fprintf('\n%s\n\n', lasterr);
        fprintf('   WARNING: there was a problem calibrating the model based on LOCO file %s.\n', AD.OpsData.LOCOFile);
    end

elseif ModeNumber == 8
    % Isochronous Sections

    % Add Gain & Offsets for magnet family
    fprintf('   Magnet gains set based on the production lattice settings.\n');
    setgainsandoffsets;

    % Hysteresis loop files: 1.5 GeV modes use the 1.9 High Tune upper lattice
    AD = getad;
    AD.OpsData.HysteresisLoopUpperLattice = [MMLROOT, 'machine', filesep, 'ALS', filesep, 'StorageRingOpsData', filesep, 'HighTune', filesep, 'GoldenConfig_HighTune'];
    setad(AD);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Change the response matrix kicks

    % Start with nominal gains
    setlocodata('Nominal');

    AO = getao;
    AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', .15e-3 / 3 / 1, AO.HCM.DeviceList);
    AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', .15e-3 / 3 / 2, AO.VCM.DeviceList);
    %AO.HCM.Setpoint.DeltaRespMat = AO.HCM.Setpoint.DeltaRespMat/4;
    %AO.VCM.Setpoint.DeltaRespMat = AO.VCM.Setpoint.DeltaRespMat/4;
    setao(AO);

    setfamilydata(200e-6,'DeltaRFDisp');


    % Set the gains from LOCO data
    LocoFileDirectory = getfamilydata('Directory','OpsData');
    setlocodata('SetGains',[LocoFileDirectory,'LocoData_IsochronousSections']);

    %     %setenergy(1.522,'Simulator');
    %     %setsp('BEND', gev2bend(1.522), 'Simulator');
    %     SP = getinjectionlattice;
    %     SP = rmfield(SP, 'BEND');

    % Set energy in the model
    setenergymodel(1.522);
    setfamilydata(1.522, 'Energy');

    %     setmachineconfig(SP, 'Simulator');
    %
    %     %setsp('SQSF', 0, 'Simulator', 'Physics');
    %     %setsp('SQSD', 0, 'Simulator', 'Physics');
    %     setsp('HCM', 0, 'Simulator', 'Physics');
    %     setsp('VCM', 0, 'Simulator', 'Physics');

elseif ModeNumber == 99
    % Low Emittance Study (Sextupole upgrade)

    % Activate all HCMs
%    Status = getfamilydata('HCM', 'Status');
%    setfamilydata(ones(size(Status)), 'HCM', 'Status');

    % Set gains, offsets, and golden values
    %setlocodata('Nominal');
%    setfamilydata(0,'BPMx','Offset');
%    setfamilydata(0,'BPMy','Offset');
%    setfamilydata(0,'BPMx','Golden');
%    setfamilydata(0,'BPMy','Golden');

    setfamilydata(0,'TuneDelay');

    setsp('SQSF', 0, 'Simulator', 'Physics');
    setsp('SQSD', 0, 'Simulator', 'Physics');
    %setsp('HCM',  0, 'Simulator', 'Physics');
    %setsp('VCM',  0, 'Simulator', 'Physics');

    % Remove power supply limits
    setfamilydata([-Inf Inf], 'QFA', 'Setpoint', 'Range');
    setfamilydata([-Inf Inf], 'QF', 'Setpoint', 'Range');
    setfamilydata([-Inf Inf], 'QD', 'Setpoint', 'Range');
    setfamilydata([-Inf Inf], 'SF', 'Setpoint', 'Range');
    setfamilydata([-Inf Inf], 'SD', 'Setpoint', 'Range');

    % Default to simulator mode
    switch2sim;

elseif ModeNumber == 101
    % Model mode

    % Activate all HCMs
    Status = getfamilydata('HCM', 'Status');
    setfamilydata(ones(size(Status)), 'HCM', 'Status');

    % Set gains, offsets, and golden values
    setlocodata('Nominal');
    setfamilydata(0,'BPMx','Offset');
    setfamilydata(0,'BPMy','Offset');
    setfamilydata(0,'BPMx','Golden');
    setfamilydata(0,'BPMy','Golden');

    setfamilydata(0,'TuneDelay');

    setsp('SQSF', 0, 'Simulator', 'Physics');
    setsp('SQSD', 0, 'Simulator', 'Physics');
    setsp('HCM',  0, 'Simulator', 'Physics');
    setsp('VCM',  0, 'Simulator', 'Physics');

    % Default to simulator mode
    switch2sim;

elseif ModeNumber == 999
    % Greg's mode

    % Add Gain & Offsets for magnet family
    fprintf('   Magnet gains set based on the production lattice settings.\n');
    setgainsandoffsets;

    % Calibrate lattice to the 1.9 TopOff loco run (this changes the model, no source points)
    %OpsDataDirectory = getfamilydata('Directory','OpsData');
    %i = strfind(OpsDataDirectory, 'Greg');
    %LOCODirectory = [OpsDataDirectory(1:i(1)-1), 'TopOff', OpsDataDirectory(i(1)+4)];
    %AD.OpsData.LOCOFile = [LOCODirectory, 'LOCO_Production_72SkewQuads_4Bends'];
    %setlocodata('LOCO2Model', AD.OpsData.LOCOFile);

    % On the 2010-05-09 libera shift the gaps were openned with tune compensation on
    %load DeltaQuad
    %stepsp('QD',-1*delQD);
    %stepsp('QF',-1*delQF);

    % For the pseudo single bunch operations, concatenate rings
%    concatenaterings(3);
    
    % SP = getproductionlattice;
    % SP = rmfield(SP, 'BEND');
    % SP = rmfield(SP, 'RF');
    % SP = rmfield(SP, 'HCMCHICANE');
    % SP = rmfield(SP, 'VCMCHICANE');
    % SP = rmfield(SP, 'HCMCHICANEM');
    % setmachineconfig(SP, 'Simulator');
    
    AD = getad;
    AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production_72SkewQuads_4Bends'];
    setad(AD);
    
    try
        setlocodata('SetGains', AD.OpsData.LOCOFile);
        %setlocodata('SetModel', AD.OpsData.LOCOFile);
        %setlocodata('LOCO2Model', AD.OpsData.LOCOFile);  % Note changes the AT model
        %buildramptable;
        
        % setsp('SQSF', 0, 'Simulator', 'Physics');
        % setsp('SQSD', 0, 'Simulator', 'Physics');
        %
        % setsp('HCM', 0, 'Simulator', 'Physics');
        % setsp('VCM', 0, 'Simulator', 'Physics');
    catch
        fprintf('\n%s\n\n', lasterr);
        fprintf('   WARNING: there was a problem calibrating the model based on LOCO file %s.\n', AD.OpsData.LOCOFile);
    end
    
elseif ModeNumber == 200
    % Walter's mode
    LocoFileDirectory = getfamilydata('Directory','OpsData');
    setlocodata('SetGains',[LocoFileDirectory,'LocoData']);
    
elseif (ModeNumber == 888) || (ModeNumber == 6)
    % User mode - 1.9 GeV, Pseudo-single bunch or Two bunch modes

    % Add Gain & Offsets for magnet families (just MML)
    fprintf('   Magnet gains set based on the production lattice settings.\n');
    setgainsandoffsets;

    %AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production_72SkewQuads_1Bend'];
 
    AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production'];
    setad(AD);

    try
        setlocodata('SetGains', AD.OpsData.LOCOFile);
        setlocodata('Nominal'); %need BPM gains of 1 and coupling terms of zero for LOCO data analysis to work properly. 2-23-15, C.Steier & T.Scarvie
        %setlocodata('SetModel', AD.OpsData.LOCOFile);
        %setlocodata('LOCO2Model', AD.OpsData.LOCOFile);
        %buildramptable;

        % setsp('SQSF', 0, 'Simulator', 'Physics');
        % setsp('SQSD', 0, 'Simulator', 'Physics');
        %
        % setsp('HCM', 0, 'Simulator', 'Physics');
        % setsp('VCM', 0, 'Simulator', 'Physics');
    catch
        fprintf('\n%s\n\n', lasterr);
        fprintf('   WARNING: there was a problem calibrating the model based on LOCO file %s.\n', AD.OpsData.LOCOFile);
    end
    
%     if isunix
%         addpath('/home/als/physbase/users/csun/script');
%     elseif ispc
%         addpath('\\als-filer\als\physbase\users\csun\script');
%     end
    
else
    % Add Gain & Offsets for magnet family
    fprintf('   Magnet gains set based on the production lattice settings.\n');
    setgainsandoffsets;

    setlocodata('Nominal');
    %LocoFileDirectory = getfamilydata('Directory','OpsData');
    %setlocodata('SetModel',[LocoFileDirectory,'LocoData_PostSymmetrize']);
    %setlocodata('SetModel',[LocoFileDirectory,'LocoData']);
end



% Build a new ramp table to force the present AT-model
% to be matched to the production and injection lattice files
%buildramptable;
fprintf('   Remember to run buildramptable if the production and/or injection\n');
fprintf('   lattice files have changed or if the AT lattice has changed.\n');


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);


% commented out the lines below so that compiled apps won't always set
% SR_mode to whatever it was when they were compiled

% try
%     setpv('SR_mode',AD.OperationalMode);
% catch
%     disp('  Trouble setting mode string to SR_mode');
% end



function BuildOffsetAndGoldenOrbits

% NOTE: 1. You can view this by >> help setoperationalmode>BuildOffsetAndGoldenOrbits
%
% if ispc
%     Directory = '\\als-filer\matlab\StorageRingData\PseudoSingleBunch\QMS\';
% else
%     Directory = '/home/als/physdata/matlab/StorageRingData/PseudoSingleBunch/QMS/';
% end
% 
% [x1, y1, BPMxFamily, QUADxFamily, BPMyFamily, QUADyFamily, DateMatX, DateMatY] = quadplotall(fullfile(Directory, '2015-12-19_All'));
% [x1, y1, BPMxFamily, QUADxFamily, BPMyFamily, QUADyFamily, DateMatX, DateMatY] = quadplotall(fullfile(Directory, '2016-01-05_All'));
% OffsetNew = [OffsetNew(:,1:2) NaN*ones(124,2) OffsetNew(:,3:end)];
% i = findrowindex(x1(:,1:2), OffsetNew(:,1:2));
% OffsetNew(i,3) = x1(:,3);
% i = findrowindex(y1(:,1:2), OffsetNew(:,1:2));
% OffsetNew(i,4) = y1(:,3);


% First save on Jan 6, 2016
% File /home/als/physbase/machine/ALS/StorageRingOpsData/PseudoSingleBunch/GoldenBPMResp_LowEmittance.mat backup to /home/als/physdata/matlab/StorageRingData/PseudoSingleBunch/Backup/2016-01-06_20-26-06_GoldenBPMResp_LowEmittance.mat
% File /home/physdata/matlab/StorageRingData/PseudoSingleBunch/Response/BPM/BPMRespMat_2016-01-06_20-13-04.mat copied to /home/als/physbase/machine/ALS/StorageRingOpsData/PseudoSingleBunch/GoldenBPMResp_LowEmittance.mat


%                          2017-03-14          2016-01-06          2015-12-19          2014-07-5
%                          X        Y          X        Y          X        Y          X       Y
OffsetNew = [
    1.0000    2.0000   -0.1887    0.9931   -0.2402    0.8317   -0.1182    0.9236   -0.1991    0.9674
    1.0000    3.0000    0.2036    0.1980   -0.0136    0.1199    0.1161    0.1592   -0.0391    0.0762
    1.0000    4.0000       NaN   -0.4407       NaN   -0.0894       NaN       NaN       NaN   -0.2852
    1.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    1.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    1.0000    7.0000       NaN    0.0216       NaN    0.1579       NaN       NaN       NaN       NaN
    1.0000    8.0000   -0.1162    0.2436   -0.0354    0.4548   -0.0377    0.5105   -0.0578    0.4095
    1.0000    9.0000    0.1221   -0.6004   -0.0460   -1.0186    0.0081   -0.9339    0.0563   -0.3307
    1.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    2.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    2.0000    2.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    2.0000    3.0000    0.0677   -0.8405    0.1380   -0.6194    0.1178   -0.6523    0.0634   -0.7153
    2.0000    4.0000       NaN    0.0473       NaN    0.0558       NaN       NaN       NaN    0.2067
    2.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    2.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    2.0000    7.0000       NaN   -0.1350       NaN   -0.1786       NaN       NaN       NaN   -0.1190
    2.0000    8.0000   -0.4284   -0.1995   -0.7911   -0.8026   -0.8136   -0.8428   -0.3764    0.5483
    2.0000    9.0000    0.2445    0.8578    0.2417    0.7293    0.2908    0.6703    0.2786    0.6398
    3.0000    2.0000   -0.0858    0.2033   -0.1404    0.1450   -0.1102    0.0772   -0.1893    0.1863
    3.0000    3.0000    0.3614   -0.1987    0.3763   -0.2437    0.4669   -0.2479       NaN       NaN
    3.0000    4.0000       NaN   -0.5846       NaN   -0.4838       NaN       NaN       NaN   -0.5372
    3.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    3.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    3.0000    7.0000       NaN    0.1088       NaN    0.4952       NaN       NaN       NaN    0.0628
    3.0000    8.0000    0.0647   -0.0673    0.3200   -0.0455    0.3634    0.0090    0.5097   -0.4683
    3.0000    9.0000    0.1729   -0.1563    0.3807   -0.4482    0.5036   -0.3217    0.1000    0.0490
    3.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    3.0000   11.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    3.0000   12.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    4.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    4.0000    2.0000   -0.1164    0.9434       NaN       NaN       NaN       NaN       NaN       NaN
    4.0000    3.0000   -0.6493    0.2050   -0.5196    0.1566   -0.3455    0.1421   -0.4058    0.1844
    4.0000    4.0000       NaN    0.3408       NaN    0.1253       NaN       NaN       NaN    0.2991
    4.0000    5.0000   -0.3506   -0.2546    0.0869   -0.3067    0.0457   -0.2841    0.0796   -0.1908
    4.0000    6.0000    0.3917    0.3913    0.7591    0.3733   -4.1769    5.9073    0.9268    0.4595
    4.0000    7.0000       NaN   -0.0490       NaN   -0.1520       NaN       NaN       NaN   -0.5225
    4.0000    8.0000   -0.5097    0.2872   -0.5416   -0.2090   -0.4686   -0.1704   -0.1196    0.4609
    4.0000    9.0000   -0.1140    0.4318    0.5101    0.3913    0.6012    0.4376   -0.1386    0.4992
    4.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    5.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    5.0000    2.0000   -0.3032    0.2940   -0.3539    0.3835   -0.3113    0.2456   -0.2856    0.2219
    5.0000    3.0000    0.0389    0.2947   -0.1113    0.3133   -0.1464    0.2715    0.1800    0.2751
    5.0000    4.0000       NaN   -1.2466       NaN    0.0946       NaN       NaN       NaN   -0.0341
    5.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    5.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    5.0000    7.0000       NaN    0.1447       NaN    0.2577       NaN       NaN       NaN   -0.0137
    5.0000    8.0000   -0.5261   -0.0813   -0.1274   -0.2007   -0.0723   -0.1422   -0.2445   -0.0130
    5.0000    9.0000   -0.0901    0.2214   -0.2324    0.0222   -0.1126    0.0280   -0.0571    0.1496
    5.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    5.0000   11.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    5.0000   12.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    6.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    6.0000    2.0000   -0.5991   -0.0458   -0.4681   -0.1428   -0.4798   -0.2106   -0.5414   -0.0679
    6.0000    3.0000   -0.5217    0.3208   -0.2520    0.3019   -0.1291    0.2722   -0.3140    0.3977
    6.0000    4.0000       NaN    0.4971       NaN    0.2186       NaN       NaN       NaN    0.4631
    6.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    6.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    6.0000    7.0000       NaN   -0.2234       NaN   -0.2507       NaN       NaN       NaN   -0.3455
    6.0000    8.0000    0.0644    0.5099    0.4584    0.8786    0.4764    0.8364    0.1598    0.6819
    6.0000    9.0000    0.0660    0.1733    0.3279   -0.1360    0.4103   -0.1384    0.1597    0.1553
    6.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    6.0000   11.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    6.0000   12.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    7.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    7.0000    2.0000    0.1884    0.0224    0.0492    0.1753    0.1649    0.1050    0.3645   -0.1396
    7.0000    3.0000   -0.1829    0.3651   -0.0272   -0.3165   -0.0217   -0.3435    0.1098    0.3946
    7.0000    4.0000       NaN    0.4254       NaN    0.3426       NaN       NaN       NaN    0.1943
    7.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    7.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    7.0000    7.0000       NaN    0.4081       NaN    0.3970       NaN       NaN       NaN    0.5316
    7.0000    8.0000   -0.1943    0.4091   -0.1925    0.0845   -0.2073    0.0782    0.0271    0.3116
    7.0000    9.0000    0.0914    0.1048   -0.1429   -0.4271   -0.0522   -0.4811   -0.0061    0.1632
    7.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    8.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    8.0000    2.0000   -0.4937    0.4415   -0.5621   -0.0555   -0.4625   -0.0096   -0.4500    0.5623
    8.0000    3.0000   -0.7030    0.6046   -0.8348   -0.0592   -0.8528   -0.0021   -0.7335    0.5420
    8.0000    4.0000       NaN    0.0326       NaN    0.0620       NaN       NaN       NaN   -0.0794
    8.0000    5.0000    0.1028    0.3264    0.1519    0.3324   -0.0086    0.2702   -0.0034    0.4001
    8.0000    6.0000   -0.1584    0.3095   -0.1385    0.3269   -0.0079    0.2474   -0.0300    0.1959
    8.0000    7.0000       NaN    0.3258       NaN    0.4929       NaN       NaN       NaN    0.3170
    8.0000    8.0000   -0.2820    1.2543    0.0253    0.7103    0.0821    0.7487    0.0168    1.2430
    8.0000    9.0000    0.1493    1.0890    0.6893    0.5699    0.7769    0.5432    0.2716    1.2511
    8.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    9.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    9.0000    2.0000   -0.2276   -0.1778    0.5585   -0.2289    0.5840   -0.1173   -0.2166   -0.0296
    9.0000    3.0000    0.0647    0.4465    0.2383    0.7088    0.3793    0.7172    0.2521    0.7283
    9.0000    4.0000       NaN    0.1024       NaN   -0.3052       NaN       NaN       NaN    0.2267
    9.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    9.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
    9.0000    7.0000       NaN    0.6417       NaN    0.4323       NaN       NaN       NaN    0.5962
    9.0000    8.0000    0.0615    0.0294    0.1061   -0.0282    0.1077   -0.1380       NaN       NaN
    9.0000    9.0000    0.6253    0.0667    0.9433   -0.4258    1.1354   -0.4159    0.6328    0.0535
    9.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
   10.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
   10.0000    2.0000    0.1486   -0.8060   -0.0187   -1.3585    0.0173   -1.2850    0.2024   -0.7271
   10.0000    3.0000   -0.4701    0.0670   -0.6725   -0.3691   -0.5789   -0.3550   -0.3095    0.2992
   10.0000    4.0000       NaN    0.0892       NaN    0.3135       NaN       NaN       NaN    0.3716
   10.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
   10.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
   10.0000    7.0000       NaN   -0.3134       NaN   -0.3221       NaN       NaN       NaN   -0.4031
   10.0000    8.0000    0.0670    0.3952    1.1609   -0.0565    1.3219   -0.0567    0.0211    0.4974
   10.0000    9.0000   -0.1439   -0.1611   -0.5792   -0.1556   -0.5147   -0.1813    0.1475   -0.1015
   10.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
   10.0000   11.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
   10.0000   12.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
   11.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
   11.0000    2.0000    0.1334    0.0320    0.0852   -0.0401    0.2158    0.0142    0.3000   -0.0279
   11.0000    3.0000   -0.4268   -0.1038   -0.4014    0.1272   -0.3725    0.2282   -0.4320    0.1385
   11.0000    4.0000       NaN   -0.3696       NaN   -0.2834       NaN       NaN       NaN   -0.7321
   11.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
   11.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
   11.0000    7.0000       NaN   -0.1184       NaN   -0.2998       NaN       NaN       NaN   -0.1488
   11.0000    8.0000    0.1577    0.2793    0.2249    0.2093    0.2566    0.1667    0.4145    0.0198
   11.0000    9.0000   -0.0932    0.4184    0.0359    0.1994    0.0919    0.2447   -0.0066    0.3804
   11.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
   12.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN
   12.0000    2.0000    0.1495    0.2088    0.2392   -0.1054    0.2854   -0.1227    0.4210   -0.2595
   12.0000    3.0000    0.2118   -1.1545    0.7532   -1.7506    0.8242   -1.7185    0.4385   -1.2913
   12.0000    4.0000       NaN   -1.3090       NaN   -0.2986       NaN       NaN       NaN   -1.7462
   12.0000    5.0000   -0.4604   -0.6978   -0.3663   -0.7260   -0.4035   -0.6966   -0.4774   -0.6488
   12.0000    6.0000    0.3219   -0.0989    0.3214   -0.1366    0.2727   -0.0539    0.5952   -0.0490
   12.0000    7.0000       NaN   -0.0787       NaN   -0.5508       NaN       NaN       NaN   -0.0166
   12.0000    8.0000   -0.3743    0.1322   -0.3138    0.2470   -0.2084    0.2112   -0.2687    0.0901
   12.0000    9.0000    0.3764   -0.2641    0.3834   -0.1790    0.4898   -0.2684    0.4130   -0.2999
   ];
Offset = OffsetNew(:,1:4);


% % Changes for the 2014-07-5 dataset
% i = findrowindex([ 3 9],Offset(:,1:2));
% Offset(i,3) = .1;
% i = findrowindex([ 8 2],Offset(:,1:2));
% Offset(i,3) = -.45;
% i = findrowindex([11 2],Offset(:,1:2));
% Offset(i,3) = .3;


% % Offsets measured by beam-based alignment 2013-03-29&30
% Offset = [
%     1.0000    2.0000    0.2505    0.9651
%     1.0000    3.0000    0.2620    0.1449
%     1.0000    4.0000    0.2556   -0.0178
%     1.0000    5.0000       NaN       NaN
%     1.0000    6.0000    0.6243    0.0033
%     1.0000    7.0000       NaN       NaN
%     1.0000    8.0000   -0.1194   -0.2701
%     1.0000    9.0000       NaN       NaN
%     1.0000   10.0000       NaN       NaN
%     2.0000    1.0000       NaN       NaN
%     2.0000    2.0000    0.4982   -0.2192
%     2.0000    3.0000    0.2218    0.1231
%     2.0000    4.0000    0.0605   -0.2002
%     2.0000    5.0000       NaN       NaN
%     2.0000    6.0000       NaN       NaN
%     2.0000    7.0000    0.2161   -0.3129
%     2.0000    8.0000    0.2437   -0.2356
%     2.0000    9.0000    0.1777    0.5158
%     3.0000    2.0000   -0.0378    0.2464
%     3.0000    3.0000    0.4105    0.2117
%     3.0000    4.0000    0.3058   -0.4014
%     3.0000    5.0000       NaN       NaN
%     3.0000    6.0000       NaN       NaN
%     3.0000    7.0000    0.6887   -0.0903
%     3.0000    8.0000    0.0680    0.4283
%     3.0000    9.0000    0.4696    0.0391
%     3.0000   10.0000       NaN       NaN
%     3.0000   11.0000       NaN       NaN
%     3.0000   12.0000       NaN       NaN
%     4.0000    1.0000       NaN       NaN
%     4.0000    2.0000   -0.2062    1.0297
%     4.0000    3.0000    0.5285   -0.3291
%     4.0000    4.0000    0.2322    0.2202
%     4.0000    5.0000   -0.1315   -0.2642
%     4.0000    6.0000    0.7767    0.4748
%     4.0000    7.0000   -0.1016   -0.5857
%     4.0000    8.0000   -0.6493   -0.0102
%     4.0000    9.0000   -0.4362   -0.3228
%     4.0000   10.0000       NaN       NaN
%     5.0000    1.0000       NaN       NaN
%     5.0000    2.0000    0.3526    0.4225
%     5.0000    3.0000    0.1459    0.4983
%     5.0000    4.0000   -0.1126    0.2223
%     5.0000    5.0000       NaN       NaN
%     5.0000    6.0000       NaN       NaN
%     5.0000    7.0000   -0.2984   -0.1684
%     5.0000    8.0000       NaN       NaN
%     5.0000    9.0000    0.4916    0.8940
%     5.0000   10.0000       NaN       NaN
%     5.0000   11.0000       NaN       NaN
%     5.0000   12.0000       NaN       NaN
%     6.0000    1.0000       NaN       NaN
%     6.0000    2.0000   -0.1248    0.1717
%     6.0000    3.0000    0.5258    0.0092
%     6.0000    4.0000   -0.0437    0.2032
%     6.0000    5.0000       NaN       NaN
%     6.0000    6.0000       NaN       NaN
%     6.0000    7.0000    0.5457   -0.0055
%     6.0000    8.0000    0.1291    0.6998
%     6.0000    9.0000   -0.2375    0.7977
%     6.0000   10.0000       NaN       NaN
%     6.0000   11.0000       NaN       NaN
%     6.0000   12.0000       NaN       NaN
%     7.0000    1.0000       NaN       NaN
%     7.0000    2.0000    0.3283    0.3060
%     7.0000    3.0000    0.2951    0.4696
%     7.0000    4.0000   -0.1758    0.2780
%     7.0000    5.0000       NaN       NaN
%     7.0000    6.0000       NaN       NaN
%     7.0000    7.0000    0.0874    0.6938
%     7.0000    8.0000    0.4329    0.7781
%     7.0000    9.0000   -0.4430   -0.5874
%     7.0000   10.0000       NaN       NaN
%     8.0000    1.0000       NaN       NaN
%     8.0000    2.0000   -0.0204    0.0506
%     8.0000    3.0000    0.6369   -0.2757
%     8.0000    4.0000   -0.8993   -0.0853
%     8.0000    5.0000   -0.2648    0.3217
%     8.0000    6.0000   -0.1954    0.2306
%     8.0000    7.0000    0.8263    0.4893
%     8.0000    8.0000    0.0863    1.6678
%     8.0000    9.0000   -1.5779   -0.4538
%     8.0000   10.0000       NaN       NaN
%     9.0000    1.0000       NaN       NaN
%     9.0000    2.0000    0.6168    0.1111
%     9.0000    3.0000    0.3264    0.4933
%     9.0000    4.0000    0.0394    0.3078
%     9.0000    5.0000       NaN       NaN
%     9.0000    6.0000       NaN       NaN
%     9.0000    7.0000    0.1897    0.7811
%     9.0000    8.0000    1.1958    0.2883
%     9.0000    9.0000    0.8835    0.1940
%     9.0000   10.0000       NaN       NaN
%    10.0000    1.0000       NaN       NaN
%    10.0000    2.0000    0.4612   -1.2896
%    10.0000    3.0000   -0.0021    0.1006
%    10.0000    4.0000    0.1247    0.2628
%    10.0000    5.0000       NaN       NaN
%    10.0000    6.0000       NaN       NaN
%    10.0000    7.0000    0.6568   -0.3282
%    10.0000    8.0000    0.6435    0.5139
%    10.0000    9.0000    1.1755       NaN
%    10.0000   10.0000       NaN       NaN
%    10.0000   11.0000       NaN       NaN
%    10.0000   12.0000       NaN       NaN
%    11.0000    1.0000       NaN       NaN
%    11.0000    2.0000    0.8499   -0.1153
%    11.0000    3.0000    0.2697    0.6344
%    11.0000    4.0000    0.8528   -0.6068
%    11.0000    5.0000       NaN       NaN
%    11.0000    6.0000       NaN       NaN
%    11.0000    7.0000    0.4807   -0.1020
%    11.0000    8.0000   -0.0415    0.0144
%    11.0000    9.0000       NaN       NaN
%    11.0000   10.0000       NaN       NaN
%    12.0000    1.0000       NaN       NaN
%    12.0000    2.0000    0.2143   -1.2292
%    12.0000    3.0000    0.2701   -0.0378
%    12.0000    4.0000    0.9362   -1.7041
%    12.0000    5.0000   -0.8084   -0.6355
%    12.0000    6.0000    0.4212   -0.1115
%    12.0000    7.0000    0.2553   -0.2449
%    12.0000    8.0000    1.4338   -0.3936
%    12.0000    9.0000    0.4232   -0.1301
% ];


%                         2011-08-04/5          2009-10-01          2008-06-04          2007-06-15          2007-01-06          2005-05-12
%      DeviceList         X          Y          X         Y         X         Y         X         Y         X         Y         X         Y
% Offset = [
%     1.0000    2.0000   -0.0447    1.0038    0.2173    1.0177   -0.1198    1.0236   -0.1540    1.0386   -0.3029    0.9601   -0.3332    0.9621
%     1.0000    3.0000    0.1452   -0.0527    0.5368   -0.0182    0.1969    0.0141   -0.1214   -0.3793   -0.0804   -0.1250   -0.0213   -0.1887
%     1.0000    4.0000       NaN   -0.1439       NaN   -0.1105       NaN   -0.0656    0.1899   -0.2022    0.6410   -0.2695    0.6410   -0.7228
%     1.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.3117    1.2317   -0.3117    1.2317
%     1.0000    6.0000       NaN       NaN       NaN    0.0755       NaN       NaN       NaN       NaN    0.2868    0.1347    0.2868    0.1347
%     1.0000    7.0000       NaN       NaN       NaN       NaN       NaN    0.0142   -0.0219   -0.0720    0.1294   -0.3856    0.1294    0.2557
%     1.0000    8.0000   -0.2260   -0.3659    0.1660   -0.4230   -0.2819   -0.1573   -0.1808   -0.2673   -0.2606   -0.3423   -0.2235   -0.1922
%     1.0000    9.0000    0.3453    0.1430    0.5065    0.4165    0.2516    0.4336    0.0986    0.2805   -0.0144    0.3451   -0.0639    0.3583
%     1.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    1.4372   -0.1518    1.4372   -0.1518
%     2.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.3365    0.0489    0.3365    0.0489
%     2.0000    2.0000    0.4821   -0.6072    0.7117   -0.5244    0.4304   -0.4414    0.3321   -0.6269    0.3349   -0.4719    0.3029   -0.4988
%     2.0000    3.0000    0.2969    0.1452    0.6877    0.3499    0.4084    0.3753    0.2252    0.2625    0.3260    0.2452    0.2920    0.1946
%     2.0000    4.0000       NaN   -0.1263       NaN   -0.1895       NaN   -0.1013    0.0382   -0.1314    0.3743   -0.1043    0.3743    0.5221
%     2.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.0128   -0.0542   -0.0128   -0.0542
%     2.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    1.0025   -1.0075    1.0025   -1.0075
%     2.0000    7.0000       NaN   -0.1676       NaN   -0.0703       NaN   -0.2359    0.1653   -0.2635   -0.0173   -0.2703   -0.0173    0.5229
%     2.0000    8.0000    0.1884   -0.2257    0.6111   -0.7221    0.1839   -0.0829    0.0736   -0.3550    0.1902   -0.2211    0.2433   -0.1423
%     2.0000    9.0000    0.2121    0.5292    0.3612    0.5136    0.1371    0.4968   -0.0113    0.3960   -0.2460    0.3486   -0.1620    0.2160
%     3.0000    2.0000   -0.0689    0.1913    0.0693    0.1990   -0.1181    0.1733   -0.2045    0.1067   -0.3086    0.0952   -0.2826    0.1080
%     3.0000    3.0000    0.4239    0.2700    0.9094    0.3879    0.4289    0.3250    0.2871    0.2895    0.3677    0.3745    0.3313    0.3497
%     3.0000    4.0000       NaN   -0.4781       NaN   -0.4517       NaN   -0.4011    0.3965   -0.3447   -0.3568   -0.8973   -0.3568    0.2155
%     3.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.0402    0.0603   -0.0402    0.0603
%     3.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.2722    0.0824    0.2722    0.0824
%     3.0000    7.0000       NaN   -0.0607       NaN   -0.0420       NaN   -0.1148    0.7024   -0.1234    0.3131   -0.3190    0.3131    0.7647
%     3.0000    8.0000    0.0834    0.4625    0.2708    0.5466   -0.1856    0.4579   -0.0985    0.4559   -0.1004    0.5151    0.0275    0.5267
%     3.0000    9.0000    0.6494   -0.0611    0.7548    0.1501    0.3552    0.5019    0.5186   -0.0231    0.4228    0.1727    0.4782    0.0919
%     3.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.7001    0.2774    0.7001    0.2774
%     3.0000   11.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.5243   -0.4578   -0.5243   -0.4578
%     3.0000   12.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.1391    0.0454   -0.1391    0.0454
%     4.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.9000    0.8040    0.9000    0.8040
%     4.0000    2.0000   -0.1812    0.9117   -0.0750    1.0126   -0.1051    0.9750   -0.2236    0.9806   -0.2389    0.9517   -0.2736    1.0024
%     4.0000    3.0000    0.5714   -0.3457    1.1842   -0.4191    0.6024   -0.4900    0.6484   -0.3606    0.5399   -0.3708    0.5481   -0.3316
%     4.0000    4.0000       NaN    0.2675       NaN    0.2154       NaN    0.4393    0.2514    0.2447   -0.6150    0.4217   -0.6150    0.2945
%     4.0000    5.0000    0.0727   -0.2756    0.2444   -0.3007   -0.1373   -0.2723   -0.0899   -0.1984    0.1066   -0.1455   -0.1270    0.1668
%     4.0000    6.0000    0.9577    0.4472    1.0418    0.4573    0.9022    0.4704    0.9520    0.3985    1.0549    0.5268    0.8027    0.7899
%     4.0000    7.0000       NaN   -0.7056       NaN   -0.5846       NaN   -0.7539   -0.0272   -0.8070   -0.5092   -0.2730   -0.5092    0.1823
%     4.0000    8.0000   -0.5503    0.2395   -0.2489    0.5815   -0.5884    0.6205   -0.6642    0.3888   -0.6119    0.6313   -0.4890    0.5291
%     4.0000    9.0000   -0.3899   -0.3108   -0.1996   -0.4021   -0.2841   -0.3300   -0.6090   -0.3532   -0.5624   -0.3060   -0.4998   -0.3415
%     4.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.4352    1.3991   -0.4352    1.3991
%     5.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.6527    0.2707    0.6527    0.2707
%     5.0000    2.0000    0.3686    0.5343   -0.5106    0.6277    0.1048    0.6311   -0.0489    0.6029    0.0368    0.6351   -0.0318    0.6071
%     5.0000    3.0000    0.1335    0.5520    0.2641    0.6958    0.1813    0.5786    0.1164    0.5500    0.2613    0.5279    0.1690    0.4812
%     5.0000    4.0000       NaN    0.3711       NaN    0.2788       NaN    0.3754   -0.0824    0.4140   -0.2422    0.1545   -0.2422    0.6403
%     5.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.3649    0.5744   -0.3649    0.5744
%     5.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.3961    0.5409   -0.3961    0.5409
%     5.0000    7.0000       NaN   -0.3522       NaN   -0.3501       NaN   -0.6321   -0.2576   -0.8496    0.1861   -0.6341    0.1861    0.4875
%     5.0000    8.0000   -0.4311    0.5085   -0.4154    0.5875   -0.5469    0.6792   -0.5953    0.6480   -0.4308    0.6563   -0.4611    0.5928
%     5.0000    9.0000    0.6582    0.6639    0.2917    1.0342    0.3213    0.7955    0.3942    0.7882    0.2031    0.9099    0.4392    0.7018
%     5.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.4052    0.9371    0.4052    0.9371
%     5.0000   11.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.2860    0.4667    0.2860    0.4667
%     5.0000   12.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.7625    0.4750    0.7625    0.4750
%     6.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.1765    0.4277   -0.1765    0.4277
%     6.0000    2.0000   -0.2199    0.0762   -0.0559    0.2238   -0.1161    0.1354       NaN       NaN   -0.5470    0.1162   -0.4925    0.1608
%     6.0000    3.0000    0.5842   -0.0676    0.7437   -0.0496    0.6536   -0.0736    0.6580   -0.0962    0.5579   -0.0764    0.4926   -0.0228
%     6.0000    4.0000       NaN    0.2508       NaN    0.2736       NaN    0.2559    0.0950    0.2593    0.1200    0.1259    0.1200    0.9682
%     6.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.0815   -0.2318    0.0815   -0.2318
%     6.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.5071    0.4360   -0.5071    0.4360
%     6.0000    7.0000       NaN   -0.2478       NaN   -0.1979       NaN   -0.2781    0.3660   -0.1818   -0.0400   -0.3844   -0.0400    0.5079
%     6.0000    8.0000    0.1810    0.7151    0.1383    0.8879    0.1382    0.8562   -0.0038    0.8238    0.0326    0.8366    0.0851    0.7527
%     6.0000    9.0000   -0.1888    0.7519   -0.3357    0.8742   -0.3015    0.7351   -0.3228    0.6993   -0.3196    0.7598   -0.2962    0.7587
%     6.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.4473   -0.1545    0.4473   -0.1545
%     7.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.6227    0.3264    0.6227    0.3264
%     7.0000    2.0000    0.0144    0.4962   -0.1295    0.5747   -0.0838    0.6303   -0.1331    0.5823   -0.1306    0.5463   -0.1513    0.6347
%     7.0000    3.0000    0.2853    0.3086    0.4701    0.7976    0.3614    0.6868    0.4716    0.6017    0.4098    0.6411    0.2288    0.5024
%     7.0000    4.0000       NaN    0.4365       NaN    0.4983       NaN    0.3684   -0.1470    0.3133   -0.2808    0.0358   -0.2808    0.5664
%     7.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.2972    0.3924    0.2972    0.3924
%     7.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.1378    0.6702   -0.1378    0.6702
%     7.0000    7.0000       NaN    0.6244       NaN    0.6635       NaN    0.6660    0.0756    0.4459    0.0613    0.5088    0.0613    0.8434
%     7.0000    8.0000    0.0138    0.7270    0.0427    0.7770   -0.1009    0.7124   -0.1205    0.6658    0.0291    0.6676   -0.0196    0.6397
%     7.0000    9.0000   -1.2518   -0.7079   -1.4811   -0.7181   -1.4026   -0.7524   -1.4073   -0.6661   -1.3782   -0.6406    0.1663    0.8314
%     7.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.4593    0.2569    0.4593    0.2569
%     8.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.2270    0.4960    0.2270    0.4960
%     8.0000    2.0000    0.2954   -0.2606   -0.1329    0.0735   -0.0591   -0.0576   -0.1114    0.0405   -0.1231    0.0635   -0.1059    0.0297
%     8.0000    3.0000    0.3703    0.8439   -0.0508    1.6374    0.0865    1.2956    0.0862    1.4383    0.2116    1.3395    0.1908    1.0542
%     8.0000    4.0000       NaN   -0.1763       NaN   -0.0970       NaN   -0.2333   -0.8683   -0.1559    0.0812   -0.5635    0.0812    0.6840
%     8.0000    5.0000   -0.0619    0.3321   -0.2355    0.4710   -0.0904    0.3483   -0.1542    0.3089   -0.1798    0.4131   -0.0830    0.6125
%     8.0000    6.0000    0.0001    0.1988    0.0345    0.3132   -0.1221    0.2915   -0.1743    0.3894   -0.1083    0.3420   -0.2474    0.8791
%     8.0000    7.0000       NaN    0.3358       NaN    0.5749       NaN    0.3050    0.6952    0.2835    0.3828    0.0519    0.3828    1.7969
%     8.0000    8.0000   -0.0134    1.5829   -0.0865    1.8277   -0.1356    1.7784   -0.2045    1.5762   -0.0812    1.6180   -0.0460    1.7202
%     8.0000    9.0000   -1.1676   -0.4678   -1.8698   -0.4364   -1.7868   -0.2850   -1.8191   -0.3515   -1.6868   -0.3611   -1.5201   -0.3296
%     8.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.5377   -0.0202    0.5377   -0.0202
%     9.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.1161   -0.0240    0.1161   -0.0240
%     9.0000    2.0000    0.5996    0.0243    1.5009    1.0610    1.6638    1.2109    1.4939    1.0447    1.7898    1.3374    0.4622    0.0734
%     9.0000    3.0000    0.5289    0.4143    0.2423    0.4379    0.2476    0.5877    0.2326    0.4554    0.4083    0.5453    0.3516    0.4305
%     9.0000    4.0000       NaN    0.2309       NaN    0.2577       NaN    0.2286    0.1507    0.1189    0.1929   -0.3953    0.1929   -0.0981
%     9.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.3339    0.0797   -0.3339    0.0797
%     9.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.1332   -0.0086    0.1332   -0.0086
%     9.0000    7.0000       NaN    0.7507       NaN    0.7674       NaN    0.8753    0.1835    0.6688    0.3534    0.5847    0.3534   -0.0021
%     9.0000    8.0000    1.0918    0.2829    0.9528    0.2784    1.0477    0.2575    0.9189    0.2861    1.0863    0.2838    1.0286    0.2349
%     9.0000    9.0000    0.8850    0.2422    0.9484    0.3439    0.8289    0.2337    0.7994    0.1987    0.9717    0.2159    0.8841    0.3314
%     9.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.3272   -0.0581    0.3272   -0.0581
%    10.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.4990    0.4044    0.4990    0.4044
%    10.0000    2.0000    0.2237   -1.4933    0.3393   -1.2579    0.3266   -1.3318    0.2261   -1.3064    0.3332   -1.2594    0.3588   -1.2207
%    10.0000    3.0000   -0.0039    0.1854   -0.1080    0.2313   -0.1001    0.2217   -0.1474    0.1990   -0.0812    0.2540    0.0714    0.1528
%    10.0000    4.0000       NaN    0.1496       NaN    0.1150       NaN    0.0773    0.0750    0.0609   -0.2064    0.1349   -0.2064    0.9781
%    10.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.5240    0.7222   -0.5240    0.7222
%    10.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.4499    0.7862    0.4499    0.7862
%    10.0000    7.0000       NaN   -0.2987       NaN   -0.3406       NaN   -0.3604    0.7592   -0.3641    0.3624   -0.2649    0.3624    0.5027
%    10.0000    8.0000    0.6349    0.4795    0.9666    0.3572    0.5101    0.3623    0.5239    0.4681    0.7216    0.4301    0.7240    0.5122
%    10.0000    9.0000    0.8062    0.3852    0.7033    0.3673    0.7365    0.4268    0.7038    0.4284    0.8702    0.4267    0.7826    0.4394
%    10.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.4979   -0.1694    0.4979   -0.1694
%    10.0000   11.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.6556   -0.4005    0.6556   -0.4005
%    10.0000   12.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.7335   -0.2444    0.7335   -0.2444
%    11.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.6382   -0.2382    0.6382   -0.2382
%    11.0000    2.0000    0.8613   -0.1561    0.7105   -0.1804    0.8822   -0.1005    0.7680   -0.0261    0.8438   -0.1025    0.8078   -0.1432
%    11.0000    3.0000    0.1871    0.7925    0.2130    0.6850    0.1696    0.8237    0.0039    0.9302    0.1660    0.7432    0.2741    0.7241
%    11.0000    4.0000       NaN   -0.7353       NaN   -0.7074       NaN   -0.6083    0.9590   -0.8161   -0.2598   -0.6969   -0.2598    0.3842
%    11.0000    5.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.0997    0.5364    0.0997    0.5364
%    11.0000    6.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.7115    0.5330    0.7115    0.5330
%    11.0000    7.0000       NaN   -0.0036       NaN   -0.1471       NaN   -0.0158    0.5438   -0.2171    0.5070   -0.2151    0.5070    0.5740
%    11.0000    8.0000    0.2079   -0.3431    0.1474   -0.2109    0.1566   -0.1658    0.0503   -0.1881   -0.1281   -0.0106   -0.0038   -0.0113
%    11.0000    9.0000    0.3023   -0.5918    0.1927   -0.2817    0.2368   -0.5027    0.1907   -0.3105    0.0638   -0.5505   -0.0390   -0.5956
%    11.0000   10.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN    0.7015   -0.2305    0.7015   -0.2305
%    12.0000    1.0000       NaN       NaN       NaN       NaN       NaN       NaN       NaN       NaN   -0.2370   -0.4183   -0.2370   -0.4183
%    12.0000    2.0000    0.2200   -1.1362    0.1893   -1.2255    0.2487   -1.5517    0.1341   -1.2611    0.1376   -1.0998    0.3036   -1.1286
%    12.0000    3.0000    0.3509    0.0310    0.7381    0.0406    0.3152   -0.0346    0.1835   -0.0610    0.1754    0.0098    0.3032   -0.0342
%    12.0000    4.0000       NaN   -1.7985       NaN   -1.8654       NaN   -1.8415    0.9430   -1.8453   -0.0736   -1.7539   -0.0736   -0.7078
%    12.0000    5.0000   -0.7302   -0.6461   -0.6964   -0.6345   -0.5968   -0.6715   -0.7679   -0.6057   -0.6584   -0.5037   -0.6623   -0.1190
%    12.0000    6.0000    0.3950   -0.0689    0.4376   -0.0564    0.2972   -0.0735    0.3659   -0.0725    0.4741    0.0259    0.2439    0.4729
%    12.0000    7.0000       NaN   -0.1736       NaN   -0.0896       NaN   -0.0741    0.2231   -0.1530   -0.0655   -0.1893   -0.0655   -0.0279
%    12.0000    8.0000   -0.0119   -0.0818   -0.1682   -0.4841    0.0701    0.2030   -0.0373   -0.5285    0.0293   -0.1884   -0.0317   -0.1047
%    12.0000    9.0000    0.4184   -0.1350    0.2375   -0.1396    0.2447   -0.1965    0.2502   -0.2326    0.2470   -0.2015    0.2964   -0.0672
% ];


% iNoOffset = find(isnan(Offset(:,3)));
% Offset(iNoOffset,3) = Offset(iNoOffset,5);
% 
% iNoOffset = find(isnan(Offset(:,4)));
% Offset(iNoOffset,4) = Offset(iNoOffset,6);


% L = getfamilydata('Circumference');
% figure;
% subplot(2,2,1);
% plot(getspos('BPMx', Offset(:,1:2)), [Offset(:,3) Offset(:,5) Offset(:,7) Offset(:,9)]);
% ylabel('Horizontal [mm]');
% xaxis([0 L]);
% title('BPM Offset');
% 
% subplot(2,2,2);
% plot(getspos('BPMx', Offset(:,1:2)), [Offset(:,3)-Offset(:,5) Offset(:,3)-Offset(:,7) Offset(:,3)-Offset(:,9)]);
% ylabel('Horizontal Difference[mm]');
% xaxis([0 L]);
% title('BPM Offset');
% 
% subplot(2,2,3);
% plot(getspos('BPMy', Offset(:,1:2)), [Offset(:,4) Offset(:,6) Offset(:,8) Offset(:,10)]);
% xlabel('BPM Position [meters]');
% ylabel('Vertical [mm]');
% xaxis([0 L]);
% 
% subplot(2,2,4);
% plot(getspos('BPMy', Offset(:,1:2)), [Offset(:,4)-Offset(:,6) Offset(:,4)-Offset(:,8) Offset(:,4)-Offset(:,10)]);
% xlabel('BPM Position [meters]');
% ylabel('Vertical Difference [mm]');
% xaxis([0 L]);
% 
% addlabel(0,0,'2008-06-04 2007-06-15 2007-01-06 2005-05-12');
% addlabel(1,0,'(2008-06-04)-(2007-06-15)  (2008-06-04)-(2007-01-06)  (2008-06-04)-(2005-05-12');
% orient landscape

% Golden orbit 2014-07-06, Christoph Steier and Greg Portmann
% Taken at 48 mA, 276 bunches, 1.9 GeV
% Established based on beam based alignment offset with 50 horizontal and 72 vertical BPMs (Bergoz and new ALS/NSLS)
% 1.) RF frequency set based on old golden orbit (with global orbit correction in srcontrol)
% 2.) Horizontal orbit set with 94 HCMs, 50 BPM offsets, 24 SVs
% 3.) Vertical orbit set with 70 VCMs, 72 BPM offsets, 24 SVs
% 4.) Chicanes all at nominal
%
% Comment - residual of orbit correction to offset orbit is similar to what it has been in the past. However, change to old golden orbit is substantial, particularly in the horizontal plane

% Golden Orbit - March 2017
% Christoph Steier, 3-15-2017
% Several BPMs still have gain problems (2.1, 6.12), so they will have to
% be adjusted in the golden orbit at some future time. There also are 3
% BPMs that are currently disable 1.5, 2.2, 9.5 (some of) which have very large
% offsets, so theuir golden values should be taken with care. But we did
% finish a full beam based alignment set on 3/13 and 3/14 (with new BPMs set
% for low current mode and Pilot tones set to low current state as well.
% We analyzed the data using quadplotall and the corresponding offset orbit
% is listed below. Then we used the old golden orbit to set the RF
% frequency, followed by a correction to the offset orbit, using measured
% offsets, all arc sector correctors, no RF frequency and 48 singular
% values. The data below was generated with
%
% [getlist('BPMx') mean(getpv('BPMx',[],0:0.25:10),2) mean(getpv('BPMy',[],0:0.25:10),2)]
%
% after the orbit correction.


Golden = [
    1.0000    2.0000   -0.0233    0.9081
    1.0000    3.0000   -0.2397   -0.0061
    1.0000    4.0000   -0.0225    0.0811
    1.0000    5.0000   -0.7733    0.9047 % this is not being used, value is just filled in from prior golden
    1.0000    6.0000    0.5255    0.3497
    1.0000    7.0000   -0.0377    0.5293
    1.0000    8.0000   -0.2058    0.2135%-0.1
    1.0000    9.0000    0.1653   -0.5549%-0.58+0.058
    1.0000   10.0000    0.2061    0.6457%-1.22+0.122
%   2.0000    1.0000    0.0629+0.35   -0.6894
%   2.0000    1.0000    0.3164   -0.9002%+0.122 % defined after BPM repair 4-3-17 with SR02 vertical bump installed
%   2.0000    1.0000    0.2277    1.0997 %golden orbit changed after SR02S DOE kicker removal and BPM cables disconnected. 4-28-2017,T.Scarvie
    2.0000    1.0000    0.787     -0.002 %golden orbit changed after SR02S DOE kicker reinstallation and BPM cables disconnected. 8-30-2017, C. Steier
    2.0000    2.0000       NaN       NaN % BPM has Status disabled at the moment
    2.0000    3.0000    0.0655   -0.9175
    2.0000    4.0000    0.1149    0.1650
    2.0000    5.0000    0.3749   -0.3355
    2.0000    6.0000    0.9315   -0.9681
    2.0000    7.0000   -0.2110    0.1670
    2.0000    8.0000   -0.5651   -0.2137
    2.0000    9.0000    0.2957    0.5948
    3.0000    2.0000   -0.0347    0.1710
    3.0000    3.0000    0.2301   -0.3830
    3.0000    4.0000   -0.1390   -0.1834
    3.0000    5.0000    0.0697   -0.3249
    3.0000    6.0000    0.4441   -0.1936
    3.0000    7.0000    0.7485    0.0053
    3.0000    8.0000    0.1254   -0.0087
    3.0000    9.0000    0.1863   -0.1919
    3.0000   10.0000    1.6596   -0.4358
    3.0000   11.0000    0.5914   -0.3991
    3.0000   12.0000    0.5497   -0.8153
    4.0000    1.0000    1.2077   -1.2528
    4.0000    2.0000   -0.1110    0.9691
    4.0000    3.0000   -0.5061    0.2070
    4.0000    4.0000    0.4441    0.3812
    4.0000    5.0000    0.0108   -0.3153
    4.0000    6.0000    0.4903    0.2736
%   4.0000    6.0000    0.1670    0.2347  % SR04 EEBI chassis modified and arc-card put back in, 8-14-17, T.Scarvie
%   4.0000    6.0000    0.4315    0.3332  % straight-section BPM card reinstalled to get EEBI working - PLL lock - EEBI issue, 7-25-17, T.Scarvie
%   4.0000    5.0000    0.0037   -0.3137  % BPM cards worked on as part of BPM(4,6) - PLL lock - EEBI issue, 7-25-17, T.Scarvie
%   4.0000    6.0000    0.1704    0.2703  % BPM cards worked on as part of BPM(4,6) - PLL lock - EEBI issue, 7-25-17, T.Scarvie
%   4.0000    6.0000    0.4667    0.2644  % Bergoz card swapped as part of troubleshooting SR04 EEBI chassis, T.Scarvie
    4.0000    7.0000   -0.1232    0.1182
    4.0000    8.0000   -0.4937    0.1691
    4.0000    9.0000   -0.0919    0.5371
    4.0000   10.0000   -0.3684    0.9986
    5.0000    1.0000    0.8175    0.8528
    5.0000    2.0000   -0.2795    0.3355
    5.0000    3.0000   -0.0526    0.1777
    5.0000    4.0000   -1.7691   -1.0824
    5.0000    5.0000    0.1246    0.4705
    5.0000    6.0000   -0.1462    0.2970
    5.0000    7.0000   -0.2038    0.2099
    5.0000    8.0000   -0.5366   -0.1100
    5.0000    9.0000   -0.0800    0.2289
    5.0000   10.0000   -1.1834    0.9843
    5.0000   11.0000   -0.0164    0.3074
    5.0000   12.0000   -0.2570   -0.0885
    6.0000    1.0000   -0.1657    1.4353
    6.0000    2.0000   -0.5830    0.0338
    6.0000    3.0000   -0.5626    0.2639
    6.0000    4.0000    0.1029    0.4958
    6.0000    5.0000    0.2516   -0.5647
    6.0000    6.0000    0.3246    0.0090
    6.0000    7.0000    0.7283    0.1908
    6.0000    8.0000    0.0569    0.3005
    6.0000    9.0000    0.0657    0.1534
    6.0000   10.0000    0.0482   -0.6230 %10% weaker chicane angle 4-17-2017
%    6.0000   11.0000    0.3818    1.8610
    6.0000   11.0000    0.1555    1.1134 %not sure this is correct - large vertical change after chicane trouble, 5-24-17, T.Scarvie
    6.0000   12.0000   -0.4736    0.6995 %BPM fixed 5-24-17, but reconnected 5-30-17, T.Scarvie
    7.0000    1.0000   -0.3782   -0.0099
%     6.0000   10.0000    0.1011   -0.6230
%     6.0000   11.0000   -0.2162    1.8610
%     6.0000   12.0000    1.3025   -6.6034
%     7.0000    1.0000   -0.3467   -0.0099
    7.0000    2.0000    0.1868    0.0634
    7.0000    3.0000   -0.1712    0.2642
    7.0000    4.0000    0.2116    0.5866
    7.0000    5.0000   -0.1228    0.1066
    7.0000    6.0000    0.1189    0.4285
    7.0000    7.0000   -0.2154    0.4640
    7.0000    8.0000   -0.2541    0.3722
    7.0000    9.0000    0.1122    0.1174
    7.0000   10.0000   -0.1662   -0.1076
    8.0000    1.0000   -0.0671    0.3066
    8.0000    2.0000   -0.4293    0.5365
    8.0000    3.0000   -0.8333    0.4166
    8.0000    4.0000   -1.0065    0.2380
    8.0000    5.0000    0.1247    0.3166
    8.0000    6.0000   -0.1682    0.6389
    8.0000    7.0000    0.6870    0.3850
    8.0000    8.0000   -0.2918    1.1520
    8.0000    9.0000    0.1494    1.0757
    8.0000   10.0000    0.0722   -0.2954
%    9.0000    1.0000    0.0241   -0.1553 %BPM disconnected for flexband 9-2 replacement 5-8-17, T.Scarvie
    9.0000    1.0000    0.0696   -0.1158
    9.0000    2.0000   -0.2072   -0.1934
    9.0000    3.0000    0.0105    0.3481
    9.0000    4.0000    0.2143    0.3117
    9.0000    5.0000   -0.4225    9.9902 % this BPM has its status disabled at the moment
    9.0000    6.0000    0.6020   -0.1348
    9.0000    7.0000    0.1084    0.6839
    9.0000    8.0000   -0.0481    0.0185
    9.0000    9.0000    0.6704    0.0561
    9.0000   10.0000   -0.0848   -0.3126
   10.0000    1.0000    0.2507   -0.1154
   10.0000    2.0000    0.1586   -0.7942
   10.0000    3.0000   -0.5271   -0.0758
   10.0000    4.0000    0.1927    0.3246
   10.0000    5.0000   -0.1802    0.3735
   10.0000    6.0000   -0.0499    0.1861
   10.0000    7.0000    0.1757   -0.1554
   10.0000    8.0000   -0.0303    0.3362
   10.0000    9.0000   -0.1211   -0.1989
   10.0000   10.0000    0.4124   -0.3597
   10.0000   11.0000    0.4518   -0.0760
   10.0000   12.0000    0.6577   -0.1285
   11.0000    1.0000    0.8792   -0.3780
   11.0000    2.0000    0.2258    0.0903
   11.0000    3.0000   -0.6434   -0.2497
   11.0000    4.0000    0.4983   -0.1406
   11.0000    5.0000    0.1862    0.3085
   11.0000    6.0000    0.9221    0.3258
   11.0000    7.0000    0.5256    0.1520
   11.0000    8.0000    0.1064    0.0955
   11.0000    9.0000   -0.0510    0.4712
   11.0000   10.0000    0.5579   -0.0875
   12.0000    1.0000   -0.3627   -0.0931
   12.0000    2.0000    0.1442    0.2318
   12.0000    3.0000    0.2675   -1.2811
   12.0000    4.0000    0.7494   -1.2064
   12.0000    5.0000   -0.3438   -0.5130
   12.0000    6.0000    0.2545    0.0541
   12.0000    7.0000    0.0093    0.3179
   12.0000    8.0000   -0.5344    0.0004
   12.0000    9.0000    0.3985   -0.4450];
    
% Temporary Golden Orbit - March 2017
% Christoph Steier, 3-12-2017
% Several BPMs still have gain problems (2.1, 6.12) and we need to finish
% BBA, but to test orbit feedback and have a reproducible orbit to come
% back to, we did an orbit correction excluding all BPMs with gain errors
% or large offsets, using 49 singular values, RF and the standard arc
% correctors.

% Golden = [
%     1.0000    2.0000   -0.1950    0.9338
%     1.0000    3.0000   -0.3117    0.0544
%     1.0000    4.0000    0.0309    0.0926
%     1.0000    5.0000   -0.7733    0.9047
%     1.0000    6.0000    0.4441    0.3300
%     1.0000    7.0000   -0.1546    0.4228
%     1.0000    8.0000   -0.0582   -0.0502
%     1.0000    9.0000    0.5677   -0.6696
%     1.0000   10.0000    0.6500    0.5815
%     2.0000    1.0000    0.0454   -1.6344
%     2.0000    2.0000       NaN       NaN
%     2.0000    3.0000    0.1932   -0.7986
%     2.0000    4.0000    0.0316    0.2166
%     2.0000    5.0000    0.2913   -0.3703
%     2.0000    6.0000    0.8921   -1.0681
%     2.0000    7.0000   -0.1824   -0.1742
%     2.0000    8.0000   -0.5999   -0.7575
%     2.0000    9.0000    0.2095    0.2514
%     3.0000    2.0000    0.0468    0.1160
%     3.0000    3.0000    0.2673   -0.4403
%     3.0000    4.0000   -0.1366   -0.1902
%     3.0000    5.0000    0.0477   -0.2715
%     3.0000    6.0000    0.4655   -0.1390
%     3.0000    7.0000    0.8185    0.0676
%     3.0000    8.0000    0.1576    0.0839
%     3.0000    9.0000    0.2145   -0.1393
%     3.0000   10.0000    1.6273   -0.4071
%     3.0000   11.0000    0.4503   -0.3921
%     3.0000   12.0000    0.3961   -0.8064
%     4.0000    1.0000    0.9481   -1.2778
%     4.0000    2.0000   -0.4284    0.9359
%     4.0000    3.0000   -0.6832    0.1496
%     4.0000    4.0000    0.4158    0.3487
%     4.0000    5.0000    0.0382   -0.3323
%     4.0000    6.0000    0.5652    0.2287
%     4.0000    7.0000   -0.0102    0.0547
%     4.0000    8.0000   -0.6167    0.0489
%     4.0000    9.0000   -0.4176    0.4662
%     4.0000   10.0000   -0.6477    0.9517
%     5.0000    1.0000    0.5674    0.8081
%     5.0000    2.0000   -0.5299    0.3142
%     5.0000    3.0000   -0.1451    0.1878
%     5.0000    4.0000   -1.6373   -1.0795
%     5.0000    5.0000    0.2189    0.4837
%     5.0000    6.0000   -0.1554    0.3087
%     5.0000    7.0000   -0.2454    0.2576
%     5.0000    8.0000   -0.4436   -0.0043
%     5.0000    9.0000    0.1730    0.2771
%     5.0000   10.0000   -0.9571    1.0079
%     5.0000   11.0000    0.1718    0.3359
%     5.0000   12.0000   -0.0776   -0.0769
%     6.0000    1.0000   -0.0215    1.4228
%     6.0000    2.0000   -0.4525    0.0378
%     6.0000    3.0000   -0.5290    0.2580
%     6.0000    4.0000    0.0334    0.4970
%     6.0000    5.0000    0.1690   -0.5582
%     6.0000    6.0000    0.2857    0.0155
%     6.0000    7.0000    0.7353    0.1915
%     6.0000    8.0000    0.1524    0.3065
%     6.0000    9.0000    0.3129    0.1365
%     6.0000   10.0000    0.5029   -0.6862
%     6.0000   11.0000    0.0446    1.6638
%     6.0000   12.0000    1.4493   -6.4396
%     7.0000    1.0000   -0.3429   -0.1221
%     7.0000    2.0000    0.1744   -0.0771
%     7.0000    3.0000   -0.2028   -0.0227
%     7.0000    4.0000    0.1700    0.4411
%     7.0000    5.0000   -0.1365    0.0807
%     7.0000    6.0000    0.1427    0.4419
%     7.0000    7.0000   -0.1594    0.4736
%     7.0000    8.0000   -0.2298    0.3715
%     7.0000    9.0000    0.1466    0.1085
%     7.0000   10.0000   -0.1406   -0.1346
%     8.0000    1.0000   -0.1271    0.1548
%     8.0000    2.0000   -0.5157    0.3421
%     8.0000    3.0000   -0.8856    0.0345
%     8.0000    4.0000   -0.9405    0.0369
%     8.0000    5.0000    0.1180    0.2172
%     8.0000    6.0000   -0.2692    0.5457
%     8.0000    7.0000    0.5551    0.2211
%     8.0000    8.0000   -0.1812    0.8779
%     8.0000    9.0000    0.5194    0.9479
%     8.0000   10.0000    0.4509   -0.3957
%     9.0000    1.0000    0.4332   -0.1875
%     9.0000    2.0000    0.2049   -0.2044
%     9.0000    3.0000    0.1567    0.3403
%     9.0000    4.0000    0.0539    0.3118
%     9.0000    5.0000   -0.4225    9.9902
%     9.0000    6.0000    0.6211   -0.1499
%     9.0000    7.0000    0.2335    0.5743
%     9.0000    8.0000    0.0124   -0.1771
%     9.0000    9.0000    0.7447   -0.0751
%     9.0000   10.0000   -0.0567   -0.4304
%    10.0000    1.0000    0.1040   -0.2230
%    10.0000    2.0000   -0.0189   -0.9078
%    10.0000    3.0000   -0.6231   -0.2800
%    10.0000    4.0000    0.2007    0.2262
%    10.0000    5.0000   -0.1542    0.3624
%    10.0000    6.0000   -0.0295    0.1877
%    10.0000    7.0000    0.1932   -0.1502
%    10.0000    8.0000   -0.1061    0.3475
%    10.0000    9.0000   -0.2789   -0.1914
%    10.0000   10.0000    0.2976   -0.3653
%    10.0000   11.0000    0.3967   -0.0959
%    10.0000   12.0000    0.6062   -0.1519
%    11.0000    1.0000    0.8823   -0.4189
%    11.0000    2.0000    0.2347    0.0496
%    11.0000    3.0000   -0.6279   -0.3176
%    11.0000    4.0000    0.5434   -0.1712
%    11.0000    5.0000    0.2021    0.3053
%    11.0000    6.0000    0.9027    0.3336
%    11.0000    7.0000    0.5025    0.1501
%    11.0000    8.0000    0.0862    0.0891
%    11.0000    9.0000   -0.0587    0.4538
%    11.0000   10.0000    0.5630   -0.1209
%    12.0000    1.0000   -0.3498   -0.1950
%    12.0000    2.0000    0.1492    0.1206
%    12.0000    3.0000    0.2592   -1.4788
%    12.0000    4.0000    0.7323   -1.3075
%    12.0000    5.0000   -0.3648   -0.5648
%    12.0000    6.0000    0.2832    0.0302
%    12.0000    7.0000    0.0636    0.2801
%    12.0000    8.0000   -0.5319   -0.1223
%    12.0000    9.0000    0.3841   -0.4597
% ];
% 
% Golden Orbit - Jan 2016
% Many BPM changes were made during the long shutdown in Oct 2015
% * New BPM electronics in 1,2,7,8 button locations (and a few more)
% * Pilot tone combiners added to IDBPMs in most of the 3,4,5,6 button locations

% Golden = [
%     1.0000    2.0000   -0.2212    0.9461
%    %1.0000    3.0000   -0.1175    0.0789
%     1.0000    3.0000   -0.3309    0.0769 % PT adjusted
%     1.0000    4.0000    0.0638    0.0385
%     1.0000    5.0000   -0.7733    0.9047
%     1.0000    6.0000    0.5090    0.1704
%    %1.0000    7.0000   -0.0962    0.3530
%    %1.0000    8.0000   -0.2376    0.3743
%    %1.0000    9.0000   -0.0970   -0.9172
%     1.0000    7.0000   -0.1124    0.4935 % PT adjusted
%     1.0000    8.0000   -0.2514    0.0396 % PT adjusted
%     1.0000    9.0000    0.0829   -0.4974 % PT adjusted
%     1.0000   10.0000    1.2671    0.2392    
%     2.0000    1.0000    0.3025   -0.1113
%     2.0000    2.0000       NaN       NaN
%     2.0000    3.0000    0.0761   -0.6586
%     2.0000    4.0000    0.0484    0.1486
%     2.0000    5.0000    0.3315   -0.3992
%     2.0000    6.0000    0.9720   -1.0463
%     2.0000    7.0000   -0.0957    0.0762
%     2.0000    8.0000   -0.8834   -0.8539
%     2.0000    9.0000    0.3933    0.5279
%     3.0000    2.0000    0.0569    0.1778
%     3.0000    3.0000    0.2570   -0.4361
%     3.0000    4.0000   -0.0645   -0.1664
%     3.0000    5.0000    0.1159   -0.2575
%     3.0000    6.0000    0.4836   -0.1383
%     3.0000    7.0000    0.7929    0.0731
%     3.0000    8.0000    0.3044    0.1660
%     3.0000    9.0000    0.4030   -0.3412
%     3.0000   10.0000    1.6046   -0.2851
%     3.0000   11.0000    0.3438   -0.4034
%     3.0000   12.0000    0.2973   -0.8153
%     4.0000    1.0000    1.0347   -1.2587
%     4.0000    2.0000   -0.1981    0.5675  % Fixed short in connector at button C (Oct 25, 2016) was 3.7774    4.6623
%     4.0000    3.0000   -0.5774    0.0055
%     4.0000    4.0000    0.3900    0.3310
%     4.0000    5.0000    0.0936   -0.3335  
%     4.0000    6.0000    0.6033    0.2632
%     4.0000    7.0000   -0.0151    0.0358
%     4.0000    8.0000   -0.6946   -0.3610
%     4.0000    9.0000    0.4546    0.5005
%     4.0000   10.0000   -0.6336    0.9324
%     5.0000    1.0000    0.5717    0.7513 % new golden orbit for Bergoz card swap - noise seen 2/3-5/16, T.Scarvie
% %    5.0000    1.0000    0.5636    0.5415
%     5.0000    2.0000   -0.3716    0.3730
%     5.0000    3.0000   -0.2365    0.1880
%     5.0000    4.0000   -0.1585    0.3704
%     5.0000    5.0000    0.2504    0.5285
%     5.0000    6.0000   -0.1794    0.3835
%     5.0000    7.0000   -0.3161    0.2279
%     5.0000    8.0000   -0.1489   -0.2309
%     5.0000    9.0000   -0.0600    0.0680
%     5.0000   10.0000   -1.0841    0.9760
%     5.0000   11.0000    0.1151    0.3237
%     5.0000   12.0000   -0.1635   -0.0908
%     6.0000    1.0000   -0.0286    1.4239 % was -0.4162  1.4324, changed due to vacuum chamber move on 2/17/16, GJP
%     6.0000    2.0000   -0.2774   -0.0874
%     6.0000    3.0000   -0.3210    0.1312
%     6.0000    4.0000    0.1130    0.4837
%     6.0000    5.0000    0.0888   -0.5256
%     6.0000    6.0000    0.2615    0.0092 % new golden orbit for Bergoz card swap - periods of noise seen 2/7/16, T.Scarvie
% %    6.0000    6.0000    0.2470    0.0038
%     6.0000    7.0000    0.7639    0.1406
%     6.0000    8.0000    0.4471    0.6100
%     6.0000    9.0000    0.2905   -0.0533
%     6.0000   10.0000    0.8235   -0.3487
%     6.0000   11.0000   -0.1526    0.8600
%     6.0000   12.0000   -0.8263    0.7223
%     7.0000    1.0000   -0.1522   -0.4857
%    %7.0000    2.0000    0.0024    0.1974
%    %7.0000    3.0000   -0.1156   -0.4445
%     7.0000    2.0000    0.1598    0.0897 % PT adjusted
%     7.0000    3.0000   -0.1681    0.3158 % PT adjusted
%     7.0000    4.0000    0.1543    0.5283
%     7.0000    5.0000   -0.1350   -0.0192
%     7.0000    6.0000    0.1648    0.2994
%     7.0000    7.0000   -0.1486    0.4348
%    %7.0000    8.0000   -0.3404    0.0722
%    %7.0000    9.0000   -0.1519   -0.4141
%     7.0000    8.0000   -0.2273    0.3614 % PT adjusted
%     7.0000    9.0000    0.0976    0.0942 % PT adjusted
%     7.0000   10.0000   -0.1137   -0.0438
%     8.0000    1.0000   -0.1490    0.3901
%     8.0000    2.0000   -0.5428    0.1221
%     8.0000    3.0000   -0.9620   -0.2452
%     8.0000    4.0000   -0.9285    0.1882
%     8.0000    5.0000    0.1586    0.2184
%     8.0000    6.0000   -0.1948    0.5459
%     8.0000    7.0000    0.6113    0.3677
%     8.0000    8.0000    0.0033    0.6956
%     8.0000    9.0000    0.8214    0.6861
%     8.0000   10.0000    0.1439   -0.1833 % Bergoz card changed 6-27-16 due to suspicious BPM drifts, T.Scarvie
% %    8.0000   10.0000    0.1463   -0.2249
%     9.0000    1.0000    0.1325   -0.2071
%     9.0000    2.0000    0.6664   -0.3360
%     9.0000    3.0000    0.2208    0.4818
%     9.0000    4.0000    0.0880    0.2210
%     9.0000    5.0000   -0.4225    9.9902
%     9.0000    6.0000    0.6722   -0.2243
%     9.0000    7.0000    0.2294    0.6475
%     9.0000    8.0000   -0.0613   -0.1303
%     9.0000    9.0000    0.9340   -0.5247
%     9.0000   10.0000   -0.1657   -0.2865
%    10.0000    1.0000    0.1860   -0.0738
%    10.0000    2.0000   -0.0850   -1.2403
%    10.0000    3.0000   -0.7912   -0.4167
%    10.0000    4.0000    0.1741    0.3225
%    10.0000    5.0000   -0.1881    0.3441
%    10.0000    6.0000   -0.0337    0.1570
%    10.0000    7.0000    0.1843   -0.1438
%    10.0000    8.0000    1.0200   -0.1194
%    10.0000    9.0000   -0.5543   -0.2252
%    10.0000   10.0000    0.4121   -0.3536
%    10.0000   11.0000    0.4309   -0.0889
%    10.0000   12.0000    0.6319   -0.1433
%    11.0000    1.0000    0.8276   -0.4077
%    11.0000    2.0000    0.1240    0.0619
%    11.0000    3.0000   -0.5351   -0.0199
%    11.0000    4.0000    0.5483   -0.1679
%    11.0000    5.0000    0.2259    0.3105
%    11.0000    6.0000    0.9134    0.3399
%    11.0000    7.0000    0.5062    0.1472
%    11.0000    8.0000    0.1361    0.0036
%    11.0000    9.0000    0.0761    0.1919
%    11.0000   10.0000    0.6010   -0.1336
%    12.0000    1.0000   -0.3529   -0.2141
%    12.0000    2.0000    0.2891   -0.1285
%    12.0000    3.0000    0.6599   -2.0250
%    12.0000    4.0000   -0.6004    0.0224
%    12.0000    5.0000   -0.3282   -0.5861
%    12.0000    6.0000    0.2278    0.0006
%    12.0000    7.0000    0.0247    0.2371
%    12.0000    8.0000   -0.4392   -0.0735
%    12.0000    9.0000    0.4790   -0.4560];

% New BPM golden orbit change (2017-06-11)
%
% d = getlist('BPM');
% x = mean(getx(d,0:.1:10),2);
% y = mean(gety(d,0:.1:10),2);
% for ii = 1:size(d,1); fprintf('   %2d   %d  %10.4f  %10.4f\n', d(ii,1), d(ii,2), x(ii), y(ii)); end
if 0
    % Need to get all BPMs with PT comp on
    % 2018-01-12
    d = [
        1   3     -0.1716      0.0186
        1   7     -0.0385      0.4429
        1   8     -0.2050     -0.0075
        1   9      0.1519     -0.6353
        2   3      0.4001     -0.8672
        2   8     -0.5938     -0.2651
        3   3      0.2215     -0.3944
        3   8      0.0757     -0.1814
        3   9      0.0972     -0.3157
        4   2     -0.0942      0.9729
        4   3     -0.5034      0.2140
        4   8     -0.4756      0.1762
        4   9      0.0296      0.5937
        5   2     -0.2679      0.3284
        5   3     -0.0635      0.1813
        5   8     -0.5633     -0.1174
        5   9     -0.1397      0.1914
        6   2     -0.5684      0.0961
        6   3     -0.4776      0.2999
        6   8      0.0197      0.3194
        6   9      0.0825      0.2359
        7   2      0.1119      0.0631
        7   3     -0.1747      0.3695
        7   8     -0.2291      0.3784
        7   9      0.1189      0.0839
        8   2     -0.3589      0.5736
        8   3     -0.7771      0.4452
        8   8     -0.3374      1.1731
        8   9      0.1743      1.1480
        9   2     -0.2057     -0.1428
        9   3      0.0267      0.3628
        9   8     -0.0823      0.0878
        9   9      0.7252      0.0676
        10   2      0.2038     -0.7476
        10   3     -0.4585     -0.0913
        10   8     -0.1322      0.3101
        10   9     -0.0961     -0.1993
        11   2      0.4018      0.0805
        11   3     -0.5654     -0.2451
        11   8      0.0940      0.1174
        11   9     -0.0606      0.5132
        12   2      0.1712      0.1596
        12   3      0.2220     -1.2224
        12   8     -0.5897      0.0110];
else
    % 2017-06-11
    d = [
        1   3     -0.2403     -0.0006
        1   7     -0.0365      0.4791
        1   8     -0.2067      0.1208
        1   9      0.1686     -0.5383
        2   3      0.4363     -0.8862
        2   8     -0.6095     -0.2030
        3   3      0.2220     -0.4002
        3   8      0.0740     -0.1918
        3   9      0.1000     -0.3162
        4   2     -0.1422      0.9756
        4   3     -0.5299      0.2122
        4   8     -0.5347      0.1881
        4   9     -0.0642      0.5933
        5   2     -0.2569      0.3119
        5   3     -0.0639      0.1377
        5   8     -0.5635     -0.1153
        5   9     -0.1121      0.2691
        6   2     -0.5750      0.0833
        6   3     -0.5011      0.2846
        6   8      0.0121      0.2905
        6   9      0.0379      0.2129
        7   2      0.1433      0.0574
        7   3     -0.1616      0.3536
        7   8     -0.2424      0.3511
        7   9      0.0976      0.0504
        8   2     -0.3663      0.5931
        8   3     -0.7816      0.4627
        8   8     -0.3386      1.1339
        8   9      0.1821      1.1124
        9   2     -0.2290     -0.1330
        9   3      0.0050      0.3600
        9   8     -0.1117      0.0734
        9   9      0.6637      0.0601
        10   2      0.1860     -0.7260
        10   3     -0.4804     -0.0274
        10   8     -0.1134      0.2944
        10   9     -0.0516     -0.2073
        11   2      0.2702      0.0716
        11   3     -0.6344     -0.2499
        11   8      0.0774      0.1155
        11   9     -0.0936      0.5041
        12   2      0.1988      0.1455
        12   3      0.2385     -1.2535
        12   8     -0.5755      0.0010
        ];
end
i = findrowindex(d(:,1:2), Golden(:,1:2));
Golden(i,3:4) = d(:,3:4);


%figure; subplot(2,1,1); plot(d(:,3)-d1(:,3)); subplot(2,1,2); plot(d(:,4)-d1(:,4));

% % Golden orbit below was used until the long shutdown in Oct 2015.
% Golden = [
%     1.0000    2.0000   -0.2593    0.9247
%     1.0000    3.0000   -0.2278   -0.0512
%     1.0000    4.0000   -0.4413    0.1127
%     1.0000    5.0000    0.6012    2.9214
%     1.0000    6.0000    0.1056    0.1554
%     1.0000    7.0000    0.1071    1.8048
% %    1.0000    8.0000   -0.2793    0.3453
%     1.0000    8.0000   -0.3178   -0.2383
%     1.0000    9.0000    0.1561   -0.2833
%     1.0000   10.0000    1.3146    0.2339
%     2.0000    1.0000    0.3235   -0.1505
%     2.0000    2.0000    1.9426  -11.6598
%     2.0000    3.0000    0.0296   -0.5819
%     2.0000    4.0000   -0.4413    0.0029
% %    2.0000    5.0000   -0.0717   -0.0012 %large offsets corrected 4-20-15, T.Scarvie
%     2.0000    5.0000   -0.0511   -0.2890
%     2.0000    6.0000    0.7130   -0.8015
%     2.0000    7.0000   -0.4884    0.0970
% %    2.0000    8.0000   -0.5144    0.5796
%     2.0000    8.0000   -0.7848   -0.9378
%     2.0000    9.0000    0.3262    0.3353
%     3.0000    2.0000   -0.2081   -0.0659
%     3.0000    3.0000   -1.1764    1.8422
%     3.0000    4.0000   -0.5230   -0.2516
%     3.0000    5.0000   -0.2926   -0.3945
%     3.0000    6.0000   -0.0063-0.02   -0.2254
%     3.0000    7.0000    0.2316   -0.1009
% %    3.0000    8.0000    0.4825   -0.3792
%     3.0000    8.0000   -0.2807    0.0630
%     3.0000    9.0000    0.1164    0.0637
%     3.0000   10.0000    1.6595   -0.2860
%     3.0000   11.0000    0.3900   -1.1188
%     3.0000   12.0000    0.5126   -0.8172
%     4.0000    1.0000    1.3770   -0.7625
%     4.0000    2.0000    2.4774    1.2289
%     4.0000    3.0000   -0.4973    0.1324
%     4.0000    4.0000    0.0522    0.3599
%     4.0000    5.0000   -0.0833-0.05   -0.2091
%     4.0000    6.0000    0.7784    0.4256
%     4.0000    7.0000   -0.2831   -0.2312
% %    4.0000    8.0000   -0.2848    0.3063
%     4.0000    8.0000   -0.5248   -0.5244
%     4.0000    9.0000   -0.1037    0.4974
%     4.0000   10.0000   -0.3022    0.9068
% %    5.0000    1.0000    0.7628    0.3114 %flexband replaced 6-16-15, offsets adjusted accordingly, T.Scarvie
%     5.0000    1.0000    1.2158    0.0234
%     5.0000    2.0000   -0.2384    0.2170
%     5.0000    3.0000    0.0324    0.1207
% %   5.0000    4.0000   -0.5326    0.3118 % Bergoz card swapped 1-10-15 due to noisy periods on the BPM observed 12-19-14
%     5.0000    4.0000   -0.5971    0.3083
%     5.0000    5.0000   -0.1739    0.3025
%     5.0000    6.0000   -0.3414    0.3893
%     5.0000    7.0000   -0.7215    0.1182
% %    5.0000    8.0000   -0.3984   -0.0727
%     5.0000    8.0000   -0.5849   -0.5479
%     5.0000    9.0000   -0.0193    0.0959
%     5.0000   10.0000   -1.0239    1.0885
% %   5.0000   11.0000    0.1934    0.1508 %BPM cables disconnected for chicane work during the late Oct. 2014 shutdown
%     5.0000   11.0000    0.2125    0.1712
% %   5.0000   12.0000   -0.1932    0.0081 %BPM cables disconnected for chicane work during the late Oct. 2014 shutdown
%     5.0000   12.0000   -0.1371    0.0234
%     6.0000    1.0000   -0.3864    1.1483
%     6.0000    2.0000   -0.4874   -0.0007
%     6.0000    3.0000   -0.4588    0.3675
%     6.0000    4.0000   -0.2537    0.4585
%     6.0000    5.0000   -0.1535   -0.4675
%     6.0000    6.0000   -0.1207    0.2113
%     6.0000    7.0000    0.0278    0.2133
% %    6.0000    8.0000   -0.0060    0.4364
%     6.0000    8.0000    0.0093   -0.2969
%     6.0000    9.0000    0.2455    0.0829
%     6.0000   10.0000   -0.8803   -0.2456
%     6.0000   11.0000   -0.0062    0.7911
% %     6.0000   11.0000    0.0208    0.6881
%     6.0000   12.0000   -0.6002    0.5845
%     7.0000    1.0000    0.2943    0.1217
%     7.0000    2.0000    0.3954   -0.1418
%     7.0000    3.0000    0.0416    0.2231
%     7.0000    4.0000   -0.1023    0.5053
%     7.0000    5.0000   -0.1393    0.1653
%     7.0000    6.0000   -0.0380    0.6473
%     7.0000    7.0000   -0.5956    0.5609
% %    7.0000    8.0000   -0.1731    0.3059
%     7.0000    8.0000   -0.4875    0.1033
%     7.0000    9.0000    0.0449    0.1803
%     7.0000   10.0000    0.2273    0.0514
%     8.0000    1.0000    0.0746    0.3210
%     8.0000    2.0000   -0.4422    0.6759
%     8.0000    3.0000   -0.9124    0.3651
%     8.0000    4.0000   -1.4555    0.0649
%     8.0000    5.0000   -0.3026    0.3345
%     8.0000    6.0000   -0.2369    0.4507
%     8.0000    7.0000    0.5918    0.3526
% %    8.0000    8.0000   -0.1277    1.1708
%     8.0000    8.0000   -0.7489    1.3563
%     8.0000    9.0000    0.2689    1.2452
% %    8.0000   10.0000    0.3767   -0.1357 %BPM button B fixed during late Oct. 2014 shutdown
%     8.0000   10.0000    0.0165   -0.2067
%     9.0000    1.0000    0.0714   -0.1956
%     9.0000    2.0000   -0.2033    0.0154
%     9.0000    3.0000    0.1842    0.7086
%     9.0000    4.0000   -0.4230    0.2791
%     9.0000    5.0000   -5.8981    5.3779
%     9.0000    6.0000    0.1727   -0.0165
%     9.0000    7.0000   -0.2802    0.5944
% %    9.0000    8.0000    0.4800   -0.5124
%     9.0000    8.0000   -0.0295   -0.0421
%     9.0000    9.0000    0.6262    0.0216
%     9.0000   10.0000    0.0463   -0.1230
% %   10.0000    1.0000    0.2973    0.2744
%    10.0000    1.0000    0.7546    0.2164 %flexband 10-2 and BPM spool for BPM(10,1) were changed 8/4/14
%    10.0000    2.0000    0.2701   -0.6120
%    10.0000    3.0000   -0.4330    0.2869
%    10.0000    4.0000   -0.2968    0.3328
% %   10.0000    5.0000   -0.6630    0.1567 %large offsets corrected 4-20-15, T.Scarvie
% %   10.0000    5.0000   -0.3577    0.5160 % 
%    10.0000    5.0000   -0.6155    0.1276
%    10.0000    6.0000   -0.2049    0.1572
%    10.0000    7.0000    0.0180   -0.2773
% %   10.0000    8.0000    0.0059    0.4288
%    10.0000    8.0000    0.0632    0.2149
%    10.0000    9.0000    0.1496   -0.1148
%    10.0000   10.0000    0.5093   -0.1662
%    10.0000   11.0000    0.6046    0.0435
%    10.0000   12.0000    0.7605   -0.0325
%    11.0000    1.0000    0.5932   -0.4686
%    11.0000    2.0000    0.3270    0.0224
%    11.0000    3.0000   -0.4923   -0.0280
%    11.0000    4.0000    0.2582   -0.5035
%    11.0000    5.0000    0.0985    0.3522
%    11.0000    6.0000    0.5649    0.1849
%    11.0000    7.0000    0.2377    0.1642
% %   11.0000    8.0000    0.4000   -0.1534
%    11.0000    8.0000    0.1745    0.0464
%    11.0000    9.0000    0.0537    0.4449
%    11.0000   10.0000    0.6186    0.0003
%    12.0000    1.0000   -0.5117   -0.3088
%    12.0000    2.0000    0.4091   -0.2167
%    12.0000    3.0000    0.4687   -1.4656
%    12.0000    4.0000    1.2386   -1.6564
%    12.0000    5.0000   -0.1734   -0.4424
%    12.0000    6.0000    0.0720    0.0429
%    12.0000    7.0000   -0.7721    0.2335
% %   12.0000    8.0000   -0.5287   -0.0025
%    12.0000    8.0000   -0.9857   -0.4605
%    12.0000    9.0000    0.4873   -0.3838];
    

% Golden orbit 2013-03-24, Christoph Steier and Tom Scarvie
% Taken at 45 mA, 276 bunches, 1.9 GeV
% Established based on old golden orbit in 78 Bergoz BPMs
% 1.) RF frequency and orbit set with 84 total SVs, 92 HCMs, 70 VCMs 
%     chicanes at nominal, center chicanes at small values, sum(HCM3456)=0
% 
% This golden orbit based on Pre Spring 2013 Shutdown below
%      DeviceList         X          Y 
% Golden = [
%     1.0000    2.0000    0.0667    1.0999
%     1.0000    3.0000    0.2940    0.1868
%     1.0000    4.0000   -0.6644    0.1578
%     1         5              0         0
%     1.0000    6.0000    0.0522    0.2748
%     1         7              0         0
%     1.0000    8.0000   -0.2396   -0.0999
%     1.0000    9.0000    0.1931    0.4140
%     1.0000   10.0000    1.3438    0.5145
%     2.0000    1.0000   -0.0706   -0.0315
%     2.0000    2.0000    0.4889   -0.1410
%     2.0000    3.0000    0.0477    0.1406
%     2.0000    4.0000   -0.7480    0.0089
%     2.0000    5.0000   -0.2690   -0.0642
%     2.0000    6.0000    0.4873   -0.8961
%     2.0000    7.0000   -0.6443    0.0844
%     2.0000    8.0000    0.0671   -0.1760
%     2.0000    9.0000    0.1317    0.2309
%     3.0000    2.0000   -0.0617    0.1699
%     3.0000    3.0000    0.1913   -0.0740
%     3.0000    4.0000   -0.6551   -0.0681
%     3.0000    5.0000   -0.4470   -0.2348
%     3.0000    6.0000   -0.1254   -0.1051
%     3.0000    7.0000    0.1631   -0.0356
%     3.0000    8.0000   -0.0893    0.6202
%     3.0000    9.0000    0.3810   -0.1857
%     3.0000   10.0000    1.0980   -0.0787
%     3.0000   11.0000    0.1785   -1.0514
%     3.0000   12.0000    0.3652   -0.6358
%     4.0000    1.0000    1.5300   -0.7690
%     4.0000    2.0000   -0.4244    0.9960
%     4.0000    3.0000    0.7561   -0.2048
%     4.0000    4.0000    0.0299    0.3964
%     4.0000    5.0000   -0.2001   -0.2094
%     4.0000    6.0000    0.5604    0.4291
%     4.0000    7.0000   -0.5705   -0.2189
%     4.0000    8.0000   -0.7442   -0.0504
%     4.0000    9.0000   -0.4553   -0.3478
%     4.0000   10.0000   -0.1155    0.7452
%     5.0000    1.0000    0.9254    0.1747
%     5.0000    2.0000    0.4799    0.3205
%     5.0000    3.0000    0.2351    0.4243
%     5.0000    4.0000   -0.7516    0.2567
%     5.0000    5.0000   -0.4039    0.2966
%     5.0000    6.0000   -0.5675    0.4287
%     5.0000    7.0000   -0.9358    0.1089
%     5.0000    8.0000   -0.1986    0.5328
%     5.0000    9.0000    0.7747    0.7792
%     5.0000   10.0000   -0.5186    1.0384
%     5.0000   11.0000    0.9349    0.4411
%     5.0000   12.0000    0.5146    0.2614
%     6.0000    1.0000   -0.1088    1.1007
%     6.0000    2.0000   -0.0265    0.2323
%     6.0000    3.0000    0.5713    0.0069
%     6.0000    4.0000   -0.4239    0.5457
%     6.0000    5.0000   -0.4205   -0.5106
%     6.0000    6.0000   -0.5820    0.2228
%     6.0000    7.0000   -0.3144    0.1910
%     6.0000    8.0000    0.5257    0.5787
%     6.0000    9.0000    0.8508    0.7742
%     6.0000   10.0000    0.5112   -0.4612
% The following two lines were set to approximate values after fix of
% center chicane chamber in June 2014 shutdsown - will need to correct
% after establishing clean golden orbit
%     6.0000   11.0000    2.3010    0.5054
%     6.0000   12.0000    1.5641    0.2046
%     7.0000    1.0000    1.1590   -0.0102
%     7.0000    2.0000    0.6255    0.3244
%     7.0000    3.0000    0.2833    0.3528
%     7.0000    4.0000   -0.7788    0.4387
%     7.0000    5.0000    0.1981    0.3295
%     7.0000    6.0000   -0.2570    0.7102
%     7.0000    7.0000   -0.7064    0.5176
%     7.0000    8.0000    0.4391    0.8113
%     7.0000    9.0000   -0.2509   -0.4423
%     7.0000   10.0000    0.7064    0.0526
%     8.0000    1.0000    0.4255    0.4650
%     8.0000    2.0000    0.1573   -0.0369
%     8.0000    3.0000    0.8810   -0.3228
%     8.0000    4.0000   -1.7045    0.2705
%     8.0000    5.0000   -0.5517    0.3827
%     8.0000    6.0000   -0.4674    0.4193
%     8.0000    7.0000    0.4633    0.2675
%     8.0000    8.0000    0.0621    1.3670
%     8.0000    9.0000   -1.0657   -0.2829
%     8.0000   10.0000    0.8981   -0.2252
%     SR08 vertical golden orbit updated when 65urad downward bump was installed for BL8.3 4-22-13, T.Scarvie
%     8.0000    1.0000    0.4255    0.4676
%     8.0000    2.0000    0.1573   -0.0369
%     8.0000    3.0000    0.8810   -0.3228
%     8.0000    4.0000   -1.7045    0.2324
%     8.0000    5.0000   -0.5517    0.3358
%     8.0000    6.0000   -0.4674    0.4631
%     8.0000    7.0000    0.4633    0.3102
%     8.0000    8.0000    0.0621    1.3670
%     8.0000    9.0000   -1.0657   -0.2829
%     8.0000   10.0000    0.8981   -0.2253
%     9.0000    1.0000    0.2293   -0.1647
%     9.0000    2.0000    0.7833    0.2437
%     9.0000    3.0000    0.3583    0.5276
%     9.0000    4.0000   -0.6855    0.3316
%     9.0000    5.0000   -1.3865    0.6081
%     9.0000    6.0000   -0.0640   -0.0063
%     9.0000    7.0000   -0.5109    0.6921
%     9.0000    8.0000    0.9047    0.3535
%     9.0000    9.0000    0.8971    0.3460
%     9.0000   10.0000    0.1607   -0.0028
%    10.0000    1.0000    0.3813    0.3873
%    10.0000    2.0000    0.0952   -1.4156
%    10.0000    3.0000   -0.2115    0.2410
%    10.0000    4.0000   -0.5714    0.4124
%    10.0000    5.0000   -0.8853    0.1206
%    10.0000    6.0000   -0.2897    0.2367
%    10.0000    7.0000   -0.0786   -0.1975
%    10.0000    8.0000    0.4324    0.6420
%    10.0000    9.0000    1.1754   -1.7659
%    10.0000   10.0000    0.4527    0.0433
%    10.0000   11.0000    0.6761   -0.1674
%    10.0000   12.0000    0.8400   -0.1477
%    11.0000    1.0000    0.6000   -0.4780  % BPM(11,1) fixed with new Bergoz card - new golden orbit values based on average BPM readings since that fix - 20130519, T.Scarvie
%   11.0000    1.0000    0.6500   -0.4106
%    11.0000    2.0000   -0.0893   -0.0069
%    11.0000    3.0000    0.3005    0.3178
%    11.0000    4.0000    0.2591   -0.5391
%    11.0000    5.0000   -0.0756    0.2883
%    11.0000    6.0000    0.4425    0.2619
%    11.0000    7.0000   -0.1207    0.2959
%    11.0000    8.0000    1.5815   -0.6500
%    11.0000    9.0000         0         0
%    11.0000   10.0000    1.0848    0.0607
%    12.0000    1.0000   -0.1460   -0.2909
%    12.0000    2.0000    0.0129   -0.9335
%    12.0000    3.0000    0.0375   -0.0325
%    12.0000    4.0000    0.5603   -1.5926
%    12.0000    5.0000   -0.4873   -0.4721
%    12.0000    6.0000    0.3454    0.0578
%    12.0000    7.0000   -0.1794    0.2753
%    12.0000    8.0000    1.0953   -0.1114
%    12.0000    9.0000    0.4348   -0.2561
%    ];

% golden orbit from before spring 2013 shutdown is below
% Golden = [
%     1.0000    2.0000   -0.0405    1.0888
%     1.0000    3.0000   -2.3441    0.1261
%     1.0000    4.0000   -0.5069    0.1649
%     1         5         0         0
%     1.0000    6.0000   -0.0245    0.2644
%     1         7         0         0
%     1.0000    8.0000    2.2047    1.4887
%     1.0000    9.0000    0         0
%     1.0000   10.0000    1.3332    0.5160
%     2.0000    1.0000    0.1851   -0.0093
%     2.0000    2.0000   -0.5934    1.7437
%     2.0000    3.0000   -0.0489   -2.6755
%     2.0000    4.0000   -0.6357    0.0431
%     2.0000    5.0000   -0.1575   -0.0632
%     2.0000    6.0000    0.5874   -0.9050
%     2.0000    7.0000   -0.5620    0.0800
%     2.0000    8.0000    3.0356    0.3473
%     2.0000    9.0000    0.2066    0.2348
%     3.0000    2.0000    0.0042    0.1886
%     3.0000    3.0000    0.8319   -0.7233
%     3.0000    4.0000   -0.6087   -0.0776
%     3.0000    5.0000   -0.4096   -0.2528
%     3.0000    6.0000   -0.0621   -0.1039
%     3.0000    7.0000    0.2072   -0.0156
%     3.0000    8.0000   -1.4873    0.2938
%     3.0000    9.0000    2.4577   -2.1912
%     3.0000   10.0000    1.1160   -0.0646
%     3.0000   11.0000    0.1988   -1.0735
%     3.0000   12.0000    0.3832   -0.6586
%     4.0000    1.0000    1.5385   -0.7916
%     4.0000    2.0000   -2.2111   -2.1815
%     4.0000    3.0000    1.1605    0.7406
%     4.0000    4.0000    0.0596    0.4001
%     4.0000    5.0000   -0.1569   -0.1815
%     4.0000    6.0000    0.5961    0.4673
%     4.0000    7.0000   -0.5982   -0.2156
%     4.0000    8.0000   -0.2053   -2.9953
%     4.0000    9.0000    2.8151   -2.0685
%     4.0000   10.0000   -0.1375    0.7211
%     5.0000    1.0000    0.7859    0.1939
%     5.0000    2.0000    1.0539    1.3460
%     5.0000    3.0000   -0.1614   -2.2899
%     5.0000    4.0000   -0.9905    0.2615
%     5.0000    5.0000   -0.4886    0.2933
%     5.0000    6.0000   -0.7160    0.4155
%     5.0000    7.0000   -1.1441    0.1304
%     5.0000    8.0000         0         0
%     5.0000    9.0000    1.5098    0.1957
%     5.0000   10.0000   -0.5994    1.0632
%     5.0000   11.0000    0.9850    0.4458
%     5.0000   12.0000    0.5756    0.2725
%     6.0000    1.0000    0.0632    1.0780
%     6.0000    2.0000   -0.2996   -0.4304
%     6.0000    3.0000    0.3221         0
%     6.0000    4.0000   -0.4810    0.5458
%     6.0000    5.0000   -0.2886   -0.3582
%     6.0000    6.0000   -0.5458    0.2439
%     6.0000    7.0000   -0.3217    0.1983
%     6.0000    8.0000   -2.0891   -2.3607
%     6.0000    9.0000    2.4331   -0.8494
%     6.0000   10.0000    0.5514   -0.4773
%     7.0000    1.0000    0.9449    0.1690
%     7.0000    2.0000    1.2014    0.7749
%     7.0000    3.0000    0.8515    1.9812
%     7.0000    4.0000   -0.7162    0.4262
%     7.0000    5.0000    0.3004    0.3322
%     7.0000    6.0000   -0.1899    0.7231
%     7.0000    7.0000   -0.6514    0.5235
%     7.0000    8.0000   -0.8263   -2.2996
%     7.0000    9.0000    1.0119   -3.7621
%     7.0000   10.0000    0.7376    0.0344
%     8.0000    1.0000    0.2525    0.4472
%     8.0000    2.0000   -2.8289    0.6943
%     8.0000    3.0000   -1.0566   -0.3263
%     8.0000    4.0000   -1.7282    0.1995
%     8.0000    5.0000   -0.5010    0.3310
%     8.0000    6.0000   -0.4300    0.4897
%     8.0000    7.0000    0.4135    0.3492
%     8.0000    8.0000   -2.0210    0.4108
%     8.0000    9.0000    2.0979   -2.9294
%     8.0000   10.0000    0.9467   -0.1973
%     9.0000    1.0000    0.2675   -0.1057
%     9.0000    2.0000   -1.8290    0.3522
%     9.0000    3.0000    1.5962    0.1350
%     9.0000    4.0000   -0.6820    0.3624
%     9.0000    5.0000   -1.3621    0.6077
%     9.0000    6.0000   -0.0321   -0.0218
%     9.0000    7.0000   -0.4964    0.6883
%     9.0000    8.0000   -3.1045    2.3327
%     9.0000    9.0000   -0.0248    2.3842
%     9.0000   10.0000    0.1823   -0.0085
%    10.0000    1.0000    0.5902    0.3301
%    10.0000    2.0000   -0.9337   -0.0429
%    10.0000    3.0000    1.1551    0.7602
%    10.0000    4.0000   -0.5248    0.4150
%    10.0000    5.0000   -0.8387    0.1992
%    10.0000    6.0000   -0.2351    0.3043
%    10.0000    7.0000   -0.0623   -0.1949
%    10.0000    8.0000    2.6987   -0.3787
%    10.0000    9.0000    0.8013    1.2235
%    10.0000   10.0000    0.4047   -0.0129
%    10.0000   11.0000    0.6993   -0.1724
%    10.0000   12.0000    0.8668   -0.1432
%    11.0000    1.0000    0.7297   -0.3697
%    11.0000    2.0000    0.0303   -0.0393
%    11.0000    3.0000    0.2875    0.2546
%    11.0000    4.0000    0.3041   -0.5097
%    11.0000    5.0000   -0.0351    0.2555
%    11.0000    6.0000    0.4894    0.2393
%    11.0000    7.0000   -0.0779    0.2689
%    11.0000    8.0000    2.1584   -1.9745
%    11.0000    9.0000         0         0
%    11.0000   10.0000    1.0911    0.0354
%    12.0000    1.0000   -0.1572   -0.2978
%    12.0000    2.0000   -1.5853    1.7806
%    12.0000    3.0000    0.1998    0.9017
%    12.0000    4.0000    0.4654   -1.5559
%    12.0000    5.0000   -0.6327   -0.4433
%    12.0000    6.0000    0.1856    0.0803
%    12.0000    7.0000   -0.3839    0.2452
%    12.0000    8.0000    0.9533    0.0119
%    12.0000    9.0000    0.4450   -0.2298];

% Save the data
AO = getao;

% Make the offset equal to the golden for BPMs without an offset measurement
% Note:  this logic needs work if the Offset and Golden aren't the same DeviceList!!!
Dev = getbpmlist('BPMx','NoXoffset', 'IgnoreStatus');
i = findrowindex(Dev, Offset(:,1:2));
Offset(i,3) = Golden(i,3);

Dev = getbpmlist('BPMy','NoYoffset', 'IgnoreStatus');
i = findrowindex(Dev, Offset(:,1:2));
Offset(i,4) = Golden(i,4);

% Convert NaN to zeroes
Offset(isnan(Offset(:,3)),3) = 0;
Offset(isnan(Offset(:,4)),4) = 0;


% % New BPM override (2014-10-26)
% % Changed  [4 8] on 2015-01-22 and saved to GoldenOrbit_43NewBPMs.mat
% % xGolden43(11,:) = -0.5199 + .520
% % yGolden43(11,:) = -0.5245+.60-.0755 = ~0
% if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
%     % Since the new BPM attenuators are very different in 2-bunch, the golden was changed
%     % This will not be necessary once the attenuators are calibrated
%     if ispc
%         load '\\als-filer\physbase\machine\ALS\StorageRing\GoldenOrbit_43NewBPMs_TwoBunch.mat'
%     elseif ismac
%         load '/Volumes/physbase/machine/ALS/StorageRing/GoldenOrbit_43NewBPMs_TwoBunch.mat'
%     else
%         load '/home/als/physbase/machine/ALS/StorageRing/GoldenOrbit_43NewBPMs_TwoBunch.mat'
%     end
%     
%     i = findrowindex(d, Golden(:,1:2));
%     Golden(i,3) = xGolden43;
%     Golden(i,4) = yGolden43;
% else
%     if ispc
%         load '\\als-filer\physbase\machine\ALS\StorageRing\GoldenOrbit_43NewBPMs.mat'
%     elseif ismac
%         load '/Volumes/physbase/machine/ALS/StorageRing/GoldenOrbit_43NewBPMs.mat'
%     else
%         load '/home/als/physbase/machine/ALS/StorageRing/GoldenOrbit_43NewBPMs.mat'
%     end
%     
%     i = findrowindex(d, Golden(:,1:2));
%     Golden(i,3) = xGolden43;
%     Golden(i,4) = yGolden43;
%     
% %     i = findrowindex([4 2], Golden(:,1:2));
% %     j = findrowindex([4 2], d);
% %     Golden(i,3) = xGolden43(j) + 4.148;
% %     Golden(i,4) = yGolden43(j) + 3.831;
% end

% % Golden orbit tweaks for new BPM installation
% i = findrowindex([1 3], Golden(:,1:2));
% Golden(i,3) = Golden(i,3) + 1.290;
% Golden(i,4) = Golden(i,4) + 0.050;
% 
% i = findrowindex([1 8], Golden(:,1:2));
% Golden(i,3) = Golden(i,3) + 0.180;
% Golden(i,4) = Golden(i,4) + 0.357;
% 
% i = findrowindex([1 9], Golden(:,1:2));
% Golden(i,3) = Golden(i,3) + 0.233;
% Golden(i,4) = Golden(i,4) - 0.287;
% 
% i = findrowindex([2 3], Golden(:,1:2));
% Golden(i,3) = Golden(i,3) + 0.075;
% Golden(i,4) = Golden(i,4) + 0.320;
% 
% i = findrowindex([6 2], Golden(:,1:2));
% Golden(i,3) = Golden(i,3) + 0.090;
% Golden(i,4) = Golden(i,4) + 0.428;
% 
% i = findrowindex([10 8], Golden(:,1:2));
% Golden(i,3) = Golden(i,3) + 0.831;
% Golden(i,4) = Golden(i,4) - 0.258;
% 
% % i = findrowindex([11 2], Golden(:,1:2));
% % Golden(i,3) = 0.0243;
% % Golden(i,4) = 0.0876;
% % 
% % i = findrowindex([11 3], Golden(:,1:2));
% % Golden(i,3) = -0.0628;
% % Golden(i,4) =  0.0513;
% 
% i = findrowindex([12 2], Golden(:,1:2));
% Golden(i,3) = Golden(i,3) + 0.012;
% Golden(i,4) = Golden(i,4) + 0.287;
% 
% i = findrowindex([12 3], Golden(:,1:2));
% Golden(i,3) = Golden(i,3) + 0.707;
% Golden(i,4) = Golden(i,4) - 0.150;
% 
% % i = findrowindex([12 8], Golden(:,1:2));
% % Golden(i,3) = -0.4759;
% % Golden(i,4) =  0.0633;
% 
% DevList = [11 2;11 3;11 8;11 9; 12 8];
% %x = getx(DevList), y = gety(DevList)
% x = [
%     -0.0701
%     -0.6313
%      0.2099
%      0.1481
%     -0.4748];
% y = [
%     0.0904
%     0.0203
%    -0.0204
%     0.1611
%     0.1149];
% 
% i = findrowindex(DevList, Golden(:,1:2));
% Golden(i,3) = x;
% Golden(i,4) = y;


% Offset orbits
[i, iNotFound, iFoundList] = findrowindex(Offset(:,1:2), AO.BPMx.DeviceList);
if ~isempty(iNotFound)
    fprintf('\n   Warning:  BPMx offsets are specified that are not in the family (setoperationalmode)\n');
end
if size(AO.BPMx.DeviceList,1) ~= length(i)
    fprintf('\n   Warning:  Not all the offsets in the BPMx family are being specified (setoperationalmode)\n');
end
AO.BPMx.Offset = zeros(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Offset(i) = Offset(iFoundList,3);

[i, iNotFound, iFoundList] = findrowindex(Offset(:,1:2), AO.BPMy.DeviceList);
if ~isempty(iNotFound)
    fprintf('\n   Warning:  BPMy offsets are specified that are not in the family (setoperationalmode)\n');
end
if size(AO.BPMy.DeviceList,1) ~= length(i)
    fprintf('\n   Warning:  Not all the offsets in the BPMy family are being specified (setoperationalmode)\n');
end
AO.BPMy.Offset = zeros(size(AO.BPMy.DeviceList,1),1);
AO.BPMy.Offset(i) = Offset(iFoundList,4);


% Golden orbits
[i, iNotFound, iFoundList] = findrowindex(Golden(:,1:2), AO.BPMx.DeviceList);
if ~isempty(iNotFound)
    fprintf('\n   Warning:  BPMx golden values are specified that are not in the family (setoperationalmode)\n');
end
if size(AO.BPMx.DeviceList,1) ~= length(i)
    fprintf('\n   Warning:  Not all the golden orbits in the BPMx family are being specified (setoperationalmode)\n');
end
AO.BPMx.Golden = zeros(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Golden(i) = Golden(iFoundList,3);

[i, iNotFound, iFoundList] = findrowindex(Golden(:,1:2), AO.BPMy.DeviceList);
if ~isempty(iNotFound)
    fprintf('\n   Warning:  BPMy golden values are specified that are not in the family (setoperationalmode)\n');
end
if size(AO.BPMy.DeviceList,1) ~= length(i)
    fprintf('\n   Warning:  Not all the golden orbits in the BPMy family are being specified (setoperationalmode)\n');
end
AO.BPMy.Golden = zeros(size(AO.BPMy.DeviceList,1),1);
AO.BPMy.Golden(i) = Golden(iFoundList,4);


% New BPM family
i = findrowindex(AO.BPM.DeviceList, AO.BPMx.DeviceList);
AO.BPM.X.Golden = zeros(size(AO.BPM.DeviceList,1),1);
AO.BPM.X.Offset = zeros(size(AO.BPM.DeviceList,1),1);
AO.BPM.X.Golden = AO.BPMx.Golden(i);

AO.BPM.Y.Golden = zeros(size(AO.BPM.DeviceList,1),1);
AO.BPM.Y.Offset = zeros(size(AO.BPM.DeviceList,1),1);
i = findrowindex(AO.BPM.DeviceList, AO.BPMy.DeviceList);
AO.BPM.Y.Golden = AO.BPMy.Golden(i);


setao(AO);
