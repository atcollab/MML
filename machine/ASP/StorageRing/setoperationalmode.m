function varargout = setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Set all the variables associated with an operational mode
%  STATUS = setoperationalmode(ModeNumber)
%
%  If STATUS == 1, the mode has been changed.
%  If STATUS == 0, the mode has NOT been changed.
%
%  See also aoinit, updateatindex
%
% Updated:
%  02/02/2009: ET ModeCell updated to reflect current modes.
%  10/11/2009: ET Returns the if mode changed or not
%  24/02/2012: KW added splitbends all IDs model

global THERING


% Check if the AO exists
checkforao;

ModeCell = {...
    'Mode  1 - 3.0 GeV User Mode (0.0 m Dispersion)';
    'Mode  2 - 3.0 GeV User Mode (0.1 m Dispersion) - SCW @ 0 T';
    'Mode  3 - 3.0 GeV User Mode (0.24 m Dispersion)';
    'Mode  4 - 3.0 GeV Model, single bend (0.0 m Dispersion)';
    'Mode  5 - 3.0 GeV Model, single bend (0.1 m Dispersion)';
    'Mode  6 - Low alpha intermediate lattice';
    'Mode  7 - Low alpha intermediate lattice (-0.7m dispersion)';
    'Mode  8 - 7-fold lattice';
    'Mode  9 - Low alpha intermediate lattice (-0.86m dispersion)';
    'Mode 10 - 3.0 GeV User Mode, all IDs (0.1m dispersion)';
    'Mode 11 - 3.0 GeV User Mode (0.1 m Dispersion) - SCW @ 3 T';
    'Mode 12 - 1.6 GeV User Mode (0.1 m Dispersion) - SCW @ 0 T';
    };

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    [ModeNumber, OKFlag] = listdlg('Name','ASP','PromptString','Select the Operational Mode:',...
        'SelectionMode','single', 'ListString', ModeCell,'ListSize',[450 300]);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        varargout{1} = 0;
        return
    end
end
varargout{1} = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;    
AD.Machine = 'ASP';               % Will already be defined if setpathmml was used
AD.SubMachine = 'StorageRing';    % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.Energy = 3.033; 3.0314; 3.0134; %3.0134           % 19/05/2008 ET machine's energy seems to be ~1.4% lower than the model prediction based on the collective magnetic measurements of quadrupoles and sextupoles.
AD.InjectionEnergy = 3.0134;
AD.HarmonicNumber = 360;

% Defaults RF for disperion and chromaticity measurements (must be in Hardware units) ???
AD.DeltaRFDisp = 2000/4;
AD.DeltaRFChro = [0 -1000 -2000 -1000 0 1000 2000 1000 0]/2;



% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.  Setpv will wait
% 2.2 * TuneDelay to be guaranteed a fresh data point.
AD.TuneDelay = 1.0;

% SP-AM Error level
% AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
%                       -1 -> SP-AM errors are Matlab warnings
%                       -2 -> SP-AM errors prompt a dialog box
%                       -3 -> SP-AM errors are ignored (ErrorFlag=-1 is returned)
AD.ErrorWarningLevel = 0;


%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% MachineName - String used to build directory structure off DataRoot
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
MachineName = 'asp';
AD.OperationalMode = ModeCell{ModeNumber};
if ModeNumber == 1
    % User mode split bends, zero dispersion
    ModeName = 'User0';
    OpsFileExtension = '_user0';
    
    % AT lattice
    [status,res]=system('hostname -s');
    switch lower(strtrim(res))
        case {'cr01opi07'}
            AD.ATModel = 'assr4_splitbends';
            assr4_splitbends cavity4ring;
        otherwise
            AD.ATModel = 'assr4_splitbends_mod';
            assr4_splitbends_mod cavity4ring;
    end
    % 3 cavity operation
    fprintf('*** Starting 3 cavity operation (2000 MV) ***\n')
    cavind = findcells(THERING,'HarmNumber');
    THERING{cavind(1)}.Voltage = 6.79e5; %6.68e5;
    THERING{cavind(2)}.Voltage = 6.86e5; %0;
    THERING{cavind(3)}.Voltage = 0;      %6.58e5;
    THERING{cavind(4)}.Voltage = 6.61e5; %6.48e5;
    
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    % Online and hardware units
    switch2online;
    switch2hw;
    
    % Updates the AT indices in the MiddleLayer with the present AT lattice
    updateatindex;
    % Set the model energy
    setenergymodel(AD.Energy);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %LocoFileDirectory = getfamilydata('Directory','OpsData');
    %setlocodata('SetGains',[LocoFileDirectory,'LOCOFilename?']);
    %setlocodata('LOCO2Model',[LocoFileDirectory,'LOCOFilename']);
    setlocodata('Nominal');
  
%     fittunedisp2([13.29 5.216 0.0],'QFA','QDA','QFB',1)
    setsp('QFA', 1.723428335912745,'physics','model');
    setsp('QDA',-1.021524810038134,'physics','model');
    setsp('QFB', 1.506832980875907,'physics','model');
    
    % Set the nominal chromaticity
    setsp('SFA', 11,'physics','model');
    setsp('SDA', -12,'physics','model');
%     fitchrom2([1,1],'SFB','SDB'); disp([getsp('SFB',1,'physics','model'),getsp('SDB',1,'physics','model')])
    setsp('SFB',  7.363955546172189,'physics','model');
    setsp('SDB', -7.179245538366332,'physics','model');

elseif ModeNumber == 2
    
    % User mode - Split bends, Distributed Dispersion (0.1)
    ModeName = 'User1';
    OpsFileExtension = '_user1';
    
    % AT lattice
    [status,res]=system('hostname -s');
    switch lower(strtrim(res))
        case {'cr01opi07'}
            AD.ATModel = 'assr4_splitbends';
            assr4_splitbends cavity4ring;
        otherwise
            AD.ATModel = 'assr4_splitbends_mod';
            assr4_splitbends_mod cavity4ring;
    end
    % 3 cavity operation
    fprintf('*** Starting 3 cavity operation (2000 MV) ***\n')
    cavind = findcells(THERING,'HarmNumber');
    THERING{cavind(1)}.Voltage = 6.79e5; %6.68e5;
    THERING{cavind(2)}.Voltage = 6.86e5; %0;
    THERING{cavind(3)}.Voltage = 0;      %6.58e5;
    THERING{cavind(4)}.Voltage = 6.61e5; %6.48e5;
        
    % Insert super conducting wiggler
%     insertscw(0);
    
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    switch2online;
    switch2hw;

    % Updates the AT indices in the MiddleLayer with the present AT lattice
    updateatindex;
    % Set the model energy
    setenergymodel(AD.Energy);
    
    % Set model parameters
    setlocodata('Nominal');   
%     fittunedisp2([13.29 5.216 0.10],'QFA','QDA','QFB',1)
    setpv('QFA', +1.733644317160764,'physics','model');
    setpv('QDA', -1.022026077359464,'physics','model');
    setpv('QFB', +1.501323674315535,'physics','model');
    
    % In order to get the right chromaticity
    % operations changed to low chromaticity for BBB operation
    setsp('SFA',  11,'physics','model');
    setsp('SDA', -12,'physics','model');
%     fitchrom2([1,1],'SFB','SDB'); disp([getsp('SFB',1,'physics','model'),getsp('SDB',1,'physics','model')])
    setsp('SFB',  7.758558385071983,'physics','model');
    setsp('SDB', -7.578367804452122,'physics','model');
    
elseif ModeNumber == 3
    
    % User mode - Split bends, Distributed Dispersion (0.24)
    ModeName = 'User2';
    OpsFileExtension = '_user2';
    
    % AT lattice
    [status,res]=system('hostname -s');
    switch lower(strtrim(res))
        case {'cr01opi07'}
            AD.ATModel = 'assr4_splitbends';
            assr4_splitbends cavity4ring;
        otherwise
            AD.ATModel = 'assr4_splitbends_mod';
            assr4_splitbends_mod cavity4ring;
    end
    % 3 cavity operation
    fprintf('*** Starting 3 cavity operation (1900 MV) ***')
    cavind = findcells(THERING,'HarmNumber');
    THERING{cavind(1)}.Voltage = 6.68e5;
    THERING{cavind(2)}.Voltage =6.68e5;
    THERING{cavind(3)}.Voltage = 6.58e5;
    THERING{cavind(4)}.Voltage = 6.48e5;
    
        
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    switch2online;
    switch2hw;

    % Updates the AT indices in the MiddleLayer with the present AT lattice
    updateatindex;
    % Set the model energy
    setenergymodel(AD.Energy);
    
    setlocodata('Nominal');
%     fittunedisp2([13.29 5.216 0.24],'QFA','QDA','QFB',1)
    setpv('QFA', +1.749877620130296,'physics','model');
    setpv('QDA', -1.022984475040535,'physics','model');
    setpv('QFB', +1.492855475998011,'physics','model');

    % Set the nominal chromaticity
    setsp('SFA', 11,'physics','model');
    setsp('SDA', -12,'physics','model');
%     fitchrom2([1,1],'SFB','SDB'); disp([getsp('SFB',1,'physics','model'),getsp('SDB',1,'physics','model')])
    setsp('SFB',  9.397721020313263,'physics','model');
    setsp('SDB', -9.152478741386210,'physics','model');
    
elseif ModeNumber == 4
    % single bends with zero-dispersion
    ModeName = 'Model';
    OpsFileExtension = '';

    % AT lattice
    AD.ATModel = 'assr4';
    assr4;
    % 3 cavity operation
    fprintf('*** Starting 3 cavity operation (1900 MV) ***')
    cavind = findcells(THERING,'HarmNumber');
    THERING{cavind(1)}.Voltage = 6.68e5;
    THERING{cavind(2)}.Voltage = 0;
    THERING{cavind(3)}.Voltage = 6.58e5;
    THERING{cavind(4)}.Voltage = 6.48e5;
    
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    switch2sim;
    switch2hw;
    
    % Updates the AT indices in the MiddleLayer with the present AT lattice
    updateatindex;
    % Set the model energy
    setenergymodel(AD.Energy);
    
    setlocodata('Nominal');
%     fittunedisp2([13.29 5.216 0.0],'QFA','QDA','QFB',1)
    setsp('QFA', 1.721721539410648,'physics','model');
    setsp('QDA',-1.018590780985194,'physics','model');
    setsp('QFB', 1.505499577114660,'physics','model');
    
    % Set the nominal chromaticity
    setsp('SFA', 11,'physics','model');
    setsp('SDA', -12,'physics','model');
%     fitchrom2([1,1],'SFB','SDB'); disp([getsp('SFB',1,'physics','model'),getsp('SDB',1,'physics','model')])
    setsp('SFB',  7.376336647962120,'physics','model');
    setsp('SDB', -7.127633424850286,'physics','model');
    
elseif ModeNumber == 5
    % Model mode, single bends with distributed dispersion (0.1)
    ModeName = 'Model';
    OpsFileExtension = '';

    % AT lattice
    AD.ATModel = 'assr4';
    assr4 cavity4ring;
    % 3 cavity operation
    fprintf('*** Starting 3 cavity operation (1900 MV) ***')
    cavind = findcells(THERING,'HarmNumber');
    THERING{cavind(1)}.Voltage = 6.68e5;
    THERING{cavind(2)}.Voltage = 0;
    THERING{cavind(3)}.Voltage = 6.58e5;
    THERING{cavind(4)}.Voltage = 6.48e5;
    
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);


    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    % Tune processor delay: delay required to wait
    % to have a fresh tune measurement after changing
    % a variable like the RF frequency.  Setpv will wait
    % 2.2 * TuneDelay to be guaranteed a fresh data point.
    AD.TuneDelay = 0;

    switch2sim;
    switch2hw;
    
    % Updates the AT indices in the MiddleLayer with the present AT lattice
    updateatindex;
    % Set the model energy
    setenergymodel(AD.Energy);
    
%     fittunedisp2([13.29 5.216 0.10],'QFA','QDA','QFB',1)
    setpv('QFA', +1.731975160162291,'physics','model');
    setpv('QDA', -1.019100405961120,'physics','model');
    setpv('QFB', +1.499963551732084,'physics','model');
    
    % In order to get the right chromaticity
    % operations changed to low chromaticity for BBB operation
    setsp('SFA',  11,'physics','model');
    setsp('SDA', -12,'physics','model');
%     fitchrom2([1,1],'SFB','SDB'); disp([getsp('SFB',1,'physics','model'),getsp('SDB',1,'physics','model')])
    setsp('SFB',  7.770807107941121,'physics','model');
    setsp('SDB', -7.502482318683351,'physics','model');
    
elseif ModeNumber == 6
    
    % Low alpha intermediate lattice with -0.5 meter dispersion
    ModeName = 'Alpha_intermediate';
    OpsFileExtension = '_alpha_int';
    
    % AT lattice using new assr4 with modified bends.
    AD.ATModel = 'assr4_modbend'; 
    assr4_modbend;
    
    AD.DeltaRFChro = AD.DeltaRFChro/2;
        
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    switch2online;
    switch2hw;

    % Updates the AT indices in the MiddleLayer with the present AT lattice
    updateatindex;
    % Set the model energy
    setenergymodel(AD.Energy);
    
    setlocodata('Nominal');
    setsp('QFA', 1.717973104075701,'physics','model');
    setsp('QDA', -1.071945364781163,'physics','model');
    setsp('QFB', 1.565332600016605,'physics','model'); 

elseif ModeNumber == 7
    
    % Low alpha intermediate lattice with -0.70 meter dispersion
    ModeName = 'Alpha_intermediate2';
    OpsFileExtension = '_alpha_int2';
    
    % AT lattice using new assr4 with modified bends.
    AD.ATModel = 'assr4_splitbends_mod'; 
%     assr4_modbend;
    assr4_splitbends_mod;
    % 3 cavity operation
    fprintf('*** Starting 3 cavity operation (1900 MV) ***')
    cavind = findcells(THERING,'HarmNumber');
    THERING{cavind(1)}.Voltage = 6.68e5;
    THERING{cavind(2)}.Voltage = 0;
    THERING{cavind(3)}.Voltage = 6.58e5;
    THERING{cavind(4)}.Voltage = 6.48e5;
    
    
    % Momentum compaction factor reduced by factor 10. So requires RF
    % change also scales by factor 10.
    AD.DeltaRFDisp = 250/10;
    AD.DeltaRFChro = AD.DeltaRFChro/10*3;
        
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    switch2online;
    switch2hw;

    % Updates the AT indices in the MiddleLayer with the present AT lattice
    updateatindex;
    % Set the model energy
    setenergymodel(AD.Energy);
    
    setlocodata('Nominal');
%     setsp('QFA', 1.701360482677673,'physics','model');
%     setsp('QDA', -1.072306322936900 ,'physics','model');
%     setsp('QFB', 1.576013680596304,'physics','model');
%     setsp('QFA', 1.702923622325624 ,'physics','model');
%     setsp('QDA', -1.048908889625475 ,'physics','model');
%     setsp('QFB', 1.571570870143046,'physics','model'); 
      % Modbend model for -0.75 m dispersion
%     setsp('QFA', 1.667596906749336 ,'physics','model');
%     setsp('QDA', -1.022625725276466 ,'physics','model');
%     setsp('QFB', 1.528329348576760,'physics','model'); 
    % for -0.7 meter dispersion
%     setsp('QFA', 1.672129504597714 ,'physics','model');
%     setsp('QDA', -1.024920210424092  ,'physics','model');
%     setsp('QFB', 1.539699300919924,'physics','model'); 
    fittunedisp2([13.29 5.216 -0.7],'QFA','QDA','QFB',1);

elseif ModeNumber == 8
    
    % 7-fold lattice for custom straigth section betas and beam sizes.
    ModeName = 'SevenFold_Lattice';
    OpsFileExtension = '_7fold';
    
    % AT lattice using new assr4 with modified bends.
    AD.ATModel = 'assr4'; 
    assr4_splitbends;
    
    % Momentum compaction factor reduced by factor 10. So requires RF
    % change also scales by factor 10.
    AD.DeltaRFDisp = 250;
    AD.DeltaRFChro = AD.DeltaRFChro;
        
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    switch2online;
    switch2hw;

    % Updates the AT indices in the MiddleLayer with the present AT lattice
    updateatindex;
    % Set the model energy
    setenergymodel(AD.Energy);
    
    setlocodata('Nominal');
    q1 = [];
    q2 = [];
    for i=1:7
        q1 = [q1 ([1 4]+(i-1)*4)];
        q2 = [q2 ([2 3]+(i-1)*4)];
    end
    % 0.1 disp and 1.5 meter betay in first straight
    setsp('QFA', 1.606767660323437,elem2dev('QFA',q2),'physics','model');
    setsp('QFA', 1.933334650614699,elem2dev('QFA',q1),'physics','model');
    setsp('QDA', -1.131939477770982,elem2dev('QDA',q2),'physics','model');
    setsp('QDA', -0.920134397770982,elem2dev('QDA',q1),'physics','model');
    setsp('QFB', 1.448641081159739,elem2dev('QFB',q2),'physics','model');
    setsp('QFB', 1.542221081159739,elem2dev('QFB',q1),'physics','model');
    
    % In order to get the right chromaticity
    setsp('SFA', 16.89,'physics','model');
    setsp('SDA', -16.49,'physics','model');
    fitchrom2([3.2 13],'SFB','SDB')

elseif ModeNumber == 9
    % Low alpha intermediate lattice with -0.86 meter dispersion
    ModeName = 'Alpha_intermediate3';
    OpsFileExtension = '_alpha_int3';
    
    % AT lattice using new assr4 with modified bends.
    AD.ATModel = 'assr4_splitbends_mod'; 
%     assr4_modbend;
    assr4_splitbends_mod;
    % 3 cavity operation
    fprintf('*** Starting 3 cavity operation (1900 MV) ***')
    cavind = findcells(THERING,'HarmNumber');
    THERING{cavind(1)}.Voltage = 6.68e5;
    THERING{cavind(2)}.Voltage = 0;
    THERING{cavind(3)}.Voltage = 6.58e5;
    THERING{cavind(4)}.Voltage = 6.48e5;
    
    fittunedisp2([13.29 5.216 -0.86],'QFA','QDA','QFB',1);
    
    % Momentum compaction factor reduced by factor 10. So requires RF
    % change also scales by factor 10.
    AD.DeltaRFDisp = 250/10;
    AD.DeltaRFChro = AD.DeltaRFChro/10;
        
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???
    % In order to get the right chromaticity
    setsp('SFA', 11,'physics','model');
    setsp('SDA', -10.4,'physics','model');
    fitchrom2([1 1],'SFB','SDB')
    
    switch2online;
    switch2hw;

    % Updates the AT indices in the MiddleLayer with the present AT lattice
    updateatindex;
    % Set the model energy
    setenergymodel(AD.Energy);
    
elseif ModeNumber == 10
    
    % User mode - Split bends, Distributed Dispersion (0.1)
    ModeName = 'User1';
    OpsFileExtension = '_user1';
    
    % AT lattice
    AD.ATModel = 'assr4_splitbends_kent'; 
    assr4_splitbends_kent cavity4ringkent;
    
        
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    switch2online;
    switch2hw;

    % Updates the AT indices in the MiddleLayer with the present AT lattice
    updateatindex;
    % Set the model energy
    setenergymodel(AD.Energy);
    
    % Set model parameters
    setlocodata('Nominal');
    
%     fittunedisp2([13.29 5.214 0.10],'QFA','QDA','QFB',1)
    
    setsp('QFA', 1.735450634682162,'physics','model');
    setsp('QDA',-1.026232260610199,'physics','model');
    setsp('QFB', 1.502798566761560,'physics','model');
    
    % In order to get the right chromaticity
    setsp('SFA', 17,'physics','model');
    setsp('SDA', -16.6,'physics','model');
    fitchrom2([3.2 13],'SFB','SDB')
    
%     idind = findcells(THERING,'FamName','ID');
%     kx =  0.0003416;
%     ky = -0.0210746;
%     THERING{idind(12)}.M66(2,1) = kx;
%     THERING{idind(12)}.M66(4,3) = ky;
elseif ModeNumber == 11
    
    % User mode - Split bends, Distributed Dispersion (0.1)
    ModeName = 'User1';
    OpsFileExtension = '_user1';
    
    % AT lattice
    AD.ATModel = 'assr4_splitbends'; 
    assr4_splitbends cavity4ring;
    
        
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    switch2online;
    switch2hw;

    % Updates the AT indices in the MiddleLayer with the present AT lattice
    updateatindex;
    % Set the model energy
    setenergymodel(AD.Energy);
    
    % Set model parameters
    setlocodata('Nominal');
    
%     fittunedisp2([13.29 5.214 0.10],'QFA','QDA','QFB',1)
    
    setsp('QFA', 1.735450634682162,'physics','model');
    setsp('QDA',-1.026232260610199,'physics','model');
    setsp('QFB', 1.502798566761560,'physics','model');
    
    % In order to get the right chromaticity
    setsp('SFA', 17,'physics','model');
    setsp('SDA', -16.6,'physics','model');
    fitchrom2([3.2 13],'SFB','SDB')
    
      % SCW at 4.3T
%     global THERING
%     idind = findcells(THERING,'FamName','ID');
%     kx = [ 0.0026];
%     ky = [-0.1219];
%     THERING{idind(8)}.M66(2,1) = kx;
%     THERING{idind(8)}.M66(4,3) = ky;
    
     % SCW at 3.0 T
     global THERING
     idind = findcells(THERING,'FamName','ID');

     % Measured with increasing field strength
     ii = 2;
     gaps = [3 2 1.4 1.0 0.2 0];
     kx = [-0.000831772685971 -0.000292523070982 -0.000583821679539  0.000059901469698 0 0];
     ky = [-0.071186619313300 -0.034495700926302 -0.019418887097436 -0.011923601576230 0 0];
     measdate = '20.12.2014';
     load /asp/usr/scripts/insertiondevice/feedforward/WIG_08_SCW/SR08ID01_SCW_QuadFF_2014-12-20_18-41-43-upramp
     
%      kx = [-0.0012];
%      ky = [-0.0369];
%      load /asp/usr/scripts/insertiondevice/feedforward/WIG_08_SCW/SR08ID01_SCW_QuadFF_2013-01-25_16-09-11.mat
     
%      kx = [0.0098];
%      ky = [-0.0551];
%      load /asp/usr/scripts/insertiondevice/feedforward/WIG_08_SCW/SR08ID01_SCW_QuadFF_2013-01-25_20-20-45.mat
%      
%      kx = -0.001269426242865;
%      ky = -0.064681552652870;
%      load /asp/usr/scripts/insertiondevice/feedforward/WIG_08_SCW/SR08ID01_SCW_QuadFF_2013-01-25_22-27-26.mat
     
     THERING{idind(8)}.M66(2,1) = kx(ii);
     THERING{idind(8)}.M66(4,3) = ky(ii);
    
     stepsp('QFA',idcorrection.qfasd(:,ii),'model','hardware');
     stepsp('QDA',idcorrection.qdasd(:,ii),'model','hardware');
     stepsp('QFB',idcorrection.qfbsd(:,ii),'model','hardware');

elseif ModeNumber == 12
    
    % User mode - Split bends, Distributed Dispersion (0.1)
    ModeName = 'Lowenergy';
    OpsFileExtension = '_lowenergy';
    
    % Set the ring energy
    AD.Energy = 1.62;
    AD.InjectionEnergy = 1.62;
        
    % AT lattice
    AD.ATModel = 'assr4_splitbends'; 
    assr4_splitbends cavity4ring;
    % 3 cavity operation
    fprintf('*** Starting 3 cavity operation (1900 MV) ***')
    cavind = findcells(THERING,'HarmNumber');
    THERING{cavind(1)}.Voltage = 2.5e5; 6.68e5;
    THERING{cavind(2)}.Voltage = 2.5e5; 0;
    THERING{cavind(3)}.Voltage = 0;     6.58e5;
    THERING{cavind(4)}.Voltage = 2.5e5; 6.48e5;
    
    % Set the model energy
    setenergymodel(1.62);
        
    % Golden TUNE is with the TUNE family (This could have been in aspphysdata)  % ???
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.290
        0.216
        NaN];
    
    % Reset the deltarespmat because the default is in HW units and for 3
    % GeV.
    AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM', 'Setpoint', 1.8e-5*AD.Energy/3.03, AO.HCM.DeviceList);
    AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM', 'Setpoint', 0.9e-5*AD.Energy/3.03, AO.VCM.DeviceList);
    
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];   % ???

    switch2online;
    switch2hw;

    % Updates the AT indices in the MiddleLayer with the present AT lattice
    updateatindex;
    
    % Set model parameters
    setlocodata('Nominal');
    
%     fittunedisp2([13.29 5.214 0.10],'QFA','QDA','QFB',1)
    
    % 0.1 m disp
%     setpv('QFA', +1.735451639222026,'physics','model');
%     setpv('QDA', -1.026238981593949,'physics','model');
%     setpv('QFB', +1.502800258212542,'physics','model');

    % 0.24 m disp
    setpv('QFA', +1.751424202841732,'physics','model');
    setpv('QDA', -1.026976173811566,'physics','model');
    setpv('QFB', +1.494479036840916,'physics','model');

    
    % In order to get the right chromaticity
    setsp('SFA', 17,'physics','model');
    setsp('SDA', -16.6,'physics','model');
    fitchrom2([3.2 13],'SFB','SDB');
    
else
    error('Operational mode unknown');
end


% Set the AD directory path
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;

%Application Programs WJC Sept 18, 2006
AD.Directory.Orbit = [MMLROOT, 'applications', filesep, 'orbit', filesep, 'asp', filesep];
AD.Directory.SOFB  = [MMLROOT, 'applications', filesep, 'SOFB', filesep];

% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);


% Cavity and radiation
setcavity off;        % Needed for tune
setradiation off;     % ???
fprintf('   Radiation and Cavities are OFF. Use setcavity/setradiation to modify\n'); 

% Momentum compaction factor
MCF = getmcf('Model');
if isnan(MCF)
    AD.MCF = 0.0020;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);

% Change defaults for LabCA if using it
try
    if exist('lcaSetRetryCount','file')
        % read dummy pv to initialize labca
        % ChannelName = family2channel('BPMx');
        % lcaGet(family2channel(ChannelName(1,:));

        % Retry count
        % 5/4/2017 Eugene: set to 100 so the total timeout is only 0.5s
        % rather than 10 seconds!
        RetryCountNew = 100;  % Default: 599-old labca, 299-labca_2_1_beta, 
        RetryCount = lcaGetRetryCount;
        lcaSetRetryCount(RetryCountNew);
        if RetryCount ~= RetryCountNew
            fprintf('   Setting LabCA retry count to %d (was %d)\n', RetryCountNew, RetryCount);
        end

        % Timeout
        TimeoutNew = 0.1;  % Defaul: .05-old labca, .1-labca_2_1_beta
        Timeout = lcaGetTimeout;
        lcaSetTimeout(TimeoutNew);
        if abs(Timeout - TimeoutNew) > 1e-5
            fprintf('   Setting LabCA TimeOut to %f (was %f)\n', TimeoutNew, Timeout);
        end
            
        % To avoid UDF errors, set the WarnLevel to 4 (Default is 3)
        lcaSetSeverityWarnLevel(4);
        fprintf('   Setting lcaSetSeverityWarnLevel to 4 to avoid annoying UDF errors.\n');
    end
catch
    fprintf('   LabCA Timeout not set, need to run lcaSetRetryCount(200), lcaSetTimeout(.01).\n');
end

fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);


