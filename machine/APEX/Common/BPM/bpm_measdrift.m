%% Get data

clear

[a,b,c,d, Prefix] = bpm_getchannelnames;
PVx = family2channel('BPMx');
PVy = family2channel('BPMy');
Dev = family2dev('BPMx');


for i = 1:5000
    
    [BPMx.Data(:,i), tmp, BPMx.DataTime(:,i)] = getx;
    [BPMy.Data(:,i), tmp, BPMy.DataTime(:,i)] = gety;
    [BPM.A(:,i), tmp, BPM.ATime(:,i)] = getpvonline(a);
    [BPM.B(:,i), tmp, BPM.BTime(:,i)] = getpvonline(b);
    [BPM.C(:,i), tmp, BPM.CTime(:,i)] = getpvonline(c);
    [BPM.D(:,i), tmp, BPM.DTime(:,i)] = getpvonline(d);
    DCCT(:,i) = getpv('DCCT');
    t(:,i) = now;
    i
    %pause(1);

   % if mod(i,100) == 0
   % save BPMDriftTest1
   % end
end

BPM.ATime = labca2datenum(BPM.ATime);
BPM.BTime = labca2datenum(BPM.BTime);
BPM.CTime = labca2datenum(BPM.CTime);
BPM.DTime = labca2datenum(BPM.DTime);

save BPMDriftTest_Set1




%%

load BPMDriftTest1

iNSLS2  = [];
iBergoz = [];
for i = 1:size(PVx,1)
    if strfind(PVx(i,:),'{')
        iNSLS2  = [iNSLS2; i];
    else
        iBergoz  = [iBergoz; i];
    end
end


%%

tout = 24*60*(t - t(1));

% Remove the starting orbit
Mx = BPMx.Data;
for i = 1:size(Mx,2)
    Mx(:,i) = Mx(:,i) - BPMx.Data(:,200);
end

My = BPMy.Data;
for i = 1:size(My,2)
    My(:,i) = My(:,i) -  BPMy.Data(:,200);
end


A = BPM.A;
for i = 1:size(A,2)
    A(:,i) = A(:,i) -  BPM.A(:,1);
end
B = BPM.B;
for i = 1:size(B,2)
    B(:,i) = B(:,i) -  BPM.B(:,1);
end
C = BPM.C;
for i = 1:size(C,2)
    C(:,i) = C(:,i) -  BPM.C(:,1);
end
D = BPM.D;
for i = 1:size(D,2)
    D(:,i) = D(:,i) -  BPM.D(:,1);
end


figure(1);
clf reset

subplot(2,1,1);
plot(tout, Mx);
grid on;
%title(sprintf('BPM Data (%s)', datestr(BPMx.TimeStamp)))
xlabel('Time [Minutes]');
ylabel('Horizontal Position [mm]');
yaxis([-.5 .5]);

subplot(2,1,2);
plot(tout, My);
grid on;
xlabel('Time [Seconds]');
ylabel('Vertical Position [mm]');
yaxis([-1 1]);

xaxiss([0 25]);


figure(2);
clf reset

subplot(2,2,1);
plot(tout, Mx(iNSLS2,:));
grid on;
xlabel('Time [Minutes]');
ylabel('Horizontal Position [mm]');
title('New BPMs');
yaxis([-.5 .5]);

subplot(2,2,3);
plot(tout, My(iNSLS2,:));
grid on;
xlabel('Time [Seconds]');
ylabel('Vertical Position [mm]');
yaxis([-1 1]);

subplot(2,2,2);
plot(tout, Mx(iBergoz,:));
grid on;
xlabel('Time [Minutes]');
ylabel('Horizontal Position [mm]');
title('Bergoz BPMs');
yaxis([-.1 .15]);

subplot(2,2,4);
plot(tout, My(iBergoz,:));
grid on;
xlabel('Time [Seconds]');
ylabel('Vertical Position [mm]');
yaxis([-.1 .1]);

xaxiss([0 25]);

% % Compute the standard deviation
% if 0    % Definition of standard deviations
%     BPMx.Sigma = std(BPMx.Data,0,2);
%     BPMy.Sigma = std(BPMy.Data,0,2);
% else
%     
%     % Low frequency drifting increases the STD.  For many purposes, like LOCO,
%     % this is not desireable.  Using difference orbits mitigates the drift problem.
%     Mx = BPMx.Data;
%     for i = 1:size(Mx,2)-1
%         Mx(:,i) = Mx(:,i+1) - Mx(:,i);
%     end
%     Mx(:,end) = [];
%     
%     My = BPMy.Data;
%     for i = 1:size(My,2)-1
%         My(:,i) = My(:,i+1) - My(:,i);
%     end
%     My(:,end) = [];
%     
%     BPMx.Sigma = std(Mx,0,2) / sqrt(2);   % sqrt(2) comes from substracting 2 random variables
%     BPMy.Sigma = std(My,0,2) / sqrt(2);
%     
% end
% 
% figure(1);
% subplot(2,2,2);
% s = getspos('BPMx',  Dev);
% plot(s, BPMx.Sigma);
% grid on;
% axis tight;
% xlabel('BPM Position [m]');
% ylabel(sprintf('Horizontal STD [mm]'));
% 
% subplot(2,2,4);
% plot(s, BPMy.Sigma);
% grid on;
% axis tight;
% xlabel('BPM Position [m]');
% ylabel(sprintf('Vertical STD [mm]'));
% 
% addlabel(.5,1,sprintf('BPM Data (%s)', datestr(t(1))), 10);
% orient landscape


figure(3);
clf reset

subplot(2,2,1);
plot(tout, A);
grid on;
xlabel('Time [Minutes]');
ylabel('A');
yaxis([0 .0225]);

subplot(2,2,2);
plot(tout, B);
grid on;
xlabel('Time [Minutes]');
ylabel('B');
yaxis([0 .0225]);

subplot(2,2,3);
plot(tout, C);
grid on;
xlabel('Time [Minutes]');
ylabel('C');
yaxis([0 .0225]);

subplot(2,2,4);
plot(tout, D);
grid on;
xlabel('Time [Minutes]');
ylabel('D');
yaxis([0 .0225]);

xaxiss([0 25]);


figure(5);
clf reset
plot(tout, DCCT);
grid on;

xlabel('Time [Minutes]');
ylabel('DCCT [mA]');
xaxiss([0 25]);


