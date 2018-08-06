function Amps = gev2bend(varargin)
%GEV2BEND - Compute the energy based on the ramp tables
% Bend = gev2bend(Family, Field, GeV, DeviceList, BranchFlag)
%
%  INPUTS
%  1. Bend - Bend magnet family {Optional}
%  2. Field - Field {Optional}
%  3. GeV - Electron beam energy [GeV]
%  4. DeviceList - Bend magnet device list to reference energy to {Default: BEND(1,1)}
%  5. BranchFlag - 1 -> Lower branch
%                  2 -> Upper branch {Default}
%
%  OUTPUTS
%  1. Bend - Bend magnet current [Amps]
%
%  See also bend2gev, getenergy

%  Written by Greg Portmann


% Default
Family = '';
Field = '';
GeV = [];
DeviceList = [];
BranchFlag = [];
ModeFlag = '';  % model, online, manual
UnitsFlag = ''; % hardware, physics
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        UnitsFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
        ModeFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'online')
        ModeFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'manual')
        ModeFlag = varargin{i};
        varargin(i) = [];
    end        
end


if length(varargin) >= 1
    if ischar(varargin{1})
        Family = varargin{1};
        varargin(1) = [];
    else
        GeV = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            DeviceList = varargin{1};
            varargin(1) = [];
        end
        if length(varargin) >= 1
            BranchFlag = varargin{1};
            varargin(1:end) = [];
        end
    end
end
if length(varargin) >= 1 && ischar(varargin{1})
    Field = varargin{1};
    varargin(1) = [];
end
if length(varargin) >= 1
    GeV = varargin{1};
    varargin(1) = [];
end
if length(varargin) >= 1
    DeviceList = varargin{1};
    varargin(1) = [];
end
if length(varargin) >= 1
    BranchFlag = varargin{1};
    varargin(1) = [];
end


if isempty(Family)
    Family = 'BD';
end
if isempty(Field)
    Field = 'Setpoint';
end

if isempty(UnitsFlag)
    UnitsFlag = getunits(Family);
end

if isempty(GeV)
    if isempty(ModeFlag)
        ModeFlag = getmode(Family);
    end
    if strcmpi(ModeFlag,'simulator') || strcmpi(ModeFlag,'model')
        GeV = getenergymodel;
    elseif strcmpi(ModeFlag,'online')
        GeV = getenergy(ModeFlag);
    else
        error('GeV input required');
    end
end

if isempty(DeviceList)
    DeviceList = family2dev(Family);
    if all(size(GeV)==[1 1])
        DeviceList = DeviceList(1,:);
    end
end


% Hysteresis branch
if isempty(BranchFlag)
    if strcmpi(getfamilydata('HysteresisBranch'),'Lower')
        % Lower branch
        BranchFlag = 1;
    else
        % Upper branch (default)
        BranchFlag = 2;
    end
else
    if char(BranchFlag)
        if strcmpi(BranchFlag, 'Lower')
            % Lower branch
            BranchFlag = 1;
        elseif strcmpi(BranchFlag, 'Upper')
            % Upper branch
            BranchFlag = 2;
        end
    end
end

% End of input checking
% Machine dependant stuff below
A = [0 146.439 340.934 535.757 730.486 827.679 876.938 940.002 974.425 1071.468 1168.572 1200]; % Power supply (Amp) 952.752304
B = [0 -0.24875 -0.57342 -0.89743 -1.21531 -1.36635 -1.43647 -1.51468 -1.55212 -1.64438 -1.72412 -1.75627]; % Bending magnet (T-M) -1.537024493
if strcmpi(Family, 'BD')
    GeV = getenergy;
    Brho = getbrho(GeV);
    for i = 1:size(DeviceList,1)
        theta = pi/9;
        B0L = Brho * theta;
        Amps = interp1(B,A,-B0L);
        
    end
end



%fprintf('   gev2bend needs work!!!\n');
