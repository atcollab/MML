function varargout=CORLog(varargin)
%=============================================================
% write correctors to file in format of spear orbit program

SYS     =varargin(1);  SYS=SYS{1};
COR     =varargin(2);  COR=COR{1};

%disp('corlog');
fid=SYS.CORLogfid;
cyc=SYS.cycle;
curr=SYS.curr;

fprintf(fid,'%s\n',[num2str(cyc),'   ',datestr(now,0),'    ',num2str(curr)]);
fprintf(fid,'%s\n','Horizontal Data (measured, fit increment, accumulated)');
for ii=1:length(COR(1).name)
fprintf(fid,'%12.3f %12.3f %12.3f\n',...
COR(1).act(ii),COR(1).fit(ii),COR(1).fit(ii));
end
fprintf(fid,'%s\n','Vertical Data (measured, fit increment, accumulated)');
for ii=1:length(COR(2).name)
fprintf(fid,'%12.3f %12.3f %12.3f\n',...
COR(2).act(ii),COR(2).fit(ii),COR(2).fit(ii));
end
