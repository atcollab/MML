function setquad(QMS, QuadSetpoint, WaitFlag, ModeFlag)
%  setquad(QMS, QuadSetpoint, WaitFlag, ModeFlag)
%  Used by quadcenter
%
%  See also getquad

% Adapted by Laurent S. Nadolski from ALS

if nargin < 2
    error('At least 2 inputs required');
end

if nargin < 3
    WaitFlag = -2;
end

QuadFamily = QMS.QuadFamily;
QuadDev    = QMS.QuadDev;

if nargin < 4
    ModeFlag = getfamilydata(QuadFamily, 'Setpoint', 'Mode', QuadDev);
end

% Set the quadrupole
setsp(QuadFamily, QuadSetpoint, QuadDev, 0, ModeFlag);