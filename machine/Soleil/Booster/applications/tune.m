%function tune(istart)

%  reglage delta tune à 110 MeV

dtune = [0.0  0.0];        % dnu H  et dnu V

m1   =[ 0.88 0.125 ; 0.2  0.716 ] ;
kqp = m1*dtune' ;                    % DI QPF et QPD en A  
sprintf(' Courant delta-quadrupole      dQPF: %g A    et     dQPD: %g A', kqp)


temp = tango_read_attribute2('BOO/AE/QF', 'current');
qpf_inj = temp.value(2) + kqp(1);
tango_write_attribute('BOO/AE/QF', 'current', qpf_inj);
if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end
temp=tango_read_attribute2('BOO/AE/QD', 'current');
qpd_inj = temp.value(2) + kqp(2);
tango_write_attribute('BOO/AE/QD', 'current', qpd_inj);
if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end



