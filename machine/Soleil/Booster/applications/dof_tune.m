

   r=0.99;
   temp=tango_read_attribute2('BOO-C10/EP/AL_DOF.1','voltagePeakValue');   dof1=temp.value(2);
   dof1t=dof1*r;
   writeattribute('BOO-C10/EP/AL_DOF.1/voltagePeakValue',dof1t);

   temp=tango_read_attribute2('BOO-C11/EP/AL_DOF.2','voltagePeakValue');   dof2=temp.value(2);
   dof2t=dof2*r;
   writeattribute('BOO-C11/EP/AL_DOF.2/voltagePeakValue',dof2t);
   
   temp=tango_read_attribute2('BOO-C12/EP/AL_DOF.3','voltagePeakValue');   dof3=temp.value(2);
   dof3t=dof3*r;
   writeattribute('BOO-C12/EP/AL_DOF.3/voltagePeakValue',dof3t);
   
   dd=[dof1 dof2  dof3]
   
   
    