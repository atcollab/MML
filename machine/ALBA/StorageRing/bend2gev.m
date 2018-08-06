function [GeV B] = bend2gev(varargin)
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
%  2. B - B-field [T]
%
%  ALGORYTHM
%  theta = BL/Brho
%
%  See Also bend2gev


%
%  Written by Gregory J. Portmann
%  Modify by Laurent S. Nadolski

% TODO Need BLeff = function of the dipole current

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
    elseif strcmpi(varargin{i},'Struct')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Numeric')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Physics')
        UnitsFlag = 'Physics';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Hardware')
        UnitsFlag = 'Hardware';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Simulator') || strcmpi(varargin{i},'Model')
        ModeFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        ModeFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Manual')
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
    if all(size(Amps)==[1 1]) | isempty(Amps)
        DeviceList = DeviceList(1,:);
    end
end
if isempty(BranchFlag)
    % Default is upper branch
    BranchFlag = 2;
end
if isempty(Amps)
    if strcmpi(ModeFlag,'simulator') || strcmpi(ModeFlag,'model')
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


DeviceListTotal = family2dev(Family, 0);

for ii = 1:size(DeviceList,1)
    if length(Amps) == 1
        BEND = Amps;    
    else
        BEND = Amps(ii);    
    end

    %% Approximation too wrong for low energy like in transfert lines
    % brho[Tm] = 3.33620907461447 * E[GeV]
    % brho = BLeff/theta = 1E9/c*sqrt(E*E-E0*E0)
    %

    E0 = .51099906e-3;  %electron rest mass in GeV
    e    = 1.60217733e-19 ;
    %% celerity times 1 billion
    cb    = 2.99792458e-1;

    AcceleratorName = getfamilydata('SubMachine');
    switch AcceleratorName
        case 'StorageRing'
            % Convert to energy
            %
            %
            %
            % Need BLeff = function of the dipole current

            % C coefficients have been scaled to convert between AT units and hardware units and also includes a DC term:
            % c8 * I^8+ c7 * I^7+ c6 * I^6 + c5 * I^5 + c4 * I^4 + c3 * I^3 + c2 * I^2+c1*I + c0 = B or B' or B"
            % C = [c8 c7 c6 c5 c4 c3 c2 c1 c0]
            %[C1, Leff, MagnetType, A] = magnetcoefficients('BEND');

            [C Leff Type A] = magnetcoefficients(Family);
            
            % Magnetfield in T
            BL = polyval(A,BEND);
            % k(i,1) = polyval(C, Amps(i)) / brho;

            theta = 0.19634954084936; % rad <--> 11.25 degrees
            % la question se pose sur l'utilite de BLeff
            %BLeff = 1.806;
            %BLeff = 1.8014;
            %brho  = BLeff/theta;
            %% TODO get BLeff in function of the dipole current
            brho  = BL/theta;
            
        case 'LT2'

            [C Leff Type A] = magnetcoefficients(Family);
            
            % Magnetfield in T
            BL = polyval(A,BEND);
            % k(i,1) = polyval(C, Amps(i)) / brho;

            theta = 0.193789; % rad <--> 11.25 degrees
            BLeff = 1.7780;
            %brho  = BLeff/theta;
            %% TODO get BLeff in function of the dipole current
            brho  = BL/theta;    
            
            
            
        case 'LT1'
            [C Leff Type A] = magnetcoefficients(Family);

            % Magnetfield in T
            BL = polyval(A,BEND);
            theta = 0.26179938779915; %rad <--> 15 degrees
            brho = BL/theta;
        case 'Booster'
            [C Leff Type A] = magnetcoefficients(Family);

            % Magnetfield in T
            BL = polyval(A,BEND);
            theta = 0.17453292519943; %rad <--> 10 degrees
            brho = BL/theta;            
        otherwise
            error('Wrong SubMachine %s', Machine);
    end
    
    % now return energy in GeV
    gev1 = sqrt(E0*E0+cb*cb*brho*brho) - E0;
    
    if size(Amps,2) == 1
        GeV(ii,1) = gev1;
    else
        GeV(1,ii) = gev1;
    end

end
