trigcnt0=0;
trigcnt0b=0;

while 1
    trigcnt1=getpv('ztec13:Inp1WaveCount');
    trigcnt1b=getpv('ztec13:Inp3WaveCount');
    if (trigcnt1>trigcnt0) & (trigcnt1b>trigcnt0b)
                 ictdata=lcaGet('ztec13:Inp1ScaledWave',1000);
                 % btscharge=(-1.5*5)*min(ictdata);
                 [minict,ictind]=min(ictdata);
                 btscharge=sum(ictdata(ictind-40:ictind+40))/(-3.51)*0.2491;

                 ictdata2=lcaGet('ztec13:Inp3ScaledWave',1000);
                 % btscharge=(-1.5*5)*min(ictdata);
                 [minict2,ictind2]=min(ictdata2);
                 btscharge2=sum(ictdata2(ictind2-40:ictind2+40))/(-3.51)*0.0594;
                 fprintf('Efficiency = %f %%, %f %f %f %f\n',100*btscharge2/btscharge,getpvonline('BTS_____SCRAP1LAC01.RBV'),getpvonline('BTS_____SCRAP1RAC01.RBV'), ...
                     getpvonline('BTS_____SCRAP2LAC01.RBV'),getpvonline('BTS_____SCRAP2RAC01.RBV'));
                 
                 trigcnt0=trigcnt1;
                 trigcnt0b=trigcnt1b;
    end
end
                 
