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
    if all(size(GeV)==[1 1])
        DeviceList = DeviceList(1,:);
    end
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

    % Convert to BEND current
    temp = getfamilydata(Family, Field, 'HW2PhysicsParams', DeviceList(ii,:));
    C = temp{1};
    
    % The function/curve used here is Energy vs Current and is calculated
    % from tracking studies using a 2D field map.
    splitind = size(C,2)/2;
    I = C(1,1:splitind);
    Energy = C(1,splitind+1:end); % in GeV
    BEND = interp1(Energy,I,gev1,'linear','extrap');

    if size(GeV,2) == 1
        Amps(ii,1) = BEND;
    else
        Amps(1,ii) = BEND;
    end
end


if strcmpi(UnitsFlag,'Physics')
    Amps = hw2physics(Family, 'Setpoint', Amps, DeviceList, GeV);
end




%     % k is fixed to be -0.31537858
%     k = 0.31537858;
%     
%     % Convert to BEND angle
%     if any(DeviceList(ii) == [1 9 10 18])
%         K2BendingAngle = 2.54842790129284 * -0.43947079695140;   % BendAngle / K
%     else
%         K2BendingAngle = 2.54842790129284 * -0.58596106939159;  % BendAngle / K
%     end
%     k = K2BendingAngle * k;
% 
%     bprime = k * brho;
%     b0 = bprime * 0.392348;
%     bl = b0;
%     k = -k;
%     
%     
%     % Solve for roots based on polynomial coefficient (coefficients already divided by Leff)
%     % p = [C(1) C(2) C(3) C(4) C(5) C(6) C(7) C(8) C(9)-bl]; 
%     % C(9) = 0
%     
%     p = C;
%     p(9) = bl;
%     %p = [c7 c6 c5 c4 c3 c2 c1  c0 -bl];
%     
%     
%     if 0
%         % Real and between 200-800 amps approach
%         r = roots(p);
%         
%         pp = poly(r);
%         
%         for i = 1:8
%             if (imag(r(i))==0. & real(r(i))<800. & real(r(i))>200.);
%                 BEND = r(i);
%             end
%         end
%         
%         
%     else
%         % Closest to the linear line approach 
%         
%         r1inear = -bl / C(end-1);
%         
%         r = roots(p);    
%         
%         % Choose the closest solution to the linear one
%         BEND = inf;
%         for i = 1:length(r)
%             if isreal(r(i))
%                 %if r(i)>0 & abs(r(i)) < BEND(j,1)  % Smallest, positive 
%                 if abs(r(i) - r1inear) < abs(BEND - r1inear)  % Closest to linear solution
%                     BEND = r(i);
%                 end
%             end
%         end
%         
%         if isinf(BEND)
%             error(sprintf('Solution for GeV=%.3f not found (all roots are complex)', gev1));
%         end
%     end