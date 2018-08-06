function [ColumnName, ErrorFlag] = family2archive(varargin)
%FAMILY2ARCHIVE - Converts the family name to a database column name in the archiver
%  ColumnName = family2archive(Family, Field, DeviceList)
%  ColumnName = family2archive(Family, DeviceList)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%              or Cell Array of Families
%  2. Field = Accelerator Object field name ('Monitor', 'Setpoint', etc) {Default: 'Monitor'}
%  3. DeviceList ([Sector Device #] or [element #]) {Default: whole family}
%
%  OUTPUTS
%  1. ColumnName - database column name corresponding to the Family, Field, and DeviceList

%  Written by Greg Portmann


% :LONG got added to these channels and put with the floats
% IGPF:LFB:DACTST:AMP:LONG
% IGPF:LFB:DELAY:LONG
% IGPF:LFB:FLT:TAPS:LONG
% IGPF:LFB:GDLEN:LONG
% IGPF:LFB:PROC_DS:LONG
% IGPF:LFB:REC_DS:LONG
% IGPF:LFB:RECLEN:LONG
% IGPF:LFB:SHIFTGAIN:LONG
% IGPF:LFB:WRT:AD8842CH0:LONG
% IGPF:LFB:WRT:AD8842CH1:LONG
% IGPF:LFB:WRT:AD8842CH2:LONG
% IGPF:LFB:WRT:AD8842CH3:LONG
% IGPF:LFB:WRT:AD8842CH4:LONG
% IGPF:LFB:WRT:AD8842CH5:LONG
% IGPF:LFB:WRT:AD8842CH6:LONG
% IGPF:LFB:WRT:AD8842CH7:LONG
% IGPF:LFB:WRT:BE_PHASE:LONG
% IGPF:LFB:WRT:FE_PHASE:LONG
% IGPF:LFB:WRT:FID_DELAY:LONG
% IGPF:LFB:WRT:HOLDOFF:LONG
% IGPF:LFB:WRT:PHDCM0:LONG
% LIBERA_0AB2:SA:SA_X_MONITOR:LONG
% LIBERA_0AB2:SA:SA_Y_MONITOR:LONG
% LIBERA_0AB2:SA:SA_Q_MONITOR:LONG
% LIBERA_0AB2:SA:SA_SUM_MONITOR:LONG
% LIBERA_0AB2:SA:SA_A_MONITOR:LONG
% LIBERA_0AB2:SA:SA_B_MONITOR:LONG
% LIBERA_0AB2:SA:SA_C_MONITOR:LONG
% LIBERA_0AB2:SA:SA_D_MONITOR:LONG
% LIBERA_0AB2:SA:SA_CX_MONITOR:LONG
% LIBERA_0AB2:SA:SA_CY_MONITOR:LONG
% LIBERA_0AB2:ENV:ENV_SWITCHES_MONITOR:LONG
% LIBERA_0AB2:ENV:ENV_GAIN_MONITOR:LONG
% LIBERA_0AB2:ENV:ENV_KX_MONITOR:LONG
% LIBERA_0AB2:ENV:ENV_KY_MONITOR:LONG
% LIBERA_0AB2:ENV:ENV_Q_OFFSET_MONITOR:LONG
% LIBERA_0AB2:ENV:ENV_X_OFFSET_MONITOR:LONG
% LIBERA_0AB2:ENV:ENV_Y_OFFSET_MONITOR:LONG
% LIBERA_0AB2:ENV:ENV_ERROR_MONITOR:LONG
% LIBERA_0AB2:ENV:ENV_SWITCHES_SP:LONG
% LIBERA_0AB2:ENV:ENV_GAIN_SP:LONG
% LIBERA_0AB2:ENV:ENV_KX_SP:LONG
% LIBERA_0AB2:ENV:ENV_KY_SP:LONG
% LIBERA_0AB2:ENV:ENV_Q_OFFSET_SP:LONG
% LIBERA_0AB2:ENV:ENV_X_OFFSET_SP:LONG
% LIBERA_0AB2:ENV:ENV_Y_OFFSET_SP:LONG



if nargin == 0
    error('Must have at least one input (''Family'')!');
end


ErrorFlag = 0;

    
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
    
    for i = 1:length(varargin{1})
        if length(varargin) == 1
            [ColumnName{i}, ErrorTmp] = family2archive(varargin{1}{i});
        elseif length(varargin) == 2
            if iscell(varargin{2})
                [ColumnName{i}, ErrorTmp] = family2archive(varargin{1}{i}, varargin{2}{i});
            else
                [ColumnName{i}, ErrorTmp] = family2archive(varargin{1}{i}, varargin{2});
            end
        else            
            if iscell(varargin{2})
                if iscell(varargin{3})
                    [ColumnName{i}, ErrorTmp] = family2archive(varargin{1}{i}, varargin{2}{i}, varargin{3}{i});
                else
                    [ColumnName{i}, ErrorTmp] = family2archive(varargin{1}{i}, varargin{2}{i}, varargin{3});
                end
            else
                if iscell(varargin{3})
                    [ColumnName{i}, ErrorTmp] = family2archive(varargin{1}{i}, varargin{2}, varargin{3}{i});
                else
                    [ColumnName{i}, ErrorTmp] = family2archive(varargin{1}{i}, varargin{2}, varargin{3});
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
    if isfield(varargin{1},'FamilyName') && isfield(varargin{1},'Field')
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
        ColumnName = varargin{1}.(Field).ColumnName(i,:);
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


%%%%%%%%%%%%%%%%%
% Special cases %
%%%%%%%%%%%%%%%%%
switch Family
    case 'LCW'
        ColumnName = 'LCW';
        
    case 'DCCT'
        ColumnName = 'DCCT';
        
    case {'Energy', 'ENERGY'}
        ColumnName = 'Energy';
        
    case {'UserBeam', 'UserBeam'}
        ColumnName = 'UserBeam';
        
    otherwise
        % Use the channel name
        if isempty(Field)
            Field = 'Monitor';
        end
        if isempty(DeviceList)
            DeviceList = family2dev(Family);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CommonName Input:  Convert common names to a DeviceList %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ischar(DeviceList)
            DeviceList = common2dev(DeviceList, Family);
            if isempty(DeviceList)
                error('DeviceList was a string but common names could not be found.');
            end
        end

        [ColumnName, ErrorFlag] = getfamilydata(Family, Field, 'ChannelNames', DeviceList);
        
        ColumnName = rollbackchanges(ColumnName);
                
        % Convert '.' to '_'
        % Note: this does not always work: for instance, the scrapers need the "."
        %[i,j] = find(ColumnName == '.');
        %ColumnName(i,j) = '_';
end



function ColumnName = rollbackchanges(ColumnName)

% BPMs in sector 4, 8, 12 had a name change 2007-09-05, but the column names did not
OldName = [
    'SR04C___BPM4YT_AM01'
    'SR04C___BPM5XT_AM02'
    'SR04C___BPM5YT_AM03'
    'SR08C___BPM4YT_AM01'
    'SR08C___BPM5XT_AM02'
    'SR08C___BPM5YT_AM03'
    'SR12C___BPM4YT_AM01'
    'SR12C___BPM5XT_AM02'
    'SR12C___BPM5YT_AM03' ];

NewName = [
    'SR04C___BPM4YT_AM00'
    'SR04C___BPM5XT_AM00'
    'SR04C___BPM5YT_AM00'
    'SR08C___BPM4YT_AM00'
    'SR08C___BPM5XT_AM00'
    'SR08C___BPM5YT_AM00'
    'SR12C___BPM4YT_AM00'
    'SR12C___BPM5XT_AM00'
    'SR12C___BPM5YT_AM00' ];

if size(NewName,2) == size(ColumnName,2)
    [i,itmp,j] = findrowindex(NewName, ColumnName);
    if ~isempty(ColumnName)
        ColumnName(i,:) = OldName(j,:);
    end
end

