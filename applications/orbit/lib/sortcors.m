function varargout=SortCORs(varargin)
% SortCORs compares vectors for:
%(1) available electronically     (COR.status)
%(2) available in response matrix (RSP.ic)
%(3) check for user selection     (COR.ifit)

COR=varargin(1);   COR=COR{1};
RSP=varargin(2);   RSP=RSP{1};

% [C,IA,IB] = INTERSECT(A,B) returns index vectors IA and IB
% such that C = A(IA) and C = B(IB)
% [C,I] = SETDIFF(...) returns an index vector I such that C = A(I)

for ip=1:2
% compare response matrix with status
[COR(ip).avail,IA,IB]=intersect(RSP(ip).ic,COR(ip).status);       %RSP.ic and COR.status are compressed 
[C,IA]=setdiff(RSP(ip).ic,RSP(ip).ic(IA));                        %check for rejected response matrix CORs
if ~isempty(IA)
    disp('SortCORs Warning 1A: CORs in response matrix do not have valid status');
    for ii=IA
        disp(COR(ip).name(ii,:));
    end
end
% [C,IB]=setdiff(COR(ip).status,COR(ip).status(IB));                %check for rejected STATUS CORs
% if ~isempty(IB)
%     disp('SortCORs Warning 1B: CORs with valid status not in response matrix');
%     for ii=IB
%         disp(COR(ip).name(ii,:));
%     end
% end

% compare result with fit selection
[COR(ip).ifit,IA,IB]=intersect(COR(ip).avail,COR(ip).ifit);       %COR.avail and COR.ifit are compressed
% [C,IA]=setdiff(COR(ip).avail,COR(ip).avail(IA));                %check for rejected available CORs
% if ~isempty(IA)
%     disp('SortCORs Warning 2A: CORs with valid status and in response matrix not in fit');
%     for ii=IA
%         disp(COR(ip).name(ii,:));
%     end
% end
[C,IB]=setdiff(COR(ip).ifit,COR(ip).ifit(IB));                    %check for rejected fit CORs 
if ~isempty(IB) 
    disp('SortCORs Warning 2B: CORs in fit not do not have valid status or not in response matrix');
    for ii=IB
        disp(COR(ip).name(ii,:));
    end
end

end  %end of plane loop

% for ip=1:2
% [n,COR(ip).avail]=intland(COR(ip).status,RSP(ip).ic);  % compare response matrix with status
% 
% % check against fit vector
% [n,COR(ip).ifit]  =intland(COR(ip).avail,COR(ip).ifit);
% end

varargout{1}=COR;
