function GeV = bend2gev(varargin)
%BEND2GEV - Compute the energy based on the ramp tables
% GeV = bend2gev(Family, Field, Amps, DeviceList, BranchFlag)
%
%  INPUTS
%  1. Bend - Bend magnet family {Optional}
%  2. Field - Field {Optional}
%  3. Amps - Bend magnet current
%  4. DeviceList - Bend magnet device list to reference energy to {Default: BEND(1,1)}
%  5. BranchFlag - 1 -> Lower branch
%                  2 -> Upper branch {Default}
%                  Not working at Spear yet, since there isn't any magnet measurements on hysteresis
%
%  OUTPUTS
%  1. GeV - Electron beam energy [GeV]
%
%  Written by Greg Portmann

% Default
Family = '';
Field = '';
Amps = [];
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
        UnitsFlag = 'Physics';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = 'Hardware';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') | strcmpi(varargin{i},'model')
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
        Amps = varargin{1};
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
if length(varargin) >= 1 & ischar(varargin{1})
    Field = varargin{1};
    varargin(1) = [];
end
if length(varargin) >= 1
    Amps = varargin{1};
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
    Family = 'BEND';
end
if isempty(ModeFlag)
    ModeFlag = getmode(Family);
end

if isempty(Field)
    Field = 'Setpoint';
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
%     if all(size(Amps)==[1 1]) | isempty(Amps)
%         DeviceList = DeviceList(1,:);
%     end
end
if isempty(BranchFlag)
    % Default is upper branch
    BranchFlag = 2;
end
if isempty(Amps)
    if strcmpi(ModeFlag,'simulator') | strcmpi(ModeFlag,'model')
        % The model energy is used only if Amps is empty
        % Otherwise "Maximum recursion limit"
        GeV = getenergymodel;
        return;
        
        %GeVmodel = getenergymodel;
        %kmodel = getpvmodel(Family, Field, DeviceList, 'Physics');
        %Amps = k2amp(Family, Field, kmodel, DeviceList, [], 1, GeVmodel);
    else 
        Amps = getpv(Family, Field, [1 1], 'Hardware', ModeFlag);
        UnitsFlag = 'UnitsFlag';
    end
end

% End of input checking
% Machine dependent stuff below


% Amps should be in hardware units
if strcmpi(UnitsFlag,'Physics')
    Amps = physics2hw(Family, 'Setpoint', Amps, DeviceList);
end

for ii = 1:size(DeviceList,1)
    if length(Amps) == 1
        BEND = Amps;    
    else
        BEND = Amps(ii);    
    end

    temp = getfamilydata(Family, Field, 'HW2PhysicsParams',DeviceList(ii,:));
    muC = temp{1};
    scaling = temp{2};
    mu = muC(1:2);
    C = muC(3:end);
    
    % Convert to BEND angle
    % The scaling factor before the BEND is to compensate for the ratio
    % between setpoint and readback from the power supplies.
    if strcmpi(strtrim(dev2common(Family,DeviceList(ii,:))),'BF')
        % BF
        gev1 = 6.762536446*polyval(C,scaling*BEND,[],mu);
    else
        % BD1 or BD2
        gev1 = 2.394347753*polyval(C,scaling*BEND,[],mu);
    end
    
    if size(Amps,2) == 1
        GeV(ii,1) = gev1;
    else
        GeV(1,ii) = gev1;
    end
end



