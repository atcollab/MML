function varargout=CloseSYSLog(varargin)
%close Log file for application program
fid=varargin(1); fid=fid{1};

fclose(fid);
disp('System Log file closed');