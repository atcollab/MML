function [BeamMode,Energy,Current,Lifetime,AmpHour]=GetSPEAR3Params(mode)
%GetSPEAR3Params
%[BeamMode,Energy,Current,Lifetime,AmpHour]=GetSPEAR3Params(struct,mode)

if strcmpi(mode,'online')
    BeamMode= getpv('SPEAR:BeamStatus  ');
    Energy  = getpv('SPEAR:Energy      ');
    Current = getpv('SPEAR:BeamCurrAvg ');
    Lifetime= getpv('SPEAR:BeamLifetimeMed');
    AmpHour = Current*Lifetime/1000;   %current returned in mA
elseif strcmpi(mode,'simulator')
    BeamMode=0;
    Energy=3;
    Current=0.1;
    Lifetime=10;
    AmpHour=1;
end
 
        