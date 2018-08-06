function Amps = at2umer(Family, Field, k, DeviceList, Energy)
%AT2MLS - Converts simulator values to amperes
%  Amps = at2mls(Family, Field, K, DeviceList, Energy)
%
%  INPUTS
%  1. Family - Family name
%  2. Field - Sub-field (like 'Setpoint')
%  3. K - "K-value" (AT convention)
%          For dipole:      K = B / Brho
%          For quadrupole:  K = B'/ Brho
%          For sextupole:   K = B"/ Brho / 2
%  4. DeviceList - Device list (Amps and DeviceList must have the same number of rows)
%  5. Energy - Energy in GeV {Default: getenergy}
%              If Energy is a vector, each output column will correspond to that energy.
%              Energy can be anything getenergy accepts, like 'Model' or 'Online'.
%              (Note: If Energy is a vector, then Amps can only have 1 column)
%
%  OUTPUTS
%  1. Amps - Ampere (or real hardware units)
%
%  See also mls2at, hw2physics, physics2hw


if nargin < 3
    error('At least 3 input required');
end

if isempty(Field)
    Field = 'Setpoint';
end

if nargin < 4
    DeviceList = [];
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end

if nargin < 5
    Energy = [];
end
if isempty(Energy)
    Energy = getenergy;
elseif ischar(Energy)
    Energy = getenergy(Energy);
end


if size(k,1) == 1 && length(DeviceList) > 1
    k = ones(size(DeviceList,1),1) * k;
elseif size(k,1) ~= size(DeviceList,1)
    error('Rows in k must equal rows in DeviceList or be a scalar');
end


if all(isnan(k))
    Amps = k;
    return
end


% Force Energy and Amps to have the same number of columns
if all(size(Energy) > 1)
    error('Energy can only be a scalar or vector');
end
Energy = Energy(:)';

if length(Energy) > 1
    if size(k,2) == size(Energy,2)
        % OK
    elseif size(k,2) > 1
        error('If Energy is a vector, then k can only have 1 column.');
    else
        % k has one column, expand to the size of Energy
        k = k * ones(1,size(Energy,2));
    end
else
    Energy = Energy * ones(1,size(k,2));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setpoint and Monitor Fields %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmpi(Field, {'Setpoint','Monitor'}))
    if strcmpi(Family, 'HCM') || strcmpi(Family,'VCM')
        Amps = rsvangle2current(Family, Field, k, DeviceList, Energy);
        return;
    elseif strcmpi(Family, 'BEND')
        Amps = dipoleangle2current(Family, Field, k, DeviceList, Energy);
        return;
    elseif strcmpi(Family, 'QF') || strcmpi(Family, 'QD')
        Amps = quadstrength2current(Family, Field, k, DeviceList, Energy);
        return;        
    end    
end

% If you made it to here, I don't know how to convert it
Amps = k;
return

end


%% Functions to convert magnets
function currents = dipoleangle2current(Family, Field, value, DeviceList, Energy)
% Converts from a dipole current setting to a dipole bend angle
%
%  FamilyName/DeviceList Method
%  [angleR,angleD] = current2quadstrength(Family, Field, value, DeviceList, Energy)
%
%  Magnet Name Method
%  [angleR,angleD] = current2quadstrength(Magnet_Name,value)
%
%
%  INPUTS
%  1. Family - Family Name
%              Data Structure
%              Channel Name or matrix of Channel Names
%              Accelerator Object (only the family name is used)
%              For CommonNames, Family=[] searches all families
%              (or Cell Array of inputs)
%
%  2. Field - Subfield name of an accelerator family ('Monitor', 'Setpoint', etc)
%             {Default: 'Monitor' or '' or ChannelName method}
%             (For non-Family subfields, Field is added as .Field, see Note #8 below for more information.)
%
%  3. value - current in A
%
%
%  4. DeviceList - [Sector Device #] or [element #] list {Default or empty list: Entire family}
%                  Note: if input 1 is a cell array then DeviceList must be a cell array
%     CommonName - Common name can replace a DeviceList (scalar or vector outputs)
%
%  5. Energy - Beam energy (optional argument)
%
% Output:
%   angleR - dipole bend angle in radians (B / Brho )
%

% Notes
% first term in multipole expansion:
% By*Current/Brig = 5.216*2.9694/338.859 = .0457
ad = getad;

dipole = family2common(Family,DeviceList);

N = size(DeviceList,1);
currents=zeros(N,1);

%% load earth field data
e_data = csvread([ad.Directory.EarthFieldData,'earth_field_data_2016.csv'],1,1); % skip row/col 1


for i = 1:N
    use_PD = strcmpi(dipole(i),'PD-Rec');
    idx = str2num(dipole{i}(2:end))+1; % grab dipole number to match index number in e_data array
    %% calculate
    l_eff = 3.819; % cm , calculated along s-axis
    peak_field = 5.216; % peak G/mA from magLi + Earth field
    if use_PD
        l_eff = 5.006;
        peak_field = 0.382;
        idx = 1;
    end
    Byl = l_eff*peak_field; % G-cm/mA g
    Byl_earth = abs(e_data(idx,4))*1e-3*32; % field in G x l_eff in cm
    
    e         = 1.60217733E-19; %C
    m         = 9.1093897E-31; %kg
    Energy    = 9967.08077; % eV
    c         = 2.997924E8; % m/s
    
    gamma     = 1+((Energy)/(511000));
    beta      = sqrt((gamma*gamma)-1)/gamma;
    bg           = beta*gamma;
    Bridg         = bg*c*(m/e)*1e6; % in G-cm
    
    
    % with earth field added
    currents(i) = value(i)*Bridg/Byl - Byl_earth/Byl; % bend + earth_bend
    % without earth field
    %angleR(i) = (Byl*value(i))/Bridg;% bend
end


end

function currents = quadstrength2current(Family, Field, value, DeviceList, Energy)
% Converts from a quad current setting to a quad strength value.
%
%  FamilyName/DeviceList Method
%  amps = current2quadstrength(Family, Field, value, DeviceList, Energy)
%
%
%  INPUTS
%  1. Family - Family Name
%              Data Structure
%              Channel Name or matrix of Channel Names
%              Accelerator Object (only the family name is used)
%              For CommonNames, Family=[] searches all families
%              (or Cell Array of inputs)
%
%  2. Field - Subfield name of an accelerator family ('Monitor', 'Setpoint', etc)
%             {Default: 'Monitor' or '' or ChannelName method}
%             (For non-Family subfields, Field is added as .Field, see Note #8 below for more information.)
%
%  3. value - current in A
%
%
%  4. DeviceList - [Sector Device #] or [element #] list {Default or empty list: Entire family}
%                  Note: if input 1 is a cell array then DeviceList must be a cell array
%     CommonName - Common name can replace a DeviceList (scalar or vector outputs)
%
%  5. Energy - Beam energy (optional argument)
%
% OUTPUTS
%  1. Amps - current in Amps
%

magnet = family2common(Family,DeviceList);

N = size(DeviceList,1);
currents=zeros(N,1);

for i=1:N
    % YQ and QR1 are special large Quads at injection
    if strcmpi('YQ',magnet(i))
        peak_grad = 1.110e-2;
        sbfact = 0.8965;
    elseif strcmpi('QR1',magnet(i))
        peak_grad = 1.010e-2;
        sbfact = 0.8965;
    else
        peak_grad = 3.609e-2;
        sbfact = 0.8354; % hard edge model factor        
    end
    
    
    e         = 1.60217733E-19; %C
    m         = 9.1093897E-31; %kg
    Energy    = 9967.08077; % eV
    c         = 2.997924E8; % m/s
    
    gamma     = 1+((Energy)/(511000));
    beta      = sqrt((gamma*gamma)-1)/gamma;
    
    bg           = beta*gamma;
    ridg         = bg*c*(m/e);
    
    
    currents(i) = value(i)*ridg/sbfact/peak_grad;
end

end

function [currents] = rsvangle2current(Family, Field, value, DeviceList, Energy)
% Converts a current to an angle for the vertical corrector magnets
%
%  FamilyName/DeviceList Method
%  [angleR,angleD] = current2rsvangle(Family, Field, value, DeviceList, Energy)
%
%  Magnet Name Method
%  [angleR,angleD] = current2rsvangle(Magnet_Name,value)
%
%
%  INPUTS
%  1. Family - Magnet Name
%              Family Name 
%              Data Structure
%              Channel Name or matrix of Channel Names
%              Accelerator Object (only the family name is used)
%              For CommonNames, Family=[] searches all families
%              (or Cell Array of inputs)
%
%  2. Field - current value in mA
%             Subfield name of an accelerator family ('Monitor', 'Setpoint', etc)  
%             {Default: 'Monitor' or '' or ChannelName method}
%             (For non-Family subfields, Field is added as .Field, see Note #8 below for more information.)
%
%  3. value - current value in mA
%
%
%  4. DeviceList - [Sector Device #] or [element #] list {Default or empty list: Entire family}
%                  Note: if input 1 is a cell array then DeviceList must be a cell array
%     CommonName - Common name can replace a DeviceList (scalar or vector outputs)
%
%  5. Energy - Beam energy (optional argument)
%
% OUTPUTS
%  1. angleR - dipole bend angle in radians
%


%% calculate
l_eff_rsv = 5.670; % 4-1/2 flange
l_eff_ssv = 3.063; % short flange

peak_field_rsv = 0.685; % peak G/mA from magLi
peak_field_ssv = 1.18;

Byl_r = l_eff_rsv*peak_field_rsv; % G-cm/mA g
Byl_s = l_eff_ssv*peak_field_ssv;

e         = 1.60217733E-19; %C
m         = 9.1093897E-31; %kg
Energy    = 9967.08077; % eV 
c         = 2.997924E8; % m/s

gamma     = 1+((Energy)/(511000)); 
beta      = sqrt((gamma*gamma)-1)/gamma;
bg           = beta*gamma;
Bridg         = bg*c*(m/e)*1e6; % in G-cm

N = size(DeviceList,1);
currents = zeros(N,1);

magnets = family2common(Family,DeviceList);

for i=1:N
    if strcmpi(Family,'VCM')
        if strcmpi(magnets(i),'RSV') % regular correctors
            currents(i) = value(i)*Bridg/Byl_r; % bend
        elseif strcmpi(magnets(i),'SSV') % short correctors
            currents(i) = value(i)*Bridg/Byl_s; % bend
        end
    elseif strcmpi(Family,'HCM')
        if strcmpi(magnets(i),'SDR6H')
            currents(i) = value(i)*Bridg/Byl_s; % bend
        else % must be dipoles
            currents(i) = dipoleangle2current(Family, Field, value(i), DeviceList(i,1:end), Energy);
        end
    end
end


end



