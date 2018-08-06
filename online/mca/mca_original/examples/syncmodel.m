function syncmodel(family)
global THERING
global QFI QDI SFI SDI qfh qdh sfh sdh
switch family
case 'QF'
    THERING = setcellstruct(THERING,'K',QFI,mcacache(qfh));
    THERING = setcellstruct(THERING,'PolynomB',QFI,mcacache(qfh),2);
case 'QD'
    THERING = setcellstruct(THERING,'K',QDI,mcacache(qdh));
    THERING = setcellstruct(THERING,'PolynomB',QDI,mcacache(qdh),2);
case 'SF'
    THERING = setcellstruct(THERING,'PolynomB',SFI,mcacache(sfh),3);
case 'SD'
    THERING = setcellstruct(THERING,'PolynomB',SDI,mcacache(sdh),3);
end