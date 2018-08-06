function [AM, tout, DataTime, ErrorFlag] = getsp_ILCTrimQF(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getsp_ILCTrimQF(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%

% To use the server the following programs must be running:
% y:\opstat\win\Hiroshi\release\BRQLinCor.exe
% y:\opstat\win\Hiroshi\release\BRQLinCorServer.exe
%
% The other option is to go directly to Hiroshi's file

FileMethod = 1;


if FileMethod
    % File method
    if ispc
        %FileName = '\\Als-filer\crdata\Machine Data\Semaphore\BRQuadServer\QFWDAT.txt';
        FileName = '\\Als-filer\physbase\hlc\BR\RampTables\Semaphore\BRQuadServer\QFWDAT.txt';
    else
        FileName = '/home/als/physbase/hlc/BR/RampTables/Semaphore/BRQuadServer/QFWDAT.txt';
    end
    
    tout = 0;
    DataTime = now;
    
    try
        d = importdata(FileName, ' ', 1);
        AM = d.data(:,2);
        ErrorFlag = 0;
    catch
        fprintf(2,'%s\n',lasterr);
        AM = NaN * ones(100,1);
        ErrorFlag = 1;
    end
    
else
    
    % Server method
    setpv('HN:BR:QFRAQ', 0);
    setpv('HN:BR:QFRRQ', 0);
    pause(.3);
    setpv('HN:BR:QFRRQ', 1);
    %pause(2);
    
    
    for i = 1:100
        %fprintf('HN:BR:QFRAQ = %d, %f\n',getpv('HN:BR:QFRAQ'), toc);
        pause(.1);
        if getpv('HN:BR:QFRAQ') == 1
            break;
        end
    end
    
    if getpv('HN:BR:QFRAQ') ~= 1
        error('HN:BR:QFRAQ is not 1');
    end
    
    for i = 1:100
        PVnames(i,:) = sprintf('HN:BR:QF%02d', i-1);
    end
    
    [AM, tout, DataTime, ErrorFlag] = getpv(PVnames);
    
    setpv('HN:BR:QFRAQ', 0);
    setpv('HN:BR:QFRRQ', 0);
    
    
    % Row vector
    AM = AM(:)';
    DataTime = DataTime(:)';
    
    
    % Convert to amps
    AM = AM * (1.36 / 10);
end

