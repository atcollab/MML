function [d, Date, ChannelName] = readepicsstriptool(FileName, N)
%READEPICSSTRIPTOOL - Read the data from an EPICS striptool file save
%  [d, Date, ChannelName] = readepicsstriptool(FileName, N)
%
%  EXAMPLES
%  1. [d, Date, ChannelName] = readepicsstriptool
%     t = datenum(Date, 'mm/dd/yyyy HH:MM:SS');  % Note: decimal seconds are ignored
%     plot(t, d);
%     datetick
%     Legend(ChannelName, 'Interpreter','none');
 
if nargin < 1
    FileName = '';
end

if nargin < 2
    N = inf;
end

if isempty(FileName) || strcmp(FileName, '.')
    if isempty(FileName)
        [FileName, DirectoryName] = uigetfile('*.*', 'EPICS Striptool File Name?', getfamilydata('Directory','DataRoot'));
    else
        [FileName, DirectoryName] = uigetfile('*.*', 'EPICS Striptool File Name?');
    end
    drawnow;
    if FileName == 0
        d=[]; Date=[]; ChannelName='';
        return
    end
    FileName = [DirectoryName FileName];
end

[fid, errmsg]  = fopen(FileName,'r');
if fid==-1
    error('Could not open file');
end

HEADER = fgetl(fid);
HEADER(1:41)= [];
HEADER = deblankright(HEADER);
i = 0;
while length(HEADER) > 5
    j = findstr(HEADER, ' ');
    i = i + 1;
    if isempty(j)
        ChannelName{i,1} = deblank(HEADER);
    else
        ChannelName{i,1} = deblank(HEADER(1:j(1)));
    end
    HEADER(1:length(ChannelName{i,1})) = [];
    HEADER = deblankright(HEADER);
end


for i = 1:N
    LINE1  = fgetl(fid);
    if ~ischar(LINE1)
        break;
    end

    j = findstr(LINE1, '0.Infi');
    if ~isempty(j)
        for k = length(j):-1:1
            LINE1(j(k)+[0 1 2]) = 'NaN';
            LINE1(j(k)+[3 4 5 6]) = [];
        end
    end

    Date(i,:) = LINE1(1:23);
    d(:,i) = str2num(LINE1(24:end));
end

fclose(fid);

if nargout == 0
    %clf reset
    t = datenum(Date, 'mm/dd/yyyy HH:MM:SS');  % Note: decimal seconds are ignored
    plot(t, d);
    %for i = 1:size(ChannelName,1)
    %    plot(t, d(i,:));
    %    hold on;
    %end
    %hold off
    datetick
    h = legend(ChannelName, 'Interpreter','none');
end


function HEADER = deblankright(HEADER)
j = 0;
for i = 1:length(HEADER)
    if HEADER(i) == ' '
        j = j + 1;
    else
        break
    end
end
HEADER(1:j) = [];
