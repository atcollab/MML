% ACenergy

    r=1 ;   %en %
    
    
    
    val(1)=readattribute('BOO/AE/D.1/current'        ,'Setpoint');
    val(2)=readattribute('BOO/AE/QF/current'          ,'Setpoint');
    val(3)=readattribute('BOO/AE/QD/current'          ,'Setpoint');
    val(4)=readattribute('BOO/AE/SF/current'          ,'Setpoint');
    val(5)=readattribute('BOO-C10/EP/AL_DOF.1/voltagePeakValue');
    val(6)=readattribute('BOO-C11/EP/AL_DOF.2/voltagePeakValue');
    val(7)=readattribute('BOO-C12/EP/AL_DOF.3/voltagePeakValue');
    val(8)=readattribute('BOO-C10/EP/AL_K.Ext/voltage');
    val(9)=readattribute('BOO-C11/EP/AL_SEP_P.Ext.1/serialVoltage');
    val(10)=readattribute('BOO-C12/EP/AL_SEP_A.Ext/voltage');
    temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay');
    Tinj=temp.value(1);
    temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
    Tsoft=temp.value(1);
    
    
    val=val*(1+r/100);
    Tsoft
    Tinj =Tinj -  r*100 ;             %  1% = + 100 µs
    Tsoft=Tsoft-  r*100 ;            %  1% = + 100 µs
    Tsoft
    writeattribute('BOO/AE/D.1/current'        ,val(1));
    writeattribute('BOO/AE/QF/current'          ,val(2));
    writeattribute('BOO/AE/QD/current'          ,val(3));
    writeattribute('BOO/AE/SF/current'          ,val(4));
    writeattribute('BOO-C10/EP/AL_DOF.1/voltagePeakValue',val(5));
    writeattribute('BOO-C11/EP/AL_DOF.2/voltagePeakValue',val(6));
    writeattribute('BOO-C12/EP/AL_DOF.3/voltagePeakValue',val(7));
    writeattribute('BOO-C10/EP/AL_K.Ext/voltage',val(8));
    writeattribute('BOO-C11/EP/AL_SEP_P.Ext.1/serialVoltage',val(9));
    writeattribute('BOO-C12/EP/AL_SEP_A.Ext/voltage,',val(10));
    tango_write_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay',Tinj);
    tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay',Tsoft);
    