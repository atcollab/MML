function varargout = monbpm(varargin)
%MONBPM - Monitors the orbit
%  [BPMx, BPMy, tout, DCCT, BPMxSTD, BPMySTD, FileName] = monbpm(t, BPMxFamily, BPMxList, BPMyFamily, BPMyList, FileName)
%  [BPMx, BPMy, FileName] = monbpm(... , 'Struct')
%
%  INPUTS
%  1. t = time vector [seconds], or
%         length of time in seconds to measure data (scalar) 
%         {Default: 3 minute at a sample rate of 2 Hz}
%         {If empty, [], prompt for an input}
%  2 and 4. BPMxFamily and BPMyFamily are the family names of the BPM's, {Default or []: the entire list}
%  3 and 5. BPMxList and BPMyList are the device list of BPM's, {Default or []: the entire list}
%  6. 'Struct'  will return data structures instead of vectors
%     'Numeric' will return vector outputs {Default}
%  7.  FileName = Filename (including directory) where the data was saved (if applicable)
%  8. 'Archive'   - save a data array structure to \<BPMData Directory>\<BPMData><Date><Time>.mat  {Default}
%     'NoArchive' - no data will be saved to file
%
%  OUTPUTS
%  For numeric output:
%  1-2. BPMx and BPMy are the raw orbit data matrices or structures 
%  3. DCCT is a row vector containing the beam current
%  4. tout is a row vector of times as returned by getam           
%  5-6. BPMxSTD and BPMySTD are standard deviation of the difference orbits
%  7. FileName = Filename (including directory) where the data was saved (if applicable)
%
%  For structures:
%  BPMxSTD and BPMySTD are the .Sigma field 
%
%  NOTE
%  1. All inputs are optional.  All of the following have the same output:  
%     [BPMx, BPMz, t] = monbpm(0:.5:180);
%     [BPMx, BPMz, t] = monbpm(0:.5:180, 'BPMx');
%     [BPMx, BPMz, t] = monbpm('BPMx');
%     [BPMx, BPMz, t] = monbpm('BPMx', 'BPMz');
%     [BPMx, BPMz, t] = monbpm('BPMx', [], 'BPMz');

%
%  Written by Gregory J. Portmann
%  Adapted by Laurent S. Nadolski


% Defaults
BPMxFamily = 'BPMx'; %gethbpmfamily; too slow
BPMyFamily = 'BPMz'; %getvbpmfamily; too slow
BPMxList = [];   
BPMyList = [];   
T = 3*60;
Tsample = .5; % Sampling period
t = [];
DisplayFlag = 1;
FileName = -1;
ArchiveFlag = 1;
StructOutputFlag = 0;
Navg = getbpmaverages;

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
        if length(varargin) > i
            % Look for a filename as the next input
            if ischar(varargin{i+1})
                FileName = varargin{i+1};
                varargin(i+1) = [];
            end
        end
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoArchive')
        ArchiveFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    end
end


% t input
if length(varargin) >= 1
    if isnumeric(varargin{1})
        t = varargin{1};
        varargin(1) = [];

        if isempty(t)
            prompt = {'Input the sample period (seconds)', 'Input the total data collection time (seconds)'};
            answer = inputdlg(prompt,'monbpm',1,{'.5','180'});
            if isempty(answer)
                fprintf('   monbpm canceled\n');
                return
            end
            T       = str2num(answer{1});
            EndTime = str2num(answer{2});
            t = 0:T:EndTime;
        end
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

% Look for BPMy family info
if length(varargin) >= 1
    if ischar(varargin{1})
        BPMyFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                BPMyList = varargin{1};
                varargin(1) = [];
            end
        end
    else
        if isnumeric(varargin{1})
            BPMyList = varargin{1};
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


if ArchiveFlag
    if isempty(FileName)
        FileName = appendtimestamp('BPMData');
        DirectoryName = getfamilydata('Directory','BPMData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot'), filesep, 'BPM', filesep];
        else
            % Make sure default directory exists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        [FileName, DirectoryName] = uiputfile('*.mat', 'Select a BPM Monitor File', [DirectoryName FileName]);
        if FileName == 0 
            ArchiveFlag = 0;
            fprintf('   monbpm canceled\n');
            varargout{1} = [];
            return
        end
        FileName = [DirectoryName, FileName];
    elseif FileName == -1
        FileName = appendtimestamp('BPMData');
        DirectoryName = getfamilydata('Directory','BPMData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot'), filesep, 'BPM', filesep];
        end
        FileName = [DirectoryName, FileName];
    end
end


if DisplayFlag
    fprintf('   Monitoring orbit and current for %.1f seconds\n', t(end)); drawnow;
end
TimeStart = gettime;

if isfamily('DCCT')
    AM = getam({BPMxFamily, BPMyFamily, 'DCCT'}, {BPMxList, BPMyList,[]}, t, 'struct');
    DCCT = AM{3};
else
    AM = getam({BPMxFamily, BPMyFamily}, {BPMxList, BPMyList}, t, 'struct');
    DCCT = [];
end
BPM(1) = AM{1};
BPM(2) = AM{2};

BPM(1).NumberOfAverages = Navg;
BPM(1).DCCT = DCCT;
BPM(1).CreatedBy = 'monbpm';
BPM(1).DataDescriptor = 'Orbit Data';

BPM(2).NumberOfAverages = Navg;
BPM(2).DCCT = DCCT;
BPM(2).CreatedBy = 'monbpm';
BPM(2).DataDescriptor = 'Orbit Data';


tout = BPM(1).tout;
Mx = BPM(1).Data;
% Orbit compared to first set
for i = 1:size(Mx,2)
    Mx(:,i) = Mx(:,i) - BPM(1).Data(:,1);
end


if DisplayFlag
    figure
    subplot(2,2,1);
    plot(tout, Mx);
    grid on;
    %title(sprintf('BPM Data (%s)', datestr(BPM(1).TimeStamp)))
    xlabel('Time [Seconds]');
    ylabel('Horizontal Relative Position [mm]');
    
    
    tout = BPM(2).tout;
    % Orbit compared to first set
    My = BPM(2).Data;
    for i = 1:size(My,2)
        My(:,i) = My(:,i) -  BPM(2).Data(:,1);
    end
    
    subplot(2,2,3);
    plot(tout, My);
    grid on;
    xlabel('Time [Seconds]');
    ylabel(sprintf('Vertical Position [%s]', BPM(2).UnitsString));
end


% Warn if the measurement did not keep in time step with t
tmeas = tout-t;
if any(tmeas(1:end-1) > 1.05*diff(t))
    fprintf('   WARNING: The time allotted for getting data is too small\n');
end



% Compute the standard deviation
if 0
    % Definition of standard deviations
    BPM(1).Sigma = std(BPM(1).Data,0,2);
    BPM(2).Sigma = std(BPM(2).Data,0,2);
    
else
    
    % Low frequency drifting increases the STD.  For many purposes, like LOCO,
    % this is not desireable.  Using difference orbits mitigates the drift problem.
    Mx = BPM(1).Data;
    for i = 1:size(Mx,2)-1
        Mx(:,i) = Mx(:,i+1) - Mx(:,i);
    end
    Mx(:,end) = [];
    
    My = BPM(2).Data;
    for i = 1:size(My,2)-1
        My(:,i) = My(:,i+1) - My(:,i);
    end
    My(:,end) = [];
    
    BPM(1).Sigma = std(Mx,0,2) / sqrt(2);   % sqrt(2) comes from substracting 2 random variables
    BPM(2).Sigma = std(My,0,2) / sqrt(2);
    
end

if DisplayFlag
    subplot(2,2,2);
    List = BPM(1).DeviceList;
    Nsectors = max(List(:,1));
    Ndevices = max(List(:,2));
    Sector = List(:,1) + List(:,2)/Ndevices + 1/Ndevices/2;
    [Sector Idx] = sort(Sector);
    plot(Sector, BPM(1).Sigma(Idx));
    grid on;
    xaxis([1 Nsectors+1])
    set(gca,'XTick',1:Nsectors);
    xlabel('Sector Number');
    ylabel(sprintf('Horizontal STD [%s]', BPM(1).UnitsString));
    
    subplot(2,2,4);
    List = BPM(2).DeviceList;
    Nsectors = max(List(:,1));
    Ndevices = max(List(:,2));
    Sector = List(:,1) + List(:,2)/Ndevices + 1/Ndevices/2;
    [Sector Idx] = sort(Sector);    
    plot(Sector, BPM(2).Sigma(Idx));
    grid on;
    xaxis([1 Nsectors+1])
    set(gca,'XTick',1:Nsectors);
    xlabel('Sector Number');
    ylabel(sprintf('Vertical STD [%s]', BPM(2).UnitsString));
  
    addlabel(.5,1,sprintf('BPM Data (%s)', datestr(BPM(1).TimeStamp)), 10);
    orient landscape
end


% Save data in the proper directory
if ArchiveFlag | ischar(FileName)
    [DirectoryName, FileName, Ext] = fileparts(FileName);
    DirStart = pwd;
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    if ErrorFlag
        fprintf('\n   There was a problem getting to the proper directory!\n\n');
    end
    BPMxData = BPM(1);
    BPMyData = BPM(2);
    save(FileName, 'BPMxData', 'BPMyData');
    %save(FileName, 'BPM');
    cd(DirStart);
    FileName = [DirectoryName, FileName, '.mat'];

    if DisplayFlag
        fprintf('   BPM data saved to %s\n', FileName);
        fprintf('   The total measurement time was %.2f minutes.\n', (gettime-TimeStart)/60);
    end
else
    FileName = '';
end


if StructOutputFlag
    % Output variables
    varargout{1} = BPM(1);    
    varargout{2} = BPM(2);    
    varargout{3} = FileName;
else
    % Output variables
    varargout{1} = BPM(1).Data;
    varargout{2} = BPM(2).Data;
    varargout{3} = tout;
    varargout{4} = DCCT;
    varargout{5} = BPM(1).Sigma;
    varargout{6} = BPM(2).Sigma;
    varargout{7} = FileName;
end

