function setpathalslabca(ROOTDir)

%if nargin == 0
%    [DirectoryName, FileName, ExtentionName] = fileparts(mfilename('fullpath'));
%    %[DirectoryName, FileName, ExtentionName] = fileparts(which('getsp'));
%    i = findstr(DirectoryName,filesep);
%    if isempty(i)
%       ROOTDir = DirectoryName; 
%    else
%       ROOTDir = DirectoryName(1:i(end));
%    end
%end


disp('   Appending MATLAB path for ALS control using LabCA ...');


% AT path
setpathat;

%addpath(fullfile(ROOTDir,'applications','bumps'),'-begin');
%addpath(fullfile(ROOTDir,'applications','bumps','als'),'-begin');
%addpath(fullfile(ROOTDir,'applications','orbit'),'-begin');
%addpath(fullfile(ROOTDir,'applications','common'),'-begin');
addpath(fullfile(ROOTDir,'loco'),'-begin');
%addpath(fullfile(ROOTDir,'applications','lattices','als'),'-begin');
%addpath(fullfile(ROOTDir,'applications','history'),'-begin');

if strcmpi(computer,'PCWIN') == 1
    addpath(fullfile(ROOTDir,'labca', 'bin','win32-x86','labca'),'-begin');
elseif strcmpi(computer,'sol2') == 1
    addpath(fullfile(ROOTDir,'labca', 'bin','solaris-sparc-gnu','labca'),'-begin');
elseif strcmpi(computer,'GLNX86') == 1
    addpath(fullfile(ROOTDir,'labca', 'bin','linux-x86','labca'),'-begin');
else
    error('Computer not recognized');
end


addpath(fullfile(ROOTDir,'acceleratorcontrol','at'),'-begin');
addpath(fullfile(ROOTDir,'acceleratorcontrol'),'-begin');
addpath(fullfile(ROOTDir,'acceleratorcontrol','machine','als'),'-begin');
addpath(fullfile(ROOTDir,'acceleratorcontrol','machine','als', 'legacyfiles'),'-begin');
addpath(fullfile(ROOTDir,'acceleratorcontrol', 'labca'),'-begin');


alsinit;


try
    %     if strcmpi(computer,'PCWIN') == 1
    %         % cd to N:\matlab2004\labca\bin\win32-x86\labca to make LabCA work
    %         %  I'm not sure why this needs to be done
    %         cd N:\matlab2004\labca\bin\win32-x86\labca
    %         
    %         pause(2);
    %     end

    % read dummy pv to initialize labca
%    lcaGet('SR10C___BPM1_X_AM00');
    
    % Default RetryCount = 599;
    %lcaGetRetryCount
%    lcaSetRetryCount(400)
    
    % Default Timeout = .05;
    %lcaGetTimeout
%    lcaSetTimeout(.05);
catch
    fprintf('   LabCA RetryCount and Timeout not set\n');
end


