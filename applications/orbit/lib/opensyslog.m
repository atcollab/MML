function varargout=OpenSysLog(varargin)
%open Log file for application program
apptype=varargin(1); apptype=char(apptype);

ts = datestr(now,0);
tmp=[apptype '-' ts ];
filename=[tmp(1:17) '-' tmp(19:20) tmp(22:23) tmp(25:26)];

[fid,message]=fopen(filename,'w');
if fid==-1
  disp(['WARNING: Unable to open system log file:' filename]);
  disp(message);
  return
end
fprintf(fid,'%s\n',[apptype, ' log file: ' filename]);
fprintf(fid,'%s\n',['Timestamp: ' datestr(now,0)]);
disp('System Log file open');

varargout{1}=fid;