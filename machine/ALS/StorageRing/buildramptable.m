function buildramptable
%BUILDRAMPTABLE - Builds a ramp table used by amp2k and k2amp
%  Builds the ramp tables for the major magnet families: BEND, QFA, QDA, QF, QD, SF, SD.
%  The online model converts for amp2k and k2amp based on this function.
%
%  NOTES
%  1. The AT model must be accurate before running this function.  Ideally, the AT 
%     model will be the best LOCO calibrated model.
%
%  See also k2amp, amp2k

%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%
% Ramp up table %
%%%%%%%%%%%%%%%%%

OpsDataDirectory = getfamilydata('Directory', 'OpsData');

iFileSep = findstr(OpsDataDirectory, filesep);
% if length(iFileSep) > 0
%     MasterRampDirectory = [OpsDataDirectory(1:iFileSep(end-2)), 'StorageRing', filesep];
% else
%     error('Problem knowing the directory location for the master ramp text file.');
% end
% load([MasterRampDirectory, 'rampmastup.txt']);

% It's best not to assume data files are on the path for stand-alone 
% (or use flag -a to include it in the compile, which is what we've doing now)
load('rampmastup.txt');
a = rampmastup;

RampTable.GeV           = a(1:end-1,1)';
RampTable.BEND.Setpoint = a(1:end-1,2)';
RampTable.QFA.Setpoint  = a(1:end-1,3)';
RampTable.QF.Setpoint   = a(1:end-1,4)';
RampTable.QD.Setpoint   = a(1:end-1,5)';
RampTable.SF.Setpoint   = a(1:end-1,6)';
RampTable.SD.Setpoint   = a(1:end-1,7)';


% Normalized tables
RampTable.GeV           = (RampTable.GeV          - RampTable.GeV(1))           / (RampTable.GeV(end)          - RampTable.GeV(1));
RampTable.BEND.Setpoint = (RampTable.BEND.Setpoint- RampTable.BEND.Setpoint(1)) / (RampTable.BEND.Setpoint(end)- RampTable.BEND.Setpoint(1));
RampTable.QFA.Setpoint  = (RampTable.QFA.Setpoint - RampTable.QFA.Setpoint(1))  / (RampTable.QFA.Setpoint(end) - RampTable.QFA.Setpoint(1));
RampTable.QF.Setpoint   = (RampTable.QF.Setpoint  - RampTable.QF.Setpoint(1))   / (RampTable.QF.Setpoint(end)  - RampTable.QF.Setpoint(1));
RampTable.QD.Setpoint   = (RampTable.QD.Setpoint  - RampTable.QD.Setpoint(1))   / (RampTable.QD.Setpoint(end)  - RampTable.QD.Setpoint(1));
RampTable.SF.Setpoint   = (RampTable.SF.Setpoint  - RampTable.SF.Setpoint(1))   / (RampTable.SF.Setpoint(end)  - RampTable.SF.Setpoint(1));
RampTable.SD.Setpoint   = (RampTable.SD.Setpoint  - RampTable.SD.Setpoint(1))   / (RampTable.SD.Setpoint(end)  - RampTable.SD.Setpoint(1));

% Base QDA on QD???
RampTable.QDA.Setpoint   = (RampTable.QD.Setpoint  - RampTable.QD.Setpoint(1))   / (RampTable.QD.Setpoint(end)  - RampTable.QD.Setpoint(1));

% RampTable.HCMCHICANE.Setpoint = linspace(0, 1, length(RampTable.GeV));
% RampTable.VCMCHICANE.Setpoint = linspace(0, 1, length(RampTable.GeV));


% Add the K values to the ramp table (get from the AT lattice)
fprintf('   The k-value for the ramp tables come from the present AT\n');
fprintf('   lattice so make sure the proper AT lattice is loaded.\n');
FieldNamesCell = fieldnames(RampTable);
for i = 1:length(FieldNamesCell)
    if ~strcmpi(FieldNamesCell{i}, 'GeV')
        RampTable.(FieldNamesCell{i}).Physics = getpvmodel(FieldNamesCell{i}, 'Setpoint', family2dev(FieldNamesCell{i},0), 'Physics');
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add the upper & lower lattices of the cycle %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Absolute table

% Get the upper and lower cycled lattices
%GeVUpper = 1.89086196873342;  % 1.894, 1.8904 or 1.89086196873342???
%GeVLower = 1.522;             % Most operational modes use 1.522 GeV injection
%GeVUpper = getfamilydata('Energy');
%GeVLower = getfamilydata('InjectionEnergy');

GeVUpper = getfamilydata('HysteresisLoopUpperEnergy');
GeVLower = getfamilydata('HysteresisLoopLowerEnergy');

load(getfamilydata('OpsData', 'HysteresisLoopUpperLattice'));
if exist('MachineConfigStructure','var')
    % New method
    [ConfigSetpoint, ConfigMonitor] = machineconfigsort(MachineConfigStructure);
    clear MachineConfigStructure
end
RampTable.UpperLattice.Setpoint = ConfigSetpoint;
RampTable.UpperLattice.Monitor  = ConfigMonitor;

load(getfamilydata('OpsData', 'HysteresisLoopLowerLattice'));
if exist('MachineConfigStructure','var')
    % New method
    [ConfigSetpoint, ConfigMonitor] = machineconfigsort(MachineConfigStructure);
    clear MachineConfigStructure
end
RampTable.LowerLattice.Setpoint = ConfigSetpoint;
RampTable.LowerLattice.Monitor  = ConfigMonitor;

% % Remove some families
% RampTable.UpperLattice.Setpoint = RemoveSomeFamilies(RampTable.UpperLattice.Setpoint);
% RampTable.UpperLattice.Monitor  = RemoveSomeFamilies(RampTable.UpperLattice.Monitor);
% RampTable.LowerLattice.Setpoint = RemoveSomeFamilies(RampTable.LowerLattice.Setpoint);
% RampTable.LowerLattice.Monitor  = RemoveSomeFamilies(RampTable.LowerLattice.Monitor);
% 
% % Remove some fields
% RampTable.UpperLattice.Setpoint = RemoveSomeFields(RampTable.UpperLattice.Setpoint);
% RampTable.UpperLattice.Monitor  = RemoveSomeFields(RampTable.UpperLattice.Monitor);
% RampTable.LowerLattice.Setpoint = RemoveSomeFields(RampTable.LowerLattice.Setpoint);
% RampTable.LowerLattice.Monitor  = RemoveSomeFields(RampTable.LowerLattice.Monitor);

fprintf('   Building a table to ramp between %.4f and %.4f GeV.\n', GeVLower, GeVUpper);
fprintf('   Change AD.Energy or AD.InjectionEnergy if this is not correct.\n');

RampTable.GeV = (GeVUpper - GeVLower) * RampTable.GeV + GeVLower;


save([OpsDataDirectory, 'alsrampup'], 'RampTable');


%%%%%%%%%%%%%%%%%%%
% Ramp down table %
%%%%%%%%%%%%%%%%%%%
%load([MasterRampDirectory, 'rampmastdown.txt']);
load('rampmastdown.txt');
a = rampmastdown;

RampTable.GeV           = a(2:end,1)';
RampTable.BEND.Setpoint = a(2:end,2)';
RampTable.QFA.Setpoint  = a(2:end,3)';
RampTable.QF.Setpoint   = a(2:end,4)';
RampTable.QD.Setpoint   = a(2:end,5)';
RampTable.SF.Setpoint   = a(2:end,6)';
RampTable.SD.Setpoint   = a(2:end,7)';


% Store normalized table
RampTable.GeV           = (RampTable.GeV          - RampTable.GeV(end))           / (RampTable.GeV(1)          - RampTable.GeV(end));
RampTable.BEND.Setpoint = (RampTable.BEND.Setpoint- RampTable.BEND.Setpoint(end)) / (RampTable.BEND.Setpoint(1)- RampTable.BEND.Setpoint(end));
RampTable.QFA.Setpoint  = (RampTable.QFA.Setpoint - RampTable.QFA.Setpoint(end))  / (RampTable.QFA.Setpoint(1) - RampTable.QFA.Setpoint(end));
RampTable.QF.Setpoint   = (RampTable.QF.Setpoint  - RampTable.QF.Setpoint(end))   / (RampTable.QF.Setpoint(1)  - RampTable.QF.Setpoint(end));
RampTable.QD.Setpoint   = (RampTable.QD.Setpoint  - RampTable.QD.Setpoint(end))   / (RampTable.QD.Setpoint(1)  - RampTable.QD.Setpoint(end));
RampTable.SF.Setpoint   = (RampTable.SF.Setpoint  - RampTable.SF.Setpoint(end))   / (RampTable.SF.Setpoint(1)  - RampTable.SF.Setpoint(end));
RampTable.SD.Setpoint   = (RampTable.SD.Setpoint  - RampTable.SD.Setpoint(end))   / (RampTable.SD.Setpoint(1)  - RampTable.SD.Setpoint(end));

% Base QDA on QD???
RampTable.QDA.Setpoint  = (RampTable.QD.Setpoint  - RampTable.QD.Setpoint(end))   / (RampTable.QD.Setpoint(1)  - RampTable.QD.Setpoint(end));

%RampTable.HCMCHICANE.Setpoint = linspace(0, 1, length(RampTable.GeV));
%RampTable.VCMCHICANE.Setpoint = linspace(0, 1, length(RampTable.GeV));


% Absolute table
RampTable.GeV = (GeVUpper - GeVLower) * RampTable.GeV + GeVLower;

% MagnetTable = (UpperLattice(iDevUpper) - LowerLattice(iDevLower)) * MagnetTable;
% for j = 1:size(MagnetTable,1)
%     MagnetTable(j,:) = MagnetTable(j,:) + LowerLattice(iDevLower(j));
% end


% K values
for i = 1:length(FieldNamesCell)
    if ~strcmpi(FieldNamesCell{i}, 'GeV')
        RampTable.(FieldNamesCell{i}).Physics = getpvmodel(FieldNamesCell{i}, 'Setpoint', family2dev(FieldNamesCell{i},0), 'Physics');
    end
end

save([OpsDataDirectory, 'alsrampdown'], 'RampTable');

fprintf('   Ramp  up  table saved to %s.mat\n', [OpsDataDirectory, 'alsrampup']);
fprintf('   Ramp down table saved to %s.mat\n', [OpsDataDirectory, 'alsrampdown']);
return


% function Lattice = RemoveSomeFamilies(Lattice)
% % Remove families
% RemoveFamilyNames = {'HCMCHICANE','HCMCHICANEM','VCMCHICANE','SQEPU','SQSF','SQSD','RF','GeV','DCCT'};
% j = find(isfield(Lattice, RemoveFamilyNames));
% Lattice = rmfield(Lattice, RemoveFamilyNames(j));
% return
% 
% 
% function Lattice  = RemoveSomeFields(Lattice);
% % Remove fields
% RemoveFieldNames = {'RampRate','TimeConstant','DAC','Trim','FF1','FF2'};
% Fields = fieldnames(Lattice);
% for i = 1:length(Fields)
%     j = find(isfield(Lattice.(Fields{i}), RemoveFieldNames));
%     Lattice.(Fields{i}) = rmfield(Lattice.(Fields{i}), RemoveFieldNames(j));
% end
% return

