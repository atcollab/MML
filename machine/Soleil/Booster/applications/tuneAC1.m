%function tune(istart)

%  reglage delta tune relatif
%       100     2.75    100
tunex=[ 0.0         0.       0.];
tunez=[ 0.0         0.0       0.0];
reset=0;
%              x       z
dtune_inj = [tunex(1)   tunez(1)];         % dnu H  et dnu V  injection   110 MeV
dtune_ext = [tunex(2)   tunez(2)];         % dnu H  et dnu V  extraction 2750 MeV
dtune_dow = [tunex(3)   tunez(3)];         % dnu H  et dnu V  retour      110 MeV
dtune     = [dtune_inj dtune_ext dtune_dow];

m1   =[1.1931   -0.1543 ; -0.2537    1.2602 ] ;              % dnux dnuz fonction de dIqf dIqd  a 110 MeV

acqf=200.*18.48/2*sin(18.48*.020);
acqd=150.*18.48/2*sin(18.48*.020);
r =110/2750;

% dtune = M *  QFoffset  QDoffset  QFcur  QDcur  delayQF  delay QD  (A et seconde)
M = [m1(1,1) m1(1,2)  r*m1(1,1) r*m1(1,2) -acqf*m1(1,1) -acqd*m1(1,2); ...
     m1(2,1) m1(2,2)  r*m1(2,1) r*m1(2,2) -acqf*m1(2,1) -acqd*m1(2,2); ...
     r*m1(1,1) r*m1(1,2) r*m1(1,1) r*m1(1,2) 0         0           ; ...
     r*m1(2,1) r*m1(2,2) r*m1(2,1) r*m1(2,2) 0         0           ; ...
     m1(1,1) m1(1,2)  r*m1(1,1) r*m1(1,2) acqf*m1(1,1) acqd*m1(1,2); ...
     m1(2,1) m1(2,2)  r*m1(2,1) r*m1(2,2) acqf*m1(2,1) acqd*m1(2,2)];

sol=inv(M)*dtune';
if reset==1;
    sol=[0 0 0 0 0 0];
end

fprintf('  ************************** \n')
fprintf('   OFFSET  QF = %g  A \n',sol(1) )
fprintf('   OFFSET  QD = %g  A \n',sol(2) )
fprintf('   CURRENT QF = %g  A \n',sol(3) )
fprintf('   CURRENT QD = %g  A \n',sol(4) )
fprintf('   DELAY   QF = %g  µs \n',sol(5)*1e+06 )
fprintf('   DELAY   QD = %g  µs \n ',sol(6)*1e+06 )




 temp=tango_read_attribute2('BOO/AE/QD', 'current');
 qpd_ext = temp.value(2) + sol(4);
 tango_write_attribute('BOO/AE/QD', 'current', qpd_ext);
  if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
 end
 temp=tango_read_attribute2('BOO/AE/QD', 'waveformOffset');
 qpd_inj = temp.value(2) + sol(2);
 tango_write_attribute('BOO/AE/QD', 'waveformOffset', qpd_inj);
 if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
 end
 
 
 temp=tango_read_attribute2('BOO/AE/QF', 'current');
 qpf_ext = temp.value(2) + sol(3);
 tango_write_attribute('BOO/AE/QF', 'current', qpf_ext);
 if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
 end

 temp = tango_read_attribute2('BOO/AE/QF', 'waveformOffset');
 qpf_inj = temp.value(2) + sol(1);
 tango_write_attribute('BOO/AE/QF', 'waveformOffset', qpf_inj);
 if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
 end
 

 temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay');
 delai_qf = temp(1) + sol(5)*1000000
 tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay',delai_qf);pause(0.5);
 %writeattribute('BOO/SY/CPT.1/delayCounter4',delai_qf)
 if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
 end
 
 temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay');
 delai_qd = temp + sol(6)*1000000
 tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay',delai_qd);pause(0.5);
 %writeattribute('BOO/SY/CPT.1/delayCounter3',delai_qd)
 if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
 end
 


