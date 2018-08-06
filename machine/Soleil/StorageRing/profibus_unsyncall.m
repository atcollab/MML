function profibus_unsyncall(Family)
%PROFIBUS_SYNC - Use UnSync Profibus mecanism for Family
%
%  INPUTS
%  1. Family to synch
%
%  NOTES
%  1. In this version unsynch all groups ANS all Boardnumber for a given
%  Profibus server
%
%  See Also profibus_sync

if isfamily(Family)
    %
end

BoardNumber = getfamilydata(Family,'Profibus','BoardNumber');
Group       = getfamilydata(Family,'Profibus','Group');
devProfibus = getfamilydata(Family,'Profibus','DeviceName');

tango_command_inout2(devProfibus,'UnSyncAll');


% dev = 'ANS/AE/DP.QP';
% %dev = 'ANS/AE/DP.COR';
% 
% tango_command_inout2(dev,'GetBoardInfo')
% 
% groupid = int32(1);
% boardid = int32(1);
% 
% tango_command_inout2(dev,'Sync',[boardid, groupid]);
% 
% %%
% tango_command_inout2(dev,'UnSyncAll');
% 
% %%
% %                                       %boardnumber %DPAddress
% tango_command_inout2(dev,'GetSlaveDiag',[int32(1),int32(101)])
% 
% %
% end

        