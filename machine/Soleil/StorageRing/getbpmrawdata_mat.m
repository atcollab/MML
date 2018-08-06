function varargout = getbpmrawdata_mat(varargin)
% GETBPMRAWDATA - Gets turn by turn data for  BPM
%
%  INPUTS
%  1. num - bpm number (scalar or vector) list ([] means all valid BPM)
%
%  Optional input arguments
%  2. Optional display
%     'Display'   - Plot BPM data X,Z, Sum, Q 
%     'NoDisplay' - No plotting
%  3. 'NoArchive' - No file archive {Default}
%     'Archive'   - Save a dispersion data structure to \<Directory.BPMData>\<DispArchiveFile><Date><Time>.mat
%                   To change the filename, included the filename after the 'Archive', '' to browse
%                   Structure output  is forced
%  4. 'Struct'    - Return out as a structure
%  5. 'Freezing'  - Buffer freezing mechanism 
%     'NoFreezing'
%
%  OUTPUTS
%  structure output if 'Struct' precised
%  AM
%
%  vector output
%  1. X - Horizontal data
%  2. Z - Vertical data
%  3. Sum - Sum signal data
%  4. Q  - Quadrupole signal data
%  5. Va - electrode data
%  6. Vb - electrode data
%  7. Vc - electrode data
%  8. Vd - electrode data
%
%  EXAMPLES
%  1. Display BPM 18
%      getbpmrawdata(18)
%  2. Display all valid BPM and output data as a structure
%      getbpmrawdata([],'Struct');
%  3. Output all valid BPM data
%      [X Z Sum Q Va Vb Vc Vd] = getbpmrawdata([],'NoDisplay');
%  4. Archives BPM 17 and 18 w/o displaying
%     getbpmrawdata([17 18],'Archive','NoDisplay');
%  5. Archives BPM 17 and 18 w/o displaying w/ buffer freezing mechanism
%     getbpmrawdata([17 18],'Archive','NoDisplay','Freezing');
%
% See Also anabpmfirstturn

%
% Written by Laurent S. Nadolski

% TODO freezing mechanism: introduce group

DisplayFlag = 1;
ArchiveFlag = 0;
StructureFlag = 0;
FreezingFlag = 0;
FileName='';
varargin2 = {};

if ~exist('DeviceName','var')
    DeviceName = [];
end

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin2 = {varargin2{:} varargin{i}};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin2 = {varargin2{:} varargin{i}};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Archive')
        ArchiveFlag = 1;
        StructureFlag = 1;
%        varargin2 = {varargin2{:} varargin{i}};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoArchive')
        ArchiveFlag = 0;
%        varargin2 = {varargin2{:} varargin{i}};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Struct')
        StructureFlag = 1;
        varargin2 = {varargin2{:} varargin{i}};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Freezing')
        FreezingFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoFreezing')
        FreezingFlag = 0;
        varargin(i) = [];
    end
end

AO = getfamilydata('BPMx');
% if empty select all valid BPM

if isempty(varargin)
    num = 1:length(AO.DeviceName);
else
    num = varargin{1};
    if isempty(num)
        num = 1:length(AO.DeviceName);
    end
end

% Status one devices
valid  = find(AO.Status);
num    = intersect(num,valid);

if isempty(num)
    disp('All BPM not valid')
    return;
end

%
% % read BPM number of samples
% % If all not the same stop program and ask action to user
% for k = 1:length(num)
%     modestr{k} = char(readattribute([AO.DeviceName{num(k)} '/Mode']));
% end
% 
% for k = 1:length(num)
%     sampleNumber(k) = readattribute([AO.DeviceName{num(k)} '/NumSamples']);
% end
% 
% notTheSame = sampleNumber-sampleNumber(1);
% 
% if ~all(strcmp(modestr,modestr{1}))
%    disp([mfilename ' STOP!']); 
%    error('Not all BPM in the same mode')
%    return;
% end
% 
% if (sum(notTheSame) ~= 0)
%    disp([mfilename ' STOP!']); 
%    error('Not all BPM with the same number of samples')
%    return;
% end

%% Buffer freezing
% Enable freezing mechanism
if (FreezingFlag)
%     hh = warndlg('BPMmanager must be stop and BPM mode be FT or TT');
%     uiwait(hh);
    disp([mfilename ': Enabling freezing mecanism']);
    for k = 1:length(num)
        tango_command_inout2(AO.DeviceName{num(k)},'EnableBufferFreezing');
    end
    disp([mfilename ': Freezing BPM: pseudo synchronism']);
    for k = 1:length(num)
        tango_command_inout2(AO.DeviceName{num(k)},'UnFreezeBuffer');
    end    
end

%% loop of bpm list
if length(num) > 1
    AM.DeviceList=[];
    for k = 1:length(num)   
        
        AM0 = getbpmrawdata_mat(num(k),varargin2{:},'Struct');
        try
            AM.DeviceName{k} = AM0.DeviceName{:};
            AM.Data.X(k,:) = AM0.Data.X(:); AM.Data.Z(k,:) = AM0.Data.Z(:);
            AM.Data.Sum(k,:) = AM0.Data.Sum(:); AM.Data.Q(k,:) = AM0.Data.Q(:);
            AM.Data.Va(k,:) = AM0.Data.Va(:); AM.Data.Vb(k,:) = AM0.Data.Vb(:);
            AM.Data.Vc(k,:) = AM0.Data.Vc(:); AM.Data.Vd(k,:) = AM0.Data.Vd(:);
            AM.TimeStamp = datestr(now);
            AM.DataDescriptor = ['Turn by turn data for ' getfamilydata('Machine')];
            AM.CreatedBy = mfilename;
            AM.DeviceList = [AM.DeviceList; AM0.DeviceList];
        catch
            switch lasterr
                case 'Subscripted assignment dimension mismatch.'
                    error('BPM do not have the same number of samples !!!')
            end
        end
    end

    % Disable freezing mechanism
    if (FreezingFlag)
        disp([mfilename ': disabling buffer freezing for BPM'])
        for k = 1:length(num)
            tango_command_inout2(AO.DeviceName{num(k)},'DisableBufferFreezing');
        end
    end

else
    %% Loop for one BPM
    AO = getfamilydata('BPMx');
    AO.DeviceName;

    attr_name = ...
        {'XPosDD','ZPosDD', 'QuadDD', 'SumDD', ...
        'VaDD', 'VbDD', 'VcDD', 'VdDD'};
    
        
    rep = tango_read_attributes2(AO.DeviceName{num},attr_name);

    X   = rep(1).value;
    Z   = rep(2).value;
    Q   = rep(3).value;
    Sum = rep(4).value;
    Va  = rep(5).value;
    Vb  = rep(6).value;
    Vc  = rep(7).value;
    Vd  = rep(8).value;

    %% Display part

    if DisplayFlag
        figure
        subplot(2,2,1)
        plot(X)
        ylabel('X (mm)')
        grid on

        subplot(2,2,2)
        plot(Z)
        ylabel('Z (mm)')
        grid on

        subplot(2,2,3)
        plot(Sum)
        ylabel('SUM')
        xlabel('turn number')
        grid on

        subplot(2,2,4)
        plot(Q)
        ylabel('Q')
        xlabel('turn number')
        grid on
        addlabel(1,0,datestr(clock));
        suptitle(sprintf('Turn by turn data for %s',AO.DeviceName{num}))
    end

    if StructureFlag
        AM.DeviceName = AO.DeviceName(num);
        AM.Data.X   = X;
        AM.Data.Z   = Z;
        AM.Data.Sum = Sum;
        AM.Data.Q   = Q;
        AM.Data.Va  = Va;
        AM.Data.Vb  = Vb;
        AM.Data.Vc  = Vc;
        AM.Data.Vd  = Vd;
        %time stamp of recording
        AM.TimeStamp = datestr(now);
        AM.DataDescriptor = ['Turn by turn data for ' getfamilydata('Machine')];
        AM.CreatedBy = mfilename;
        AM.DeviceList = tango2dev(AO.Monitor.TangoNames{num});
    end

end

if ArchiveFlag
    % filling up data
    % Archive data structure
    if isempty(FileName)
        FileName = appendtimestamp(getfamilydata('Default', 'BPMArchiveFile'));
        DirectoryName = getfamilydata('Directory','BPMData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'BPM', filesep];
        else
            % Make sure default directory exists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        [DirectoryName FileName]
        [FileName, DirectoryName] = uiputfile('*.mat', 'Select Dispersion File', [DirectoryName FileName]);
        if FileName == 0
            ArchiveFlag = 0;
            disp('   BPM measurement canceled.');
            FileName='';
            return
        end
        FileName = [DirectoryName, FileName];
    elseif FileName == -1
        FileName = appendtimestamp(getfamilydata('Default', 'BPMArchiveFile'));
        DirectoryName = getfamilydata('Directory','BPMData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'BPM', filesep];
        end
        FileName = [DirectoryName, FileName];
    end

    save(FileName,'AM');

end

if StructureFlag
    varargout{1} = AM;
else
    if exist('AM','var') % not nice but it works
        varargout{1} = AM.Data.X; varargout{2} =   AM.Data.Z;
        varargout{3} = AM.Data.Sum; varargout{4} =  AM.Data.Q;
        varargout{5} = AM.Data.Va; varargout{6} =  AM.Data.Vb;
        varargout{7} = AM.Data.Vc; varargout{8} =  AM.Data.Vd;
    else
        varargout{1} = X;   varargout{2} =   Z;
        varargout{3} = Sum; varargout{4} =  Q;
        varargout{5} = Va;  varargout{6} =  Vb;
        varargout{7} = Vc;  varargout{8} =  Vd;
    end
end
