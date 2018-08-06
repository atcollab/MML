function varargout = monbpmv(varargin)
%MONBPM - Monitors the orbit and button voltages
%  [BPMx, BPMy, tout, DCCT, BPMxSTD, BPMySTD, FileName] = monbpmv(t, BPMxFamily, BPMxList, BPMyFamily, BPMyList, FileName)
%  [BPMx, BPMy, FileName] = monbpmv(... , 'Struct')
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
%     [BPMx, BPMy, t] = monbpm(0:.5:180);
%     [BPMx, BPMy, t] = monbpm(0:.5:180, 'BPMx');
%     [BPMx, BPMy, t] = monbpm('BPMx');
%     [BPMx, BPMy, t] = monbpm('BPMx', 'BPMy');
%     [BPMx, BPMy, t] = monbpm('BPMx', [], 'BPMy');
%  2. Use plotorbitdata to view data.
%
%  See also plotorbitdata, monbpm, monmags

%  Written by Greg Portmann


% Defaults
BPMxFamily = gethbpmfamily;
BPMyFamily = getvbpmfamily;
BPMxList = [];   
BPMyList = [];   
DisplayFlag = 1;
FileName = -1;
ArchiveFlag = 1;
StructOutputFlag = 0;
Navg = getbpmaverages;
ModelFlag = 0;

[Navg, Tsample] = getbpmaverages;
if isempty(Tsample)
    Tsample = .5;
else
    Tsample = Tsample(1);
end
T = 3*60;  % 3 minutes (no good reason)
t = [];


% Look if 'struct' or 'numeric' in on the input line
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Struct')
        StructOutputFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Model')
        ModelFlag = 1;
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


% Probably should change this get to always be hardware units?
if ModelFlag
    %%%%%%%%%
    % Model %
    %%%%%%%%%
    [AM{1}, tmp, TimeStamp] = getam(BPMxFamily, BPMxList, 'Struct', 'Physics');
    x0 = AM{1}.Data;
    for i = 1:length(t)
        AM{1}.Data(:,i) = x0 + .1e-6*randn(size(AM{1}.DeviceList,1),1);
        AM{1}.DataTime(:,i) = AM{1}.DataTime(:,1);
    end
    AM{1}.t = t;
    AM{1}.tout = AM{1}.t;
    
    if strcmpi(getunits(BPMxFamily), 'Hardware')
        AM{1} = physics2hw(AM{1});
    end
    
    [AM{2}, tmp, TimeStamp] = getam(BPMyFamily, BPMyList, 'Struct', 'Physics');
    x0 = AM{2}.Data;
    for i = 1:length(t)
        AM{2}.Data(:,i) = x0 + .1e-6*randn(size(AM{2}.DeviceList,1),1);
        AM{2}.DataTime(:,i) = AM{2}.DataTime(:,1);
    end
    AM{2}.t = t;
    AM{2}.tout = AM{2}.t;

    if strcmpi(getunits(BPMyFamily), 'Hardware')
        AM{2} = physics2hw(AM{2});
    end

    BPM(1) = AM{1};
    BPM(2) = AM{2};
    tout = t;
    DCCT = [];
else
    %%%%%%%%%%
    % Online %
    %%%%%%%%%%
    
    %if isfamily('DCCT')
    %    AM = getam({BPMxFamily, BPMyFamily, 'DCCT'}, {BPMxList, BPMyList,[]}, t, 'struct');
    %    DCCT = AM{3};
    %else
    %    AM = getam({BPMxFamily, BPMyFamily}, {BPMxList, BPMyList}, t, 'struct');
    %    DCCT = [];
    %end
    %BPM(1) = AM{1};
    %BPM(2) = AM{2};

    if isfamily('DCCT')
        DCCTFlag = 1;
        DCCT = zeros(size(family2dev('DCCT'),1),length(t));
    else
        DCCTFlag = 0;
        DCCT = [];
    end

    % Pre-allocate the memory
    BPM = family2datastruct(BPMxFamily, family2dev(BPMxFamily));
    BPM.Data = zeros(size(BPM.Data,1),length(t));
    BPM.DataTime = zeros(size(BPM.Data,1),length(t));

    tmp = family2datastruct(BPMyFamily, family2dev(BPMyFamily));
    tmp.Data = zeros(size(tmp.Data,1),length(t));
    tmp.DataTime = zeros(size(tmp.Data,1),length(t));
    BPM(2) = tmp;
    
    BPM(1).t = t;
    BPM(2).t = t;
    
    % Need to lookup Button MemberOf??? 
    Button1 = family2datastruct(BPMxFamily, 'Button1', family2dev(BPMxFamily));
    Button1.Data = zeros(size(Button1.Data,1),length(t));
    Button1.DataTime = zeros(size(Button1.Data,1),length(t));    
    Button1.t = t;
    
    Button2 = family2datastruct(BPMxFamily, 'Button2', family2dev(BPMxFamily));
    Button2.Data = zeros(size(Button2.Data,1),length(t));
    Button2.DataTime = zeros(size(Button2.Data,1),length(t));
    Button2.t = t;
    
    Button3 = family2datastruct(BPMxFamily, 'Button3', family2dev(BPMxFamily));
    Button3.Data = zeros(size(Button3.Data,1),length(t));
    Button3.DataTime = zeros(size(Button3.Data,1),length(t));
    Button3.t = t;
    
    Button4 = family2datastruct(BPMxFamily, 'Button4', family2dev(BPMxFamily));
    Button4.Data = zeros(size(Button4.Data,1),length(t));
    Button4.DataTime = zeros(size(Button4.Data,1),length(t));
    Button4.t = t;

    tout = zeros(1,length(t));

    t0 = clock;
    BPM(1).TimeStamp = t0;
    BPM(2).TimeStamp = t0;
    
    for i = 1:length(t)
        T = t(i)-etime(clock, t0);
        if T > 0
            pause(T);
        end

        [BPM(1).Data(:,i), tmp, BPM(1).DataTime(:,i)] = getpv(BPM(1).FamilyName, BPM(1).Field, BPM(1).DeviceList);
        [BPM(2).Data(:,i), tmp, BPM(2).DataTime(:,i)] = getpv(BPM(2).FamilyName, BPM(2).Field, BPM(2).DeviceList);
        [Button1.Data(:,i), tmp, Button1.DataTime(:,i)] = getpv(BPM(1).FamilyName, 'Button1', BPM(1).DeviceList);
        [Button2.Data(:,i), tmp, Button2.DataTime(:,i)] = getpv(BPM(1).FamilyName, 'Button2', BPM(1).DeviceList);
        [Button3.Data(:,i), tmp, Button3.DataTime(:,i)] = getpv(BPM(1).FamilyName, 'Button3', BPM(1).DeviceList);
        [Button4.Data(:,i), tmp, Button4.DataTime(:,i)] = getpv(BPM(1).FamilyName, 'Button4', BPM(1).DeviceList);
        if DCCTFlag
            DCCT(:,i) = getpv('DCCT');
        end
        tout(:,i) = etime(clock, t0);
    end

    BPM(1).tout = tout;
    BPM(2).tout = tout;
end


% Complete the structures
BPM(1).NumberOfAverages = Navg;
BPM(1).DCCT = DCCT;
BPM(1).CreatedBy = 'monbpmv';
BPM(1).DataDescriptor = 'Orbit Data';

BPM(2).NumberOfAverages = Navg;
BPM(2).DCCT = DCCT;
BPM(2).CreatedBy = 'monbpmv';
BPM(2).DataDescriptor = 'Orbit Data';

Button1.NumberOfAverages = Navg;
Button1.DCCT = DCCT;
Button1.CreatedBy = 'monbpmv';
Button1.DataDescriptor = 'BPM Button 1';

Button2.NumberOfAverages = Navg;
Button2.DCCT = DCCT;
Button2.CreatedBy = 'monbpmv';
Button2.DataDescriptor = 'BPM Button 2';

Button3.NumberOfAverages = Navg;
Button3.DCCT = DCCT;
Button3.CreatedBy = 'monbpmv';
Button3.DataDescriptor = 'BPM Button 3';

Button4.NumberOfAverages = Navg;
Button4.DCCT = DCCT;
Button4.CreatedBy = 'monbpmv';
Button4.DataDescriptor = 'BPM Button 4';


% Remove the starting orbit
Mx = BPM(1).Data;
for i = 1:size(Mx,2)
    Mx(:,i) = Mx(:,i) - BPM(1).Data(:,1);
end

My = BPM(2).Data;
for i = 1:size(My,2)
    My(:,i) = My(:,i) -  BPM(2).Data(:,1);
end

    
if DisplayFlag
    subplot(2,2,1);
    plot(tout, Mx);
    grid on;
    %title(sprintf('BPM Data (%s)', datestr(BPM(1).TimeStamp)))
    xlabel('Time [Seconds]');
    ylabel(sprintf('Horizontal Position [%s]', BPM(1).UnitsString));
        
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
    s = getspos( BPM(1).FamilyName,  BPM(1).DeviceList);
    %List = BPM(1).DeviceList;
    %Nsectors = max(List(:,1));
    %Ndevices = max(List(:,2));
    %Sector = List(:,1) + List(:,2)/Ndevices + 1/Ndevices/2;
    %plot(Sector, BPM(1).Sigma);
    plot(s, BPM(1).Sigma);
    grid on;
    axis tight;
    %xaxis([1 Nsectors+1])
    %set(gca,'XTick',1:Nsectors);
    %xlabel('Sector Number');
    xlabel('BPM Position [m]');
    ylabel(sprintf('Horizontal STD [%s]', BPM(1).UnitsString));
    
    subplot(2,2,4);
    %List = BPM(2).DeviceList;
    %Nsectors = max(List(:,1));
    %Ndevices = max(List(:,2));
    %Sector = List(:,1) + List(:,2)/Ndevices + 1/Ndevices/2;
    %plot(Sector, BPM(2).Sigma);
    plot(s, BPM(2).Sigma);
    grid on;
    axis tight;
    %xaxis([1 Nsectors+1])
    %set(gca,'XTick',1:Nsectors);
    %xlabel('Sector Number');
    xlabel('BPM Position [m]');
    ylabel(sprintf('Vertical STD [%s]', BPM(2).UnitsString));
  
    addlabel(.5,1,sprintf('BPM Data (%s)', datestr(BPM(1).TimeStamp)), 10);
    orient landscape
end


% Save data in the proper directory
if ArchiveFlag || ischar(FileName)
    [DirectoryName, FileName, Ext] = fileparts(FileName);
    DirStart = pwd;
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    if ErrorFlag
        fprintf('\n   There was a problem getting to the proper directory!\n\n');
    end
    BPMxData = BPM(1);
    BPMyData = BPM(2);
    save(FileName, 'BPMxData', 'BPMyData', 'Button1', 'Button2', 'Button3', 'Button4');
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

