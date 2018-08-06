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
N = 2;

% Set everything to zero
% famlist = {'BEND','QFA','QFB','QDA','SFA','SDA','SFB','SDB'};
% famlist = {'QDA','QFA','QFB'};
famlist = {'QDA','QFA', 'QFB','SFA','SDA','SFB','SDB'};

for i=1:length(famlist)
    range = getfamilydata(famlist{i},'Setpoint','Range',getlist(famlist{i}));
    
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
            disp('Setting lower setpoint');
            if local_setmachineconfig(lowersetpoint, 25)
                % error occured
                break; 
            end
        end
        pause(5);

        if exist('lowersetpoint','var')
            disp('Setting upper setpoint');
            if local_setmachineconfig(uppersetpoint, 40)
                % error occured
                break;
            end
        end
        pause(5);
    end

    if exist('nominal','var')
        disp('Setting NOMINAL');
        local_setmachineconfig(nominal, 5);
    end
    
catch
    disp(lasterr)
    disp('Error');
    return
end

if strcmpi(DisplayFlag, 'Display')
    fprintf('   Storage ring standardization complete\n');
end



function err = local_setmachineconfig(config, varargin)

err = 0;
WaitFlag = 0;
Time = 10; % Default of 10 seconds to achieve goal
N = 2;

if nargin > 1
    Time = varargin{1};
end

if nargin > 2
    WaitFlag = varargin{2};
end


families = fieldnames(config)';

for i=1:length(families)
    units = config.(families{i}).Setpoint.Units;
    
    % getcurrent values Assuming setpoint available
    if isfield(config.(families{i}),'Setpoint')
        devicelists{1,i} = config.(families{i}).Setpoint.DeviceList;
        
        curr = getpv(config.(families{i}).Setpoint);
        delta = config.(families{i}).Setpoint.Data - curr.Data;
        for j=1:N
            data(j).newvals{1,i} = curr.Data + delta.*(j/N);
        end
    else
        fprintf('Warning: No setpoint field found for family %s\n',families{i});
        return;
    end  
end

for j=1:N
    try
        setpv(families,'Setpoint',data(j).newvals,devicelists,units,-1);
    catch
        disp(lasterr);
        disp('Will try again...');
        try 
            % Wait some time before trying again.
            pause(10);
            setpv(families,'Setpoint',data(j).newvals,devicelists,units,-1);
            disp('... successful second attempt');
        catch
            disp(lasterr);
            disp('Still did not work... maybe something wrong. Will put setpoints back to initial values.');
            err = 1;
        end
    end
end

pause(0);