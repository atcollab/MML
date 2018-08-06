%% Test of ArchiveData 
%
% This test makes assumptions about what your data server serves.
% In this example, key=4 points to ChannelArchiver/DemoData/index.


url = 'http://crconlnx1.als.lbl.gov:8080/RPC2';

names={ 'cmm:beam_current', 'SR01S___IBPM2X_AM02' }


%% Show Server Info
ml_arch_info(url);
[ver, desc, hows]=ml_arch_info(url);
h_raw=0;
h_sheet=1;
h_average=2;
h_plot=3;
h_linear=4;

%% List served archives (keys)
ml_arch_archives(url);
[keys,names,paths]=ml_arch_archives(url);

%% List channels of an archive
key=4;
ml_arch_names(url, key, 'IOC');
ml_arch_names(url, key, names{1});

%% Get data
%Data = ArchiveData(url, 'values', 4, 'cmm:beam_current')

ml_arch_get( url, key, names{1}, datenum(2008, 7, 18), datenum(2008, 7, 20), h_sheet, 20);
ml_arch_get( url, key, names{1}, datenum(2008, 7, 18), datenum(2008, 7, 20),  h_plot, 20);
ml_arch_plot(url, key, names{1}, datenum(2008, 7, 18), datenum(2008, 7, 20), h_plot, 500);


%% Get a channel that's an array
ml_arch_get(url, key, 'ExampleArray', datenum(2008, 7, 18), datenum(2008, 7, 8), h_raw, 20);
[times, micros, values] = ml_arch_get(url, key, 'ExampleArray', datenum(2008, 7, 18, datenum(2008, 8, 20), h_raw, 100);
xlabel('');
mesh(values(50:70,:));

pause;

%% Getting & handling 2 PVs at once, directly calling the mex/oct routine:
t0 = datenum(2003, 1, 18);
t1 = t0 + 2;
[out, in]=ArchiveData(url, 'values', key, names, t0, t1, 500, h_plot);
tin=in(1,:);
tout=out(1,:);
in=in(3,:);
out=out(3,:);
if is_matlab==1
    plot(tin, in*10, 'b-', tout, out, 'r-');
    legend('Klystron Input [10 W]', 'Klystron Output [kW]');
    datetick('x', 0);
else
    t0=min(tin(1),tout(1));
    [Y,M,D,h,m,s] = datevec(t0);
    day=floor(t0);
    xlabel(sprintf('Time on %02d/%02d/%04d [24h]', M, D, Y))
    plot(tin-day, in, '-;Klystron Input [10 W];', ...
         tout-day,out, '-;Klystron Output [kW];');
end

t0 = datenum(2003, 1, 19);
t1 = t0 + 2;
[out, in]=ArchiveData(url, 'values', key, names, t0, t1, 1000, h_average);
tin=in(1,:);
tout=out(1,:);
in=in(3,:);
out=out(3,:);
if length(tin) ~= length(tout) |  ~(isempty(find(tin-tout)))
    disp('TIME STAMPS OF THE 2 CHANNELS DO NOT MATCH');
end
gain=10*log10((out*1000)./in);
% Patch gain to remove e.g. +-Inf
gain(find(abs(gain) > 100)) = 0;
if is_matlab==1
    subplot(1,2,1);
    plot(tin, in*10, 'b-', tin, out, 'r-');
    legend('Input [10 W]', 'Output [kW]');
    datetick('x', 1);
    title('Klystron Input/Output');
    subplot(1,2,2);
    plot(out, gain, 'rd');
    xlabel('Klystron Output [kW]');
    ylabel('Gain [dB]');
    title('Klystron Gain');
else
    figure(1);
    t0=min(tin(1),tout(1));
    [Y,M,D,h,m,s] = datevec(t0);
    day=floor(t0);
    xlabel(sprintf('Time on %02d/%02d/%04d [24h]', M, D, Y))
    plot(tin-day, in, '-;Klystron Input [10 W];', ...
         tout-day,out, '-;Klystron Output [kW];');
    figure(2);
    xlabel('Klystron Output [kW]');
    ylabel('Gain [dB]');
    plot(out, gain, '*;;');
end

