function Out = getsma100(varargin)
%GETSMA100 - Rohde & Schwarz single generator (SMA 100A)
%  Out = getSMA100(Field)

% Written by Greg Portmann

% RST, CLS

if nargin >= 1 && any(strcmpi(varargin{1}, {'All','Struct'}))
    % Structure output
    [Out.SetMainFrequency, tout, DataTime] = getpvonline('SMA100:1:SetMainFrequency');  % [mA]
    Out.SetClockFrequency = getpvonline('SMA100:1:SetClockFrequency');
    Out.SetPowerLevel     = getpvonline('SMA100:1:SetPowerLevel');    
    Out.SetOutputOnOff    = getpvonline('SMA100:1:SetOutputOnOff');
    
    Out.ID                = getpvonline('SMA100:1:IDN');
    Out.ID = char(Out.ID);
    
    %Out.GetSTB = getpvonline('SMA100:1:GetSTB');    % Output completion status
    %Out.GetESR = getpvonline('SMA100:1:GetESR');    % Output completion status
    %Out.GetESE = getpvonline('SMA100:1:GetESE');    % Output completion status
    %Out.GetSRE = getpvonline('SMA100:1:GetSRE');    % Output completion status
    %Out.GetOPC = getpvonline('SMA100:1:GetOPC');    % Output completion status

    %Out.SetESE = getpvonline('SMA100:1:SetESE');    % Output completion status
    %Out.SetSRE = getpvonline('SMA100:1:SetSRE');    % Output completion status

    Out.TimeStamp = labca2datenum(DataTime);
    Out.TimeStampStr = datestr(Out.TimeStamp, 31);
else
    Out = getpvonline('SMA100:1:SetMainFrequency');
end

% Controls
% 'SMA100:1:RST'    % Reset
% 'SMA100:1:CLS'    % SCPI clear status
% 'SMA100:1:SetESE' % SCPI enable event status
% 'SMA100:1:SetSRE' % SCPI enable service requests

% Monitors
% 'SMA100:1:IDN'
% 'SMA100:1:GetSTB'  % SCPI get status byte
% 'SMA100:1:GetESR'  % SCPI get event status
% 'SMA100:1:GetESE'  % SCPI enabled event status
% 'SMA100:1:GetSRE'  % SCPI enable service requests
% 'SMA100:1:GetOPC'  % Output completion status
% 'SMA100:1:'
% 'SMA100:1:'






