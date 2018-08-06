function smat2hiroshi

BPMxList = getbpmlist('2 3 4 5 6 7 8 9');
BPMyList = BPMxList;
HCMList = getcmlist('Horizontal');
VCMList = getcmlist('Vertical');

[R, FN] = getbpmresp('BPMx', BPMxList, 'BPMy', BPMyList, 'HCM', HCMList, 'VCM', VCMList, 'Filename', '', 'NoEnergyScaling', 'Struct');

Sx = R(1,1).Data;
Sy = R(2,2).Data;


IDBPMxList = getbpmlist('1 10');
IDBPMyList = BPMxList;
HCMList = getcmlist('Horizontal');
VCMList = getcmlist('Vertical');

[R, FN] = getbpmresp('BPMx', IDBPMxList, 'BPMy', IDBPMyList, 'HCM', HCMList, 'VCM', VCMList, 'Filename', FN, 'NoEnergyScaling', 'Struct');

SIDx = R(1,1).Data;
SIDy = R(2,2).Data;


clear R 

FN(end-3:end) = [];
save([FN, 'Hiroshi']);