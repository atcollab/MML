function [SP, AM] = getquad(QMS)
%GETQUAD - Get quadrupole setpoint (used by quadcenter)
%  [SP, AM] = getquad(QMS)
%
%  See also setquad, quadcenter


if nargin == 0
    error('At least 1 input is required');
end

QuadFamily = QMS.QuadFamily;
QuadDev    = QMS.QuadDev;

Mode = getfamilydata(QuadFamily,'Setpoint','Mode');


if strcmpi(Mode,'Simulator')
    % Simulator
    SP = getsp(QuadFamily, QuadDev);
    if nargout >= 2
        AM = getam(QuadFamily, QuadDev);
    end
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
    SP = getsp(QuadFamily, QuadDev);
    if nargout >= 2
        AM = getam(QuadFamily, QuadDev);
    end
end