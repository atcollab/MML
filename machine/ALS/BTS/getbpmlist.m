function [DeviceList, Index] = getbpmlist(varargin)
%GETBPMLIST - Return a BPM list based on key words and sector numbers 
%  [DeviceList, Index] = getbpmlist(KeyWord1, KeyWord2, ...)
%
%  INPUTS
%  1. KeyWord - 'All' {Default}
%
%     Note: 1. Devices can be selected by a number string
%              For example, '2 3 8 9' selects all devices numbered 2,3,8,9 
%     Note: 2. Sector can be selected by a vector 
%              For example, sectors 2, 10, 12 can be selected with input [2 10 12] 
%              The default is all sectors, 1:12.
%
%  OUTPUTS
%  1. DeviceList
%  2. Index - Index relative to the entire list (family2dev(Family, 0))
%
%  See also family2dev getcmlist
%
%  Written by Greg Portmann


for i = length(varargin):-1:1
    % Horizontal and vertical are the same
    if strcmpi(varargin{i},'Horizontal') | strcmpi(varargin{i},'x') | strcmpi(varargin{i},'BPMx')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Vertical') | strcmpi(varargin{i},'y') | strcmpi(varargin{i},'BPMy')
        varargin(i) = [];
    end
end


if length(varargin) == 0
    varargin = {'All'};
end

Family = 'BPMx';

%  Sector Dev   ARC  Bergoz
Table = [
     1     1     0     0     1     1     1     1     1
     1     2     0     0     1     1     1     1     1
     1     3     0     0     1     1     1     1     1
     1     4     0     0     1     1     1     1     1
     1     5     0     0     1     1     1     1     1
     1     6     0     0     1     1     1     1     1
    ];


List = ones(size(Table,1),1);
for i = 1:length(varargin)
    if isnumeric(varargin{i})
        % Sector
        Sector = varargin{i};
        Marker = zeros(size(Table,1),1);
        for j = 1:length(Sector)
            Marker = Marker | (Table(:,1)==Sector(j));
        end
        List = List & Marker;
    elseif strcmpi(varargin{i}, 'all')
        % All good status BPMs
        %StatusFlag = family2status(Family);
        %List = List & StatusFlag;
    elseif strcmpi(varargin{i}, 'arc')
        List = List & Table(:,3);
    elseif any(strcmpi(varargin{i}, {'straight','straightsection','straight section'}))
        List = List & ~Table(:,3);
    elseif any(strcmpi(varargin{i}, {'bergoz','bbpm'}))
        List = List & Table(:,4);
    elseif any(strcmpi(varargin{i}, {'nonbergoz','hinkson'}))
        List = List & ~Table(:,4);
    elseif strcmpi(varargin{i}, '2 3 5BSC 6BSC 8 9')
        %         1 2 3 4 5 6 7 8 9 0 1 2
        Mask   = [0 1 1 0 0 0 0 1 1 0 0 0]';
        MaskSB = [0 1 1 0 1 1 0 1 1 0 0 0]';
        Mask = [Mask;Mask;Mask;MaskSB;Mask;Mask;Mask;MaskSB;Mask;Mask;Mask;MaskSB;];
        List = List & Mask;
    elseif strcmpi(varargin{i}, '2 3 4 5BSC 6BSC 7 8 9')
        %         1 2 3 4 5 6 7 8 9 0 1 2
        Mask   = [0 1 1 1 0 0 1 1 1 0 0 0]';
        MaskSB = [0 1 1 1 1 1 1 1 1 0 0 0]';
        Mask = [Mask;Mask;Mask;MaskSB;Mask;Mask;Mask;MaskSB;Mask;Mask;Mask;MaskSB;];
        List = List & Mask;
    elseif isnumeric(str2num(varargin{i}))
        % Numeric Keyword - DeviceList
        %       1 2 3 4 5 6 7 8 9 0 1 2
        Mask = [0 0 0 0 0 0 0 0 0 0 0 0]';
        MaskNumber = str2num(varargin{i});
        Mask(MaskNumber) = 1;
        Mask = [Mask;Mask;Mask;Mask;Mask;Mask;Mask;Mask;Mask;Mask;Mask;Mask;];
        List = List & Mask;
    else
        error('Input not a known BPM list type');
    end
end


% Check middle layer status for what BPM are available
DeviceList = family2dev(Family);
%StatusFlag = family2status(Family);
IndexDeviceList = findrowindex(DeviceList, Table(:,1:2));
%List = List(IndexTotal) & StatusFlag;
List = List(IndexDeviceList);


% List w.r.t. the middle layer device list
Index = find(List);
DeviceList = DeviceList(Index, 1:2);

