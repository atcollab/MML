function [SP, AM] = getquad(QMS)
% [SP, AM] = getquad(QMS)
% Used by quadcenter


if nargin < 1
    QuadFamily = 'QD';
    QuadDev = [1 1];
else
    QuadFamily = QMS.QuadFamily;
    QuadDev = QMS.QuadDev;
end


Mode = getfamilydata(QuadFamily, 'Setpoint', 'Mode');

if strcmpi(Mode,'Simulator')
    SP = getsp(QuadFamily, QuadDev);
    if nargout >= 2
        AM = getam(QuadFamily, QuadDev);
    end
else
    if strcmpi(QuadFamily,'QD') | strcmpi(QuadFamily,'QDT')
        SP = getsp('QDT', QuadDev);

        if nargout >= 2
            AM = getam('QDT', QuadDev);
        end

    else
        error('Only QDT has an variable trim winding.');
    end
end
