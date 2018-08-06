function saveusergaps

DirStart = pwd;

if ispc
    cd \\Als-filer\physbase\hlc\SR\ID
else
    cd /home/als/physbase/hlc/SR/ID
end


% ID_UserGap.sh 
FileName = mml2caput('ID', 'UserGap', getpv('ID', 'UserGap'));


% ID_Setpoint_UserGap.sh  (turn gap control off)
FileName = mml2caput({'ID','ID'}, {'GapEnableControl', 'Setpoint'}, {0,getpv('ID', 'UserGap')}, {family2dev('ID'), family2dev('ID')}, 'ID_Setpoint_UserGap.sh', 0, .25);


% EPU_UserGap.sh 
FileName = mml2caput('EPU', 'UserGap', getpv('EPU', 'UserGap'));


% EPU_Setpoint_UserGap.sh (turn gap control off)
FileName = mml2caput({'ID','EPU'}, {'GapEnableControl', 'Setpoint'}, {0,getpv('EPU', 'UserGap')}, {family2dev('EPU'), family2dev('EPU')}, 'EPU_Setpoint_UserGap.sh', 0, .25);
%FileName = mml2caput('EPU', 'Setpoint', getpv('EPU', 'UserGap'), family2dev('EPU'), 'EPU_Setpoint_UserGap.sh');

fprintf('   ID user requests saved.  User the "ID Control" EPICS application to restore them.\n');

cd(DirStart);

