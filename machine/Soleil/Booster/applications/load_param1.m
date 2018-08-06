function [boo]=load_param

% save parameter
% alim
    boo.corrz = getam('VCOR');
    boo.corrx = getam('HCOR'); 
    boo.cv2=readattribute('LT1/AE/CV.2/current');
    boo.cv3=readattribute('LT1/AE/CV.3/current');  
    boo.DIPcurrent=readattribute('BOO/AE/D.1/current'        ,'Setpoint');
    boo.DIPoffset =readattribute('BOO/AE/D.1/waveformOffset' ,'Setpoint');
    boo.QFcurrent=readattribute('BOO/AE/QF/current'          ,'Setpoint');
    boo.QFpoffset =readattribute('BOO/AE/QF/waveformOffset'  ,'Setpoint');
    boo.QDcurrent=readattribute('BOO/AE/QD/current'          ,'Setpoint');
    boo.QDpoffset =readattribute('BOO/AE/QD/waveformOffset'  ,'Setpoint');
    boo.SFcurrent=readattribute('BOO/AE/SF/current'          ,'Setpoint');
    boo.SFpoffset =readattribute('BOO/AE/SF/waveformOffset'  ,'Setpoint');
    boo.SDcurrent=readattribute('BOO/AE/SD/current'          ,'Setpoint');
    boo.SDpoffset =readattribute('BOO/AE/SD/waveformOffset'  ,'Setpoint');
% ep
    temp=tango_read_attribute2('BOO-C01/EP/AL_K.Inj','voltage');            boo.KINJvoltage=temp.value(2);
    temp=tango_read_attribute2('BOO-C22/EP/AL_SEP_P.Inj','voltage');        boo.SPINJvoltage=temp.value(2);
    temp=tango_read_attribute2('BOO-C10/EP/AL_DOF.1','voltagePeakValue');   boo.DOF1EXTvoltage=temp.value(2);
    temp=tango_read_attribute2('BOO-C11/EP/AL_DOF.2','voltagePeakValue');   boo.DOF2EXTvoltage=temp.value(2);
    temp=tango_read_attribute2('BOO-C12/EP/AL_DOF.3','voltagePeakValue');   boo.DOF3EXTvoltage=temp.value(2);
    temp=tango_read_attribute2('BOO-C10/EP/AL_K.Ext','voltage');            boo.KEXTvoltage=temp.value(2);
    temp=tango_read_attribute2('BOO-C11/EP/AL_SEP_P.Ext.1','serialVoltage');boo.SPEXTvoltage=temp.value(2);
    temp=tango_read_attribute2('BOO-C12/EP/AL_SEP_A.Ext','voltage');        boo.SAEXTvoltage=temp.value(2);
    
    
    
% synchro
    temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay');
    boo.DIPdelay=temp.value(1);
    temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay');
    boo.QFdelay=temp.value(1);
    temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay');
    boo.QDdelay=temp.value(1);
% diag
      current=tango_read_attribute2('BOO-C01/DG/DCCT','iV');
      boo.current=current.value;
     xpos=tango_read_attribute2('BOO-C01/DG/BPM.01','XPosDD');
     boo.bpmx=xpos.value;
     zpos=tango_read_attribute2('BOO-C03/DG/BPM.02','ZPosDD');
     boo.bpmz=zpos.value;
