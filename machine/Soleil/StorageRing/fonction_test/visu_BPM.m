function visu_BPM(ncell,nBPM)

%% visualisation d'un BPM en fonction des tours

BPMxliste = [ncell nBPM];       % BPM n°1
NBPM = dev2elem('BPMx',BPMxliste)
Ntours = 30;             % 10 tours
fileName = '/home/matlabML/measdata/Ringdata/BPM/BPMData_30tours.mat';
load(fileName);


% normalisation des signal somme
[dummy idx] = max(AM.Data.Sum');
for k = 1:120
    Data(k,:) = AM.Data.Sum(k,:)./dummy(k);
end
Sum = Data(NBPM,1:Ntours);
X = AM.Data.X(NBPM,1:Ntours);
Y = AM.Data.Z(NBPM,1:Ntours);
% 
% [X Y] = anabpmnfirstturns(BPMxliste,Ntours,'NoDisplay2'); 
% 
% %% test : comparer le premier tour avec la fonction simple premier tour
% [X1 Y1 Sum] = anabpmfirstturn(BPMxliste,'MaxSum','NoDisplay');
% difference_x = X(1)-X1    % =0 ??
% diference_y = Y(1)-Y1    % =O??

%% plot

spos =  1:Ntours ;
figure(117)

h0 = subplot(6,1,[1 2]);
plot(spos,Sum,'k.-');
ylim([0 1]);
ylabel('signal somme')
name = strcat('BPM n°',num2str(NBPM));
title(name)

h1 = subplot(6,1,[3 4]);
plot(spos,X,'r.-');
hold on
%plot(spos(1),X1,'rs'); % premier tour avec fonction premier tour
hold off
ylabel('X (mm)')

h2 = subplot(6,1,[5 6]);
plot(spos,Y,'b.-');
hold on
%plot(spos(1),Y1,'bs'); % premier tour avec fonction premier tour
hold off
ylabel('Z (mm)')

%linkaxes([h1 h2 ],'Nombre de tours')
set([h0 h1 h2 ],'XGrid','On','YGrid','On');
set([h1 h2 ],'ylim',([-10 10]));
xlabel('Nombre de tours')
