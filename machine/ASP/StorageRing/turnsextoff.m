sextnames = {'SFA','SFB','SDA','SDB'};

for i=1:length(sextnames);
    origstatus = getfamilydata(sextnames{i},'Status');
    newstatus = ones(size(origstatus));
    setfamilydata(newstatus,sextnames{i},'Status');
    setpv(sextnames{i},'Setpoint',0,'Model','Physics');
    setfamilydata(origstatus,sextnames{i},'Status');
end
