function [BPMrate, HCMrate, VCMrate] = monrates
%MONRATES - Emperically computes the channel sample rates
%  [BPMrate, HCMrate, VCMrate] = monrates
%
%  Tests the analog monitor data rate for BPMs and corrector magnets 
%  This test will only work if the AM value is very noisy.

%  Written by Greg Portmann


clf reset;

% BPM Sample Rates
Family = 'BPMx';
List = family2dev(Family);
Nsectors = max(List(:,1));
Ndevices = max(List(:,2));
Sector = List(:,1) + List(:,2)/Ndevices + 1/Ndevices/2;
[BPMrate, N] = monrate(Family, List, 10);

subplot(3,1,1);
bar(Sector, BPMrate);
xaxis([1 Nsectors+1])
set(gca,'XTick',1:Nsectors);
title(['BPM Data Rates']);
xlabel('Sector Number');
ylabel('Data Rate [Hz]');


% HCM sample rates
Family = 'HCM';
List = family2dev(Family);
Nsectors = max(List(:,1));
Ndevices = max(List(:,2));
Sector = List(:,1) + List(:,2)/Ndevices + 1/Ndevices/2;
[HCMrate, N] = monrate(Family, List, 5);

subplot(3,1,2);
bar(Sector, HCMrate);
xaxis([1 Nsectors+1])
set(gca,'XTick',1:Nsectors);
title(['HCM Data Rates']);
xlabel('Sector Number');
ylabel('Data Rate [Hz]');

% VCM sample rates
Family = 'VCM';
List = family2dev(Family);
Nsectors = max(List(:,1));
Ndevices = max(List(:,2));
Sector = List(:,1) + List(:,2)/Ndevices + 1/Ndevices/2;
[VCMrate, N] = monrate(Family, List, 5);

subplot(3,1,3);
bar(Sector, VCMrate);
xaxis([1 Nsectors+1])
set(gca,'XTick',1:Nsectors);
title(['VCM Data Rates']);
xlabel('Sector Number');
ylabel('Data Rate [Hz]');


addlabel(1,0);
orient tall