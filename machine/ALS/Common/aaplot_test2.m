function ds = aaplot_test(pvnames, d1, d2)
%AAPLOT_TEST - ALS archive appliance example

% Written by Greg Portmann

% To test time conversions:
% http://www.epochconverter.com/
%


% Attempt to read .pb file directly
% ssh arch02.als
% cd /arch02-data/lts/ArchiverStore
% fid = fopen('SR10S___UPV2_5__AM:2015.pb');
% fid = fopen('Topoff_cam_lifetime_AM:2015.pb');
% buffer = fread(fid, [1 inf], '*uint8');
% fclose(fid);
% char(buffer(5:22))



clear

aa = ArchAppliance;

if nargin < 2
    if 1
        % Local 
        d2 = now; % datenum('2013-10-04');
        d1 = d2 - 1;
        %d1 = now - 3/24/60;     % last  3 minutes
        %d1 = now - 1/24;

        %d2 = datenum('2016-04-28');
        %d1 = datenum('2016-04-21');
        
        % Convert to UTC time
        if isdaylightsavings(d1)
            d1 = d1 + 7/24;
        else
            d1 = d1 + 8/24;
        end
        % Convert to UTC time
        if isdaylightsavings(d2)
            d2 = d2 + 7/24;
        else
            d2 = d2 + 8/24;
        end
    else
        % Must be in UTC
       % archiver started roughly '2013-10-03T00:00:00.000Z'
       %d1 = '2015-04-30T20:00:00.000Z';
       %d2 = '2015-05-01T08:00:00.000Z';
       %d1 = '2015-03-14T00:00:00.000Z';
       %d2 = '2015-03-27T10:00:00.000Z';
       %d1 = '2014-08-06T00:00:00.000Z';
       %d2 = '2014-08-07T00:00:00.000Z';
       %d1 = '2014-02-03T10:00:00.000Z';
       %d2 = '2014-02-07T00:00:00.000Z';
       %d1 = '2013-10-06T09:00:00.000Z';
       %d2 = '2013-10-11T00:00:00.000Z';
       %%%% 
       d1 = '2015-05-16T15:30:00.000Z';
       d2 = '2015-05-16T16:30:00.000Z';
    end
end

%  tic; urlwrite(url, 'AAtemp.mat', 'get',  {'pv', pvname{i}, 'from', from, 'to', to}); toc
%  S = urlread(url, 'get',  {'pv', pvname{i}, 'from', from, 'to', to});

% Force to cfd notation
if ~ischar(d1)
    d1 = datestr(d1, 'yyyy-mm-ddTHH:MM:SS.FFFZ');
end
if ~ischar(d2)    
    d2 = datestr(d2, 'yyyy-mm-ddTHH:MM:SS.FFFZ');
end

Offset = 0;
pvname = 'TimInjFieldSyncDelaySP';

%pvname = 'cmm:beam_current';
%pvname = 'bl72:XRMSAve';
%pvname = 'bl72:YRMSAve';
%pvname = 'beamline31:XRMSAve';
%pvname = 'beamline31:YRMSAve';
%pvname = 'SR01C___FREQB__AM00';
%pvname = 'SR09C___SQSHF1_AM00';  % not found

%pvname = 'SR01S___IBPM2X_AM02';

%pvname = 'LN______KY1FIL_AM00';
%pvname = 'LN______KY1PTB_AM01';
%pvname = 'LN______MD1HV__AM02';
%pvname = 'LN______MD1CC__AM03';

%pvname = 'LN______MD1HV__AC02';
%pvname = 'SR01C___VCM2T__AC10';

%pvname = 'SR09S___IBPM1X_AM00';

% pvname = 'SR04C:BPM1:ADC2:peak';
% pvname = 'SR04C:BPM1:SA:X';
% pvname = 'SR04C:BPM1:ADC2:rfMag';

%pvname = 'SR11C:BPM8:SA:X';  % X, Y, Q, S 
%pvname = 'SR11C:BPM8:ADC2:rfMag';
%pvname = 'SR01C:BPM2:SA:S';
%pvname = 'SR01C:BPM7:Gain:RfAtte-SP'
%pvname = 'SR01C:BPM7:ADC:WA-A.MAX';
%pvname = 'SR01C:BPM7:Ampl:ASA-I';
%pvname = 'SR01C:BPM7:Pos:X-I'

%pvname = 'SR01C:BPM2:AFE:pllStatus';
%pvname = 'SR01C:BPM8:FPGA:temperature'
%pvname = 'SR07C:BPM2:FPGA:temperature'

%pvname = 'SR05C:BPM8:SA:X';  % X, Y, Q, S 
%Offset = getgolden('BPMx', [5 9]);
%pvname = 'SR05C:BPM8:ADC3:rfMag'; 
%pvname = 'SR05C:BPM8:attenuation';

%pvname = 'SR06C:BPM1:ADC3:rfMag'; 
%pvname = 'SR06C:BPM1:ADC1:rfMag'; 
%pvname = 'SR06C:BPM1:ADC2:ptLoMag';

%pvname = 'SR01C:BPM5:AFE:0:temperature';
%pvname = '';

% Bad channel test
%pvname = 'SR02C___C3MERR_BM00';


%% test single pv call
tmp = zeros(100,1);
if 1
    for i = 1:100
    tic;
    ds = aa.getData(pvname, d1, d2);
    tmp(i) = toc;
    end
    ds = aaepoch2datenum(ds);
    mean(tmp)
end


%% test multi pv calls
Family = 'BPMx';
Field  = 'Monitor';
%DeviceList = getbpmlist(Family, 'Bergoz', 'UserDisplay');
DeviceList = getbpmlist(Family, 'nonbergoz', 'UserDisplay');
pvnames = cellstr(family2channel(Family,Field,DeviceList));

% combine both bpmx & bpmy pv
%pvnames2 = cellstr(family2channel('BPMy',Field,DeviceList));
%pvnames = [pvnames;pvnames2];
%tic
%ds = aa.getData(pvnames, d1, d2);
%toc
%ds = aaepoch2datenum(ds);

% test with all pv from graphit_setup
if 0
    [GR, main] = graphit_setup;
    for i = 1:length(GR)
        pvnames = GR{i}.Data.ChannelNames;
        fprintf('grabbing channel set %d \n',i);
        try
            ds{i} = aa.getData(pvnames, d1, d2);
            ds{i} = aaepoch2datenum(ds{i});
        catch
            GR{i}.Data.ChannelNames
        end
    end
    %
    % remove empty
    ds = ds(~cellfun('isempty',ds));
    % transpose to column vectors
    ds= cellfun(@transpose,ds,'UniformOutput',false);
    % turn into single cell array
    ds = [ds{:}];
end

%% test retrieval time for various amounts of data
if 0
    timerange = linspace(0.001,36,100);
    times = zeros(length(timerange),1);
    data = zeros(length(timerange),1);
    Family = 'BPMx';
    Field  = 'Monitor';
    DeviceList = getbpmlist(Family, 'Bergoz', 'UserDisplay');
    %DeviceList = getbpmlist(Family, 'nonbergoz', 'UserDisplay');
    pvnames = cellstr(family2channel(Family,Field,DeviceList));
    
    for i = 1:length(timerange)
        d2 = now; % datenum('2013-10-04');
        d1 = d2 - timerange(i);
        
        % Force to cfd notation
        if ~ischar(d1)
            d1 = datestr(d1, 'yyyy-mm-ddTHH:MM:SS.FFFZ');
        end
        if ~ischar(d2)
            d2 = datestr(d2, 'yyyy-mm-ddTHH:MM:SS.FFFZ');
        end
        
        tic
        ds = aa.getData(pvnames(1), d1, d2);
        time(i) = toc;
        data(i) = length(ds{1}.data.values);
        fprintf(' completed %d \n', i);
        
        
    end
end

% Put a space for large archiver gaps
% TGap = 36*60; % 
% dt = diff(ds.data.datenum)*24*60*60;
% i = find(dt > TGap);
% if ~isempty(i)
%     ds.data.values(i) = NaN;   % Should really add a gap instead of wiping out data!
%     fprintf('   Removed %d data points with larger data time gaps then %.0f seconds.\n', length(i), TGap);
% end
%% test retrieval time 2
% testing to see if speed depends on looping

if 0
    timerange = linspace(0.001,2,10);
    times = zeros(length(timerange),1);
    data = zeros(length(timerange),1);
    Family = 'BPMx';
    Field  = 'Monitor';
    DeviceList = getbpmlist(Family, 'Bergoz', 'UserDisplay');
    %DeviceList = getbpmlist(Family, 'nonbergoz', 'UserDisplay');
    pvnames = cellstr(family2channel(Family,Field,DeviceList));
    ds = cell(length(pvnames),1);
    dsTime = zeros(length(pvnames),1);
    
    % loop through 1 at a time. 
    for i = 1:length(timerange)
        d2 = now; % datenum('2013-10-04');
        d1 = d2 - timerange(i);
        
        % Force to cfd notation
        if ~ischar(d1)
            d1 = datestr(d1, 'yyyy-mm-ddTHH:MM:SS.FFFZ');
        end
        if ~ischar(d2)
            d2 = datestr(d2, 'yyyy-mm-ddTHH:MM:SS.FFFZ');
        end
        
        % get values with looping
        for j = 1:length(pvnames)
            timePV = tic;
            ds{j} = aa.getData(pvnames{j}, d1, d2);
            dsTime(j) = toc(timePV);
            fprintf(' pv completed %d -- %d\n', j,dsTime(j));
        end
        
        % get value without looping
        timeT = tic;
        dsTmp = aa.getData(pvnames,d1,d2);
        dsTmpTime = toc(timeT);
        
        fprintf(' +++++++++++++++++++++ time completed %d \n', i);
        fprintf(' non loop: %d vs loop: %d \n', dsTmpTime, sum(dsTime));
        x = input('');
        
    end
    
end

%%

ds.data.values = ds.data.values - Offset;


%% plotting
if 1
figure(402);
clf reset
if length(ds) == 1 % plot for single pv
    plot(ds.data.datenum, ds.data.values, '.-');
    title(sprintf('%s   %s  to  %s   (%d points)', pvname, datestr(ds.data.datenum(1),31), datestr(ds.data.datenum(end),31), length(ds.data.values)));
else
    cc=hsv(length(ds)); % plot for multiple pv
    for i = 1:length(ds)
        if ds{i}.data.values ~= 0
        try
            plot(ds{i}.data.datenum, ds{i}.data.values, '.-','color',cc(i,:));
            hold on;
        catch
        end
        end
       
    end
%title(sprintf('ArchAppliance:  %s   %s  to  %s   (%d points)', pvname, datestr(ds.data.datenum(1),31), datestr(ds.data.datenum(end),31), length(ds.data.values)));
end
end

% T = ds.data.datenum(end) - ds.data.datenum(1);
% if T > 20
%     datetick('x','mm:dd');
% elseif T > 3
%     datetick('x','dd:hh');
% elseif T > 1
%     datetick('x','hh:mm');
% elseif T > .1
%     datetick('x','hh:mm:ss');
% end  
datetick x
%axis tight

if 0
figure(202);
clf reset
if length(ds) == 1
    t = 24 * 60 * 60 * (ds.data.datenum - ds.data.datenum(1));
    t = 24 *           (ds.data.datenum - ds.data.datenum(1));
    plot(t, ds.data.values, '.-');
    title(sprintf('%s  to  %s   (%d points)', datestr(ds.data.datenum(1),31), datestr(ds.data.datenum(end),31), length(ds.data.values)));
else
    t = 24 * 60 * 60 * (ds{1}.data.datenum - ds{1}.data.datenum(1));
    t = 24 *           (ds{1}.data.datenum - ds{1}.data.datenum(1));
    plot(t, ds{1}.data.values, '.-');
end
end


