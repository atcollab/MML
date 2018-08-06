function load_synchro(file)

Directory = '/home/matlabML/measdata/Boosterdata/Datatemp';
pwdold = pwd;
cd(Directory);
load(file)
cd(pwdold);

tout=0.2;
if (length(timing.lin_lpm)==1)  % ancien
    tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTimeDelay',timing.sdc1);pause(tout);
    tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmTimeDelay',timing.lin_lpm);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigTimeDelay',timing.boo_bpm);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigTimeDelay',timing.boo_bpm);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigTimeDelay',timing.boo_bpm);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigTimeDelay',timing.boo_bpm);pause(tout);     
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceTimeDelay',timing.lt1_emittance);pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1TimeDelay',timing.lt1_mc1);pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2TimeDelay',timing.lt1_mc2);pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscTimeDelay',timing.lt1_osc);pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booTimeDelay',timing.boo_dcct);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigTimeDelay',timing.boo_nod);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigTimeDelay',timing.boo_sep_p_inj);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigTimeDelay',timing.boo_k_inj);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay',timing.boo_dp);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay',timing.boo_qf);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay',timing.boo_qd);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfTimeDelay',timing.boo_sf);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdTimeDelay',timing.boo_sd);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.RF.1', 'rfTimeDelay',timing.boo_rf);pause(tout);
    tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareTimeDelay',timing.sdc2);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigTimeDelay',timing.boo_dof_ext);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigTimeDelay',timing.boo_sep_p_ext);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigTimeDelay',timing.boo_sep_a_ext);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigTimeDelay',timing.boo_k_ext);pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigTimeDelay',timing.lt2_bpm);pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctTimeDelay',timing.lt2_osc);pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvTimeDelay',timing.lt2_emittance);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceTimeDelay',timing.lt2_emittance);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigTimeDelay',timing.ans_k1_inj);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigTimeDelay',timing.ans_k2_inj);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigTimeDelay',timing.ans_k3_inj);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigTimeDelay',timing.ans_k4_inj);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigTimeDelay',timing.ans_sep_p_inj);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigTimeDelay',timing.ans_sep_a_inj);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigTimeDelay',timing.ans_bpm01);pause(tout);
    tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm02);pause(tout);
    tango_write_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm03);pause(tout);
    tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm04);pause(tout);
    tango_write_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm05);pause(tout);
    tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm06);pause(tout);
    tango_write_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm07);pause(tout);
    tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm08);pause(tout);
    tango_write_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm09);pause(tout);
    tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm10);pause(tout);  
    tango_write_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm11);pause(tout);  
    tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm12);pause(tout);  
    tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm13);pause(tout);  
    tango_write_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm14);pause(tout);  
    tango_write_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm15);pause(tout);  
    tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm16);pause(tout);   
    tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctTimeDelay',timing.ans_dcct);pause(tout)
    
elseif (length(timing.lin_lpm)==2)  % nouveau avec spm
    display('off set')
    if isfield(timing,'inj_offset');inj_offset=timing.inj_offset;
       if isfield(timing,'ext_offset');ext_offset=timing.ext_offset;
           if isfield(timing,'lin_fin'   );
              lin_fin   =timing.lin_fin;
              FileName = fullfile(getfamilydata('Directory', 'Synchro'), 'synchro_offset_lin');
              save(FileName, 'inj_offset' , 'ext_offset', 'lin_fin');
           end
       end
    end
    display('Delay')
    tango_write_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay',timing.central_pc);
    tango_write_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay',timing.central_inj);
    tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay',timing.central_soft);
    tango_write_attribute2('ANS/SY/CENTRAL', 'ExtractionOffsetTimeValue',timing.central_ext);
    
    tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTimeDelay',timing.sdc1(1));pause(tout);
    tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmTimeDelay',timing.lin_lpm(1));pause(tout);
    tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareTimeDelay',timing.lin_modulateur(1));
    if isfield(timing,'lin_spm');tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacTimeDelay',timing.lin_spm(1));pause(tout);end
    tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigTimeDelay',timing.boo_bpm(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigTimeDelay',timing.boo_bpm(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigTimeDelay',timing.boo_bpm(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigTimeDelay',timing.boo_bpm(1));pause(tout);     
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceTimeDelay',timing.lt1_emittance(1));pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1TimeDelay',timing.lt1_mc1(1));pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2TimeDelay',timing.lt1_mc2(1));pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscTimeDelay',timing.lt1_osc(1));pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booTimeDelay',timing.boo_dcct(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigTimeDelay',timing.boo_nod(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigTimeDelay',timing.boo_sep_p_inj(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigTimeDelay',timing.boo_k_inj(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay',timing.boo_dp(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay',timing.boo_qf(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay',timing.boo_qd(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfTimeDelay',timing.boo_sf(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdTimeDelay',timing.boo_sd(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.RF.1', 'rfTimeDelay',timing.boo_rf(1));pause(tout);
    tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareTimeDelay',timing.sdc2(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigTimeDelay',timing.boo_dof_ext(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigTimeDelay',timing.boo_sep_p_ext(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigTimeDelay',timing.boo_sep_a_ext(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigTimeDelay',timing.boo_k_ext(1));pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigTimeDelay',timing.lt2_bpm(1));pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctTimeDelay',timing.lt2_osc(1));pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvTimeDelay',timing.lt2_emittance(1));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceTimeDelay',timing.lt2_emittance(1));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigTimeDelay',timing.ans_k1_inj(1));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigTimeDelay',timing.ans_k2_inj(1));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigTimeDelay',timing.ans_k3_inj(1));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigTimeDelay',timing.ans_k4_inj(1));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigTimeDelay',timing.ans_sep_p_inj(1));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigTimeDelay',timing.ans_sep_a_inj(1));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigTimeDelay',timing.ans_bpm01(1));pause(tout);
    tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm02(1));pause(tout);
    tango_write_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm03(1));pause(tout);
    tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm04(1));pause(tout);
    tango_write_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm05(1));pause(tout);
    tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm06(1));pause(tout);
    tango_write_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm07(1));pause(tout);
    tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm08(1));pause(tout);
    tango_write_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm09(1));pause(tout);
    tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm10(1));pause(tout);  
    tango_write_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm11(1));pause(tout);  
    tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm12(1));pause(tout);  
    tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm13(1));pause(tout);  
    tango_write_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm14(1));pause(tout);  
    tango_write_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm15(1));pause(tout);  
    tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm16(1));pause(tout);   
    tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctTimeDelay',timing.ans_dcct(1));pause(tout);
    display('Event')
    tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscEvent',int32(timing.sdc1(2)));pause(tout);
    tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',int32(timing.lin_lpm(2)));pause(tout);
    tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareEvent',int32(timing.lin_modulateur(2)));
    if isfield('timing','lin_spm');tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent',int16(timing.lin_spm(2)));pause(tout);end
    tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigEvent',int32(timing.boo_bpm(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigEvent',int32(timing.boo_bpm(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigEvent',int32(timing.boo_bpm(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigEvent',int32(timing.boo_bpm(2)));pause(tout);     
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent',int32(timing.lt1_emittance(2)));pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',int32(timing.lt1_mc1(2)));pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',int32(timing.lt1_mc2(2)));pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',int32(timing.lt1_osc(2)));pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',int32(timing.boo_dcct(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigEvent',int32(timing.boo_nod(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigEvent',int32(timing.boo_sep_p_inj(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigEvent',int32(timing.boo_k_inj(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpEvent',int32(timing.boo_dp(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfEvent',int32(timing.boo_qf(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdEvent',int32(timing.boo_qd(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfEvent',int32(timing.boo_sf(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdEvent',int32(timing.boo_sd(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.RF.1', 'rfEvent',int32(timing.boo_rf(2)));pause(tout);
    tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareEvent',int32(timing.sdc2(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigEvent',int32(timing.boo_dof_ext(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigEvent',int32(timing.boo_sep_p_ext(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigEvent',int32(timing.boo_sep_a_ext(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigEvent',int32(timing.boo_k_ext(2)));pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigEvent',int32(timing.lt2_bpm(2)));pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctEvent',int32(timing.lt2_osc(2)));pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvEvent',int32(timing.lt2_emittance(2)));pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceEvent',int32(timing.lt2_emittance(2)));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigEvent',int32(timing.ans_k1_inj(2)));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigEvent',int32(timing.ans_k2_inj(2)));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigEvent',int32(timing.ans_k3_inj(2)));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigEvent',int32(timing.ans_k4_inj(2)));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigEvent',int32(timing.ans_sep_p_inj(2)));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigEvent',int32(timing.ans_sep_a_inj(2)));pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigEvent',int32(timing.ans_bpm01(2)));pause(tout);
    tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm02(2)));pause(tout);
    tango_write_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm03(2)));pause(tout);
    tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm04(2)));pause(tout);
    tango_write_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm05(2)));pause(tout);
    tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm06(2)));pause(tout);
    tango_write_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm07(2)));pause(tout);
    tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm08(2)));pause(tout);
    tango_write_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm09(2)));pause(tout);
    tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm10(2)));pause(tout);  
    tango_write_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm11(2)));pause(tout);  
    tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm12(2)));pause(tout);  
    tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm13(2)));pause(tout);  
    tango_write_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm14(2)));pause(tout);  
    tango_write_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm15(2)));pause(tout);  
    tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm16(2)));pause(tout);   
    tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctEvent',int32(timing.ans_dcct(2)));pause(tout);
 end
    

display('OK')


