function [X, Y, BPMxFamily, QUADxFamily, BPMyFamily, QUADyFamily, DateMatX, DateMatY] = quadgetdata(DirName, PlotFlag)
%QUADGETDATA - Collect the date from a quadrupole center run.
%              When all the quadrupole center data files are stored in a directory this function
%              will go through all the files and pull out some of the important information.
%
%  [X, Y, BPMxFamily, QUADxFamily, BPMyFamily, QUADyFamily, XfileDate, YfilesDate] = quadgetdata(DirName)
%
%  INPUTS
%  1. DirName - Directory name to look for quadrupole center files  
%               [] to browse {Default}
%  2. PlotFlag - 0 to just get data without plotting results, else, plot results
%  
%  OUTPUTS
%  1. X - Horizontal output matrix (format below)
%  2. Y - Vertical output matrix (format below)
%
%             1&2     3       4        5     6       7         8         9
%  Output = [BPMDev Center CenterSTD BPMpos DCCT BPMATIndex Quadpos QuadATIndex]
%
%  3-6. BPMxFamily, QUADxFamily, BPMyFamily, QUADyFamily - Family name for each center measurement
%  7-8. XfileDate, YfilesDate - Date string for the file name

%  Written by Greg Portmann


if nargin == 0
    DirName = '';
end

if nargin < 2
    PlotFlag = 1;
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
DateMatX = [];
DateMatY = [];
for i = 1:length(Files)
    if exist(Files(i).name) == 2
        clear QMS DelHCM DelVCM
        try
            load(Files(i).name)

            %Files(i).name

            % Old middle layer
            if exist('DelHCM')
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

                %fprintf('   %d.  %s(%d,%d)\n', i, q.QuadFamily, q.QuadDev);

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
        end
    end
end

[DateMatX, iX] = sortrows(DateMatX);
[DateMatY, iY] = sortrows(DateMatY);
X = X(iX,:);
Y = Y(iY,:);
BPMxFamily = BPMxFamily(iX,:);
BPMyFamily = BPMyFamily(iY,:);
QUADxFamily = QUADxFamily(iX,:);
QUADyFamily = QUADyFamily(iY,:);

cd(StartDir);


if PlotFlag

    % Plot data
    L = getfamilydata('Circumference');

    figure;
    subplot(2,1,1);
    errorbar(X(:,5), X(:,3), X(:,4), '.b');
    ylabel('Horizontal [mm]');
    xaxis([0 L]);
    title('BPM Offset');

    subplot(2,1,2);
    errorbar(Y(:,5), Y(:,3), Y(:,4), '.b');
    xlabel('BPM Position [meters]');
    ylabel('Vertical [mm]');
    xaxis([0 L]);

end