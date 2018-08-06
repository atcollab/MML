%%

%TBT = bpm_gettbt;


n = 1:length(TBT{1}.A);
t = 1:length(TBT{1}.A);

% if (FilterOnNoBeam)
%iBeam = find(TBT{1}.S>4000);
%n = iBeam;

t = t(n) - t(n(1));

FigNum = 11;
figure(FigNum);
clf reset
figure(FigNum+1);
clf reset

n0 = .5e6;  %1e6;

clear X Y
for i = [3 2 4 1] %1:4 %length(Prefix)
    figure(FigNum);
    X(i,:) = TBT{i}.X(n) - TBT{i}.X(n(n0));
    Y(i,:) = TBT{i}.Y(n) - TBT{i}.Y(n(n0));
    
    h = subplot(3,1,1);
    plot(t, TBT{i}.X(n) - TBT{i}.X(n(n0)));
    hold on
    h(2) = subplot(3,1,2);
    plot(t, TBT{i}.Y(n) - TBT{i}.Y(n(n0)));
    hold on
    h(3) = subplot(3,1,3);
    plot(t, TBT{i}.S(n));
    hold on
    
    figure(FigNum+1);
    h(4) = subplot(4,1,1);
    plot(t, TBT{i}.A(n));
    hold on
    h(5) = subplot(4,1,2);
    plot(t, TBT{i}.B(n));
    hold on
    h(6) = subplot(4,1,3);
    plot(t, TBT{i}.C(n));
    hold on
    h(7) = subplot(4,1,4);
    plot(t, TBT{i}.D(n));
    hold on
end
figure(FigNum);
linkaxes(h, 'x');
drawnow;

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









