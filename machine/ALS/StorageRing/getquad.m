function [SP, AM] = getquad(QMS, ModeFlag)
% [SP, AM] = getquad(QMS, ModeFlag)
% Used by quadcenter
%
%  See also setquad



if nargin < 1
    QuadFamily = 'QF';
    QuadDev = [1 1];
else
    QuadFamily = QMS.QuadFamily;
    QuadDev = QMS.QuadDev;
end


if nargin < 2
    ModeFlag = getfamilydata(QuadFamily, 'Setpoint', 'Mode');
end

if any(strcmpi(ModeFlag, {'Simulator', 'Model'})) | ~strcmpi(QuadFamily,'QFA')
    
    SP = getsp(QuadFamily, QuadDev, ModeFlag);
    if nargout >= 2
        AM = getam(QuadFamily, QuadDev, ModeFlag);
    end
    
else
    
    % The QFA family is on a shunt
    if strcmpi(QuadFamily,'QFA')
        SP = getpv('QFA', 'Shunt1Control', QuadDev) + getpv('QFA', 'Shunt2Control', QuadDev);
        if nargout > 1
            AM = getpv('QFA', 'Shunt1', QuadDev) + getpv('QFA', 'Shunt2', QuadDev);
        end
    else
        error('Only QFA has an shunt.');
    end
end
    