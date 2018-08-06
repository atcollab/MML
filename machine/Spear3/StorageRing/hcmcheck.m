function hcmcheck
%check sequence of hcm correctors on girders 3,4

%load horizontal reference orbit
xref_ol=getam('BPMx');
  %hotwire BPM [10 4]
  indx=findrowindex([10 4],devlist);
  xref_ol(indx)=0;

  %hotwire BPM [12 4]
  indx=findrowindex([12 4],devlist);
  xref_ol(indx)=0;

%check girder 3 online
delta=2.0;
hcm0=getsp('HCM',[3 3])
setsp('HCM',hcm0+delta,[3 3]);   %online
pause(5);
x=getam('BPMx');
setsp('HCM',hcm0,[3 3]);   %online

  devlist=getlist('BPMx');
  %hotwire BPM [10 4]
  indx=findrowindex([10 4],devlist);
  x(indx)=0;

  %hotwire BPM [12 4]
  indx=findrowindex([12 4],devlist);
  x(indx)=0;
  
figure
subplot(2,1,1)
plot(1.4*(x-xref_ol),'r');
hold on

%simulator
xref_sim=getam('BPMx','simulator');

setsp('HCM',delta,[3 2],'simulator');   %online
x=getam('BPMx','simulator');
setsp('HCM',0,[3 2],'simulator');   %online
plot(x-xref_sim,'b')
setsp('HCM',delta,[3 3],'simulator');   %online
x=getam('BPMx','simulator');
setsp('HCM',0,[3 3],'simulator');   %online
plot(x-xref_sim,'g')
title('HCMs at Girder 3: r=[3 3]/online, b=[3 2]/simulator, g=[3 3]/simulator ')
xlabel('BPM index')
ylabel('horizontal orbit shift')


%check girder 4 online
delta=2.0;
hcm0=getsp('HCM',[4 3])
setsp('HCM',hcm0+delta,[4 3]);   %online
pause(5);
x=getam('BPMx');
setsp('HCM',hcm0,[4 3]);   %online

  devlist=getlist('BPMx');
  %hotwire BPM [10 4]
  indx=findrowindex([10 4],devlist);
  x(indx)=0;

  %hotwire BPM [12 4]
  indx=findrowindex([12 4],devlist);
  x(indx)=0;
  
subplot(2,1,2)
plot(1.4*(x-xref_ol),'r');
hold on

%simulator
setsp('HCM',delta,[4 2],'simulator');   %online
x=getam('BPMx','simulator');
setsp('HCM',0,[4 2],'simulator');   %online
plot(x-xref_sim,'b')
setsp('HCM',delta,[4 3],'simulator');   %simulator
x=getam('BPMx','simulator');
setsp('HCM',0,[4 3],'simulator');   %simulator
plot(x-xref_sim,'g')
title('HCMs at Girder 4: r=[4 3]/online, b=[4 2]/simulator, g=[4 3]/simulator ')
xlabel('BPM index')
ylabel('horizontal orbit shift')


