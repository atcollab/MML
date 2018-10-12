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

% if strcmpi(QuadFamily,'QFB')
%     del = QuadSetpoint-getsp(QuadFamily,QuadDev);
%     setsp(QuadFamily, getsp(QuadFamily,[QuadDev(1) 1; QuadDev(1) 2]) + del, [QuadDev(1) 1; QuadDev(1) 2], WaitFlag); 
% else
    setsp(QuadFamily, QuadSetpoint, QuadDev, WaitFlag);
% end
