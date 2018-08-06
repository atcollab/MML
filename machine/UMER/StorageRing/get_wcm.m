function [scope_data]=get_wcm(scope)
%##################################################################
% Returns scope data at given bpm.
% assumes WCM signal is on 3rd channel!
%##################################################################

ad = getad;
if ad.simFlag
    scope_data = [(1:1000)'*1e-9,rand(1000,1)]; % simulated random #s
    return
end

%Retrieve sample from scope
[scope.yData3, scope.xData3, scope.yUnits3, scope.xUnits3] = invoke(scope.waveformObj3, 'readwaveform', scope.channelObj3.name);

scope_data(:,1)=transpose(scope.xData3); % these conver the data into 5 columns: t, ch1, ch2, ch3, ch4
scope_data(:,2)=transpose(scope.yData3); % by 25,000 lines of data.

%Clear all variables
clear scope.yData1 scope.yData2 scope.yData3 scope.yData4 scope.xData1 scope.xData2 scope.xData3 scope.xData4 
clear scope.yUnits1 scope.yUnits2 scope.yUnits3 scope.yUnits4 scope.xUnits1 scope.xUnits2 scope.xUnits3 scope.xUnits4


