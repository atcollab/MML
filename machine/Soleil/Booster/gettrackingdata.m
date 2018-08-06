function [D1 D2 QF QD itime] = gettrackingdata(varargin)
% GETTRACKING - get measured current on D1 D2 QD and QF
%
%  INPUTS
%
%
%  OUTPUTS
%  1. D1 -  Measured current on Dipole D1  in A
%  2. D2 -  Measured current on Dipole D2 in A
%  3. QF -  Measured current on quadrupole QF in A
%  4. QD -  Measured current on quadrupole QD in A
%  5. itime - Time base in seconds
%
% NOTES
% 1. Voltages are between -10 and 10 V and converted into amperes
% 2/ time base is reconstruced by reading frequency and bufferdepth on
% dserver tracking

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

devName = 'BOO/AE/tracking';
% use this function to assure synchronous reading
val = tango_read_attributes(devName, ...
    {'channel0','channel1','channel2','channel3','frequency','bufferDepth'});

if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end


% Gets numerical values for current (it is a voltage with is read)
% D.1 D.2 QF QD

D1 = val(1).value*-56; % -55 A/V
D2 = val(2).value*-56; % -55 A/V
QF = val(3).value*-25; % -25 A/V
QD = val(4).value*-25;  % -10 A/V

freq       = val(5).value(1); % read value
timeTot = val(6).value(1); % read value

itime = 0:1/freq:timeTot;
itime = itime(2:end);


if DisplayFlag
    subplot(2,1,1)
    plot(itime,(D1+D2)/2,itime,QF,itime,QD);
    grid on
    legend('(D1+D2)/2','QF','QD')
    xlabel('time (s)')
%     xlim([0.03 0.05])
    hold off
    ylabel('normalized voltage (-10V to 10 V)')
    title(['Dipole = ' num2str(max(D1+D2)/2) ' QF = ' num2str(max(QF)) ' QD = '  num2str(max(QD))])
    subplot(2,1,2)
    plot(itime,QD./((D1+D2)/2),itime,QF./((D1+D2)/2));
    %hold off
    xlim([0.0 0.03])
    grid on
    legend('QD/Dipole','QF/Dipole')
    xlabel('time (s)')
    ylabel('normalized voltage (-10V to 10 V)')
       
end