function ErrorFlag = setpvonline(ChannelNames, NewSP, DataType)
%SETPVONLINE - Sets the online value
% ErrorFlag = setpvonline(ChannelNames, NewSP, DataType)

if nargin < 2
    error('Must have at least two inputs');
end

ErrorFlag = 0;


% There can be multiple channel names due to "ganged" power supplies
[ChannelNames, i, j] = unique(ChannelNames, 'rows');

if size(ChannelNames,1) == size(NewSP,1)
    % ChannelNames equals the number of power supplies
else
    NewSP = NewSP(i);
end


% Look for blank channel names
for k = size(ChannelNames,1):-1:1      
    ChanName = deblank(ChannelNames(k,:));
    if isempty(ChanName)
        NewSP(k,:) = [];
        ChannelNames(k,:) = [];
    end
end


% Put data

%disp(ChannelNames);
%lnls1_cmd_set_parameter(deblank(ChannelNames), NewSP); 

msg = struct;
for i=1:length(ChannelNames(:,1))
    cName = upper(deblank(ChannelNames(i,:)));
    cName = strrep(cName, ':SP','_SP');
    msg.(cName) = NewSP(i);
end
lnls1_comm_write(msg);