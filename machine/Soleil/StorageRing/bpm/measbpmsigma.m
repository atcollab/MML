function varargout = measbpmsigma(varargin)
%MEASBPMSIGMA - Measures the standard deviation of the BPMs
%  [BPMxSTD, BPMzSTD, BPMx, BPMz, tout, DCCT, FileName] = measbpmsigma(t, BPMxFamily, BPMxList, BPMzFamily, BPMzList, FileName)
%  [BPMxSTD, BPMzSTD, FileName] = measbpmsigma(... , 'Struct')
%
%  INPUTS
%  1. t = time vector [seconds], or
%         length of time in seconds to measure data (scalar) 
%         {default: 3 minute at a sample rate of 2 Hz}
%  2 and 4. BPMxFamily and BPMzFamily are the family names of the BPM's, {default or []: the entire list}
%  3 and 5. BPMxList and BPMzList are the device list of BPM's, {default or []: the entire list}
%  6. 'Struct'  will return data structures instead of vectors
%     'Numeric' will return vector outputs {default}
%  7.  FileName = Filename (including directory) where the data was saved (if applicable)
%  8. 'Archive'   - save a data array structure to \<BPMData Directory>\<BPMSigmaFile><Date><Time>.mat {Default}
%     'NoArchive' - no data will be saved to file
%
%  OUTPUTS
%  For numeric output:
%  1-2. BPMxSTD and BPMzSTD are standard deviation of the difference orbits
%  3-4. BPMx and BPMz are the raw orbit data matrices 
%  5. DCCT is a row vector containing the beam current
%  6. tout is a row vector of times as returned by getam           
%  7. FileName = Filename (including directory) where the data was saved (if applicable)
%
%  For structures:
%  1-2. BPMxSTD and BPMzSTD - the standard deviations are put the Data field and the 
%     BPMx and BPMz data are put in the RawData field.
%  3. FileName = Filename (including directory) where the data was saved (if applicable)
%
%  NOTE
%  1. All inputs are optional.  All of the following have the same output:  
%        measbpmsigma(0:.5:180);
%        measbpmsigma(0:.5:180, 'BPMx');
%        measbpmsigma('BPMx');
%        measbpmsigma('BPMx', 'BPMz');
%        measbpmsigma('BPMx', [], 'BPMz');
%  2. To make the measured sigma the default:
%     First divide by the sqrt(BPMxSigma.NumberOfAverages)
%     BPMxSigma.Data = BPMxSigma.Data / BPMxSigma.NumberOfAverages;
%     BPMzSigma.Data = BPMzSigma.Data / BPMzSigma.NumberOfAverages;
%     [BPMxSigma, BPMzSigma] = measbpmsigma('Struct');
%     setphysdata(BPMxSigma,'Sigma');
%     setphysdata(BPMzSigma,'Sigma');
%  3. Use getsigma to get the default values

%
% Written by Gregory J. Portmann
% Modified by Laurent S. Nadolski

% Defaults
BPMxFamily = 'BPMx';
BPMzFamily = 'BPMz';
BPMxList = [];   
BPMzList = [];   
T = 3*60; %total monitoring time
Tsample = .5; % 2Hz by default
t = []; % t= 0:Tsample:T
FileName = []; %Filename for archiving
ArchiveFlag = 1; %Archive by default
StructOutputFlag = 0;
OutputFileName = '';
Navg = getbpmaverages; % number of averages

% Look if 'struct' or 'numeric' in on the input line
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Struct')
        StructOutputFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Numeric')
        StructOutputFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Archive')
        ArchiveFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoArchive')
        ArchiveFlag = 0;
        varargin(i) = [];
    end
end

% t input
if length(varargin) >= 1
    if isnumeric(varargin{1})
        t = varargin{1};
        varargin(1) = [];
    end
end

% Look for BPMx family info
if length(varargin) >= 1
    if ischar(varargin{1})
        BPMxFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                BPMxList = varargin{1};
                varargin(1) = [];
            end
        end
    else
        if isnumeric(varargin{1})
            BPMxList = varargin{1};
            varargin(1) = [];
        end
    end
end

% Look for BPMz family info
if length(varargin) >= 1
    if ischar(varargin{1})
        BPMzFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                BPMzList = varargin{1};
                varargin(1) = [];
            end
        end
    else
        if isnumeric(varargin{1})
            BPMzList = varargin{1};
            varargin(1) = [];
        end
    end
end

% Look for FileName info
if length(varargin) >= 1
    if ischar(varargin{1})
        FileName = varargin{1};
    end
end

if isempty(t)
    t = 0:Tsample:T;
end

% Make a row vector
t = t(:)';

% If scalar, create a vector
if length(t) == 1
    t = 0:Tsample:t;
end

%---------------------------Start of process
fprintf('   Monitoring orbit and current for %.1f seconds\n', t(end)); drawnow;

if isfamily('DCCT')
    AM = getam({BPMxFamily, BPMzFamily, 'DCCT'}, {BPMxList, BPMzList,[]}, t, 'struct');
    DCCT = AM{3};
else
    AM = getam({BPMxFamily, BPMzFamily}, {BPMxList, BPMzList}, t, 'struct');
    DCCT = [];
end
BPM(1) = AM{1};
BPM(2) = AM{2};

BPM(1).NumberOfAverages = Navg;
BPM(1).RawData = BPM(1).Data;
BPM(1).DCCT = DCCT;
BPM(1).CreatedBy = 'measbpmsigma';
BPM(1).DataDescriptor = 'Standard Deviation';

BPM(2).NumberOfAverages = Navg;
BPM(2).RawData = BPM(2).Data;
BPM(2).DCCT = DCCT;
BPM(2).CreatedBy = 'measbpmsigma';
BPM(2).DataDescriptor = 'Standard Deviation';


tout = BPM(1).tout;
Mx = BPM(1).Data;
% retrieve first value 
for i = 1:size(Mx,2)
    Mx(:,i) = Mx(:,i) - BPM(1).Data(:,1);
end

clf reset
subplot(2,2,1);
plot(tout, Mx);
grid on;
%title(sprintf('BPM Data (%s)', datestr(BPM(1).TimeStamp)))
xlabel('Time [Seconds]');
ylabel('Horizontal Position [mm]');

tout = BPM(2).tout;
My = BPM(2).Data;
for i = 1:size(My,2)
    My(:,i) = My(:,i) -  BPM(2).Data(:,1);
end

subplot(2,2,3);
plot(tout, My);
grid on;
xlabel('Time [Seconds]');
ylabel('Vertical Position [mm]');

% Warn if the measurement did not keep in time step with t
tmeas = tout-t;
if any(tmeas(1:end-1) > 1.05*diff(t))
    fprintf('   WARNING: The time allotted for getting data is too small\n');
end

% Change the definition of .data to the standard deviation
BPM(1).t = BPM(1).t(1);
BPM(1).tout = BPM(1).tout(1);
BPMx = BPM(1).Data;
BPMz = BPM(2).Data;

% Compute the standard deviation
if 1    
    % Definition of standard deviations
    BPM(1).Data = std(BPM(1).Data,0,2);
    BPM(2).Data = std(BPM(2).Data,0,2);    
else    
    % Low frequency drifting increases the STD.  For many purposes, like LOCO,
    % this is not desireable.  Using difference orbits mitigates the drift problem.
    Mx = BPMx;
    for i = 1:size(Mx,2)-1
        Mx(:,i) = Mx(:,i+1) - Mx(:,i);
    end
    Mx(:,end) = [];
     
    My = BPMz;
    for i = 1:size(My,2)-1
        My(:,i) = My(:,i+1) - My(:,i);
    end
    My(:,end) = [];
     
    BPM(1).Data = std(Mx,0,2) / sqrt(2);   % sqrt(2) comes from substracting 2 random variables
    BPM(2).Data = std(My,0,2) / sqrt(2);
    
end

subplot(2,2,2);
plot(BPM(1).Data);
grid on;
xlabel('BPM Number');
ylabel('Horizontal STD [mm]');

subplot(2,2,4);
plot(BPM(2).Data);
grid on;
xlabel('BPM Number');
ylabel('Vertical STD [mm]');
addlabel(.5,1,sprintf('BPM Data (%s)', datestr(BPM(1).TimeStamp)), 10);
orient landscape

if ArchiveFlag | ~isempty(FileName)
    if ~isempty(FileName)
        FileNameArchive = FileName;
    else
        FileNameArchive = appendtimestamp('BPMSigma', BPM(1).TimeStamp);
        DirectoryName = getfamilydata('Directory','BPMData');
        FileNameArchive = [DirectoryName FileNameArchive];
    end
    fprintf('   BPM sigma data structure saved to %s.mat\n', FileNameArchive);
    BPMxSigma = BPM(1);
    BPMzSigma = BPM(2);
    save(FileNameArchive, 'BPMxSigma', 'BPMzSigma');
    %save(FileNameArchive, 'BPM');
else
    FileNameArchive = [];
end

if StructOutputFlag
    % Output variables
    varargout{1} = BPM(1);    
    varargout{2} = BPM(2);    
    varargout{3} = FileNameArchive;
else
    % Output variables
    varargout{1} = BPM(1).Data;
    varargout{2} = BPM(2).Data;
    varargout{3} = BPMx;
    varargout{4} = BPMz;
    varargout{5} = tout;
    varargout{6} = DCCT;
    varargout{7} = FileNameArchive;
end