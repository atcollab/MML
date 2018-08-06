function plotlattice(varargin)
%PLOTLATTICE - Plot the lattice
%  plotlattice(FamilyName, FileName)
%  plotlattice(FamilyName, FileName)
%
%  KEY WORDS
%  1. 'Production' or 'Golden' - Golden lattice {Default}
%  2. 'Injection' - Injection lattice
%  3. 'Present'   - Present lattice 


%  3. 'Position'  - X-axis is the position along the ring {Default}
%  4. 'Phase'     - X-axis is the phase along the ring

% Written by Greg Portmann


XAxisFlag = 'Position';
XLabel = 'Position [meters]';

FamilyName = '';
FileName = '';
ConfigSetpoint = [];

% Input parsing
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Position')
        XAxisFlag = 'Position';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Phase')
        XAxisFlag = 'Phase';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Golden') || strcmpi(varargin{i},'Production')
        FileName = 'Production';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Present')
        FileName = 'Present';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Injection') || strcmpi(varargin{i},'Inj')
        FileName = 'Injection';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Offset')
        % Just remove
        varargin(i) = [];
    end
end

if length(varargin) >= 1
    if iscell(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif size(varargin{1},1) > 1 && ischar(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif isfamily(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif isstruct(varargin{1})
        ConfigSetpoint = varargin{1};
        varargin(1) = [];
    elseif ischar(varargin{1})
        FileName = varargin{1};
        varargin(1) = [];
    end
end
if length(varargin) >= 1
    if iscell(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif size(varargin{1},1) > 1 && ischar(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif isfamily(varargin{1})
        FamilyName = varargin{1};
        varargin(1) = [];
    elseif isstruct(varargin{1})
        ConfigSetpoint = varargin{1};
        varargin(1) = [];
    elseif ischar(varargin{1})
        FileName = varargin{1};
        varargin(1) = [];
    end
end

if isempty(ConfigSetpoint)
    try
        if isempty(FileName)
            % Default file
            %FileName = getfamilydata('Default', 'CNFArchiveFile');
            DirectoryName = getfamilydata('Directory', 'ConfigData');
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file to load', DirectoryName);
            if FileName == 0
                return
            end
            load([DirectoryName FileName]);
            FileName = [DirectoryName FileName];
            AskStartQuestion = 0;
        elseif strcmpi(FileName, '.')
            % Default 
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file to load');
            if FileName == 0
                return
            end
            load([DirectoryName FileName]);
            FileName = [DirectoryName FileName];
            AskStartQuestion = 0;
        elseif strcmpi(FileName, 'Production')
            % Get the production file name (full path)
            % AD.OpsData.LatticeFile could have the full path else default to AD.Directory.OpsData
            FileName = getfamilydata('OpsData','LatticeFile');
            [DirectoryName, FileName, Ext, VerNumber] = fileparts(FileName);
            if isempty(DirectoryName)
                DirectoryName = getfamilydata('Directory', 'OpsData');
            end
            FileName = fullfile(DirectoryName,[FileName, '.mat']);
            load(FileName);
        elseif strcmpi(FileName, 'Injection')
            % Get the injection file name (full path)
            % AD.OpsData.InjectionFile could have the full path else default to AD.Directory.OpsData
            FileName = getfamilydata('OpsData','InjectionFile');
            [DirectoryName, FileName, Ext, VerNumber] = fileparts(FileName);
            if isempty(DirectoryName)
                DirectoryName = getfamilydata('Directory', 'OpsData');
            end
            FileName = fullfile(DirectoryName,[FileName, '.mat']);
            load(FileName);
        elseif strcmpi(FileName, 'Present')
            [ConfigSetpoint, ConfigMonitor, FileName] = getmachineconfig;
        else
            % Input file name
            load(FileName);
        end
    catch
        fprintf('%s\n', lasterr)
        return
    end
end


L = getfamilydata('Circumference');

clf reset
if ~isempty(FamilyName)
    FamilyName = [FamilyName,'.Setpoint'];
    plot(getspos(ConfigSetpoint.(FamilyName)), ConfigSetpoint.(FamilyName).Data, '.-');
    xlabel(XLabel);
    ylabel(sprintf('%s [%s]',ConfigSetpoint.(FamilyName).FamilyName, ConfigSetpoint.(FamilyName).UnitsString));
else
    % Plot a bunch of typical families
    subplot(2,2,1);
    plot(getspos(ConfigSetpoint.HCM.Setpoint), ConfigSetpoint.HCM.Setpoint.Data, '.-');
    %xlabel(XLabel);
    ylabel(sprintf('%s [%s]',ConfigSetpoint.HCM.Setpoint.FamilyName, ConfigSetpoint.HCM.Setpoint.UnitsString));
    
    subplot(2,2,3);
    plot(getspos(ConfigSetpoint.VCM.Setpoint), ConfigSetpoint.VCM.Setpoint.Data, '.-');
    xlabel(XLabel);
    ylabel(sprintf('%s [%s]',ConfigSetpoint.VCM.Setpoint.FamilyName, ConfigSetpoint.VCM.Setpoint.UnitsString));
    
    subplot(2,2,2);
    plot(getspos(ConfigSetpoint.QF.Setpoint), ConfigSetpoint.QF.Setpoint.Data, '.-');
    %xlabel(XLabel);
    ylabel(sprintf('%s [%s]',ConfigSetpoint.QF.Setpoint.FamilyName, ConfigSetpoint.QF.Setpoint.UnitsString));
    
    subplot(2,2,4);
    plot(getspos(ConfigSetpoint.QD.Setpoint), ConfigSetpoint.QD.Setpoint.Data, '.-');
    xlabel(XLabel);
    ylabel(sprintf('%s [%s]',ConfigSetpoint.QD.Setpoint.FamilyName, ConfigSetpoint.QD.Setpoint.UnitsString));
end
xaxiss([0 L]);


addlabel(1, 0, ['Lattice saved on ', datestr(ConfigSetpoint.VCM.Setpoint.TimeStamp,0)]);

%addlabel(0, 0, sprintf(sprintf('RMS: Horizontal %6.3f %s  Vertical %6.3f %s', std(x.Data), x.UnitsString, std(y.Data), y.UnitsString)));
