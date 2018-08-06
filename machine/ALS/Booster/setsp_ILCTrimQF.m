function ErrorFlag = setsp_ILCTrimQF(Family, Field, Data, DeviceList, WaitFlag, RampFlag)
% ErrorFlag = setsp_ILCTrimQF(Family, Field, Data, DeviceList, WaitFlag, RampFlag)
%
% The following programs must be running:
% y:\opstat\win\Hiroshi\release\BRQLinCor.exe
% y:\opstat\win\Hiroshi\release\BRQLinCorServer.exe
%


if length(Data) == 1
    Data = Data * ones(100,1);
end


% Convert to amps
Data = Data * ( 10 / 1.36);


setpv('HN:BR:QFWAQ', 0);
setpv('HN:BR:QFWRQ', 0);
pause(.3);


% Set the data
for i = 1:100
    PVnames(i,:) = sprintf('HN:BR:QF%02d', i-1);
end

ErrorFlag = setpv(PVnames, Data(:));


setpv('HN:BR:QFWRQ', 1);
%pause(2);


for i = 1:100
    %fprintf('HN:BR:QFWAQ = %d, %f\n',getpv('HN:BR:QFWAQ'), toc);
    pause(.1);
    if getpv('HN:BR:QFWAQ') == 1
        break;
    end
end


if getpv('HN:BR:QFWAQ') ~= 1
    error('HN:BR:QFWAQ is not 1');
end


setpv('HN:BR:QFWAQ', 0);
setpv('HN:BR:QFWRQ', 0);


