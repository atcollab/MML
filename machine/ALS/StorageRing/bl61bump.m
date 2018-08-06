function bl61bump(offsetfac, anglefac)
% function bl61bump(offsetfac, anglefac)
%
% This function generates a vertical offset and or angle bump at
% BL 6.1 using 7 vertical correction magnets.
%
% Christoph Steier, November 2004


% Turn feedforward off
%setff([],0);

ModelFlag = strcmpi(getmode('BPMy'),'Simulator');

HCMList = getcmlist('HCM','1 2 3 4 5 6 7 8');
VCMList = getcmlist('VCM','1 2 4 5 7 8');


BPMxList = getbpmlist('BPMx', '2 3 4 5 6 7 8 9');
BPMyList = getbpmlist('BPMy', '2 3 4 5 6 7 8 9');

% Missing BPMs
BPMxList96 = getbpmlist('BPMx', '2 3 4 5 6 7 8 9','IgnoreStatus');
BPMIndex = findrowindex(BPMxList, BPMxList96);


%load('/home/als/physbase/matlab/chris/commands/bl61bumps.mat');
%load('/home/als/physbase/matlab2004/users/portmann/bl6bumps/bl61bumps.mat');
load([getfamilydata('Directory','OpsData'), 'bl61bumps.mat']);
orbit_angle = orbit_angle(:,BPMIndex);
orbit_offset = orbit_offset(:,BPMIndex);


x0 = getx(BPMxList);
%x0real = raw2real('BPMx', 'Monitor', x0, BPMxList);

y0 = gety(BPMyList);
%y0real = raw2real('BPMy', 'Monitor', y0, BPMyList);

xgolden = getgolden('BPMx', BPMxList);
ygolden = getgolden('BPMy', BPMyList);

if nargin < 1
    offsetfac = input('   Offset factor (times 1 mm at 6.1) ');
end

if nargin < 2
    anglefac = input('   Angle factor (times 0.1 mrad at 6.1) ');
end

if isnan(offsetfac) || isnan(anglefac)
    error('Input arguments are NaN');
end



f1 = 1; %figure;
f2 = 2; %figure;

BPMs = getspos('BPMx', BPMxList);


figure(f1);
clf reset
subplot(2,1,1);
plot(BPMs,x0-xgolden,'bx-');
hold on
subplot(2,1,2);
plot(BPMs,y0-ygolden,'bo-');
hold on

figure(f2);
clf reset
subplot(2,1,1);
plot(BPMs,x0-x0,'bx-');
hold on
subplot(2,1,2);
plot(BPMs, offsetfac*orbit_offset(3,:)'*1e3+anglefac*orbit_angle(3,:)'*1e3,'bo-');
hold on

if ModelFlag
    [xm0, ym0, Sx, Sy] = modeltwiss('x');
end

ynew = y0+offsetfac*orbit_offset(3,:)'*1e3+anglefac*orbit_angle(3,:)'*1e3;

%ynewReal = y0+offsetfac*orbit_offset(3,:)'*1e3+anglefac*orbit_angle(3,:)'*1e3;
%ynewRaw = real2raw('BPMy', 'Monitor', ynewReal, BPMyList);

fprintf('   Starting the orbit bump\n');
setbpm('HCM', x0,   HCMList, BPMxList, ...
       'VCM', ynew, corrlist, BPMyList, 4, 1.5e-3 );
   
% Raw may not be working because there is an offset???    
%setbpm('HCM', x0,    HCMList, BPMxList, ...
%       'VCM', ynewRaw, corrlist, BPMyList, 4, 1.5e-3 );
fprintf('   Orbit bump complete.\n');

if ModelFlag
    [xm1, ym1] = modeltwiss('x');
end

x1 = getx(BPMxList);
%x1 = raw2real('BPMx', 'Monitor', x1, BPMxList);

y1 = gety(BPMyList);
%y1 = raw2real('BPMy', 'Monitor', y1, BPMyList);


figure(f1);
subplot(2,1,1);
plot(BPMs, x1-xgolden, 'rx-');
hold off
ylabel('BPMx [mm]');
title('BL 6.2 Orbit Bump: Different from the Golden Orbit');
legend('Goal Orbit', 'Final Orbit', 0);
subplot(2,1,2);
plot(BPMs, y1-ygolden, 'ro-');
hold off
xlabel('BPM Position [Meters]');
ylabel('BPMy [mm]');

figure(f2);
subplot(2,1,1);
plot(BPMs, x1-x0, 'rx-');
if ModelFlag
    plot(Sx, 1e3*(xm1-xm0),'g');
end
hold off

legend('Goal Orbit', 'Final Orbit', 0);
ylabel('\DeltaBPMx [mm]');
title('BL 6.2 Orbit Bump');

subplot(2,1,2);
plot(BPMs, y1-y0, 'ro-');

if ModelFlag
    plot(Sy, 1e3*(ym1-ym0),'g');
end
hold off

xlabel('BPM Position [Meters]');
ylabel('\DeltaBPMy [mm]');

addlabel(0, 0, 'BPM gains have been taken into account.');
addlabel(1, 0, datestr(clock,0));

