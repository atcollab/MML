function plotDD(AM,isup,ishift)

figure

bpmnum = (1:7)  + ishift;
turnnum = 4:40;

h1=subplot(2,2,1);
plot(AM.Data.Sum(bpmnum ,turnnum)','.-')
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',1+isup))

h2=subplot(2,2,2);
plot(AM.Data.Q(bpmnum ,turnnum)','.-')
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.Data.X(bpmnum,turnnum)','.-')
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.Data.Z(bpmnum,turnnum)','.-')
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

bpmnum = (8:15)  + ishift;

h1=subplot(2,2,1);
plot(AM.Data.Sum(bpmnum,turnnum)','.-')
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',2+isup))

h2=subplot(2,2,2);
plot(AM.Data.Q(bpmnum ,turnnum)','.-')
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.Data.X(bpmnum,turnnum)','.-')
grid on
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.Data.Z(bpmnum,turnnum)','.-')
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

bpmnum = (16:23)  + ishift;

h1=subplot(2,2,1);
plot(AM.Data.Sum(bpmnum,turnnum)','.-')
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',3+isup))

h2=subplot(2,2,2);
plot(AM.Data.Q(bpmnum ,turnnum)','.-')
grid on
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.Data.X(bpmnum,turnnum)','.-')
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.Data.Z(bpmnum,turnnum)','.-')
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

bpmnum = (24:30)  + ishift;

h1=subplot(2,2,1);
plot(AM.Data.Sum(bpmnum,turnnum)','.-')
ylabel('Sum (a.u.)')
suptitle(sprintf('Cell %d',4+isup))

h2=subplot(2,2,2);
plot(AM.Data.Q(bpmnum ,turnnum)','.-')
ylabel('Quad (a.u.)')

h3=subplot(2,2,3);
plot(AM.Data.X(bpmnum,turnnum)','.-')
ylabel('X(mm)')
xlabel('BPM number')

h4=subplot(2,2,4);
plot(AM.Data.Z(bpmnum,turnnum)','.-')
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
