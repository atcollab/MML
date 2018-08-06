% need libreadline.so.5

% Add to the dynamic Java path (just once)
JaveDynmicJars = javaclasspath('-dynamic');
JarFile = fullfile(getmmlroot,'hlc','archiveviewer','archiveviewer.jar');
if ~any(strcmpi(JarFile, JaveDynmicJars))
	javaaddpath(JarFile);
end

if ~exist('client', 'var')
	tic
	client = epics.archiveviewer.clients.channelarchiver.ArchiverClient();
	client.connect('http://apps1.als.lbl.gov:8080/RPC2', []);
	fprintf('   client setup time = %.3f seconds\n', toc);
end

%client.getServerInfoText()
 
 
x = client.getAvailableArchiveDirectories();
%x(1).getName

clear y
tic
%ChannelNames = 'cmm:beam_current|SR01S___IBPM2X_AM02';
%ChannelNames = 'SR11U___GDS1PS_AM00';
ChannelNames = 'IGPF:LFB:SHIFTGAIN';
% Names = family2channel('BPMx', getbpmlist('Bergoz'));
% ChannelNames = deblank(Names(1,:));
% for i = 2:size(Names,1)
% 	ChannelNames = [ChannelNames, '|', deblank(Names(i,:))];
% end

y = client.search(x(1), ChannelNames, []);
fprintf('   client.search time = %.3f seconds\n', toc);

% tic
% y1= client.search(x(1), 'cmm:beam_current', []);

% toc
%y2 = client.search(x(1), 'SR01S___IBPM2X_AM02', []);
%tic
%y3 = client.search(x(1), 'SR01S*', []);
%toc

z = client.getAVEInfo(y(1));

end_t = z.getArchivingEndTime();
%start_t = z.getArchivingStartTime();
start_t = end_t - 1000*60*60*1000;            % time is in msec

r = client.getRetrievalMethod('raw');    % Methods: raw linear spreadsheet plot-binning average

%tic
req_obj = epics.archiveviewer.RequestObject(start_t, end_t, r, 1000);
%toc

tic
data = client.retrieveData(y, req_obj, []);
fprintf('   client.retrieveData time = %.3f seconds\n', toc);

% data(1).getNumberOfValues()
% data(1).getValue(1)
% data(1).getValue(2)
% data(1).getValue(3)
% data(1).getTimestampInMsec(3)

N = get(data(1),'NumberOfValues');

tic
clear t
for i= 1:data.length
      Tot = data(i).getNumberOfValues();
      for j=1:Tot;
         data(i).getValue(j-1).firstElement(); 
          data(i).getTimestampInMsec(j-1);
      end
end 

for j = 1:N
    t(1,j) = data(1).getTimestampInMsec(j-1);
    for i = 1:size(data)
        a(i,j) = data(i).getValue(j-1).firstElement();
    end
end
fprintf('   For loop time = %.3f seconds\n', toc);




% Time in hours
t = (t - t(1)) / 1000 / 60 / 60;


plot(t,a);


%delete('client'); clear client;
%delete('data'); clear data;
%delete('req_obj'); clear req_obj;


% >> javaaddpath(fullfile(matlabroot,'work','archiveviewer.jar'))
% 
% >> client = epics.archiveviewer.clients.channelarchiver.ArchiverClient();
% 
% >> client.connect('http://ees101/archive/cgi/ArchiveDataServer.cgi', []);
% 
% >> client.getServerInfoText()
% http://ees101/archive/cgi/ArchiveDataServer.cgi
% Server version: 0
% ----------------------------------------
% Description
% Channel Archiver Data Server V0,
% built Dec  7 2005, 10:04:55
% from sources for version 2.6.0
% Config: '/mnt/disk1/www/html/archive/serverconfig.xml'
% ----------------------------------------
% Methods
% average
% linear
% plot-binning
% spreadsheet
% raw
% 
% 
% 
% >> x = client.getAvailableArchiveDirectories()
% epics.archiveviewer.ArchiveDirectory[]:
%     [epics.archiveviewer.clients.channelarchiver.ArchiveInfo]
% 
% 
% >> x(1).getName
% Room128
% 
% >> y = client.search(x(1), 'gun_hv_volt_rdbk', [])
% epics.archiveviewer.AVEntry[]:
%     [epics.archiveviewer.clients.channelarchiver.CAEntry]
% 
% >> z = client.getAVEInfo(y(1))
% epics.archiveviewer.AVEntryInfo@86359
% 
% >> start_t = z.getArchivingStartTime()
% 1.1685e+012
% 
% >> end_t = z.getArchivingEndTime()
% 1.1713e+012
% 
% >> r = client.getRetrievalMethod('linear')
% linear
% 
% >> req_obj = epics.archiveviewer.RequestObject(start_t, end_t, r, 1000)
% epics.archiveviewer.RequestObject@80000003
% 
% >> data = client.retrieveData(y, req_obj, [])
% epics.archiveviewer.ValuesContainer[]:
%     [epics.archiveviewer.clients.channelarchiver.NumericValuesContainer]
% 
% >> data(1).getNumberOfValues()
% 248
% 
% >> data(1).getValue(1)
% [0.0]
% 
% >> data(1).getValue(2)
% [0.0]
% 
% >> data(1).getValue(3)
% [176.269315853876]
% 
% >> data(1).getTimestampInMsec(3)
% 1.1685e+012
