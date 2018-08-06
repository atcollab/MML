function [DeviceList, Index] = getcmlist(varargin)
%GETBPMLIST - Return a corrector magnet list based on key words and sector numbers 
%  [DeviceList, Index] = getbpmlist(KeyWord1, KeyWord2, ...)
%
%  INPUTS
%  1. KeyWord - 'Horizontal' {Default} or 'Vertical'
%               'Arc' or 'Straight'
%
%     Note: 1. Devices can be selected by a number string
%              For example, '2 3 8 9' selects all devices numbered 2,3,8,9 
%     Note: 1. Sector can be selected by a vector 
%              For example, sectors 2, 10, 12 can be selected with input [2 10 12] 
%              The default is all sectors, 1:12.
%
%  OUTPUTS
%  1. DeviceList
%  2. Index - Index relative to the entire list (family2dev(Family))
%
%  See also family2dev getbpmlist
%
%  Written by Greg Portmann


PlaneFlag = 0;
for i = length(varargin):-1:1
    if any(strcmpi(varargin{i}, {'Horizontal','x','h','HCM'}))
        PlaneFlag = 1;
        Family = 'HCM';
    elseif any(strcmpi(varargin{i}, {'Vertical','y','v','VCM'}))
        PlaneFlag = 1;
        Family = 'VCM';
    end
end

if ~PlaneFlag
    varargin = [varargin {'Horizontal'}];
    Family = 'HCM';
end

if length(varargin) == 0
    varargin = {'Horizontal'};
end


%  Sector Dev    H     V    ARC 
Table = [
     1     1     1     1     0     0     0
     1     2     1     1     0     0     0
     1     3     1     0     1     0     0
     1     4     1     1     1     0     0
     1     5     1     1     1     0     0
     1     6     1     0     1     0     0
     1     7     1     1     0     0     0
     1     8     1     1     0     0     0
     1     9     1     1     0     0     0
     1    10     1     1     0     0     0
     2     1     1     1     0     0     0
     2     2     1     1     0     0     0
     2     3     1     0     1     0     0
     2     4     1     1     1     0     0
     2     5     1     1     1     0     0
     2     6     1     0     1     0     0
     2     7     1     1     0     0     0
     2     8     1     1     0     0     0
     2     9     1     1     0     0     0
     2    10     1     1     0     0     0
     3     1     1     1     0     0     0
     3     2     1     1     0     0     0
     3     3     1     0     1     0     0
     3     4     1     1     1     0     0
     3     5     1     1     1     0     0
     3     6     1     0     1     0     0
     3     7     1     1     0     0     0
     3     8     1     1     0     0     0
     3     9     1     1     0     0     0
     3    10     1     1     0     0     0
     4     1     1     1     0     0     0
     4     2     1     1     0     0     0
     4     3     1     0     1     0     0
     4     4     1     1     1     0     0
     4     5     1     1     1     0     0
     4     6     1     0     1     0     0
     4     7     1     1     0     0     0
     4     8     1     1     0     0     0
     4     9     1     1     0     0     0
     4    10     1     1     0     0     0
     5     1     1     1     0     0     0
     5     2     1     1     0     0     0
     5     3     1     0     1     0     0
     5     4     1     1     1     0     0
     5     5     1     1     1     0     0
     5     6     1     0     1     0     0
     5     7     1     1     0     0     0
     5     8     1     1     0     0     0
     5     9     1     1     0     0     0
     5    10     1     1     0     0     0
     6     1     1     1     0     0     0
     6     2     1     1     0     0     0
     6     3     1     0     1     0     0
     6     4     1     1     1     0     0
     6     5     1     1     1     0     0
     6     6     1     0     1     0     0
     6     7     1     1     0     0     0
     6     8     1     1     0     0     0
     6     9     1     1     0     0     0
     6    10     1     1     0     0     0
     7     1     1     1     0     0     0
     7     2     1     1     0     0     0
     7     3     1     0     1     0     0
     7     4     1     1     1     0     0
     7     5     1     1     1     0     0
     7     6     1     0     1     0     0
     7     7     1     1     0     0     0
     7     8     1     1     0     0     0
     7     9     1     1     0     0     0
     7    10     1     1     0     0     0
     8     1     1     1     0     0     0
     8     2     1     1     0     0     0
     8     3     1     0     1     0     0
     8     4     1     1     1     0     0
     8     5     1     1     1     0     0
     8     6     1     0     1     0     0
     8     7     1     1     0     0     0
     8     8     1     1     0     0     0
     8     9     1     1     0     0     0
     8    10     1     1     0     0     0     
     9     1     1     1     0     0     0
     9     2     1     1     0     0     0
     9     3     1     0     1     0     0
     9     4     1     1     1     0     0
     9     5     1     1     1     0     0
     9     6     1     0     1     0     0
     9     7     1     1     0     0     0
     9     8     1     1     0     0     0
     9     9     1     1     0     0     0
     9    10     1     1     0     0     0
    10     1     1     1     0     0     0
    10     2     1     1     0     0     0
    10     3     1     0     1     0     0
    10     4     1     1     1     0     0
    10     5     1     1     1     0     0
    10     6     1     0     1     0     0
    10     7     1     1     0     0     0
    10     8     1     1     0     0     0
    10     9     1     1     0     0     0
    10    10     1     1     0     0     0
    11     1     1     1     0     0     0
    11     2     1     1     0     0     0
    11     3     1     0     1     0     0
    11     4     1     1     1     0     0
    11     5     1     1     1     0     0
    11     6     1     0     1     0     0
    11     7     1     1     0     0     0
    11     8     1     1     0     0     0
    11     9     1     1     0     0     0
    11    10     1     1     0     0     0
    12     1     1     1     0     0     0
    12     2     1     1     0     0     0
    12     3     1     0     1     0     0
    12     4     1     1     1     0     0
    12     5     1     1     1     0     0
    12     6     1     0     1     0     0
    12     7     1     1     0     0     0
    12     8     1     1     0     0     0
    12     9     1     1     0     0     0
    12    10     1     1     0     0     0
    ];


List = ones(size(Table,1),1);
for i = 1:length(varargin)
    if any(strcmpi(varargin{i}, {'Horizontal','x','h','HCM'}))
        Family = 'HCM';
        List = List & Table(:,3);    
    elseif any(strcmpi(varargin{i}, {'Vertical','y','v','VCM'}))
        Family = 'VCM';
        List = List & Table(:,4);    
    elseif isnumeric(varargin{i})
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
        List = List & Table(:,5);
    elseif any(strcmpi(varargin{i}, {'straight','straightsection','straight section'}))
        List = List & ~Table(:,5);
%     elseif strcmpi(varargin{i}, '1 2 5BSC 6BSC 7  8')
%         %         1 2 3 4 5 6 7 8 9 10
%         Mask   = [0 1 1 0 0 0 0 1 0  0]';
%         MaskSB = [0 1 1 0 1 1 0 1 0  0]';
%         Mask = [Mask;Mask;Mask;MaskSB;Mask;Mask;Mask;MaskSB;Mask;Mask;Mask;MaskSB;];
%         List = List & Mask;
    elseif isnumeric(str2num(varargin{i}))
        % Numeric Keyword - DeviceList
        %       1 2 3 4 5 6 7 8 9 10
        Mask = [0 0 0 0 0 0 0 0 0  0]';
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

