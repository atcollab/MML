function srcycle(LatticeFile, DisplayFlag)
%SRCYCLE - Standardize the storage ring magnets to the golden lattice
%
%  INPUTS
%  1. LatticeFile - No input - cycle to the present lattice {Default}
%                  'Golden'  - cycle to the golden lattice
%                   LatticeFilename - cycle to the ConfigSetpoint in that file
%  2. 'Display' or 'NoDisplay' - to varify before standardizing and display results (or not)
%
%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parsing and checking %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LatticeFileDefault = 'Present';  % was 'Golden';
if nargin < 1
    LatticeFile = LatticeFileDefault;
end
if nargin < 2
    DisplayFlag = 'Display';
end
if strcmpi(LatticeFile, 'Display') | strcmpi(LatticeFile, 'NoDisplay')
    DisplayFlag = LatticeFile;
    LatticeFile = LatticeFileDefault;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the proper lattice %
%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(LatticeFile)
    [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat', 'Select a Machine Configuration File for Standardization', getfamilydata('Directory', 'DataRoot'));
    if FilterIndex == 0
        if strcmpi(DisplayFlag, 'Display')
            fprintf('   Storage ring standardization cancelled\n');
        end        
        return
    end
    try
        load([DirectoryName FileName]);
        Lattice = ConfigSetpoint;
    catch
        error(sprintf('Problem getting data from machine configuration file\n%s',lasterr));
    end
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to the lattice file %s\n', [DirectoryName FileName]);
    end        
elseif strcmpi(LatticeFile, 'Present')
    % Present lattice
    Lattice = getmachineconfig;
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to the present lattice\n');
    end
elseif strcmpi(LatticeFile, 'Golden')
    % Golden lattice
    FileName = getfamilydata('OpsData', 'LatticeFile');
    DirectoryName = getfamilydata('Directory', 'OpsData');
    load([DirectoryName FileName]);
    
    Lattice = ConfigSetpoint;
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to the golden lattice %s\n', [DirectoryName FileName]);
    end
elseif ischar(LatticeFile)
    load(LatticeFile);
    Lattice = ConfigSetpoint;
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to lattice file %s\n', LatticeFile);
    end
else
    error('Not sure what lattice to cycle to!');    
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Query to begin measurement %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(DisplayFlag, 'Display')
    tmp = questdlg('Begin storage ring standardization?','SRCYCLE','Yes','No','No');
    if strcmpi(tmp,'No')
        fprintf('   Lattice standardization cancelled\n');
        return
    end
end

% Number of cycles
N = 1;

% Set everything to zero
% famlist = {'BEND','QFA','QFB','QDA','SFA','SDA','SFB','SDB'};
% famlist = {'QDA','QFA','QFB'};
famlist = {'QDA'};

for i=1:length(famlist)
    range = getfamilydata(famlist{i},'Setpoint','Range');
    
    uppersetpoint.(famlist{i}) = Lattice.(famlist{i});
    switch uppersetpoint.(famlist{i}).Setpoint.Units
        case 'Physics'
            uppersetpoint.(famlist{i}).Setpoint.Data = hw2physics(famlist{i},'Setpoint',range(:,2),uppersetpoint.(famlist{i}).Setpoint.DeviceList);
        case 'Hardware'
            uppersetpoint.(famlist{i}).Setpoint.Data = range(:,2);
    end
    
    lowersetpoint.(famlist{i}) = Lattice.(famlist{i});
    switch lowersetpoint.(famlist{i}).Setpoint.Units
        case 'Physics'
            lowersetpoint.(famlist{i}).Setpoint.Data = hw2physics(famlist{i},'Setpoint',range(:,1),uppersetpoint.(famlist{i}).Setpoint.DeviceList);
        case 'Hardware'
            lowersetpoint.(famlist{i}).Setpoint.Data = range(:,1);
    end
    
    nominal.(famlist{i}) = Lattice.(famlist{i});
end

try
    % Wait flag of -1 will wait for the ramp to complete.
    for j=1:N
        if exist('lowersetpoint','var')
            disp('Turning ON all other multipoles');
            setmachineconfig(lowersetpoint, -1);
        end
        pause(10);

        if exist('lowersetpoint','var')
            disp('Turning OFF all other multipoles');
            setmachineconfig(uppersetpoint, -1);
        end
        pause(20);
    end

    if exist('nominal','var')
        setmachineconfig(nominal, -1);
    end
    
catch
    disp(lasterr)
    disp('Error');
    return
end

if strcmpi(DisplayFlag, 'Display')
    fprintf('   Storage ring standardization complete\n');
end