function set4correctorbump(varargin)
%function set4correctorbump(IDnum,plane) - Set an orbit bump using 4 correctors in H or V
%  on the top of the present orbit
%
%  INPUTS
%  1. IDnum straight section number  1 is injection straigth
%  2. plane  1 for horizontal {default}
%            2 for vertical
%  3. pos bump size in mm Default : 0.5 mm
%  4. percent percent to apply 100% {default}
%  5. Bump type - 'Position' {default} or 'Angle'
%
%  NOTES
%  1. use orbit golden response matrix
%  2. Straight list
%     1 injection straight section
%  3. In model, should use fixed momentum Orbit response matrix

%  Maximum aplitude possible in straigth sections
%  Long = circa 3 mm (H) -
%  Medium = circa 2 mm (H) - 1.2 mm (V)
%  Short = circa 4 mm (H) -
%
%  See Also setbump4, setangle4

% 11 january 2006
%% Written by Laurent S. Nadolski

PositionFlag = 1;
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Position')
        PositionFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Angle')
        PositionFlag = 0;
        varargin(i) = [];
    end
end

if isempty(varargin)
    error('At least bump ID has to be specified')
else
    IDnum = varargin{1};
    if IDnum < 0 || IDnum > 24
        error('Bump does not exist')
    end
end

if length(varargin) < 2
    plane = 1; % Default plane
else
    plane = varargin{2};
end

if length(varargin) < 3
    pos = 0.5; % mm Default bump
else
    pos = varargin{3};
end

if length(varargin) < 4 % percentage of correction to apply
    percent = 1;
else
    percent = varargin{4};
    if percent > 1 || percent <0
        error('percentage has to be between 0 (0%)  or 1 (100%)')
    end
end

if PositionFlag == 1  % Position bump
    Z = [0 pos pos 0]';
else % Angle Bump
    Z = [0 pos -pos 0]';
end

switch plane
    case 1 % Horizontal
        ActuatorFamily = gethcmfamily;
        BPMFamily = gethbpmfamily;
        %% Insertion
        % ID straigth  Correctors   BPM
        tab = {
            01    [16  4]   [16  7]   [ 1  1]   [ 1  4]   [16  5]   [ 1  1]   [ 1  2]   [ 1  5]
            02    [ 1  4]   [ 1  7]   [ 2  1]   [ 2  4]   [ 1  4]   [ 2  1]   [ 2  2]   [ 2  5]
            03    [ 2  1]   [ 2  4]   [ 2  5]   [ 2  8]   [ 2  2]   [ 2  5]   [ 2  6]   [ 3  1]
            04    [ 2  5]   [ 2  8]   [ 3  1]   [ 3  4]   [ 2  7]   [ 3  1]   [ 3  2]   [ 3  5]
            05    [ 3  1]   [ 3  4]   [ 3  5]   [ 3  8]   [ 3  2]   [ 3  5]   [ 3  6]   [ 4  1]
            06    [ 3  5]   [ 3  8]   [ 4  1]   [ 4  4]   [ 3  6]   [ 4  1]   [ 4  2]   [ 4  6]
            07    [ 4  4]   [ 4  7]   [ 5  1]   [ 5  4]   [ 4  5]   [ 5  1]   [ 5  2]   [ 5  5]
            08    [ 5  4]   [ 5  7]   [ 6  1]   [ 6  4]   [ 5  4]   [ 6  1]   [ 6  2]   [ 6  5]
            09    [ 6  1]   [ 6  4]   [ 6  5]   [ 6  8]   [ 6  2]   [ 6  5]   [ 6  6]   [ 7  1]
            10    [ 6  5]   [ 6  8]   [ 7  1]   [ 7  4]   [ 6  7]   [ 7  1]   [ 7  2]   [ 7  5]
            11    [ 7  1]   [ 7  4]   [ 7  5]   [ 7  8]   [ 7  2]   [ 7  5]   [ 7  6]   [ 8  1]
            12    [ 7  5]   [ 7  8]   [ 8  1]   [ 8  4]   [ 7  6]   [ 8  1]   [ 8  2]   [ 8  6]
            13    [ 8  4]   [ 8  7]   [ 9  1]   [ 9  4]   [ 8  5]   [ 9  1]   [ 9  2]   [ 9  5]
            14    [ 9  4]   [ 9  7]   [10  1]   [10  4]   [ 9  4]   [10  1]   [10  2]   [10  5]
            15    [10  1]   [10  4]   [10  5]   [10  8]   [10  2]   [10  5]   [10  6]   [11  1]
            16    [10  5]   [10  8]   [11  1]   [11  4]   [10  6]   [11  1]   [11  2]   [11  5]
            17    [11  1]   [11  4]   [11  5]   [11  8]   [11  2]   [11  5]   [11  6]   [12  1]
            18    [11  5]   [11  8]   [12  1]   [12  4]   [11  6]   [12  1]   [12  2]   [12  6]
            19    [12  4]   [12  7]   [13  1]   [13  4]   [12  5]   [13  1]   [13  2]   [13  5]
            20    [13  4]   [13  7]   [14  1]   [14  4]   [13  4]   [14  1]   [14  2]   [14  5]
            21    [14  1]   [14  4]   [14  5]   [14  8]   [14  2]   [14  5]   [14  6]   [15  1]
            22    [14  5]   [14  8]   [15  1]   [15  4]   [14  6]   [15  1]   [15  2]   [15  5]
            23    [15  1]   [15  4]   [15  5]   [15  8]   [15  2]   [15  5]   [15  6]   [16  1]
            24    [15  5]   [15  8]   [16  1]   [16  4]   [15  6]   [16  1]   [16  2]   [16  6]
            };

    case 2 % Vertical
        ActuatorFamily = getvcmfamily;
        BPMFamily = getvbpmfamily;
        %% Insertion
        % ID straigth  Correctors   BPM
        tab = { ...
            01    [16  4]   [16  6]   [ 1  2]   [ 1  4]   [16  5]   [ 1  1]   [ 1  2]   [ 1  5]
            02    [ 1  4]   [ 1  6]   [ 2  2]   [ 2  3]   [ 1  4]   [ 2  1]   [ 2  2]   [ 2  5]
            03    [ 2  2]   [ 2  3]   [ 2  6]   [ 2  7]   [ 2  2]   [ 2  5]   [ 2  6]   [ 3  1]
            04    [ 2  6]   [ 2  7]   [ 3  2]   [ 3  3]   [ 2  7]   [ 3  1]   [ 3  2]   [ 3  5]
            05    [ 3  2]   [ 3  3]   [ 3  6]   [ 3  7]   [ 3  2]   [ 3  5]   [ 3  6]   [ 4  1]
            06    [ 3  6]   [ 3  7]   [ 4  2]   [ 4  4]   [ 3  6]   [ 4  1]   [ 4  2]   [ 4  6]
            07    [ 4  4]   [ 4  6]   [ 5  2]   [ 5  4]   [ 4  5]   [ 5  1]   [ 5  2]   [ 5  5]
            08    [ 5  4]   [ 5  6]   [ 6  2]   [ 6  3]   [ 5  4]   [ 6  1]   [ 6  2]   [ 6  5]
            09    [ 6  2]   [ 6  3]   [ 6  6]   [ 6  7]   [ 6  2]   [ 6  5]   [ 6  6]   [ 7  1]
            10    [ 6  6]   [ 6  7]   [ 7  2]   [ 7  3]   [ 6  7]   [ 7  1]   [ 7  2]   [ 7  5]
            11    [ 7  2]   [ 7  3]   [ 7  6]   [ 7  7]   [ 7  2]   [ 7  5]   [ 7  6]   [ 8  1]
            12    [ 7  6]   [ 7  7]   [ 8  2]   [ 8  4]   [ 7  6]   [ 8  1]   [ 8  2]   [ 8  6]
            13    [ 8  4]   [ 8  6]   [ 9  2]   [ 9  4]   [ 8  5]   [ 9  1]   [ 9  2]   [ 9  5]
            14    [ 9  4]   [ 9  6]   [10  2]   [10  3]   [ 9  4]   [10  1]   [10  2]   [10  5]
            15    [10  2]   [10  3]   [10  6]   [10  7]   [10  2]   [10  5]   [10  6]   [11  1]
            16    [10  6]   [10  7]   [11  2]   [11  3]   [10  6]   [11  1]   [11  2]   [11  5]
            17    [11  2]   [11  3]   [11  6]   [11  7]   [11  2]   [11  5]   [11  6]   [12  1]
            18    [11  6]   [11  7]   [12  2]   [12  4]   [11  6]   [12  1]   [12  2]   [12  6]
            19    [12  4]   [12  6]   [13  2]   [13  4]   [12  5]   [13  1]   [13  2]   [13  5]
            20    [13  4]   [13  6]   [14  2]   [14  3]   [13  4]   [14  1]   [14  2]   [14  5]
            21    [14  2]   [14  3]   [14  6]   [14  7]   [14  2]   [14  5]   [14  6]   [15  1]
            22    [14  6]   [14  7]   [15  2]   [15  3]   [14  6]   [15  1]   [15  2]   [15  5]
            23    [15  2]   [15  3]   [15  6]   [15  7]   [15  2]   [15  5]   [15  6]   [16  1]
            24    [15  6]   [15  7]   [16  2]   [16  4]   [15  6]   [16  1]   [16  2]   [16  6]
            };

    otherwise
        error('Unknown plane see help');
end

%%

ActuatorDeviceList = cell2mat(tab(IDnum,2:5)');
BPMDeviceList = cell2mat(tab(IDnum,6:9)');

% get Response matrix
R = getrespmat(BPMFamily,BPMDeviceList, ActuatorFamily, ActuatorDeviceList);

% Delta Setpoints to apply
DeltaSP = R\Z;

%% Check whether strength too large
% Get current Setpoints
SP = getam(ActuatorFamily,ActuatorDeviceList);
NewSP = SP + percent*DeltaSP;
MaxVal = getmaxsp(ActuatorFamily,ActuatorDeviceList);
index = [];
index = find(MaxVal < abs(NewSP));
if ~isempty(index)
    fprintf('name      actual   required     max\n')
    name = dev2common(ActuatorFamily,ActuatorDeviceList);
    for k = 1:4,
        fprintf('%s %f %f %f \n', name(k,:), SP(k), NewSP(k), MaxVal(k));
    end
    warning('max current too large: command not applied');
    return;
end
% end

%% Relative bump
stepsp(ActuatorFamily, DeltaSP*percent, ActuatorDeviceList);
