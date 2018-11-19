function [ATPATHDirectory, ATVersion] = gotoat(varargin)
%GOTOAT - cd to the AT Toolbox directory where atpath and atmexall is located
%  [ATPATHDirectory, ATVersion] = gotoat(ATROOT) 
%  [ATPATHDirectory, ATVersion] = gotoat(ATVersion)
%  [ATPATHDirectory, ATVersion] = gotoat
%
%  ATROOT is where atpath is found
%  ATVersion = 1.3, 1.4, or 2.0
%
% See also setpathat setpathmml


ATPATHDirectory = '';
ATVersion = [];
ATVersionDefault = 1.3;

while length(varargin) > 0
    if isstruct(varargin{1}) || iscell(varargin{1})
        % Ignor structures
    elseif isnumeric(varargin{1})
        ATVersion = varargin{1};
    else
        ATPATHDirectory = varargin{1};
    end
    varargin(1) = [];
end

ATPATHDirectory = getenv('ATROOT');

if isempty(ATPATHDirectory)
    % Determine RootDir by the version number
    MatlabVersion = ver('Matlab');
    MatlabVersion = str2num(MatlabVersion.Version);
    
    if isempty(ATVersion)
        if MatlabVersion >= 9.3  % 2017b (not sure about 2017a or 2016b)
            if ismac || ispc  % Not linking properly on Linux yet!!!
                ATVersion = 2.0;
            else
                ATVersion = ATVersionDefault;
            end
        else
            ATVersion = ATVersionDefault;
        end
    end
    
    [DirectoryName, FileName, ExtentionName] = fileparts(which('getpv'));
    i = findstr(DirectoryName,filesep);
    SimulatorROOT = [DirectoryName(1:i(end)),'simulators',filesep];
    
    if ATVersion == 2.0
        ATPATHDirectory = [SimulatorROOT, 'at2.0', filesep, 'atmat', filesep];
    elseif ATVersion == 1.4
        %ATPATHDirectory = [SimulatorROOT, 'at1.4', filesep, 'atmat', filesep];
        ATPATHDirectory = [SimulatorROOT, 'at1.4.1', filesep, 'atmat', filesep];
    elseif ATVersion == 1.3
        if MatlabVersion >= 9.3
            ATPATHDirectory = [SimulatorROOT, 'at1.3mod', filesep];
        else
            ATPATHDirectory = [SimulatorROOT, 'at1.3', filesep];
        end
    end
end

cd(ATPATHDirectory);

