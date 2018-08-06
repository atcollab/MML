function [BPMx, BPMy, HCM, VCM, QF, QD, SF, SD, BEND] = elsalattice

% ELSA lattice
% 2.3 GeV electron energy.

L0 = 164.4;        % design length [m]
C0 = 299792458;       % speed of light [m/s]
HarmNumber = 274;
Energy = 2.3e9;


clear global FAMLIST GLOBVAL
global THERING
THERING = [];


% Convert MAD survey file to AT
%       NAME  - a string array of 8-character element names
%       TYPE  - an integer array of element types:
%       1 = Drift                (DRFT)
%       2 = Bend                 (SBND)
%       3 = Quadrupole           (QUAD)
%       4 = Sextupole            (SEXT)
%       5 = Linear acceleration  (ACCL)
%       6 = Horizontal corrector (HKIC)
%       7 = Vertical corrector   (VKIC)
%       8 = H/V corrector        (KICK)
%       9 = Horizontal BPM       (HMON)
%      10 = Vertical BPM         (VMON)
%      11 = H/V BPM              (MONI)
%      12 = Marker point         (MARK)

% Choose which ELSA lattice should be loaded (by O. Preisner)
choice=menu('Choose an ELSA lattice:','Positions of double correctors in the beginning, sextupoles off', ...
    'Positions of double correctors in the beginning, sextupoles on', 'Positions of double correctors in the middle, sextupoles off',...
    'Positions of double correctors in the middle, sextupoles on', 'Positions of double correctors in the beginning, sextupoles off, TEST file for LOCO');

if choice==1;
    THERING = readmad('ELSA_KH07+VH23Anfang_withoutSexts_MAD8_Survey.txt');
elseif choice==2;
    THERING = readmad('ELSA_KH07+VH23Anfang_withSexts_MAD8_Survey.txt');
elseif choice==3;
    THERING = readmad('ELSA_KH07+VH23Mitte_withoutSexts_MAD8_Survey.txt');
elseif choice==4;
    THERING = readmad('ELSA_KH07+VH23Mitte_withSexts_MAD8_Survey.txt');
elseif choice==5;
    THERING = readmad('ELSA_KH07+VH23Anfang_withoutSexts_FehlerFuerLOCO_MAD8_Survey.txt');
end


% THERING = readmad('ELSA_MAD8_Survey.txt');


% % Add a starting marker
% ElemData.FamName = 'SECTOR';
% ElemData.FamName = 'INITIAL';
% ElemData.Length = 0;
% ElemData.PassMethod = 'IdentityPass';
% ElemData.MADType = 'MARK';
% THERING = [{ElemData} THERING];

Spos = findspos(THERING, 1:length(THERING)+1);



Sector = 1;
QFDev = 0;
QDDev = 0;
SFDev = 0;
SDDev = 0;
SXDev = 0;
BendDev = 0;
BPMxDev = 0;
BPMyDev = 0;
HCMDev = 0;
VCMDev = 0;

QF.DeviceList = [];
QD.DeviceList = [];
SF.DeviceList = [];
SD.DeviceList = [];
SX.DeviceList = [];
BEND.DeviceList = [];
BPMx.DeviceList = [];
BPMy.DeviceList = [];
HCM.DeviceList = [];
VCM.DeviceList = [];

QF.N = [];
QD.N = [];
SF.N = [];
SD.N = [];
SX.N = [];
BEND.N = [];
BPMx.N = [];
BPMy.N = [];
HCM.N = [];
VCM.N = [];

NN = length(THERING);
iWarn = 0;

fprintf('   %d of %d elements of THERING included in this MML.\n', NN, length(THERING));

SectorLast = 1;
for i = 1:NN
    if Spos(i) > 164.4/2
        Sector = 2;
    else
        Sector = 1;
    end
    if Sector > SectorLast
        SectorLast = Sector;
        QFDev = 0;
        QDDev = 0;
        SFDev = 0;
        SDDev = 0;
        SXDev = 0;
        BendDev = 0;
        BPMxDev = 0;
        BPMyDev = 0;
        HCMDev = 0;
        VCMDev = 0;
    end

    if strcmpi(THERING{i}.MADType, 'DRIF')
        % Drift
        THERING{i}.FamName = 'DRIFT';

    elseif strcmpi(THERING{i}.MADType, 'SBEN')
        % BEND
        THERING{i}.FamName = 'BEND';
        BendDev = BendDev + 1;
        BEND.DeviceList = [BEND.DeviceList; Sector BendDev];
        BEND.N = strvcat(BEND.N, THERING{i}.FamName);

    elseif strcmpi(THERING{i}.MADType, 'QUAD')
        % Quadrupole
        if THERING{i}.K > 0
            THERING{i}.FamName = 'QF';
            QFDev = QFDev + 1;
            QF.DeviceList(end+1,:) = [Sector QFDev];
            QF.N = strvcat(QF.N, THERING{i}.FamName);
        elseif THERING{i}.K < 0
            THERING{i}.FamName = 'QD';
            QDDev = QDDev + 1;
            QD.DeviceList(end+1,:) = [Sector QDDev];
            QD.N = strvcat(QD.N, THERING{i}.FamName);
        else
            error('Quad is off');
        end

    elseif strcmpi(THERING{i}.MADType, 'SEXT')
        % Sextupole
        if strcmpi(THERING{i}.FamName(1:2), 'SF')
            THERING{i}.FamName = 'SF';
            SFDev = SFDev + 1;
            SF.DeviceList(end+1,:) = [Sector SFDev];
            SF.N = strvcat(SF.N, THERING{i}.FamName);
        elseif strcmpi(THERING{i}.FamName(1:2), 'SD')
            THERING{i}.FamName = 'SD';
            SDDev = SDDev + 1;
            SD.DeviceList(end+1,:) = [Sector SDDev];
            SD.N = strvcat(SD.N, THERING{i}.FamName);
        elseif strcmpi(THERING{i}.FamName(1:2), 'SX')
            THERING{i}.FamName = 'SX';
            SXDev = SXDev + 1;
            SX.DeviceList(end+1,:) = [Sector SXDev];
            SX.N = strvcat(SX.N, THERING{i}.FamName);
        else
            error('Unknown sextupole');            
        end

    elseif strcmpi(THERING{i}.MADType, 'RFCA')
        % Cavity
        THERING{i}.FamName = 'CAV';
        THERING{i}.HarmNumber = HarmNumber;

    elseif strcmpi(THERING{i}.MADType, 'LCAV')
        % Cavity with focusing
        THERING{i}.FamName = 'CAV';

    elseif strcmpi(THERING{i}.MADType, 'HKIC')
        %  6 = Horizontal corrector (HKIC)
        THERING{i}.FamName = 'HCM';
        HCMDev = HCMDev + 1;
        HCM.DeviceList = [HCM.DeviceList; Sector HCMDev];
        HCM.N = strvcat(HCM.N, THERING{i}.FamName);
    elseif strcmpi(THERING{i}.MADType, 'VKIC')
        %  7 = Vertical corrector   (VKIC)
        THERING{i}.FamName = 'VCM';
        VCMDev = VCMDev + 1;
        VCM.DeviceList = [VCM.DeviceList; Sector VCMDev];
        VCM.N = strvcat(VCM.N, THERING{i}.FamName);
    elseif strcmpi(THERING{i}.MADType, 'KICK')
        %  8 = H/V corrector        (KICK)
        THERING{i}.FamName = 'COR';
        HCMDev = HCMDev + 1;
        HCM.DeviceList = [HCM.DeviceList; Sector HCMDev];
        HCM.N = strvcat(HCM.N, THERING{i}.FamName);

        VCMDev = VCMDev + 1;
        VCM.DeviceList = [VCM.DeviceList; Sector VCMDev];
        VCM.N = strvcat(VCM.N, THERING{i}.FamName);
    elseif strcmpi(THERING{i}.MADType, 'HMON')
        %  9 = Horizontal BPM       (HMON)
        THERING{i}.FamName = 'BPM';
        BPMxDev = BPMxDev + 1;
        BPMx.DeviceList = [BPMx.DeviceList; Sector BPMxDev];
        BPMx.N = strvcat(BPMx.N, THERING{i}.FamName);
    elseif strcmpi(THERING{i}.MADType, 'VMON')
        % 10 = Vertical BPM         (VMON)
        THERING{i}.FamName = 'BPM';
        BPMyDev = BPMyDev + 1;
        BPMy.DeviceList = [BPMy.DeviceList; Sector BPMyDev];
        BPMy.N = strvcat(BPMy.N, THERING{i}.FamName);
    elseif strcmpi(THERING{i}.MADType, 'MONI')
        % 11 = H/V BPM              (MONI)
        THERING{i}.FamName = 'BPM';
        BPMxDev = BPMxDev + 1;
        BPMx.DeviceList = [BPMx.DeviceList; Sector BPMxDev];
        BPMx.N = strvcat(BPMx.N, THERING{i}.FamName);

        BPMyDev = BPMyDev + 1;
        BPMy.DeviceList = [BPMy.DeviceList; Sector BPMyDev];
        BPMy.N = strvcat(BPMy.N, THERING{i}.FamName);
    elseif strcmpi(THERING{i}.MADType, 'MARK')
        % 12 = Marker point         (MARK)
    else
        % Not sure what it is
        fprintf('   Warning:  element %d, unknown MAD type "%s" for FamNam "%s"\n', i, THERING{i}.MADType, THERING{i}.FamName);
    end
end

% Remove MSI31 from the device list
% HCM.DeviceList(end-1,:) = []; % commented out by Greg: in newer MAD
% HCM.N(end-1,:) = []; % in newer MAD survey files MSI 31 doesn't exist

% Cut THERING
%THERING = THERING(4:NN);

%clear global FAMLIST GLOBVAL


% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);


% Compute total length and RF frequency
fprintf('   L0 = %.6f m  (design length %f m)\n', Spos(end), L0);
fprintf('   RF = %.6f MHz \n', HarmNumber*C0/Spos(end)/1e6);
