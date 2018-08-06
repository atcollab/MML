function aaplot_irmvacuum(d1, d2)
%AAPLOT_IRMVACUUM

% Written by Greg Portmann

% Options.format    = 'html';
% Options.outputDir = '/home/physdata/IRM/IonPumps/Calibration_Verification';
% Options.showCode = false;
% publish('aaplot_irmvacuum', Options)


clear

if nargin < 2
    if 1
        % Local
        d2 = now; % datenum('2013-10-04');
        d1 = d2 - 60;
        
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
        d1 = '2014-02-06T01:00:00.000Z';
        d2 = '2014-02-22T12:00:00.000Z';
        %d1 = '2013-10-06T00:00:00.000Z';
        %d2 = '2014-01-06T00:00:00.000Z';
        %d1 = '2013-10-06T09:00:00.000Z';
        %d2 = '2013-10-11T00:00:00.000Z';
    end
end

% Force to cfd notation
if ~ischar(d1)
    d1 = datestr(d1, 'yyyy-mm-ddTHH:MM:SS.FFFZ');
end
if ~ischar(d2)
    
    d2 = datestr(d2, 'yyyy-mm-ddTHH:MM:SS.FFFZ');
end


[ILC, IRM, Gain, Offset] = irmvacuumnames;
OffsetOrg = Offset;
Offset = Offset * 0;

close all

aa = ArchAppliance;

% recheck: 53 74

IRMTestFlag = 1;

for i = 1:length(IRM)
    
    try
        Test = 0;
        if IRMTestFlag
            pvname = IRM{i};
            ds = aa.getData(pvname, d1, d2);
            ds = aaepoch2datenum(ds);
            Start = datevec(ds.data.datenum(1));
            d_irm = ds;
            t_irm = (ds.data.datenum - ds.data.datenum(1)) + Start(3);
            % t_irm = t_irm - t_irm(1);
        else
            pvname = ['TEST:',ILC{i}];
            
            ds = aa.getData(pvname, d1, d2);
            ds = aaepoch2datenum(ds);
            Start = datevec(ds.data.datenum(1));
            d_irm = ds;
            t_irm = (ds.data.datenum - ds.data.datenum(1)) + Start(3);
            
            TestGain = str2double(getpvonline([pvname, '.INPB']));
            TestOff  = str2double(getpvonline([pvname, '.INPC']));
            fprintf('   Gain=%.4g   Offset=%.4g\n', TestGain, TestOff);
            d_irm.data.values = (d_irm.data.values - TestOff)/ TestGain;
        end
        
        Test = 1;
        pvname = ILC{i};
        ds = aa.getData(pvname, d1, d2);
        ds = aaepoch2datenum(ds);
        Start = datevec(ds.data.datenum(1));
        d_ilc = ds;
        t_ilc = (ds.data.datenum - ds.data.datenum(1)) + Start(3);
        % t_ilc = t_ilc - t_ilc(1);
        
        Test = 2;
        %if IRMTestFlag
            ibad = find((Gain(i) * d_irm.data.values + Offset(i)) < 1e-11);
            d_irm.data.values(ibad) = NaN;
        %end
        
        ibad = find(d_ilc.data.values<=0);
        d_ilc.data.values(ibad) = NaN;
        
       %ibad = find(d_ilc.data.values>1e-3);
       %d_ilc.data.values(ibad) = NaN;

        h = figure(1);  % was i
        clf reset
        %set(h, 'Units', 'Normalized');
        %p = get(h, 'Position');
        %p(3) = 1.2*p(3);
        %set(h, 'Position', p);
        %clf reset
        semilogy(t_ilc, d_ilc.data.values, '-b');
        hold on
        %if IRMTestFlag
            semilogy(t_irm, Gain(i) * d_irm.data.values + Offset(i), '-r');
        %else
        %    semilogy(t_irm, d_irm.data.values, '-r');
        %end
        hold off
        title(sprintf('%d.   %s    %s', i, ILC{i}, IRM{i}), 'Interpret', 'None');
        xlabel(sprintf('%s  to  %s   (%d points)   [Days]', datestr(ds.data.datenum(1),31), datestr(ds.data.datenum(end),31), length(ds.data.values)));
        
        if i == 3
            yaxis([1e-8 1e-7]);
        end
        
        if OffsetOrg(i) ~= Offset(i);
            addlabel(.5,.9,sprintf('Gain = %.5e   Offset = %.5e', Gain(i), OffsetOrg(i)), 12);
        else
            if Gain(i) ~= -2.6e-7
                addlabel(.5,.9,sprintf('Gain = %.5e', Gain(i)), 12);
            else
                addlabel(.5,.9,sprintf('Gain = %.1e', Gain(i)), 12);
            end
            % addlabel(.5,.9,sprintf('Gain = %.5e   Offset = %.5e', Gain(i), Offset(i)), 12);
        end
        hold off
        
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
    
    pause
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
