function measure_ID_tune_shift_20170814

IDlist=[
    4     1
    4     2
    5     1
    7     1
    7     2
    8     1
    9     1
    10     1
    11     1
    11     2
    12     1
    ];

EPUlist = [
    4     1
    4     2
    7     1
    7     2
    11    1
    11    2
    ];

%getlist('ID');
setepu(EPUlist,0);

setid(maxsp('ID',IDlist),IDlist);

for ID = 1:size(IDlist,1)
    setid(IDlist(ID,:), minsp(IDlist(ID,:)), 0.5);
    