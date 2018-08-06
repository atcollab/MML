% topoff_bts_bpm_attn_switch.m
%
% This routine reads the gun width setting to distinguish between single
% and multibunch injections and changes the BTS transfer line BPM gain
% settings accordingly (to try to avoid intensity dependent fake BPM
% offsets).

setpathals('BTS');

while 1
    if getpv('GTL_____TIMING_AC02')>20
        setpv('BPM','Attn',14);
    else
        setpv('BPM','Attn',8);
    end
    
    pause(1.4)
end