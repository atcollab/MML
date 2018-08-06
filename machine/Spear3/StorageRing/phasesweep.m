
x=[];
y=[];
phasevect=[];

nstep=18;
step=20;
offset=-180;
for k=1:nstep
    phase=offset+(k-1)*step;
    disp([num2str(k) ' of ' num2str(nstep) ': step rf phase to ' num2str(phase) ' degrees'])
    phasevect=[phasevect phase ];
    setpv('SRF1:STN:PHASE',phase);
    pause(4)
    x=[x getam('BPMx',[3 6])];
    y=[y getam('BPMy',[3 6])];
end

figure
subplot(2,1,1)
plot(phasevect,1000*x)
ylabel('x (micron)');
xlabel('rf phase (deg)')
title('BPM [3 6] processed through BPM [3 6] electronics')

subplot(2,1,2)
plot(phasevect,1000*y)
ylabel('y (micron)');
xlabel('rf phase (deg)')

