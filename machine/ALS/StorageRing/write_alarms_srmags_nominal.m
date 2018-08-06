function write_alarms_srmags_nominal
% function write_alarms_srmags_nominal
%
% This routine writes the HIGH, LOW, HIHI, and LOLO fields for the AM
% channels of storage ring magnets - currently only QF and QD
%
% Christoph Steier, November 2010
%

BENDind = [1 1;4 2;8 2;12 2];
QFAind = [1 1;4 1;8 1];
SEXTind = [1 1];

BENDname=getname('BEND',BENDind);
QFname = getname('QF');
QDname = getname('QD');
QFAname=getname('QFA',QFAind);
QDAname=getname('QDA');
SFname=getname('SF',SEXTind);
SDname=getname('SD',SEXTind);

setpv(strcat(BENDname,'.HIGH'),[900;300;300;300]);
setpv(strcat(BENDname,'.LOW'),-1);
setpv(strcat(BENDname,'.HIHI'),[905;302;302;302]);
setpv(strcat(BENDname,'.LOLO'),-2);

setpv(strcat(QFname,'.HIGH'),115);
setpv(strcat(QFname,'.LOW'),-1);
setpv(strcat(QFname,'.HIHI'),120);
setpv(strcat(QFname,'.LOLO'),-2);

setpv(strcat(QDname,'.HIGH'),118);
setpv(strcat(QDname,'.LOW'),-1);
setpv(strcat(QDname,'.HIHI'),120);
setpv(strcat(QDname,'.LOLO'),-2);

setpv(strcat(QFAname,'.HIGH'),552);
setpv(strcat(QFAname,'.LOW'),-1);
setpv(strcat(QFAname,'.HIHI'),600);
setpv(strcat(QFAname,'.LOLO'),-2);

% setpv(strcat(QDAname,'.HIGH'),91); %added 1A on 7-23 due to setting of SR12C___QDA2 after symmetrization
% setpv(strcat(QDAname,'.LOW'),-1);
% setpv(strcat(QDAname,'.HIHI'),101);
% setpv(strcat(QDAname,'.LOLO'),-2);

setpv([SFname(1,:) '.HIGH'],385); % there is only one SF power supply
setpv([SFname(1,:) '.LOW'],-1);
setpv([SFname(1,:) '.HIHI'],400);
setpv([SFname(1,:) '.LOLO'],-2);

setpv([SDname(1,:) '.HIGH'],300); % there is only one SD power supply
setpv([SDname(1,:) '.LOW'],-1);
setpv([SDname(1,:) '.HIHI'],350);
setpv([SDname(1,:) '.LOLO'],-2);

