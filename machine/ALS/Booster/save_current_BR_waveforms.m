function save_current_BR_waveforms(varargin)
% function save_current_BR_waveforms(varargin)

if ispc
    cd \\Als-filer\physdata\matlab\BoosterData\19INJ\BR_supply_trips
else
    cd /home/als/physdata/matlab/BoosterData/19INJ/BR_supply_trips
end

% Swap table is not necessary anymore with Eric Norum's new EPICS interface
%setpv('BR1:B:SWAP_TABLE',1);
% pause(0.5);
BENDwave=lcaGet('BR1:B:RAMPI_COND',0,'int32');
timevecBEND=(0:(length(BENDwave)-1))/97720*16;
Data.Data(:,1)=125*(BENDwave*10/2^23)*1.23395+19.35;
Data.Timevec=timevecBEND;

Data.TimeStep=16/97720;

%setpv('BR1:QF:SWAP_TABLE',1);
% pause(0.5);
QFwave=lcaGet('BR1:QF:RAMPI_COND',0,'int32');
Data.Data(:,2)=60*(QFwave*10/2^23)*1.2275+9.37;

%setpv('BR1:QD:SWAP_TABLE',1);
% pause(0.5);
QDwave=lcaGet('BR1:QD:RAMPI_COND',0,'int32');
Data.Data(:,3)=60*(QDwave*10/2^23)*1.228+9.25;

filenamestr=sprintf('BR_trip_waveforms_%s.mat',datestr(now,30));
save(filenamestr,'BENDwave','QFwave','QDwave');

f1=figure;
plot(Data.Timevec,Data.Data)
axis tight
title(['BR waveforms (tripped supply should be static), ',datestr(now)]);
xlabel('time [s]')
ylabel('Current')
legend('BEND','QF','QD')

print(f1,'-dpng',sprintf('BR_trip_waveforms_%s.png',datestr(now,30)))
