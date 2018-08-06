function Amps = gev2bend(varargin)
%GEV2BEND
% Bend = gev2bend(Family, Field, GeV, DeviceList)
%
%  INPUTS
%  1. Bend - Bend magnet family {Optional}
%  2. Field - Field {Optional}
%  3. GeV - Electron beam energy [GeV]
%  4. DeviceList - Bend magnet device list to reference energy to {Default: BEND(1,1)}
%
%  OUTPUTS
%  1. Bend - Bend magnet current [Amps]
%
%  Written by Greg Portmann


Amps = 0.03272492347500


% % Default
% Family = '';
% Field = '';
% GeV = [];
% DeviceList = [];
% BranchFlag = [];
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
%         UnitsFlag = varargin{i};
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
%         GeV = varargin{1};
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
%     GeV = varargin{1};
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
% if isempty(Field)
%     Field = 'Setpoint';
% end
% 
% if isempty(UnitsFlag)
%     UnitsFlag = getunits(Family);
% end
% 
% if isempty(GeV)
%     if isempty(ModeFlag)
%         ModeFlag = getmode(Family);
%     end
%     if strcmpi(ModeFlag,'simulator') | strcmpi(ModeFlag,'model')
%         GeV = getenergymodel;
%     else
%         error('GeV input required');
%     end
% end
% 
% if isempty(DeviceList)
%     DeviceList = family2dev(Family);
%     if all(size(GeV)==[1 1])
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
% % End of input checking
% % Machine dependant stuff below
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
% for i = 1:size(GeV,1)   %length(iDevTotal) 
%     for j = 1:size(GeV,2) 
%         
%         %% Cubic if outside the table (just because cubic extends outside the table)
%         %if min(RampTable.GeV) > GeV(i,j) | max(RampTable.GeV) < GeV(i,j)
%         %    Amps(i,j) = interp1(RampTable.GeV, MagnetTable(i,:), GeV(i,j), 'cubic');
%         %else
%         %    Amps(i,j) = interp1(RampTable.GeV, MagnetTable(i,:), GeV(i,j));
%         %end
%         
%         
%         % Linear interpolation
%         Amps(i,j) = interp1(RampTable.GeV, MagnetTable(i,:), GeV(i,j));
%         
%         if isnan(Amps(i,j))
%             % Linear interpolate by hand outside the table
%             [AmpTbl,iSort] = sort(MagnetTable(i,:));
%             GeVTbl = RampTable.GeV(iSort);
%             
%             if GeV(i,j) > GeVTbl(end)
%                 % Energy greater than table max
%                 m = (AmpTbl(end)-AmpTbl(end-3)) / (GeVTbl(end) - GeVTbl(end-3));
%                 Amps(i,j) = m * (GeV(i,j) - GeVTbl(end)) + AmpTbl(end);
%             else
%                 % Energy less than table min
%                 m = (AmpTbl(3)-AmpTbl(1)) / (GeVTbl(3) - GeVTbl(1));
%                 Amps(i,j) = m * (GeV(i,j) - GeVTbl(1)) + AmpTbl(1);                    
%             end
%         end
%                 
%         if strcmpi(UnitsFlag,'Physics')
%             Amps(i,j) = hw2physics(Family, 'Setpoint', Amps(i,j), DeviceList, GeV(i,j));
%         end
%     end
% end
% 
