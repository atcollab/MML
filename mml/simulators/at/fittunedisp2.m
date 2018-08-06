function varargout =  fittunedisp2(newtunes_disp, quadfam1, quadfam2, quadfam3, dispind, varargin)
%FITTUNEDISP2 - Fits the linear tunes and the dispersion of model using 3 quadrupole families.  
%  fittune2([nux nuy disp], QUADFAMILY1, QUADFAMILY2, QUADFAMILY3, DISPIND)
% 
%  INPUTS
%  1. nux and nuy - the tunes (indlucing the integer parts)
%     disp        - dispersion at the position (AT index) given by DISPIND 
%  2. QUADFAMILY1 - Quadrupole family #1
%  3. QUADFAMILY2 - Quadrupole family #2
%  4. QUADFAMILY3 - Quadrupole family #3
%  5. DISPIND - AT index to measure dispersion 
%
%  ALGORITHM
%  Iteratively calculate the required quadrupole strengths to fit the new tunes and dispersion.

%  Written by Eugene Tan


% Must declare THERING as global in order for the function to modify quadrupole values 
global THERING
MAXDEPTH = 5;
threshold = 1e-9;
if nargin > 5 % use externally supplied step size for quadrupole K-values 
    delta = varargin{1};
else
    delta = 1e-6; % default step size for quadrupole K-values 
end
if nargin > 6
    recursion_depth = varargin{2};
else
    recursion_depth = 0;
end
try
    THERING{dispind};
catch
    fprintf('Invalid position/index to measure dispersion %d\n',dispind);
end

% find indexes of the 2 quadrupole families use for fitting
Q1I = findcells(THERING,'FamName',quadfam1);
if isempty(Q1I); fprintf('Cannot find quadfamily: %s\n',quadfam1); return; end;
Q2I = findcells(THERING,'FamName',quadfam2);
if isempty(Q2I); fprintf('Cannot find quadfamily: %s\n',quadfam2); return; end;
Q3I = findcells(THERING,'FamName',quadfam3);
if isempty(Q3I); fprintf('Cannot find quadfamily: %s\n',quadfam3); return; end;


InitialK1 = getcellstruct(THERING,'K',Q1I);
InitialK2 = getcellstruct(THERING,'K',Q2I);
InitialK3 = getcellstruct(THERING,'K',Q3I);
InitialPolB1 = getcellstruct(THERING,'PolynomB',Q1I,2);
InitialPolB2 = getcellstruct(THERING,'PolynomB',Q2I,2);
InitialPolB3 = getcellstruct(THERING,'PolynomB',Q3I,2);

% Compute initial tunes before fitting 
% [ LD, InitialTunes] = linopt(THERING,0);
mach = machine_at;
TempTunes = [mach.nux(end);mach.nuy(end)];
TempDisp  = mach.etax(1);
TempK1 = InitialK1;
TempK2 = InitialK2;
TempK3 = InitialK3;
TempPolB1 = InitialPolB1;
TempPolB2 = InitialPolB2;
TempPolB3 = InitialPolB3;

if recursion_depth == 0
    fprintf('\n==== Fitting Tunes and Dispersion ====\n');
    fprintf('Desired Tunes and Dispersion: %14.10f (H) %14.10f (V) %14.10f (D)\n',...
        newtunes_disp);
    fprintf('Initial Tunes and Dispersion: %14.10f (H) %14.10f (V) %14.10f (D)\n',...
        TempTunes(1),TempTunes(2),TempDisp);
    fprintf('Inital K values: %9.7f (%s) %9.7f (%s) %9.7f (%s)\n',...
        InitialK1(1), quadfam1, InitialK2(1), quadfam2, InitialK3(1), quadfam3);
end

% Take Derivative
THERING = setcellstruct(THERING,'K',Q1I,TempK1+delta);
THERING = setcellstruct(THERING,'PolynomB',Q1I,TempPolB1+delta,2);
mach = machine_at;
Tunes_dK1 = [mach.nux(end);mach.nuy(end)];
Disp_dK1 = mach.etax(1);
THERING = setcellstruct(THERING,'K',Q1I,TempK1);
THERING = setcellstruct(THERING,'PolynomB',Q1I,TempPolB1,2);

THERING = setcellstruct(THERING,'K',Q2I,TempK2+delta);
THERING = setcellstruct(THERING,'PolynomB',Q2I,TempPolB2+delta,2);
mach = machine_at;
Tunes_dK2 = [mach.nux(end);mach.nuy(end)];
Disp_dK2 = mach.etax(1);
THERING = setcellstruct(THERING,'K',Q2I,TempK2);
THERING = setcellstruct(THERING,'PolynomB',Q2I,TempPolB2,2);

THERING = setcellstruct(THERING,'K',Q3I,TempK3+delta);
THERING = setcellstruct(THERING,'PolynomB',Q3I,TempPolB3+delta,2);
mach = machine_at;
Tunes_dK3 = [mach.nux(end);mach.nuy(end)];
Disp_dK3 = mach.etax(1);
THERING = setcellstruct(THERING,'K',Q3I,TempK3);
THERING = setcellstruct(THERING,'PolynomB',Q3I,TempPolB3,2);


%Construct the Jacobian
change_dK = zeros(3);
tempTunesDisp = zeros(3);

change_dK(:,1) = [Tunes_dK1(1); Tunes_dK1(2); Disp_dK1];
change_dK(:,2) = [Tunes_dK2(1); Tunes_dK2(2); Disp_dK2];
change_dK(:,3) = [Tunes_dK3(1); Tunes_dK3(2); Disp_dK3];
tempTunesDisp(:,1) = [TempTunes(1); TempTunes(2); TempDisp];
tempTunesDisp(:,2) = [TempTunes(1); TempTunes(2); TempDisp];
tempTunesDisp(:,3) = [TempTunes(1); TempTunes(2); TempDisp];


J = (change_dK - tempTunesDisp)/delta;
Jinv = inv(J);

dnu = (newtunes_disp(:) - tempTunesDisp(:,1));
dK = Jinv*dnu;


TempK1 = TempK1+dK(1);
TempK2 = TempK2+dK(2);
TempK3 = TempK3+dK(3);
TempPolB1 = TempPolB1+dK(1);
TempPolB2 = TempPolB2+dK(2);
TempPolB3 = TempPolB3+dK(3);


THERING = setcellstruct(THERING,'K',Q1I,TempK1);
THERING = setcellstruct(THERING,'PolynomB',Q1I,TempPolB1,2);
THERING = setcellstruct(THERING,'K',Q2I,TempK2);
THERING = setcellstruct(THERING,'PolynomB',Q2I,TempPolB2,2);
THERING = setcellstruct(THERING,'K',Q3I,TempK3);
THERING = setcellstruct(THERING,'PolynomB',Q3I,TempPolB3,2);

mach = machine_at;
newTunes = [mach.nux(end);mach.nuy(end)];
newDisp = mach.etax(1);
if sqrt((newtunes_disp - [newTunes(:); newDisp]').^2)/3 > threshold | recursion_depth > MAXDEPTH
%     disp('looping again')
    [Kvals newTunes] = fittunedisp2(newtunes_disp,quadfam1,quadfam2,quadfam3,dispind,delta,recursion_depth+1);
else
    fprintf('Finished calculations. Recursion depth %d\n',recursion_depth);
    Kvals = [TempK1(1) TempK2(1) TempK3(1)];
    newTunes = [mach.nux(end) mach.nuy(end) mach.etax(1)];
end

if recursion_depth == 0
    fprintf('Final K values:  %9.7f (%s) %9.7f (%s) %9.7f (%s)\n',...
        Kvals(1), quadfam1, Kvals(2), quadfam2, Kvals(3), quadfam3);
    fprintf('Change        :  %9.7f (%s) %9.7f (%s) %9.7f (%s)\n',...
        1-(InitialK1(1)/Kvals(1)), quadfam1, 1-(InitialK2(1)/Kvals(2)), quadfam2, 1-(InitialK3(1)/Kvals(3)), quadfam3);
    fprintf('Final Tunes and Dispersion:   %14.10f (H) %14.10f (V) %14.10f (D)\n',...
        newTunes(1), newTunes(2), newTunes(3));
end

varargout{1} = Kvals;
varargout{2} = newTunes;