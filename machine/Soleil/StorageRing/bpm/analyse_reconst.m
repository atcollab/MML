function analyse_reconst

load('BPMData_30tours.mat');

% to be set in startup file
set(0,'DefaultAxesColorOrder',(colordg(1:15))); 

%%
Sum  = AM.Data.Va + AM.Data.Vd + AM.Data.Va + AM.Data.Vd;
Quad  = (AM.Data.Va + AM.Data.Vc - AM.Data.Vb - AM.Data.Vd)./Sum;
Kx = 11.4; Kz = 11.4;
XPos = Kx*(AM.Data.Va - AM.Data.Vb + AM.Data.Vd - AM.Data.Vc)./Sum;
ZPos = Kz*(AM.Data.Va + AM.Data.Vb - AM.Data.Vc - AM.Data.Vd)./Sum;

AM.DataR.Sum = Sum; 
AM.DataR.Q = Quad; 
AM.DataR.X = XPos; 
AM.DataR.Z = ZPos; 

% figure;
% plot(repmat((1:8),3),'.-')
% legend('1','2','3','4','5','6','7','8')
 
%% Superperiod 1
figure

isup = 4;
ishift = 30; 


local_plot(isup,ishift)

function local_plot(isup,ishift)

bpmnum = (1:8)  + ishift;
turnnum = 4:40;

h1=subplot(2,2,1);
plot(AM.DataR.Sum(bpmnum ,turnnum)','.-')
ylabel('Sum (a.u.)')
suptitle('Cell 1')

h2=subplot(2,2,2);
plot(AM.DataR.Q(bpmnum ,turnnum)','.-')
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X(bpmnum,turnnum)','.-')
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z(bpmnum,turnnum)','.-')
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');
set([h1 h2 h3 h4],'XGrid','On','YGrid','On');
legendstr = eval(['{', sprintf('''BPM[%2d %d]'',',AM.DeviceList(bpmnum,:)'), '}']);
legend1 = legend(...
  legendstr,...
  'LineWidth',1,...
  'Position',[0.3202 0.4961 0.4257 0.02956],...
  'Orientation','horizontal');

figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum(9:16,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle('Cell 2')

h2=subplot(2,2,2);
plot(AM.DataR.Q(9:16 ,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X(9:16,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z(9:16,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum(17:24,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle('Cell 3')

h2=subplot(2,2,2);
plot(AM.DataR.Q(17:24 ,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X(17:24,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z(17:24,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum(25:31,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle('Cell 4')

h2=subplot(2,2,2);
plot(AM.DataR.Q(25:31 ,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X(25:31,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z(25:31,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

%% Superperiod 2
isup = 4;
ishift = 30; 
figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum((1:8)+ishift ,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',1+isup))

h2=subplot(2,2,2);
plot(AM.DataR.Q((1:8)+ishift ,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X((1:8)+ishift,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z((1:8)+ishift,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum((9:16)+ishift,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',2+isup))

h2=subplot(2,2,2);
plot(AM.DataR.Q((9:16)+ishift,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X((9:16)+ishift,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z((9:16)+ishift,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum((17:24)+ishift,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',3+isup))

h2=subplot(2,2,2);
plot(AM.DataR.Q((17:24)+ishift,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X((17:24)+ishift,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z((17:24)+ishift,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum((25:31)+ishift,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',4+isup))

h2=subplot(2,2,2);
plot(AM.DataR.Q((25:31)+ishift,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X((25:31)+ishift,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z((25:31)+ishift,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

%% superperiod 3
isup = 4*2;
ishift = 30*2; 
figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum((1:8)+ishift ,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',1+isup))

h2=subplot(2,2,2);
plot(AM.DataR.Q((1:8)+ishift ,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X((1:8)+ishift,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z((1:8)+ishift,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum((9:16)+ishift,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',2+isup))

h2=subplot(2,2,2);
plot(AM.DataR.Q((9:16)+ishift,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X((9:16)+ishift,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z((9:16)+ishift,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum((17:24)+ishift,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',3+isup))

h2=subplot(2,2,2);
plot(AM.DataR.Q((17:24)+ishift,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X((17:24)+ishift,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z((17:24)+ishift,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum((25:31)+ishift,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',4+isup))

h2=subplot(2,2,2);
plot(AM.DataR.Q((25:31)+ishift,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X((25:31)+ishift,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z((25:31)+ishift,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');


%% Superperiod 4
isup = 4*3;
ishift = 30*3; 
figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum((1:8)+ishift ,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',1+isup))

h2=subplot(2,2,2);
plot(AM.DataR.Q((1:8)+ishift ,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X((1:8)+ishift,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z((1:8)+ishift,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum((9:16)+ishift,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',2+isup))

h2=subplot(2,2,2);
plot(AM.DataR.Q((9:16)+ishift,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X((9:16)+ishift,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z((9:16)+ishift,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum((17:24)+ishift,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',3+isup))

h2=subplot(2,2,2);
plot(AM.DataR.Q((17:24)+ishift,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X((17:24)+ishift,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z((17:24)+ishift,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

figure

h1=subplot(2,2,1);
plot(AM.DataR.Sum(114:end,turnnum)','.-')
grid on
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',4+isup))

h2=subplot(2,2,2);
plot(AM.DataR.Q(114:end,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.X(114:end,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Z(114:end,turnnum)','.-')
grid on
ylabel('Z(mm)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');

%%


figure

h1=subplot(2,2,1);
plot(AM.DataR.Va(114:end,turnnum)','.-')
grid on
ylabel('Va (a.u.)')
suptitle(sprintf('Cell %d',4+isup))

h2=subplot(2,2,2);
plot(AM.DataR.Vb(114:end,turnnum)','.-')
grid on
ylabel('Vb (a.u.)')

h3=subplot(2,2,3);
plot(AM.DataR.Vc(114:end,turnnum)','.-')
grid on
ylabel('Vc (a.u.)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.DataR.Vd(114:end,turnnum)','.-')
grid on
ylabel('Vd (a.u.)')
xlabel('BPM number')

linkaxes([h1 h2 h3 h4],'x');


%%
etax = modeldisp('BPMx');

%%
ZFFT = fft(AM.DataR.Z(1,:));
figure
zlin = (1:length(ZFFT))/length(ZFFT);
plot(zlin,abs(ZFFT))
%%
mesh(abs(fft(AM.DataR.Z(:,:))))

