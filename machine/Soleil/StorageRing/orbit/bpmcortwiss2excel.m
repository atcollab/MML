function twiss_excel
%execute spear3 init
%load Optics structure from GetTwiss2
%load bpm and cor structures
%dump bpm and cor structures to EXCEL

clear bpm cor
spear3init;                                                    %set up middleware and run sp3v81f deck
global THERING
Optics = GetTwiss2(THERING,0,1:length(THERING));               %load structure with optical parameters
Optics;                                                         %show what Optics contains
ATindx=ATIndex(THERING);                                       %AATindx has indices for each family

ibpm=ATindx.BPM;                                               %select BPMs
bpm.name    =Optics.name(ibpm,:);
bpm.name    =getfamilydata('BPMx','CommonNames');
bpm.status  =getfamilydata('BPMx','Status');
bpm.s       =Optics.s(ibpm);
bpm.phix    =Optics.phix(ibpm);
bpm.betax   =Optics.betax(ibpm);
bpm.alfax   =Optics.alfax(ibpm);
bpm.etax    =Optics.etax(ibpm);
bpm.phiy    =Optics.phiy(ibpm);
bpm.betay   =Optics.betay(ibpm);
bpm.alfay   =Optics.alfay(ibpm);
struct2excel(bpm)

icor=ATindx.COR;                                               %select CORs
cor.name    =Optics.name(icor,:);
cor.x_name  =getfamilydata('HCM','CommonNames');
cor.x_status=getfamilydata('HCM','Status');
cor.y_name  =getfamilydata('VCM','CommonNames');
cor.y_status=getfamilydata('VCM','Status');
cor.s       =Optics.s(icor);
cor.phix    =Optics.phix(icor);
cor.betax   =Optics.betax(icor);
cor.alfax   =Optics.alfax(icor);
cor.etax    =Optics.etax(icor);
cor.phiy    =Optics.phiy(icor);
cor.betay   =Optics.betay(icor);
cor.alfay   =Optics.alfay(icor);
struct2excel(cor)