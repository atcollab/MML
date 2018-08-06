function get_orbit_stats()

c0 = 2.99792458e8; harm_num = 30;

BPMx = getbpm('X'); BPMy = getbpm('Y');
BPMx_m = mean(BPMx); BPMy_m = mean(BPMy);
BPMx_s = std(BPMx);  BPMy_s = std(BPMy);

HCMs = getsp('HCM'); VCMs = getsp('VCM');
HCMs_m = mean(HCMs); VCMs_m = mean(VCMs);
HCMs_s = std(HCMs); VCMs_s = std(VCMs);

[f_RF_sp f_RF_am] = getrf;

fprintf(1, '\n');
fprintf(1, 'f_RF = %10.7f MHz, C = %7.3f m\n', ...
        f_RF_sp, c0*harm_num/(1e6*f_RF_sp))
fprintf(1, '\n');
fprintf(1, 'x = %4.2f+/-%4.2f mm, y = %4.2f+/-%4.2f mm\n', ...
        BPMx_m, BPMx_s, BPMy_m, BPMy_s)
fprintf(1, '\n');
fprintf(1 ,'HCM = %4.2f+/-%4.2f A, VCM = %4.2f+/-%4.2f A\n', ...
        HCMs_m, HCMs_s, VCMs_m, VCMs_s)