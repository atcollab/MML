%...load fields of cellarray 'THERING'
%...into structure Optics for EXCEL display
%...RING2EXCEL

global THERING

%...first compute Twiss parameters
dp=0.0;
Optics=GetTwiss(THERING,dp);

NR=length(THERING);
%display ring tunes
disp(['Horizontal Tune: ', num2str(Optics.phix(NR),'%6.3f')]);
disp(['Vertical Tune:   ', num2str(Optics.phiy(NR),'%6.3f')]);

disp('Finished loading MATLAB structure ''Optics'''); Optics
disp('Generating EXCEL spreadsheet...');
STRUCT2EXCEL(Optics);