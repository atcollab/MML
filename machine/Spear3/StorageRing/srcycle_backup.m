function srcycle(LatticeFile, DisplayFlag)
%SRCYCLE - Standardize the storage ring magnets to the golden lattice
%
%  INPUTS
%  1. LatticeFile - No input - cycle to the present lattice {Default}
%                  'Golden'  - cycle to the golden lattice
%                   LatticeFilename - cycle to the ConfigSetpoint in that file
%  2. 'Display' or 'NoDisplay' - to varify before standardizing and display results (or not)
%
%  Written by Greg Portmann

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parsing and checking %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FileName='Setpoints';   %default value
DesiredFlag=0;          %do not cycle to present Desired values
if nargin>0 & strcmpi(LatticeFile, 'Desired')
    DesiredFlag=1;   %cycle to Desired values
    DisplayFlag = 'Display';
end

if ~DesiredFlag
LatticeFileDefault = 'Present';  % was 'Golden';
if nargin < 1
    LatticeFile = LatticeFileDefault;
end
if nargin < 2
    DisplayFlag = 'Display';
end
if strcmpi(LatticeFile, 'Display') | strcmpi(LatticeFile, 'NoDisplay')
    DisplayFlag = LatticeFile;
    LatticeFile = LatticeFileDefault;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the proper lattice %
%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(LatticeFile)
    [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat', 'Select a Machine Configuration File for Standardization', getfamilydata('Directory', 'DataRoot'));
    if FilterIndex == 0
        if strcmpi(DisplayFlag, 'Display')
            fprintf('   Storage ring standardization cancelled\n');
        end        
        return
    end
    try
        load([DirectoryName FileName]);
        Lattice = ConfigSetpoint;
    catch
        error(sprintf('Problem getting data from machine configuration file\n%s',lasterr));
    end
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to the lattice file %s\n', [DirectoryName FileName]);
    end        
elseif strcmpi(LatticeFile, 'Present')
    % Present lattice
    Lattice = getmachineconfig;
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to the present lattice\n');
    end
elseif strcmpi(LatticeFile, 'Golden')
    % Golden lattice
    FileName = getfamilydata('OpsData', 'LatticeFile');
    DirectoryName = getfamilydata('Directory', 'OpsData');
    load([DirectoryName FileName]);
    
    Lattice = ConfigSetpoint;
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to the golden lattice %s\n', [DirectoryName FileName]);
    end
elseif ischar(LatticeFile)
    load(LatticeFile);
    Lattice = ConfigSetpoint;
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to lattice file %s\n', LatticeFile);
    end
else
    error('Not sure what lattice to cycle to!');    
end
    
end  %end ~DesiredFlag condition

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Query to begin standardization %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(DisplayFlag, 'Display')
    tmp = questdlg('Begin storage ring standardization?','SRCYCLE','Yes','No','No');
    if strcmpi(tmp,'No')
        fprintf('   Lattice standardization cancelled\n');
        return
    end
end

if DesiredFlag    %user wants to cycle to present Desired Values
  Lattice = getmachineconfig;   %for correctors and kickers only
  FileName='LATVALS';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Set the kickers first %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Set Kicker values
if isfield(Lattice,'KickerAmp')
    disp(  ['   Setting kicker setpoints to: ' FileName])
    setsp('KickerAmp',Lattice.KickerAmp.Setpoint.Data)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Set the correctors second %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NOTE: If standardizing to LATVALS, 'Lattice' is undefined for correctors
FOFBState=getpv('Fofb:ControlState');
setpv('Fofb:ControlState',1);    %0=failed, 1=off, 2=running
NSteps = 5;
HCM0 = getsp('HCM');
VCM0 = getsp('VCM');
if strcmpi(DisplayFlag, 'Display')
disp(  ['   Setting corrector setpoints to: ' FileName])
disp(  ['   FOFB State: ' num2str(FOFBState) ])
end
for k = 1:NSteps
    setsp('HCM', HCM0 + k/NSteps * (Lattice.HCM.Setpoint.Data-HCM0), [], -1);
    setsp('VCM', VCM0 + k/NSteps * (Lattice.VCM.Setpoint.Data-VCM0), [], -1);
    pause(0.1)
end

setpv('Fofb:ControlState',FOFBState);    %put FOFB flag back

disp('   Finished with correctors')

%return   %%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Set the desired setpoints %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~DesiredFlag
setdesired(Lattice);
end  %end ~DesireFlag condition


%%%%%%%%%%%%%%%%%%%
% Start the cycle %
%%%%%%%%%%%%%%%%%%%

% BEND
setpv('MS1-BD:Standardize', 1);

% QF
setpv('PS:QFStandardizeSeq', 1);

% QD
setpv('PS:QDStandardizeSeq', 1);

% Sextupoles
setpv('PS:SextStandardizeSeq', 1);


if strcmpi(DisplayFlag, 'Display')
    pause(2);
    
    % PS:BTSStandardizeNum
    bend = getpv('PS:StandardizeNum');
    qf   = getpv('PS:QFStandardizeNum');
    qd   = getpv('PS:QDStandardizeNum');
    sext = getpv('PS:SextStandardizeNum');
    
    fprintf('   BEND     QFC      QF      QX      QY     QFZ      QF      QX      QY     QFZ     SF      SD     SFM     SDM\n');
    while bend | qf | qd | sext
        bend = getpv('PS:StandardizeNum');
        qf   = getpv('PS:QFStandardizeNum');
        qd   = getpv('PS:QDStandardizeNum');
        sext = getpv('PS:SextStandardizeNum');
        pause(4.5);
        
        BEND = getam('BEND');
        QFC = getam('QFC');
        QF  = getam('QF');
        QFX = getam('QFX');
        QFY = getam('QFY');
        QFZ = getam('QFZ');
        QD  = getam('QD');
        QDX = getam('QDX');
        QDY = getam('QDY');
        QDZ = getam('QDZ');
        SF = getam('SF');
        SD = getam('SD');
        SFM = getam('SFM');
        SDM = getam('SDM');
        fprintf(' %7.1f %7.1f %7.1f %7.1f %7.1f %7.1f %7.1f %7.1f %7.1f %7.1f%7.1f %7.1f %7.1f %7.1f\r', BEND(1), QFC(1), QF(1), QFX(1), QFY(1), QFZ(1), QD(1), QDX(1), QDY(1), QDZ(1), SF(1), SD(1), SFM(1), SDM(1));
    end
    fprintf('\n');
end


% Make sure all the setpoints are there
if ~DesiredFlag
setmachineconfig(Lattice);
end


if strcmpi(DisplayFlag, 'Display')
    fprintf('   Storage ring standardization complete\n');
end