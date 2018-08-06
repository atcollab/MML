function [Data, FileName] = getdisp(varargin)
%GETDISP - Returns the dispersion for a BPM family (from file)
%  [Data, FileName] = getdisp(BPMFamily, DeviceList, FileName)
%
%  INPUTS
%  1. BPMFamily  {Default: gethbpmfamily}
%  2. DeviceList {Default: the entire device list}
%  3. FileName - File name for dispersion data {Default:  <OpsData><DispFile>}
%                [] or '' - prompt the user to choose a response matrix file
%     To put the filename anywhere in the function call use the keyword, 'Filename' followed by the actual 
%     filename or '' to get a dialog box.  For example, m = getbpmresp('FileName','DispABC') to search in DispABC.mat.
%
%  Extra Flags:
%  1. 'Physics'  - For actual dispersion units
%     'Hardware' - For hardware units, usually mm/MHz {Default}
%  2. 'Struct'  - Data structures instead of vectors
%     'Numeric' - Vector outputs {Default}
%  3. Optional override of the mode
%     'Model' or 'Simulator' - Get the model dispersion directly from AT 
%                              (same as measdisp([], Family, DeviceList, 'Model'))
%
%  OUTPUTS
%  1. Data - Dispersion data
%
%  See also measdisp

%  Written by Greg Portmann


ModelFlag = 0;
FileName = -1;
Family = '';
DeviceList = [];
Data = [];
InputStruct = 0;

InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        if isfamily(varargin{i})
            % Structure input
            InputStruct = 1;
            Family = varargin{i}.FamilyName;
            DeviceList = varargin{i}.DeviceList;
            InputFlags = [InputFlags {varargin{i}.Units}];
        end
        varargin(i) = [];
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Struct')
        InputFlags = [varargin(i) InputFlags];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Numeric')
        InputFlags = [varargin(i) InputFlags];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Simulator') || strcmpi(varargin{i},'Model')
        ModelFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Physics')
        InputFlags = [varargin(i) InputFlags];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Hardware')
        InputFlags = [varargin(i) InputFlags];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'FileName')
        if length(varargin) >= i+1 && ischar(varargin{i+1})
            FileName = varargin{i+1};
            varargin(i:i+1) = [];
        else
            varargin(i) = [];
        end
        if isempty(FileName)
            DirectoryName = getfamilydata('Directory', 'DispData');
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a disperion data file', DirectoryName);
            if FileName == 0
                S = [];
                FileName = [];
                return;
            end
            FileName = [DirectoryName FileName];
        end
    elseif ischar(varargin{i}) && isfamily(varargin{i})
        Family = varargin{i};
        varargin(i) = [];
    elseif ischar(varargin{i}) && ~isfamily(varargin{i})
        FileName = varargin{i};
        varargin(i) = [];
    end
end

% For structure inputs, the default output is a structure
if InputStruct
    InputFlags = [InputFlags {'Struct'}];
end

% Default is physics units
if ~any(strcmpi(InputFlags, 'Hardware')) && ~any(strcmpi(InputFlags, 'Physics'))
    InputFlags = [InputFlags {'Physics'}];    
end

if isempty(Family)
    Family = gethbpmfamily; 
end

if length(varargin) >= 1 
    DeviceList = varargin{1};
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end


% Look in the dispersion file or calculate in the model
if ModelFlag == 1
    Data = measdisp([], Family, DeviceList, Family, DeviceList, 'Model', InputFlags{:});
    FileName = '';
else
    try
        if FileName == -1
            FileName = getfamilydata('OpsData','DispFile');
            DirectoryName = getfamilydata('Directory', 'OpsData');
            FileName = [DirectoryName FileName];
        elseif isempty(FileName)
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a Dispersion File?', getfamilydata('Directory','DispData'));
            if ~ischar(FileName)
                FileName = '';
                return
            else
                FileName = [DirectoryName FileName];
            end
        end

        % Get dispersion data from a file
        % Note: dispersion should not be scaled with energy
        [Data, FileName] = getrespmat(Family, DeviceList, 'RF', [], FileName, 'NoEnergyScaling', InputFlags{:});
    catch
        fprintf('   Could not find a dispersion response file, so using the model (%s).\n', Family);
        Data = measdisp([], Family, DeviceList, Family, DeviceList, 'Model', InputFlags{:});
        FileName = '';
    end
end

