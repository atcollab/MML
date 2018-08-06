function [TangoNames, ErrorFlag] = family2tango(varargin)
%FAMILY2TANGO - Converts a familly to TANGO names
% [TangoNames, ErrorFlag] = family2tango(Family, Field, DeviceList)
%
% INPUTS  
% 1. Family = Family Name 
%             Data Structure
%             Accelerator Object
%             Cell Array
% 2. Field = Accelerator Object field name ('Monitor', 'Setpoint', etc) {'Monitor'}
% 3. DeviceList ([Sector Device #] or [element #]) {default: whole family}
% 
% OUTPUTS 
% 1. TangoNames = Channel name corresponding to the Family, Field, and DeviceList
%
% NOTES
% 1. If Family is a cell array, then DeviceList and Field must also be a cell arrays
% 2. Returns only status 1 devices -- See StatusFlag
%
% EXAMPLES 
% 1. family2tango('BPMx')
% 2. family2tango('BPMx','Monitor',[1 1])
% 3. family2tango({'HCOR','VCOR'},{'Monitor','Monitor'},{[1 1],[1 2]})
%
% See also tango2family

% 
% Written by Laurent S. Nadolski

if nargin == 0
    error('Must have at least one input (''Family'')!');
end


%%%%%%%%%%%%%%%%%%%%%
% Cell Array Inputs %
%%%%%%%%%%%%%%%%%%%%%
if iscell(varargin{1})
    if length(varargin) >= 3 && iscell(varargin{3})
        if length(varargin{1}) ~= length(varargin{3})
            error('Family and DeviceList must be the same size cell arrays.');
        end
    end
    if length(varargin) >= 2 && iscell(varargin{2})
        if length(varargin{1}) ~= length(varargin{2})
            error('If Field is a cell array, then must be the same size as Family.');
        end
    end
    
  ErrorFlag = 0;
    for i = 1:length(varargin{1})
        if length(varargin) == 1
            [TangoNames{i}, ErrorTmp] = family2tango(varargin{1}{i});
        elseif length(varargin) == 2
            if iscell(varargin{2})
                [TangoNames{i}, ErrorTmp] = family2tango(varargin{1}{i}, varargin{2}{i});
            else
                [TangoNames{i}, ErrorTmp] = family2tango(varargin{1}{i}, varargin{2});
            end
        else            
            if iscell(varargin{2})
                if iscell(varargin{3})
                    [TangoNames{i}, ErrorTmp] = family2tango(varargin{1}{i}, varargin{2}{i}, varargin{3}{i});
                else
                    [TangoNames{i}, ErrorTmp] = family2tango(varargin{1}{i}, varargin{2}{i}, varargin{3});
                end
            else
                if iscell(varargin{3})
                    [TangoNames{i}, ErrorTmp] = family2tango(varargin{1}{i}, varargin{2}, varargin{3}{i});
                else
                    [TangoNames{i}, ErrorTmp] = family2tango(varargin{1}{i}, varargin{2}, varargin{3});
                end
            end
        end
        ErrorFlag = ErrorFlag | ErrorTmp;
    end
    return    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Family or data structure inputs beyond this point %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isstruct(varargin{1})
    if isfield(varargin{1},'FamilyName') & isfield(varargin{1},'Field')
        % Data structure inputs
        Family = varargin{1}.FamilyName;

        Field = varargin{1}.Field;
        if length(varargin) >= 2
            if ischar(varargin{2})
                Field = varargin{2};
                varargin(2) = [];
            end
        end
        if length(varargin) >= 2
            DeviceList = varargin{2};
        else
            DeviceList = varargin{1}.DeviceList;
        end
    else
        % AO input
        Field = '';
        if length(varargin) >= 2
            if ischar(varargin{2})
                Field = varargin{2};
                varargin(2) = [];
            end
        end
        if length(varargin) >= 2
            DeviceList = varargin{2};
        else
            DeviceList = varargin{1}.DeviceList;
        end
        
        if isempty(Field)
            Field = 'Monitor';
        end
        if isempty(DeviceList)
            DeviceList = varargin{1}.DeviceList;
        end
        if isempty(DeviceList)
            DeviceList = family2dev(Family);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CommonName Input:  Convert common names to a varargin{3} %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if isstr(DeviceList)
            DeviceList = common2dev(DeviceList, Family);
            if isempty(DeviceList)
                error('DeviceList was a string but common names could not be found.');
            end
        end

        [i,iNotFound] = findrowindex(DeviceList, varargin{1}.DeviceList);
        if ~isempty(iNotFound)
            error('Device at found in the input structure');
        end
        TangoNames = varargin{1}.(Field).TangoNames(i,:);
        ErrorFlag = 0;

        return;
    end

else
    
    % Family input
    Family = varargin{1};
    
    Field = '';
    if length(varargin) >= 2
        if ischar(varargin{2})
            Field = varargin{2};
            varargin(2) = [];
        end
    end
    if length(varargin) >= 2
        DeviceList = varargin{2};
    else
        DeviceList = [];
    end
    
end

if isempty(Field)
    Field = 'Monitor';
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% CommonName Input:  Convert common names to a varargin{3} %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ischar(DeviceList)
    DeviceList = common2dev(DeviceList, Family);
    if isempty(DeviceList)
        error('DeviceList was a string but common names could not be found.');
    end
end


%%%%%%%%%%%%
% Get data %
%%%%%%%%%%%%
[TangoNames, ErrorFlag] = getfamilydata(Family, Field, 'TangoNames', DeviceList);
