function Press=getpressure(Nflag)
% Press = getpressure(Nflag)
%
% gets the ring pressure [mbar]
% Nflag = 1 (default) at the ion gauges (***C___IG2)
% Nflag = 2 at the ion pumps (***C___IP1-6)
%

if nargin < 1
    Nflag = 1;
end

if Nflag == 1
    Press = getam('IonGauge');
else
    Press = getam('IonPump');
end

