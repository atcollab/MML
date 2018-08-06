function lnls_preload_passmethods

% Preload passmethods in order to avoid problems with loading recently
% compiled passmethods functions
%
% History:
%
% 2011-08-04: versão inicial (Ximenes)


global THERING;

THERING0 = THERING;

setradiation('off');
setcavity('off');

not_ready = true;
while not_ready
    try
        atpass(THERING, [0 0 0 0 0 0]',1,1);
        not_ready = false;
    catch
       if isempty(strfind(lasterr,'Library or function could not be loaded'))
            rethrow(lasterror);
       end
    end
end

setradiation('on');
setcavity('on');

not_ready = true;
while not_ready
    try
        atpass(THERING, [0 0 0 0 0 0]',1,1);
        not_ready = false;
    catch
       if isempty(strfind(lasterr,'Library or function could not be loaded'))
            rethrow(lasterror);
       end
    end
end

THERING = THERING0;