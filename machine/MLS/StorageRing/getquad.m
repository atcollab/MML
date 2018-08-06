function [SP, AM] = getquad(QMS)
%GETQUAD - Get quadrupole setpoint (used by quadcenter)
%  [SP, AM] = getquad(QMS)
%
%  See also setquad, quadcenter


if nargin == 0
    error('At least 1 input is required');
end

QuadFamily = QMS.QuadFamily;
QuadDev    = QMS.QuadDev;

Mode = getfamilydata(QuadFamily,'Setpoint','Mode');

if strcmpi(Mode,'Simulator')
    % Simulator
    SP = getsp(QuadFamily, QuadDev);
    if nargout >= 2
        AM = getam(QuadFamily, QuadDev);
    end
else
    % Online
    quad_muxport  = getfamilydata(QuadFamily,'Muxport',QuadDev);
    akt_muxport   = getquadmux('number');
    if (quad_muxport == akt_muxport)
        is_sel_mux = 1;
    else
        is_sel_mux=0;
    end
    
    % Quad Raw Data
    SP = getsp(QuadFamily, QuadDev);
    AM = getam(QuadFamily, QuadDev);

    % If Quadmux is on Quadrupole, add the offset
    if is_sel_mux
        SP = SP + getpvonline('QSPAZRP:setCur');
        AM = AM + getpvonline('QSPAZRP:rdCur');
    end

    if nargout >= 2
        AM = getam(QuadFamily, QuadDev);
    end
end