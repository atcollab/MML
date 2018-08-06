function BPM = aaplot_bpm(DevList, d1, d2)
%AAPLOT_BPM - ALS archive appliance for BPMs
%
% BPM = aaplot_bpm(DevList, d1, d2)

% Written by Greg Portmann

% To test time conversions:
% http://www.epochconverter.com/

% Attempt to read .pb file directly
% ssh arch02.als
% cd /arch02-data/lts/ArchiverStore
% fid = fopen('SR10S___UPV2_5__AM:2015.pb');
% fid = fopen('Topoff_cam_lifetime_AM:2015.pb');
% buffer = fread(fid, [1 inf], '*uint8');
% fclose(fid);
% char(buffer(5:22))

aa = ArchAppliance;

if nargin < 1
    DevList = [1 1];
end

if nargin < 2
    if 0
        % Local
        d2 = now; % datenum('2013-10-04');
        d1 = d2 - 2;
        
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
    else
        % Must be in UTC
        % Archiver started roughly '2013-10-03T00:00:00.000Z'
        
        % Issue with SR04C:BPM1:ADC2:rfMag
        %d1 = '2015-05-10T01:00:00.000Z';
        %d2 = '2015-05-13T23:00:00.000Z';
        
        % Issue with
        %d1 = '2016-02-11T02:00:00.000Z';
        %d2 = '2016-03-12T03:00:00.000Z';
        
        d1 = '2017-12-13T02:00:00.000Z';
        d2 = '2017-12-21T03:00:00.000Z';
    end
end


% Force to cfd notation
if ~ischar(d1)
    d1 = datestr(d1, 'yyyy-mm-ddTHH:MM:SS.FFFZ');
end
if ~ischar(d2)
    d2 = datestr(d2, 'yyyy-mm-ddTHH:MM:SS.FFFZ');
end

FigNum = 701;

%pvname = 'cmm:beam_current';
%pvname = 'bl72:XRMSAve';
%pvname = 'bl72:YRMSAve';


%Prefix = 'SR02C:BPM2';
%Prefix = 'SR01C:BPM8';
%pvname = sprintf('%s:SA:X', Prefix);
%pvname = sprintf('%s:SA:Y', Prefix);
%pvname = sprintf('%s:SA:S', Prefix);
%pvname = sprintf('%s:attenuation', Prefix);
%pvname = sprintf('%s:ADC0:rfMag', Prefix);
%pvname = sprintf('%s:SA:RMS:wide:X', Prefix);
%pvname = sprintf('%s:autotrim:control', Prefix);  % not in archiver

%pvname = 'SR09S___IBPM1X_AM00';

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

Fields = {'X','Y','S','Attn'};
%Fields = {'X','Y','Q','S','A','B','C','D','Attn'};

for i = 1:size(DevList, 1)
    for j = 1:length(Fields)
        pvname = family2channel('BPM', Fields{j}, DevList(i,:));
        
        n = aa.getPVs';
        ii = find(strcmpi(deblank(pvname), n));
        if isempty(ii)
            fprintf('%s not found in PV list\n', pvname);
        end
        
        ds = aa.getData(pvname, d1, d2);
        ds = aaepoch2datenum(ds);
        
        % Print output to the screen
        if length(ds.data.values) < 30
            fprintf('%s\n', pvname);
            for i = 1:length(ds.data.values)
                fprintf('%s %d\n', datestr(ds.data.datenum(i)), ds.data.values(i));
            end
        end
        BPM.(Fields{j}).t    = ds.data.datenum;
        BPM.(Fields{j}).data = ds.data.values;
    end
end


% plotting
for i = 1:size(DevList)
    %iGood = find(BPM(i).S.data > 1e5);
    
    figure(FigNum+i-1);
    clf reset
    
    h = subplot(3,1,1);
    %plot(BPM(i).X.t(iGood), BPM(i).X.data(iGood), '.-');
    plot(BPM(i).X.t, BPM(i).X.data, '.-');
    ylabel('Horizontal');
    title(sprintf('BPM(%d,%d)  %s to %s (%d points)', DevList(i,:), datestr(ds.data.datenum(1),31), datestr(ds.data.datenum(end),31), length(ds.data.values)));
    datetick x
    
    h(length(h)+1) = subplot(3,1,2);
    plot(BPM(i).Y.t, BPM(i).Y.data, '.-');
    ylabel('Vertical');
    datetick x
    
    h(length(h)+1) = subplot(3,1,3);
    plot(BPM(i).S.t, BPM(i).S.data, '.-');
    ylabel('Sum');    
    datetick x
end

linkaxes(h, 'x');


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
% datetick x
%axis tight


% figure(FigNum + 1);
% clf reset
% if length(ds) == 1
%     t = 24 * 60 * 60 * (ds.data.datenum - ds.data.datenum(1));
%     t = 24 *           (ds.data.datenum - ds.data.datenum(1));
%     plot(t, ds.data.values, '.-');
%     title(sprintf('ArchAppliance:  %s  to  %s   (%d points)', datestr(ds.data.datenum(1),31), datestr(ds.data.datenum(end),31), length(ds.data.values)));
% else
%     t = 24 * 60 * 60 * (ds{1}.data.datenum - ds{1}.data.datenum(1));
%     t = 24 *           (ds{1}.data.datenum - ds{1}.data.datenum(1));
%     plot(t, ds{1}.data.values, '.-');
% end
%


