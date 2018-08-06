function [S, FileName] = getbpmresp(varargin)
%GETBPMRESP - Returns the BPM response matrix in the horizontal and vertical planes
%
%  For family name, device list inputs:
%  [Rmat, FileName] = getbpmresp(BPMxFamily, BPMxList, BPMyFamily, BPMyList, HCMFamily, HCMList, VCMFamily, VCMList, FileName)
%
%  For data structure inputs: 
%  [Rmat, FileName] = getbpmresp(BPMxStruct, BPMyStruct, HCMStruct, VCMStruct, FileName)
%
%  INPUTS
%  1. BPMxFamily     - BPMx family name {Default: gethbpmfamily}
%     BPMxDeviceList - BPMx device list {Default: all devices with good status}
%     or 
%     BPMxStruct can replace BPMxFamily and BPMxList
%
%  2. BPMyFamily     - BPMy family name {Default: getvbpmfamily}
%     BPMyDeviceList - BPMy device list {Default: all devices with good status}
%     or 
%     BPMyStruct can replace BPMyFamily and BPMyList
%
%  3. HCMFamily     - HCM family name {Default: gethcmfamily}
%     HCMDeviceList - HCM device list {Default: all devices with good status}
%     or 
%     HCMStruct can replace HCMFamily and HCMList
%
%  4. VCMFamily     - VCM family name {Default: getvcmfamily} 
%     VCMDeviceList - VCM device list {Default: all devices with good status}
%     or 
%     VCMStruct can replace VCMFamily and VCMList
%
%  5. FileName - File name for response matrix (or cell array of file names) {Default: use getfamilydata('OpsData','RespFiles')}
%                [] or '' - prompt the user to choose a response matrix file
%     To put the filename anywhere in the function call use the keyword, 'Filename' followed by the actual 
%     filename or '' to get a dialog box.  For example, m = getbpmresp('FileName','RmatABC') to search in RmatABC.mat.
%     
%  6. The response matrix will linearly scale to the present energy (getenergy) from the measured energy.
%     It's not always desirable to scale by the energy, so the following keywords can be used.
%     'EnergyScaling' - Scale the response matrix by energy (getenergy / measured energy) {Default}
%     'NoEnergyScaling' - Don't scale with energy
%  7. 'Struct'  will return the response matrix structure {Default if BPMxFamily is a structure input}
%     'Numeric' will return a numeric matrix {Default for non-data structure inputs}
%
%  OUTPUTS
%  1. Rmat = Orbit response matrix (delta(orbit)/delta(Kick))
%
%     Numeric Output:
%       Rmat = [x/x  x/y  
%               y/x  y/y] 
%
%     Ie, columns are correctors arranged horizontal to vertical
%         rows are BPMs arranged horizontal to vertical
%
%     Stucture Output:
%     Rmat(BPM Plane, Corrector Plane) - 2x2 struct array
%     Rmat(1,1).Data = x/x;   % Kick x, look x
%     Rmat(2,1).Data = y/x;   % Kick x, look y
%     Rmat(1,2).Data = x/y;   % Kick y, look x
%     Rmat(2,2).Data = y/y;   % Kick y, look y
%           
%     Rmat(Monitor, Actuator).Data - Response matrix
%                            .Monitor  - BPM data structure (starting orbit)
%                            .Monitor1 - BPM matrix (first  data point)
%                            .Monitor2 - BPM matrix (second data point)
%                            .Actuator - Corrector data structure
%                            .ActuatorDelta - Corrector kick vector
%                            .GeV - Electron beam energy
%                            .ModulationMethod - 'unipolar' or 'bipolar'
%                            .WaitFlag - Wait flag used when acquiring data
%                            .TimeStamp
%                            .CreatedBy
%                            .DCCT
%
%  2. FileName = File name where the data was found
%
%
%  NOTES
%  1. If the DeviceList is empty, [], or not present, all the device in that response matrix will be returned.
%  2. GeV will linearly scale the response matrix from the measured energy.  
%
%
%  EXAMPLES
%  1. Get the default corrector to BPM response matrix and plot
%     S = getbpmresp;
%          or
%     S = getbpmresp('BPMx', 'BPMy', 'HCM', 'VCM');
%     surf(S);
%
%  2. Get a HCM to BPM response matrix but return as a structure 
%     S = getbpmresp('BPMx', 'BPMy', 'HCM', 'VCM', 'Struct');
%
%  4. Structure inputs:
%     Xmon = getx([1 2;2 1; 3 3],'struct'); 
%     Ymon = gety([1 2;2 1; 3 3],'struct'); 
%     Xact = getsp('HCM', [1 2;2 1;2 2;4 1],'struct');
%     Yact = getsp('VCM', [1 2;2 1;2 2;4 1],'struct');
%     S = getbpmresp(Xmon, Ymon, Xact, Yact);
%     Returns the same matrix as in Example 1.
%
%  See also getrespmat, measbpmresp, measrespmat, gettuneresp, getchroresp

%  Written by Greg Portmann


% Initialize defaults
BPMxFamily = gethbpmfamily; 
BPMxList   = [];

BPMyFamily = getvbpmfamily;
BPMyList   = [];

HCMFamily = gethcmfamily;
HCMList   = [];
HCMKicks  = [];

VCMFamily = getvcmfamily;
VCMList   = [];
VCMKicks  = [];

FileName = '';
InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Struct')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Numeric')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Model') || strcmpi(varargin{i},'Simulator')
        fprintf('WARNING: Model input ignored.  Used measbpmresp to get the model response matrix.\n');
        varargin(i) = [];
    elseif strcmpi(varargin{i},'EnergyScaling')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoEnergyScaling')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Physics')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Hardware')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'FileName')
        if length(varargin) >= i+1 && ischar(varargin{i+1})
            FileName = varargin{i+1};
            varargin(i:i+1) = [];
        else
            varargin(i) = [];
        end
        if isempty(FileName)
            DirectoryName = getfamilydata('Directory', 'BPMResponse');
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a BPM response matrix file', DirectoryName);
            if FileName == 0
                S = [];
                FileName = [];
                return;
            end
            FileName = [DirectoryName FileName];
        end
    end
end


%%%%%%%%%%%%%%%%
% Parse Inputs %
%%%%%%%%%%%%%%%%

% Special case: empty in input 1, ask for a file
if length(varargin) == 1 && (isempty(varargin{1}) || strcmp(varargin{1},'.'))
    FileName = varargin{1};
    varargin(1) = [];

    if isempty(FileName)
        DirectoryName = getfamilydata('Directory', 'BPMResponse');
    elseif strcmp(FileName, '.')
        DirectoryName = '';
    end
    [FileName, DirectoryName] = uigetfile('*.mat', 'Select a BPM response matrix file', DirectoryName);
    if FileName == 0
        S = [];
        FileName = [];
        return;
    end
    FileName = [DirectoryName FileName];
end

% Look for BPMx family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        BPMxFamily = varargin{1}.FamilyName;
        BPMxList = varargin{1}.DeviceList;
        varargin(1) = [];
        if ~any(strcmpi(InputFlags,'Numeric'))
            % Only change to structure output if 'Numeric' is not on the input line
            InputFlags = [{'Struct'} InputFlags];
        end
    elseif ischar(varargin{1})
        BPMxFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                BPMxList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        BPMxList = varargin{1};
        varargin(1) = [];
    end
end
if isempty(BPMxList) && ~isempty(BPMxFamily)
    BPMxList = family2dev(BPMxFamily, 1);
end

% Look for BPMy family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        BPMyFamily = varargin{1}.FamilyName;
        BPMyList = varargin{1}.DeviceList;
        varargin(1) = [];
    elseif ischar(varargin{1})
        BPMyFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                BPMyList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        BPMyList = varargin{1};
        varargin(1) = [];
    end
end
if isempty(BPMyList) && ~isempty(BPMyFamily)
    BPMyList = family2dev(BPMyFamily, 1);
end

% Look for HCM family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        HCMFamily = varargin{1}.FamilyName;
        HCMList = varargin{1}.DeviceList;
        varargin(1) = [];
    elseif ischar(varargin{1})
        HCMFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                HCMList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        HCMList = varargin{1};
        varargin(1) = [];
    end
end
if isempty(HCMList) && ~isempty(HCMFamily)
    HCMList = family2dev(HCMFamily, 1);
end

% Look for VCM family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        VCMFamily = varargin{1}.FamilyName;
        VCMList = varargin{1}.DeviceList;
        varargin(1) = [];
    elseif ischar(varargin{1})
        VCMFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                VCMList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        VCMList = varargin{1};
        varargin(1) = [];
    end
end
if isempty(VCMList) && ~isempty(VCMFamily)
    VCMList = family2dev(VCMFamily, 1);
end


if length(varargin) >= 1
    if ischar(varargin{1}) 
        FileName = varargin{1};
        varargin(1) = [];
        if isempty(FileName)
            DirectoryName = getfamilydata('Directory', 'BPMResponse');
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a BPM response matrix file', DirectoryName);
            if FileName == 0
                S = [];
                FileName = [];
                return;
            end
            FileName = [DirectoryName FileName];
        end
    end
end


try
    if ~isempty(FileName)
        [S, FileName] = getrespmat({BPMxFamily, BPMyFamily}, {BPMxList, BPMyList}, {HCMFamily, VCMFamily}, {HCMList, VCMList}, FileName, InputFlags{:});
    else
        [S, FileName] = getrespmat({BPMxFamily, BPMyFamily}, {BPMxList, BPMyList}, {HCMFamily, VCMFamily}, {HCMList, VCMList}, InputFlags{:});
    end
catch
    fprintf('   Could not find a BPM response matrix file, so using the model (%s & %s).\n', HCMFamily, VCMFamily);
    S = measbpmresp('Model',{BPMxFamily, BPMyFamily}, {BPMxList, BPMyList}, {HCMFamily, VCMFamily}, {HCMList, VCMList}, InputFlags{:}, varargin{:});
    FileName = '';
end



