%Long girders 
global THERING
L = length(THERING);
s = findspos(THERING,1:L);

BPMxFamily = 'BPMx';

spos =getspos(BPMxFamily,family2dev(BPMxFamily));

GirderShift(61, 81, 100E-6, 0E-6);
for i=1:L
    dxLong(i)=0;
    dyLong(i)=0;
    if isfield(THERING{i},'T1')
        dxLong(i)=THERING{i}.T1(1);
        dyLong(i)=THERING{i}.T1(3);
    end
end

long_girder_orbit = getx;
GirderShift(61, 81, 00E-6, 0E-6);
GirderShift(61, 72, 100E-6, 0E-6);
for i=1:L
    dxShort(i)=0;
    dyShort(i)=0;
    if isfield(THERING{i},'T1')
        dxShort(i)=THERING{i}.T1(1);
        dyShort(i)=THERING{i}.T1(3);
    end
end
short_girder_orbit = getx;
GirderShift(71, 72, 00E-6, 0E-6);
GirderShift(74, 74, 100E-6, 0E-6);
for i=1:L
    dxShort(i)=0;
    dyShort(i)=0;
    if isfield(THERING{i},'T1')
        dxShort(i)=THERING{i}.T1(1);
        dyShort(i)=THERING{i}.T1(3);
    end
end
bend_girder_orbit = getx;
GirderShift(74, 74, 00E-6, 0E-6);
GirderShift(76, 86, 100E-6, 0E-6);
for i=1:L
    dxShort(i)=0;
    dyShort(i)=0;
    if isfield(THERING{i},'T1')
        dxShort(i)=THERING{i}.T1(1);
        dyShort(i)=THERING{i}.T1(3);
    end
end
short_girderB_orbit = getx;
figure
subplot(2,2,1)
plot(spos,1E3*long_girder_orbit,'g-');
hold on
plot(spos,1E3*short_girder_orbit,'r-');
plot(spos,1E3*bend_girder_orbit,'b-');
plot(spos,1E3*short_girderB_orbit,'k-');
xaxis([0 270])
ylabel ('Orbit distortion [mm]')
xlabel ('s [m]')
%plot(s, dxLong-8E-4, 'b')
%plot(s, dxShort-8E-4, 'm')
legend('Long girder', 'Short girder A','Bend girder','Short girder B')
%the lattice
drawlattice(-10E-1,200E-3)
subplot(2,2,2)
plot(spos,1E3*long_girder_orbit,'g-');
hold on
plot(spos,1E3*short_girder_orbit,'r-');
xaxis([0 270])
ylabel ('Orbit distortion [mm]')
xlabel ('Long girder and Short Girder A [m]')
subplot(2,2,3)
plot(spos,1E3*long_girder_orbit,'g-');
hold on
plot(spos,1E3*bend_girder_orbit,'b-');
xaxis([0 270])
ylabel ('Orbit distortion [mm]')
xlabel ('Long girder and Bend Girder s [m]')
subplot(2,2,4)
plot(spos,1E3*long_girder_orbit,'g-');
hold on
plot(spos,1E3*short_girderB_orbit,'k-');
xaxis([0 270])
ylabel ('Orbit distortion [mm]')
xlabel ('Long girder and Short Girder B s [m]')
figure(2)
plot(spos,1E3*long_girder_orbit,'g-');
title('Long Girder');
figure(3)
plot(spos,1E3*short_girder_orbit,'r-');
title('Short Girder A');
figure(4)
plot(spos,1E3*bend_girder_orbit,'b-');
title('Short Girder Bending')
figure(5)
plot(spos,1E3*short_girderB_orbit,'k-');
title('Short Girder B')