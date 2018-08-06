function [Data, FileName] = getchro(varargin)
%GETCHRO - Return the chromaticity function (from file)
%  [Data, FileName] = getchro(Plane, FileName)
%
%
%  INPUTS
%  1. Plane - 'x' or 'Horizontal'
%             'y' or 'Vertical'
%  2. FileName - {Default start directory: <OpsData><ChroFile>}
%
%  Extra Flags:
%  1. 'Physics'  - For actual chromaticity units {Default}
%     'Hardware' - For hardware units, usually mm/MHz
%  2. 'Struct'  - Data structures instead of vectors
%     'Numeric' - Vector outputs {Default}
%  3. Optional override of the mode
%     'Model' or 'Simulator' - Get the model chromaticity directly from AT 
%                              (same as measchro([], Family, DeviceList, 'Model'))
%
%  OUTPUTS
%  1. Data - Chromaticity data
%  
%  See also getrespmat, setchro

%  Written by Greg Portmann

ModelFlag = 0;
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
    elseif strcmpi(varargin{i},'Simulator') || strcmpi(varargin{i},'Model')
        ModelFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Physics')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Hardware')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        varargin(i) = [];
    elseif ischar(varargin{i}) && ~isfamily(varargin{i})
        FileName = varargin{i};
        varargin(i) = [];
    end
end


% Default units
if ~any(strcmpi(InputFlags,'Physics')) && ~any(strcmpi(InputFlags,'Hardware'))
    InputFlags{length(InputFlags)+1} = 'Physics';
end


% Look in the chromaticity file
if ModelFlag == 1
    Data = measchro('Model', InputFlags{:});
    FileName = '';
else
    if FileName == -1 
        FileName = getfamilydata('OpsData','ChroFile');
        DirectoryName = getfamilydata('Directory', 'OpsData'); 
        FileName = [DirectoryName FileName];
    elseif isempty(FileName)
        [FileName, DirectoryName] = uigetfile('*.mat', 'Select a Chromaticity File?', getfamilydata('Directory','ChroData'));
        if ~ischar(FileName)
            return
        else
            FileName = [DirectoryName FileName];
        end
    end
    [Data, FileName] = getrespmat('TUNE', [1 1;1 2], 'RF', [], FileName, InputFlags{:});
end

