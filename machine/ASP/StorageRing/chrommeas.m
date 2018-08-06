alfa=.002;% Momentum compaction factor
frf=499670.833; % Master frequency in kHz

fnuxinit=403.2;% Frequency of horizontal tune signal in kHz before frequency shift
fnuyinit=303.6;% Frequency of vertical tune signal in kHz before frequency shift

nuxinit=fnuxinit/(frf/360);
nuyinit=fnuyinit/(frf/360); 

deltafrf=8;% Frequency shift 

fnuxfinal= 398.4;% Frequency of horizontal tune signal in kHz after frequency shift
fnuyfinal= 280.8;% Frequency of vertical tune signal in kHz after frequency shift


nuxfinal=fnuxfinal/((frf+deltafrf)/360); 
nuyfinal=fnuyfinal/((frf+deltafrf)/360); 




chromx=-alfa*(nuxfinal-nuxinit)*frf/deltafrf
chromy=-alfa*(nuyfinal-nuyinit)*frf/deltafrf