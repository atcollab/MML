function [X, Y, BPMxFamily, QUADxFamily, BPMyFamily, QUADyFamily, DateMatX, DateMatY] = quadplotall(DirName)
%QUADPLOTALL - Collects the date from a quadrupole center run.
%              When all the quadrupole center data files are stored in a directory this function
%              will go through all the files and pull out and plot some of the important information.
%
%  [X, Y, BPMxFamily, QUADxFamily, BPMyFamily, QUADyFamily] = quadplotall(DirName)
%
%  DirName - Directory name to look for quadrupole center files
%            {Default or '': browse for a directory}
%
%  X - Horizontal output matrix (format below)
%  Y - Vertical   output matrix (format below)
%  BPMxFamily, QUADxFamily, BPMyFamily, QUADyFamily - Family name for each center measurement
%
%             1&2     3       4        5     6       7         8         9      10       11      12       13
%  Output = [BPMDev Center CenterSTD BPMpos DCCT BPMATIndex Quadpos QuadATIndex BPMBeta BPMPhi QuadBeta QuadPhi]
%
%  To combine the old and new offsets:
%  [x, y] = quadplotall;
%  DevListTotal = family2dev('BPMx');
%  xoff = getoffset('BPMx', DevListTotal);
%  i = findrowindex(x(:,1:2), DevListTotal);
%  xoff(i) = x(:,3);
%  DevListTotal = family2dev('BPMy');
%  yoff = getoffset('BPMy', DevListTotal);
%  i = findrowindex(y(:,1:2), DevListTotal);
%  yoff(i) = y(:,3);
%  [DevListTotal xoff yoff]

%  Written by Greg Portmann


PlotFlag = 1;


LineType = '.r';

if nargin == 0
    DirName = '';
end

if isempty(DirName)
    DirName = [getfamilydata('Directory', 'DataRoot'), 'QMS', filesep];
    DirName = uigetdir(DirName, 'Select directory where the QMS data are located');
end

StartDir = pwd;
cd(DirName);

Files = dir('*.mat');

X = [];
Y = [];
BPMxFamily = [];
QUADxFamily = [];
BPMyFamily = [];
QUADyFamily = [];
DateMatX = [];
DateMatY = [];
for i = 1:length(Files)
    if exist(Files(i).name, 'file') == 2
        clear QMS DelHCM DelVCM
        try
            load(Files(i).name)
            
            %Files(i).name
            
            % Backward compatibility issues
            if exist('DelHCM')
                % Old middle layer
                clear q
                [q.Center, q.CenterSTD, ErrorString] = quadhplt(Files(i).name);
                q.BPMFamily = 'BPMx';
                q.BPMDev = BPMnum + [0 1];
                q.DCCT = NaN;
                [q.QuadFamily, q.QuadDev] = bpm2quad(q.BPMFamily, q.BPMDev);
                
                X = [X; q.BPMDev q.Center q.CenterSTD getspos(q.BPMFamily, q.BPMDev) min(q.DCCT) family2atindex(q.BPMFamily, q.BPMDev) getspos(q.QuadFamily, q.QuadDev) family2atindex(q.QuadFamily, q.QuadDev)];
                BPMxFamily = strvcat(BPMxFamily, q.BPMFamily);
                QUADxFamily = strvcat(QUADxFamily, q.QuadFamily);
                DateMatX = [DateMatX; Files(i).date];
                
            elseif exist('DelVCM')
                % Old middle layer
                clear q
                [q.Center, q.CenterSTD, ErrorString] = quadvplt(Files(i).name);
                q.BPMFamily = 'BPMy';
                q.BPMDev = BPMnum + [0 1];
                q.DCCT = NaN;
                [q.QuadFamily, q.QuadDev] = bpm2quad(q.BPMFamily, q.BPMDev);
                
                Y = [Y; q.BPMDev q.Center q.CenterSTD getspos(q.BPMFamily, q.BPMDev) min(q.DCCT) family2atindex(q.BPMFamily, q.BPMDev) getspos(q.QuadFamily, q.QuadDev) family2atindex(q.QuadFamily, q.QuadDev)];
                BPMyFamily = strvcat(BPMyFamily, q.BPMFamily);
                QUADyFamily = strvcat(QUADyFamily, q.QuadFamily);
                DateMatY = [DateMatY; Files(i).date];
                
            else
                
                % New middle layer
                q = QMS;
                
                % Change the BPMSTD
                %q.BPMSTD = .01;  % mm?
                %q.OutlierFactor = 10;
                
                % Change the fit
                if q.QuadPlane == 1
                    q.QuadraticFit = 1;   % 0->Linear, 1-> Quadratic
                else
                    q.QuadraticFit = 0;   % 0->Linear, 1-> Quadratic
                end
                
                
                if PlotFlag
                    fprintf('   %d.  %s(%d,%d)\n', i, q.QuadFamily, q.QuadDev);
                    q = quadplot(q, 1);
                    drawnow;
                    pause
                    %close all
                else
                    q = quadplot(q, 0);
                end
                
                
                if q.QuadPlane == 1
                    X = [X; q.BPMDev q.Center q.CenterSTD getspos(q.BPMFamily, q.BPMDev) min(q.DCCT) family2atindex(q.BPMFamily, q.BPMDev) getspos(q.QuadFamily, q.QuadDev) family2atindex(q.QuadFamily, q.QuadDev)];
                    BPMxFamily = strvcat(BPMxFamily, q.BPMFamily);
                    QUADxFamily = strvcat(QUADxFamily, q.QuadFamily);
                    DateMatX = [DateMatX; Files(i).date];
                else
                    Y = [Y; q.BPMDev q.Center q.CenterSTD getspos(q.BPMFamily, q.BPMDev) min(q.DCCT) family2atindex(q.BPMFamily, q.BPMDev) getspos(q.QuadFamily, q.QuadDev) family2atindex(q.QuadFamily, q.QuadDev)];
                    BPMyFamily = strvcat(BPMyFamily, q.BPMFamily);
                    QUADyFamily = strvcat(QUADyFamily, q.QuadFamily);
                    DateMatY = [DateMatY; Files(i).date];
                end
                if any(q.DCCT<5)
                    fprintf('   %s(%d,%d) (%s) shows a beam less than 5 mamps during the experiment!\n', q.BPMFamily, q.BPMDev, Files(i).name);
                end
            end
        catch
            fprintf(2, '   %s failed!!!\n', Files(i).name);
        end
    else
    end
end

if ~isempty(X)
    [tmp, iX] = sortrows(X(:,5));
    X = X(iX,:);
    BPMxFamily = BPMxFamily(iX,:);
    QUADxFamily = QUADxFamily(iX,:);
end

if ~isempty(Y)
    [tmp, iY] = sortrows(Y(:,5));
    Y = Y(iY,:);
    BPMyFamily = BPMyFamily(iY,:);
    QUADyFamily = QUADyFamily(iY,:);
end

% [DateMatX, iX] = sortrows(DateMatX);
% [DateMatY, iY] = sortrows(DateMatY);
% X = X(iX,:);
% Y = Y(iY,:);
% BPMxFamily = BPMxFamily(iX,:);
% BPMyFamily = BPMyFamily(iY,:);
% QUADxFamily = QUADxFamily(iX,:);
% QUADyFamily = QUADyFamily(iY,:);
%
% cd(StartDir);
%
% % x = X;
% % y = Y;
% % return
%
% if ~isempty(X)
%     dx = getlist('BPMx',0);
%     Xnew = NaN * ones(size(dx,1),size(X,2));
%     Xnew(:,1:2) = dx;
%     i = findrowindex(X(:,1:2), dx);
%     Xnew(i,:) = X;
% end
%
%
% if ~isempty(Y)
%     dy = getlist('BPMy',0);
%     Ynew = NaN * ones(size(dy,1),size(Y,2));
%     Ynew(:,1:2) = dy;
%     j = findrowindex(Y(:,1:2), dy);
%     Ynew(j,:) = Y;
% end
%
% % Get the average Beta and Phi
% [BetaX, BetaY] = modeltwiss('Beta');
% BetaX = [(BetaX(1:end-1)+BetaX(2:end))/2; BetaX(end)];
% BetaY = [(BetaY(1:end-1)+BetaY(2:end))/2; BetaY(end)];
%
% [PhiX,  PhiY]  = modeltwiss('Phase');
% PhiX = [(PhiX(1:end-1)+PhiX(2:end))/2; PhiX(end)];
% PhiY = [(PhiY(1:end-1)+PhiY(2:end))/2; PhiY(end)];
%
% i = findrowindex(X(:,1:2), dx);
% j = findrowindex(Y(:,1:2), dy);
% Xnew = [Xnew NaN*ones(size(Xnew,1),4)];
% Xnew(i,end-3:end) = [BetaX(Xnew(i,7)) PhiX(Xnew(i,7)) BetaX(Xnew(i,9)) PhiX(Xnew(i,9))];
% Ynew = [Ynew NaN*ones(size(Ynew,1),4)];
% Ynew(j,end-3:end) = [BetaY(Ynew(j,7)) PhiY(Ynew(j,7)) BetaY(Ynew(j,9)) PhiY(Ynew(j,9))];
%
% x = Xnew;
% y = Ynew;
%
% L = getfamilydata('Circumference');
% Nx = size(dx,1);
% Ny = size(dy,1);

% figure(1);
% subplot(2,1,1);
% errorbar(x(:,5), x(:,3), x(:,4), LineType);
% %errorbar(1:Nx, x(:,3), x(:,4), LineType);
% %xlabel('BPM Position [meters]');
% %xlabel('BPM Number');
% ylabel('Horizontal [mm]');
% xaxis([0 L]);
% title('BPM Offset');
%
% subplot(2,1,2);
% errorbar(y(:,5), y(:,3), y(:,4), LineType);
% %errorbar(1:Ny, y(:,3), y(:,4), LineType);
% xlabel('BPM Position [meters]');
% ylabel('Vertical [mm]');
% xaxis([0 L]);
%
%
% figure(2);
% subplot(2,1,1);
% plot(x(:,5), 360*(x(:,11)-x(:,13))/2/pi, LineType);
% xlabel('BPM Position [meters]');
% ylabel('Horizontal [degrees]');
% xaxis([0 L]);
% title('Phase Advance Between the BPM and Quadrupole');
%
% subplot(2,1,2);
% plot(y(:,5), 360*(y(:,11)-y(:,13))/2/pi, LineType);
% xlabel('BPM Position [meters]');
% ylabel('Vertical [degrees]');
% xaxis([0 L]);
%
% figure(3);
% subplot(2,1,1);
% plot(x(:,5), x(:,10),'.b', x(:,8),x(:,12),'.r');
% xlabel('Position [meters]');
% ylabel('Horizontal [meters]');
% xaxis([0 L]);
% legend('BPM', 'Quadrupole', 0);
% title('Beta Function at the BPM and Quadrupole');
%
% subplot(2,1,2);
% plot(y(:,5),y(:,10),'.b', y(:,8),y(:,12),'.r');
% xlabel('Position [meters]');
% ylabel('Vertical [meters]');
% xaxis([0 L]);
% legend('BPM', 'Quadrupole', 0);
%
%
% figure(4);
% subplot(2,1,1);
% plot(x(:,5),x(:,6),LineType);
% xlabel('Position [meters]');
% ylabel('DCCT [mamps]');
% xaxis([0 L]);
% title('Beam Current During the Horizontal Measurement');
%
% subplot(2,1,2);
% plot(y(:,5),y(:,6),LineType);
% xlabel('Position [meters]');
% ylabel('DCCT [mamps]');
% xaxis([0 L]);
% title('Beam Current During the Vertical Measurement');


% Only return the measure centers
% i = find(~isnan(x(:,3)));
% x = x(i,:);
%
% i = find(~isnan(y(:,3)));
% y = y(i,:);


fprintf('   End of function\n');
% tic
