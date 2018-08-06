function Data=get_dpsc_current_waveforms(varargin)
% function [Data]=get_dpsc_current_waveforms(varargin)

% Swap table is not necessary anymore with Eric Norum's new EPICS interface
%setpv('BR1:B:SWAP_TABLE',1);
% pause(0.5);

%[BENDwave, ~, ts] = getpv('BR1:B:RAMPI', 'waveform');
[BENDwave, BENDts] = lcaGet('BR1:B:RAMPI',0,'int32');
timevecBEND=(0:(length(BENDwave)-1))/97720;
Data.Data(:,1)=125*(BENDwave*10/2^23)*1.23395+19.35;
Data.Timevec=timevecBEND;

Data.TimeStep=1/97720;

%setpv('BR1:QF:SWAP_TABLE',1);
% pause(0.5);
[QFwave, QFts] = lcaGet('BR1:QF:RAMPI',0,'int32');
Data.Data(:,2)=60*(QFwave*10/2^23)*1.2275+9.37;

%setpv('BR1:QD:SWAP_TABLE',1);
% pause(0.5);
[QDwave, QDts] = lcaGet('BR1:QD:RAMPI',0,'int32');
Data.Data(:,3)=60*(QDwave*10/2^23)*1.228+9.25;


if nargout == 0
    plot(Data.Timevec,Data.Data)
    xlabel('Time [Seconds]')
    ylabel('Time [Amps]')
    legend(sprintf('%s  BEND', datestr(labca2datenum(BENDts),'yyyy-mm-dd HH:MM:SS.fff')), sprintf('%s  QF', datestr(labca2datenum(QFts),'yyyy-mm-dd HH:MM:SS.fff')), sprintf('%s  QD', datestr(labca2datenum(QDts),'yyyy-mm-dd HH:MM:SS.fff')))
    title('BR Waveforms')
end
