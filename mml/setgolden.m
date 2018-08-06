function varargout = setgolden(varargin)
%SETGOLDEN - Set the golden values
%  [DataStruct, ...] = setgolden(FamilyName, Data, DeviceList)
%  [DataStruct, ...] = setgolden(FamilyName, FileName, DeviceList)
%  [DataStruct, ...] = setgolden(FileName)
%  [DataStruct, ...] = setgolden(DataStruct)
%  [DataStruct, ...] = setgolden(DataStruct1, DataStruct2, ...)
%
%  INPUTS
%  1. FamilyName - Family to set the offset field {Default: BPM families}
%                  (can be a cell array of families)
%     DataStruct - Data structure input (.FamilyName, .Data, and .DeviceList fields are used)
%     FileName - Data structure input can be in a file
%  2. Data - Data vector to set
%  3. DeviceList - Device list
%
%  OUTPUTS
%  1. DataStruct - The data structure with the new offset in the .Data field
%
%  NOTES
%  1. The golden values are changed for the present Matlab session only.  They are
%     not saved for future sessions.  The golden orbit is usually set in the 
%     one of the initialization files (like setoperationalmode).
%  2. This function calls setfamilydata.
%
%  See also setoffset, savegoldenorbit, getgolden, plotgoldenorbit

%  Written by Greg Portmann
%  Modifid by Laurent S. Nadolski

Family = '';
FileName = '';

if nargin == 0
    %DirName = getfamilydata('Directory','BPMData');
    DirName = getfamilydata('Directory','DataRoot');
    [FileName, DirName] = uigetfile([DirName,filesep,'*.mat'], 'Select a data file:');

    if FileName == 0
        return;
    end

    FileName = [DirName, FileName];
end


if nargin >= 1
    if iscell(varargin{1})
        Family = varargin{1};
    elseif isstruct(varargin{1})
        Family = {varargin{1}.FamilyName};
        varargout{1} = varargin{1};
    elseif isfamily(varargin{1})
        Family{1} = {varargin{1}};
        varargout{1}.FamilyName = varargin{1};
    elseif ischar(varargin{1})
        FileName = varargin{1};
    else
        error('Input #1 unknown type: Family or Filename expected.');
    end
end

if nargin >= 2
    if isstruct(varargin{2})
        Family = [Family; {varargin{2}.FamilyName}];
        varargout{2} = varargin{2};
    elseif ischar(varargin{2})
        FileName = varargin{2};
    elseif isnumeric(varargin{2})
        varargout{1}.Data = varargin{2};
    elseif isempty(varargin{2})
        %DirName = getfamilydata('Directory','BPMData');
        DirName = getfamilydata('Directory','DataRoot');
        [FileName, DirName] = uigetfile([DirName,filesep,'*.mat'], 'Select data file:');
        if FileName == 0
            return;
        end
        FileName = [DirName, FileName];
    else
        error('Input #2 unknown type: Data or Filename expected.');
    end
end


DeviceListFlag = 0;
if nargin >= 3
    if isstruct(varargin{3})
        Family = [Family; {varargin{3}.FamilyName}];
        varargout{3} = varargin{3};
    elseif isnumeric(varargin{3})
        DeviceList = varargin{3};
        if ~isfield(varargin{1}, 'DeviceList')
            varargin{1}.DeviceList = varargin{3};
        end
        DeviceListFlag = 1;
    else
        error('Input #3 unknown type: DeviceList expected.');
    end
end


% Extra structures can be passed on
for i = 4:nargin
    if isstruct(varargin{i})
        Family = [Family; {varargin{i}.FamilyName}];
        varargout{i} = varargin{i};
    end
end

    
if ~isempty(FileName)
    if isempty(Family)
        Family = findmemberof('BPM');
        if isempty(Family)
            Family = {gethbpmfamily; getvbpmfamily};
        end
    end
end


for i = 1:length(Family)
    if ~isempty(FileName)
        if DeviceListFlag
            varargout{i} = getdata(Family{i}, DeviceList, 'Struct', FileName);
        else
            varargout{i} = getdata(Family{i}, 'Struct', FileName);
        end
    end

    if DeviceListFlag
        [iFound, iNotFound] = findrowindex(DeviceList, varargout{i}.DeviceList);
        if ~isempty(iNotFound)
            error('Not all the devices are in the data set.');
        end
        varargout{i}.Data = varargout{i}.Data(iFound,:);
        varargout{i}.DeviceList = varargout{i}.DeviceList(iFound,:);
    end

    if size(varargout{i}.Data,1) ~= size(varargout{i}.DeviceList,1)
        error('The size of the data does not equal the number of devices.');
    end
    
    setfamilydata(varargout{i}.Data, varargout{i}.FamilyName, 'Golden', varargout{i}.DeviceList);
end