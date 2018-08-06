% Input termination impedance (0->1MOhm, 1->50 Ohms)
InputImpedance = 1;
setpv('sr02blm:termination:A_sp', InputImpedance);
setpv('sr02blm:termination:B_sp', InputImpedance);
setpv('sr02blm:termination:C_sp', InputImpedance);
setpv('sr02blm:termination:D_sp', InputImpedance);

% Attenuation
Attn = [31 31 31 31];
setpv('sr02blm:att:A_sp', Attn(1));
setpv('sr02blm:att:B_sp', Attn(2));
setpv('sr02blm:att:C_sp', Attn(3));
setpv('sr02blm:att:D_sp', Attn(4));

% ADC Mask - not sure what's best here
%setpv('sr02blm:adcmask:offset', 0);
%setpv('sr02blm:adcmask:window', 16);

% Vgc to the BLD (PMT) (0 to 1)
Vgc = .4;
setpv('sr02blm:bld:vgc:A_sp', Vgc);
setpv('sr02blm:bld:vgc:B_sp', Vgc);
setpv('sr02blm:bld:vgc:C_sp', Vgc);
setpv('sr02blm:bld:vgc:D_sp', Vgc);

% Decimation factor
% 82 for 1 turn (82 x 8ns = 656 ns)
% Note: it's not locked to the RF
setpv('sr02blm:decimation:sum_sp', 82);

% SA decimation     (Default: 524288)
% The closest to .1 SA is 17 -> 131072
%setpv('sr02blm:decimation:sa', 152439) is not directly setable!!!
%setpv('sr02blm:decimation:sa:n_sp') (Default 19)
setpv('sr02blm:decimation:sa:n_sp', 17);

% Average waveform - not sure what's best here (Default: 4)
%setpv('sr02blm:decimation:avg:n', 4);

% Counter: Sample rate and Loss Threshold
setpv('sr02blm:decimation:counter_datarate_sp', 10);
setpv('sr02blm:threshold:loss_count_sp', -200);

% Triggering
TriggerThreshold = [-5000 -8190 -8190 -8190];
setpv('sr02blm:threshold:autotrig:A_sp', TriggerThreshold(1));
setpv('sr02blm:threshold:autotrig:B_sp', TriggerThreshold(2));
setpv('sr02blm:threshold:autotrig:C_sp', TriggerThreshold(3));
setpv('sr02blm:threshold:autotrig:D_sp', TriggerThreshold(4));

% Set the acqtrigger:source to arm the waveform recorder
setpv('sr02blm:triggers:t2:source_sp', 2); % 0>Off  1->Ext  2->Int  3->Pulse  4->LXI  5->RTC
setpv('sr02blm:acqtrigger:source_sp',  2); % 0>Off  1->T2(depends on T2 Source)  2->Auto (uses threshold)


% EPICS\sr02blm:triggers:t2:delay_sp




