function [x, y, BPMxFamily, QUADxFamily, BPMyFamily, QUADyFamily] = quadbuildoffsetlist(DirName)
%QUADBUILDOFFSETLIST - Collect the date from a quadrupole center run.
%                      When all the quadrupole center data files are stored in a directory this function
%                      will go through all the files and pull out and plot some of the important information.
%
%  [X, Y, BPMxFamily, QUADxFamily, BPMyFamily, QUADyFamily] = quadbuildoffsetlist(DirName)
%
%  DirName - Directory name to look for quadrupole center files  
%            [] to browse
%            {Default: '.'}
%  
%  X - Horizontal output matrix (format below)
%  Y - Vertical output matrix (format below)
%  BPMxFamily, QUADxFamily, BPMyFamily, QUADyFamily - Family name for each center measurement6
%
%             1&2     3       4        5     6       7         8         9      10       11      12       13
%  Output = [BPMDev Center CenterSTD BPMpos DCCT BPMATIndex Quadpos QuadATIndex BPMBeta BPMPhi QuadBeta QuadPhi]
%
%  Written by Greg Portmann


if nargin == 0 
    DirName = '';
end

if isempty(DirName)
    DirName = [getfamilydata('Directory', 'DataRoot'),'QMS\'];
    DirName = uigetdir(DirName, 'Select directory where the QMS data are located');
end

StartDir = pwd;
cd(DirName);

Files = dir;

X = [];
Y = [];
BPMxFamily = [];
QUADxFamily = [];
BPMyFamily = [];
QUADyFamily = [];
for i = 1:length(Files)
    if exist(Files(i).name) == 2
        clear QMS
        try
            load(Files(i).name)
            q = QMS;
            
            if q.QuadPlane == 1
                X = [X; q.BPMDev q.Center q.CenterSTD getspos(q.BPMFamily, q.BPMDev) min(q.DCCT) family2atindex(q.BPMFamily, q.BPMDev) getspos(q.QuadFamily, q.QuadDev) family2atindex(q.QuadFamily, q.QuadDev) datenum(q.TimeStamp)];
                BPMxFamily = strvcat(BPMxFamily, q.BPMFamily);
                QUADxFamily = strvcat(QUADxFamily, q.QuadFamily);
            else
                Y = [Y; q.BPMDev q.Center q.CenterSTD getspos(q.BPMFamily, q.BPMDev) min(q.DCCT) family2atindex(q.BPMFamily, q.BPMDev) getspos(q.QuadFamily, q.QuadDev) family2atindex(q.QuadFamily, q.QuadDev) datenum(q.TimeStamp)];
                BPMyFamily = strvcat(BPMyFamily, q.BPMFamily);
                QUADyFamily = strvcat(QUADyFamily, q.QuadFamily);
            end
            if any(q.DCCT<5)
                fprintf('   %s(%d,%d) (%s) shows a beam less than 5 mamps during the experiment!\n', q.BPMFamily, q.BPMDev, Files(i).name);
            end
        catch
            %lasterr
        end
    end
end
cd(StartDir);


x = X;
y = Y;
return


dx = getlist('BPMx',0);
Xnew = NaN * ones(size(dx,1),size(X,2));
Xnew(:,1:2) = dx;
i = findrowindex(X(:,1:2), dx);
Xnew(i,:) = X; 


dy = getlist('BPMy',0);
Ynew = NaN * ones(size(dy,1),size(Y,2));
Ynew(:,1:2) = dy;
j = findrowindex(Y(:,1:2), dy);
Ynew(j,:) = Y; 


% Get the average Beta and Phi
[BetaX, BetaY] = modeltwiss('Beta'); 
BetaX = [(BetaX(1:end-1)+BetaX(2:end))/2; BetaX(end)];
BetaY = [(BetaY(1:end-1)+BetaY(2:end))/2; BetaY(end)];

[PhiX,  PhiY]  = modeltwiss('Phase'); 
PhiX = [(PhiX(1:end-1)+PhiX(2:end))/2; PhiX(end)];
PhiY = [(PhiY(1:end-1)+PhiY(2:end))/2; PhiY(end)];

i = findrowindex(X(:,1:2), dx);
j = findrowindex(Y(:,1:2), dy);
Xnew = [Xnew NaN*ones(size(Xnew,1),4)];
Xnew(i,end-3:end) = [BetaX(Xnew(i,7)) PhiX(Xnew(i,7)) BetaX(Xnew(i,9)) PhiX(Xnew(i,9))];
Ynew = [Ynew NaN*ones(size(Ynew,1),4)];
Ynew(j,end-3:end) = [BetaY(Ynew(j,7)) PhiY(Ynew(j,7)) BetaY(Ynew(j,9)) PhiY(Ynew(j,9))];

x = Xnew;
y = Ynew;

L = getfamilydata('Circumference');
Nx = size(dx,1); 
Ny = size(dy,1); 

figure;
subplot(2,1,1);
errorbar(x(:,5), x(:,3), x(:,4), '.b');
%errorbar(1:Nx, x(:,3), x(:,4), '.b');
ylabel('Horizontal [mm]');
xaxis([0 L]);
title('BPM Offset');

subplot(2,1,2);
errorbar(x(:,5), y(:,3), y(:,4), '.b');
%errorbar(1:Ny, y(:,3), y(:,4), '.b');
xlabel('BPM Position [meters]');
ylabel('Vertical [mm]');
xaxis([0 L]);


XOffset = getoffset('BPMx', x(:,1:2));
YOffset = getoffset('BPMy', y(:,1:2));

figure;
subplot(2,1,1);
plot(x(:,5), x(:,3)-XOffset, '.b');
ylabel('Horizontal [mm]');
xaxis([0 L]);
title('New BPM Offsets Relative to the Present Offset Orbit');

subplot(2,1,2);
plot(x(:,5), y(:,3)-YOffset, '.b');
xlabel('BPM Position [meters]');
ylabel('Vertical [mm]');
xaxis([0 L]);



figure;
subplot(2,1,1);
plot(x(:,5),360*(x(:,11)-x(:,13))/2/pi,'.r');
ylabel('Horizontal [degrees]');
xaxis([0 L]);
title('Phase Advance Between the BPM and Quadrupole');

subplot(2,1,2);
plot(x(:,5),360*(y(:,11)-y(:,13))/2/pi,'.r');
xlabel('BPM Position [meters]');
ylabel('Vertical [degrees]');
xaxis([0 L]);

figure;
subplot(2,1,1);
plot(x(:,5),x(:,10),'.b', x(:,8),x(:,12),'.r');
ylabel('Horizontal [meters]');
xaxis([0 L]);
legend('BPM', 'Quadrupole');
title('Beta Function at the BPM and Quadrupole');

subplot(2,1,2);
plot(y(:,5),y(:,10),'.b', y(:,8),y(:,12),'.r');
xlabel('Position [meters]');
ylabel('Vertical [meters]');
xaxis([0 L]);
legend('BPM', 'Quadrupole');


figure;
subplot(2,1,1);
plot(x(:,5),x(:,6),'.');
xlabel('Position [meters]');
ylabel('DCCT [mamps]');
xaxis([0 L]);
title('Beam Current During the Horizontal Measurement');

subplot(2,1,2);
plot(y(:,5),y(:,6),'.');
ylabel('DCCT [mamps]');
xaxis([0 L]);
title('Beam Current During the Vertical Measurement');


% Only return the measure centers
i = find(~isnan(x(:,3)));
x = x(i,:);

i = find(~isnan(y(:,3)));
y = y(i,:);
