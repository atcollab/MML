function [scope]=initialize_scope(GPIB_addr)
% Initializes a scope object
%
% INPUTS
%   1. GPIB_addr - an optional agrument for the scope GPIB address
%
% OUTPUTS
%   1. scope - a scope object used to collect data from the bpm scope
%
% NOTES
% Edited July 2017 by Levon D.
% -- added a check to see if setpath already initialized the scope
%

% check if scope has already been initialized by setpath
if nargin < 1
    GPIB_addr = 1;
end

if GPIB_addr==8 % BPM scope
ad = getad;
try
    scope = ad.wcm;
    return
catch
    % no scope, continue on
end
end


%DPO7254 Scope Initialization
scope.yData1=[]; 
scope.xData1=[];
scope.yData2=[]; 
scope.xData2=[];
scope.yData3=[]; 
scope.xData3=[];
scope.yData4=[]; 
scope.xData4=[];

scope.xUnits1=[];
scope.yUnits1=[];
scope.xUnits2=[];
scope.yUnits2=[];
scope.xUnits3=[];
scope.yUnits3=[];
scope.xUnits4=[];
scope.yUnits4=[];

% Instrument control variables
scope.interfaceObj = [];
scope.deviceObj = [];
scope.channelObj = [];
scope.waveformObj = [];
scope.channelObj1 = []; 
%waveformObj1 = [];



% The Tektronix DPO 7254 oscilloscope
scope.interfaceObj = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', GPIB_addr, 'Tag', '');

if isempty(scope.interfaceObj)
    scope.interfaceObj = gpib('NI', 0, GPIB_addr);
else
    fclose(scope.interfaceObj);
    scope.interfaceObj = scope.interfaceObj(1);
end

fclose(scope.interfaceObj);  %temporarily close the scope to set buffersize

set(scope.interfaceObj,'InputBufferSize',2e6);
set(scope.interfaceObj,'OutputBufferSize',2e6);

fopen(scope.interfaceObj);

scope.deviceObj = icdevice('DPO7254.mdd', scope.interfaceObj);
%connect(scope.deviceObj);
%if ad.bpm_scope_avg == 16
%    set(scope.deviceObj.Acquisition,'NumberOfAverages',16);
%end

fprintf(scope.interfaceObj,'DAT:STOP 100000') 

scope.channelObj3 = scope.deviceObj.Channel(3); % read from channel 3
scope.waveformObj3 = scope.deviceObj.Waveform(1);  % default  waveform measurement 3
























