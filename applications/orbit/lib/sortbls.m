function varargout=SortBLs(varargin)
% SortBLs compares vectors for:
%(1) available electronically     (BL.open)
%(2) available in response matrix (RSP.ibl)
%(3) check for user selection     (RSP.ifit)

BL=varargin(1);    BL=BL{1};
RSP=varargin(2);   RSP=RSP{1};

for ip=2:2
% compare response matrix with status
[BL(ip).avail,IA,IB]=intersect(RSP(ip).ibl,BL(ip).open);        %RSP.ibl and BL.open are compressed 
[C,IA]=setdiff(RSP(ip).ibl,RSP(ip).ibl(IA));                     %check for rejected response matrix BLs
if ~isempty(IA)
    disp('SortBLs Warning 1A: BLs in response matrix not open');
    for ii=IA
        disp(BL(ip).name(ii,:));
    end
end
% [C,IB]=setdiff(BL(ip).open,BL(ip).open(IB));                   %check for rejected OPEN BLs
% if ~isempty(IB)
%     disp('SortBLs Warning 1B: BLs with open beamline not in response matrix');
%     for ii=IB
%         disp(BL(ip).name(ii,:));
%     end
% end

% compare result with fit selection
[BL(ip).ifit,IA,IB]=intersect(BL(ip).avail,BL(ip).ifit);          %BL.avail and BL.ifit are compressed
% [C,IA]=setdiff(BL(ip).avail,BL(ip).avail(IA));                %check for rejected available BLs
% if ~isempty(IA)
%     disp('SortBLs Warning 2A: BLs with valid status and in response matrix not in fit');
%     for ii=IA
%         disp(BL(ip).name(ii,:));
%     end
% end
[C,IB]=setdiff(BL(ip).ifit,BL(ip).ifit(IB));                    %check for rejected fit BLs 
if ~isempty(IB) 
    disp('SortBLs Warning 2B: BLs in fit not do not have valid status or not in response matrix');
    for ii=IB
        disp(BL(ip).name(ii,:));
    end
end

end  %end of plane loop




% for ip=1:2
% [n,COR(ip).avail]=intland(COR(ip).status,RSP(ip).ic);  % compare response matrix with status
% 
% % check against fit vector
% [n,COR(ip).ifit]  =intland(COR(ip).avail,COR(ip).ifit);
% end

% % check response matrix against photon beam open
% for ip=1:2
%   [n,BL(ip).avail]=intland(BL(ip).open,RSP(ip).ibl);
% % check against fit vector
%   [n,BL(ip).ifit] =intland(BL(ip).avail,BL(ip).ifit);
% end

varargout{1}=BL;
