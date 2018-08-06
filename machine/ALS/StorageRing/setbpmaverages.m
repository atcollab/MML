function setbpmaverages(T, DeviceList)
%SETBPMAVERAGES - Sets the BPM sampling period [second]
%  setbpmaverages(T)
%
%  INPUTS
%  1. T - Data collection period of the BPMs in seconds
%  2. DeviceList - BPM device list {Default: All BPMs}
%
%  NOTES
%  1. In Simlutor mode, nothing is set
%  2. For Bergoz BPM's the sampling period is an effective sampling period.
%
%  See also getbpmaverages, getbpmtimeconstant, setbpmtimeconstant

%  Written by Greg Portmann


Mode = getfamilydata('BPMx','Monitor','Mode');

if ~strcmpi(Mode,'Simulator')
    % Not simulator

    if nargin < 1
        T = 0.5;
    end
    if nargin < 2
        DeviceList = family2dev('BPMx');
    end


    BPMNumAveragesPerOneSecondPeriod_OldStyle = 2 * 190;
    
    NAvg = floor(T * BPMNumAveragesPerOneSecondPeriod_OldStyle);
    NAvg(find(NAvg<1)) = 1;

    
    % Set the old style BPM averaging
    [tmp1, tmp2, i] = findrowindex(DeviceList, getbpmlist('nonBergoz'));
    if ~isempty(i)
        if length(NAvg) > 1
            NAvgOldStyle = NAvg(i);
        else
            NAvgOldStyle = NAvg;
        end

        setpv('BPMx', 'NumberOfAverages', NAvgOldStyle, DeviceList(i,:));
    end


    % Set the Bergoz style BPM by setting the time constant
    % BPMNumAveragesPerOneSecondPeriod_Bergoz = 2 * 2700;   % Bergoz BPMs used to have averaging (in the good old days)
    [tmp1, tmp2, i] = findrowindex(DeviceList, getbpmlist('Bergoz'));
    if ~isempty(i)
        % Bergoz style BPM - set time constant
        % 2.5 Time constants in T seconds should give reasonable results
        % since data is not considered fresh for 2.2*T (ie, 5.5 time constants)
        if length(T) > 1
            T = T(i);
        end
       setpv('BPMx', 'TimeConstant', T / 2.5, DeviceList(i,:));
    end

end

 



% setidbpmavg(IDBPMNumAverages {Default: 2700})
% This function sets up a bunch of storage ring parameters
% 5400 averages corresponds to 1 Hz data rate.
%
% This function is not used any longer (as of 9/02) because no IDBPMs or BBPMs
%		support averaging. Instead the timeconstants are set via setidbpmtimeconstant.m
% 9-25-02, Tom Scarvie
% 
% if nargin==0
%    IDBPMNumAverages = 2700;
% end
% 
% IDBPMlist = getlist('IDBPMx');
% 
% IDBPMs do not support averaging anymore, instead use setidbpmtimeconstant ....
% C. Steier, September 2001
%
% Set the IDBPM averaging
% for i=1:size(IDBPMlist,1)
%   Name = sprintf('SR%02dS___IBPM%dA_AC%d', IDBPMlist(i,1), IDBPMlist(i,2), 97+IDBPMlist(i,2));
%   scaput(Name, IDBPMNumAverages);
% end
%
% Other IDBPMs
% scaput('SR04S___IBPM3A_AC98', IDBPMNumAverages);
% scaput('SR04S___IBPM4A_AC99', IDBPMNumAverages);
%
% These channels are not used anymore. Instead, the BBPM timeconstants are set the same
%		as the IDBPM ones via the SRxxS___IBPM___AC00 channels.
% scaput('SR09C___BPM4AT_AC98', IDBPMNumAverages);
% scaput('SR09C___BPM5AT_AC99', IDBPMNumAverages);


% function setbpmavg(BPMNumAverages)
% % setbpmavg(IDBPMNumAverages {Default: 190})
% % This function sets the number of averages for all BPMs to BPMNumAverages
% % 380 averages corresponds to 1 Hz data rate.
% %
% 
% BPMlist = getlist('BPMx');
% 
% if nargin < 1
%    BPMNumAverages = 190;
% end
% 
% % Set the BPM averaging
% for i=1:size(BPMlist,1)
%    Name = sprintf('SR%02dC___BPMAVG%dAC99', BPMlist(i,1), BPMlist(i,2));
%    setpv(Name, BPMNumAverages);
% end
% 


