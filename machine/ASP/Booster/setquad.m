function setquad(QMS, QuadSetpoint, WaitFlag)
% setquad(QMS, QuadSetpoint, WaitFlag)
% Used by quadcenter

if nargin < 2
    error('At least 2 inputs required');
end
if nargin < 3
    WaitFlag = -2;
end

QuadFamily = QMS.QuadFamily;
QuadDev = QMS.QuadDev;


setsp(QuadFamily, QuadSetpoint, QuadDev, WaitFlag); 
