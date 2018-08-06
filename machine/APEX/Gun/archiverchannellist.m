function Chan = archiverchannellist(ChanType)


if nargin < 1
    ChanType = 'bi1';
end


if strcmpi(ChanType, 'bi_1')
    FileName = '/remote/apex/hlc/matlab/applications/ArchiverAppliance/py/APEX_Archiver_BI_1.txt';
elseif strcmpi(ChanType, 'bi_2')
    FileName = '/remote/apex/hlc/matlab/applications/ArchiverAppliance/py/APEX_Archiver_BI_2.txt';
elseif strcmpi(ChanType, 'bo_1')
    FileName = '/remote/apex/hlc/matlab/applications/ArchiverAppliance/py/APEX_Archiver_BO_1.txt';
elseif strcmpi(ChanType, 'bo_2')
    FileName = '/remote/apex/hlc/matlab/applications/ArchiverAppliance/py/APEX_Archiver_BO_2.txt';
elseif strcmpi(ChanType, 'ai')
    FileName = '/remote/apex/hlc/matlab/applications/ArchiverAppliance/py/APEX_Archiver_AI_1.txt';
elseif strcmpi(ChanType, 'ao')
    FileName = '/remote/apex/hlc/matlab/applications/ArchiverAppliance/py/APEX_Archiver_AO_1.txt';
elseif strcmpi(ChanType, 'mbbi')
    FileName = '/remote/apex/hlc/matlab/applications/ArchiverAppliance/py/APEX_Archiver_MBBI.txt';
elseif strcmpi(ChanType, 'mbbo')
    FileName = '/remote/apex/hlc/matlab/applications/ArchiverAppliance/py/APEX_Archiver_MBBO.txt';
else
    error(sprintf('Unknown archiver channel type: %s', ChanType));
end

Chan = importdata(FileName);