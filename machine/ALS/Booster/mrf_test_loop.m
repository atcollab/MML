function mrf_test_loop(varargin)
% function mrf_test_loop(varargin)
%
% Dummy function that copies Timing setpoints to soft PVs to work around
% 71->93 EPICS connectivity problem
%
% Christoph Steier, October 2012

while 1
    try
        if getpv('BR1_____TIMING_AC00')~=getpv('BR1_____TMPTIM_AC00')
            setpv('BR1_____TMPTIM_AC00',getpv('BR1_____TIMING_AC00'));
            disp('Setting Injection Trigger soft PV');
        end
        if getpv('BR1_____TIMING_AC01')~=getpv('BR1_____TMPTIM_AC01')
            setpv('BR1_____TMPTIM_AC01',getpv('BR1_____TIMING_AC01'));
            disp('Setting Bump Trigger soft PV');
        end
        if getpv('BR1_____TIMING_AC04')~=getpv('BR1_____TMPTIM_AC04')
            setpv('BR1_____TMPTIM_AC04',getpv('BR1_____TIMING_AC04'));
            disp('Setting Extraction Trigger soft PV');
        end
    catch
        warning('Failed copying MRF timing values');
    end
    fprintf('%s mrf_test_loop active\n',datestr(now));
    pause(1);
end