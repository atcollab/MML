function mmlarchiver(Action)


if nargin < 1
    Action = 'Start';
end

if strcmpi(Action, 'CashChannelNames')
    ChanBI_1 = archiverchannellist('bi_1');
    ChanBO_1 = archiverchannellist('bo_1');
        
    ChanBI_2 = archiverchannellist('bi_2');
    ChanBO_2 = archiverchannellist('bo_2');
    
    ChanBI = [ChanBI_1;  ChanBI_2];
    ChanBO = [ChanBO_1;  ChanBO_2];

    ChanAI = archiverchannellist('ai');
    ChanAO = archiverchannellist('ao');
    
    ChanMBBI = archiverchannellist('mbbi');
    ChanMBBO = archiverchannellist('mbbo');
    
    % Save
    save /remote/apex/hlc/matlab/machine/APEX/Gun/ArchiverChannelList
    
elseif strcmpi(Action, 'Start')
    
    load /remote/apex/hlc/matlab/machine/APEX/Gun/ArchiverChannelList.mat
    
    % First remove missing channels
    ChanBI   = removemissingchannels(ChanBI);
    ChanBO   = removemissingchannels(ChanBO);
    ChanAI   = removemissingchannels(ChanAI);
    ChanAO   = removemissingchannels(ChanAO);
    ChanMBBI = removemissingchannels(ChanMBBI);
    ChanMBBO = removemissingchannels(ChanMBBO);

    
    N = length(ChanBI) + length(ChanBO) + length(ChanAI) + length(ChanAO) + length(ChanMBBI) + length(ChanMBBO);
    fprintf('Total number of channels to archive: %d\n', N);

    for i = 1:300000
        tic
        [BI.Data, ~, BI.Ts] = getpvonline(ChanBI, 'double');
        BI.Ts = labca2datenum(BI.Ts);
        [BO.Data, ~, BO.Ts] = getpvonline(ChanBO, 'double');
        BO.Ts = labca2datenum(BO.Ts);
        [AI.Data, ~, AI.Ts] = getpvonline(ChanAI, 'double');
        AI.Ts = labca2datenum(AI.Ts);
        [AO.Data, ~, AO.Ts] = getpvonline(ChanAO, 'double');
        AO.Ts = labca2datenum(AO.Ts);
        [MBBI.Data, ~, MBBI.Ts] = getpvonline(ChanMBBI, 'double');
        MBBI.Ts = labca2datenum(MBBI.Ts);
        [MBBO.Data, ~, MBBO.Ts] = getpvonline(ChanMBBO, 'double');
        MBBO.Ts = labca2datenum(MBBO.Ts);
        toc
    end
end





function Chan = removemissingchannels(Chan)

PatternsToRemove = {'Sol1Quad2','Sol1SQuad2','BLM', 'Spare'};

for i = length(Chan):-1:1
    Chan{i} = strtrim(Chan{i});
    for j = 1:length(PatternsToRemove)
        k = strfind(Chan{i}, PatternsToRemove{j});
        if ~isempty(k)
            fprintf('Removing: %s\n', Chan{i});
            Chan(i) = [];
        end
    end
end

