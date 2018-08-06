function [AM, tout, DataTime, ErrorFlag] = getz(varargin)
%getz - Returns the vertical orbit
%  [AM, tout, DataTime]  = getz(DeviceList, t, FreshDataFlag, TimeOutPeriod)
%         or
%  [AM, tout, DataTime]  = getz(DataStructure, t, FreshDataFlag, TimeOutPeriod)
%
%  INPUTS
%  1. DeviceList or DataStructure  (see help getpv)
%  2. t  (see help getpv)
%  3. FreshDataFlag  (see help getpv)
%  4. TimeOutPeriod  (see help getpv)
%  5. 'Struct' will return a data structure
%     'Numeric' will return a vector output {default}
%  6. 'Archive' will save a BPM data structure to \<DataRoot>\BPM\
%      with filename BPMz<Date><Time>.mat
%
%  OUTPUTS
%  1. AM = orbit vector or data structure
%  2. tout  (see help getpv)
%  3. DataTime
%  4. ErrorFlag  (see help getpv)
%
%  NOTE
%  1. 'Struct', 'Numeric', and 'Archive' are not case sensitive
%  2. All inputs are optional
%
%  EXAMPLE
%  1. <a href="matlab: plot(getspos(getvbpmfamily),getz); xlabel('BPM Position [meters]'); ylabel('Vertical Orbit');">plot(getz);</a>
%
%  See also getx, getbpm, getam, getpv

%
%  Written by Gregory J. Portmann

Family = 'BPMz'; %getvbpmfamily; % Too slow with generic name > 0.3 s


% Get input flags
StructOutputFlag = 0;
ArchiveFlag = 0;
for i = length(varargin):-1:1
    if isstr(varargin{i})
        if strcmpi(varargin{i},'struct')
            StructOutputFlag = 1;
            %varargin(i) = [];
        elseif strcmpi(varargin{i},'numeric')
            StructOutputFlag = 0;
            %varargin(i) = [];
        elseif strcmpi(varargin{i},'archive')
            ArchiveFlag = 1;
            varargin(i) = [];
        end
    end
end


% Get data
if isempty(varargin)
    [AM, tout, DataTime, ErrorFlag] = getpv(Family, 'Monitor');
elseif isstruct(varargin{1})
    [AM, tout, DataTime, ErrorFlag] = getpv(varargin{:});
else
    [AM, tout, DataTime, ErrorFlag] = getpv(Family, 'Monitor', varargin{:});
end

if StructOutputFlag
    % Structure output
    AM.CreatedBy = 'getz';
    AM.DataDescriptor = 'Vertical Orbit';
end


% Archive data structure
if ArchiveFlag
    DirStart = pwd;
    FileName = appendtimestamp([getfamilydata('Default', 'BPMArchiveFile') 'z'], clock);
    DirectoryName = getfamilydata('Directory','BPMData');
    if isempty(DirectoryName)
        DirectoryName = [getfamilydata('Directory','DataRoot') 'BPM\'];
    end
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    BPMyData = getz('struct');
    save(FileName, 'BPMyData');
    cd(DirStart);
end
