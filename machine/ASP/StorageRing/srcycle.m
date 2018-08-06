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


disp('!!!  Do not use yet  !!!');


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
famlist = {};

for i=1:length(famlist)
    range = getfamilydata(famlist{i},'Setpoint','Range');
    
    uppersetpoint.(famlist{i}) = Lattice.(famlist{i});
    uppersetpoint.(famlist{i}).Setpoint.Data = range(:,2);
    
    lowersetpoint.(famlist{i}) = Lattice.(famlist{i});
    lowersetpoint.(famlist{i}).Setpoint.Data(:) = range(:,1);
    
    nominal.(famlist{i}) = Lattice.(famlist{i});
end

% Different for BEND, need to set to upper limit and turn on and off
% the supply to cycle the magent. Will have to montior the readback to
% see if it has reached the maximum and if its turned completely off.

% Dipole on off command handle
dipole_handle = mcaopen('SR00DPS01:OFF_ON_CMD');

% Nominal
dipole_nomsp = Lattice.BEND.Setpoint.Data(1,1);

% Get dipole upper setpoint
temp = getfamilydata('BEND','Setpoint','Range',[1 1]);
dipole_uppersp = temp(2);

try
    % Turn off the dipole and check its off.
    dipolewaitoff(dipole_handle);

    % Wait flag of -1 will wait for the ramp to complete.
    for j=1:N
        disp('Turning ON dipole');
        dipoleturnon(dipole_handle, dipole_uppersp);
        if exist('lowersetpoint','var')
            disp('Turning ON all other multipoles');
            setmachineconfig(lowersetpoint, -1);
        end
        pause(1);

        disp('Turning OFF dipole');
        dipolewaitoff(dipole_handle);
        if exist('lowersetpoint','var')
            disp('Turning OFF all other multipoles');
            setmachineconfig(uppersetpoint, -1);
        end
        pause(1);
    end


    % Make sure all the setpoints are there
    dipoleturnon(dipole_handle, dipole_nomsp);
    if exist('nominal','var')
        setmachineconfig(nominal, -1);
    end
    
catch
    disp(lasterr)
    disp('Error');
    mcaclose(dipole_handle);
    return
end

mcaclose(dipole_handle);

if strcmpi(DisplayFlag, 'Display')
    fprintf('   Storage ring standardization complete\n');
end



function dipolewaitoff(dipole_handle)
% Two step process go to 50 amps first then wait before going to 0.1 amps.
DEBUG = 1;

% Generate normalised curve with 101 points
% curve =[ 0.0000000  0.0004501  0.0009766  0.0015905  0.0023039 ...
%  0.0031305  0.0040851  0.0051840  0.0064449  0.0078871 ...
%  0.0095315  0.0114004  0.0135176  0.0159085  0.0185999 ...
%  0.0216197  0.0249973  0.0287631  0.0329482  0.0375843 ...
%  0.0427039  0.0483391  0.0545222  0.0612847  0.0686573 ...
%  0.0766694  0.0853485  0.0947203  0.1048077  0.1156307 ...
%  0.1272057  0.1395455  0.1526587  0.1665491  0.1812159 ...
%  0.1966530  0.2128489  0.2297867  0.2474438  0.2657919 ...
%  0.2847972  0.3044203  0.3246166  0.3453365  0.3665256 ...
%  0.3881254  0.4100734  0.4323042  0.4547493  0.4773384 ...
%  0.5000000  0.5226616  0.5452507  0.5676958  0.5899266 ...
%  0.6118746  0.6334744  0.6546635  0.6753834  0.6955797 ...
%  0.7152028  0.7342081  0.7525562  0.7702133  0.7871511 ...
%  0.8033470  0.8187841  0.8334509  0.8473413  0.8604545 ...
%  0.8727943  0.8843693  0.8951923  0.9052797  0.9146515 ...
%  0.9233306  0.9313427  0.9387153  0.9454778  0.9516609 ...
%  0.9572961  0.9624157  0.9670518  0.9712369  0.9750027 ...
%  0.9783803  0.9814001  0.9840915  0.9864824  0.9885996 ...
%  0.9904685  0.9921129  0.9935551  0.9948160  0.9959149 ...
%  0.9968695  0.9976961  0.9984095  0.9990234  0.9995499  1.0000000];
x = 0:0.01:1; 
curve = (erf(3*x-1.5)/max(abs(erf(3*x-1.5))) + 1)./2;
offcurve = curve(end:-1:1);

% Current dipvalue
dipval = getam('BEND',[1,1]);
% Dipole PS tolerance
tol = 0.2; %getfamilydata('BEND','Setpoint','Tolerance',[1 1]);

if DEBUG; saveval = []; end

setvals = offcurve.*dipval;
j = 1; j_previous = 1;
for i=1:length(setvals)
    setsp('BEND',setvals(i),[1,1]);
    
    % 10 Second limit
    while abs(dipval - setvals(i)) > tol && j < j_previous + 20
        pause(0.5);
        dipval = getam('BEND',[1,1]);

        if DEBUG; saveval(j) = dipval; end

        j = j + 1;
%         if j > 21 && std(saveval(end-20)) < 0.0
%             if DEBUG; figure; plot(saveval); end;
%             error('Dipole didn'' seem to reach desired current!');
%         end
    end
    j_previous = j;
end
% Additional wait of 2 seconds to wait till current regulates to final
% value.
pause(2);

if DEBUG; figure; plot(saveval); end;



function dipoleturnon(dipole_handle, val)
DEBUG = 1;

x = 0:0.01:1; 
curve = (erf(3*x-1.5)/max(abs(erf(3*x-1.5))) + 1)./2;

tol = 0.3; %getfamilydata('BEND','Setpoint','Tolerance',[1,1]);
dipval = getam('BEND',[1,1]);

if DEBUG; saveval = []; end

setvals = curve.*val;
temp = find(setvals > dipval);
starti = (1);


j = 1; j_previous = 1;
for i=starti:length(setvals)
    setsp('BEND',setvals(i),[1,1]);
    
    while abs(dipval - setvals(i)) > tol && j < j_previous+20
        pause(0.5);
        dipval = getam('BEND',[1,1]);

        if DEBUG; saveval(j) = dipval; end

        j = j + 1;
%         if j > 20 && std(saveval(end-20)) < 0.0
%             if DEBUG; figure; plot(saveval); end;
%             error('Dipole didn'' seem to reach desired current!');
%         end
    end
    j_previous = j;
end
% Additional wait of 2 seconds to wait till current regulates to final
% value.
pause(2);

if DEBUG; figure; plot(saveval); end;