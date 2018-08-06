function ManipBump(X)
idDevServMainPS1='ans-c05/ei/l-hu640_PS1';
idDevServCHE='ans-c05/ei/l-hu640_Corr2';
idDevServCHS='ans-c05/ei/l-hu640_corr1';
idDevServCVE='ans-c05/ei/l-hu640_corr4';
idDevServCVS='ans-c05/ei/l-hu640_corr3';

devemit = 'ANS-C02/DG/PHC-EMIT';
fprintf('%s\n','BUMP[mm]         Current[A]      EpsZ[nm.rd]     EpsX[pm.rd]     Couplage[%]     SigX[mic]       SigZ[mic]         TuneX         TuneZ')
PS1=0;
CVE=0;
CHE=0;
CVS=0;
CHS=0;

idSetCurrentSync(idDevServMainPS1, PS1, 0.3);
idSetCurrentSync(idDevServCVE, CVE, 0.01);
idSetCurrentSync(idDevServCHE, CHE, 0.01);
idSetCurrentSync(idDevServCVS, CVS, 0.01);
idSetCurrentSync(idDevServCHS, CHS, 0.01);

pause(5);
EmittanceV=readattribute([devemit '/EmittanceV']);
EmittanceH=readattribute([devemit '/EmittanceH']);
Couplage=readattribute([devemit '/Coupling']);
SigH=readattribute([devemit '/SrcPointSigmaH']);
SigV=readattribute([devemit '/SrcPointSigmaV']);
Tune=gettune;
fprintf('%8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\n',X,PS1,EmittanceV,EmittanceH, Couplage, SigH, SigV,Tune(1),Tune(2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PS1=-300;
CVE=-.0383;
CHE=-.032;
CVS=-.0143;
CHS=-.0685;

idSetCurrentSync(idDevServMainPS1, PS1, 0.3);
idSetCurrentSync(idDevServCVE, CVE, 0.01);
idSetCurrentSync(idDevServCHE, CHE, 0.01);
idSetCurrentSync(idDevServCVS, CVS, 0.01);
idSetCurrentSync(idDevServCHS, CHS, 0.01);

pause(5);
EmittanceV=readattribute([devemit '/EmittanceV']);
EmittanceH=readattribute([devemit '/EmittanceH']);
Couplage=readattribute([devemit '/Coupling']);
SigH=readattribute([devemit '/SrcPointSigmaH']);
SigV=readattribute([devemit '/SrcPointSigmaV']);
Tune=gettune;
fprintf('%8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\n',X,PS1,EmittanceV,EmittanceH, Couplage, SigH, SigV,Tune(1),Tune(2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PS1=-600;
CVE=-.0478;
CHE=-.0609;
CVS=-.0072;
CHS=-.1183;

idSetCurrentSync(idDevServMainPS1, PS1, 0.3);
idSetCurrentSync(idDevServCVE, CVE, 0.01);
idSetCurrentSync(idDevServCHE, CHE, 0.01);
idSetCurrentSync(idDevServCVS, CVS, 0.01);
idSetCurrentSync(idDevServCHS, CHS, 0.01);

pause(5);
EmittanceV=readattribute([devemit '/EmittanceV']);
EmittanceH=readattribute([devemit '/EmittanceH']);
Couplage=readattribute([devemit '/Coupling']);
SigH=readattribute([devemit '/SrcPointSigmaH']);
SigV=readattribute([devemit '/SrcPointSigmaV']);
Tune=gettune;
fprintf('%8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\n',X,PS1,EmittanceV,EmittanceH, Couplage, SigH, SigV,Tune(1),Tune(2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PS1=600;
CVE=.0645;
CHE=.0772;
CVS=.0191;
CHS=.1609;
idSetCurrentSync(idDevServMainPS1, PS1, 0.3);
idSetCurrentSync(idDevServCVE, CVE, 0.01);
idSetCurrentSync(idDevServCHE, CHE, 0.01);
idSetCurrentSync(idDevServCVS, CVS, 0.01);
idSetCurrentSync(idDevServCHS, CHS, 0.01);

pause(5);
EmittanceV=readattribute([devemit '/EmittanceV']);
EmittanceH=readattribute([devemit '/EmittanceH']);
Couplage=readattribute([devemit '/Coupling']);
SigH=readattribute([devemit '/SrcPointSigmaH']);
SigV=readattribute([devemit '/SrcPointSigmaV']);
Tune=gettune;
fprintf('%8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\n',X,PS1,EmittanceV,EmittanceH, Couplage, SigH, SigV,Tune(1),Tune(2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PS1=300;
CVE=.0388;
CHE=.0285;
CVS=.0195;
CHS=.0898;

idSetCurrentSync(idDevServMainPS1, PS1, 0.3);
idSetCurrentSync(idDevServCVE, CVE, 0.01);
idSetCurrentSync(idDevServCHE, CHE, 0.01);
idSetCurrentSync(idDevServCVS, CVS, 0.01);
idSetCurrentSync(idDevServCHS, CHS, 0.01);

pause(5);
EmittanceV=readattribute([devemit '/EmittanceV']);
EmittanceH=readattribute([devemit '/EmittanceH']);
Couplage=readattribute([devemit '/Coupling']);
SigH=readattribute([devemit '/SrcPointSigmaH']);
SigV=readattribute([devemit '/SrcPointSigmaV']);
Tune=gettune;
fprintf('%8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\n',X,PS1,EmittanceV,EmittanceH, Couplage, SigH, SigV,Tune(1),Tune(2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PS1=0;
CVE=0;
CHE=0;
CVS=0;
CHS=0;

idSetCurrentSync(idDevServMainPS1, 0, 0.3);
idSetCurrentSync(idDevServCVE, CVE, 0.01);
idSetCurrentSync(idDevServCHE, CHE, 0.01);
idSetCurrentSync(idDevServCVS, CVS, 0.01);
idSetCurrentSync(idDevServCHS, CHS, 0.01);

pause(5);
EmittanceV=readattribute([devemit '/EmittanceV']);
EmittanceH=readattribute([devemit '/EmittanceH']);
Couplage=readattribute([devemit '/Coupling']);
SigH=readattribute([devemit '/SrcPointSigmaH']);
SigV=readattribute([devemit '/SrcPointSigmaV']);
Tune=gettune;
fprintf('%8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\t %8.4f\n',X,PS1,EmittanceV,EmittanceH, Couplage, SigH, SigV,Tune(1),Tune(2));
