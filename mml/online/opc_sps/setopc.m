function ErrorFlag = setopc(ChannelNames, NewSP)
%SETOPC - Low level OPC set program
%
%  See also getopc, setpvonline

ErrorFlag = 0;

global DA_GLOBAL DA_GLOBAL_BPM DA_GROUP_GLOBAL


if isempty(findstr(ChannelNames(1,:),'\\192.168.100'))
    if isempty(DA_GLOBAL)
        DA_GLOBAL = opcda('localhost','RSLinx Remote OPC Server');
    end
    connect(DA_GLOBAL);

    %if isempty(DA_GROUP_GLOBAL)
    DA_GROUP_GLOBAL = addgroup(DA_GLOBAL);
    %else
    %    % You might have to flush old data out of the group, I'm not sure ???
    %    flushdata(DA_GROUP_GLOBAL);
    %end
else
    if isempty(DA_GLOBAL_BPM)
        DA_GLOBAL_BPM = opcda('localhost','National Instruments.LookoutOPCServer');
    end
    connect(DA_GLOBAL_BPM);

    %if isempty(DA_GROUP_GLOBAL)
    DA_GROUP_GLOBAL = addgroup(DA_GLOBAL_BPM);
    %else
    %    % You might have to flush old data out of the group, I'm not sure ???
    %    flushdata(DA_GROUP_GLOBAL);
    %end
end


% Que the gets
for i = 1:size(ChannelNames, 1)
    item{i} = additem(DA_GROUP_GLOBAL, deblank(ChannelNames(i,:)));
end

% Set the data
for i = 1:size(ChannelNames, 1)
    %set(item{i}, 'Field', NewSP(i,:));
    write(item{i}, NewSP(i,:))
end


