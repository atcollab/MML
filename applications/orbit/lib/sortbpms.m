function varargout=SortBPMss(varargin)
% SortBPMss compares vectors for:
%(1) available electronically (BPM.status)
%(2) available in reference orbit (BPM.iref)
%(3) available in response matrix (RSP.ib)
%*** BPM.avail requires reference, response matrix, status

BPM=varargin{1};
RSP=varargin{2}; 

% [C,IA,IB] = INTERSECT(A,B) returns index vectors IA and IB
% such that C = A(IA) and C = B(IB)
% [C,I] = SETDIFF(...) returns an index vector I such that C = A(I)

for ip=1:2
% compare status with reference orbit
[BPM(ip).avail,IA,IB]=intersect(BPM(ip).iref,BPM(ip).status);     %BPM.iref and BPM.status are compressed
[C,IA]=setdiff(BPM(ip).iref,BPM(ip).iref(IA));                    %check for rejected reference BPMs
if ~isempty(IA)
    %disp('SortBPMs Warning 1A: BPMs in reference orbit do not have valid status');
    for ii=IA
        %disp(BPM(ip).name(ii,:));
    end
end
% [C,IB]=setdiff(BPM(ip).status,BPM(ip).status(IB));              %check for rejected status BPMs
% if ~isempty(IB)
%     disp('SortBPMs Warning 1B: BPMs with valid status not in reference orbit');
%     for ii=IB
%         disp(BPM(ip).name(ii,:));
%     end
% end

% compare result with response matrix
[BPM(ip).avail,IA,IB]=intersect(BPM(ip).avail,RSP(ip).ib);     %BPM.avail and RSP.ib are compressed
[C,IA]=setdiff(BPM(ip).avail,BPM(ip).avail(IA));                  %check for rejected available BPMs
if ~isempty(IA)
    %disp('SortBPMs Warning 2A: BPMs with valid status and in reference orbit not in response matrix');
    for ii=IA
        %disp(BPM(ip).name(ii,:));
    end
end
% [C,IB]=setdiff(RSP(ip).ib,RSP(ip).ib(IB));                      %check for rejected response matrix BPMs
% if ~isempty(IB)
%     disp('SortBPMs Warning 2B: BPMs in response matrix do not have valid status or not in reference orbit');
%     for ii=IB
%         disp(BPM(ip).name(ii,:));
%     end
% end

% compare result with fit selection
[BPM(ip).ifit,IA,IB]=intersect(BPM(ip).avail,BPM(ip).ifit);     %BPM.avail and BPM.ifit are compressed
[C,IA]=setdiff(BPM(ip).avail,BPM(ip).avail(IA));                %check for rejected available BPMs
% if ~isempty(IA)
%     disp('SortBPMs Warning 3A: BPMs with valid status, in reference orbit, and in response matrix not in fit');
%     for ii=IA
%         disp(BPM(ip).name(ii,:));
%     end
% end
%%%[C,IB]=setdiff(BPM(ip).ifit,BPM(ip).ifit(IB));                   %check for rejected fit BPMs
if ~isempty(IB)
    %disp('SortBPMs Warning 3B: BPMs in fit not do not have valid status, in reference orbit, or not in response matrix');
    for ii=IB
        %%%disp(BPM(ip).name(ii,:));
    end
end




end  %end of plane loop

% for ip=1:2
% [navail,BPM(ip).avail]=intland(BPM(ip).status,BPM(ip).iref);  % compare status matrix with reference orbit
% [navail,BPM(ip).avail]=intland(BPM(ip).avail,RSP(ip).ib);     % compare with response matrix
% [nfit,BPM(ip).ifit]   =intland(BPM(ip).avail,BPM(ip).ifit);   % compare with fit selection
% end

varargout{1}=BPM;


function t=testsort


family='BPMx';
[index,AO]=isfamily(family);
name=family2common(AO);   
status=[1 2 3 4 5]';
avail =[1 2 3 4 5]';
ifit  =[1 2 3 4 5]';
iref  =[1 2 3 4 5]';
irsp  =[1 2 3 4 5]';

t.name=name;
t.status=status;
t.avail=avail;
t.ifit=ifit;
t.iref=iref;

BPM(1)=t;
BPM(2)=t;

RSP(1).ib=irsp;
RSP(2).ib=irsp;
RSP(2).ic=irsp;
RSP(2).ic=irsp;

BPM=SortBPMs(BPM,RSP);

t=BPM(1);
disp('status')
t.status
disp('avail')
t.avail
disp('ifit')
t.ifit
disp('iref')
t.iref
disp('irsp')
RSP(1).ib

