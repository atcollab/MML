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
%                  Not working at Spear yet
%
%  OUTPUTS
%  1. Bend - Bend magnet current [Amps]
%
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
if length(varargin) >= 1 & ischar(varargin{1})
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
    Family = 'BEND';
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
    if strcmpi(ModeFlag,'simulator') | strcmpi(ModeFlag,'model')
        GeV = getenergymodel;
    else
        error('GeV input required');
    end
end

if isempty(DeviceList)
    DeviceList = family2dev(Family);
%     if all(size(GeV)==[1 1])
%         DeviceList = DeviceList(1,:);
%     end
end
if isempty(BranchFlag)
    % Default is upper branch
    BranchFlag = 2;
end

% End of input checking
% Machine dependant stuff below
for ii = 1:size(DeviceList,1)
    if length(GeV) == 1
        gev1 = GeV;
    else
        gev1 = GeV(ii);
    end
    % Convert to BEND angle
    %K2BendingAngle = 2.54842790129284; 
    if strcmpi(strtrim(dev2common(Family,DeviceList(ii,:))),'BF')
        % BF
        B = gev1/6.762536446;
    else
        % BD1 or BD2
        B = gev1/2.394347753;
    end

    temp = getfamilydata(Family, Field, 'HW2PhysicsParams',DeviceList(ii,:));
    muC = temp{1};
    scaling = temp{2};
    mu = muC(1:2);
    C = muC(3:end);
    % Vertical shift polynomial so desired B is crosses the x-axis and use
    % "roots" to find the solution.
    C(end) = C(end) - B;
    
    r = roots(C);

    % First order approxmiation of where the shifted polynomial crosses the
    % x-axis is the linear approxmiation.
    r1inear = -C(end)/C(end-1);
    
    BEND = inf;
    for i = 1:length(r)
        if isreal(r(i))
            %if r(i)>0 & abs(r(i)) < BEND(j,1)  % Smallest, positive
            if abs(r(i) - r1inear) < abs(BEND - r1inear)  % Closest to linear solution
                BEND = r(i);
            end
        end
    end
    
    if isinf(BEND)
        error(sprintf('Solution for GeV=%.3f not found (all roots are complex)', gev1));
    else
        % Convert into Amps
        BEND = BEND*mu(2) + mu(1);
    end
    
    % Set some conversion factors due to power supplies.
    if strcmpi(strtrim(dev2common(Family,DeviceList(ii,:))),'BF')
        % BF
        if size(GeV,2) == 1
            Amps(ii,1) = scaling*BEND;
        else
            Amps(1,ii) = scaling*BEND;
        end
    else
        % BD1 or BD2
        if size(GeV,2) == 1
            Amps(ii,1) = scaling*BEND;
        else
            Amps(1,ii) = scaling*BEND;
        end
    end
    

end

if strcmpi(UnitsFlag,'Physics')
    Amps = hw2physics(Family, 'Setpoint', Amps, DeviceList, GeV);
end

