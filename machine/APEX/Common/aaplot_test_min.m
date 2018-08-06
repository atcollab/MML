
aa = ArchAppliance;

% Local
d2 = now; % datenum('2013-10-04');
d1 = d2 - 20;

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

% Force to cfd notation
if ~ischar(d1)
    d1 = datestr(d1, 'yyyy-mm-ddTHH:MM:SS.FFFZ');
end
if ~ischar(d2)
    
    d2 = datestr(d2, 'yyyy-mm-ddTHH:MM:SS.FFFZ');
end

pvname = 'CavityHeater1:OutputOn';
%pvname = 'Gun:RF:Cav_Nose_Cone_Flow';
%pvname = 'Gun:RF:Circ2_Flow';
%pvname = 'Screen1:LaserPermit';

tic
ds = aa.getData(pvname, d1, d2);
toc

ds = aaepoch2datenum(ds);


% Put a space for large archiver gaps
% TGap = 36*60; % 
% dt = diff(ds.data.datenum)*24*60*60;
% i = find(dt > TGap);
% if ~isempty(i)
%     ds.data.values(i) = NaN;   % Should really add a gap instead of wiping out data!
%     fprintf('   Removed %d data points with larger data time gaps then %.0f seconds.\n', length(i), TGap);
% end

figure(101);
clf reset
plot(ds.data.datenum, ds.data.values, '-');
title(sprintf('ArchAppliance:  %s  to  %s   (%d points)', datestr(ds.data.datenum(1),31), datestr(ds.data.datenum(end),31), length(ds.data.values)));

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
axis tight


%t = 24 * 60 * (ds.data.datenum - ds.data.datenum(1));
t = (ds.data.datenum - ds.data.datenum(1));
figure(102);
clf reset
plot(t, ds.data.values, '.-');
title(sprintf('ArchAppliance:  %s  to  %s   (%d points)', datestr(ds.data.datenum(1),31), datestr(ds.data.datenum(end),31), length(ds.data.values)));
%xlabel('Time [Minutes]');
xlabel('Time [Days]');
ylabel(sprintf('%s', pvname), 'Interpret','None');
