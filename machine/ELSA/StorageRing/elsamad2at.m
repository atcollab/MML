function [BPMx, BPMy, HCM, VCM, QUAD, BEND] = elsamad2at(varargin)
%ELSAMAD2AT - Build AT deck from MAD8 survey tape

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


L0 = 164.3952;        % design length [m]
C0 = 299792458;       % speed of light [m/s]
HarmNumber = 274;
Energy = 2.3e9;


clear global FAMLIST GLOBVAL
global THERING
THERING = [];

% Convert MAD survey file to AT
THERING = readmad('ELSA_MAD8_Survey.tape');



% Add a starting marker
ElemData.FamName = 'SECTOR';
ElemData.MADName = 'INITIAL';
ElemData.Length = 0;
ElemData.PassMethod = 'IdentityPass';
ElemData.M66 = eye(6);
ElemData.MADType = 'MARK';
%ElemData.Energy = Energy;
THERING = [{ElemData} THERING];

Spos = findspos(THERING, 1:length(THERING)+1);



% Sector = 1;
% QuadDev = 0;
% BendDev = 0;
% BPMxDev = 0;
% BPMyDev = 0;
% HCMDev = 0;
% VCMDev = 0;
% 
% QUAD.DeviceList = [];
% BEND.DeviceList = [];
% BPMx.DeviceList = [];
% BPMy.DeviceList = [];
% HCM.DeviceList = [];
% VCM.DeviceList = [];
% 
% QUAD.N = [];
% BEND.N = [];
% BPMx.N = [];
% BPMy.N = [];
% HCM.N = [];
% VCM.N = [];
% 
% 
% iBEND = findcells(THERING, 'FamName', 'BEND')';
% iQUAD = findcells(THERING, 'FamName', 'QUAD')';
% 
% %NN = length(THERING);
% NN = max(find(Spos-Spos(1)<25)); %size(N,1);
% iWarn = 0;
% 
% fprintf('   %d of %d elements of THERING included in this MML.\n', NN, length(THERING));
% 
% for i = 1:NN
%     if strcmpi(THERING{i}.MADType, '')
%         fprintf('   Sector break at %d\n', i);
%         
%         Sector = Sector + 1;
%         QuadDev = 0;
%         BendDev = 0;
%         BPMxDev = 0;
%         BPMyDev = 0;
%         HCMDev = 0;
%         VCMDev = 0;
%         
%         %marker('SECTOR', 'IdentityPass');
% 
%     elseif strcmpi(THERING{i}.MADType, 'DRIF')
%         % Drift
% 
%     elseif strcmpi(THERING{i}.MADType, 'SBEN')
%         % BEND
%         
%         % The BEND is not simulating properly???
%         %matrix66('BEND', L, M, 'Matrix66Pass');
%         THERING{i}.PassMethod = 'Matrix66Pass';
% 
%         ii = max(iBEND(iBEND<i));
%         if isempty(ii)
%             % First magnet in family
%             FirstElement = 1;
%         elseif abs(Spos(ii)+THERING{ii}.Length - Spos(i))<.001
%             % Spilt magnet
%             FirstElement = 0;
%         else
%             % Either 1 magnet or first part of a spilt magnet
%             FirstElement = 1;
%         end
%         if FirstElement
%             BendDev = BendDev + 1;
%             BEND.DeviceList = [BEND.DeviceList; Sector BendDev];
%             BEND.N = strvcat(BEND.N, THERING{i}.MADName);
%         end
% 
%     elseif strcmpi(THERING{i}.MADType, 'QUAD')
%         % Quadrupole
%         ii = max(iQUAD(iQUAD<i));
%         if isempty(ii)
%             % First magnet in family
%             FirstElement = 1;
%         elseif abs(Spos(ii)+THERING{ii}.Length - Spos(i))<.001
%             % Spilt magnet
%             FirstElement = 0;
%         else
%             % Either 1 magnet or first part of a spilt magnet
%             FirstElement = 1;
%         end
%         if FirstElement
%             QuadDev = QuadDev + 1;
%             QUAD.DeviceList = [QUAD.DeviceList; Sector QuadDev];
%             QUAD.N = strvcat(QUAD.N, THERING{i}.MADName);
%         end
% 
%     elseif strcmpi(THERING{i}.MADType, 'SEXT')
%         % Sextupole
% 
%     elseif strcmpi(THERING{i}.MADType, 'LCAV')
%         % Cavity with focusing
%         if abs(THERING{i}.Length - L(i)) > 1e-6
%             error('Element %d has a different length in Survey vs Response (%f) file', i, THERING{i}.Length, L(i));
%         end
%         %matrix66('Cavity', L, M, 'Matrix66Pass');
%         %THERING{i}.PassMethod = 'Matrix66Pass';
% 
%     elseif strcmpi(THERING{i}.MADType, 'HKIC')
%         %  6 = Horizontal corrector (HKIC)
%         HCMDev = HCMDev + 1;
%         HCM.DeviceList = [HCM.DeviceList; Sector HCMDev];
%         HCM.N = strvcat(HCM.N, THERING{i}.MADName);
%     elseif strcmpi(THERING{i}.MADType, 'VKIC')
%         %  7 = Vertical corrector   (VKIC)
%         VCMDev = VCMDev + 1;
%         VCM.DeviceList = [VCM.DeviceList; Sector VCMDev];
%         VCM.N = strvcat(VCM.N, THERING{i}.MADName);
%     elseif strcmpi(THERING{i}.MADType, 'KICK')
%         %  8 = H/V corrector        (KICK)
%         HCMDev = HCMDev + 1;
%         HCM.DeviceList = [HCM.DeviceList; Sector HCMDev];
%         HCM.N = strvcat(HCM.N, THERING{i}.MADName);
% 
%         VCMDev = VCMDev + 1;
%         VCM.DeviceList = [VCM.DeviceList; Sector VCMDev];
%         VCM.N = strvcat(VCM.N, THERING{i}.MADName);
%     elseif strcmpi(THERING{i}.MADType, 'HMON')
%         %  9 = Horizontal BPM       (HMON)
%         BPMxDev = BPMxDev + 1;
%         BPMx.DeviceList = [BPMx.DeviceList; Sector BPMxDev];
%         BPMx.N = strvcat(BPMx.N, THERING{i}.MADName);
%     elseif strcmpi(THERING{i}.MADType, 'VMON')
%         % 10 = Vertical BPM         (VMON)
%         BPMyDev = BPMyDev + 1;
%         BPMy.DeviceList = [BPMy.DeviceList; Sector BPMyDev];
%         BPMy.N = strvcat(BPMy.N, THERING{i}.MADName);
%     elseif strcmpi(THERING{i}.MADType, 'MONI')
%         % 11 = H/V BPM              (MONI)
%         BPMxDev = BPMxDev + 1;
%         BPMx.DeviceList = [BPMx.DeviceList; Sector BPMxDev];
%         BPMx.N = strvcat(BPMx.N, THERING{i}.MADName);
% 
%         BPMyDev = BPMyDev + 1;
%         BPMy.DeviceList = [BPMy.DeviceList; Sector BPMyDev];
%         BPMy.N = strvcat(BPMy.N, THERING{i}.MADName);
%     elseif strcmpi(THERING{i}.MADType, 'MARK')
%         % 12 = Marker point         (MARK)
%     else
%         % Not sure what it is, so make a transfer function out of it
%         % matrix66('M66', L, M, 'Matrix66Pass');
% 
%         if abs(THERING{i}.Length - L(i)) > 1e-6
%             error('Element %d has a different length in Survey vs Response (%f) file', i, THERING{i}.Length, L(i));
%         end
%         
%         Mmad = R(:,:,i) * inv(R(:,:,i-1));
%         if strcmp(THERING{i}.PassMethod, 'DriftPass')
%             M = eye(6,6);
%             M(1,2) = THERING{i}.Length;
%             M(3,4) = THERING{i}.Length;
%             if all(all(abs(Mmad-M)<1e-7))
%                 % Probably OK
%             else
%                 THERING{i}.PassMethod = 'Matrix66Pass';
%             end
%         elseif strcmp(THERING{i}.PassMethod, 'IdentityPass')
%             if all(all(abs(Mmad-eye(6,6))<1e-7))
%                 % Probably OK
%             else
%                 %% Look for a drift
%                 %M = eye(6,6);
%                 %M(1,2) = THERING{i}.Length;
%                 %M(3,4) = THERING{i}.Length;
%                 %if all(all(abs(Mmad-M)<1e-7))
%                 %    THERING{i}.PassMethod = 'DriftPass';
%                 %else
%                     THERING{i}.PassMethod = 'Matrix66Pass';
%                 %end
%             end
%         else
%             THERING{i}.PassMethod = 'Matrix66Pass';
%         end
% 
%         %fprintf('   Warning:  element %d, unknown type (%s %s)\n', i, THERING{i}.MADType, THERING{i}.MADName);
%         iWarn = iWarn + 1;
%     end
% 
%     % Store every response matrix in AT format
%     THERING{i}.M66cum = tfmad2at(R(:,:,i));
% 
%     if i == 1
%         Mmad = eye(6,6);
%     else
%         Mmad = R(:,:,i) * inv(R(:,:,i-1));
%     end
% 
%     %if strcmpi(THERING{i}.MADType, 'LCAV')
%     %    THERING{i}.M66 = 1.135*tfmad2at(Mmad);
%     %else
%         THERING{i}.M66 = tfmad2at(Mmad);
%     %end
% 
%     % Add the Energy
%     THERING{i}.Energy = E(i);
% end
% 
% fprintf('   %d unknown types converted to 6x6 transfer functions.\n', iWarn);



% Cut THERING
%THERING = THERING(4:NN);

clear global FAMLIST GLOBVAL


% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);


% Compute total length and RF frequency
fprintf('   L0 = %.6f m  (design length %f m)\n', Spos(end), L0);
fprintf('   RF = %.6f MHz \n', HarmNumber*C0/Spos(end)/1e6);
