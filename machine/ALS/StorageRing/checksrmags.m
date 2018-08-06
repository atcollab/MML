function NumErrors = checksrmags(LatticeFileName)
%CHECKSRMAGS - Check SR power supplies against a lattice file
%  NumErrors = checksrmags(LatticeFileName)
%
%  INPUTS
%  1. LatticeFileName can be: 1. Lattice file name
%                             2. 'Production' - for the production lattice
%                             3. 'Injection' - for the injeciton lattice
%                             4. Lattice setpoint structure
%                             5. If empty, a lattice is loaded based on the energy
%
%  NOTES:
%  1. Corrector magnet trims cannot be 
%  2. 

% Revision History:
%
% 2003-02-25, Christoph Steier
%     Added a check of corrector magnet setpoints if the lattice is an injection lattice
%     (there is no problem with changed setpoints due to orbit correction or feedback there)
%
% 2005-08-07, Tom Scarvie
% Modified to work with the new Matlab Middle Layer
%
% 2005-12-015, Greg Portmann
% Worked on more new Matlab Middle Layer compatibility


%%%%%%%%%
% Setup %
%%%%%%%%%
CheckCorrectorsFlag = 1;   % Check that the SP-AM is within tolerance 
CheckSetpointFlag = 1;     % Check that the present setpoint matches the lattice file


%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the lattice file %
%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    LatticeFileName = '';
end

if isempty(LatticeFileName)
    GeV = bend2gev;
    if GeV == getfamilydata('Energy')
        [ConfigSetpoint, ConfigMonitor, LatticeFileName] = getproductionlattice;
    elseif GeV == getfamilydata('InjectionEnergy')
        [ConfigSetpoint, ConfigMonitor, LatticeFileName] = getinjectionlattice;
    else
        CheckSetpointFlag = 0;
    end
elseif ischar(LatticeFileName)
    if strcmpi(LatticeFileName, 'Production')
        [ConfigSetpoint, ConfigMonitor, LatticeFileName] = getproductionlattice;
    elseif strcmpi(LatticeFileName, 'Injection')
        [ConfigSetpoint, ConfigMonitor, LatticeFileName] = getinjectionlattice;
    else
        load(LatticeFileName);
        [ConfigSetpoint, ConfigMonitor] = machineconfigsort(MachineConfigStructure);
    end
elseif isstruct(LatticeFileName)
    ConfigSetpoint = LatticeFileName;
else
    CheckSetpointFlag = 0;
    %error('Input #1 must be a lattice file name, ''Production'', ''Injection'', a lattice setpoint structure, or empty.');
end

if CheckSetpointFlag == 0
    % Use the present setpoints
    ConfigSetpoint = getmachineconfig;

    fprintf('   Magnet lattice unknown hence no power supply setpoint checking will be done.\n');
end

if CheckCorrectorsFlag
    if getfbstate
        CheckCorrectorsFlag = 0;
        fprintf('   Fast orbit feedback is running, hence Setpoint-Monitor errors for corrector magnets will not be tested.\n');        
        fprintf('   When fast orbit feedback is turned off, the Trim channel is updated and SP-AM error checking can be done.\n');        
    end
end


% Start checking
NumErrors = 0;


%FamilyCell = findmemberof('MachineConfig','Setpoint');
FamilyCell = {
    'HCM'
    'VCM'
    'QF'
    'QD'
    'SF'
    'SD'
    'SQSF'
    'SQSD'
    'QFA'
    'QDA'
    'BEND'
    'HCMCHICANE'
    'HCMCHICANEM'
    };

try
    [DelHCM, DelVCM, DelQF, DelQD] = ffdeltasp;
catch
    disp('Problem reading FF values');
    DelHCM = 0; DelVCM=0; DelQF=0; DelQD=0;
end

try
    [dummya, dummyb, DelSQSF, DelSQSD] = ffdeltaquad;
catch
    disp('Problem reading FF values');
    DelSQSF=0; DelSQSD=0;
end

for iFamily = 1:length(FamilyCell)
    ErrorFlag = 0;
    Family = FamilyCell{iFamily};
    DevList = family2dev(Family, 1, 1);
    tol = family2tol(Family, DevList);
    
    if strcmp(Family,'QF')
        tol(23)=tol(23)*3;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Make sure the power supplies are on %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isfield(getfamilydata(Family),'On')
        try
            On = getpv(Family, 'On', DevList);
            for i = 1:size(DevList,1)
                if On(i) ~= 1
                    % If the setpoint is zero, it's ok that it's off
                    if ConfigSetpoint.(Family).Setpoint.Data(i) ~= 0
                        if isnan(On(i))
                            fprintf('   %s(%2d,%2d): Cannot tell if this device is on or off!\n', Family, DevList(i,:));
                        else
                            fprintf('   %s(%2d,%2d): Off\n', Family, DevList(i,:));
                            NumErrors = NumErrors + 1;
                        end
                    end
                end
            end
        catch
            fprintf('\n%s\n\n',lasterr);
            fprintf('Problem checking the on/off state of all power supplies.\n');
        end
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Check for the proper setpoint %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if CheckSetpointFlag
        if ~(strcmp(Family,'HCM') | strcmp(Family,'VCM'))
            SP = getpv(Family, 'Setpoint', DevList);
            if strcmp(Family,'QF')
                SP=SP-DelQF;
            elseif strcmp(Family,'QD')
                SP=SP-DelQD;
            end
            if strcmp(Family,'SQSF')
                SP=SP-DelSQSF;
            elseif strcmp(Family,'SQSD')
                SP=SP-DelSQSD;
            end
            [iFound, iMissing] = findrowindex(DevList, ConfigSetpoint.(Family).Setpoint.DeviceList);
            if ~isempty(iMissing)
                for ii = iMissing(:)'
                    fprintf('   %s(%2d,%2d) is not in the lattice file but it''s set to %f.\n', Family, DevList(ii,:), SP(ii));
                    NumErrors = NumErrors + 1;
                end
            end

            GoalSP = ConfigSetpoint.(Family).Setpoint.Data(iFound);
            SP(iMissing) = [];
            DevList(iMissing,:) = [];
            for ii = 1:length(iFound)
                if abs(GoalSP(ii)-SP(ii)) > .001
                    fprintf('   %s(%2d,%2d): GoalSP=%7.3f  SP=%7.3f Amps  (Incorrect Setpoint)\n', Family, DevList(ii,:), GoalSP(ii), SP(ii));
                    NumErrors = NumErrors + 1;
                end
            end
        end
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Check for setpoint - monitor errors %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~ismemberof(Family,'COR') | CheckCorrectorsFlag
        % Get the total setpoint
        if ismemberof(Family,'COR') & ~ismemberof(Family,'HCMCHICANE') %(no Sum function for HCMCHICANEs yet)
            SP = getpv(Family, 'Sum', DevList);
        elseif strcmp(Family,'QF') | strcmp(Family,'QD')
            SP = getpv(Family, 'Sum', DevList);
        else
            SP = getpv(Family, 'Setpoint', DevList);
        end

        AM = getam(Family, DevList);
        for i = 1:size(DevList,1)
            if abs(SP(i)-AM(i)) > tol(i)
                fprintf('   %s(%2d,%2d): SP=%7.3f  AM=%7.3f  SP-AM=%6.3f  Tol=%6.3f Amps  (SP-AM Tolerance Error)\n', Family, DevList(i,:), SP(i), AM(i), SP(i)-AM(i), tol(i));
                NumErrors = NumErrors + 1;
            end
        end
    end
end


% skip checking of feed-forward values for the time being (currently this produces nuisance errors otherwise)

if 0
    %%%%%%%%%%%%%%%%%%%%%%
    % Feed Forward Check %
    %%%%%%%%%%%%%%%%%%%%%%
    try
        [DelHCM, DelVCM, DelQF, DelQD] = ffdeltasp;
        
        Family = 'HCM';
        DevList = family2dev(Family);
        FF1 = getpv(Family, 'FF1');
        FF2 = getpv(Family, 'FF2');
        FF1(isnan(FF1)) = 0;
        FF2(isnan(FF2)) = 0;
        %    iBad = find(DelHCM ~= FF1+FF2);
        iBad = find(abs(DelHCM-(FF1+FF2))>0.001);
        for i = iBad(:)'
            fprintf('   %s(%2d,%2d): FFgoal=%7.3f  FF1+FF2=%7.3f   (Feed Forward Error)\n', Family, DevList(i,:), DelHCM(i), FF1(i)+FF1(i));
            NumErrors = NumErrors + 1;
        end
        
        Family = 'VCM';
        DevList = family2dev(Family);
        FF1 = getpv(Family, 'FF1');
        FF2 = getpv(Family, 'FF2');
        FF1(isnan(FF1)) = 0;
        FF2(isnan(FF2)) = 0;
        %    iBad = find(DelVCM ~= FF1+FF2);
        iBad = find(abs(DelVCM-(FF1+FF2))>0.001);
        for i = iBad(:)'
            fprintf('   %s(%2d,%2d): FFgoal=%7.3f  FF1+FF2=%7.3f   (Feed Forward Error)\n', Family, DevList(i,:), DelVCM(i), FF1(i)+FF1(i));
            NumErrors = NumErrors + 1;
        end
        
        Family = 'QF';
        DevList = family2dev(Family);
        FF = getpv(Family, 'FF');
        FF(isnan(FF)) = 0;
        %    iBad = find(DelQF ~= FF);
        iBad = find(abs(DelQF-FF)>0.001);
        for i = iBad(:)'
            fprintf('   %s(%2d,%2d): FFgoal=%7.3f  FF1+FF2=%7.3f   (Feed Forward Error)\n', Family, DevList(i,:), DelQF(i), FF(i));
            NumErrors = NumErrors + 1;
        end
        
        Family = 'QD';
        DevList = family2dev(Family);
        FF = getpv(Family, 'FF');
        FF(isnan(FF)) = 0;
        %    iBad = find(DelQD ~= FF);
        iBad = find(abs(DelQD-FF)>0.001);
        for i = iBad(:)'
            fprintf('   %s(%2d,%2d): FFgoal=%7.3f  FF1+FF2=%7.3f   (Feed Forward Error)\n', Family, DevList(i,:), DelQD(i), FF(i));
            NumErrors = NumErrors + 1;
        end
        
    catch
        fprintf('\n%s\n\n', lasterr);
        fprintf('   A problem was encountered checking the feed forward values.\n\n');
    end
end

%%%%%%%%%%%%
% RF Check %
%%%%%%%%%%%%
Family = 'RF';
DevList = [1 1];
tol = family2tol(Family, DevList);
SP = getpv(Family, 'Setpoint', DevList);
AM = getpv(Family, 'Monitor',  DevList);


if abs(SP-AM) > tol
    fprintf('   RF frequency:  SP=%9.8f  AM=%9.8f  SP-AM=%9.8f  Tol = %9.8f MHz  (SP-AM Tolerance Error)\n', SP, AM, SP-AM, tol);
    NumErrors = NumErrors + 1;
end

SP = getsp(Family, DevList);
[iFound, iMissing] = findrowindex(DevList, ConfigSetpoint.(Family).Setpoint.DeviceList);

if isempty(iFound)
    fprintf('   RF frequency is not in the lattice file but it''s set to %f MHz.\n', SP);
    NumErrors = NumErrors + 1;
else
    GoalSP = ConfigSetpoint.RF.Setpoint.Data(iFound);
    if 1e6*abs(GoalSP-SP) > 1500
        fprintf('   RF frequency:  GoalSP=%10.6f   SP=%10.6f  GoalSP-SP=%10.6f  MHz  (Slow orbit feedback does change the RF but this seems large)\n', GoalSP, SP, GoalSP, SP);
        NumErrors = NumErrors + 1;
    end
end


%%%%%%%%%%%%%%%%%
% Final Remarks %
%%%%%%%%%%%%%%%%%
if NumErrors > 8
   fprintf('   There were %d storage ring lattice errors found.\n', NumErrors);
end

if NumErrors
    if ischar(LatticeFileName) && ~isempty(LatticeFileName)
        fprintf('   Lattice file name: %s (saved on %s)\n', LatticeFileName, datestr(ConfigSetpoint.BEND.Setpoint.TimeStamp,0));
    end
end


