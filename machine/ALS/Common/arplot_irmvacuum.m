function arplot_irmvacuum
%ARPLOT_IRMVACUUM

% Written by Greg Portmann


% Options.format    = 'html';
% Options.outputDir = 'Feb2014_Archive';
% Options.showCode = false;
% publish('arplot_irmvacuum', Options)

clear

% Must be in UTC
d1 = '2014-02-20T00:30:00.000Z';
d2 = '2014-02-20T23:30:00.000Z';
arread('20140220');


[ILC, IRM, Gain, Offset] = irmvacuumnames;

%close all

aa = ArchAppliance;

arglobal

for i = 1:4 %length(IRM)
    
    try
        Test = 0;
        pvname = IRM{i};
        ds = aa.getData(pvname, d1, d2);
        ds = aaepoch2datenum(ds);
        Start = datevec(ds.data.datenum(1));
        d_irm = ds;
        t_irm = 24*(ds.data.datenum - ds.data.datenum(1));
              
        Test = 1;
        pvname = ILC{i};
        [d_ilc.data.values, iar] = arselect(pvname);
        t_ilc = ARt/60/60;
        
        Test = 2;
        ibad = find((Gain(i) * d_irm.data.values + Offset(i)) < 1e-11);
        d_irm.data.values(ibad) = NaN;
        
        ibad = find(d_ilc.data.values<=0);
        d_ilc.data.values(ibad) = NaN;
        
        h = figure(i);
        clf reset
        set(h, 'Units', 'Normalized');
        p = get(h, 'Position');
        p(3) = 1.2*p(3);
        set(h, 'Position', p);
        semilogy(t_ilc, d_ilc.data.values, '-b');
        hold on
        semilogy(t_irm, Gain(i) * d_irm.data.values + Offset(i), '-r');
        hold off
        title(sprintf('%d.   %s    %s', i, ILC{i}, IRM{i}), 'Interpret', 'None');
        xlabel(sprintf('%s  to  %s   (%d points)   [Days]', datestr(ds.data.datenum(1),31), datestr(ds.data.datenum(end),31), length(ds.data.values)));
                
        %axis tight;
        %a = axis;
        %if a(3) < 5e-11;
        %    a(3) = 5e-11;
        %end
        %axis(a);
    catch
        if Test == 0
            fprintf('There was a problem finding %s\n', IRM{i});
        else
            fprintf('There was a problem finding %s\n', ILC{i});
        end
    end
end


% figure(101);
% clf reset
% plot(ds.data.datenum, ds.data.values, '-');
% title(sprintf('ArchAppliance:  %s  to  %s   (%d points)', datestr(ds.data.datenum(1),31), datestr(ds.data.datenum(end),31), length(ds.data.values)));
% datetick x
% axis tight
%
%
% t = 24 * 60 * 60 * (ds.data.datenum - ds.data.datenum(1));
% figure(102);
% clf reset
% plot(t, ds.data.values, '.-');
% title(sprintf('ArchAppliance:  %s  to  %s   (%d points)', datestr(ds.data.datenum(1),31), datestr(ds.data.datenum(end),31), length(ds.data.values)));
