function varargout=OpenBPMLog(varargin)
% open file to log bpms
filename=varargin(1);  filename=char(filename);
comment =varargin(2);  comment=char(comment);
BPM     =varargin(3);  BPM=BPM{1};
ncyc    =varargin(4);  ncyc=ncyc{1};

ntbpm=length(BPM(1).name);
nbx=length(BPM(1).ifit);
ibx=BPM(1).ifit;
nby=length(BPM(2).ifit);
iby=BPM(2).ifit;
nbb=nbx;
ibb=ibx;


[fid,message]=fopen(filename,'w');
if fid==-1
  disp(['WARNING: Unable to open file to log bpms :' filename]);
  disp(message);
  return
end
fprintf(fid,'%s\n',['Feedback BPM Log file: ' filename, '     ', comment]);
fprintf(fid,'%s\n',['Timestamp: ' datestr(now,0)]);
fprintf(fid,'%d %d %d %d %d\n',ntbpm, nbx, nby, nbb, ncyc);

%Horizontal BPM indices;
fprintf(fid,'%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n' ,ibx);
if ~(mod(length(ibx),10)==0) fprintf(fid,'%s\n',' '); end %line feed
%Vertical BPM indices;
fprintf(fid,'%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n' ,iby);
if ~(mod(length(iby),10)==0) fprintf(fid,'%s\n',' '); end %line feed
%Bump BPM indices;
fprintf(fid,'%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n' ,ibb);
if ~(mod(length(ibb),10)==0) fprintf(fid,'%s\n',' '); end %line feed

fprintf(fid,'%6.3f %6.3f\n',0.0, 0.0);   %tunes

for ii=1:length(BPM(1).name)
fprintf(fid,'%10s %6.3f %6.3f %6.3f% 6.3f\n',...
BPM(1).name(ii,:), 0.0, 0.0, 0.0, 0.0); %5 columns wide
end

fprintf(fid,'%s\n',['Reference Orbit: ' num2str(length(BPM(1).status))]);
fprintf(fid,'%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n' ,BPM(1).iref);
if ~(mod(length(BPM(1).iref),10)==0) fprintf(fid,'%s\n',' '); end %line feed

for ii=1:length(BPM(1).name)
fprintf(fid,'%3d %15.3f %15.3f %15.3f\n',...
ii, BPM(1).ref(ii), BPM(2).ref(ii), BPM(2).ref(ii));
end

disp(['BPM log file open: ' filename]);

varargout{1}=fid;
