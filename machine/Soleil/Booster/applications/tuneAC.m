%function tune(istart)

%  reglage delta tune à 110 MeV

dtune_inj = [-0.00     -0.1];                               % dnu H  et dnu V
dtune_ext = [+0.00   -0.0];                               % dnu H  et dnu V

m1   =[ 0.88 0.125 ; 0.2  0.716 ] ;
m2  =inv([ 1   1 ; 110/2750  1 ]) ;
k_inj  = m1*dtune_inj'    ;                    % DI QPF et QPD en A  
k_ext = m1*dtune_ext' *2750/110 ;              % DI QPF et QPD en A  
kqp_qf  = m2*[k_ext(1) ; k_inj(1)]                             % DI offset et cur QPF
kqp_qd = m2*[k_ext(2) ; k_inj(2)]                              % DI offset et cur QPD
sprintf(' Delta courant qf   :  offset  %g A    et      current:  %g A',   kqp_qf(2) , kqp_qf(1))
sprintf('Delta courant qd   :  offset  %g A     et      current:  %g A ', kqp_qd(2) , kqp_qd(2))

return

 temp=tango_read_attribute2('BOO/AE/QD', 'current');
 qpd_ext = temp.value(2) + kqp_qd(1);
 tango_write_attribute('BOO/AE/QD', 'current', qpd_ext);
  if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
 end
 temp=tango_read_attribute2('BOO/AE/QD', 'waveformOffset');
 qpd_inj = temp.value(2) + kqp_qd(2);
 if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
 end
 
 
 
 temp=tango_read_attribute2('BOO/AE/QF', 'current');
 qpf_ext = temp.value(2) + kqp_qf(1);
 tango_write_attribute('BOO/AE/QF', 'current', qpf_ext);
 if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
 end

 temp = tango_read_attribute2('BOO/AE/QF', 'waveformOffset');
 qpf_inj = temp.value(2) + kqp_qf(2);
 tango_write_attribute('BOO/AE/QF', 'waveformOffset', qpf_inj);
 if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end
 
% stepsp('QF', kqp(1));
% stepsp('QD', kqp(2));

% istart=100000;
% iend=istart+1*512+1;
% clear a xt zt
% a=getbpmrawdata( [1 2] ,'nodisplay','struct');
% 
% xt=a.Data.X(1,istart:iend); % +10*cos(2*3.14156*0.35*i);
% zt=a.Data.Z(2,istart:iend) ;
% 
% nf=iend-istart+1;
% fx=fft(xt); px=fx.*conj(fx)/nf; xf=(1:nf)/nf;
% fz=fft(zt); pz=fz.*conj(fz)/nf; zf=(1:nf)/nf;
% % fx=fft(xt,nf); px=fx.*conj(fx)/nf; xf=(1:nf/2)/nf;
% % fz=fft(zt,nf); pz=fz.*conj(fz)/nf; zf=(1:nf/2)/nf;
% clear max
% tunex=find(px==max(px))/nf
% clear max
% tunez=find(pz==max(pz))/nf
% 
% figure(1001)
% subplot(1,2,1)
% plot(xf(2:nf/2),px(2:nf/2)); ylim([0 1]);
% grid on
% subplot(1,2,2)
% plot(zf(2:nf/2),pz(2:nf/2))
% suptitle(['TuneX= ' num2str(tunex) '            TuneZ= ' num2str(tunez)]);
% grid on

