function plotbpmrespsym(R)
%PLOTBPMRESPSYM - Looks for symmetry of the orbit response matrix
%  plotbpmrespsym(R)
%  plotbpmrespsym(FileName)
%
%  NOTES
%  1. This function is only informative if the lattice is
%     symmetric by sector.
%  2. This function only works if the corrector and BPM 
%     placement is symmetric in each sector.

%  Written by Greg Portmann


if nargin == 0
    R = getbpmresp('Struct');
end
if isempty(R)
    R = getbpmresp('','Struct');
end
if isempty(R)
    return;
end


% Use physics units for scaling
R = hw2physics(R);


FontSize = 10;
Buffer = .01;
HeightBuffer = .08;


Sx = R(1,1).Data;
Sy = R(2,2).Data;

NSectors = R(1,1).Monitor.DeviceList(end,1);
NBPMxperSector = max(R(1,1).Monitor.DeviceList(:,2));
NBPMyperSector = max(R(2,2).Monitor.DeviceList(:,2));

NBPMx = size(Sx,1);
NBPMy = size(Sy,1);

NHCMperSector = max(R(1,1).Actuator.DeviceList(:,2));
NVCMperSector = max(R(2,2).Actuator.DeviceList(:,2));

%NHCMperSector = size(Sx,2) / NSectors;
%NVCMperSector = size(Sy,2) / NSectors;

Circumference = getfamilydata('Circumference');

BPMxs = getspos(R(1,1).Monitor.FamilyName, R(1,1).Monitor.DeviceList);
BPMxs = BPMxs(:);
BPMys = getspos(R(2,2).Monitor.FamilyName, R(2,2).Monitor.DeviceList);
BPMys = BPMys(:);

BPMxDev = R(1,1).Monitor.DeviceList;
BPMyDev = R(2,2).Monitor.DeviceList;
% BPMxelem = dev2elem(R(1,1).Monitor.FamilyName, R(1,1).Monitor.DeviceList);
% BPMyelem = dev2elem(R(2,2).Monitor.FamilyName, R(2,2).Monitor.DeviceList);

% BPMxGain = getgain(R(1,1).Monitor.FamilyName, R(1,1).Monitor.DeviceList);
% BPMyGain = getgain(R(2,2).Monitor.FamilyName, R(2,2).Monitor.DeviceList);

HCMDev = R(1,1).Actuator.DeviceList;
VCMDev = R(2,2).Actuator.DeviceList;
% HCMelem = dev2elem('HCM', R(1,1).Actuator.DeviceList);
% VCMelem = dev2elem('VCM', R(2,2).Actuator.DeviceList);

% % Hardware units to mradian
% %HCMGain = getgain('HCM', R(1,1).Actuator.DeviceList);
% HCMGain = 1 ./ (hw2physics('HCM', 'Setpoint', R(1,1).ActuatorDelta, HCMDev) ./ R(1,1).ActuatorDelta) / 1000;
% 
% %VCMGain = getgain('VCM', R(2,2).Actuator.DeviceList);
% VCMGain = 1 ./ (hw2physics('VCM', 'Setpoint', R(2,2).ActuatorDelta, VCMDev) ./ R(2,2).ActuatorDelta) / 1000;

XUnitsString = R(1,1).UnitsString;
XUnitsString(findstr(XUnitsString,'(')) = [];
XUnitsString(findstr(XUnitsString,')')) = [];
YUnitsString = R(2,2).UnitsString;
YUnitsString(findstr(YUnitsString,'(')) = [];
YUnitsString(findstr(YUnitsString,')')) = [];


L = getfamilydata('Circumference');



%%%%%%%%%%%%%%
% Horizontal %
%%%%%%%%%%%%%%

% % Scale response matrix by the BPM gains
% for i = 1:size(Sx,2)
%    Sx(:,i) = Sx(:,i) .* BPMxGain(:);
% end
% 
% % Scale response matrix by the HCM gains
% for i = 1:size(Sx,1)
%    Sx(i,:) = Sx(i,:) .* HCMGain(:)';
%    %Sx(i,:) = Sx(i,:) ./ hw2physics('HCM', 'Setpoint', 1, HCMDev)'/1000;
%    %Sx(i,:) = Sx(i,:) / (1000*amps2rad('HCM',1,i));
% end


figure;
clf reset
set(gcf,'units','normal','position',[.0+Buffer .27+Buffer .5-2*Buffer .72-2*Buffer-HeightBuffer]);
for Mag = 1:NHCMperSector    
    S = [];
    P = [];
    for i = 1:NSectors
        j = findrowindex([i Mag], HCMDev);
        if ~isempty(j)
            k = min(find(BPMxDev(:,1)==i));
            S = [S [Sx(k:end, j); Sx(1:k-1, j)]]; 
            P = [P [BPMxs(k:end); BPMxs(1:k-1)+L]-BPMxs(k)+BPMxs(1)]; 
        end
    end
    
    subplot(NHCMperSector, 1, Mag);
    if isempty(S)
        plot(BPMxs, NaN*ones(size(BPMxs)));        
    else
        plot(P, S);
    end
    ylabel(sprintf('Mag #%d', Mag), 'FontSize', FontSize);
end

subplot(NHCMperSector,1,1);
title(sprintf('Horizontal Corrector Magnet Response (%s)', XUnitsString), 'FontSize', FontSize);

subplot(NHCMperSector,1,NHCMperSector);
xlabel('BPM Position [meters]', 'FontSize', FontSize);
if isfield(R(1,1), 'TimeStamp')
    addlabel(1,0,sprintf('%s', datestr(R(1,1).TimeStamp)));
end
orient tall


%%%%%%%%%%%%
% Vertical %
%%%%%%%%%%%%

% % Scale response matrix by the BPM gains
% for i = 1:size(Sy,2)
%    Sy(:,i) = Sy(:,i) .* BPMyGain(:);
% end
% 
% % Scale response matrix by the VCM gains
% for i = 1:size(Sy,1)
%    Sy(i,:) = Sy(i,:) .* VCMGain(:)';
%    %Sy(i,:) = Sy(i,:) / (1000*amps2rad('VCM',1,i));
% end

figure(gcf+1);
clf reset
set(gcf,'units','normal','position',[.5+Buffer .27+Buffer .5-2*Buffer .72-2*Buffer-HeightBuffer]);

for Mag = 1:NVCMperSector     
    S = [];
    P = [];
    for i = 1:NSectors
        j = findrowindex([i Mag], VCMDev);
        if ~isempty(j)
            k = min(find(BPMyDev(:,1)==i));
            S = [S [Sy(k:end, j); Sy(1:k-1, j)]]; 
            P = [P [BPMys(k:end); BPMys(1:k-1)+L]-BPMys(k)+BPMys(1)]; 
        end
    end
  
    subplot(NVCMperSector, 1, Mag);
    if isempty(S)
        plot(BPMys, NaN*ones(size(BPMys)));        
    else
        plot(P, S);
    end
    ylabel(sprintf('Mag #%d', Mag), 'FontSize', FontSize);
end

subplot(NVCMperSector,1,1);
title(sprintf('Vertical Corrector Magnet Response (%s)', XUnitsString), 'FontSize', FontSize);

subplot(NVCMperSector,1,NVCMperSector);
xlabel('BPM Position [meters]', 'FontSize', FontSize);
if isfield(R(1,1), 'TimeStamp')
    addlabel(1,0,sprintf('%s', datestr(R(1,1).TimeStamp)));
end
orient tall


