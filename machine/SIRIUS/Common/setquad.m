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
    setsp(QuadFamily, QuadSetpoint, QuadDev, WaitFlag);
end
