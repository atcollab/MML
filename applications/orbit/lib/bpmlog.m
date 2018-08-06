function varargout=BPMLog(varargin)
%=============================================================
% write bpms to file in format of spear orbit program

SYS     =varargin{1};
BPM     =varargin{2};
if nargin==3
BL      =varargin{3};
else
BL=[];
end


%disp('bpmlog')
fid=SYS.BPMLogfid;
cyc=SYS.cycle;
curr=SYS.curr;
fprintf(fid,'%s\n',[num2str(cyc),'   ',datestr(now,0),'    ',num2str(curr)]);
for ii=1:length(BPM(1).name(:,1))
fprintf(fid,'%12.3f %12.3f %12.3f\n',...
BPM(1).act(ii), BPM(2).act(ii), 0.0);
end
if ~isempty(BL)
for ii=1:length(BL(2).name(:,1))
fprintf(fid,'%12.3f\n',BL(2).nerr(ii));
end
end