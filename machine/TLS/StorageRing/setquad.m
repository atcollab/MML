function setquad(QMS, QuadSetpoint, WaitFlag)
%SETQUAD - Set quadrupole setpoint (used by quadcenter)
%  setquad(QMS, QuadSetpoint, WaitFlag)
%
%  See also getquad, quadcenter


if nargin < 2
    error('At least 2 inputs required');
end
if nargin < 3
    WaitFlag = -2;
end

QuadFamily = QMS.QuadFamily;
QuadDev    = QMS.QuadDev;

Mode = getfamilydata(QuadFamily,'Setpoint','Mode');

if strcmpi(Mode,'Simulator')
    % Simulator
    setsp(QuadFamily, QuadSetpoint, QuadDev, WaitFlag);
else
    % Online
    if strcmpi(QuadFamily,'QD1')
        if QuadDev(1,2) == 1
            QuadDev = [ QuadDev(1,1) 1];
        else
            QuadDev = [ QuadDev(1,1) 8];
        end

    elseif strcmpi(QuadFamily,'QF1')
        if QuadDev(1,2) == 1
            QuadDev = [ QuadDev(1,1) 2];
        else
            QuadDev = [ QuadDev(1,1) 7];
        end

    elseif strcmpi(QuadFamily,'QD2')
        if QuadDev(1,2) == 1
            QuadDev = [ QuadDev(1,1) 3];
        else
            QuadDev = [ QuadDev(1,1) 6];
        end

    elseif strcmpi(QuadFamily,'QF2')
        if QuadDev(1,2) == 1
            QuadDev = [ QuadDev(1,1) 4];
        else
            QuadDev = [ QuadDev(1,1) 5];
        end

    end

    QuadFamily = 'TrimQ';

    DeV = [
        1 6
        1 7
        1 8
        2 1
        2 2
        2 3
        ];


    for (i=1:6)
        if all(QuadDev(1,:) == DeV(i,:))
            setsp(QuadFamily, QuadSetpoint, QuadDev, WaitFlag);
            X = 0;
            break;
        end
        X = 1;
    end

    if (X == 1)
        if abs(QuadSetpoint) < 0.001 
            setsp(QuadFamily, 0, QuadDev, WaitFlag);
        else
            setsp(QuadFamily, X, QuadDev, WaitFlag);
        end
        sleep(2);
        ctl_set('RCMTPS',QuadSetpoint);
    end
end
