function profibus_sync(Family)
%PROFIBUS_SYNC - Use Sync Profibus mecanism for Family
%
%  INPUTS
%  1. Family to synch
%
%  See Also profibus_unsyncall

if isfamily(Family)
    %
end

BoardNumber = getfamilydata(Family,'Profibus','BoardNumber');
Group       = getfamilydata(Family,'Profibus','Group');
devProfibus = getfamilydata(Family,'Profibus','DeviceName');

tango_command_inout2(devProfibus,'Sync',[BoardNumber, Group]);



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

        