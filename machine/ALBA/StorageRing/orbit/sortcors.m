function varargout = sortcors(varargin)
%SORTCORS - Compares vectors for several cases:
%(1) available electronically     (COR.status)
%(2) available in response matrix (RSP.ic)
%(3) check for user selection     (COR.ifit)
%
% INPUTS
% 1. Corrector structure
% 2. Response matrix structure
%
% OUTPUTS
% 1. Updated Corrector structure

% 
% Written by William J. Corbett
% Modified by Laurent S. Nadolski

COR = varargin{1}; 
RSP = varargin{2}; 

% [C,IA,IB] = INTERSECT(A,B) returns index vectors IA and IB
% such that C = A(IA) and C = B(IB)
% [C,I] = SETDIFF(...) returns an index vector I such that C = A(I)

for ip = 1:2 % for each plane
% compare response matrix with status
[COR(ip).avail,IA,IB] = intersect(RSP(ip).ic,COR(ip).status); %RSP.ic and COR.status are compressed 
[C,IA]                = setdiff(RSP(ip).ic,RSP(ip).ic(IA)); %check for rejected response matrix CORs
if ~isempty(IA)
    disp('SortCORs Warning 1A: CORs in response matrix do not have valid status');
    for ii = IA
        disp(COR(ip).name(ii,:));
    end
end

% compare result with fit selection
[COR(ip).ifit,IA,IB] = intersect(COR(ip).avail,COR(ip).ifit);  %COR.avail and COR.ifit are compressed
[C,IB]               = setdiff(COR(ip).ifit,COR(ip).ifit(IB)); %check for rejected fit CORs 
if ~isempty(IB) 
    disp('SortCORs Warning 2B: CORs in fit not do not have valid status or not in response matrix');
    for ii = IB
        disp(COR(ip).name(ii,:));
    end
end

end  %end of plane loop

varargout{1} = COR;
