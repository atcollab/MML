%%
switch2sim
IF =[7.59 7.52 7.52 7.45 7.35 7.35 7.35 7.27 7.09 7.08 7.03 6.98 6.92  ];
ID =[5.82 5.82 5.73 5.73 5.69 5.66 5.59 5.49 5.43 5.32 5.27 5.21 5.14  ];
nux0=[6.88 6.80 6.82 6.75 6.63 6.63 6.65 6.57 6.36 6.37 6.34 6.29 6.24  ];
nuz0=[4.77 4.77 4.69 4.75 4.67 4.64 4.54 4.53 4.44 4.32 4.27 4.22 4.14  ];
cas=1:length(IF);

brho=0.3679; %(ET=110.3)

QFI = findcells(THERING,'FamName','QPF');
QDI = findcells(THERING,'FamName','QPD');
for i=1:length(IF)

    GF=0.0465 + 0.0516*IF(i); KF=GF/brho;
    GD=0.0485 + 0.0518*ID(i); KD=-GD/brho;
    THERING = setcellstruct(THERING,'K',QFI,KF);
    THERING = setcellstruct(THERING,'K',QDI,KD);
    THERING = setcellstruct(THERING,'PolynomB',QFI, KF,2);
    THERING = setcellstruct(THERING,'PolynomB',QDI, KD,2);
    tune=gettune;nux(i)=tune(1);nuz(i)=tune(2);
    
end

figure(1)
subplot(2,1,1)
plot(cas,nux0,'ok',cas,nux,'ob')
ylim([6 7]);ylabel('nux');xlabel('case');
legend('Mesures','Model')
subplot(2,1,2)
plot(cas,nuz0,'ok',cas,nuz,'ob')
ylim([4 5]);ylabel('nuz');xlabel('case');
legend('Mesures','Model')


resx11=[6 7]; resy11=[4 5];
resx12=[6.5 6.5]; resy12=[4 5];
resx13=[6 7]; resy13=[4.5 4.5];
resx31=[6.667 6.667]; resy31=[4 5];
resx32=[6 7]; resy32=[4.667 4.667];
resx33=[6 8]; resy33=[5 4];
resx41=[6 7]; resy41=[4.5 5];
resx42=[6.5 7]; resy42=[4 5];
figure(2)
plot( resx11 , resy11 , '-k' ,... 
    resx12 , resy12 , '-k' ,... 
    resx13 , resy13 , '-k' ,... 
    resx31 , resy31 , '-r' ,...
    resx32 , resy32 , '-r', ...
    resx33 , resy33 , '-r', ...
    resx41 , resy41 , '-b', ...
    resx42 , resy42 , '-b')
xlim([6 7.]);ylim([4 5.]);
hold on
plot( nux0,nuz0,'ob','MarkerFaceColor','b' )
plot( nux,nuz,'or','MarkerFaceColor','r' )
hold off



