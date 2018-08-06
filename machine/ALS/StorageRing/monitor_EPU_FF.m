function monitor_EPU_FF(EPU_Sector)

while 1
    hcm_dacs = getpv('HCM','DAC',[EPU_Sector-1 8; EPU_Sector-1 10; EPU_Sector 1]);
    vcm_dacs = getpv('VCM','DAC',[EPU_Sector-1 8; EPU_Sector-1 10; EPU_Sector 1]);
    fprintf('HCM %.3f, %.3f, %.3f  VCM %.3f, %.3f, %.3f\n', hcm_dacs(1),hcm_dacs(2),hcm_dacs(3), vcm_dacs(1),vcm_dacs(2),vcm_dacs(3));
    pause(1)
end
