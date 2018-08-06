function AM = getopc(ChannelNames)
%GETOPC - Low level OPC get program
%
%  See also setopc, getpvonline

global DA_GLOBAL DA_GLOBAL_BPM DA_GROUP_GLOBAL

if isempty(findstr(ChannelNames(1,:),'\\192.168.100'))
    if isempty(DA_GLOBAL)
        DA_GLOBAL = opcda('localhost','RSLinx Remote OPC Server');
    end
    connect(DA_GLOBAL);

    %tic
    %if isempty(DA_GROUP_GLOBAL)
    DA_GROUP_GLOBAL = addgroup(DA_GLOBAL);
    set(DA_GLOBAL,'Timeout',100,'EventLogMax',2000);
    %else
    %    % You might have to flush old data out of the group, I'm not sure ???
    %    flushdata(DA_GROUP_GLOBAL);
    %end
    %fprintf('   Addgroup call took %f seconds\n', toc);
else
    if isempty(DA_GLOBAL_BPM)
        DA_GLOBAL_BPM = opcda('localhost','National Instruments.LookoutOPCServer');
    end
    connect(DA_GLOBAL_BPM);
 
    %tic
    %if isempty(DA_GROUP_GLOBAL)
    DA_GROUP_GLOBAL = addgroup(DA_GLOBAL_BPM);
    warning off
    %else
    %    % You might have to flush old data out of the group, I'm not sure ???
    %    flushdata(DA_GROUP_GLOBAL);
    %end
    %fprintf('   Addgroup call took %f seconds\n', toc);
end

% Que the gets
%tic
for i = 1:size(ChannelNames,1)
   item{i} = additem(DA_GROUP_GLOBAL, deblank(ChannelNames(i,:)));
   warning off
end
%fprintf('   %d additem calls took %f seconds\n', size(ChannelNames,1), toc);

% Delay (should not be needed)
%pause(.5);

% Get the data
%tic
for i = 1:size(ChannelNames,1)
    tmp = read(item{i});
    AM(i,:) = tmp.Value;
end
%fprintf('   %d reads took %f seconds\n', size(ChannelNames,1), toc);

inxv=strfind(ChannelNames(1,:),'STV');
inxh=strfind(ChannelNames(1,:),'STH');

inxMPW=strfind(ChannelNames(1,:),'MPW');
inxSWLS=strfind(ChannelNames(1,:),'SWLS');

XM=double(AM);

if ~isempty(inxv)||~isempty(inxh) 
    
    if ~isempty(inxMPW) || ~isempty(inxSWLS)
        AM=XM;
    else
        XM = XM./1000000;
        AM=XM;
    end
     
end

flushdata(DA_GROUP_GLOBAL);