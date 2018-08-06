function buildsrdatabase
%BUILDSRDATABASE - Build the storage ring database tables BPM, Lattice, MPS
%
%  Also calls buildbpmrespdatabase
%
%  See also buildbpmrespdatabase, getmysqldata, showdatabases

%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%%%%%
% Open a connection %
%%%%%%%%%%%%%%%%%%%%%
Host = 'ps3.als.lbl.gov';    % Control database is ps2, ps3 is the same as pdb (physics database)
User = 'portmann';
PassWord = 'gregp'; %'gp80_12!op';
%[User, PassWord] = logindlg('MySQL Connection', User);

%User = 'root';
%PassWord = 'als2010$';

%User = 'croper'; 
%PassWord = 'cro@als';

if ~isempty(User)
    OpenResult = mym('open', Host, User, PassWord);
else
    return
end
clear PassWord


%%%%%%%%%%%%%%%%%%%%%
% Select a Database %
%%%%%%%%%%%%%%%%%%%%%
%UseResult = mym('use controls');
try
    UseResult = mym('use StorageRing');
catch
    mym('create DATABASE StorageRing;');
    UseResult = mym('use StorageRing');
end


%%%%%%%%%%%%%%%%%
% LATTICE TABLE %
%%%%%%%%%%%%%%%%%

% Drop the table and create a new one
mym('drop table if exists LATTICE');

% Create a new table
CommandString = [
    'create table if not exists LATTICE (', ...
    'TableIndex INT AUTO_INCREMENT PRIMARY KEY, ', ...
    'Element int, ', ...
    'SPosition float, ' , ...
    'Length float, ' , ...
    'Family char(15), ', ...
    'Type char(10), ', ...    
    'Sector int, ', ...
    'Device int, ', ...
    'CommonName char(25) ', ...
    ');'];

mym(CommandString);

Ntotal   = 0;
[N, Ntotal] = writelatticetable('BPMx', 'BPM',      Ntotal);
[N, Ntotal] = writelatticetable('BPMy', 'BPM',      Ntotal);
[N, Ntotal] = writelatticetable('HCM',  'COR',      Ntotal);
[N, Ntotal] = writelatticetable('VCM',  'COR',      Ntotal);
[N, Ntotal] = writelatticetable('QF',   'QUAD',     Ntotal);
[N, Ntotal] = writelatticetable('QD',   'QUAD',     Ntotal);
[N, Ntotal] = writelatticetable('QFA',  'QUAD',     Ntotal);
[N, Ntotal] = writelatticetable('QDA',  'QUAD',     Ntotal);
[N, Ntotal] = writelatticetable('SF',   'SEXT',     Ntotal);
[N, Ntotal] = writelatticetable('SD',   'SEXT',     Ntotal);
[N, Ntotal] = writelatticetable('SQSF', 'SKEWQUAD', Ntotal);
[N, Ntotal] = writelatticetable('SQSD', 'SKEWQUAD', Ntotal);
[N, Ntotal] = writelatticetable('BEND', 'BEND',     Ntotal);




%%%%%%%%%%%%%
% BPM TABLE %
%%%%%%%%%%%%%

% Drop the table and create a new one
mym('drop table if exists BPM');

% Create a new table
CommandString = [
    'create table if not exists BPM (', ...
    'TableIndex INT AUTO_INCREMENT PRIMARY KEY, ', ...
    'Element int, ', ...
    'SPosition float, ' , ...
    'Family char(15), ', ...
    'Sector int, ', ...
    'Device int, ', ...
    'CommonName char(25), ', ...
    'ARC int, ', ...
    'Bergoz int, ', ...
    'AM char(25), ', ...
    'AVG char(25), ', ...
    'TimeConstant char(25), ', ...
    'Status int, ' , ...
    'Golden float, ' , ...
    'Offset float ' , ...
    ');'];
mym(CommandString);


Ntotal = 0;
[N, Ntotal] = writebpmtable('BPMx', Ntotal);
[N, Ntotal] = writebpmtable('BPMy', Ntotal);



%%%%%%%%%%%%%
% MPS TABLE %
%%%%%%%%%%%%%

% Drop the table and create a new one
mym('drop table if exists MPS');

% Create a new table
CommandString = [
    'create table if not exists MPS (', ...
    'TableIndex INT AUTO_INCREMENT PRIMARY KEY, ', ...
    'Element int, ', ...
    'SPosition float, ' , ...
    'Family char(15), ', ...
    'Type char(10), ', ...    
    'Sector int, ', ...
    'Device int, ', ...
    'CommonName char(25), ', ...
    'MonitorChanName char(25), ', ...
    'SetpointChanName char(25), ', ...
    'OnMonitorChanName char(25), ', ...
    'OnControlChanName char(25), ', ...
    'ResetChanName char(25), ', ...
    'ReadyChanName char(25), ', ...
    'RampRateChanName char(25), ', ...
    'DACChanName char(25), ', ...
    'TimeConstantChanName char(25), ', ...
    'Status int, ' , ...
    'SetpointMin float, ' , ...
    'SetpointMax float, ' , ...
    'Tolerance float, ' , ...
    'SetpointProduction float, ' , ...
    'SetpointInjection float ' , ...
    ');'];

mym(CommandString);

Ntotal = 0;
[N, Ntotal] = writesrmpstable('HCM',  'COR', Ntotal);
[N, Ntotal] = writesrmpstable('VCM',  'COR', Ntotal);
[N, Ntotal] = writesrmpstable('QF',   'QUAD', Ntotal);
[N, Ntotal] = writesrmpstable('QD',   'QUAD', Ntotal);
[N, Ntotal] = writesrmpstable('QFA',  'QUAD', Ntotal);
[N, Ntotal] = writesrmpstable('QDA',  'QUAD', Ntotal);
[N, Ntotal] = writesrmpstable('SQSF', 'SKEWQUAD', Ntotal);
[N, Ntotal] = writesrmpstable('SQSD', 'SKEWQUAD', Ntotal);
[N, Ntotal] = writesrmpstable('SF',   'SEXT', Ntotal);
[N, Ntotal] = writesrmpstable('SD',   'SEXT', Ntotal);
[N, Ntotal] = writesrmpstable('BEND', 'BEND', Ntotal);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print some output to the screen %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mym('select * from LATTICE;');
mym('select * from BPM;');
mym('select * from MPS;');

mym('explain LATTICE;');
mym('explain BPM;');
mym('explain MPS;');


fprintf('\n   Updating the BPM response matrix database (buildbpmrespdatabase)\n');
buildbpmrespdatabase;


%%%%%%%%%%%%%%%%%%%%%%
% Close the database %
%%%%%%%%%%%%%%%%%%%%%%
mym('close');




function [N, Ntotal] = writelatticetable(Family, Type, Offset)

DevList = family2dev(Family,0);
%Element = dev2elem(Family, DevList);
Spos = getspos(Family, DevList);
L = getleff(Family, DevList);

for i = 1:size(DevList,1)
    mym(sprintf('insert into LATTICE values (%d, %d, %.5f, %.5f, "%s", "%s", %d, %d, "%s");', i+Offset, i, Spos(i), L(i),Family, Type, DevList(i,1), DevList(i,2), family2common(Family, DevList(i,:))));
end
N = size(DevList,1);
Ntotal = Offset + N;




function [N, Ntotal] = writebpmtable(Family, NOffset)

DevList = family2dev(Family,0);
%Element = dev2elem(Family, DevList);
Spos = getspos(Family, DevList);
CommonName = family2common(Family, DevList);
AM = family2channel(Family, 'Monitor', DevList);
AVG = family2channel(Family, 'NumberOfAverages', DevList);
TC = family2channel(Family, 'TimeConstant', DevList);
IsBergoz = zeros(size(DevList,1),1);
[tmp, i] = getbpmlist(Family, 'Bergoz');
IsBergoz(i) = 1;
IsArc = zeros(size(DevList,1),1);
[tmp, i] = getbpmlist(Family, 'Arc');
IsArc(i) = 1;
Status = family2status(Family, DevList);
Golden = getgolden(Family, DevList);
Offset = getoffset(Family, DevList);

% NaN is a problem???
Golden(isnan(Golden)) = 0;

for i = 1:size(DevList,1)
    mym(sprintf('insert into BPM values (%d, %d, %.5f, "%s", %d, %d, "%s", %d, %d, "%s", "%s", "%s", %d, %.5f, %.5f);', ...
        i+NOffset, i, Spos(i), Family, DevList(i,1), DevList(i,2), deblank(CommonName(i,:)), IsArc(i), IsBergoz(i), ...
        deblank(AM(i,:)), deblank(AVG(i,:)), deblank(TC(i,:)), Status(i), Golden(i), Offset(i) ) );
end
N = size(DevList,1);
Ntotal = NOffset + N;




function [N, Ntotal] = writesrmpstable(Family, Type, NOffset)

DevList = family2dev(Family, 0, 1);   % All status, By power supply
%Element = dev2elem(Family, DevList);
Spos = getspos(Family, DevList);
CommonName = family2common(Family, DevList);
AM = family2channel(Family, 'Monitor', DevList);
SP = family2channel(Family, 'Setpoint', DevList);
ONBM = family2channel(Family, 'On', DevList);
ONBC = family2channel(Family, 'OnControl', DevList);
Reset = family2channel(Family, 'Reset', DevList);
Ready = family2channel(Family, 'Ready', DevList);
RampRate = family2channel(Family, 'RampRate', DevList);
DAC = family2channel(Family, 'DAC', DevList);
if isempty(DAC)
    DAC = SP(:,1);
    DAC(:,1) = ' ';
end

TC = family2channel(Family, 'TimeConstant', DevList);
if isempty(TC)
    TC = SP(:,1);
    TC(:,1) = ' ';
end

Status = family2status(Family, DevList);

MagStruct = getproductionlattice(Family, 'Setpoint');
[i, iNotFound, iFoundList1] = findrowindex(DevList, MagStruct.DeviceList);
if isempty(iNotFound)
    % All the devices are in the lattice file
    Prod = MagStruct.Data(i);
else
    % Probably just a status off
    fprintf('   Not all the %s power supplies were found in the production lattice file.\n', Family);
    Prod = zeros(size(DevList,1),1);
    Prod(iFoundList1) = MagStruct.Data(i);
end

MagStruct = getinjectionlattice(Family, 'Setpoint');
[i, iNotFound, iFoundList1] = findrowindex(DevList, MagStruct.DeviceList);
if isempty(iNotFound)
    % All the devices are in the lattice file
    Inj = MagStruct.Data(i);
else
    % Probably just a status off
    fprintf('   Not all the %s power supplies were found in the injection lattice file.\n', Family);
    Inj = zeros(size(DevList,1),1);
    Inj(iFoundList1) = MagStruct.Data(i);
end

Min = minsp(Family, DevList);
Max = maxsp(Family, DevList);
Tol = family2tol(Family, DevList);


for i = 1:size(DevList,1)
    mym(sprintf('insert into MPS values (%d, %d, %.5f, "%s", "%s", %d, %d, "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", %d, %.5f, %.5f, %.5f, %.5f, %.5f);', ...
        i+NOffset, i, Spos(i), Family, Type, DevList(i,1), DevList(i,2), ...
        deblank(CommonName(i,:)), deblank(AM(i,:)), deblank(SP(i,:)), deblank(ONBM(i,:)), deblank(ONBC(i,:)), deblank(Reset(i,:)), deblank(Ready(i,:)), deblank(RampRate(i,:)), deblank(DAC(i,:)), deblank(TC(i,:)), Status(i), Min(i), Max(i), Tol(i), Prod(i), Inj(i) ) );
end
N = size(DevList,1);
Ntotal = NOffset + N;
