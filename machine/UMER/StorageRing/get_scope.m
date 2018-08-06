function [scope_data]=get_scope(bpm_number,scope)
%##################################################################
% Returns scope data at given bpm.
%##################################################################

ad = getad;

%BPM MUX Initiallization and selection
%ni_mux_controller(num2str(bpm_number));
cytec_mux_controller(num2str(bpm_number))

%Delay used to pause scope before it samples
pause(ad.bpm_scope_pause) % grabbed from ad

%Retrieve sample from scope
[scope.yData1, scope.xData1, scope.yUnits1, scope.xUnits1] = invoke(scope.waveformObj1, 'readwaveform', scope.channelObj1.name);
[scope.yData2, scope.xData2, scope.yUnits2, scope.xUnits2] = invoke(scope.waveformObj2, 'readwaveform', scope.channelObj2.name);
[scope.yData3, scope.xData3, scope.yUnits3, scope.xUnits3] = invoke(scope.waveformObj3, 'readwaveform', scope.channelObj3.name);
[scope.yData4, scope.xData4, scope.yUnits4, scope.xUnits4] = invoke(scope.waveformObj4, 'readwaveform', scope.channelObj4.name);

scope_data(:,1)=transpose(scope.xData1); % these conver the data into 5 columns: t, ch1, ch2, ch3, ch4
scope_data(:,2)=transpose(scope.yData1); % by 25,000 lines of data.
scope_data(:,3)=transpose(scope.yData2);
scope_data(:,4)=transpose(scope.yData3);
scope_data(:,5)=transpose(scope.yData4);
scope_data(:,6)=transpose(scope.yData1+scope.yData2+scope.yData3+scope.yData4); % sum signal

%Clear all variables
clear scope.yData1 scope.yData2 scope.yData3 scope.yData4 scope.xData1 scope.xData2 scope.xData3 scope.xData4 
clear scope.yUnits1 scope.yUnits2 scope.yUnits3 scope.yUnits4 scope.xUnits1 scope.xUnits2 scope.xUnits3 scope.xUnits4


