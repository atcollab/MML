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
    SP = getsp(QuadFamily, QuadDev);
    if nargout >= 2
        AM = getam(QuadFamily, QuadDev);
    end
end