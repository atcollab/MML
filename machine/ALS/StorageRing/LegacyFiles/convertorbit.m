
% Get the following files from the old middlelayer
% BPMoffset.mat
% golden.mat
% getoffsetorbit.m


cd /home/als/physbase


% Build the offset an golden orbits
XOffsetNew = NaN*ones(120,1);
YOffsetNew = NaN*ones(120,1);
XGoldenNew = NaN*ones(120,1);
YGoldenNew = NaN*ones(120,1);

DeviceList = family2dev('BPMx',0);


% 96 origional "arc" BPMs
i = findrowindex(getbpmlist('arc'), DeviceList);

StartDir = pwd;
cd /home/als/physbase/matlab/als/alsdata/
load BPMoffset
load golden

XOffsetNew(i) = Xoffset;
YOffsetNew(i) = Yoffset;
XGoldenNew(i) = Xgolden;
YGoldenNew(i) = Ygolden;


BergozList = getbpmlist('arc','Bergoz', '5 6');
i = findrowindex(BergozList, DeviceList);

cd /home/als/physbase/matlab/als/commands

OldList = [
    1     4
    1     5
    2     4
    2     5
    3     4
    3     5
    4     4
    4     5
    5     4
    5     5
    6     4
    6     5
    7     4
    7     5
    8     4
    8     5
    9     4
    9     5
    10     4
    10     5
    11     4
    11     5
    12     4
    12     5];
XOffsetNew(i) = getoffsetorbit('BBPMx', OldList);
YOffsetNew(i) = getoffsetorbit('BBPMy', OldList);
XGoldenNew(i) = getgoldenorbit('BBPMx', OldList);
YGoldenNew(i) = getgoldenorbit('BBPMy', OldList);


% Straight section Bergoz BPMs
OldList = [
    2.0000    1.0000   
    2.0000    2.0000  
    4.0000    1.0000  
    4.0000    3.0000   
    4.0000    4.0000   
    4.0000    2.0000  
    5.0000    1.0000  
    5.0000    2.0000  
    6.0000    1.0000  
    6.0000    2.0000  
    7.0000    1.0000  
    7.0000    2.0000  
    8.0000    1.0000  
    8.0000    2.0000  
    9.0000    1.0000  
    9.0000    2.0000  
   10.0000    1.0000  
   10.0000    2.0000 
   11.0000    1.0000   
   11.0000    3.0000  
   11.0000    4.0000  
   11.0000    2.0000  
   12.0000    1.0000  
   12.0000    2.0000    
];

cd /home/als/physbase
BergozList = getbpmlist('Straight','Bergoz','1 10 11 12');
i = findrowindex(BergozList, DeviceList);

cd /home/als/physbase/matlab/als/commands
XOffsetNew(i) = getoffsetorbit('IDBPMx',OldList);
YOffsetNew(i) = getoffsetorbit('IDBPMy',OldList);
XGoldenNew(i) = getgoldenorbit('IDBPMx',OldList);
YGoldenNew(i) = getgoldenorbit('IDBPMy',OldList);



% Bergoz BPMs added to the "arcs" 
OldNew = [
    1.0000    1.0000   12 9 
    1.0000    2.0000    1 2

    3.0000    1.0000    2 9
    3.0000    2.0000    3 2];

i = findrowindex(OldNew(:,3:4), DeviceList);

XOffsetNew(i) = getoffsetorbit('IDBPMx',OldNew(:,1:2));
YOffsetNew(i) = getoffsetorbit('IDBPMy',OldNew(:,1:2));
XGoldenNew(i) = getgoldenorbit('IDBPMx',OldNew(:,1:2));
YGoldenNew(i) = getgoldenorbit('IDBPMy',OldNew(:,1:2));


cd(StartDir);


% Save new physdata
setphysdata('BPMx','Offset', XOffsetNew);
setphysdata('BPMy','Offset', YOffsetNew, 'NoArchive');
setphysdata('BPMx','Golden', XGoldenNew, 'NoArchive');
setphysdata('BPMy','Golden', YGoldenNew, 'NoArchive');



