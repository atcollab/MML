function [BPMx, BPMy, HCM, VCM, QF, QD, SF, SD, BEND] = mad2at_elettra(varargin)
%MAD2AT_ELETTRA - Build AT deck from 
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
% RFCA


clear global FAMLIST GLOBVAL
global THERING
THERING = [];

% Convert MAD survey file to AT
THERING = readmad('elettra_mad_survey_file.survey');

% Rotate the ring
%THERING = [THERING(end-75:end) THERING(1:end-76)];

C0 = 299792458;       % speed of light [m/s]
HarmNumber = 432;

% Add a starting marker
ElemData.FamName = 'Start';
ElemData.MADName = 'INITIAL';
ElemData.Length = 0;
ElemData.PassMethod = 'IdentityPass';
ElemData.M66 = eye(6);
ElemData.MADType = 'MARK';
ElemData.Energy = [];
THERING = [{ElemData} THERING];

Spos = findspos(THERING, 1:length(THERING)+1);

Sector = 1;
SFDev = 0;
SDDev = 0;
QFDev = 0;
QDDev = 0;
BendDev = 0;
BPMxDev = 0;
BPMyDev = 0;
HCMDev = 0;
VCMDev = 0;
KickerDev = 0;

SF.DeviceList = [];
SD.DeviceList = [];
QF.DeviceList = [];
QD.DeviceList = [];
BEND.DeviceList = [];
BPMx.DeviceList = [];
BPMy.DeviceList = [];
HCM.DeviceList = [];
VCM.DeviceList = [];
Kicker.DeviceList = [];

SF.N = [];
SD.N = [];
QF.N = [];
QD.N = [];
BEND.N = [];
BPMx.N = [];
BPMy.N = [];
HCM.N = [];
VCM.N = [];
Kicker.N = [];

NN = length(THERING);
iWarn = 0;

L = Spos(end);

fprintf('   %d of %d elements of THERING included in this MML.\n', NN, length(THERING));
        
iRF = [];
        
for i = 1:NN
    %fprintf('%03d. %s\n', i, THERING{i}.MADType);
    
    if strcmpi(THERING{i}.MADType, '')
        fprintf('   Sector break at %d\n', i);
        
        Sector = Sector + 1;
        QuadDev = 0;
        BendDev = 0;
        BPMxDev = 0;
        BPMyDev = 0;
        HCMDev = 0;
        VCMDev = 0;
        
        %marker('SECTOR', 'IdentityPass');

    elseif strcmpi(THERING{i}.MADType, 'DRIF')
        % Drift

    elseif strcmpi(THERING{i}.MADType, 'SBEN')
        % BEND
        BendDev = BendDev + 1;
        BEND.DeviceList = [BEND.DeviceList; Sector BendDev];
        BEND.N = strvcat(BEND.N, THERING{i}.FamName);
        THERING{i}.FamName = 'BEND';
        
    elseif strcmpi(THERING{i}.MADType, 'QUAD')
        % Quadrupole
        if strcmpi(THERING{i}.FamName(1:2), 'QF')
            THERING{i}.FamName = 'QF';
        elseif strcmpi(THERING{i}.FamName(1:2), 'QD')
            THERING{i}.FamName = 'QD';
        elseif strcmpi(THERING{i}.FamName(1:2), 'Q1')
            THERING{i}.FamName = 'Q1';
        elseif strcmpi(THERING{i}.FamName(1:2), 'Q2')
            THERING{i}.FamName = 'Q2';
        elseif strcmpi(THERING{i}.FamName(1:2), 'Q3')
            THERING{i}.FamName = 'Q3';
        end
        
        %if THERING{i}.PolynomB(2) >= 0
        %else
        %    QDDev = QDDev + 1;
        %    QD.DeviceList = [QD.DeviceList; Sector QDDev];
        %    QD.N = strvcat(QD.N, THERING{i}.FamName);
        %    THERING{i}.FamName = 'QD';
        %end
        
    elseif any(strcmpi(THERING{i}.MADType, {'SEXT','MULT'}))
        % Sextupole
        % 4 = Sextupole            (SEXT)
        if strcmpi(THERING{i}.FamName(1:2), 'SF')
            THERING{i}.FamName = 'SF';
        elseif strcmpi(THERING{i}.FamName(1:2), 'SD')
            THERING{i}.FamName = 'SD';
        elseif strcmpi(THERING{i}.FamName(1:2), 'S1')
            THERING{i}.FamName = 'S1';
        end

%         if THERING{i}.PolynomB(3) >= 0
%             SFDev = SFDev + 1;
%             SF.DeviceList = [SF.DeviceList; Sector SFDev];
%             SF.N = strvcat(SF.N, THERING{i}.FamName);
%             THERING{i}.FamName = 'SF';
%         else
%             SDDev = SDDev + 1;
%             SD.DeviceList = [SD.DeviceList; Sector SDDev];
%             SD.N = strvcat(SD.N, THERING{i}.FamName);
%             THERING{i}.FamName = 'SD';
%         end
        
    elseif strcmpi(THERING{i}.MADType, 'RFCA')
        % Cavity
        iRF = [iRF; i];
        THERING{i}.HarmNumber = HarmNumber;
        
    elseif strcmpi(THERING{i}.MADType, 'LCAV')
        % Cavity with focusing

    elseif strcmpi(THERING{i}.MADType, 'HKIC')
        %  6 = Horizontal corrector (HKIC)
        HCMDev = HCMDev + 1;
        HCM.DeviceList = [HCM.DeviceList; Sector HCMDev];
        HCM.N = strvcat(HCM.N, THERING{i}.FamName);
        THERING{i}.FamName = 'HCM';
    elseif strcmpi(THERING{i}.MADType, 'VKIC')
        %  7 = Vertical corrector   (VKIC)
        VCMDev = VCMDev + 1;
        VCM.DeviceList = [VCM.DeviceList; Sector VCMDev];
        VCM.N = strvcat(VCM.N, THERING{i}.FamName);
        THERING{i}.FamName = 'VCM';
    elseif strfind(THERING{i}.FamName, 'KICKER')
        %  Kicker        (KICKER)
        KickerDev = KickerDev + 1;
        Kicker.DeviceList = [Kicker.DeviceList; Sector KickerDev];
        Kicker.N = strvcat(Kicker.N, THERING{i}.FamName);
        THERING{i}.FamName = 'Kicker';
        THERING{i}.KickAngle = [0 0];
        THERING{i}.PassMethod = 'CorrectorPass';
    elseif strcmpi(THERING{i}.MADType, 'KICK')
        %  8 = H/V corrector        (KICK)
        HCMDev = HCMDev + 1;
        HCM.DeviceList = [HCM.DeviceList; Sector HCMDev];
        HCM.N = strvcat(HCM.N, THERING{i}.FamName);
        THERING{i}.FamName = 'HCM';

        VCMDev = VCMDev + 1;
        VCM.DeviceList = [VCM.DeviceList; Sector VCMDev];
        VCM.N = strvcat(VCM.N, THERING{i}.FamName);
        THERING{i}.FamName = 'VCM';
    elseif strcmpi(THERING{i}.MADType, 'HMON')
        %  9 = Horizontal BPM       (HMON)
        BPMxDev = BPMxDev + 1;
        BPMx.DeviceList = [BPMx.DeviceList; Sector BPMxDev];
        BPMx.N = strvcat(BPMx.N, THERING{i}.FamName);
        THERING{i}.FamName = 'BPMx';
    elseif strcmpi(THERING{i}.MADType, 'VMON')
        % 10 = Vertical BPM         (VMON)
        BPMyDev = BPMyDev + 1;
        BPMy.DeviceList = [BPMy.DeviceList; Sector BPMyDev];
        BPMy.N = strvcat(BPMy.N, THERING{i}.FamName);
        THERING{i}.FamName = 'BPMy';
    elseif strcmpi(THERING{i}.MADType, 'MONI')
        % 11 = H/V BPM              (MONI)
        if strcmpi(THERING{i}.FamName, 'BPM')
            BPMxDev = BPMxDev + 1;
            BPMx.DeviceList = [BPMx.DeviceList; Sector BPMxDev];
            BPMx.N = strvcat(BPMx.N, THERING{i}.FamName);
            THERING{i}.FamName = 'BPM';
            
            BPMyDev = BPMyDev + 1;
            BPMy.DeviceList = [BPMy.DeviceList; Sector BPMyDev];
            BPMy.N = strvcat(BPMy.N, THERING{i}.FamName);
            THERING{i}.FamName = 'BPM';
        elseif strcmpi(THERING{i}.FamName, 'FLSC_S4')
            % Skip this BPM for now???
            % What about FLSC_S8???
        else
            % Skip this BPM
        end
    elseif strcmpi(THERING{i}.MADType, 'MARK')
        % 12 = Marker point         (MARK)
        iMarker = i;
    else
        % Not sure what it is, so make a transfer function out of it
        % matrix66('M66', L, M, 'Matrix66Pass');

        if abs(THERING{i}.Length - L(i)) > 1e-6
            error('Element %d has a different length in Survey vs Response (%f) file', i, THERING{i}.Length, L(i));
        end
        
        Mmad = R(:,:,i) * inv(R(:,:,i-1));
        if strcmp(THERING{i}.PassMethod, 'DriftPass')
            M = eye(6,6);
            M(1,2) = THERING{i}.Length;
            M(3,4) = THERING{i}.Length;
            if all(all(abs(Mmad-M)<1e-7))
                % Probably OK
            else
                THERING{i}.PassMethod = 'Matrix66Pass';
            end
        elseif strcmp(THERING{i}.PassMethod, 'IdentityPass')
            if all(all(abs(Mmad-eye(6,6))<1e-7))
                % Probably OK
            else
                %% Look for a drift
                %M = eye(6,6);
                %M(1,2) = THERING{i}.Length;
                %M(3,4) = THERING{i}.Length;
                %if all(all(abs(Mmad-M)<1e-7))
                %    THERING{i}.PassMethod = 'DriftPass';
                %else
                    THERING{i}.PassMethod = 'Matrix66Pass';
                %end
            end
        else
            THERING{i}.PassMethod = 'Matrix66Pass';
        end

        %fprintf('   Warning:  element %d, unknown type (%s %s)\n', i, THERING{i}.MADType, THERING{i}.MADName);
        iWarn = iWarn + 1;
    end

    % Store every response matrix in AT format
    %THERING{i}.M66cum = tfmad2at(R(:,:,i));
    %
    %if i == 1
    %    Mmad = eye(6,6);
    %else
    %    Mmad = R(:,:,i) * inv(R(:,:,i-1));
    %end
    %
    %%if strcmpi(THERING{i}.MADType, 'LCAV')
    %%    THERING{i}.M66 = 1.135*tfmad2at(Mmad);
    %%else
    %    THERING{i}.M66 = tfmad2at(Mmad);
    %%end

    % Add the Energy
    %THERING{i}.Energy = Energy;
end

%fprintf('   %d unknown types converted to 6x6 transfer functions.\n', iWarn);


% Add energy to the added first element
THERING{1}.Energy = THERING{2}.Energy;


% Add some length to the sextupoles
iSF = findcells(THERING, 'FamName', 'SF');
iSD = findcells(THERING, 'FamName', 'SD');
iS1 = findcells(THERING, 'FamName', 'S1');
iSext = [iSF(:); iSD(:); iS1(:)];
for i = iSext'
    if THERING{i}.Length==0
        if strcmpi(THERING{i-1}.FamName,'DRIFT') && strcmpi(THERING{i+1}.FamName,'DRIFT') && THERING{i-1}.Length>.05 && THERING{i+1}.Length>.05
            THERING{i-1}.Length = THERING{i-1}.Length - .05;
            THERING{i+1}.Length = THERING{i+1}.Length - .05;
            THERING{i}.Length = .1;
            THERING{i}.PolynomB(3) = THERING{i}.PolynomB(3) / THERING{i}.Length; 
        else
            THERING{i}
            error('Trouble adding some length to the sextupole magnets.');
        end
    end
end


% Check the path length
L0_tot = findspos(THERING, length(THERING)+1);
Frequency = HarmNumber*C0/L0_tot;
fprintf('   L0 = %.6f m   \n', L0_tot);
fprintf('   RF = %.6f MHz \n', Frequency/1e6);


% Cavity frequency and voltage appear to be missing in the MAD model
for i = iRF(:)'
    THERING{i}.Frequency = Frequency;  % Hz  
    THERING{i}.Voltage = .5e6;         % MV per cavity
end


clear global FAMLIST GLOBVAL



% QDIndex = [];
% BendIndex = [];
% BPMIndex = [];
% HCMIndex = [];
% VCMIndex = [];
% DriftIndex = [];
% KIndex = [];
% for i = 1:size(N,1)
%     if N(i,1) == 'Q'
%         QDIndex(end+1,1) = i;
%     end
%     if strcmp(N(i,1:2), 'BX')
%         BendIndex(end+1,1) = i;
%     end
%     if strcmp(N(i,1:3), 'BPM')
%         BPMIndex(end+1,1) = i;
%     end
%     if strcmp(N(i,1:2), 'XC')
%         HCMIndex(end+1,1) = i;
%     end
%     if strcmp(N(i,1:2), 'YC')
%         VCMIndex(end+1,1) = i;
%     end
%     if strcmp(N(i,1:2), 'DR')
%         DriftIndex(end+1,1) = i;
%     end
%     if strcmp(N(i,1), 'K')
%         KIndex(end+1,1) = i;
%     end
% end

