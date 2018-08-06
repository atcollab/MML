function [LifeTimeFast, LifeTimeMed, LifeTimeSlow, LifeMeasPeriodFast, LifeMeasPeriodMed, LifeMeasPeriodSlow] = getlifetime(LifeMeasPeriodFast, LifeMeasPeriodMed, LifeMeasPeriodSlow)
%GETLIFETIME - Returns the lifetime channel
%  [LifeTimeFast, LifeTimeMed, LifeTimeSlow, LifeMeasPeriodFast, LifeMeasPeriodMed, LifeMeasPeriodSlow] = getlifetime(LifeMeasPeriodFast, LifeMeasPeriodMed, LifeMeasPeriodSlow)
%
%  Fast measurement period can only be .1 .2 .5 1 2 5 10 seconds (presently .1 is has problems)


Mode = getfamilydata('DCCT','Monitor','Mode');
if strcmpi(Mode,'Simulator') | strcmpi(Mode,'Model') 
    LifeTimeFast = 6;
    LifeTimeMed = 6;
    LifeTimeSlow = 6;
    LifeMeasPeriodFast = 1;
    LifeMeasPeriodMed = 1;
    LifeMeasPeriodSlow = 1;
    return;
end

% Set data
if nargin >= 1
    if ischar(LifeMeasPeriodFast)
        setpv('SPEAR:DcctTrace.SCAN', LifeMeasPeriodFast);
    else
        switch LifeMeasPeriodFast
            case .1
                T = 9;
            case .2
                T = 8;
            case .5
                T = 7;
            case 1
                T = 6;
            case 2
                T = 5;
            case 5
                T = 4;
            case 10
                T = 3;
            otherwise
                error('Lifetime measurement period invalid hence no change made (see help getlifetime)');
        end
        setpv('SPEAR:DcctTrace.SCAN', T);
    end
end
if nargin >= 2
    setpv('SPEAR:BeamTimePeriodMed', LifeMeasPeriodMed);
end
if nargin >= 3
    setpv('SPEAR:BeamTimePeriodSlow', LifeMeasPeriodSlow);
end


% Get data
LifeTimeFast = getpv('SPEAR:BeamLifetime');
if nargout >= 2
    LifeTimeMed  = getpv('SPEAR:BeamLifetimeMed');
end
if nargout >= 3
    LifeTimeSlow = getpv('SPEAR:BeamLifetimeSlow');
end
if nargout >= 4
    LifeMeasPeriodFast = getpv('SPEAR:DcctTrace.SCAN');
    
    switch LifeMeasPeriodFast
        case 9
            LifeMeasPeriodFast = .1;
        case 8
            LifeMeasPeriodFast = .2;
        case 7
            LifeMeasPeriodFast = .5;
        case 6
            LifeMeasPeriodFast = 1;
        case 5
            LifeMeasPeriodFast = 2;
        case 4
            LifeMeasPeriodFast = 5;
        case 3
            LifeMeasPeriodFast = 10;
        otherwise
            LifeMeasPeriodFast = NaN
    end
    
end
if nargout >= 5
    LifeMeasPeriodMed = getpv('SPEAR:BeamTimePeriodMed');
end
if nargout >= 6
    LifeMeasPeriodSlow = getpv('SPEAR:BeamTimePeriodSlow');
end



