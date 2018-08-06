function [AM, tout, DataTime, ErrorFlag] = getsp_ILCTrimQD(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getsp_ILCTrimQD(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%
% The following programs must be running:
% y:\opstat\win\Hiroshi\release\BRQLinCor.exe
% y:\opstat\win\Hiroshi\release\BRQLinCorServer.exe
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
        FileName = '\\Als-filer\physbase\hlc\BR\RampTables\Semaphore\BRQuadServer\QDWDAT.txt';
    else
        FileName = '/home/als/physbase/hlc/BR/RampTables/Semaphore/BRQuadServer/QDWDAT.txt';
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
    setpv('HN:BR:QDRAQ', 0);
    setpv('HN:BR:QDRRQ', 0);
    pause(.3);
    setpv('HN:BR:QDRRQ', 1);
    %pause(2);
    
    
    for i = 1:100
        %fprintf('HN:BR:QDRAQ = %d, %f\n',getpv('HN:BR:QDRAQ'), toc);
        pause(.1);
        if getpv('HN:BR:QDRAQ') == 1
            break;
        end
    end
    
    if getpv('HN:BR:QDRAQ') ~= 1
        error('HN:BR:QDRAQ is not 1');
    end
    
    for i = 1:100
        PVnames(i,:) = sprintf('HN:BR:QD%02d', i-1);
    end
    
    [AM, tout, DataTime, ErrorFlag] = getpv(PVnames);
    
    setpv('HN:BR:QDRAQ', 0);
    setpv('HN:BR:QDRRQ', 0);
    
    
    % Row vector
    AM = AM(:)';
    DataTime = DataTime(:)';
    
    
    % Convert to amps
    AM = AM * (1.36 / 10);
end

