setoperationalmode(2);
global THERING_NOWIG
THERING_NOWIG = THERING;

ind = findcells(THERING,'FamName','ID');
mach_init = machine_at;
qfai = getsp('QFA','model');
qdai = getsp('QDA','model');
qfbi = getsp('QFB','model');

% ID12 Wiggler
idnum = 12;
% 18.16 mm
kx = 0.0003416;
ky = -0.0210746;
% 14.6 mm
% kx = 0.0005088;
% ky = -0.0281203;

THERING{ind(idnum)}.M66(2,1) = kx;
THERING{ind(idnum)}.M66(4,3) = ky;

initialisations = ['global THERING THERING_NOWIG;',...
    'qfaind = getfamilydata(''QFA'',''AT'',''ATIndex'',[11 2; 12 1]);',...
    'qdaind = getfamilydata(''QDA'',''AT'',''ATIndex'',[11 2; 12 1]);',...
    'qfbind = getfamilydata(''QFB'',''AT'',''ATIndex'',[11 2; 12 1]);',...
    'sfbind = getfamilydata(''SFB'',''AT'',''ATIndex'');'];

varget = {'getcellstruct(THERING,''K'',qfaind)';...
          'getcellstruct(THERING,''K'',qdaind)';...
          'getcellstruct(THERING,''K'',qfbind)'};
      
varset = {'THERING = setcellstruct(THERING,''PolynomB'',qfaind,variable,2); THERING = setcellstruct(THERING,''K'',qfaind,variable);';... 
          'THERING = setcellstruct(THERING,''PolynomB'',qdaind,variable,2); THERING = setcellstruct(THERING,''K'',qdaind,variable);';...
          'THERING = setcellstruct(THERING,''PolynomB'',qfbind,variable,2); THERING = setcellstruct(THERING,''K'',qfbind,variable);'};  

% varset = {'THERING = setcellstruct(THERING,''K'',qfaind,variable);';... 
%           'THERING = setcellstruct(THERING,''K'',qdaind,variable);'};  
      
paramget = {'std(machine_at(THERING,0,sfbind'',''betax''))';...
            'std(machine_at(THERING,0,sfbind'',''betay''))';...
            'std(machine_at(THERING,0,sfbind'',''etax'')*10)'};
        
goalparam = [0 0 0];

linearfit(varget,varset,paramget,goalparam,initialisations);
mach_final = machine_at;

% fittunedisp2([mach_init.nux(end) mach_init.nuy(end) mach_init.etax(end)],'QFA','QDA','QFB',1);

qfaf = getsp('QFA','model');
qdaf = getsp('QDA','model');
qfbf = getsp('QFB','model');

qfa_rel = qfaf./qfai;
qda_rel = qdaf./qdai;
qfb_rel = qfbf./qfbi;
