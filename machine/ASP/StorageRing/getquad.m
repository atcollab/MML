function [SP, AM] = getquad(QMS)
% [SP, AM] = getquad(QMS)
% Used by quadcenter


if nargin < 1
    QuadFamily = 'QFA';
    QuadDev = [1 1];
else
    QuadFamily = QMS.QuadFamily;
    QuadDev = QMS.QuadDev;
end

SP = getsp(QuadFamily, QuadDev);

if nargout >= 2
    AM = getam(QuadFamily, QuadDev);
end
