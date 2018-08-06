%     simple_cam_bias_watchdog 
%
% This program optimizes LINAC settings (currently only the gun bias) to allow for larger single bunch (cam) current.
%
% Christoph Steier, September 2010

fprintf('Simple cam_bias_watchdog (%s): Watching target bucket and number of gun buckets and adjusting gun bias\n',datestr(now));
    
if (getpv('GTL_____TIMING_AM02')==12) 
    lastmode=1;
    startbias=40;
else
    lastmode=4;
    startbias=getpv('EG______BIAS___AC01');
end

   
while 1
    pause(1.44);
    if (getpv('GTL_____TIMING_AM02')==12)  && (lastmode==4)
        fprintf('Simple cam_bias_watchdog (%s): Switching to cam settings\n',datestr(now));
%        setpv('GTL_____TIMING_AC04',20);
        setpv('EG______BIAS___AC01',34);
    elseif (getpv('GTL_____TIMING_AM02')>12)  && (lastmode==1)
        fprintf('Simple cam_bias_watchdog (%s): Switching to multibunch settings\n',datestr(now));
%        setpv('GTL_____TIMING_AC04',70);
        setpv('EG______BIAS___AC01',startbias);
    end
    if (getpv('GTL_____TIMING_AM02')==12)
        lastmode=1;
    else
        lastmode=4;
    end
end

