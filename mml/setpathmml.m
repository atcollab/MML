function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(varargin)
%SETPATHMML -  Initialize the Matlab MiddleLayer (MML) path
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT]  = setpathmml(MachineName, SubMachineName, MachineType, OnlineLinkMethod, MMLROOT)
%
%  INPUTS
%  1. MachineName -
%  2. SubMachineName -
%  3. MachineType - 'StorageRing' {Default}, 'Booster', 'Linac', or 'Transport'
%  4. OnlineLinkMethod - 'LabCA', 'SCA', 'MCA', 'Tango', 'SLC', 'UCODE', ... {Default: 'LabCA'}
%  5. MMLROOT - Directory path to the MML root directory

%  Written by Greg Portmann
%  Updated by Igor Pinayev


% Inputs:  MachineName, SubMachineName, MachineType, LinkFlag, MMLROOT


% First strip-out the link method
LinkFlag = '';
for i = length(varargin):-1:1
    if ~ischar(varargin{i})
        % Ignor input
    elseif strcmpi(varargin{i},'LabCA')
        LinkFlag = 'LabCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'MCA')
        LinkFlag = 'MCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'MCA_ASP')
        LinkFlag = 'MCA_ASP';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'MCA_ORIGINAL')
        LinkFlag = 'MCA_ASP';  % Use ASP
        varargin(i) = [];
    elseif strcmpi(varargin{i},'SCA')
        LinkFlag = 'SCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'TLS_CTL')
        LinkFlag = 'TLS_CTL';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'OPC')
        LinkFlag = 'OPC';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'SLC')
        LinkFlag = 'SLC';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Tango')
        LinkFlag = 'Tango';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'lnls1_link')
        LinkFlag = 'lnls1_link';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'sirius_link')
        LinkFlag = 'sirius_link';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'UCODE')
        LinkFlag = 'UCODE';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'UMER_WS')
        LinkFlag = 'UMER_WS';
        varargin(i) = [];
    end
end


% Get the machine name
if length(varargin) >= 1
    MachineName = varargin{1};
else
    MachineName = '';
end

if isempty(MachineName)
    [MachineListCell, SubMachineListCell] = getmachinelist;
    [i, iok] = listdlg('Name','SETPATHMML', 'ListString',MachineListCell, 'Name','MML Init', 'PromptString',{'Select a facility:'}, 'SelectionMode','Single');
    %[MachineNameCell, i] = editlist(MachineListCell,'',zeros(size(MachineListCell,1),1));
    drawnow;
    if iok
        MachineName = MachineListCell{i};
    else
        fprintf('   No path change.\n');
        MachineName=''; SubMachineName=''; LinkFlag=''; MMLROOT='';
        return;
    end
else
    SubMachineListCell = {};
end


% Get the submachine name
if length(varargin) >= 2
    SubMachineName = varargin{2};
else
    SubMachineName = '';
end
if isempty(SubMachineName)
    if isempty(SubMachineListCell)
        [MachineListCell, SubMachineListCell] = getmachinelist;
    end
    i = strmatch(MachineName, MachineListCell, 'exact');
    SubMachineListCell = SubMachineListCell{i}(:);
    
    if length(SubMachineListCell) == 1
        SubMachineName = SubMachineListCell{1};
    else
        [i, iok] = listdlg('Name','SETPATHMML', 'ListString',SubMachineListCell, 'Name','MML Init', 'PromptString',{'Select an accelerator:'}, 'SelectionMode','Single');
        drawnow;
        if iok
            SubMachineName = SubMachineListCell{i};
        else
            fprintf('   No path change.\n');
            MachineName=''; SubMachineName=''; LinkFlag=''; MMLROOT='';
            return;
        end
    end
end


% Find the machine type
if length(varargin) >= 3
    MachineType = varargin{3};
else
    MachineType = '';
end
if isempty(MachineType)
    switch upper(SubMachineName)
        case {'LTB', 'LB', 'BTS', 'BS', 'LT1', 'LT2', 'INJECTOR', 'LINAC', 'GUN', 'PTB'}
            MachineType = 'Transport';
        case {'BOOSTER', 'BOOSTER RING', 'BR'}
            MachineType = 'Booster';
        case {'SR', 'STORAGERING', 'STORAGE RING', 'HER', 'LER', '800MEV'}
            MachineType = 'StorageRing';
        otherwise
            MachineType = 'StorageRing';
    end
end


%if all(strcmpi(MachineType, {'StorageRing','Booster','Linac','Transport'}) == 0)
%    error('MachineType must be storagering, booster, linac, or transport.');
%end

MatlabVersion = ver('Matlab');
MatlabVersion = str2num(MatlabVersion.Version);
%if MatlabVersion >= 7.4
%if strncmp(computer,'PC',2)
%if strncmp(computer,'GLNX',4)

% LinkFlag if empty
if isempty(LinkFlag)
    switch upper(MachineName)
        case 'ALS'
            LinkFlag = 'LABCA';
        case {'ASP','TPS','SPEAR','SPEAR3','SSRF','SESAME'}
            LinkFlag = 'LABCA';
        case {''}
            LinkFlag = 'LABCA';
        case 'ASTRID2'
            LinkFlag = 'ConSys';
        case {'PLS'}
            LinkFlag = 'MCA_ASP';
        case 'TLS'
            LinkFlag = 'TLS_CTL';
        case 'BFACTORY'
            LinkFlag = 'SLC';
        case 'LCLS'
            LinkFlag = 'LABCA';
        %case {'LNLS1','LNLS2'}
        %    LinkFlag = 'lnlslink';
        case 'LNLS1'
            LinkFlag = 'lnls1_link';
        case 'SIRIUS'
            LinkFlag = 'sirius_link';
        case {'NSRC','SPS'}
            LinkFlag = 'OPC';
        case {'UMER'}
            LinkFlag = 'UMER_WS';
        case {'VUV','XRAY'}
            LinkFlag = 'UCODE';
        case {'ALBA','SOLEIL', 'ELETTRA','SOLARIS','MAXIV'}
            LinkFlag = 'Tango';
        otherwise
            % Other
            LinkFlag = 'LABCA';
    end
end


% Find the MML root directory
if length(varargin) >= 4
    MMLROOT = varargin{4};
else
    MMLROOT = '';
end
if isempty(MMLROOT)
    MMLROOT = getmmlroot('IgnoreTheAD');
end


% The path does not needs to be set in Standalone mode
if ~isdeployed_local
    
    % Jeff's orbit GUI
    if any(strcmpi(MachineName,{'Spear3','cls','diamond','asp','alba','camd'}))
        %addpath(fullfile(MMLROOT, 'applications', 'orbit'), '-begin');
        addpath(fullfile(MMLROOT, 'applications', 'orbit', 'lib'), '-begin');
        addpath(fullfile(MMLROOT, 'applications', 'orbit', lower(MachineName)), '-begin');
    end
    
    % Just for Spear3
    if any(strcmpi(MachineName,{'Spear3'}))
        addpath(fullfile(MMLROOT, 'machine', MachineName, 'Applications', 'lattices', 'spear3'), '-begin');
        addpath(fullfile(MMLROOT, 'machine', MachineName, 'Applications', 'configurations'), '-begin');
        addpath(fullfile(MMLROOT, 'machine', MachineName, 'Applications', 'plotwaveform'), '-begin');
        addpath(fullfile(MMLROOT, 'machine', MachineName, 'Applications', 'sofb'), '-begin');
    end
    
    % N A F F (files not distributed with MML)
    Directory = fullfile(MMLROOT, 'applications', 'naff');
    if exist(Directory, 'dir')
        addpath(fullfile(MMLROOT, 'applications', 'naff'), '-begin');
    end
    
    % m2html generation program
    %addpath(fullfile(MMLROOT, 'applications', 'm2html'), '-end');

    % MySQL
    %addpath(fullfile(MMLROOT, 'applications', 'database', 'mysql'), '-end');
    %addpath(fullfile(MMLROOT, 'applications', 'database', 'mym'), '-end');

    % XML
    %addpath(fullfile(MMLROOT, 'applications', 'xml', 'geodise'), '-end');
    %addpath(fullfile(MMLROOT, 'applications', 'xml', 'xmltree'), '-end');

    if strcmpi(LinkFlag,'LABCA')
        % EPICS uses might want to use the EDM conversion functions
        addpath(fullfile(MMLROOT, 'applications', 'EDM'), '-begin');
    end
    
    % AT path
    setpathat;    
%     if MatlabVersion >= 9.3  % 2017b (not sure about 2017a)
%         if ismac || ispc  % Not linking properly on Linux yet!!!
%             % AT2.0
%             DirectoryName = fullfile(MMLROOT,'simulators','at2.0');
%             olddir = pwd;
%             cd(DirectoryName);
%             cd atmat
%             atpath(DirectoryName);
%             cd(olddir);
%             fprintf('   Using AT 2.0\n');
%         else
%             % AT 1.3 (used at ALS for many years)
%             setpathat(fullfile(MMLROOT,'simulators','at1.3mod'));
%             fprintf('   Using AT 1.3 (with small changes for Matlab2017b)\n');
%         end
%     else
%         % AT 1.3 (used at ALS for many years)
%         setpathat(fullfile(MMLROOT,'simulators','at1.3'));
%         fprintf('   Using AT 1.3\n');
%     end
    
    % Connection MML to simulator
    addpath(fullfile(MMLROOT, 'mml','simulators', 'at'), '-begin');


    % LOCO
    addpath(fullfile(MMLROOT, 'applications', 'loco'), '-begin');

    % Link method
    switch upper(LinkFlag)
        case 'MCA'
            % R3.14.4 and Andrei's MCA
            fprintf('   Appending MATLAB path control using MCA and EPICS R3.13.4\n');
            %addpath(fullfile(MMLROOT, 'online', 'mca', 'mca_original'), '-begin');            
            addpath(fullfile(MMLROOT, 'online', 'mca', 'mca_sns', 'matlab'), '-begin');            
            addpath(fullfile(MMLROOT, 'mml', 'online', 'mca'), '-begin');

        case 'MCA_ASP'
            % R3.14.4 and Australian MCA
            fprintf('   Appending MATLAB path control using MCA (Australian)\n');
            addpath(fullfile(MMLROOT, 'online', 'mca', 'mca_asp'), '-begin');            
            addpath(fullfile(MMLROOT, 'mml', 'online', 'mca'), '-begin');
            
        case 'LABCA'
            fprintf('   Appending MATLAB path control using LabCA \n');
            switch computer
                case 'PCWIN'
                    %if MatlabVersion >= 9.3  % 2017b
                    %    addpath(fullfile(MMLROOT,'online','labca_3_5', 'bin','win32','labca'), '-begin');
                    %else
                        addpath(fullfile(MMLROOT,'online','labca', 'bin','win32','labca'), '-begin');
                    %end
                case 'PCWIN64'
                    if MatlabVersion >= 9.3  % 2017b
                        addpath(fullfile(MMLROOT,'online','labca3_5', 'bin','windows-x64','labca'), '-begin');
                    else
                        addpath(fullfile(MMLROOT,'online','labca', 'bin','win64','labca'), '-begin');
                    end
                case 'SOL2'
                    addpath(fullfile(MMLROOT,'online','labca', 'bin','solaris-sparc','labca'), '-begin');
                case 'SOL64'
                    addpath(fullfile(MMLROOT,'online','labca', 'bin','solaris-sparc64','labca'), '-begin');
                case 'GLNX86'
                    %if MatlabVersion >= 9.3  % 2017b
                    %    addpath(fullfile(MMLROOT,'online','labca3_5', 'bin','linux-x86','labca'), '-begin');
                    %else
                        addpath(fullfile(MMLROOT,'online','labca', 'bin','linux-x86','labca'), '-begin');
                    %end
                case 'GLNXA64'
                    %if MatlabVersion >= 9.3  % 2017b
                    %    addpath(fullfile(MMLROOT,'online','labca3_5', 'bin','linux-x86_64','labca'), '-begin');
                    %else
                        addpath(fullfile(MMLROOT,'online','labca', 'bin','linux-x86_64','labca'), '-begin');
                    %end
                otherwise
                    fprintf('   LabCA not compiled yet for %s computer (hence model only).\n', computer);
            end

            addpath(fullfile(MMLROOT,'mml', 'online', 'labca'), '-begin');

        case 'SCA'
            fprintf('   Appending MATLAB path control using Simple-CA Version 3\n');
            switch computer
                case 'PCWIN'
                    fprintf('\n   WARNING:  SCAIII is not working with PC''s yet\n\n');
                    addpath(fullfile(MMLROOT,'online','sca', 'bin','win32-x86','sca'), '-begin');
                case 'SOL2'
                    addpath(fullfile(MMLROOT,'online','sca', 'bin','solaris-sparc','sca'), '-begin');
                case 'SOL64'
                    addpath(fullfile(MMLROOT,'online','sca', 'bin','solaris-sparc64','sca'), '-begin');
                case 'GLNX86'
                    addpath(fullfile(MMLROOT,'online','sca', 'bin','linux-x86','sca'), '-begin');
                case 'GLNXA64'
                    addpath(fullfile(MMLROOT,'online','sca', 'bin','linux-x86_64','sca'), '-begin');
                otherwise
                    fprintf('   Computer not recognized for SCA path.\n');
            end
            addpath(fullfile(MMLROOT, 'mml', 'online', 'sca'), '-begin');

        case 'TANGO'
            fprintf('   Appending MATLAB path control using Tango\n');
            addpath(fullfile(MMLROOT,'online','tango'), '-begin');
            addpath(fullfile(MMLROOT, 'mml', 'online', 'tango'), '-begin');

        case 'TLS_CTL'
            fprintf('   Appending MATLAB path for TLS control\n');
            %addpath(fullfile(MMLROOT,'online','tls_ctl'), '-begin');
            addpath(fullfile(MMLROOT, 'mml', 'online', 'tls_ctl'), '-begin');
        
        case 'UCODE'
            fprintf('   Appending MATLAB path control using UCODE \n');
            %addpath(fullfile(MMLROOT,'online','ucode'), '-begin');
            addpath(fullfile(MMLROOT,'mml','online','ucode'), '-begin');

        case 'SLC'
            fprintf('   Appending MATLAB path for SLC control \n');
            addpath(fullfile(MMLROOT,'online','slc'), '-begin');
            addpath(fullfile(MMLROOT,'mml', 'online', 'slc'), '-begin');

        case 'LNLSLINK'
            fprintf('   Appending MATLAB path for LNLS1Link control \n');
            %addpath(fullfile(MMLROOT,'online','lnlslink','lnls_meas'), '-begin');
            addpath(fullfile(MMLROOT,'online','lnlslink','lnls_comm'), '-begin');
            %addpath(fullfile(MMLROOT,'online','lnlslink','lnls_cmd'), '-begin');
            addpath(fullfile(MMLROOT,'mml', 'online', 'lnlslink'), '-begin');
            
        case 'LNLS1_LINK'
            fprintf('   Appending MATLAB path for lnls1_link control \n');
            addpath(fullfile(MMLROOT,'online','lnls','lnls1'), '-begin');
            addpath(fullfile(MMLROOT,'mml', 'online', 'lnls','lnls1'), '-begin');
            
        case 'SIRIUS_LINK'
            fprintf('   Appending MATLAB path for sirius_link control \n');
            addpath(fullfile(MMLROOT,'online','lnls','sirius'), '-begin');
            addpath(fullfile(MMLROOT,'mml', 'online', 'lnls','sirius'), '-begin');
            
        case 'OPC'
            fprintf('   Appending MATLAB path for OPC control \n');
            addpath(fullfile(MMLROOT,'online','opc'), '-begin');
            addpath(fullfile(MMLROOT,'mml', 'online', 'opc'), '-begin');

        case 'CONSYS'
            fprintf('   Appending MATLAB path for ConSys control \n');
            addpath(fullfile(MMLROOT,'online','consys'), '-begin');
            addpath(fullfile(MMLROOT,'mml', 'online', 'consys'), '-begin');

        case 'UMER_WS'
            fprintf('   Appending MATLAB path for the University of Maryland control system.\n');
            addpath(fullfile(MMLROOT,'online','umer_ws'), '-begin');
            addpath(fullfile(MMLROOT,'mml', 'online', 'umer_ws'), '-begin');

        otherwise
            fprintf('   Unknown type for the Online connection method.  Only simulator mode will work.\n');
    end


    % Common files
    addpath(fullfile(MMLROOT, 'applications', 'common'), '-begin');

    % MML path
    addpath(fullfile(MMLROOT, 'mml'), '-begin');

    % Machine directory
    if ~isempty(MachineName) && ~isempty(SubMachineName)
        % Sometimes there is a common directory that all submachines share
        Directory = fullfile(MMLROOT, 'machine', MachineName, 'Common');
        if exist(Directory, 'dir')
            addpath(Directory, '-begin');
        end
        Directory = fullfile(MMLROOT, 'machine', MachineName, 'common');
        if exist(Directory, 'dir')
            addpath(Directory, '-begin');
        end
        
        % New MML path
        addpath(fullfile(MMLROOT, 'machine', MachineName, SubMachineName), '-begin');
    end
end


% Start the AD with machine and submachine
setad([]);
AD.Machine = MachineName;
AD.SubMachine = SubMachineName;
AD.MachineType = MachineType;
AD.OperationalMode = '';    % Gets filled in later
setad(AD);


% Initialize the AO & AD
aoinit(SubMachineName);


function RunTimeFlag = isdeployed_local
% isdeployed is not in matlab 6.5
V = version;
if str2num(V(1,1)) < 7
    RunTimeFlag = 0;
else
    RunTimeFlag = isdeployed;
end
