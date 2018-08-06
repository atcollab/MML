function setquad(QMS, QuadSetpoint, WaitFlag)
% setquad(QMS, QuadSetpoint, WaitFlag)


if nargin < 2
    error('At least 2 inputs required');
end

if nargin < 3
    WaitFlag = -2;
end

QuadFamily = QMS.QuadFamily;
QuadDev = QMS.QuadDev;


Mode = getfamilydata(QuadFamily, 'Setpoint', 'Mode');

if strcmpi(Mode,'Simulator')
    setsp(QuadFamily, QuadSetpoint, QuadDev, WaitFlag); 
else 
    if strcmpi(QuadFamily,'QD') | strcmpi(QuadFamily,'QDT')
%        setsp('QDT', QuadSetpoint, QuadDev, WaitFlag); 
        % QDT readback are not working
        setsp('QDT', QuadSetpoint, QuadDev, 0); 
        sleep(1);
    else
        error('Only QD has shunts.');
    end
end



