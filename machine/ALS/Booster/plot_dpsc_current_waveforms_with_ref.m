%
% plot_dpsc_current_waveforms_with_ref.m
%
% Routine to display plots of the DPSC waveforms (solid lines) and latest golden reference (dashed lines)
%

FileName = '\\Als-filer\physdata\matlab\srdata\powersupplies\BQFQD_ramping_20071031\BR_BQFQD_20091120.txt'

fid = fopen(FileName, 'r');
data.TimeStep = fscanf(fid, '%f', 1);
data.Line2    = fscanf(fid, '%f', 1);
data.Data     = fscanf(fid, '%f %f %f', [3 inf])';
fclose(fid);

figure('Name','BR Waveforms')
while 1
    bendI=get_dpsc_current_waveforms_cond;
    plot(bendI.Timevec,bendI.Data,'-',(1:length(data.Data))*data.TimeStep,[125*data.Data(:,1),60*data.Data(:,2:3)],'--');
    xlabel('t [s]')
    ylabel('I [A]')
    legend('Bend','QF','QD');
    
    pause(1.4);
end