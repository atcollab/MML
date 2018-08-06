function GeV = bend2gev(varargin)
%BEND2GEV - Compute the energy
% GeV = bend2gev(Family, Field, Amps, DeviceList)
%
%  INPUTS
%  1. Bend - Bend magnet family {Optional}
%  2. Field - Field {Optional}
%  3. Amps - Bend magnet current
%  4. DeviceList - Bend magnet device list to reference energy to {Default: BEND(1,1)}
%
%  OUTPUTS
%  1. GeV - Electron beam energy [GeV]
%
%  Written by Greg Portmann


GeV = 3;

% % Default
% Family = '';
% Field = '';
% Amps = [];
% DeviceList = [];
% BranchFlag = [];
% 
% ModeFlag = '';  % model, online, manual
% UnitsFlag = ''; % hardware, physics
% for i = length(varargin):-1:1
%     if isstruct(varargin{i})
%         % Ignor structures
%     elseif iscell(varargin{i})
%         % Ignor cells
%     elseif strcmpi(varargin{i},'struct')
%         varargin(i) = [];
%     elseif strcmpi(varargin{i},'numeric')
%         varargin(i) = [];
%     elseif strcmpi(varargin{i},'physics')
%         UnitsFlag = 'Physics';
%         varargin(i) = [];
%     elseif strcmpi(varargin{i},'hardware')
%         UnitsFlag = varargin{i};
%         varargin(i) = [];
%     elseif strcmpi(varargin{i},'simulator') | strcmpi(varargin{i},'model')
%         ModeFlag = varargin{i};
%         varargin(i) = [];
%     elseif strcmpi(varargin{i},'online')
%         ModeFlag = varargin{i};
%         varargin(i) = [];
%     elseif strcmpi(varargin{i},'manual')
%         ModeFlag = varargin{i};
%         varargin(i) = [];
%     end        
% end
% 
% 
% if length(varargin) >= 1
%     if ischar(varargin{1})
%         Family = varargin{1};
%         varargin(1) = [];
%     else
%         Amps = varargin{1};
%         varargin(1) = [];
%         if length(varargin) >= 1
%             DeviceList = varargin{1};
%             varargin(1) = [];
%         end
%         if length(varargin) >= 1
%             BranchFlag = varargin{1};
%             varargin(1:end) = [];
%         end
%     end
% end
% if length(varargin) >= 1 & ischar(varargin{1})
%     Field = varargin{1};
%     varargin(1) = [];
% end
% if length(varargin) >= 1
%     Amps = varargin{1};
%     varargin(1) = [];
% end
% if length(varargin) >= 1
%     DeviceList = varargin{1};
%     varargin(1) = [];
% end
% if length(varargin) >= 1
%     BranchFlag = varargin{1};
%     varargin(1) = [];
% end
% 
% 
% if isempty(Family)
%     Family = 'BEND';
% end
% if isempty(ModeFlag)
%     ModeFlag = getmode(Family);
% end
% 
% if isempty(Field)
%     Field = 'Setpoint';
% end
% if isempty(DeviceList)
%     DeviceList = family2dev(Family);
%     if all(size(Amps)==[1 1]) | isempty(Amps)
%         DeviceList = DeviceList(1,:);
%     end
% end
% 
% 
% % Hysteresis branch
% if isempty(BranchFlag)
%     if strcmpi(getfamilydata('HysteresisBranch'),'Lower')
%         % Lower branch
%         BranchFlag = 1;
%     else
%         % Upper branch (default)
%         BranchFlag = 2;
%     end
% else
%     if char(BranchFlag)
%         if strcmpi(BranchFlag, 'Lower')
%             % Lower branch
%             BranchFlag = 1;
%         elseif strcmpi(BranchFlag, 'Upper')
%             % Upper branch
%             BranchFlag = 2;
%         end
%     end
% end
% 
% 
% if isempty(Amps)
%     if strcmpi(ModeFlag,'simulator') | strcmpi(ModeFlag,'model')
%         % The model energy is used only if Amps is empty
%         GeV = getenergymodel;
%         return;
%     else 
%         Amps = getpv(Family, Field, [1 1], 'Hardware', ModeFlag);
%         UnitsFlag = 'UnitsFlag';
%     end
% end
% 
% if size(Amps,1) == 1 & size(DeviceList,1) > 1
%     Amps = ones(size(DeviceList,1),1) * Amps;
% end
% 
% % End of input checking
% % Machine dependent stuff below
% 
% 
% % Amps should be in hardware units
% if strcmpi(UnitsFlag,'Physics')
%     % This does not make sense for ALS since the K is fixed at all energies
%     error('Amps input can not be in physics units.');
%     Amps = physics2hw(Family, 'Setpoint', Amps, DeviceList);
% end
% 
% 
% % % If at the production or injection lattice, then just scale the energy
% % % Get the initial and final lattices
% % FileName = getfamilydata('OpsData', 'LatticeFile');
% % DirectoryName = getfamilydata('Directory', 'OpsData');
% % load([DirectoryName FileName]);
% % if strcmpi(Field, 'Monitor')
% %     SPProduction = ConfigMonitor;
% % else
% %     SPProduction = ConfigSetpoint;
% % end
% % 
% % FileName = getfamilydata('OpsData', 'InjectionFile');
% % DirectoryName = getfamilydata('Directory', 'OpsData');
% % load([DirectoryName FileName]);
% % if strcmpi(Field, 'Monitor')
% %     SPInjection = ConfigMonitor;
% % else
% %     SPInjection = ConfigSetpoint;
% % end
% 
% 
% % Get the proper table
% % The tables are normalized:  Setpoints = RampTable * (Upper-Lower) + Lower
% DirectoryName = getfamilydata('Directory', 'OpsData');
% if BranchFlag == 1
%     % Lower branch
%     load([DirectoryName 'alsrampup']);
% else
%     % Upper branch
%     load([DirectoryName 'alsrampdown']);
% end
% 
% 
% % Setpoints = RampTable * (Upper-Lower) + Lower
% UpperLattice = RampTable.UpperLattice.(Field).(Family).(Field).Data;
% LowerLattice = RampTable.LowerLattice.(Field).(Family).(Field).Data;
% iDevUpper = findrowindex(DeviceList, RampTable.UpperLattice.(Field).(Family).(Field).DeviceList);
% iDevLower = findrowindex(DeviceList, RampTable.LowerLattice.(Field).(Family).(Field).DeviceList);
% 
% % Convert to a absolute table
% MagnetTable = RampTable.(Family).(Field);
% MagnetTable = (UpperLattice(iDevUpper) - LowerLattice(iDevLower)) * MagnetTable;
% for j = 1:size(MagnetTable,1)
%     MagnetTable(j,:) = MagnetTable(j,:) + LowerLattice(iDevLower(j));
% end
% 
% iDevTotal      = findrowindex(DeviceList, family2dev(Family,0));
% iDevInjection  = findrowindex(DeviceList, RampTable.LowerLattice.(Field).(Family).(Field).DeviceList);
% iDevProduction = findrowindex(DeviceList, RampTable.UpperLattice.(Field).(Family).(Field).DeviceList);
%     
% 
% for i = 1:size(Amps,1)   %length(iDevTotal) 
%     for j = 1:size(Amps,2) 
%         
%         %% Cubic if outside the table (just because cubic extends outside the table)
%         %if min(MagnetTable(i,:)) > Amps(i,j) | max(MagnetTable(i,:)) < Amps(i,j)
%         %    GeV(i,j) = interp1(MagnetTable(i,:), RampTable.GeV, Amps(i,j), 'cubic');
%         %else
%         %    GeV(i,j) = interp1(MagnetTable(i,:), RampTable.GeV, Amps(i,j));
%         %end
%         
%         % Linear interpolation
%         GeV(i,j) = interp1(MagnetTable(i,:), RampTable.GeV, Amps(i,j));
%         if isnan(GeV(i,j))
%             % Linear interpolate by hand outside the table
%             [AmpTbl,iSort] = sort(MagnetTable(i,:));
%             GeVTbl = RampTable.GeV(iSort);
%             
%             if Amps(i,j) > AmpTbl(end)
%                 % Amps greater than table max
%                 m = (GeVTbl(end) - GeVTbl(end-3)) / (AmpTbl(end)-AmpTbl(end-3));
%                 GeV(i,j) = m * (Amps(i,j) - AmpTbl(end)) + GeVTbl(end);
%             else
%                 % Amps less than table min
%                 m = (GeVTbl(3) - GeVTbl(1)) / (AmpTbl(3)-AmpTbl(1));
%                 GeV(i,j) = m * (Amps(i,j) - AmpTbl(1)) + GeVTbl(1);                    
%             end
%         end
%     end
% end
% 
