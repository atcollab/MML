function ATLATTICE = readmad(FILENAME)
%READMAD - Reads the file output of MAD commands
% TWISS, STRUCTURE, SURVEY.
%
% READMAD reads the MAD file header to determine the number of elements
% in the lattice, symmetry flag, the number of supperperiods etc.
% 
% Then it interprets the entry for each element in the MAD output file.
% The topology of the lattice is completely determined by
% Length, Bending Angle, and Ttilt Angle in each element
% 
% READMAD uses MAD TYPES and the values of to determine
% which pass-method function in AT to use.
% 
% MAD TYPE      |  AT PassMethod
% ----------------------------------
% DRIFT         |  DriftPass
% SBEND         |  BendLinearPass, BendLinearFringeTiltPass, BndMPoleSymplectic4Pass
% QUADRUPOLE    |  QualdLinearPass
% SEXTUPOLE     |  StrMPoleSymplectic4Pass
% OCTUPOLE      |  StrMPoleSymplectic4Pass
% MULTIPOLE     |  !!! Not implemented, in future - ThinMPolePass
% RFCAVITY      |  ThinCavityPass
% KICKER        |  CorrectorPass
% HKICKER       |  CorrectorPass
% VKICKER       |  CorrectorPass
% MONITOR       |  IdentityPass
% HMONITOR      |  IdentityPass
% VMONITOR      |  IdentityPass
% MARKER        |  IdentityPass
% -----------------------------------
% all others    |  Length=0 -> IdentityPass, Length~=0 -> DriftPass

[fid, errmsg]  = fopen(FILENAME,'r');
if fid==-1
    error('Could not open file');
end

warnlevel = warning;
warning on

global READMADCAVITYFLAG
READMADCAVITYFLAG = 0;

LINE1 = fgetl(fid);
LINE2 = fgetl(fid);

S = LINE1(9:16);
nonspaceindex = find(~isspace(S) & (S~=0));
MADFILETYPE = S(nonspaceindex);
% The possiblilites for MADFILETYPE are
% TWISS,SURVEY,STRUCTUR,ENVELOPE


NSUPER = str2double(LINE1(41:48));

S = LINE1(56);
SYMFLAG = eq(S,'T');

NPOS = str2double(LINE1(57:64));

disp(['MAD output file: ',FILENAME]);
disp(' ');
disp(['MAD file type:           ',MADFILETYPE]);
disp(['Symmetry flag:           ',num2str(SYMFLAG)]);
disp(['Number of superperiods:  ',num2str(NSUPER)]);
disp(['Number of elements :     ',num2str(NPOS)]);
disp(' ');


% Allocate cell array to store AT lattice
% MAD files heve one extra entry for the beginning of the lattice 
ATNumElements = NPOS-1;
ATLATTICE = cell(1,ATNumElements);


switch MADFILETYPE
case {'STRUCTUR','SURVEY'}
    NumLinesPerElement = 4;
case {'TWISS','CHROM'}
    NumLinesPerElement = 5;
case 'ENVELOPE'
    NumLinesPerElement = 8;
end

ELEMENTDATA = cell(1,NumLinesPerElement);

% Skip the INITIAL element in MAD file
for i = 1:NumLinesPerElement;
    LINE = fgetl(fid);
end

for i = 1:ATNumElements
    % Read the first 2 lines of the element entry
    for j= 1:NumLinesPerElement
        ELEMENTDATA{j}=fgetl(fid);
    end
    
    ATLATTICE{i}=mad2at(ELEMENTDATA,MADFILETYPE);
end
    



fclose(fid);
warning(warnlevel);

disp(' ');
disp(['AT cell array was successfully created from MAD output file ',FILENAME]);
disp('Some information may be not available in MAD otput files')
disp('Some elements may have to be further modified to be consistent with AT element models')
disp(' ');
disp('For RF cavities READMAD creates elements that use DriftPass or IdentityPass (if Length ==0)');
disp('Use CAVITYON(ENERGY) [eV] in order to turn them into cavities');


% ---------------------------------------------------------------------------

function atelem = mad2at(elementdata,madfiletype)
    global READMADCAVITYFLAG
    MADTYPE = elementdata{1}(1:4);
    atelem.FamName = deblank(elementdata{1}(5:20));
    atelem.Length = str2double(elementdata{1}(21:32));
    % Type specific 
    switch MADTYPE
    case 'DRIF'
        atelem.PassMethod = 'DriftPass';
    case {'MARK','MONI','HMON','VMON'}
        atelem.PassMethod = 'IdentityPass';
    case 'RFCA'
        % Note MAD determines the RF frequency from the harmonic number HARMON
        % defined by MAD stetement BEAM, and the total length of the closed orbit
        if ~READMADCAVITYFLAG
            warning('MAD lattice contains RF cavities')
            READMADCAVITYFLAG = 1;
        end
        atelem.Frequency = 1e6*str2double(elementdata{2}(17:32)); % MAD uses MHz
        atelem.Voltage = 1e6*str2double(elementdata{2}(33:48));
        atelem.PhaseLag = str2double(elementdata{2}(49:64));
        if atelem.Length
            atelem.PassMethod = 'DriftPass';
        else
            atelem.PassMethod = 'IdentityPass';
        end
    case 'SBEN'
        K1 = str2double(elementdata{1}(49:64));
        K2 = str2double(elementdata{1}(65:80));
        atelem.BendingAngle = str2double(elementdata{1}(33:48));
        atelem.ByError = 0;
        atelem.MaxOrder = 3;
        atelem.NumIntSteps = 10;
        atelem.TiltAngle = str2double(elementdata{2}(1:16));
        atelem.EntranceAngle = str2double(elementdata{2}(17:32));
        atelem.ExitAngle = str2double(elementdata{2}(33:48));
        atelem.K = K1;
        atelem.PolynomB = [0 K1 K2 0];
        atelem.PolynomA = [0 0 0 0];      
        atelem.T1 = zeros(1,6);
        atelem.T2 = zeros(1,6);
        atelem.R1 = eye(6);
        atelem.R2 = eye(6);
        if atelem.BendingAngle
            if K2
                atelem.PassMethod = 'BndMPoleSymplectic4Pass';
            elseif atelem.TiltAngle
                atelem.PassMethod = 'BendLinearFringeTiltPass'
            else
                atelem.PassMethod = 'BendLinearPass';
            end
            
        else
            if K2
                atelem.PassMethod = 'StrMPoleSymplectic4Pass';
            elseif K1
                atelem.PassMethod = 'QuadLinearPass';
            else
                atelem.PassMethod = 'DriftPass';
            end
        end
    case 'QUAD'
        K1 = str2double(elementdata{1}(49:64));
        atelem.MaxOrder = 3;
        atelem.NumIntSteps = 10;
        atelem.K = K1;
        atelem.PolynomB = [0 K1 0 0];
        atelem.PolynomA = [0 0 0 0];
        atelem.T1 = zeros(1,6);
        atelem.T2 = zeros(1,6);
        TILT = str2double(elementdata{2}(1:16));
        atelem.R1 = mksrollmat(TILT);
        atelem.R2 = mksrollmat(-TILT);
        atelem.PassMethod = 'QuadLinearPass';
        
    case 'SEXT'
        % MAD multipole strength coefficients K(n) are defined without 1/n!
        % Adjust to match AT
        K2 = str2double(elementdata{1}(65:80))/2;
        atelem.MaxOrder = 3;
        atelem.NumIntSteps = 10;
        atelem.PolynomB = [0 0 K2 0];
        atelem.PolynomA = [0 0 0 0];
        atelem.T1 = zeros(1,6);
        atelem.T2 = zeros(1,6);
        TILT = str2double(elementdata{2}(1:16));
        atelem.R1 = mksrollmat(TILT);
        atelem.R2 = mksrollmat(-TILT);
        atelem.PassMethod = 'StrMPoleSymplectic4Pass';
        
    case 'OCTU'
        % MAD multipole strength coefficients K(n) are defined without 1/n!
        % Adjust to match AT
        K3 = str2double(elementdata{2}(17:32))/6;
        atelem.MaxOrder = 3 ;
        atelem.NumIntSteps = 10;
        atelem.PolynomB = [0 0 0 K3];
        atelem.PolynomA = [0 0 0 0];
        atelem.T1 = zeros(1,6);
        atelem.T2 = zeros(1,6);
        TILT = str2double(elementdata{2}(1:16));
        atelem.R1 = mksrollmat(TILT);
        atelem.R2 = mksrollmat(-TILT);
        atelem.PassMethod = 'StrMPoleSymplectic4Pass';
    otherwise
        if atelem.Length
            atelem.PassMethod = 'DriftPass';
        else
            atelem.PassMethod = 'IdentityPass';
        end
    end
