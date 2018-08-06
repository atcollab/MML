function [timing]=get_synchro

n=1;
% central
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay');
timing.central_pc=temp.value(n);

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay');
timing.central_inj=temp.value(n);

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
timing.central_soft=temp.value(n);

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'ExtractionOffsetTimeValue');
timing.central_ext=temp.value(n);


% Linac
temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTimeDelay');
temp1=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'oscEvent');
timing.sdc1=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmTimeDelay');
temp1=tango_read_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent');
timing.lin_lpm=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacTimeDelay');
temp1=tango_read_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent');
timing.lin_spm=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('LIN/SY/LOCAL.LPM.1', 'spareTimeDelay');
temp1=tango_read_attribute2('LIN/SY/LOCAL.LPM.1', 'spareEvent');
timing.lin_modulateur=[temp.value(n) double(temp1.value(n))];


% LT1
temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceTimeDelay');
temp1=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent');
timing.lt1_emittance=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1TimeDelay');
temp1=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event');
timing.lt1_mc1=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2TimeDelay');
temp1=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event');
timing.lt1_mc2=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'oscTimeDelay');
temp1=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent');
timing.lt1_osc=[temp.value(n) double(temp1.value(n))];



% Boo
temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booTimeDelay');
temp1=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent');
timing.boo_dcct=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigEvent');
timing.boo_sep_p_inj=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigEvent');
timing.boo_k_inj=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigEvent');
timing.boo_bpm=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigEvent');
timing.boo_nod=[temp.value(n) double(temp1.value(n))];


% alim
temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpEvent');
timing.boo_dp=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfEvent');
timing.boo_qf=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdEvent');
timing.boo_qd=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfEvent');
timing.boo_sf=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdEvent');
timing.boo_sd=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('BOO/SY/LOCAL.RF.1', 'rfTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.RF.1', 'rfEvent');
timing.boo_rf=[temp.value(n) double(temp1.value(n))];





% ext
temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigEvent');
timing.boo_dof_ext=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigEvent');
timing.boo_sep_p_ext=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigEvent');
timing.boo_sep_a_ext=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigTimeDelay');
temp1=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigEvent');
timing.boo_k_ext=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'spareTimeDelay');
temp1=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'spareEvent');
timing.sdc2=[temp.value(n) double(temp1.value(n))];


% LT2
temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvTimeDelay');
temp1=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvEvent');
timing.lt2_emittance=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctTimeDelay');
temp1=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctEvent');
timing.lt2_osc=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigEvent');
timing.lt2_bpm=[temp.value(n) double(temp1.value(n))];


% ANS
temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigEvent');
timing.ans_k1_inj=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigEvent');
timing.ans_k2_inj=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigEvent');
timing.ans_k3_inj=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigEvent');
timing.ans_k4_inj=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigEvent');
timing.ans_sep_p_inj=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigEvent');
timing.ans_sep_a_inj=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctTimeDelay');
temp1=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctEvent');
timing.ans_dcct=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigEvent');
timing.ans_bpm=[temp.value(n) double(temp1.value(n))];
timing.ans_bpm01=[temp.value(n) double(temp1.value(n))];

temp=tango_read_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm02=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm03=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm04=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm05=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm06=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm07=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm08=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm09=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm10=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm11=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm12=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm13=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm14=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm15=[temp.value(n) double(temp1.value(n))];
temp=tango_read_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
temp1=tango_read_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigEvent');
timing.ans_bpm16=[temp.value(n) double(temp1.value(n))];


% offset
FileName = fullfile(getfamilydata('Directory', 'Synchro'), 'synchro_offset_lin');
load(FileName, 'inj_offset' , 'ext_offset', 'lin_fin');
timing.inj_offset=inj_offset;
timing.ext_offset=ext_offset;
timing.lin_fin   =lin_fin;



