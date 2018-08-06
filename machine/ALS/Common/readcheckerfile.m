function data = readcheckerfile(FileName)

if nargin < 1
    FileName = 'gsr1113.mch';
end

fid = fopen(FileName, 'r');

data.ChannelName = [];
data.Ext = [];

for i = 1:Inf
    tline = fgetl(fid);
    if ~ischar(tline), break, end

    ChannelName = sscanf(tline, '%c', 16);
    tline(1:16) = [];

    % Convert blanks to underscores
    j = findstr(ChannelName,' ');
    ChannelName(j) = '_';
    ChannelName = deblank(ChannelName);
    
    data.ChannelName = strvcat(data.ChannelName, ChannelName);
    
    
    % Get extension without blanks
    Ext = sscanf(tline, '%s', 1);
    Ext = deblank(Ext);
    data.Ext = strvcat(data.Ext, Ext);
    k = findstr(Ext(end), tline);
    tline(1:k(1)) = '';
    
    % Saved value
    data.Value(i,1) = sscanf(tline, '%f', 1);
    

    %data.Desc{i,1}        = sscanf(tline, '%s', 1);
    %data.BeamOrder(i,1)   = sscanf(tline, '%d', 1);
end

fclose(fid);



