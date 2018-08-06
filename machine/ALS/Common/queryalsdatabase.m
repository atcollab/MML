function TableInfo = queryalsdatabase(Table, commandstr)
%QUERYALSDATABASE - Show info on the various databases
%
%  See also showdatabases, archive_size, archive_sr, getmysqldata

%  Written by Greg Portmann

TableInfo = [];
ShowTableInfo = 0;


% Current database is "controls"
%
%
%   Name          Engine   Version   Row_format   Rows    Avg_row_length   Data_length   Max_data_length      Index_length   Data_free   Auto_increment   Create_time           Update_time           Check_time            Collation           Checksum   Create_options   Comment
%  +-----------+ +------+ +-------+ +----------+ +-----+ +--------------+ +-----------+ +------------------+ +------------+ +---------+ +--------------+ +-------------------+ +-------------------+ +-------------------+ +-----------------+ +--------+ +--------------+ +---------------------+
%   ac            InnoDB   10        Compact      926     1716             1589248       0                    0              0           912              2011-10-12 14:34:22                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   am            InnoDB   10        Compact      1575    1009             1589248       0                    0              0           1660             2011-10-12 14:34:23                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   at            InnoDB   10        Compact      109     601              65536         0                    0              0           135              2011-10-12 14:34:24                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   bc            InnoDB   10        Compact      1414    312              442368        0                    0              0           1440             2011-10-12 14:34:24                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   bm            InnoDB   10        Compact      3326    477              1589248       0                    0              0           3505             2011-10-12 14:34:25                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   bp            InnoDB   10        Compact      52      1260             65536         0                    0              0           151              2011-10-12 14:34:26                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   device        InnoDB   10        Compact      2442    100              245760        0                    0              0           2488             2011-10-12 14:34:27                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   device_chan   MyISAM   10        Fixed        8532    98               836136        27584547717644287    107520         0           20064            2011-07-08 09:23:36   2011-07-08 09:23:36                         latin1_swedish_ci
%   devtype       InnoDB   10        Compact      445     147              65536         0                    0              0           267              2011-10-12 14:34:27                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   di            InnoDB   10        Compact      418     156              65536         0                    0              0           224              2011-10-12 14:34:27                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   do            InnoDB   10        Compact      3       5461             16384         0                    0              0           4                2011-10-12 14:34:27                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   gr            InnoDB   10        Compact      163     402              65536         0                    0              0           239              2011-10-12 14:34:28                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   ilc           InnoDB   10        Compact      462     212              98304         0                    0              0           522              2011-10-12 14:34:28                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   ilcconfig     MyISAM   10        Fixed        360     74               26640         20829148276588543    1024           0                            2011-10-12 14:34:28   2011-10-12 14:34:28                         latin1_swedish_ci
%   ilclist       MyISAM   10        Fixed        392     119              46648         33495522228568063    6144           0                            2011-07-08 09:23:36   2011-10-12 14:39:59                         latin1_swedish_ci
%   ilcserver     MyISAM   10        Fixed        115     22               2530          6192449487634431     1024           0                            2011-07-08 09:23:36   2011-07-08 09:23:36                         latin1_swedish_ci
%   mi            InnoDB   10        Compact      122     537              65536         0                    0              0           164              2011-10-12 14:34:28                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   mo            InnoDB   10        Compact      22      744              16384         0                    0              0           23               2011-10-12 14:34:28                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   pv            InnoDB   10        Compact      19383   460              8929280       0                    3686400        0           26012            2011-07-18 18:53:40                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   pv_list       InnoDB   10        Compact      517     158              81920         0                    0              0                            2011-07-18 18:53:40                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   pvtmp         MyISAM   10        Fixed        18856   376              7089856       105834591243206655   256000         0                            2011-11-23 02:02:20   2011-11-23 02:02:21   2011-11-23 02:02:21   latin1_swedish_ci
%   sc            InnoDB   10        Compact      298     219              65536         0                    0              0           223              2011-10-12 14:34:28                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   valid         InnoDB   10        Compact      70      234              16384         0                    0              0           71               2011-10-12 14:34:28                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%   version       InnoDB   10        Compact      18      910              16384         0                    0              0           19               2011-10-12 14:34:28                                               latin1_swedish_ci                               InnoDB free: 36864 kB
%
%
% AC Columns
%
%   Field        Type               Null   Key   Default             Extra
%  +----------+ +----------------+ +----+ +---+ +-----------------+ +--------------+
%   id           int(10) unsigned   NO     PRI                       auto_increment
%   timestamp    timestamp          NO           CURRENT_TIMESTAMP
%   SYS_NAME     char(7)            NO
%   ID_NAME      char(7)            NO
%   CHAN_NAME    char(4)            NO
%   DEV_NAME     char(4)            NO
%   NET_NAME     char(16)           NO
%   COMMENT      char(20)           NO
%   CHAN_TYPE    int(3)             NO
%   FUNC_TYPE    int(3)             NO
%   ...          ...                ...    ...   ...                 ...
%   LOLO         char(10)           NO
%   HHSV         char(10)           NO
%   LLSV         char(10)           NO
%   HSV          char(10)           NO
%   LSV          char(10)           NO
%   HYST         char(10)           NO
%   ADEL         char(10)           NO
%   MDEL         char(10)           NO
%   ASG          char(10)           NO
%   deleted      tinyint(4)         NO           0
% (66 rows total)
%
%
% AM Columns
%
%   Field        Type               Null   Key   Default             Extra
%  +----------+ +----------------+ +----+ +---+ +-----------------+ +--------------+
%   id           int(10) unsigned   NO     PRI                       auto_increment
%   timestamp    timestamp          NO           CURRENT_TIMESTAMP
%   SYS_NAME     char(7)            NO
%   ID_NAME      char(7)            NO
%   CHAN_NAME    char(4)            NO
%   DEV_NAME     char(4)            NO
%   NET_NAME     char(16)           NO
%   COMMENT      char(20)           NO
%   CHAN_TYPE    int(3)             NO
%   FUNC_TYPE    int(3)             NO
%   ...          ...                ...    ...   ...                 ...
%   LOW          char(10)           NO
%   HHSV         char(10)           NO
%   LLSV         char(10)           NO
%   HSV          char(10)           NO
%   LSV          char(10)           NO
%   HYST         char(10)           NO
%   ADEL         char(10)           NO
%   MDEL         char(10)           NO
%   SIMS         char(10)           NO
%   deleted      tinyint(4)         NO           0
% (53 rows total)
%
%
% BC Columns
%
%   Field        Type               Null   Key   Default             Extra
%  +----------+ +----------------+ +----+ +---+ +-----------------+ +--------------+
%   id           int(10) unsigned   NO     PRI                       auto_increment
%   timestamp    timestamp          NO           CURRENT_TIMESTAMP
%   SYS_NAME     char(7)            NO
%   ID_NAME      char(7)            NO
%   CHAN_NAME    char(4)            NO
%   DEV_NAME     char(4)            NO
%   NET_NAME     char(16)           NO
%   CHAN_TYPE    int(3)             NO
%   COMMENT      char(20)           NO
%   FUNC_TYPE    int(3)             NO
%   ILC          int(4)             NO
%   CHAN_NUMB    int(3)             NO
%   PWR_ON_VAL   int(3)             NO
%   LOW_TEXT     char(5)            NO
%   HIGH_TEXT    char(5)            NO
%   OPERATE      int(3)             NO
%   BEAM_ORDER   int(6)             NO
%   HARD_TYPE    int(3)             NO
%   FLNK         char(30)           NO
%   DTYP         char(16)           NO
%   OUT          char(24)           NO
%   DOL          char(30)           NO
%   SCAN         char(15)           NO
%   PINI         char(10)           NO
%   HIGH         char(10)           NO
%   deleted      tinyint(4)         NO           0
%
%
% BM Columns
%
%   Field        Type               Null   Key   Default             Extra
%  +----------+ +----------------+ +----+ +---+ +-----------------+ +--------------+
%   id           int(10) unsigned   NO     PRI                       auto_increment
%   timestamp    timestamp          NO           CURRENT_TIMESTAMP
%   SYS_NAME     char(7)            NO
%   ID_NAME      char(7)            NO
%   CHAN_NAME    char(4)            NO
%   DEV_NAME     char(4)            NO
%   NET_NAME     char(16)           NO
%   COMMENT      char(20)           NO
%   CHAN_TYPE    int(3)             NO
%   FUNC_TYPE    int(3)             NO
%   ILC          int(4)             NO
%   CHAN_NUMB    int(3)             NO
%   HIGH_TEXT    char(5)            NO
%   LOW_TEXT     char(5)            NO
%   OPERATE      int(3)             NO
%   BEAM_ORDER   int(6)             NO
%   HARD_TYPE    int(3)             NO
%   CHAIN_ORD    int(2)             NO
%   SCAN         char(15)           NO
%   FLNK         char(30)           NO
%   DTYP         char(16)           NO
%   INP          char(24)           NO
%   deleted      tinyint(4)         NO           0
%
%
% ILC Columns
%
%   Field        Type               Null   Key   Default             Extra
%  +----------+ +----------------+ +----+ +---+ +-----------------+ +--------------+
%   id           int(10) unsigned   NO     PRI                       auto_increment
%   timestamp    timestamp          NO           CURRENT_TIMESTAMP
%   NUMBER       int(4)             NO
%   NAME         char(10)           NO
%   USER_CODE    char(12)           NO
%   IOCONFIG     int(2)             NO
%   ILC_TYPE     int(2)             NO
%   SBX_TYPE     int(2)             NO
%   SBX_CONFIG   int(2)             NO
%   SN           float              NO
%   CPU          int(2)             NO
%   LINK         int(2)             NO
%   PORT         int(2)             NO
%   PHY_LNK      float              NO
%   DB_SIZE      char(7)            NO
%   MULTI_SCAN   int(2)             NO
%   IOC_GROUP    smallint(8)        NO
%   deleted      tinyint(4)         NO           0
%   SERVERNUM    tinyint(4)         NO           0
%
%
%
% ILCLIST Columns
%
%   Field     Type                   Null   Key   Default   Extra
%  +-------+ +--------------------+ +----+ +---+ +-------+ +-----+
%   NUMBER    smallint(5) unsigned   NO     PRI
%   LINK      tinyint(3) unsigned    YES
%   RACK      char(16)               YES
%   SLOT      smallint(5) unsigned   YES
%   PRINT     char(16)               YES
%   COMMENT   char(80)               YES
%   active    tinyint(4)             YES
%
%mysql -h ps2 -u rfgunion -p ilcs
%mysql> select ilc, sys_name, id_name, chan_name from am where sys_name in ('SR01C', 'SR07C', 'SR08C') and id_name like 'BPM%';
%mysql> select number, rack from ilcconfig where number in (559,564,565,606,607,612,613,615);


% pv Columns
%
%   Field          Type                                                                                                                                                                                                     Null   Key   Default               Extra
%  +------------+ +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+ +----+ +---+ +-------------------+ +--------------+
%   id             mediumint(8) unsigned                                                                                                                                                                                    NO     PRI                         auto_increment
%   HOST           char(16)                                                                                                                                                                                                 YES
%   REC_TYPE       char(16)                                                                                                                                                                                                 YES
%   name           char(61)                                                                                                                                                                                                 YES    MUL
%   DESCR          char(32)                                                                                                                                                                                                 YES
%   ASG            char(8)                                                                                                                                                                                                  YES
%   SCAN           char(16)                                                                                                                                                                                                 YES
%   DTYP           char(32)                                                                                                                                                                                                 YES
%   REC_INP        char(48)                                                                                                                                                                                                 YES
%   REC_OUT        char(48)                                                                                                                                                                                                 YES
%   EGU            char(16)                                                                                                                                                                                                 YES
%   EGUF           float                                                                                                                                                                                                    YES
%   EGUL           float                                                                                                                                                                                                    YES
%   HIHI           float                                                                                                                                                                                                    YES
%   HHSV           enum('MAJOR','MINOR','NO_ALARM')                                                                                                                                                                         YES
%   LOLO           float                                                                                                                                                                                                    YES
%   LLSV           enum('MAJOR','MINOR','NO_ALARM')                                                                                                                                                                         YES
%   HIGH           float                                                                                                                                                                                                    YES
%   HSV            enum('MAJOR','MINOR','NO_ALARM')                                                                                                                                                                         YES
%   LOW            float                                                                                                                                                                                                    YES
%   LSV            enum('MAJOR','MINOR','NO_ALARM')                                                                                                                                                                         YES
%   MDEL           float                                                                                                                                                                                                    YES
%   DRVH           float                                                                                                                                                                                                    YES
%   DRVL           float                                                                                                                                                                                                    YES
%   ZSV            enum('MAJOR','MINOR','NO_ALARM')                                                                                                                                                                         YES
%   OSV            enum('MAJOR','MINOR','NO_ALARM')                                                                                                                                                                         YES
%   COSV           enum('MAJOR','MINOR','NO_ALARM')                                                                                                                                                                         YES
%   ZNAM           char(16)                                                                                                                                                                                                 YES
%   ONAM           char(16)                                                                                                                                                                                                 YES
%   VIS            enum('public','restrict','private')                                                                                                                                                                      YES          public
%   ALIAS          char(80)                                                                                                                                                                                                 NO
%   IOC            char(16)                                                                                                                                                                                                 YES
%   DEPLOY         enum('active','pending','removed')                                                                                                                                                                       YES          active
%   MOD_DATE       datetime                                                                                                                                                                                                 YES          2008-01-22 09:00:00
%   LAST_CHANGE    text                                                                                                                                                                                                     YES
%   LOCATION       enum('eg','gtl','ln','ltb','br','btf','bts','sr','bl','fe')                                                                                                                                              YES
%   CATEGORY       set('sb','mps','rf','vac','time','eps','rad','pbpm','bpm','ffb','water','cryo','lcw','temp','motor','mag','id','air-act','diag','pstop','bstop','fe','scrape','inj','ramp','pulsed','interlock','epu')   YES
%   DEV_ID         int(11)                                                                                                                                                                                                  YES
%   DEV_ORDER      int(11)                                                                                                                                                                                                  YES
%   ADEL           float                                                                                                                                                                                                    YES
%   dev_function   char(4)                                                                                                                                                                                                  YES
%   ILC            int(11)                                                                                                                                                                                                  YES
%   ACCESS         int(11)


%%%%%%%%%%%%%%%%%%%%%
% Open a connection %
%%%%%%%%%%%%%%%%%%%%%
% Note:  Use mysql install in /usr/local/mysql-5.1.45 the default mysql is pointing to /usr/local/mysql

% Control database is ps2, ps3 is the same as pdb (physics database)
if 0
    Host = 'ps2.als.lbl.gov';
    User = 'croper';
    PassWord = 'cro@als';
else
    Host = 'ps3.als.lbl.gov';
    User = 'croper';
    PassWord = 'cro@als';
end

if ~isempty(User)
    OpenResult = mym('open', Host, User, PassWord);
else
    return
end
clear PassWord

DataBase = 'controls';

if nargin < 1
    Table = 'ilc';
end


%%%%%%%%%%%%%%%%%%%%%
% Select a database %
%%%%%%%%%%%%%%%%%%%%%
mym(sprintf('use %s', DataBase));

clc

%%%%%%%%%%%%%%%
% SRLOG TABLE %
%%%%%%%%%%%%%%%

% Print table info
if ShowTableInfo
    %diary Tables
    
    % Display database info
    mym(sprintf('show table status from %s;', DataBase));
    
    fprintf('\nAC Columns\n');
    mym('show columns from ac;');
    
    fprintf('\nAM Columns\n');
    mym('show columns from am;');
    
    fprintf('\nBC Columns\n');
    mym('show columns from bc;');
    
    fprintf('\nBM Columns\n');
    mym('show columns from bm;');
    
    fprintf('\nILC Columns\n');
    mym('show columns from ilc;');
    fprintf('\n');
    
    fprintf('\nILCLIST Columns\n');
    mym('show columns from ilclist;');
    fprintf('\n');
    
    fprintf('\nilcserver Columns\n');
    mym('show columns from ilcserver;');
    fprintf('\n');
    
    fprintf('\npv Columns\n');
    mym('show columns from pv;');
    fprintf('\n');
    
    %diary off
    %return
else
    ac = mym('show columns from ac;');
    am = mym('show columns from am;');
    bc = mym('show columns from bc;');
    bm = mym('show columns from bm;');
end

TableInfo = mym(sprintf('show table status from %s;', DataBase));

% for i = 1:length(TableInfo.Name)
%     if strcmp(TableInfo.Name{i}, TableName)
%         break
%     end
% end
%
% fprintf('   The present archive table %s was created %s and the last update was %s\n', TableInfo.Name{i}, TableInfo.Create_time{i}, TableInfo.Update_time{i});
% fprintf('   It is presently %f GBytes with %d rows\n', TableInfo.Data_length(i)/2^30, TableInfo.Rows(i));

% Chris changed the ilclist table structure to make it a little easier to query. Basically I made a separate column for slot number rather than using a '-' character.

%To see the number of ilcs in each chassis ordered by the number of ilcs:
%SELECT count(*) as ilcs, number, rack, substring(rack,1,5) as r, comment FROM ilclist where (number >= 530 and number <= 548) or number = 650
%group by rack order by ilcs
%
%Getting all the devices/channels is laborious but straight forward. For example, to check for all the AMs in this range, the following returns the count:
%select count(*) as num_ams from am where (ilc >= 530 and ilc <= 548) or ilc = 650

% This shows the details of all the ams:
% select sys_name,id_name,chan_name, net_name from am where (ilc >= 530 and ilc <= 548) or ilc = 650

% mysql -h ps2.als.lbl.gov -u croper -p controls < select ilc, sys_name,id_name,chan_name, net_name from am where (ilc >= 530 and ilc <= 548) or ilc = 650 order by ilc
% mysql -h ps2.als.lbl.gov -u croper -p controls < select ilc, sys_name,id_name,chan_name, net_name from ac where (ilc >= 530 and ilc <= 548) or ilc = 650 order by ilc


% TableInfo = mym('select ILC,SERVER,LINK from ilcserver order by SERVER;')
% for i = 1:length(TableInfo.ILC)
%         fprintf('%3d  %s  %d\n', TableInfo.ILC(i), TableInfo.SERVER{i}, TableInfo.LINK(i));
% end
% save ILCServer TableInfo
% return


if 0
    TableInfo = mym('select number,name,ilc_type,phy_lnk,sn from ilc where number >= 1 order by number;')
    for i = 1:length(TableInfo.number)
        Name = TableInfo.name{i};
        k = find(Name == ' ');
        Name(k) = '_';
        fprintf('%3d\t%-10s\t%d\t%d\t%d\n', TableInfo.number(i), Name, TableInfo.ilc_type(i), TableInfo.phy_lnk(i), TableInfo.sn(i));
    end
    
    
    % Find the 337 unknown ILC replacements in the total list
    ILCKnown = GetKnownILCNumbers;
    [i,j] = findrowindex(ILCKnown, TableInfo.number(:));
    
    ILCUnknown = TableInfo.number(:);
    ILCUnknown(i) = []
    for j = 1:length(ILCUnknown)
        i = findrowindex(ILCUnknown(j),TableInfo.number(:));
        Name = TableInfo.name{i};
        k = find(Name == ' ');
        Name(k) = '_';
        fprintf('%3d\t%-10s\t%d\t%d\t%d\n', TableInfo.number(i), Name, TableInfo.ilc_type(i), TableInfo.phy_lnk(i), TableInfo.sn(i));
    end
    fprintf('\n\n');
    
    PrintILCInfo(ILCUnknown);
end


%TableInfo = mym(sprintf(' select %s, sys_name,id_name,chan_name, net_name from am where (ilc >= 530 and ilc <= 548) or ilc = 650 order by ilc;', Table));
%fprintf('ILC sys_name  id_name   chan_name  net_name\n');
%for i = 1:length(TableInfo.ilc)
%    fprintf('%3d  %-5s   %-10s%-4s  "%s"\n', TableInfo.ilc(i), TableInfo.sys_name{i}, TableInfo.id_name{i}, TableInfo.chan_name{i}, TableInfo.net_name{i});
%end

%TableInfo = mym(sprintf(' select %s, sys_name,id_name,chan_name, net_name from am where (id_name sounds like "MD1HV") order by ilc;', Table));
%fprintf('ILC sys_name  id_name   chan_name  net_name\n');
%for i = 1:length(TableInfo.ilc)
%    fprintf('%3d  %-5s   %-10s%-4s  "%s"\n', TableInfo.ilc(i), TableInfo.sys_name{i}, TableInfo.id_name{i}, TableInfo.chan_name{i}, TableInfo.net_name{i});
%end

%TableInfo = mym(sprintf(' select %s, sys_name,id_name,chan_name, net_name from ac where (id_name sounds like "MD1HV") order by ilc;', Table));
%for i = 1:length(TableInfo.ilc)
%    fprintf('%3d  %-5s   %-10s%-4s  "%s"\n', TableInfo.ilc(i), TableInfo.sys_name{i}, TableInfo.id_name{i}, TableInfo.chan_name{i}, TableInfo.net_name{i});
%end

%TableInfo = mym(sprintf(' select %s, sys_name,id_name,chan_name, net_name from bm where (id_name sounds like "MD1HV") order by ilc;', Table));
%for i = 1:length(TableInfo.ilc)
%    fprintf('%3d  %-5s   %-10s%-4s  "%s"\n', TableInfo.ilc(i), TableInfo.sys_name{i}, TableInfo.id_name{i}, TableInfo.chan_name{i}, TableInfo.net_name{i});
%end

%TableInfo = mym(sprintf(' select %s, sys_name,id_name,chan_name, net_name from bc where (id_name sounds like "MD1HV") order by ilc;', Table));
%for i = 1:length(TableInfo.ilc)
%    fprintf('%3d  %-5s   %-10s%-4s  "%s"\n', TableInfo.ilc(i), TableInfo.sys_name{i}, TableInfo.id_name{i}, TableInfo.chan_name{i}, TableInfo.net_name{i});
%end

diary DatabaseInfo.txt

Sector2PLC = [
    509
    662
    663
    ];
%PrintILCInfo(Sector2PLC, Table);

ID = [
    695
    691
    715
    697
    739
    407
    408
    409
    410
    411
    ];
%PrintILCInfo(ID, Table);

Misc = [
    69
    125  % S082039  Hall probe
    442
    444
    498
    525
    713
    719
    733
    737
    741
    
    % 441
    % 524  Sabersky Finger
    % 719
    ];
%PrintILCInfo(Misc, Table);


CaenMagnets = [
    65
    
    66
    67
    68
    72
    
    77
    82
    
    83
    84
    85  % S081334 - 1 channel, B2 250A
    
    364
    365
    
    374
    375
    
    376
    
    86
    87  %           LTB_B3, 10A could be Caen replacement, needs extra voltage
    ];
%PrintILCInfo(CaenMagnets, Table);


InjectionMagnets = [
    
% 70   % LI0242  - Sol 115A
% 71   %           Sol ~500
%
% 76   % S071334 - BS and B1
%
% 362  % B022132 - BTS Quads, 90A (3)
% 363  %           BTS Quads, 40A -> Caen replacement (2)
%
% 372  % S111934 - BTS Quads, 90A (3) -> Could go on SB12 cPCI
% 373

742  % S100728 - BTSFE B1, 825A
];
%PrintILCInfo(InjectionMagnets, Table);


Injection = [
    79  % LI0143
    81
    
    89  % LI0838  IP + SIM?
    92
    93
    94
    95
    
    73  % LI0944
    74
    75
    
    90  % LI1629  IP
    113
    114
    
    117  % LI1846
    118
    120
    
    91  % LI1929  IP
    115
    116
    
    119  % LI2146
    
    104  % S081939
    105
    106
    181
    
    282  % B010346
    293
    
    294  % B020346
    
    366  % B020740
    367
    377
    378
    
    284  % B030346
    
    285  % B040346
    ];
%PrintILCInfo(Injection, Table);

FastMagnets = [
    297
    287
    344
    496
    497
    
    286  % S081527  BR KI
    345  % B021330  BR KE
    ];
%PrintILCInfo(FastMagnets, Table);

QFAShunts = [
    743
    744
    745];
%PrintILCInfo(QFAShunts, Table);

Vacuum = [
    % Gauges, pumps, & water flow
    97
    340
    341
    342
    343
    503
    505
    507
    509
    510
    511
    513
    515
    519
    521
    
    124
    368
    500
    501
    506
    508
    512
    514
    516
    517
    518
    520
    522
    523
    544
    714];
%PrintILCInfo(sort(Vacuum), Table);

TSP = [
    700
    701
    702
    703
    704
    705
    706
    707
    708
    709
    710
    711];
%PrintILCInfo(TSP, Table);


RFPermissive = [
    660
    661
    662
    663
    664
    665
    666
    667
    668
    669
    670
    671
    672
    673
    674
    675
    676
    677
    678
    679
    680
    681
    682
    683];
%PrintILCInfo(RFPermissive, Table);

RF = [
    526
    527
    528
    529
    530
    531
    532
    533
    534
    535
    536
    537
    538
    539
    540
    541
    542
    543
    545
    546
    650];
%PrintILCInfo(RF, Table);

Timing = [
    80
    290
    690
    ];
%PrintILCInfo(Timing, Table);

EPBI = [
    424
    717
    718
    698
    694
    693
    696
    720
    721
    746
    747
    699
    ];
%PrintILCInfo(EPBI, Table);


BR = [
    252
    253
    254
    261
    ];
%PrintILCInfo(BR, Table);

% Deleted in Gun, Linac
% IRM = [
% 200 89 
% 201 97 ];
% clc;
% PrintILCInfo(IRM, Table);


IRM = [
    1	79
    2	81
    3	70
    4	71
    5	95
    6	92
    7	93
    8	94
    9	73
    10	74
    11	75
    12	90
    13	113
    14	114
    15	118
    16	117
    17	120
    18	91
    19	115
    20	116
    21	119
    23	76
    24	85
    25	104
    26	105
    27	106
    28	181
    ];

%setpathals('GTB');
%clc;
%PrintILCInfo(IRM, Table);


IRM = [
    29	286
    30	252
    31	282
    32	293
    33	341
    34	294
    35	344
    36	287
    37	345
    38	297
    39	284
    40	285
    41	366
    42	367
    43	377
    44	378
    45	362
    46	363
    47	372
    48	373
    49	498
    50	524
    51	737
    53	507
    54	660
    55	661
    56	496
    57	497
    58	508
    59	509
    60	662
    61	663
    62	650
    63	510
    65	511
    66	664
    67	665
    68	512
    69	513
    70	666
    71	667
    72	514
    73	525
    74	442
    75	444
    76	515
    77	668
    78	669
    79	744
    80	670
    80 517  % Ion pumps
    81	671
    82	518
    85	519
    86	672
    87	673
    88	520
    89	408
    90	521
    91	674
    92	675
    93	743
    94	676
    94  523  % Ion pumps
    95	677
    96	522
    97	409
    98	742
    99	745
    100	678
    100 501  % Ion pumps
    101	679
    102	500
    103	411
    104	503
    105	680
    106	681
    107	714
    108	410
    109	505
    110	682
    111	683
    240	455  % DHCP
    241 456  % DHCP
    ];

%setpathals('BTS');
%PrintILCInfo(IRM, Table);


% Power supplies
IRM = [
65
66
67
68
72
77
82
83
84
87
86
364
365
374
375
376
363
];
PrintILCInfo([(1:length(IRM))' IRM], Table);



%setpathals('StorageRing');

%IRM = [80 517; 94 523; 100 501];
%setpathals('BTS');
%PrintILCInfo(IRM, Table);

%PrintILCInfo([(1:100)' (401:500)'], Table);


%IRM = [1 89;2 93; 3 94 ; 4 97];
%PrintILCInfo(IRM, Table);
% Vacuum
% IRM = [
%  30 NaN 124
%  33  34 340
% 342
% 343
% ];
% PrintILCInfo(IRM, Table);


%PrintILCInfo(getbpmilcnumber, Table);


diary off

%%%%%%%%%%%%%%%%%%%%%%
% Close the database %
%%%%%%%%%%%%%%%%%%%%%%
mym('close');


function PrintILCInfo(ILCNumber, Table)
Table = 'ilc';

Tables = {'ac','am','bc','bm'};

ColumnsAC = 'ilc,sys_name,id_name,chan_name,net_name,deleted,LOW_LIM,UPPER_LIM,FS_VAL,OFFSET,STEP_SIZE,SLEWRATE,MAXSLEWRATE';
ColumnsAM = 'ilc,sys_name,id_name,chan_name,net_name,deleted,LO_ALARM,UP_ALARM,FS_VAL,OFFSET';
ColumnsBC = 'ilc,sys_name,id_name,chan_name,net_name,deleted,LOW_TEXT,HIGH_TEXT,OPERATE';
ColumnsBM = 'ilc,sys_name,id_name,chan_name,net_name,deleted,LOW_TEXT,HIGH_TEXT,OPERATE';

nAC = 0;
nAM = 0;
nBC = 0;
nBM = 0;

if size(ILCNumber,2)
    IRMNumber = ILCNumber(:,1);
    ILCNumber = ILCNumber(:,2);
else
    IRMNumber = [];
end

m = 0;
for iILC = 1:length(ILCNumber)
    
    RackInfo = mym(sprintf(' select RACK,SLOT from ilclist where NUMBER = %d;', ILCNumber(iILC)));
    if isempty(RackInfo.RACK)
        Rack = NaN;
        Slot = NaN;
    else
        Rack = RackInfo.RACK{1};
        Slot = RackInfo.SLOT;
    end
    
    for iTable = 1:length(Tables)
        %fprintf('ILC #%d\n', ILCNumber(iILC));
        
        if strcmpi(Tables(iTable), 'ac')
            TableInfo = mym(sprintf(' select %s from %s where ilc = %d order by chan_name;', ColumnsAC, Tables{iTable}, ILCNumber(iILC)));
        elseif strcmpi(Tables(iTable), 'am')
            TableInfo = mym(sprintf(' select %s from %s where ilc = %d order by chan_name;', ColumnsAM, Tables{iTable}, ILCNumber(iILC)));
        elseif strcmpi(Tables(iTable), 'bc')
            TableInfo = mym(sprintf(' select %s from %s where ilc = %d order by chan_name;', ColumnsBC, Tables{iTable}, ILCNumber(iILC)));
        elseif strcmpi(Tables(iTable), 'bm')
            TableInfo = mym(sprintf(' select %s from %s where ilc = %d order by chan_name;', ColumnsBM, Tables{iTable}, ILCNumber(iILC)));
        else
            error('Unknown Table');
        end
        
        if isempty(TableInfo.ilc)
            %fprintf('%3d -> No %s column\n',ILCNumber(iILC), Tables{iTable});
        else
            for i = 1:length(TableInfo.ilc)
                % Combine the name into one string (like an EPICS PV name)
                Name = sprintf('%-8s%-7s%-4s', TableInfo.sys_name{i}, TableInfo.id_name{i}, TableInfo.chan_name{i});
                k = find(Name == ' ');
                Name(k) = '_';
                
                k = find(Name == '.');  % Not the best choice in my oppinion
                Name(k) = ',';
                
                %PVInfo = mym(sprintf('select ilc,DEPLOY,name from pv where name = "%s";', Name))
                
                % Remove " " from the net name (looks like a label string) so it doesn't get split into multiple columns
                %k = find(TableInfo.net_name{i} == ' ');
                %TableInfo.net_name{i}(k) = '_';
                
                m = m + 1;
                XLScell(m,1:4) = {TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i}};
                
                %fprintf('%3d\t%-5s\t%-10s\t%-4s\t%s\t"%s"\n', TableInfo.ilc(i), TableInfo.sys_name{i}, TableInfo.id_name{i}, TableInfo.chan_name{i}, Tables{iTable}, TableInfo.net_name{i});
                
                if 1 %TableInfo.deleted(i) == 0 || any(TableInfo.ilc(i)==[73 525 496 497 455 709])
                    if TableInfo.deleted(i)
                        Comment = 'Deleted';
                    else
                        Comment = '';
                    end
                    
                    if any(TableInfo.ilc(i)==[455 456])
                        Name = ['Test:',Name];
                    end
                    
                    if isempty(IRMNumber)
                        IRMNumber = NaN;
                    end
                    
                    if strcmpi(Tables(iTable), 'ac')
                        
                        % SLEW_TIME is zero for all IRM ACs
                        %TableInfo.STEP_SIZE                        
                        STEP_SIZE = str2num(TableInfo.STEP_SIZE{i});
                        if STEP_SIZE > 0
                            % LTB quads ~.25
                            % LTB_____BS_____AC00   Measured 2.0 A/sec, 220 A max
                            % LTB_____B1_____AC02   Measured  2.1 A/sec, 220 A max
                            % LTB_____B2_____AC00   Measured  6.9 A/sec, 250 A max
                            % LTB_____B3_____AC03   Measured .09 A/sec,  10 A max (Caen)
                            RampRate = STEP_SIZE * 80;  % * 4 / length(TableInfo.STEP_SIZE);  % A/step * 16 steps/sec
                            fprintf('%s\t%.1f\t%.1f\t%f\t%f\n', Name, TableInfo.LOW_LIM(i), TableInfo.UPPER_LIM(i), RampRate, STEP_SIZE);
                        else
                            RampRate = 0;
                        end
                        
                        %if TableInfo.deleted(i) == 0
                        nAC = nAC + 1;
                        %end
                        [Family, Field, DeviceList, ErrorFlag] = channel2family(Name);
                        if isempty(Family)
                            Golden = [];
                        else
                            Golden = getgolden(Family, Field, DeviceList);
                        end
                        
       %                 fprintf('%s\t%3d\t%3d\t%s\t%s\t"%s"\t%.1f\t%.1f\t%.1f\t%.1f\t%.1f\t%.1f\t%.1f\t%s\n', Rack, IRMNumber(iILC), TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i}, TableInfo.LOW_LIM(i), TableInfo.UPPER_LIM(i), TableInfo.FS_VAL(i), TableInfo.OFFSET(i), TableInfo.SLEWRATE(i), TableInfo.MAXSLEWRATE(i), Golden, Comment);

                    elseif strcmpi(Tables(iTable), 'am')
                        %if TableInfo.deleted(i) == 0
                        nAM = nAM + 1;
                        %end
                        [Family, Field, DeviceList, ErrorFlag] = channel2family(Name);
                        if isempty(Family)
                            Golden = [];
                        else
                            Golden = getgolden(Family, Field, DeviceList);
                        end
                            
                        if strcmpi(Name([5 9:10]),'CIP') && str2num(Name(11))<=4 && IRMNumber(iILC)>52
                            IRM = IRMNumber(iILC) + 1;
                        elseif strcmpi(Name([5 9:10]),'CIP') && str2num(Name(11))>4 && IRMNumber(iILC)>52
                            IRM = IRMNumber(iILC) + 2;
                        else
                            IRM = IRMNumber(iILC);
                        end
                        
       %                 fprintf('%s\t%3d\t%3d\t%s\t%s\t"%s"\t%.1f\t%.1f\t%.1f\t%.1f\t%f\t%s\n',  Rack, IRM, TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i}, TableInfo.LO_ALARM(i), TableInfo.UP_ALARM(i), TableInfo.FS_VAL(i), TableInfo.OFFSET(i), Golden, Comment);

                    elseif strcmpi(Tables(iTable), 'bc')
                        % Ignor IP
                        if ~strcmpi(Name(9:10),'IP')
                            %if TableInfo.deleted(i) == 0
                            nBC = nBC + 1;
                            %end
        %                    fprintf('%s\t%3d\t%3d\t%s\t%s\t"%s"\t%s\t%s\t\t\t%d\t%s\n',    Rack, IRMNumber(iILC), TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i}, TableInfo.LOW_TEXT{i}, TableInfo.HIGH_TEXT{i}, TableInfo.OPERATE(i), Comment);
                        end
                        
                    elseif strcmpi(Tables(iTable), 'bm')
                        % Ignor IP
                        if ~(strcmpi(Name(9:10),'IP') && IRMNumber(iILC)>52)
                            %if TableInfo.deleted(i) == 0
                            nBM = nBM + 1;
                            %end
         %                   fprintf('%s\t%3d\t%3d\t%s\t%s\t"%s"\t%s\t%s\t\t\t%d\t%s\n',    Rack, IRMNumber(iILC), TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i}, TableInfo.LOW_TEXT{i}, TableInfo.HIGH_TEXT{i}, TableInfo.OPERATE(i), Comment);
                        end
                    end
                end
            end
        end
    end
%    fprintf('\n');
end


fprintf('Number of AC = %d\n', nAC);
fprintf('Number of AM = %d\n', nAM);
fprintf('Number of BC = %d\n', nBC);
fprintf('Number of BM = %d\n', nBM);
fprintf('\n\n');


if ispc
    xlswrite('ExcelTestFile.xls', XLScell, 'SheetILC', 'A2');
end



function PrintIRMInfo(ILCNumber, Table)
Table = 'ilc';

Tables = {'ac','am','bc','bm'};

Columns   = 'ilc,sys_name,id_name,chan_name,net_name,deleted';
ColumnsAC = 'ilc,sys_name,id_name,chan_name,net_name,deleted,upper_lim,low_lim FS_VAL OFFSET';

m = 0;
for iILC = 1:length(ILCNumber)
    
    RackInfo = mym(sprintf(' select RACK,SLOT from ilclist where NUMBER = %d;', ILCNumber(iILC)));
    Rack = RackInfo.RACK{1};
    Slot = RackInfo.SLOT;
    
    nAC = 0;
    nAM = 0;
    nBC = 0;
    nBM = 0;
    
    for iTable = 1:length(Tables)
        %fprintf('ILC #%d\n', ILCNumber(iILC));
        if strcmpi(Tables(iTable), 'ac')
            TableInfo = mym(sprintf(' select %s from %s where ilc = %d order by ilc;', ColumnsAC, Tables{iTable}, ILCNumber(iILC)));
            %TableInfo
        else
            TableInfo = mym(sprintf(' select %s from %s where ilc = %d order by ilc;', Columns, Tables{iTable}, ILCNumber(iILC)));
        end
        
        if isempty(TableInfo.ilc)
            %fprintf('%3d -> No %s column\n',ILCNumber(iILC), Tables{iTable});
        else
            
            ACcell = {'','','',''};
            AMcell = {'','','',''};
            
            for i = 1:length(TableInfo.ilc)
                % Combine the name into one string (like an EPICS PV name)
                Name = sprintf('%-8s%-7s%-4s', TableInfo.sys_name{i}, TableInfo.id_name{i}, TableInfo.chan_name{i});
                k = find(Name == ' ');
                Name(k) = '_';
                
                k = find(Name == '.');  % Not the best choice in my oppinion
                Name(k) = ',';
                
                %PVInfo = mym(sprintf('select ilc,DEPLOY,name from pv where name = "%s";', Name))
                
                % Remove " " from the net name (looks like a label string) so it doesn't get split into multiple columns
                %k = find(TableInfo.net_name{i} == ' ');
                %TableInfo.net_name{i}(k) = '_';
                
                m = m + 1;
                XLScell(m,1:4) = {TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i}};
                
                %fprintf('%3d\t%-5s\t%-10s\t%-4s\t%s\t"%s"\n', TableInfo.ilc(i), TableInfo.sys_name{i}, TableInfo.id_name{i}, TableInfo.chan_name{i}, Tables{iTable}, TableInfo.net_name{i});
                
                if strcmpi(Tables(iTable), 'ac')
                    if TableInfo.deleted(i) == 0
                        nAC = nAC + 1;
                        ACcell{nAC} = Name;
                    end
                    fprintf('%s\t%3d\t%s\t%s\t"%s"\t%d\t%.1f\t%.1f\n', Rack, TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i}, TableInfo.deleted(i), TableInfo.low_lim(i), TableInfo.upper_lim(i));
                elseif strcmpi(Tables(iTable), 'am')
                    if TableInfo.deleted(i) == 0
                        nAM = nAM + 1;
                        AMcell{nAM} = Name;
                    end
                    fprintf('%s\t%3d\t%s\t%s\t"%s"\t%d\n',              Rack, TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i}, TableInfo.deleted(i));
                    %fprintf('\t%s', Name);
                elseif strcmpi(Tables(iTable), 'bc')
                    if TableInfo.deleted(i) == 0
                        nBC = nBC + 1;
                        BCcell{1,nBC} = Name;
                    end
                    fprintf('%s\t%3d\t%s\t%s\t"%s"\t%d\n',              Rack, TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i}, TableInfo.deleted(i));
                    %fprintf('\t%s', Name);
                elseif strcmpi(Tables(iTable), 'bm')
                    if TableInfo.deleted(i) == 0
                        nBM = nBM + 1;
                        BMcell{1,nBM} = Name;
                    end
                    fprintf('%s\t%3d\t%s\t%s\t"%s"\t%d\n',              Rack, TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i}, TableInfo.deleted(i));
                    %fprintf('\t%s', Name);
                else
                    fprintf('\n');
                end
            end
        end
    end
    
    
    %     if ~isempty(TableInfo.ilc)
    %         fprintf('%s\t%3d', Rack, TableInfo.ilc(1));
    %     end
    %
    %     for ii = 1:4
    %         fprintf('\t%s', ACcell{ii});
    %     end
    %     for ii = 1:4
    %         fprintf('\t%s', AMcell{ii});
    %     end
    %     for ii = 1:nBC
    %         fprintf('\t%s', BCcell{ii});
    %     end
    %     for ii = 1:nBM
    %         fprintf('\t%s', BMcell{ii});
    %     end
    %     fprintf('\n');
    
end


% fprintf('Number of AC = %d\n', nAC);
% fprintf('Number of AM = %d\n', nAM);
% fprintf('Number of BC = %d\n', nBC);
% fprintf('Number of BM = %d\n', nBM);
% fprintf('\n\n');


if ispc
    xlswrite('ExcelTestFile.xls', XLScell, 'SheetILC', 'A2');
end



function ILC = getbpmilcnumber
% 144 BPM ILCs

ILC = [
    381
    382
    383
    384
    385
    386
    98
    100
    102
    103
    107
    108
    109
    110
    111
    112
    299
    300
    301
    302
    303
    304
    305
    306
    307
    308
    309
    310
    311
    312
    313
    314
    315
    316
    317
    318
    319
    320
    321
    322
    323
    324
    325
    326
    327
    328
    329
    330
    550
    551
    552
    553
    554
    555
    556
    557
    558
    559
    560
    561
    562
    563
    564
    565
    566
    567
    568
    569
    570
    571
    572
    573
    574
    575
    576
    577
    578
    579
    580
    581
    582
    583
    584
    585
    586
    587
    588
    589
    590
    591
    592
    593
    594
    595
    596
    597
    598
    599
    600
    601
    %602
    603
    604
    605
    606
    607
    608
    609
    610
    611
    612
    613
    614
    615
    616
    617
    618
    619
    620
    621
    622
    623
    624
    625
    626
    627
    628
    629
    630
    631
    632
    633
    634
    635
    636
    637
    638
    639
    640
    641
    642
    643
    644
    645
    ];



function ILC = GetKnownILCNumbers
% 337 Unknown ILC replacements

ILC = [
    695
    691
    715
    697
    739
    
    407
    408
    409
    410
    411
    
    69
    441 % ?
    442 % ?
    442
    444
    498
    524
    525
    719
    733
    737
    741
    
    
    66
    67
    68
    72
    77
    82
    83
    84
    86
    87
    364
    365
    374
    375
    376
    
    
    65
    70
    71
    76
    85
    362
    363
    372
    373
    742
    
    
    297
    287
    344
    496
    497
    
    
    79
    81
    89
    92
    93
    94
    95
    104
    105
    106
    117
    118
    119
    125
    181
    282
    284
    285
    286
    293
    345
    366
    367
    73
    74
    75
    90
    91
    113
    114
    115
    116
    120
    132
    294
    377
    378
    
    
    526
    527
    528
    529
    530
    531
    532
    533
    534
    535
    536
    537
    538
    539
    540
    541
    542
    543
    545
    546
    650
    
    
    660
    661
    662
    663
    664
    665
    666
    667
    668
    669
    670
    671
    672
    673
    674
    675
    676
    677
    678
    679
    680
    681
    682
    683
    
    
    743
    744
    745
    
    
    80
    290
    690
    
    
    700
    701
    702
    703
    704
    705
    706
    707
    708
    709
    710
    711
    
    
    97
    340
    341
    342
    343
    503
    505
    507
    509
    510
    511
    513
    515
    519
    521
    
    
    124
    368
    500
    501
    506
    508
    512
    514
    516
    517
    518
    520
    522
    523
    544
    714
    
    
    424
    693
    694
    696
    698
    699
    717
    718
    720
    721
    746
    747
    
    
    381
    382
    383
    384
    385
    386
    98
    100
    102
    103
    107
    108
    109
    110
    111
    112
    299
    300
    301
    302
    303
    304
    305
    306
    307
    308
    309
    310
    311
    312
    313
    314
    315
    316
    317
    318
    319
    320
    321
    322
    323
    324
    325
    326
    327
    328
    329
    330
    550
    551
    552
    553
    554
    555
    556
    557
    558
    559
    560
    561
    562
    563
    564
    565
    566
    567
    568
    569
    570
    571
    572
    573
    574
    575
    576
    577
    578
    579
    580
    581
    582
    583
    584
    585
    586
    587
    588
    589
    590
    591
    592
    593
    594
    595
    596
    597
    598
    599
    600
    601
    602
    603
    604
    605
    606
    607
    608
    609
    610
    611
    612
    613
    614
    615
    616
    617
    618
    619
    620
    621
    622
    623
    624
    625
    626
    627
    628
    629
    630
    631
    632
    633
    634
    635
    636
    637
    638
    639
    640
    641
    642
    643
    644
    645
    ];








