function setid_101_except_IVID

% this routine is a bandaid to set all gaps except for IVID to 101mm for fills.
% NOTE THAT User Gap Enables must be OFF for this command to work

% Setting IVID SP changes the AM to something crazy at this point due to controls problem
%      even though the drive unit is locked out
% T.Scarvie, 2008-08-06

% start moves (no waitflag)
try
    setid([4 1], 101, 4.0, 0);
catch
    disp('trouble moving 4-1 vertical');
end
try
    setepu([4 1], 0, 0, 0, 16.7, 0);
catch
    disp('trouble moving 4-1 horizontal');
end
try
    setid([4 2], 101, 3.0, 0);
catch
    disp('trouble moving 4-2 vertical');
end
try
    setepu([4 2], 0, 0, 0, 10.0, 0);
catch
    disp('trouble moving 4-2 horizontal');
end
try
    setid([5 1], 101, 3.3, 0);
catch
    disp('trouble moving 5');
end
try
    setid([7 1], 101, 3.3, 0);
catch
    disp('trouble moving 7');
end
try
    setid([8 1], 101, 3.3, 0);
catch
    disp('trouble moving 8');
end
try
    setid([9 1], 101, 3.3, 0);
catch
    disp('trouble moving 9');
end
try
    setid([10 1], 101, 3.3, 0);
catch
    disp('trouble moving 10');
end
try
    setid([11 1], 101, 4.0, 0);
catch
    disp('trouble moving 11-1 vertical');
end
try
    setepu([11 1], 0, 0, 0, 16.7, 0);
catch
    disp('trouble moving 11-1 horizontal');
end
try
    setid([11 2], 101, 4.0, 0);
catch
    disp('trouble moving 11-2 vertical');
end
try
    setepu([11 2], 0, 0, 0, 16.7, 0);
catch
    disp('trouble moving 11-2 horizontal');
end
try
    setid([12 1], 101, 3.3, 0);
catch
    disp('trouble moving 12');
end

% complete moves with waitflag
try
    setid([4 1], 101, 4.00, -1);
catch
    disp('trouble moving 4-1 vertical');
end
try
    setepu([4 1], 0, 0, 0, 16.7, 1);
    disp('EPU 4-1 is open to 101mm and Z=0mm.');
catch
    disp('trouble moving 4-1 horizontal');
end
try
    setid([4 2], 101, 3.00, -1);
catch
    disp('trouble moving 4-2 vertical');
end
try
    setepu([4 2], 0, 0, 0, 10.0, 1);
    disp('EPU 4-2 is open to 101mm and Z=0mm.');
catch
    disp('trouble moving 4-2 horizontal');
end
try
    setid([5 1], 101, 3.30, -1);
    disp('ID 5-1 is open to 101mm.');
catch
    disp('trouble moving 5');
end
try
    setid([7 1], 101, 3.33, -1);
    disp('ID 7-1 is open to 101mm.');
catch
    disp('trouble moving 7');
end
try
    setid([8 1], 101, 3.33, -1);
    disp('ID 8-1 is open to 101mm.');
catch
    disp('trouble moving 8');
end
try
    setid([9 1], 101, 3.33, -1);
    disp('ID 9-1 is open to 101mm.');
catch
    disp('trouble moving 9');
end
try
    setid([10 1], 101, 3.33, -1);
    disp('ID 10-1 is open to 101mm.');
catch
    disp('trouble moving 10');
end
try
    setid([11 1], 101, 4.00, -1);
catch
    disp('trouble moving 11-1 vertical');
end
try
    setepu([11 1], 0, 0, 0, 16.7, 1);
    disp('EPU 11-1 is open to 101mm and Z=0mm.');
catch
    disp('trouble moving 11-1 horizontal');
end

try
    setid([11 2], 101, 4.00, -1);
catch
    disp('trouble moving 11-2 vertical');
end
try
    setepu([11 2], 0, 0, 0, 16.7, 1);
    disp('EPU 11-2 is open to 101mm and Z=0mm.');
catch
    disp('trouble moving 11-2 horizontal');
end
try
    setid([12 1], 101, 3.33, -1);
    disp('ID 12-1 is open to 101mm.');
catch
    disp('trouble moving 12');
end
