%=============================================================
function varargout=WriteReference(varargin)
%=============================================================
% write reference orbit file in format of spear orbit program
filename=varargin(1);   filename=char(filename);
comment =varargin(2);   comment=char(comment);
bpm     =varargin(3);   bpm=bpm{1};

[fid,message]=fopen(filename,'w');
if fid==-1
  disp(['WARNING: Unable to open file to write reference :' filename]);
  disp(message);
  return
end
disp(['Writing reference orbit file: ' filename]);
fprintf(fid,'%s\n','Reference Orbit');
fprintf(fid,'%s\n',['timestamp: ' datestr(now,0)]);
fprintf(fid,'%s\n',comment);
fprintf(fid,'%d %d\n',bpm(1).ntbpm, length(bpm(1).iref));
fprintf(fid,'%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n' ,bpm(1).iref);
if ~(mod(length(bpm(1).iref),10)==0) fprintf(fid,'%s\n',' '); end %line feed

for ii=1:length(bpm(1).name)
fprintf(fid,'%3d %6.3f %6.3f %6.3f %s\n',...
ii, bpm(1).ref(ii), bpm(2).ref(ii), bpm(2).ref(ii),bpm(1).name(ii,:)); %5 columns wide
end
fclose(fid);
