function [a, t] = getepicsarchive(ChannelName, StartTime, EndTime)
%GETEPICSARCHIVE - Get data from the ALS EPICS archiver
%
%  INPUTS
%  1. ChannelName - Matrix of channel names
%  2-3. StartTime and EndTime - Matlab date number of any string recognizable by datenum
%
%  EXAMPLES
%  1. 3 hour of BPMx(1,2)
%     ChannelName = family2channel('BPMx', 'Monitor' , [1 2]);
%     [x, t] = getepicsarchive(ChannelName, datestr(now-3/24), datestr(now));
%     plot(t{1}, x{1});
%     datetick x
%     Please note: 3000 max. of number of points retrieved  per channel;
%     StartTime/ EndTime format: datenum('25-Jun-2010 11:06:00');  
%  2. IP Data
%     [x, t] = getepicsarchive('SR04S___IP1CUR_AM02', datestr(now-3/24), datestr(now));
%     semilogy(t{1}, x{1});
%     datetick x
%  3. 3 hour of beam current
%     [x, t] = getepicsarchive('cmm:beam_current', datestr(now-3/24), datestr(now));
%     plot(t{1}, x{1});
%     datetick x




% Written by Greg Portmann & Paola Pace

% Note: needs libreadline.so.5


if ischar(StartTime)
    StartTime = datenum(StartTime);
end

if ischar(EndTime)
    EndTime = datenum(EndTime);
end

if(StartTime >= EndTime)    
   fprintf(2, '   Please enter a correct time interval, expecting StartTime<EndTime');
   a = [];
   t = [];
   return; 
end



% Add to the dynamic Java path (just once)
JaveDynmicJars = javaclasspath('-dynamic');
JarFile = fullfile(getmmlroot,'hlc','archiveviewer','archiveviewer.jar');
if ~any(strcmpi(JarFile, JaveDynmicJars))
	javaaddpath(JarFile);
end


client =[];

if isempty(client)
	tic
	client = epics.archiveviewer.clients.channelarchiver.ArchiverClient();
	%client.connect('http://apps1.als.lbl.gov:8080/RPC2', []);
    client.connect('http://apps1.als.lbl.gov:8080/cgi-bin/ArchiveDataServer.cgi ',[]);
	%fprintf('   client setup time = %.3f seconds\n', toc);
end

%client.getServerInfoText()
 


 
%UTC matlab time reference difference
DateNumber1970 = 719529;  %datenum('1-Jan-1970');

EndTimeMillisec = (EndTime-DateNumber1970)*24*60*60*1000;% EndTime in millisec (local) Pacific Time
EndTimeOffset = java.util.Calendar.getInstance.getTimeZone().getOffset(EndTimeMillisec);% time difference  (ms) between UTC and Pacific Time(local)

StartTimeMillisec = (StartTime-DateNumber1970)*24*60*60*1000;% StartTime in millisec (local) Pacific Time
StartTimeOffset = java.util.Calendar.getInstance.getTimeZone().getOffset(StartTimeMillisec);% time difference  (ms) between UTC and Pacific Time(local)


% convert MATLAB Start/End Time to UTC/archiver start/end time in ms
end_t = (EndTime-DateNumber1970-EndTimeOffset/24/1000/60/60)*24*60*60*1000;
start_t = (StartTime-DateNumber1970-StartTimeOffset/24/1000/60/60)*24*60*60*1000;

try
    x = client.getAvailableArchiveDirectories();
catch ME
    fprintf(2, '\n   Error connecting to the archiver %s\n',ME.message);    
    clear client;
    return;
end


% clear y
tic

% ChannelNames = 'cmm:beam_current|SR01S___IBPM2X_AM02';

NamesString = deblank(ChannelName(1,:));
for i = 2:size(ChannelName)
    NamesString = [NamesString, '|', deblank(ChannelName(i,:))];
end

try
    %         ChannelSearch = client.search(x(1), ArchiverGetStringSet{p}, []);
    ChannelSearch = client.search(x(1), NamesString, []);
catch ME
   
    fprintf(2, '\n   client.search error %s\n',ME.message);
   
    clear client;
    return;
end



%y = client.search(x(1), Names, []);
%fprintf('   client.search time = %.3f seconds\n', toc);

%z = client.getAVEInfo(y(1));

try
    if(~isempty(ChannelSearch) && ~(length(ChannelSearch) <  size(ChannelName,1)))
        %if(~isempty(ChannelSearch))
        z = client.getAVEInfo(ChannelSearch(1));% at least one channel has been retrieved !!!
        
        ArchiverStartTime = z.getArchivingStartTime(); %a reference time (UTC) for data in the archiver 
        if(ArchiverStartTime> start_t)
            fprintf('   Archived data is only available from %s\n', datestr((ArchiverStartTime)/1000/60/60/24+DateNumber1970));
            a=[];
            t=[];
            clear client;
            return;
        end
    else
        fprintf('   Channel Not Found in Archiver [%s]', NamesString);
        a=[];
        t=[];
        clear client;
        return;
    end
catch ME
    fprintf(2, '\n   Error connecting to the Archiver %s\n\n',ME.message);
    a=[];
    t=[];
    clear client;
    return;
end



% start_t = end_t - (EndTime-StartTime)*24*60*60*1000;   % msec

%end_t = z.getArchivingEndTime();
%start_t = z.getArchivingStartTime();
%start_t = end_t - 24*60*60*1000;          % 1 day in msec
% start_t = end_t - 1*60*60*1000;            % 1 hour in msec
%start_t = end_t -      60*1000;            % 1 minute in msec

% catch any Java exception
try
    % Retrive data
    % Methods: raw linear spreadsheet PLot-binning average
    r = client.getRetrievalMethod('raw');
    % r = client.getRetrievalMethod('linear');
    % r = client.getRetrievalMethod('spreadsheet');
    % r = client.getRetrievalMethod('PLot-binning');
    % r = client.getRetrievalMethod('average');
    
    req_obj = epics.archiveviewer.RequestObject(start_t, end_t, r, 3000);
    
    fprintf('   Retrieve start time = %s\n', datestr(start_t/1000/60/60/24 + DateNumber1970 + StartTimeOffset/1000/60/60/24));
    fprintf('   Retrieve end   time = %s\n', datestr(  end_t/1000/60/60/24 + DateNumber1970 + EndTimeOffset/1000/60/60/24));
    tic
    data = client.retrieveData(ChannelSearch, req_obj, []);
    fprintf('   Retrievial time     = %.3f seconds for %.2f hours of data\n', toc, 24*(EndTime-StartTime));
    
    if(size(data,1)<1)
        fprintf(2, '   No data found.\n');
        clear client;
        a=[];
        t=[];
        return;
    end
    
    
catch ME
    fprintf('\n   Error connecting to the Archiver %s\n\n',ME.message);  
    clear client;
    a=[];
    t=[];
    return;
end

% data(1).getNumberOfValues()
% data(1).getValue(1)
% data(1).getValue(2)
% data(1).getValue(3)
% data(1).getTimestampInMsec(3)

% MetaData has a bunch of stuff: {type=double, disp_low=-10.0, disp_high=10.0, alarm_low=-10.0, alarm_high=10.0, warn_low=-10.0, warn_high=10.0, precision=4, units=mm  }
% get(y(i),'MetaData')


tic
clear t a
for i = 1:size(ChannelName,1)  
    NamesSort = char(ChannelSearch(i).getName());
    ii = findrowindex(NamesSort, ChannelName);
    NPoints(i,1) = data(i).getNumberOfValues();
    % Need to initialize this (either [] or NaN)
    t{ii} = [];
    a{ii} = [];
	for j = 1:NPoints(i)
        t{ii}(j) = data(i).getTimestampInMsec(j-1);
		a{ii}(j) = data(i).getValue(j-1).firstElement();
	end
end
%fprintf('   For loop time = %.3f seconds\n', toc);


% Convert time back from UTC/Archiver time to MATLAB time (Pacific Time)
% Get Time difference between UTC time and Pacific Time (including DST), this changes for DST

% empty not ok otherwise
temp=t;
temp(cellfun(@isempty,temp)) = {NaN};
startMin = min(cellfun(@min, temp));

% need to use startMin since might retrieve t < start_t!!!
% TimeOffsetMilliSec = java.util.Calendar.getInstance.getTimeZone().getOffset(start_t);
TimeOffsetMilliSec = java.util.Calendar.getInstance.getTimeZone().getOffset(startMin);
% if DST changes within this time interval
if(TimeOffsetMilliSec ~= java.util.Calendar.getInstance.getTimeZone().getOffset(end_t))
    for i = 1:size(t,2)
        if(~isempty(t{i}))
            for k =1: length(t{i})
                % should return the timedifference in millisecond including daylightsaving time from UTC time to pacific time
                dst = java.util.Calendar.getInstance.getTimeZone().getOffset(t{i}(k));
                t{i}(k) = t{i}(k)/1000/60/60/24 + DateNumber1970 + dst/1000/60/60/24;
            end
        end
    end
else %
    for i = 1:size(t,2)
        if(~isempty(t{i}))
            % Time in Matlab datenum format
            t{i} = t{i}/1000/60/60/24 + DateNumber1970 + TimeOffsetMilliSec/1000/60/60/24;
        end
    end
end


% delete('client');
% delete('data'); 
% delete('req_obj');

a = a';
t = t';

clear client;
clear data;
clear req_obj;
