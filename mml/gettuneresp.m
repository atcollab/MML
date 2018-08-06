function [TuneMatrix, FileName] = gettuneresp(varargin)
%GETTUNERESP - Loads the tune response vector (or matrix) for multiple quadrupole families
%  [TuneMatrix, FileName] = gettuneresp(FamilyName1, DeviceList1, FamilyName2, DeviceList2, ... , FileName, GeV)
%  [TuneMatrix, FileName] = gettuneresp(DataStructure1, DataStructure2, ... , FileName, GeV)
%
%  INPUTS
%  1. FamilyName - Quadrupole family name
%  2. DeviceList - DeviceList for a quadrupole family.  If [] or no input, then TuneMatrix 
%                  will be a column vector which is the cumulative sum of all magnets in the family.
%  3. FileName - File name to look for the response matrix (or cell array of file names)
%                [] or '' - prompt the user to choose a response matrix file
%                To put the filename anywhere in the function call use the keyword, 'Filename' followed by the actual 
%                filename or '' to get a dialog box.  For example, m = gettuneresp('FileName','RmatABC') to search in RmatABC.mat.
%  4. GeV is the energy that the response matrix will be used at {Default or []: getenergy}.
%     It's not always desirable to scale by the energy, so the following keywords can be used.
%     'EnergyScaling' - Scale the response matrix by energy (getenergy / measured energy) {Default}
%     'NoEnergyScaling' - Don't scale with energy
%  5. 'Struct'  will return the response matrix structure {default for data structure inputs}
%     'Numeric' will return a numeric matrix {default for non-data structure inputs}
%  Note: FamilyName and DeviceList can be cell arrays instead of multiple input pairs
%
%  OUTPUTS
%  1. TuneMatrix = Response matrix 
%
%     It is assumed that most common use of this function is with the  
%     QF and QD families on a ganged power supply.  Hence, the default 
%     behavior is to return the cumulative sum of all the magnets in the chain.
%     If there is more than one FamilyName, then TuneMatrix will be a matrix  
%     where each column is the sum of the contribution of all magnets in that family.
%
%     To get the response matrix for individual magnets in the family use getrespmat:
%     getrespmat('TUNE', [1 1;1 2], MagnetFamilyName, MagnetDeviceList)
%     For instance, getrespmat('TUNE', [1 1;1 2], 'QF', [])
%
%  EXAMPLES
%  1. M = gettuneresp
%     M = gettuneresp({'QF','QD'}) 
%     M = gettuneresp({'QF','QD'},{[],[]})
%     M = gettuneresp('QF',getlist('QF'))
%     All returns the same 2x2 matrix of QF and QD to horizontal and vertical tune
%
%  2. M = gettuneresp('QF')
%     M = gettuneresp('QF', []) 
%     Returns a 2x1 matrix representing the cumulative sum of all the magnets in the chain
%
%  3. QF_DataStruct = getsp('QF','Struct');
%     M = gettuneresp(QF_DataStruct); 
%     Returns a 2x1 matrix representing the cumulative sum of all the magnets in the chain
%
%  4. Change the tune by [.01; -.01] using the entire 'QF' and 'QD' families (see stepchro)
%     DeltaTune = [.01; -.01];
%     DeltaAmps = inv(gettuneresp) * DeltaTune;
%     setsp({'QF', 'QD'}, {getsp('QF')+DeltaAmps(1), getsp('QD')+DeltaAmps(2)});
%
%  See also meastuneresp, steptune

%  Written by Greg Portmann


FileName = '';
NumericFlag = 1;
InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Struct')
        NumericFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Numeric')
        NumericFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        % Remove
        fprintf('GETTUNERESP WARNING: ''Online'' input ignored.  Used meastuneresp to get the chromaticity response matrix.');
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Simulator')
        % Remove
        fprintf('GETTUNERESP WARNING: ''Simulator'' input ignored.  Used meastuneresp to get the chromaticity response matrix.');
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Model')
        % Remove
        fprintf('GETTUNERESP WARNING: ''Model'' input ignored.  Used meastuneresp to get the model chromaticity response matrix.');
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Model')
        fprintf('WARNING: ''Model'' input ignored.  Used meastuneresp to get the model tune response matrix.');
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoEnergyScaling')
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'EnergyScaling')
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
            DirectoryName = getfamilydata('Directory', 'TuneResponse');
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a TUNE response matrix file', DirectoryName);
            FileName = [DirectoryName FileName];
        end
        InputFlags = [InputFlags {FileName}];
    end
end

ActuatorFamilyDefault = findmemberof('Tune Corrector')';
if isempty(ActuatorFamilyDefault)
    error('MemberOf ''Tune Corrector'' was not found');
end

if isempty(varargin)
    FamilyNameCell = ActuatorFamilyDefault;
    DeviceListCell = cell(size(ActuatorFamilyDefault));
    NumFamilies = length(FamilyNameCell);
    
elseif length(varargin) == 1 && isempty(varargin{1})
    FamilyNameCell = ActuatorFamilyDefault;
    DeviceListCell = cell(size(ActuatorFamilyDefault));
    NumFamilies = length(FamilyNameCell);
    
elseif iscell(varargin{1})
    FamilyNameCell = varargin{1};
    varargin(1) = [];
    if length(varargin) >= 1
        DeviceListCell = varargin{1};
        varargin(1) = [];
    else
        for i = 1:length(FamilyNameCell)
            DeviceListCell{i} = [];
        end
    end
    NumFamilies = length(FamilyNameCell);
    if ~iscell(DeviceListCell)
        error('If FamilyName is a cell array then DeviceList must be a cell array')
    end
    
elseif isstruct(varargin{1})
    NumFamilies = 0;
    while ~isempty(varargin)
        % Look for Family and DeviceList
        if length(varargin) >= 1
            if ~isstruct(varargin{1})
                break
            end
            if ~isfamily(varargin{1}.FamilyName)
                error('Unknown family name in data structure');
            end
            NumFamilies = NumFamilies + 1;
            FamilyNameCell{NumFamilies} = varargin{1}.FamilyName;
            DeviceListCell{NumFamilies} = varargin{1}.DeviceList;
            varargin(1) = [];
        end
    end
    
else
    NumFamilies = 0;
    while ~isempty(varargin)
        % Look for Family and DeviceList
        if length(varargin) >= 1
            if ~isfamily(varargin{1})
                break
            end
            NumFamilies = NumFamilies + 1;
            FamilyNameCell{NumFamilies} = varargin{1};
            varargin(1) = [];
        end
        if length(varargin) >= 1
            if isnumeric(varargin{1}) || isempty(varargin{1})
                DeviceListCell{NumFamilies} = varargin{1};
                varargin(1) = [];
            else
                DeviceListCell{NumFamilies} = [];
            end
        else
            DeviceListCell{NumFamilies} = [];
        end
    end
end

% FileName should be the next input (if a string, or [] for dialog box)
if length(varargin) >= 1
    if ischar(varargin{1}) || isempty(varargin{1})
        FileName = varargin{1};
        varargin(1) = [];

        if isempty(FileName)
            % Note: This only works if all families are in the same file
            DirectoryName = getfamilydata('Directory', 'TuneResponse');  
            [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat','Select Quadrupole-to-Tune Response Matrix File', DirectoryName);
            if FilterIndex == 0
                TuneMatrix = [];
                FileName = [];
                return
            end
            
            FileName = [DirectoryName FileName];
            InputFlags = [{FileName} InputFlags];
        end
    end
end


% The only thing left on the input line can be energy which can be left in varargin


% Get the response matrix
if NumericFlag == 1
    TuneMatrix = [];
end
for i = 1:NumFamilies
    if NumericFlag == 1
        try
            [M, FileName] = getrespmat('TUNE', [1 1;1 2], FamilyNameCell{i}, DeviceListCell{i}, 'Numeric', InputFlags{:}, varargin{:});
        catch
            fprintf('   Could not find a TUNE response matrix file, so using the model (%s).\n', FamilyNameCell{i});
            M = meastuneresp(FamilyNameCell{i}, DeviceListCell{i}, 'Model', 'Numeric', InputFlags{:}, varargin{:});
            %M = measrespmat('TUNE', [1 1;1 2], FamilyNameCell{i}, DeviceListCell{i}, 'Model', 'Numeric', InputFlags{:}, varargin{:});
            FileName = '';
        end
        TuneMatrix = [TuneMatrix sum(M,2)];
    else
        try
            [TuneMatrix(1,i), FileName] = getrespmat('TUNE', [1 1;1 2], FamilyNameCell{i}, DeviceListCell{i}, 'Struct', InputFlags{:}, varargin{:});
        catch
            fprintf('   Could not find a TUNE response matrix file, so using the model (%s).\n', FamilyNameCell{i});
            TuneMatrix(1,i) = meastuneresp(FamilyNameCell{i}, DeviceListCell{i}, 'Model', 'Struct', InputFlags{:}, varargin{:});
            FileName = '';
        end
    end
end


