function ErrorFlag = setsp_ILCTrimQD(Family, Field, Data, DeviceList, WaitFlag, RampFlag)
% ErrorFlag = setsp_ILCTrimQD(Family, Field, Data, DeviceList, WaitFlag, RampFlag)
%
% The following programs must be running:
% y:\opstat\win\Hiroshi\release\BRQLinCor.exe
% y:\opstat\win\Hiroshi\release\BRQLinCorServer.exe
%


if length(Data) == 1
    Data = Data * ones(100,1);
end


% Convert to amps
Data = Data * ( 10 / 1.18);


setpv('HN:BR:QDWAQ', 0);
setpv('HN:BR:QDWRQ', 0);
pause(.3);


% Set the data
for i = 1:100
    PVnames(i,:) = sprintf('HN:BR:QD%02d', i-1);
end

ErrorFlag = setpv(PVnames, Data(:));


setpv('HN:BR:QDWRQ', 1);
%pause(2);


tic
for i = 1:100
    %fprintf('HN:BR:QDWAQ = %d, %f\n',getpv('HN:BR:QDWAQ'), toc);
    pause(.1);
    if getpv('HN:BR:QDWAQ') == 1
        break;
    end
end


if getpv('HN:BR:QDWAQ') ~= 1
    error('HN:BR:QDWAQ is not 1');
end


setpv('HN:BR:QDWAQ', 0);
setpv('HN:BR:QDWRQ', 0);


