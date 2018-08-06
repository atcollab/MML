function devlist = getidbpmlist(varargin)
%GETIDPMLIST - Return devicelist of IDBPM
%
%  INPUTS
%  1. CellNumber (optional) - cell number or seet of cell
%
%  OUTPUTS
%  1. devlist - IDBPM devicelist 
%
%  EXAMPLES
%  1. getidpmlist(1) - for cell 1
%  2. getidpmlist([2 3]) - for cells 2 and 3

%
%  Written by Laurent S. Nadolski

CellNumber = -1;

if ~isempty(varargin)
    CellNumber = varargin{1};
end

IDBPM = [1 7 8 11 12 15 16 19 20 23 24 30 ]';
IDBPM = [IDBPM ;IDBPM+30 ;IDBPM+60 ; IDBPM+90];

devlist = elem2dev('BPMx',IDBPM);

if CellNumber ~= -1
    ind = [];
    for k = 1:length(CellNumber)
        ind = [ind; find(devlist(:,1) == CellNumber(k))];
    end
    devlist = devlist(ind,:);
end
% 1     1
% 1     2
% 2     1
% 2     2
% 2     5
% 2     6
% 3     1
% 3     2
% 3     5
% 3     6
% 4     1
% 4     2
% 5     1
% 5     2
% 6     1
% 6     2
% 6     5
% 6     6
% 7     1
% 7     2
% 7     5
% 7     6
% 8     1
% 8     2
% 9     1
% 9     2
% 10     1
% 10     2
% 10     5
% 10     6
% 11     1
% 11     2
% 11     5
% 11     6
% 12     1
% 12     2
% 13     1
% 13     2
% 14     1
% 14     2
% 14     5
% 14     6
% 15     1
% 15     2
% 15     5
% 15     6
% 16     1
% 16     2