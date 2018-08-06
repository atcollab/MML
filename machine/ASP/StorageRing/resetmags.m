famnamelist = {'QFA' 'QDA' 'QFB'};
% famnamelist = {'SFA' 'SDA' 'SFB' 'SDB'};
% fanmanelist = {'HCM' 'VCM' 'SQK'};

sector = [14];

for ii=1:length(famnamelist)
    famname = famnamelist{ii};
    
    switch famname
        case {'QFA' 'QDA' 'QFB' 'SFA' 'SDA' 'SDB'}
            elenum = [1 2];
        case {'HCM'}
            elenum = [1 2 3];
        case {'VCM'}
            elenum = [1 2 3 4];
        otherwise
            elenum = [1];
    end

    % HCM (3 per sector)
    % VCM (4 per sector)
    % QFA (2 per sector)
    % QFB (1 per sector)
    % QDA (2 per sector)
    % SFA (2 per sector)
    % SDA (2 per sector)
    % SFB (1 per sector)
    % SDB (2 per sector)


    devicelist = [];
    for i=1:length(sector);
        devicelist = [devicelist; [repmat(sector(i),length(elenum),1) elenum']];
    end

    sp_pvnames = getfamilydata(famname,'Setpoint','ChannelNames',devicelist);

    pvnames = strrep(cellstr(sp_pvnames),'CURRENT_SP','RESET_CMD');
    handles = mcaopen(pvnames);

    ind = find(handles > 0);

    mcaput(handles(ind),ones(1,length(ind)));
    pause(1);
    mcaput(handles(ind),zeros(1,length(ind)));

    mcaclose(handles(ind));
end