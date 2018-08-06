function fftest
%FFTEST
%
% FFTEST:  Tests the feed forward tables
%


% Initialize
ArchiveFlag = 0;

global BPMs BPMelem  IDBPMlist

GeV = getenergy;

GeVnum = GeV;
GeVstr = num2str(GeVnum);
  
FFDate = date;
FFClock = clock;

t=0:.5:7*60;
N=length(t);


f1=figure;
f2=figure;
f3=figure;
f4=figure;


% Display test setup
disp([' ']); disp([' ']); 
disp(['         INSERTION DEVICE FEEDFORWARD TABLE TESTING APPLICATION']);
disp([' ']);
disp(['  This program will test a feedforward table at ',num2str(GeV), ' GeV.']);
disp(['  If this is not the correct beam energy, exit (enter 0 for Sector) and run alsinit.']);
disp(['  Before continuing, make sure the following conditions are true.  ']);
disp(['                    *  Multi-bunch mode.']);
disp(['                    *  FF is enabled.']);
disp(['                    *  Velocity Profile is on.']);
disp(['                    *  Gap Control is disabled.']);
disp(['                    *  Current range: 90-110 mAmps.']);
disp(['                    *  Production corrector magnet set.']);
disp(['                    *  Bumps off.']);
disp(['                    *  BPMs calibrated.']);
disp([' ']);

Sector = input('                    Sector (0-exit, 4, 5, 7, 8, 9, 10, 11, 12) = ');
disp(' ');


if Sector == 0
  disp(['  fftest test aborted.']);
  return;
end


% Minimum and maximum gap
[GAPmin, GAPmax] = gaplimit(Sector);
IDVel = maxpv('ID', 'VelocityControl', Sector);

disp(['  The insertion device for sector ',num2str(Sector),' has been selected.']);
disp(['                   Maximum Gap = ',num2str(GAPmax),' mm']);
disp(['                   Mimimum Gap = ',num2str(GAPmin),' mm']);
disp([' ']);
disp(['  Data collection started.']);

% Change to DataRoot directory
DirStart = pwd;

if ispc
    error('Unix only at the moment.');
    cd M:\matlab\srdata\gaptrack
else
    %cd /home/als/physbase/matlab/srdata/gaptrack
  %  cd /home/crconfs1/prod/idcomp_prod_tables
end


% Sector 8
Table = [
209.9998 0.000 0.000 0.000 0.000
199.9996 0.003 -0.008 -0.012 -0.002
190.0016 -0.005 -0.008 -0.024 -0.011
179.9997 -0.013 -0.011 -0.037 -0.018
170.0014 -0.018 -0.016 -0.052 -0.028
159.9995 -0.027 -0.018 -0.067 -0.036
149.9988 -0.029 -0.027 -0.081 -0.045
139.9998 -0.038 -0.032 -0.100 -0.054
130.0016 -0.048 -0.040 -0.127 -0.067
119.9990 -0.052 -0.052 -0.149 -0.077
110.0011 -0.062 -0.061 -0.174 -0.094
100.0018 -0.075 -0.070 -0.199 -0.102
90.0013 -0.081 -0.087 -0.225 -0.114
80.0002 -0.093 -0.102 -0.252 -0.124
70.0009 -0.102 -0.123 -0.277 -0.130
59.9994 -0.104 -0.145 -0.287 -0.126
55.9994 -0.111 -0.154 -0.291 -0.125
51.9991 -0.112 -0.164 -0.288 -0.117
48.0000 -0.111 -0.181 -0.284 -0.111
44.0007 -0.125 -0.188 -0.279 -0.098
40.0011 -0.123 -0.213 -0.256 -0.082
35.9991 -0.129 -0.240 -0.235 -0.065
34.4993 -0.138 -0.248 -0.221 -0.058
33.0004 -0.142 -0.265 -0.211 -0.051
31.4997 -0.145 -0.281 -0.198 -0.046
30.0003 -0.149 -0.299 -0.182 -0.038
28.5012 -0.150 -0.319 -0.168 -0.026
27.0007 -0.157 -0.334 -0.148 -0.023
25.5005 -0.158 -0.353 -0.136 -0.014
23.9989 -0.149 -0.366 -0.117 -0.007
22.4996 -0.137 -0.362 -0.099 -0.009
21.0004 -0.115 -0.334 -0.087 -0.008
19.5000 -0.066 -0.272 -0.072 -0.016
18.9998 -0.037 -0.245 -0.062 -0.020
18.5003 -0.013 -0.205 -0.059 -0.025
18.0009 0.025 -0.167 -0.057 -0.030
17.5004 0.066 -0.120 -0.050 -0.034
17.0002 0.116 -0.074 -0.051 -0.037
16.4995 0.164 -0.016 -0.035 -0.037
15.9987 0.223 0.037 -0.031 -0.040
15.5005 0.279 0.103 -0.022 -0.040
15.0002 0.352 0.165 -0.013 -0.040
14.5006 0.417 0.242 -0.002 -0.037
13.9996 0.505 0.315 0.009 -0.033
];


DataRoot = getfamilydata('Directory','DataRoot');
DirectoryName = [DataRoot, 'ID', filesep, 'feedforward', filesep];
[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
if (Sector(1)==4 || Sector(1)==6 || Sector(1)==11)
    FileNameTable = sprintf('id%02dd%ie%.0f', Sector(1), Sector(2), 10*getenergy);
    FileName = sprintf('id%02dd%ie%.0f_Test', Sector(1), Sector(2), 10*getenergy);
else
    FileNameTable = sprintf('id%02de%2.0f', Sector(1), 10*getenergy);
    FileName = sprintf('id%02de%2.0f_Test', Sector(1), 10*getenergy);
end
FileName = appendtimestamp(FileName);
 
%a = load(FileNameTable, 'ascii');

% % Save in text format
% if (Sector(1)==4 || Sector(1)==6 || Sector(1)==11)
%     FileNameText = sprintf('id%02dd%ie%.0f.txt', Sector(1), Sector(2), 10*getenergy);
% else
%     FileNameText = sprintf('id%02de%2.0f.txt', Sector(1), 10*getenergy);
% end
% fid = fopen(FileNameText, 'wt');
% fprintf(fid,'#Gap     HCM4   HCM1   VCM4   VCM1\n');
% for i=1:size(tableX,1)
%     fprintf(fid,'%.4f %.3f %.3f %.3f %.3f\n', tableX(i,1), tableX(i,2), tableX(i,3), tableY(i,2), tableY(i,3));
% end
% fclose(fid);
% fprintf('  Data saved to %s\n', [pwd, filesep, FileNameText]);



DirStart = pwd;
gotodata
cd ID
cd feedforward


% Set gap to maximum, set velocity to maximum
setid(Sector, GAPmax, IDVel);  
sleep(2);

BPMList = getbpmlist('Bergoz');

% Closing test
DCCT=zeros(1,N);
BPMx=zeros(size(BPMList,1),N); 
BPMy=zeros(size(BPMList,1),N);
tout=zeros(1,N);
Gap =zeros(1,N);
Vel =zeros(1,N);
VCM4=zeros(1,N);
VCM1=zeros(1,N);
HCM4=zeros(1,N);
HCM1=zeros(1,N);


BPMx0 = getx(BPMList);
BPMy0 = gety(BPMList);

setid(Sector, GAPmin, IDVel, 0)

t0 = gettime;
for i = 1:length(t);
	while ((gettime-t0) < t(i))
	end

	tout(1,i) = gettime-t0;

	BPMx(:,i) = getx(1) - BPMx0;
	BPMy(:,i) = gety(1) - BPMy0;

	[Gap(:,i), Vel(:,i)] = getid(Sector);

	HCM4(:,i) = getsp('HCM', [Sector-1 8]);
	HCM1(:,i) = getsp('HCM', [Sector   1]);

	VCM4(:,i) = getsp('VCM', [Sector-1 8]);
	VCM1(:,i) = getsp('VCM', [Sector   1]);

	DCCT(1,i) = getdcct;
	
	if abs(Gap(i)-GAPmin) < .1
		break;
	end

%if DCCT(1,i) < 10
%   error('    Beam current drop below 10 milliamps.  Test aborted!');
%end

end


BPMx0 = getx(BPMList);
BPMy0 = gety(BPMList);


[BPMx1, BPMy1] = getbpm(1,1);
[IDBPMx1, IDBPMy1] = getidbpm(1,1);

DCCT=DCCT(:,1:i);
BPMx=BPMx(:,1:i);
BPMy=BPMy(:,1:i);
IDBPMx=IDBPMx(:,1:i);
IDBPMy=IDBPMy(:,1:i);
t   =   t(:,1:i);
tout=tout(:,1:i);
Gap = Gap(:,1:i);
Vel = Vel(:,1:i);
VCM4=VCM4(:,1:i);
VCM1=VCM1(:,1:i);
HCM4=HCM4(:,1:i);
HCM1=HCM1(:,1:i);


% Save data
eval(['save id', num2str(Sector), 'clos Sector DCCT BPMx0 BPMy0 BPMx1 BPMy1 BPMx BPMy IDBPMx0 IDBPMy0 IDBPMx1 IDBPMy1 IDBPMx IDBPMy t tout Gap Vel VCM4 VCM1 HCM4 HCM1 FFClock FFDate']);


% Plot orbit data
figure(f1); clf
subplot(2,1,1);
plot(Gap, 1000*mean(BPMx))
xlabel('Gap position [mm]');
ylabel('Mean(Diff. Orbit) [microns]');
title(['ID ',num2str(Sector),', Horizontal Orbit Distortion']);

subplot(2,1,2);
plot(Gap, 1000*std(BPMx))
xlabel('Gap position [mm]');
ylabel('RMS(Diff. orbit) [microns]');


figure(f2); clf
subplot(2,1,1);
plot(Gap, 1000*mean(BPMy))
xlabel('Gap position [mm]');
ylabel('Mean(Diff. Orbit) [microns]');
title(['ID ',num2str(Sector),', Vertical Orbit Distortion']);

subplot(2,1,2);
plot(Gap, 1000*std(BPMy))
xlabel('Gap position [mm]');
ylabel('RMS(Diff. orbit) [microns]');


% Plot Corrector Magnets 
% Load the data tables
Datafn = sprintf('id%02de%.0f', Sector, 10*GeVnum);
eval(['load ', Datafn]);

figure(f3); clf
subplot(2,1,1);
plot(Gap,HCM4,tableX(:,1),tableX(:,2)+HCM4(1));                  % closing
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', HCM8 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');

subplot(2,1,2);
plot(Gap,HCM1,tableX(:,1),tableX(:,3)+HCM1(1));                  % closing
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', HCM1 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');

figure(f4); clf
subplot(2,1,1);
plot(Gap,VCM4,tableY(:,1),tableY(:,2)+VCM4(1));                  % closing
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', VCM8 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');

subplot(2,1,2);
plot(Gap,VCM1,tableY(:,1),tableY(:,3)+VCM1(1));                  % closing
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', VCM1 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');


drawnow;
disp('  Closing measurement completed.  Hit return to start the opening measurement.');
pause;
disp('  Opening gap.');


% Opening test
DCCT=zeros(1,N);
BPMx=zeros(96,N); 
BPMy=zeros(96,N);
IDBPMx=zeros(size(IDBPMlist,1),N); 
IDBPMy=zeros(size(IDBPMlist,1),N);
tout=zeros(1,N);
Gap =zeros(1,N);
Vel =zeros(1,N);
VCM4=zeros(1,N);
VCM1=zeros(1,N);
HCM4=zeros(1,N);
HCM1=zeros(1,N);

[BPMx0, BPMy0] = getbpm(1,1);
[IDBPMx0, IDBPMy0] = getidbpm(1,1);

setid(Sector, GAPmax, IDVel, 0)

t0 = gettime;
for i = 1:length(t);
	while ((gettime-t0) < t(i))
	end

	tout(1,i) = gettime-t0;

	BPMx(:,i) = getx(1) - BPMx0;
	BPMy(:,i) = gety(1) - BPMy0;

	IDBPMx(:,i) = getidx(1) - IDBPMx0;
	IDBPMy(:,i) = getidy(1) - IDBPMy0;

	[Gap(:,i), Vel(:,i)] = getid(Sector);

	HCM4(:,i) = getsp('HCM', [Sector-1 8]);
	HCM1(:,i) = getsp('HCM', [Sector   1]);

	VCM4(:,i) = getsp('VCM', [Sector-1 8]);
	VCM1(:,i) = getsp('VCM', [Sector   1]);

	DCCT(1,i) = getdcct;
	
	if abs(Gap(i)-GAPmax) < .1
		break;
	end

%	if DCCT(1,i) < 10
%		error('    Beam current drop below 10 milliamps.  Test aborted!');
%	end
end

[BPMx1, BPMy1] = getbpm(1,1);
[IDBPMx1, IDBPMy1] = getidbpm(1,1);
	
DCCT=DCCT(:,1:i);
BPMx=BPMx(:,1:i);
BPMy=BPMy(:,1:i);
IDBPMx=IDBPMx(:,1:i);
IDBPMy=IDBPMy(:,1:i);
t   =   t(:,1:i);
tout=tout(:,1:i);
Gap = Gap(:,1:i);
Vel = Vel(:,1:i);
VCM4=VCM4(:,1:i);
VCM1=VCM1(:,1:i);
HCM4=HCM4(:,1:i);
HCM1=HCM1(:,1:i);


% Save data
eval(['save id', num2str(Sector), 'open Sector DCCT BPMx0 BPMy0 BPMx1 BPMy1 BPMx BPMy IDBPMx0 IDBPMy0 IDBPMx1 IDBPMy1 IDBPMx IDBPMy t tout Gap Vel VCM4 VCM1 HCM4 HCM1 FFClock FFDate']);


% Plot orbit data
figure(f1); clf
subplot(2,1,1);
plot(Gap, 1000*mean(BPMx))
xlabel('Gap position [mm]');
ylabel('Mean(Diff. Orbit) [microns]');
title(['ID ',num2str(Sector),', Horizontal Orbit Distortion']);

subplot(2,1,2);
plot(Gap, 1000*std(BPMx))
xlabel('Gap position [mm]');
ylabel('RMS(Diff. orbit) [microns]');


figure(f2); clf
subplot(2,1,1);
plot(Gap, 1000*mean(BPMy))
xlabel('Gap position [mm]');
ylabel('Mean(Diff. Orbit) [microns]');
title(['ID ',num2str(Sector),', Vertical Orbit Distortion']);

subplot(2,1,2);
plot(Gap, 1000*std(BPMy))
xlabel('Gap position [mm]');
ylabel('RMS(Diff. orbit) [microns]');


% Plot Corrector Magnets 
% Load the data tables
Datafn = sprintf('id%02de%.0f', Sector, 10*GeVnum);
eval(['load ', Datafn]);

figure(f3); clf
subplot(2,1,1);
plot(Gap,HCM4,tableX(:,1),tableX(:,2)+HCM4(max(size(HCM4))));    % opening
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', HCM8 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');

subplot(2,1,2);  
plot(Gap,HCM1,tableX(:,1),tableX(:,3)+HCM1(max(size(HCM1))));    % opening
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', HCM1 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');

figure(f4); clf
subplot(2,1,1);
plot(Gap,VCM4,tableY(:,1),tableY(:,2)+VCM4(max(size(VCM4))));    % opening
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', VCM8 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');

subplot(2,1,2);
plot(Gap,VCM1,tableY(:,1),tableY(:,3)+VCM1(max(size(VCM1))));    % opening
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', VCM1 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');


% Return of original directory
eval(['cd ', DirStart]);


disp(['  Data collection finished.  Insertion device is at maximum gap.']);
disp([' ']);




% AM.CreatedBy = 'getx';
% AM.DataDescriptor = 'Horizontal Orbit';
% 
% % Archive data structure
% if ArchiveFlag
%     DirStart = pwd;
%     FileName = appendtimestamp([getfamilydata('Default', 'BPMArchiveFile') 'x'], clock);
%     DirectoryName = getfamilydata('Directory','BPMData');
%     if isempty(DirectoryName)
%         DirectoryName = [getfamilydata('Directory','DataRoot'), 'BPM', filesep];
%     end
%     [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
%     BPMxData = AM;
%     save(FileName, 'BPMxData');
% end


% Return of original directory
cd(DirStart);


%figure(1); clf
%plotyy(Gap, mean(BPMx), '-r', Gap, std(BPMx),'--g')
%xlabel('Gap position [mm]');
%ylabel('Mean Horizontal Diff. Orbit [mm]');
%y2label('RMS Horizontal Diff. orbit [mm]');
%title(['ID ',num2str(Sector),', Horizontal Difference Orbit']);
%
%figure(2); clf
%plotyy(Gap, mean(BPMy), '-r', Gap, std(BPMy),'--g')
%xlabel('Gap position [mm]');
%ylabel('Mean Vertical Diff. Orbit [mm]');
%y2label('RMS Vertical Diff. orbit [mm]');
%title(['ID ',num2str(Sector),', Vertical Difference Orbit']);


%figure(5); clf
%subplot(2,1,1);
%plot(BPMs, 1000*max(abs(BPMx'))' );
%xlabel('BPM Position [meters]');
%ylabel('Max. Hor. Change [microns]');
%title(['ID ',num2str(Sector),', Maximum Orbit Distortion']);
%
%subplot(2,1,2);
%plot(BPMs, 1000*max(abs(BPMy'))' );
%xlabel('BPM Position [meters]');
%ylabel('Max. Vert. Change [microns]');

