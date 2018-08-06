function varargout=CloseLog(varargin)
%=============================================================
fid=varargin(1); fid=fid{1};
fclose(fid);
disp('Log file closed');
