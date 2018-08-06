function [S, FileName] = getphotresp(varargin)
%GETBPMRESP - Returns the Photon BPM response matrix in the vertical plane
%
%  For family name, device list inputs:
%  S = getphotresp(BPMxFamily, BPMxList, BPMyFamily, BPMyList,  ErrFamily, ErrList,  SumFamily, SumList,  NormFamily, NormList,  VCMFamily, VCMList, FileName)
%
%  For data structure inputs: 
%  S = getphotresp(BPMxStruct, BPMyStruct, ErrStruct, SumStruct, NormStruct, VCMStruct, FileName)
%
%  INPUTS
%  1. BPMxFamily       - BPMx family name {Default: 'BPMx'} 
%     BPMxDeviceList   - BPMx device list {Default: all devices with good status}
%     or 
%     BPMxStruct can replace BPMxFamily and BPMxList
%
%  2. BPMyFamily       - BPMy family name {Default: 'BPMy'} 
%     BPMyDeviceList   - BPMy device list {Default: all devices with good status}
%     or 
%     BPMyStruct can replace BPMyFamily and BPMyList
%
%  3. SumFamily       - Sum family name {Default: 'Sum'} 
%     SumDeviceList   - Sum device list {Default: all devices with good status}
%     or 
%     SumStruct can replace SumFamily and SumList
%
%  4. ErrFamily       - Err family name {Default: 'Err'} 
%     ErrDeviceList   - Err device list {Default: all devices with good status}
%     or 
%     ErrStruct can replace ErrFamily and ErrList
%
%  5. VCMFamily       - VCM family name {Default: 'VCM'} 
%     VCMDeviceList   - VCM device list {Default: all devices with good status}
%     or 
%     VCMStruct can replace VCMFamily and VCMList
%
%  6. FileName - File name for response matrix (or cell array of file names) {default: use AD.OpsData.RespFiles}
%                [] or '' - prompt the user to choose a response matrix file
%     To put the filename anywhere in the function call use the keyword, 'Filename' followed by the actual 
%     filename or [] to get a dialog box.  For example, m = getbpmresp('FileName',[]); to search for a response matrix file.
%  7. GeV is the energy that the response matrix will be used at {default or []: getenergy}.
%  8. 'Struct'  will return the response matrix structure {default for data structure inputs}
%     'Numeric' will return a numeric matrix {default for non-data structure inputs}
%
%  OUTPUTS
%  1. Rmat = Orbit response matrix (delta(Electron BPM, Photon BPM)/delta(Kick))
%
%     Numeric Output:
%       Rmat = [xy
%               yy 
%               sy 
%               ey]
%
%     Stucture Output:
%     Rmat(BPM Plane, Corrector Plane) - 2x2 struct array
%     Rmat(1,1).Data=xy;  % Kick y, look BPMx
%     Rmat(2,1).Data=yy;  % Kick y, look BPMy
%     Rmat(3,1).Data=sy;  % Kick y, look Sum
%     Rmat(4,1).Data=ey;  % Kick y, look Err
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
%                            .ExtraDelay - Extra time delay 
%                            .TimeStamp
%                            .CreatedBy
%                            .DCCT
%
%  2. FileName = File name (including directory) where the data was saved (if applicable)
%                (a machine configuration structure is saved in the data file as well)
%
%
%  NOTES
%  1. If the DeviceList is empty, [], or not present, all the device in that response matrix will be returned
%  2. GeV will linearly scale the response matrix from the measured energy {default: getenergy}
%  3. 
%
%  EXAMPLES
%  1. Get the default corrector to BPM,Photon response matrix and plot
%     S = getbpmresp;
%          or
%     S = getbpmresp('BPMx', 'BPMy', 'BLSum', 'BLErr', 'VCM');
%     mesh(S);
%
%  2. Get a HCM to BPM response matrix but return as a structure 
%     S = getbpmresp('BPMx', 'BPMy', 'BLSum', 'BLErr', 'VCM', 'Struct');
%
%  4. Structure inputs:
%     Xmon = getx([1 1;1 2; 1 3],'struct'); 
%     Ymon = gety([1 1;1 2; 1 3],'struct'); 
%     Smon = getam('BLSum',[1 1;1 2; 1 3],'struct'); 
%     Emon = getam('BLErr',[1 1;1 2; 1 3],'struct'); 
%     Yact = getsp('VCM', [1 1;2 1;2 2;4 1],'struct');
%     S = getbpmresp(Xmon, Ymon, Xact, Yact);
%     Returns the same matrix as in Example 1.
%
%  Also see getrespmat, measbpmresp, measrespmat
%
%  Adapted from Greg Portmann's 'getbpmresp' by Jeff Corbett


% Initialize defaults
% Initialize defaults
BPMxFamily = 'BPMx';
BPMxList = [];
BPMyFamily = 'BPMy';
BPMyList = [];
SumFamily  = 'BLSum';
SumList  = [];
ErrFamily  = 'BLErr';
ErrList  = [];
VCMFamily= 'VCM';
VCMList  = [];

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
    elseif strcmpi(varargin{i},'FileName')
        FileName = varargin{i+1};
        varargin(i:i+1) = [];
        if isempty(FileName)
            DirectoryName = getfamilydata('Directory', 'BLResponse');
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file to load', DirectoryName);
            FileName = [DirectoryName FileName];
        end

    elseif strcmpi(varargin{i},'Model')
        fprintf('WARNING: ''Model'' input ignored.  Used measphotresp to get the model response matrix.');
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Physics')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Hardware')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    end
end

%%%%%%%%%%%%%%%%
% Parse Inputs %
%%%%%%%%%%%%%%%%

% Look for BPMx family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        BPMxFamily = varargin{1}.FamilyName;
        BPMxList = varargin{1}.DeviceList;
        varargin(1) = [];
        if ~NumericOutputFlag
            StructOutputFlag = 1; % Only change StructOutputFlag if 'Numeric' is not on the input line
        end
    elseif isstr(varargin{1})
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
if isempty(BPMxList)
    BPMxList = getlist(BPMxFamily, 1);
end

% Look for BPMy family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        BPMyFamily = varargin{1}.FamilyName;
        BPMyList = varargin{1}.DeviceList;
        varargin(1) = [];
        if ~NumericOutputFlag
            StructOutputFlag = 1; % Only change StructOutputFlag if 'Numeric' is not on the input line
        end
    elseif isstr(varargin{1})
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
if isempty(BPMyList)
    BPMyList = getlist(BPMyFamily, 1);
end


% Look for Sum family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        SumFamily = varargin{1}.FamilyName;
        SumList = varargin{1}.DeviceList;
        varargin(1) = [];
        if ~NumericOutputFlag
            StructOutputFlag = 1; % Only change StructOutputFlag if 'Numeric' is not on the input line
        end
    elseif isstr(varargin{1})
        SumFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                SumList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        SumList = varargin{1};
        varargin(1) = [];
    end
end
if isempty(SumList)
    SumList = getlist(SumFamily, 1);
end


% Look for Err family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        ErrFamily = varargin{1}.FamilyName;
        ErrList = varargin{1}.DeviceList;
        varargin(1) = [];
        if ~NumericOutputFlag
            StructOutputFlag = 1; % Only change StructOutputFlag if 'Numeric' is not on the input line
        end
    elseif isstr(varargin{1})
        ErrFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                ErrList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        ErrList = varargin{1};
        varargin(1) = [];
    end
end
if isempty(ErrList)
    ErrList = getlist(ErrFamily, 1);
end


% Look for VCM family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        VCMFamily = varargin{1}.FamilyName;
        VCMList = varargin{1}.DeviceList;
        varargin(1) = [];
        if ~NumericOutputFlag
            StructOutputFlag = 1; % Only change StructOutputFlag if 'Numeric' is not on the input line
        end
    elseif isstr(varargin{1})
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
if isempty(VCMList)
    VCMList = getlist(VCMFamily, 1);
end


if length(varargin) >= 1
    FileName = varargin{1};
    varargin(1) = [];
    if isempty(FileName)
        DirectoryName = getfamilydata('Directory', 'BLResponse');
        [FileName, DirectoryName] = uigetfile('*.mat', 'Select a Beamline response matrix file to load', DirectoryName);
        FileName = [DirectoryName FileName];
    end
end

BPMxFamily = 'BPMxPhot';     %use 'Phot' suffix to differentiate from nominal response matrix measurement
BPMyFamily = 'BPMyPhot';     

if ~isempty(FileName)
    [S, FileName] = getrespmat({BPMxFamily, BPMyFamily, SumFamily, ErrFamily}, {BPMxList, BPMyList, SumList, ErrList}, {VCMFamily}, {VCMList}, FileName, InputFlags{:});
else
    [S, FileName] = getrespmat({BPMxFamily, BPMyFamily, SumFamily, ErrFamily}, {BPMxList, BPMyList, SumList, ErrList}, {VCMFamily}, {VCMList}, InputFlags{:});
end



