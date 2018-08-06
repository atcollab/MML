function btscycle(LatticeFile, DisplayFlag)
%BTSCYCLE - Standardize the BTS magnets
%
%  btscycle(Filename, DisplayFlag)
%
%  INPUTS
%  1. Filename - BTS file to cycle the setpoint to
%                '' to browse for a directory and file
%                If no input - cycle to the present lattice {Default}
%  2. 'Display' or 'NoDisplay' - to varify before standardizing and display results (or not)
%
%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parsing and checking %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DesiredFlag=0;       %do not cycle to Desired values
if nargin>0 & strcmpi(LatticeFile, 'Desired')
    DesiredFlag=1;   %cycle to Desired values
    DisplayFlag = 'Display';
end

if ~DesiredFlag
LatticeFileDefault = 'Present'; 
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
    [FileName, DirectoryName] = uigetfile('*.mat', 'Select a BTS Configuration File for Standardization', [getfamilydata('Directory', 'DataRoot'), 'BTS', filesep]);
    if FileName == 0
        if strcmpi(DisplayFlag, 'Display')
            fprintf('   BTS standardization cancelled\n');
        end
        return
    end
    try
        % Get BTSConfig structure from file
        load([DirectoryName FileName]);
    catch
        error(sprintf('Problem getting data from BTS configuration file\n%s',lasterr));
    end

    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to the lattice file %s\n', [DirectoryName FileName]);
    end
elseif strcmpi(LatticeFile, 'Present')
    % Present BTSsetpoints
    BTSConfig.Values.B7H = getpv('BTS-B7H:CurrSetpt');
    BTSConfig.Values.B8V = getpv('BTS-B8V:CurrSetpt');
    BTSConfig.Values.C8H = getpv('BTS-C8H:CurrSetpt');  BTSConfig.Values.C8H = BTSConfig.Values.C8H(1);
    BTSConfig.Values.B9V = getpv('BTS-B9V:CurrSetpt');
    BTSConfig.Values.Q8  = getpv('BTS-Q8:CurrSetpt');
    BTSConfig.Values.Q9  = getpv('BTS-Q9:CurrSetpt');

    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to the present BTS lattice\n');
    end
elseif ischar(LatticeFile)
    try
        % Get BTSConfig structure from file
        load(LatticeFile);
    catch
        error(sprintf('Problem getting data from BTS configuration file\n%s',lasterr));
    end
    Lattice = ConfigSetpoint;
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Standardizing to lattice file %s\n', LatticeFile);
    end
else
    error('Not sure what BTS lattice to cycle to!');    
end
    
end  %end ~DesiredFlag condition


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Query to begin standardization cycle %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(DisplayFlag, 'Display')
    tmp = questdlg('Begin BTS standardization?','BTSCYCLE','Yes','No','No');
    if strcmpi(tmp,'No')
        fprintf('   BTS standardization cancelled\n');
        return
    end
end


% Set the desired setpoint field
if ~DesiredFlag
setpv('BTS-B7H:CurrSetptDes', BTSConfig.Values.B7H);
setpv('BTS-B8V:CurrSetptDes', BTSConfig.Values.B8V);
setpv('BTS-C8H:CurrSetptDes', BTSConfig.Values.C8H);
setpv('BTS-B9V:CurrSetptDes', BTSConfig.Values.B9V);
setpv('BTS-Q8:CurrSetptDes',  BTSConfig.Values.Q8);
setpv('BTS-Q9:CurrSetptDes',  BTSConfig.Values.Q9);
end

if strcmpi(DisplayFlag, 'Display')
    fprintf('   Starting BTS magnet standardization .\n');
end

% Start the cycle
setpv('PS:BTSStandardizeSeq', 1);  % ok 1/31/05


