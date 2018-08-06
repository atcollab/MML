function monitor_FF(ID_sector)

while 1
    hcm_dacs = getpv('HCM','DAC',[ID_sector-1 8;ID_sector 1]);
        vcm_dacs = getpv('VCM','DAC',[ID_sector-1 8;ID_sector 1]);

    fprintf('HCM %.3f, %.3f  VCM %.3f, %.3f\n', hcm_dacs(1),hcm_dacs(2), vcm_dacs(1),vcm_dacs(2));
    pause(1)
end
