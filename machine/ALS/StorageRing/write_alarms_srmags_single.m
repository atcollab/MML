function write_alarms_srmags_single
% function write_alarms_srmags_single
%
% This routine writes the HIGH, LOW, HIHI, and LOLO fields for the AM
% channels of storage ring magnets - currently only QF and QD
%
% Christoph Steier, November 2010
%

BENDind = [1 1;4 2;8 2;12 2];
QFAind = [1 1;4 1;8 1];
SEXTind = [1 1];

BENDtol=gettol('BEND',BENDind);
QFtol=gettol('QF');
if size(QFtol)>22
    QFtol(23)=QFtol(23)*1.5;
end
QDtol=gettol('QD');
QFAtol=gettol('QFA',QFAind);
if size(QFAtol,2)==2
    QFAtol=QFAtol(:,2);
end
QDAtol=gettol('QDA');
SFtol=gettol('SF',SEXTind);
SDtol=gettol('SD',SEXTind);

BENDname=getname('BEND',BENDind);
QFname = getname('QF');
QDname = getname('QD');
QFAname=getname('QFA',QFAind);
QDAname=getname('QDA');
SFname=getname('SF',SEXTind);
SDname=getname('SD',SEXTind);


BENDsp = getsp('BEND',BENDind)+[0;0;0;0];
QFsp = getsp('QF');
QDsp = getsp('QD');
QFAsp = getsp('QFA',QFAind);
% QDAsp = getsp('QDA');
SFsp = getsp('SF',SEXTind);
SDsp = getsp('SD',SEXTind);

setpv(strcat(BENDname,'.HIGH'),BENDsp+1.5*BENDtol);
setpv(strcat(BENDname,'.LOW'),BENDsp-1.5*BENDtol);
setpv(strcat(BENDname,'.HIHI'),BENDsp+3*BENDtol);
setpv(strcat(BENDname,'.LOLO'),BENDsp-3*BENDtol);

% disp([datestr(now) ': write alarms srmags: setting BEND alarm values for alarm handler']);

setpv(strcat(QFname,'.HIGH'),QFsp+3*QFtol);
setpv(strcat(QFname,'.LOW'),QFsp-3*QFtol);
setpv(strcat(QFname,'.HIHI'),QFsp+10*QFtol);
setpv(strcat(QFname,'.LOLO'),QFsp-10*QFtol);


setpv(strcat(QDname,'.HIGH'),QDsp+3*QDtol);
setpv(strcat(QDname,'.LOW'),QDsp-3*QDtol);
setpv(strcat(QDname,'.HIHI'),QDsp+10*QDtol);
setpv(strcat(QDname,'.LOLO'),QDsp-10*QDtol);

% disp([datestr(now) ': write alarms srmags: setting QF+QD alarm values for alarm handler']);

setpv(strcat(QFAname,'.HIGH'),QFAsp+1.5*QFAtol);
setpv(strcat(QFAname,'.LOW'),QFAsp-1.5*QFAtol);
setpv(strcat(QFAname,'.HIHI'),QFAsp+3*QFAtol);
setpv(strcat(QFAname,'.LOLO'),QFAsp-3*QFAtol);

% disp([datestr(now) ': write alarms srmags: setting QFA alarm values for alarm handler']);

% setpv(strcat(QDAname,'.HIGH'),QDAsp+2*QDAtol);
% setpv(strcat(QDAname,'.LOW'),QDAsp-2*QDAtol);
% setpv(strcat(QDAname,'.HIHI'),QDAsp+6*QDAtol);
% setpv(strcat(QDAname,'.LOLO'),QDAsp-6*QDAtol);
% 
% % disp([datestr(now) ': write alarms srmags: setting QDA alarm values for alarm handler']);

setpv([SFname(1,:) '.HIGH'],SFsp(1)+2*SFtol(1)); % there is only one SF power supply
setpv([SFname(1,:) '.LOW'],SFsp(1)-2*SFtol(1));
setpv([SFname(1,:) '.HIHI'],SFsp(1)+5*SFtol(1));
setpv([SFname(1,:) '.LOLO'],SFsp(1)-5*SFtol(1));

% disp([datestr(now) ': write alarms srmags: setting SF alarm values for alarm handler']);

setpv([SDname(1,:) '.HIGH'],SDsp(1)+2*SDtol(1)); % there is only one SD power supply
setpv([SDname(1,:) '.LOW'],SDsp(1)-2*SDtol(1));
setpv([SDname(1,:) '.HIHI'],SDsp(1)+5*SDtol(1));
setpv([SDname(1,:) '.LOLO'],SDsp(1)-5*SDtol(1));


% disp([datestr(now) ': write alarms srmags: setting SD alarm values for alarm handler']);
