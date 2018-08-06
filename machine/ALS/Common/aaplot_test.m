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

        % Before and after DOE kicker was removed
        %d2 = datenum('2017-04-30');
        %d1 = d2 - 8;

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
    elseif 1
        % EPBI trip
        d1 = datenum('2018-02-10');
        d1 = d1 + .01;
        d2 = d1 + .01;

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
        
        % Issue with SR04C:BPM1:ADC2:rfMag
        %d1 = '2015-05-10T01:00:00.000Z';
        %d2 = '2015-05-13T23:00:00.000Z';
        
        % Issue with
        %d1 = '2016-02-11T02:00:00.000Z';
        %d2 = '2016-03-12T03:00:00.000Z';
        
        %d1 = '2016-10-23T02:00:00.000Z';
        %d2 = '2016-10-25T03:00:00.000Z';

        d1 = '2017-12-13T02:00:00.000Z';
        d2 = '2017-12-24T03:00:00.000Z';
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

if 1
    FigNum = 201;
    pvname = 'cmm:beam_current';
   %pvname = 'SR05S___DCCTLP_AM01';
   %pvname = family2channel('BPMx',[4 7]);
   
elseif 0
    FigNum = 302;
    pvname = family2channel('HCM','Monitor',[11 1]);
    %pvname = family2channel('QF','Monitor',[10 2]);
    %pvname = family2channel('QD','Monitor',[11 1]);
    %pvname = 'SR11U___HCM2M1_AM00';
    %pvname = 'SR11U___HCM2M2_AM01';
    
elseif 0
    pvname = 'TimSeqFailedCount'
   %pvname = 'TimSeqUnkFiberLinkCount'
   
elseif 0
    pvname = 'MOCounter:FREQUENCY';  % Frequency
    %pvname = 'EG______HQMOFM_AC01';  % Analog frequency control
    %pvname = 'SR03S___RFPHLP_AC03'
    %pvname = 'SR01C___FREQBHPAM00'; % HP precise
    FigNum = 301;
    
else
    FigNum = 801;
 
    %FigNum = 311;
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
    
    % Linac  RF Master Trigger Delay: old TimRFMasterDelay,  new  LI11:EVR2-DlyGen:0:Delay-SP
    % Injection Kicker Trigger Delay: old TimInjKickerDelay, new S0817:EVR1-DlyGen:0:Delay-SP
    %pvname = 'TimRFMasterDelay';
    %pvname = 'TimInjKickerDelay';
    %pvname = 'LI11:EVR2-DlyGen:0:Delay-SP';
    %pvname = 'S0817:EVR1-DlyGen:0:Delay-SP';
    %pvname = '';
    
    Prefix = 'SR01C:BPM4';
    %Prefix = 'SR01C:BPM8';
    %pvname = sprintf('%s:DFE:2:temperature', Prefix);
    %pvname = sprintf('%s:AFE:1:temperature', Prefix);
    %pvname = sprintf('%s:AFE:adcRate', Prefix);    % Not archived!!!
    %pvname = sprintf('%s:', Prefix);
    %pvname = sprintf('%s:', Prefix);
    
    %pvname = sprintf('%s:SA:X', Prefix);
    %pvname = sprintf('%s:SA:Y', Prefix);
    %pvname = sprintf('%s:SA:S', Prefix);
    pvname = sprintf('%s:attenuation', Prefix);
    %pvname = sprintf('%s:ADC0:rfMag', Prefix);
    %pvname = sprintf('%s:SA:RMS:wide:X', Prefix);
    %pvname = sprintf('%s:autotrim:control', Prefix);  % not in archiver
    
    %pvname = 'SR12S___IBPM1X_AM00';
    
    %pvname = 'SR01C:BPM2:SA:X';
    %pvname = 'SR01C:BPM2:SA:Y';
    %pvname = 'SR01C:BPM2:SA:S';
    %pvname = 'SR01C:BPM2:SA:Q';
    % pvname = 'SR01C:BPM2:ADC0:rfMag';
    % pvname = 'SR01C:BPM2:ADC1:rfMag';
    % pvname = 'SR01C:BPM2:ADC2:rfMag';
    % pvname = 'SR01C:BPM2:ADC3:rfMag';
    % pvname = 'SR01C:BPM2:ADC0:gainFactor';
    % pvname = 'SR01C:BPM2:ADC0:ptLoMag';
    % pvname = 'SR01C:BPM2:ADC1:ptLoMag';
    % pvname = 'SR01C:BPM2:ADC2:ptLoMag';
    % pvname = 'SR01C:BPM2:ADC3:ptLoMag';
    % pvname = 'SR01C:BPM2:ADC0:ptHiMag';
    % pvname = 'SR01C:BPM2:ADC1:ptHiMag';
    % pvname = 'SR01C:BPM2:ADC2:ptHiMag';
    % pvname = 'SR01C:BPM2:ADC3:ptHiMag';
    
    %pvname = 'BTS_____VCM3___AC02';
    
    
    % pvname = 'SR04C:BPM1:ADC2:peak';
    % pvname = 'SR04C:BPM1:SA:X';
    % FigNum = 201;
    %pvname = 'SR04C:BPM1:ADC2:rfMag';
    %FigNum = 301;
    %pvname = {'SR04C:BPM1:ADC0:rfMag';'SR04C:BPM1:ADC1:rfMag';'SR04C:BPM1:ADC2:rfMag';'SR04C:BPM1:ADC3:rfMag'};
    
    %FigNum = 321;
    %pvname = {'SR09C:BPM2:ADC0:rfMag';'SR09C:BPM2:ADC1:rfMag';'SR09C:BPM2:ADC2:rfMag';'SR09C:BPM2:ADC3:rfMag'};
    
    %FigNum = 311;
    %pvname = 'SR08C:BPM1:attenuation'
    
    %pvname = 'SR11C:BPM8:SA:X';  % X, Y, Q, S
    %pvname = 'SR11C:BPM8:ADC2:rfMag';
    %pvname = 'SR01C:BPM2:SA:S';
    %pvname = 'SR01C:BPM7:Gain:RfAtte-SP'
    %pvname = 'SR01C:BPM7:ADC:WA-A.MAX';
    %pvname = 'SR01C:BPM7:Ampl:ASA-I';
    %pvname = 'SR01C:BPM7:Pos:X-I'
    
    %pvname = 'SR01C:BPM2:AFE:pllStatus';
        
    % Bad channel test
    %pvname = 'SR02C___C3MERR_BM00';
    
    %pvname = 'IGPF:LFB:MILMEGA:FWD';
end

n = aa.getPVs';
ii = find(strcmpi(deblank(pvname), n));
if isempty(ii)
    fprintf('%s not found in PV list\n', pvname);
end


% Prefix = 'SR02C:BPM2:'
% ii = find(strncmp(Prefix, n, length(Prefix)));
% if ~isempty(ii)
%     n(ii)
% end

ds = aa.getData(pvname, d1, d2);
ds = aaepoch2datenum(ds);

% Print output to the screen
if length(ds.data.values) < 30
    fprintf('%s\n', pvname);
    for i = 1:length(ds.data.values)
        fprintf('%s %d\n', datestr(ds.data.datenum(i)), ds.data.values(i));
    end
end

% plotting
figure(FigNum);
clf reset
if length(ds) == 1 % plot for single pv
    plot(ds.data.datenum, ds.data.values, '.-');
    title(sprintf('ArchAppliance:  %s   %s  to  %s   (%d points)', pvname, datestr(ds.data.datenum(1),31), datestr(ds.data.datenum(end),31), length(ds.data.values)));
else
    cc=hsv(length(ds)); % plot for multiple pv
    for i = 1:length(ds)
        ColorStr = nxtcolor;
        plot(ds{i}.data.datenum, ds{i}.data.values, '.-', 'color',ColorStr);
        hold on;
    end
    title(sprintf('ArchAppliance:  %s  to  %s   (%d points)', datestr(ds{1}.data.datenum(1),31), datestr(ds{1}.data.datenum(end),31), length(ds{1}.data.values)));
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


figure(FigNum + 1);
clf reset
if length(ds) == 1
    t = 24 * 60 * 60 * (ds.data.datenum - ds.data.datenum(1));
    t = 24 *           (ds.data.datenum - ds.data.datenum(1));
    plot(t, ds.data.values, '.-');
    title(sprintf('ArchAppliance:  %s  to  %s   (%d points)', datestr(ds.data.datenum(1),31), datestr(ds.data.datenum(end),31), length(ds.data.values)));
else
    t = 24 * 60 * 60 * (ds{1}.data.datenum - ds{1}.data.datenum(1));
    t = 24 *           (ds{1}.data.datenum - ds{1}.data.datenum(1));
    plot(t, ds{1}.data.values, '.-');
end



