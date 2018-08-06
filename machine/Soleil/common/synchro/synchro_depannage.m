 %   synchro_depannage
 
 
%  writeattribute('BOO/AE/dipole/current',345);
%  writeattribute('BOO/AE/QF/current',201.7677);
%  writeattribute('BOO/AE/QD/current',162.611);pause(2);
%  writeattribute('BOO/AE/dipole/current',545);
 pause(2)
 tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
 pause(2)
%  writeattribute('BOO/AE/QD/current',062.611);
%  writeattribute('BOO/AE/QF/current',101.7677);
%  writeattribute('BOO/AE/dipole/current',345); pause(3);
%  writeattribute('BOO/AE/dipole/current',145); pause(3);
 
 
 
 