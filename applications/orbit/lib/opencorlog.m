function varargout=OpenCORLog(varargin)
% open file to log bpms
filename=varargin(1);  filename=char(filename);
comment =varargin(2);  comment=char(comment);
COR     =varargin(3);  COR=COR{1};
ncyc    =varargin(4);  ncyc=ncyc{1};

ntcorx=length(COR(1).name);
ntcory=length(COR(2).name);
ncx=length(COR(1).ifit);
icx=COR(1).ifit;
ncy=length(COR(2).ifit);
icy=COR(2).ifit;


[fid,message]=fopen(filename,'w');
if fid==-1
  disp(['WARNING: Unable to open file to log correctors :' filename]);
  disp(message);
  return
end
fprintf(fid,'%s\n',['Feedback COR Log file: ' filename, '     ', comment]);
fprintf(fid,'%s\n',['Timestamp: ' datestr(now,0)]);
fprintf(fid,'%d %d %d %d %d\n',ntcorx, ntcory, ncx, ncy, ncyc);

%Horizontal COR indices;
fprintf(fid,'%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n' ,icx);
if ~(mod(length(icx),10)==0) fprintf(fid,'%s\n',' '); end %line feed
%Vertical COR indices;
fprintf(fid,'%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n' ,icy);
if ~(mod(length(icy),10)==0) fprintf(fid,'%s\n',' '); end %line feed

fprintf(fid,'%6.3f %6.3f\n',0.0, 0.0);   %tunes

for ip=1:2
for ii=1:length(COR(ip).name)
fprintf(fid,'%10s %6.3f %6.3f %6.3f% 6.3f\n',...
COR(ip).name(ii,:), 0.0, 0.0, 0.0, 0.0); %5 columns wide
end
end

disp(['COR log file open: ' filename]);
varargout{1}=fid;
