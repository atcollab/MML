function [SP, AM] = getquad(QMS, ModeFlag)
% [SP, AM] = getquad(QMS, ModeFlag)
% Used by quadcenter
%
%  See also getquad

%
%  Adapted by Laurent S. Nadolski from ALS

if nargin < 1
    QuadFamily = 'Q1';
    QuadDev = [1 1];
else
    QuadFamily = QMS.QuadFamily;
    QuadDev    = QMS.QuadDev;
end

if nargin < 2
    ModeFlag = getfamilydata(QuadFamily, 'Setpoint', 'Mode');
end

SP = getsp(QuadFamily, QuadDev, ModeFlag);
AM = getam(QuadFamily, QuadDev, ModeFlag);
