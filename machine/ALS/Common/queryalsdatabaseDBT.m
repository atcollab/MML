function TableInfo = queryalsdatabaseDBT(Table, commandstr)
%QUERYALSDATABASE - Show info on the various databases
%
%  See also showdatabases, archive_size, archive_sr, getmysqldata

%  Written by Greg Portmann
%  Modified by Paola Pace to use MATLAB DBT - Development Version

TableInfo = [];
ShowTableInfo = 1;


% Current database is "controls"
% 
%   Name          Engine   Version   Row_format   Rows    Avg_row_length   Data_length   Max_data_length      Index_length   Data_free   Auto_increment   Create_time           Update_time           Check_time            Collation           Checksum   Create_options   Comment              
%  +-----------+ +------+ +-------+ +----------+ +-----+ +--------------+ +-----------+ +------------------+ +------------+ +---------+ +--------------+ +-------------------+ +-------------------+ +-------------------+ +-----------------+ +--------+ +--------------+ +--------------------+
%   ac            MyISAM   10        Fixed        875     406              355250        114278840544526335   1024           0                            2008-01-23 16:08:24   2008-01-23 16:08:24                         latin1_swedish_ci                                                    
%   am            MyISAM   10        Fixed        1592    421              670232        118500965195186175   1024           0                            2008-01-23 16:08:24   2008-01-23 16:08:25                         latin1_swedish_ci                                                    
%   at            MyISAM   10        Fixed        134     172              23048         48413695994232831    1024           0                            2008-01-23 16:08:25   2008-01-23 16:08:25                         latin1_swedish_ci                                                    
%   bc            MyISAM   10        Fixed        1439    223              320897        62768919806476287    1024           0                            2008-01-23 16:08:25   2008-01-23 16:08:25                         latin1_swedish_ci                                                    
%   bm            MyISAM   10        Fixed        3581    172              615932        48413695994232831    1024           0                            2008-01-23 16:08:25   2008-01-23 16:08:25                         latin1_swedish_ci                                                    
%   device        MyISAM   10        Fixed        2389    55               131395        15481123719086079    99328          0           2390             2009-10-28 10:02:38   2009-10-28 10:02:38                         latin1_swedish_ci                                                    
%   device_chan   MyISAM   10        Fixed        8532    98               836136        27584547717644287    81920          0           20064            2009-06-03 13:40:07   2009-06-21 12:02:09                         latin1_swedish_ci                                                    
%   devtype       MyISAM   10        Fixed        258     66               17028         18577348462903295    1024           0                            2008-01-24 14:25:40   2008-01-24 14:25:40                         latin1_swedish_ci                                                    
%   di            MyISAM   10        Fixed        207     75               15525         21110623253299199    1024           0                            2008-01-23 16:08:25   2008-01-23 16:08:25                         latin1_swedish_ci                                                    
%   do            MyISAM   10        Fixed        0       0                0             20547673299877887    1024           0                            2008-01-23 16:08:25   2008-01-23 16:08:25                         latin1_swedish_ci                                                    
%   ilc           MyISAM   10        Fixed        362     44               15928         12384898975268863    5120           0                            2009-10-27 14:13:29   2009-10-27 14:13:29                         latin1_swedish_ci                                                    
%   ilcconfig     MyISAM   10        Fixed        360     74               26640         20829148276588543    1024           0                            2009-11-05 08:53:17   2009-11-05 08:53:17                         latin1_swedish_ci                                                    
%   ilclist       MyISAM   10        Fixed        447     118              52746         33214047251857407    6144           0                            2010-05-26 09:31:13   2010-05-26 09:31:13                         latin1_swedish_ci                                                    
%   ilcserver     MyISAM   10        Fixed        115     22               2530          6192449487634431     1024           0                            2010-03-29 11:12:44   2010-03-29 11:12:44                         latin1_swedish_ci                                                    
%   pv            InnoDB   10        Compact      18230   489              8929280       0                    3620864        0           24493            2009-05-01 09:35:24                                               latin1_swedish_ci                               InnoDB free: 5120 kB 
%   pv_list       InnoDB   10        Compact      37      3099             114688        0                    0              0                            2009-06-12 09:30:44                                               latin1_swedish_ci                               InnoDB free: 5120 kB 
%   pvtmp         MyISAM   10        Fixed        2844    376              1069344       105834591243206655   44032          0                            2010-06-02 02:00:04   2010-06-02 02:00:04   2010-06-02 02:00:04   latin1_swedish_ci                                                    

  
% mym('show columns from am;');
% 
%   Field        Type             Null   Key   Default   Extra 
%  +----------+ +--------------+ +----+ +---+ +-------+ +-----+
%   SYS_NAME     char(7)          YES                          
%   ID_NAME      char(7)          YES                          
%   CHAN_NAME    char(4)          YES                          
%   DEV_NAME     char(4)          YES                          
%   NET_NAME     char(16)         YES                          
%   COMMENT      char(20)         YES                          
%   CHAN_TYPE    tinyint(4)       YES                          
%   FUNC_TYPE    tinyint(4)       YES                          
%   ILC          int(11)          YES                          
%   CHAN_NUMB    tinyint(4)       YES                          
%   FS_VAL       decimal(9,3)     YES                          
%   OFFSET       decimal(9,3)     YES                          
%   UP_ALARM     decimal(19,11)   YES                          
%   LO_ALARM     decimal(19,11)   YES                          
%   UNITS        char(4)          YES                          
%   ADC_RES      decimal(2,0)     YES                          
%   DEF_TOL      decimal(3,1)     YES                          
%   FORMAT       char(3)          YES                          
%   STABILITY    decimal(3,1)     YES                          
%   DEVIATION    decimal(3,1)     YES                          
%   BEAM_ORDER   int(11)          YES                          
%   HARD_TYPE    decimal(3,0)     YES                          
%   B_TO_I       char(12)         YES                          
%   B_TO_I2      char(12)         YES                          
%   DTYP         char(16)         YES                          
%   INP          char(24)         YES                          
%   DOL          char(30)         YES                          
%   SCAN         char(15)         YES                          
%   PINI         char(10)         YES                          
%   PHAS         decimal(4,0)     YES                          
%   EVNT         decimal(4,0)     YES                          
%   DISV         decimal(2,0)     YES                          
%   SDIS         char(10)         YES                          
%   DISS         char(10)         YES                          
%   PRIO         char(10)         YES                          
%   FLNK         char(10)         YES                          
%   PREC         decimal(4,0)     YES                          
%   LINR         char(15)         YES                          
%   EGUF         char(10)         YES                          
%   EGUL         char(10)         YES                          
%   HIGH         char(10)         YES                          
%   LOW          char(10)         YES                          
%   HHSV         char(10)         YES                          
%   LLSV         char(10)         YES                          
%   HSV          char(10)         YES                          
%   LSV          char(10)         YES                          
%   HYST         char(10)         YES                          
%   ADEL         char(10)         YES                          
%   MDEL         char(10)         YES                          
%   SIMS         char(10)         YES    
  

%%%%%%%%%%%%%%%%%%%%%
% Open a connection %
%%%%%%%%%%%%%%%%%%%%%
% Note:  Use mysql install in /usr/local/mysql-5.1.45 the default mysql is pointing to /usr/local/mysql
%%Host = 'ps2.als.lbl.gov';    % Control database is ps2, ps3 is the same as pdb (physics database)
% % User = 
% % PassWord = 
% % if ~isempty(User)
% %     OpenResult = mym('open', Host, User, PassWord);
% % else
% %     return
% % end
% % clear PassWord



% set the db URL 
% Note:  Use mysql install in /usr/local/mysql-5.1.45 the default mysql is pointing to /usr/local/mysql
%Host = 'ps2.als.lbl.gov';    % Control database is ps2, ps3 is the same as pdb (physics database)

jdbcURL ='jdbc:mysql://ps3.als.lbl.gov/controls';

%set user passw

%User ='hlc-user';
%PassWord = 'alshlc'; % this is expected to be read-only
%User = 'croper';  %@hlcdev01.dhcp.lbl.gov';  % 'croper'; 
%PassWord = 'cro@als';

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

DataBase = 'controls';

if nargin < 1
    Table = 'ilc';
end


% create a connection to the database
conn =[];
try
    % Matlab 2011a
 %   jdbcURL ='jdbc:mysql://ps3.als.lbl.gov/controls';
 %   conn = database(DataBase, User, PassWord, 'com.mysql.jdbc.Driver', jdbcURL);
    
    %conn = database(DataBase, User, PassWord, 'Vendor', 'MySQL', 'Server', Host, 'databaseurl', jdbcURL);
    
    conn = database(DataBase, User, PassWord, 'Vendor', 'MySQL', 'Server', Host);
    
catch ME
    fprintf('Connection error %s', ME.message);
    if(~isempty(conn))
        fprintf('Connection Message %s \n',conn.Message);
        
        fprintf('Connection paraeters %s \n',conn);
        
    end
end
    
clear PassWord    
    
% Check if connected ok
%if(~isconnection(conn)) 
if(~isopen(conn)) 
    conn.Message
    clear conn;
    return;
end

% create a db meta info obj
dbmetaH = dmd(conn);

dbinfo = get(dbmetaH); % get general info about the db
fprintf('Database info:\n'); 
dbinfo
fprintf('\n'); 
setdbprefs('DataReturnFormat','cellarray');
% isreadonly(conn) -> returns 0?!!
% close(conn);
% 
% return;

%%%%%%%%%%%%%%%%%%%%%
% Select a database %
%%%%%%%%%%%%%%%%%%%%%
% % mym(sprintf('use %s', DataBase));

% database should already be controls
% not sure how DBT treats that....



%%%%%%%%%%%%%%%
% SRLOG TABLE %
%%%%%%%%%%%%%%%

% % % Print table info
% % if ShowTableInfo
% % 	% Display database info
% % 	mym(sprintf('show table status from %s;', DataBase));
% % 
% % 	fprintf('\nAC Columns\n');
% % 	mym('show columns from ac;');
% % 	fprintf('\nAM Columns\n');
% % 	mym('show columns from am;');
% % 	fprintf('\nBC Columns\n');
% % 	mym('show columns from bc;');
% % 	fprintf('\nBM Columns\n');
% % 	mym('show columns from bm;');
% % 	fprintf('\nILC Columns\n');
% % 	mym('show columns from ilc;');
% % 	fprintf('\n');
% %  end

% Print table info 
% If data return is structure:
%  curs.Data
% 
% ans = 
% 
%          TABLE_NAME: {17x1 cell}
%              ENGINE: {17x1 cell}
%             VERSION: [17x1 double]
%          ROW_FORMAT: {17x1 cell}
%          TABLE_ROWS: [17x1 double]
%      AVG_ROW_LENGTH: [17x1 double]
%         DATA_LENGTH: [17x1 double]
%     MAX_DATA_LENGTH: [17x1 double]
%        INDEX_LENGTH: [17x1 double]
%           DATA_FREE: [17x1 double]
%      AUTO_INCREMENT: [17x1 double]
%         CREATE_TIME: {17x1 cell}
%         UPDATE_TIME: {17x1 cell}
%          CHECK_TIME: {17x1 cell}
%     TABLE_COLLATION: {17x1 cell}
%            CHECKSUM: [17x1 double]
%      CREATE_OPTIONS: {17x1 cell}
%       TABLE_COMMENT: {17x1 cell}


if ShowTableInfo
    % Display database info
    % 	mym(sprintf('show table status from %s;', DataBase));
    
        setdbprefs('DataReturnFormat','structure');
    try
        sqlst = sprintf('show table status from %s;', DataBase);
        curs = exec(conn, sqlst);
        curs = fetch(curs); % get dataset
%         attributes = attr(curs);%% get columns info
        close(curs);
        %         close(conn);
        
        
        
    catch ME
        
        fprintf('Error in query %s', ME.message);
        if(~isempty(curs))
            fprintf('Query Message %s \n',curs.Message);
            
            fprintf('Query parameters %s \n',curs);
            
        end
        
    end
    
         dispStructure(curs.Data, 1)
         
% dataInfo.TABLE_NAME = curs.Data.TABLE_NAME; 
% dataInfo.ENGINE = curs.Data.ENGINE;
% dataInfo.VERSION = curs.Data.VERSION;
% dataInfo.ROW_FORMAT = curs.Data.ROW_FORMAT;
% dataInfo.avg_row_length = curs.Data.AVG_ROW_LENGTH;
% dataInfo.data_length = curs.Data.DATA_LENGTH;
% 
% dataInfo.avg_row_length = curs.Data.AVG_ROW_LENGTH;
% dataInfo.avg_row_length = curs.Data.AVG_ROW_LENGTH;
% dataInfo.avg_row_length = curs.Data.AVG_ROW_LENGTH;
% dataInfo.avg_row_length = curs.Data.AVG_ROW_LENGTH;
% dataInfo.avg_row_length = curs.Data.AVG_ROW_LENGTH;
% dataInfo.avg_row_length = curs.Data.AVG_ROW_LENGTH;
% dataInfo.avg_row_length = curs.Data.AVG_ROW_LENGTH;

%             VERSION: [17x1 double]
%          ROW_FORMAT: {17x1 cell}
%          TABLE_ROWS: [17x1 double]
%      AVG_ROW_LENGTH: [17x1 double]
%         DATA_LENGTH: [17x1 double]
%     MAX_DATA_LENGTH: [17x1 double]
%        INDEX_LENGTH: [17x1 double]
%           DATA_FREE: [17x1 double]
%      AUTO_INCREMENT: [17x1 double]
%         CREATE_TIME: {17x1 cell}
%         UPDATE_TIME: {17x1 cell}
%          CHECK_TIME: {17x1 cell}
%     TABLE_COLLATION: {17x1 cell}
%            CHECKSUM: [17x1 double]
%      CREATE_OPTIONS: {17x1 cell}
%       TABLE_COMMENT: {17x1 cell}


%     if(~isempty(curs.Data))
%         for c = 1:size(curs.Data, 1)
%             temp1 =attributes(c).fieldName;
%             fprintf('%s,\t',temp1);
%             
%             
%         end
%         fprintf('\n');
%         % print the column
%         % modify this to check data type and empty columns
%         for r = 1:size(curs.Data,1)
%             for c = 1:size(curs.Data,2)
%                 temp2 = curs.Data{r,c};
%                 
%                 fprintf('%s,\t',temp2);
%                 
%             end
%         end
        
        
        
        
%     end
    setdbprefs('DataReturnFormat','cellarray');
    %     all_columns =columns(dbmetaH, 'controls');
    scol='show columns from ac;'
    curs = exec(conn, scol);
    curs = fetch(curs); % get dataset
    close(curs);
    
    fprintf('\nAC Columns\n');
    curs.Data(:,1:2)
    
    scol='show columns from am;'
    curs = exec(conn, scol);
    curs = fetch(curs); % get dataset
    close(curs);
    
    fprintf('\nAM Columns\n');
    curs.Data(:,1:2)
    
    
    scol='show columns from bc;'
    curs = exec(conn, scol);
    curs = fetch(curs); % get dataset
    close(curs);
    
    fprintf('\nBC Columns\n');
    curs.Data(:,1:2)
    
    
    scol='show columns from bm;'
    curs = exec(conn, scol);
    curs = fetch(curs); % get dataset
    close(curs);
    
    fprintf('\nBM Columns\n');
    curs.Data(:,1:2)
    
    scol='show columns from ilc;'
    curs = exec(conn, scol);
    curs = fetch(curs); % get dataset
    close(curs);
    
    fprintf('\nILC Columns\n');
    curs.Data(:,1:2)
    
    
    fprintf('\n');
end




% % TODO
% % TableInfo = mym(sprintf('show table status from %s;', DataBase));

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



if 0
% % TableInfo = mym('select number,name,ilc_type,phy_lnk,sn from ilc where number >= 1 order by number;')
setdbprefs('DataReturnFormat','structure');
stinfo = 'select number, name, ilc_type, phy_lnk, sn from ilc where number >= 1 order by number;';
curs = exec(conn, stinfo);
curs = fetch(curs); % get dataset
close(curs);
    
    
% TableInfo.number = curs.Data(:,1);
% TableInfo.name = curs.Data(:,2);
% TableInfo.ilc_type = curs.Data(:,3);
% TableInfo.phy_lnk = curs.Data(:,4);
% TableInfo.sn = curs.Data(:,5);


TableInfo.number = curs.Data.NUMBER;
TableInfo.name = curs.Data.NAME;
TableInfo.ilc_type = curs.Data.ILC_TYPE;
TableInfo.phy_lnk = curs.Data.PHY_LNK;
TableInfo.sn = curs.Data.SN;


% % for i = 1:length(TableInfo.number)
% % 	Name = TableInfo.name{i};
% % 	k = find(Name == ' ');
% % 	Name(k) = '_';
% %     fprintf('%3d\t%-10s\t%d\t%d\t%d\n', TableInfo.number(i), Name, TableInfo.ilc_type(i), TableInfo.phy_lnk(i), TableInfo.sn(i));
% % end


for i = 1:length(TableInfo.number)
	Name = TableInfo.name{i};
	k = find(Name == ' ');
	Name(k) = '_';
    fprintf('%3d\t%-10s\t%d\t%d\t%d\n', TableInfo.number(i), Name, TableInfo.ilc_type(i), TableInfo.phy_lnk(i), TableInfo.sn(i));
%    fprintf('%3d\t%-10s\t%d\t%d\t%d\n', TableInfo.number{i}, Name, TableInfo.ilc_type{i}, TableInfo.phy_lnk{i}, TableInfo.sn{i});
end



% TODO check this
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

PrintILCInfo(ILCUnknown, conn);
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

%PrintILCInfo(450, conn, 'ilc');  % SR01C HCM2,3,4

%PrintILCInfo(266, conn, 'ilc');   % BR2 SF,SD
%PrintILCInfo(267, conn, 'ilc');   % BR2 HCM2, BR3 HCM1 (BR3 looks like a type-o)
%PrintILCInfo([267 268], conn, 'ilc');   % BR2 HCM3,4
BR_Mag_ILCs = [
262
263
264
265
266

267
268
269
270
271

272
273
274
275
276

277
278
279
280
281
];
PrintILCInfo(BR_Mag_ILCs, conn, 'ilc');

Misc = [
69
442
444
498
% 524  Sabersky Finger
525
719
733
737
741];
%PrintILCInfo(Misc, Table);


InjectionMagnets = [
65
66
67
68
72
77
82
83
84
85
86
87
364
365
374
375
376

70
71
76
362
363
372
373
742];
%PrintILCInfo(InjectionMagnets, Table);

Injection = [ 
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
294
377
378
];
%PrintILCInfo(Injection, Table);

QFAShunts = [
743
744
745];
%PrintILCInfo(QFAShunts, Table);

IonGaugesPumps = [
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
%PrintILCInfo(IonGaugesPumps, Table);


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
747];
%TODO
% % PrintILCInfo(EPBI, Table);

%%%%%%%%%%%%%%%%%%%%%%
% Close the database %
%%%%%%%%%%%%%%%%%%%%%%

% % mym('close');
close(conn);

% % function PrintILCInfo(ILCNumber, Table, conn)
function PrintILCInfo(ILCNumber, conn, Table)
%Table = 'ilc';
%Tables = {'ac','am','bc','bm','ilc'};
Tables = {'ac','am','bc','bm'};

setdbprefs('DataReturnFormat','structure');

Columns    = 'ilc,sys_name,id_name,chan_name,net_name';
ColumnsAC  = 'ilc,sys_name,id_name,chan_name,net_name,upper_lim,low_lim,hard_type';
ColumnsILC = 'name,rack';

nAC = 0;
nAM = 0;
nBC = 0;
nBM = 0;

	
m = 0;
for iILC = 1:length(ILCNumber)
    for iTable = 1:length(Tables)
        %fprintf('ILC #%d\n', ILCNumber(iILC));
        
        if strcmpi(Tables(iTable), 'ac')
            % % 			TableInfo = mym(sprintf(' select %s from %s where ilc = %d order by ilc;', ColumnsAC, Tables{iTable}, ILCNumber(iILC)));
            stinfo = sprintf(' select %s from %s where ilc = %d order by ilc;', ColumnsAC, Tables{iTable}, ILCNumber(iILC));
            curs = exec(conn, stinfo);
            curs = fetch(curs); % get dataset
            close(curs);
            TableInfo = curs.Data;
            
            %TableInfo
        elseif any(strcmpi(Tables(iTable), {'am','bi','bm','bc'}))
            % %             TableInfo = mym(sprintf(' select %s from %s where ilc = %d order by ilc;', Columns, Tables{iTable}, ILCNumber(iILC)));
            stinfo = sprintf(' select %s from %s where ilc = %d order by ilc;', Columns, Tables{iTable}, ILCNumber(iILC));
            curs = exec(conn, stinfo);
            curs = fetch(curs); % get dataset
            close(curs);
            TableInfo = curs.Data;
            
        elseif strcmpi(Tables(iTable), 'ilc')
            stinfo = sprintf(' select %s from %s where ilc = %d order by ilc;', ColumnsILC, Tables{iTable}, ILCNumber(iILC));
            curs = exec(conn, stinfo);
            curs = fetch(curs); % get dataset
            close(curs);
            TableInfo = curs.Data;
        end
        
%         stinfo = sprintf(' select %s from %s where rack=S060307;', ColumnsILC, Tables{iTable},);
%         curs = exec(conn, stinfo);
%         curs = fetch(curs); % get dataset
%         close(curs);
%         TableInfo = curs.Data;

        
        % %         if isempty(TableInfo.ilc)
        if strcmpi(TableInfo,'No data')
            %fprintf('%3d -> No %s column\n',ILCNumber(iILC), Tables{iTable});
        else
            for i = 1:length(TableInfo.ILC)
                % Combine the name into one string (like an EPICS PV name)
% %                 Name = sprintf('%-8s%-7s%-4s', TableInfo.sys_name{i}, TableInfo.id_name{i}, TableInfo.chan_name{i});
                Name = sprintf('%-8s%-7s%-4s', TableInfo.SYS_NAME{i}, TableInfo.ID_NAME{i}, TableInfo.CHAN_NAME{i});
                k = find(Name == ' ');
                Name(k) = '_';
                
                k = find(Name == '.');  % Not the best choice in my oppinion
                Name(k) = ',';
                
                % Remove " " from the net name (looks like a label string) so it doesn't get split into multiple columns
                %k = find(TableInfo.net_name{i} == ' ');
                %TableInfo.net_name{i}(k) = '_';
                
                m = m + 1;
% %                 XLScell(m,1:4) = {TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i}};
                XLScell(m,1:4) = {TableInfo.ILC(i), Name, Tables{iTable}, TableInfo.NET_NAME{i}};
                %fprintf('%3d\t%-5s\t%-10s\t%-4s\t%s\t"%s"\n', TableInfo.ilc(i), TableInfo.sys_name{i}, TableInfo.id_name{i}, TableInfo.chan_name{i}, Tables{iTable}, TableInfo.net_name{i});
                
                if strcmpi(Tables(iTable), 'ac')
                    nAC = nAC + 1;
% %                     fprintf('%3d\t%s\t%s\t%-18s\t%.1f\t%.1f\n', TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i}, TableInfo.low_lim(i), TableInfo.upper_lim(i));
                    fprintf('%3d\t%s\t%s\t%-18s\t%.1f\t%.1f\n', TableInfo.ILC(i), Name, Tables{iTable}, TableInfo.NET_NAME{i}, TableInfo.LOW_LIM(i), TableInfo.UPPER_LIM(i));
                elseif strcmpi(Tables(iTable), 'am')
                    nAM = nAM + 1;
% %                     fprintf('%3d\t%s\t%s\t"%s"\n', TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i});
                    fprintf('%3d\t%s\t%s\t"%s"\n', TableInfo.ILC(i), Name, Tables{iTable}, TableInfo.NET_NAME{i});
                elseif strcmpi(Tables(iTable), 'bc')
                    nBC = nBC + 1;
% %                     fprintf('%3d\t%s\t%s\t"%s"\n', TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i});
                    fprintf('%3d\t%s\t%s\t"%s"\n', TableInfo.ILC(i), Name, Tables{iTable}, TableInfo.NET_NAME{i});
                elseif strcmpi(Tables(iTable), 'bm')
                    nBM = nBM + 1;
% %                     fprintf('%3d\t%s\t%s\t"%s"\n', TableInfo.ilc(i), Name, Tables{iTable}, TableInfo.net_name{i});
                    fprintf('%3d\t%s\t%s\t"%s"\n', TableInfo.ILC(i), Name, Tables{iTable}, TableInfo.NET_NAME{i});
                end
            end
        end
        %fprintf('\n');
    end
    fprintf('\n');
end


fprintf('Number of AC = %d\n', nAC);
fprintf('Number of AM = %d\n', nAM);
fprintf('Number of BC = %d\n', nBC);
fprintf('Number of BM = %d\n', nBM);
	
	
if ispc
	xlswrite('ExcelTestFile.xls', XLScell, 'SheetILC', 'A2');
end


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

% display a structure
% only for level 1
function dispStructure(astruct, level)

if nargin < 2
    level = 0;
end

level = 2;

fn = fieldnames(astruct);

for n= 1:length(fn)
    
    tabs = '';
    for m=1:level
        tabs = [tabs '    '];
    end
    disp([tabs fn{n}])
    
    fn2 = getfield(astruct, fn{n});
    
    if isstruct(fn2)
        dispStructure(fn2, level+1);
    else
        disp(fn2);
    end
    
end


































