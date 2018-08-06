function [D QF QD itime] = gettrackinghall(varargin)
% GETTRACKINGHALL - get B-field measured with hallprobe  for Dipole, QD and QF
%
%  INPUTS
%
%
%  OUTPUTS
%  1. D -  Measured current on Dipole Dipole  in au
%  2. DF -  Measured current on Dipole QF in au
%  3. QD -  Measured current on quadrupole QD in au
%  4. itime - Time base in seconds
%
% NOTES
% 1. Voltages are between -10 and 10 V and converted into amperes
% 2/ time base is reconstruted by reading frequency and bufferdepth on
% dserver tracking

%
% Written by Laurent S. Nadolski

DisplayFlag = 1; 

% Input parser

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end

devName = 'BOO/AE/trackinghall';
% use this function to assure synchronous reading
val = tango_read_attributes(devName, ...
    {'channel0','channel1','channel2','frequency','bufferDepth'});

if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end


% Gets numerical values for current (it is a voltage with is read)
% D QF QD

D  = val(1).value; 
QF = val(2).value;
QD = val(3).value;

freq       = val(4).value(1); % read value
timeTot = val(5).value(1); % read value

itime = 0:1/freq:timeTot;
itime = itime(2:end);


if DisplayFlag
    subplot(2,1,1)
    plot(itime,D,itime,QF,itime,QD);
    grid on
    legend('D','QF','QD')
    xlabel('time (s)')
%     xlim([0.03 0.05])
    hold off
    ylabel('u a')
   % title(['Dipole = ' num2str(max(D1+D2)/2) ' QF = ' num2str(max(QF)) ' QD = '  num2str(max(QD))])
    subplot(2,1,2)
    plot(itime,QD./D,itime,QF./D);
    %hold off
    xlim([0.03 0.320])
    grid on
    legend('QD/Dipole','QF/Dipole')
    xlabel('time (s)')
    ylabel('normalized voltage (-10V to 10 V)')
       
end