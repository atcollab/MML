%normalized injection rate

factor1=190/0.26;   %converts ACM1 to FARC (190 on FARC for 0.26 on ACM1)
factor2=190/0.22;   %converts ACM2 to FARC (190 on FARC for 0.22 on ACM2)
%factor of 13 is for injection efficiency (elog 12/28)
for k=1:10000
    rate=getpv('SPEAR:BeamLossRateMed');
    acm2=getpv('inj:BTS_ACM2.CURRENT_AM');
    efficiency=100*13*abs(rate)/(acm2*factor2);
    disp(['ACM2 : ' num2str(acm2,'%10.2f') '   Inj. Rate : ' num2str(rate,'%10.2f'),'    Injection Efficiency (%): ', num2str(efficiency,'%10.2f')]);
    pause(0.5);
end