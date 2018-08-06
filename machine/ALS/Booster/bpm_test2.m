%%

%TBT = bpm_gettbt;
%FA = bpm_getfa;


n = 1:length(FA{1}.A);
t = 1000*((1:length(FA{1}.A))-1)/FA{1}.fs;

% if (FilterOnNoBeam)
iBeam = find(FA{1}.S>4000);
n = iBeam;

t = t(n) - t(n(1));

FigNum = 11;
figure(FigNum);
clf reset
figure(FigNum+1);
clf reset

clear X Y
for i = 1:length(Prefix)
    figure(FigNum);
    X(i,:) = FA{i}.X(n) - FA{i}.X(n(2500));
    Y(i,:) = FA{i}.Y(n) - FA{i}.Y(n(2500));
    
    h = subplot(3,1,1);
    plot(t, FA{i}.X(n) - FA{i}.X(n(2500)));
    hold on
    h(2) = subplot(3,1,2);
    plot(t, FA{i}.Y(n) - FA{i}.Y(n(2500)));
    hold on
    h(3) = subplot(3,1,3);
    plot(t, FA{i}.S(n));
    hold on
    
    figure(FigNum+1);
    h(4) = subplot(4,1,1);
    plot(t, FA{i}.A(n));
    hold on
    h(5) = subplot(4,1,2);
    plot(t, FA{i}.B(n));
    hold on
    h(6) = subplot(4,1,3);
    plot(t, FA{i}.C(n));
    hold on
    h(7) = subplot(4,1,4);
    plot(t, FA{i}.D(n));
    hold on
end
figure(FigNum);
linkaxes(h, 'x');
drawnow;

subplot(3,1,1);
hold off
axis tight
ylabel('Horizontal [mm]');
xlabel('Time [milliseconds]');
title('FA Data  --  16 Booster BPMs');
subplot(3,1,2);
hold off
axis tight
ylabel('Vertical [mm]');
xlabel('Time [milliseconds]');
subplot(3,1,3);
hold off
ylabel('Sum');
xlabel('Time [milliseconds]');
axis tight

figure(FigNum+1);
subplot(4,1,1);
ylabel('A');
title('FA Data  --  16 Booster BPMs');
subplot(4,1,2);
ylabel('B');
subplot(4,1,3);
ylabel('C');
subplot(4,1,4);
ylabel('D');
xlabel('Time [milliseconds]');


[tt,ii] = meshgrid(t, 1:length(Prefix));

figure(FigNum+2);
clf reset
surf(tt,ii,X);
shading interp
%colormap jet
colormap parula
%brighten(.8);

figure(FigNum+3);
clf reset
surf(tt,ii,Y);
shading interp
%colormap jet
colormap parula
%brighten(.8);









