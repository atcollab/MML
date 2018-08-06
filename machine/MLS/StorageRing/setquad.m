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
    setquadmux(dev2common(QuadFamily, QuadDev));
    delta_Setpoint = QuadSetpoint-getsp(QuadFamily, QuadDev);
    setpvonline('QSPAZRP:setCur', delta_Setpoint);
end
