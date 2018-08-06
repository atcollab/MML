function [tbt, adc, Ts] = getblmtbt(varargin)

NextTriggerFlag = 0;

if nargin >= 1
    NextTriggerFlag = varargin{1};
end

if NextTriggerFlag
    % Get the starting time stamp
    [tbt, adc, Ts0] = getblmtbt(0);
    fprintf('   TbT A time stamp:  %s  (waiting for a sizeable beam loss)\n', datestr(Ts0(1)));
    
    % Set the acqtrigger:source to arm the waveform recorder
    setpv('sr02blm:triggers:t2:source', 2); % 0>Off  1->Ext  2->Int  3->Pulse  4->LXI  5->RTC
    setpv('sr02blm:acqtrigger:source',  2); % 0>Off  1->T2(depends on T2 Source)  2->Auto (uses threshold)
    
    % Wait for a new time
    t0 = clock;
    Ts = Ts0;
    while Ts(1)==Ts0(1) || Ts(2)==Ts0(2) || Ts(3)==Ts0(3) || Ts(4)==Ts0(4)
        pause(.2);
        [tbt, adc, Ts] = getblmtbt(0);
    end
    
    % Not sure why?
    setpv('sr02blm:signals:adc.PROC', 1);
    setpv('sr02blm:signals:sum.PROC', 1);
    pause(.5);

    fprintf('   TbT A time stamp:  %s  (waited %.1f seconds,  %.1f seconds from the last trigger)\n', datestr(Ts(1)), etime(clock,t0), 24*60*60*(Ts(1)-Ts0(1)));
    
    a = getpv('TimInjReq');
    fprintf('   SR Bucket %d  Gun Bunches %d  Injection Mode %d\n\n', a(1), a(2), a(3));
end

adc(1,:) = getpv('sr02blm:signals:adc.A');
adc(2,:) = getpv('sr02blm:signals:adc.B');
adc(3,:) = getpv('sr02blm:signals:adc.C');
adc(4,:) = getpv('sr02blm:signals:adc.D');

[tbt(1,:), ~, Ts(1,1)] = getpv('sr02blm:signals:sum.A');
[tbt(2,:), ~, Ts(2,1)] = getpv('sr02blm:signals:sum.B');
[tbt(3,:), ~, Ts(3,1)] = getpv('sr02blm:signals:sum.C');
[tbt(4,:), ~, Ts(4,1)] = getpv('sr02blm:signals:sum.D');
