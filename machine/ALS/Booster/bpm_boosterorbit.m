%%

% Arm
%setpv('BPM','TBT_Arm',1); 
%setpv('BPM','FA_Arm',1);

%TBT1 = bpm_gettbt('BR2:BPM2');
%TBT = bpm_gettbt;


i = find(TBT{1}.S > 50000);
% i = 1:length(TBT{1}.A);
t = 1:length(TBT{1}.A);
iOff = .5e6;  %1e6;

% if (FilterOnNoBeam)
%iBeam = find(TBT{1}.S>4000);
%i = iBeam;

t = t(i) - t(i(1));

FigNum = 1;
figure(FigNum);
clf reset
figure(FigNum+1);
clf reset

clear X Y
h = [];
for j = 1:length(TBT)
    figure(FigNum);
    
    LineColor = nxtcolor;
    
    h(length(h)+1) = subplot(3,1,1);
    plot(t, TBT{j}.X(i) - TBT{j}.X(i(iOff)), 'color', nxtcolor);
    hold on
    h(length(h)+1) = subplot(3,1,2);
    plot(t, TBT{j}.Y(i) - TBT{j}.Y(i(iOff)), 'color', nxtcolor);
    hold on
    h(length(h)+1) = subplot(3,1,3);
    plot(t, TBT{j}.S(i), 'color', nxtcolor);
    hold on
    
    figure(FigNum+1);
    h(length(h)+1) = subplot(4,1,1);
    plot(t, TBT{j}.A(i), 'color', nxtcolor);
    hold on
    h(length(h)+1) = subplot(4,1,2);
    plot(t, TBT{j}.B(i), 'color', nxtcolor);
    hold on
    h(length(h)+1) = subplot(4,1,3);
    plot(t, TBT{j}.C(i), 'color', nxtcolor);
    hold on
    h(length(h)+1) = subplot(4,1,4);
    plot(t, TBT{j}.D(i), 'color', nxtcolor);
    hold on
end
linkaxes(h, 'x');


figure(FigNum);
subplot(3,1,1);
hold off
axis tight
ylabel('Horizontal [mm]');
xlabel('Time [Turns]');
%title('TBT Data  --  16 Booster BPMs');
title('TBT Data  --  Sector 1 BPMs');
subplot(3,1,2);
hold off
axis tight
ylabel('Vertical [mm]');
xlabel('Time [Turns]');
subplot(3,1,3);
hold off
ylabel('Sum');
xlabel('Time [Turns]');
axis tight

figure(FigNum+1);
subplot(4,1,1);
ylabel('A');
%title('TBT Data  --  16 Booster BPMs');
title('TBT Data  --  Sector 1 BPMs');
subplot(4,1,2);
ylabel('B');
subplot(4,1,3);
ylabel('C');
subplot(4,1,4);
ylabel('D');
xlabel('Time [Turns]');


% [tt,ii] = meshgrid(t, 1:length(Prefix));
% 
% figure(FigNum+2);
% clf reset
% surf(tt,ii,X);
% shading interp
% %colormap jet
% colormap parula
% %brighten(.8);
% 
% figure(FigNum+3);
% clf reset
% surf(tt,ii,Y);
% shading interp
% %colormap jet
% colormap parula
% %brighten(.8);









