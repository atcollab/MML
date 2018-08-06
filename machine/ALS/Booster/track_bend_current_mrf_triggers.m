% track_bend_current_mrf_triggers
%
% Routine used for follow potential drift of booster bend magnet ramp / MRF timing system

f1=figure;
[b,a]=butter(1,0.1);
    
while 1
    bendI=get_dpsc_current_waveforms_cond;
    bendcurr=bendI.Data(1,1)+filter(b,a,bendI.Data(:,1)-bendI.Data(1,1));
    bendI.Data(:,1)=bendcurr;
    
    figure(f1)
    subplot(2,1,1)
    plot(bendI.Timevec,bendI.Data);
    xlabel('t [s]')
    ylabel('I [A]')
    legend('Bend','QF','QD');
    subplot(2,1,2)
    plot(bendI.Timevec,bendI.Data(:,1));
    xlabel('t [s]')
    ylabel('I [A]')
    axis([0 0.5 0 1010]);
    grid on;
    
    RFfreq=getpv('SR01C___FREQB__AM00')*1e6;
    
%     Dly1=getpvonline('BR1_____CONVTIM_AC00.VAL')/1e6;
%     Dly2=getpvonline('BR1_____CONVTIM_AC01.VAL')/1e6;
%     Dly3=getpvonline('BR1_____CONVTIM_AC04.VAL')/1e6;

    Dly1=getpvonline('GaussClockInjectionFieldTrigger')*4/RFfreq;
    Dly2=getpvonline('GaussClockExtractionFieldTrigger')*4/RFfreq-5.5e-3;
    Dly3=getpvonline('GaussClockExtractionFieldTrigger')*4/RFfreq;
    
    Curr=interp1(bendI.Timevec,bendI.Data(:,1),[Dly1 Dly2 Dly3],'linear','extrap');
    
    fprintf('Booster bend current injection = %.2f A (%.2f ms)\n',Curr(1),Dly1*1e3);
    fprintf('Booster bend current bump trigger = %.2f A (%.2f ms)\n',Curr(2),Dly2*1e3);
    fprintf('Booster bend current extraction = %.2f A (%.2f ms)\n',Curr(3),Dly3*1e3);
   
    setpvonline('Physics2',Curr(1));
    setpvonline('Physics3',Curr(2));
    setpvonline('Physics4',Curr(3));
    
    figure(f1)
    hold on
    plot([Dly1 Dly2 Dly3],Curr,'rx');
    hold off
    
    legendstr=sprintf('Curr = %.2f, %.2f, %.2f A',Curr);
    legend(legendstr,'Location','Best');
    
    pause(1.4);
end