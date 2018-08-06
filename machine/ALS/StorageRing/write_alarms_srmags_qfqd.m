function write_alarms_srmags_qfqd(QFsp,QDsp)
% function write_alarms_srmags_qfqd(QFsp,QDsp)
%
% This routine writes the HIGH, LOW, HIHI, and LOLO fields for the AM
% channels of storage ring magnets - currently only QF and QD
%
% Christoph Steier, November 2010
%

% QFtol=gettol('QF');
% QDtol=gettol('QD');
% if size(QFtol)>22
%     QFtol(23)=QFtol(23)*1.5;
% end

QFtol=0.2;QDtol=0.2;

QFname = getname('QF');
QDname = getname('QD');

if nargin<2
    QFsp = getsp('QF');
    QDsp = getsp('QD');
end

setpvonline(strcat(QFname,'.HIGH'),QFsp+3*QFtol);
setpvonline(strcat(QFname,'.LOW'),QFsp-3*QFtol);
setpvonline(strcat(QFname,'.HIHI'),QFsp+10*QFtol);
setpvonline(strcat(QFname,'.LOLO'),QFsp-10*QFtol);

setpvonline(strcat(QDname,'.HIGH'),QDsp+3*QDtol);
setpvonline(strcat(QDname,'.LOW'),QDsp-3*QDtol);
setpvonline(strcat(QDname,'.HIHI'),QDsp+10*QDtol);
setpvonline(strcat(QDname,'.LOLO'),QDsp-10*QDtol);

