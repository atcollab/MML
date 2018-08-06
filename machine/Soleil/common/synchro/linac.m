function linac(mode)
% switch linac


load('synchro_offset_lin', 'inj_offset' , 'ext_offset', 'lin_fin');
tout=0.;


switch mode  % Get Tag of selected object
    case 'soft'
    % switch to soft
        event=int32(5) ;% adresse de l'injection
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',event); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent',int16(0));
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareEvent',int32(1)); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent',event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',event); pause(tout);
    % special modulateur
        temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay');pc=temp.value(1);
        temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');soft=temp.value(1);
        delay=inj_offset+soft-pc;
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareTimeDelay',delay);
        display('ok change 3Hz to soft')
        
    case '3Hz'
    % switch to 3Hz
        event=int32(2) ;% adresse de l'injection
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',int32(2)); pause(tout);
        tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent',int16(0)); 
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareEvent',event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent',event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',event); pause(tout);
        tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',event); pause(tout);
    % special modulateur
        delay=inj_offset+0;
        tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'spareTimeDelay',delay);
        display('ok change soft to 3Hz')
end

