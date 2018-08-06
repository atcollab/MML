setpv('BR1:B:SWAP_TABLE',1);
pause(0.5);
BENDwave=lcaget('BR1:B:RAMPI');
dvmdata=readdvmfile_booster([PathName InputFile]);
timevec=(1:length(dvmdata.Data))*dvmdata.TimeStep;
timevecBEND=(1:length(BENDwave))/97720;
figure;
plot(timevec,125*dvmdata.Data(:,1),timevecBEND,125*(BENDwave*10/2^23)*1.23395+19.35);

pause(0.5);

setpv('BR1:QF:SWAP_TABLE',1);
pause(0.5);
QFwave=lcaget('BR1:QF:RAMPI');
dvmdata=readdvmfile_booster([PathName InputFile]);
timevec=(1:length(dvmdata.Data))*dvmdata.TimeStep;
timevecQF=(1:length(QFwave))/97720;
figure;
plot(timevec,60*dvmdata.Data(:,3),timevecQF,60*(QFwave*10/2^23)*1.2275+9.45);

pause(0.5);

setpv('BR1:QD:SWAP_TABLE',1);
pause(0.5);
QDwave=lcaget('BR1:QD:RAMPI');
dvmdata=readdvmfile_booster([PathName InputFile]);
timevec=(1:length(dvmdata.Data))*dvmdata.TimeStep;
timevecQD=(1:length(QDwave))/97720;
figure;
plot(timevec,60*dvmdata.Data(:,2),timevecQD,60*(QDwave*10/2^23)*1.228+9.53);
