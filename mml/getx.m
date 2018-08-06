function [AM, tout, DataTime, ErrorFlag] = getx(varargin)
%GETX - Returns the horizontal orbit
%  [AM, tout, DataTime]  = getx(DeviceList, t, FreshDataFlag, TimeOutPeriod)
%         or
%  [AM, tout, DataTime]  = getx(DataStructure, t, FreshDataFlag, TimeOutPeriod)
%
%  INPUTS
%  1. DeviceList or DataStructure  (see help getpv)
%  2. t  (see help getpv)
%  3. FreshDataFlag  (see help getpv)
%  4. TimeOutPeriod  (see help getpv)
%  5. 'Struct' will return a data structure
%     'Numeric' will return a vector output {default}
%  6. 'Archive' will save a BPM data structure to \<DataRoot>\BPM\
%      with filename BPMy<Date><Time>.mat
%
%  OUTPUTS
%  1. AM = orbit vector or data structure
%  2. tout  (see help getpv)
%  3. DataTime
%
%  NOTE
%  1. 'Struct', 'Numeric', and 'Archive' are not case sensitive
%  2. All inputs are optional
%
%  EXAMPLE
%  1. <a href="matlab: plot(getspos(gethbpmfamily),getx); xlabel('BPM Position [meters]'); ylabel('Horizontal Orbit');">plot(getx);</a>
%  2. An easy way to averaged 10 orbits is:
%     x = mean(getx([],0:.5:4.5)')';   % .5 second between measurements
%
%  See also gety, getz, getbpm, getam, getpv

%  Written by Greg Portmann


Family = gethbpmfamily;


% Get input flags
StructOutputFlag = 0;
ArchiveFlag = 0;
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        StructOutputFlag = 1;
    else
        if ischar(varargin{i})
            if strcmpi(varargin{i},'struct')
                StructOutputFlag = 1;
                varargin(i) = [];
            elseif strcmpi(varargin{i},'numeric')
                StructOutputFlag = 0;
                varargin(i) = [];
            elseif strcmpi(varargin{i},'archive')
                ArchiveFlag = 1;
                varargin(i) = [];
            end
        end
    end
end


% Get data
if isempty(varargin)
    [AM, tout, DataTime, ErrorFlag] = getpv(Family, 'Monitor', 'struct');
elseif isstruct(varargin{1})
    [AM, tout, DataTime, ErrorFlag] = getpv(varargin{:});
else
    [AM, tout, DataTime, ErrorFlag] = getpv(Family, 'Monitor', 'struct', varargin{:});
end

AM.CreatedBy = 'getx';
AM.DataDescriptor = 'Horizontal Orbit';

% Archive data structure
if ArchiveFlag
    DirStart = pwd;
    FileName = appendtimestamp([getfamilydata('Default', 'BPMArchiveFile') 'x'], clock);
    DirectoryName = getfamilydata('Directory','BPMData');
    if isempty(DirectoryName)
        DirectoryName = [getfamilydata('Directory','DataRoot'), 'BPM', filesep];
    end
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    BPMxData = AM;
    save(FileName, 'BPMxData');
    cd(DirStart);
end


if ~StructOutputFlag
    AM = AM.Data;
end

