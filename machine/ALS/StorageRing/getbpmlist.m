function [DeviceList, Index] = getbpmlist(varargin)
%GETBPMLIST - Return a BPM list based on key words and sector numbers 
%  [DeviceList, Index] = getbpmlist(KeyWord1, KeyWord2, ...)
%
%  INPUTS
%  1. KeyWord - 'Status'       -> Return only good status BPMs {Default}
%               'IgnoreStatus' -> Ignore the MML status when selecting the list
%
%               'Arc' or 'Straight'    -> BPM is in the arc chamber or straight section?
%
%               'Bergoz', 'nonBergoz'  -> Bergoz electronics
%               'OldBergoz'            -> Bergoz electronics before May 15, 2007
%
%               'Libera'
%               'UserDisplay'  -> BPMs to remove for user displays
%
%               'Horizontal Offset', 'HOffset', 'XOffset' -> Horizontal offset orbit was measured at these BPM
%               'Vertical Offset',   'VOffset', 'YOffset' -> Vertical   offset orbit was measured at these BPM
%
%               'No Horizontal Offset', 'NoHOffset', 'NoXOffset' -> No Horizontal offset orbit these BPM
%               'No Vertical Offset',   'NoVOffset', 'NoYOffset' -> No Vertical   offset orbit these BPM
% 
%               'Button'  -> Button exists
%
%     Note: 1. Devices can be selected by a number string
%              For example, '2 3 8 9' selects all device list 2nd column with number 2,3,8,9 
%     Note: 2. Sector can be selected by a vector 
%              For example, sectors 2, 10, 12 can be selected with input [2 10 12] 
%              The default is all sectors, 1:12.
%
%  OUTPUTS
%  1. DeviceList
%  2. Index - Index relative to the entire list (family2dev(Family, 0))
%
%  See also family2dev, getcmlist

%  Written by Greg Portmann


StatusFlag = 1;

RemoveBPMDeviceList = [];

for i = length(varargin):-1:1
    % Horizontal and vertical are the same
    if strcmpi(varargin{i},'Horizontal') || strcmpi(varargin{i},'x') || strcmpi(varargin{i},'BPMx')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Vertical') || strcmpi(varargin{i},'y') || strcmpi(varargin{i},'BPMy')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'IgnoreStatus')
        StatusFlag = 0;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'All','Status'}))
        StatusFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'UserDisplay') || strcmpi(varargin{i},'User Display')
        % BPMs to remove from displays that the users may see, like graphit_bpm
        RemoveBPMDeviceList = [6 5;11 7];
        varargin(i) = [];
    end
end


if isempty(varargin)
    varargin = {'All'};
end

Family = 'BPMx';

%                           QMS Offset  Old        Button
%  Sector Dev   ARC  Bergoz  x     y   Bergoz Libera
Table = [
     1     1     0     0     0     0     1     0     0  % No button
     1     2     1     1     1     1     1     0     1
     1     3     1     0     1     1     0     0     1
     1     4     1     1     0     1     0     0     1
     1     5     1     1     0     0     1     0     1  % NSLS-II Testing
     1     6     1     1     0     0     1     0     1  % Removed 2011-08-01;  Added back to y offset (2009-10-01); Partially broken input
     1     7     1     0     0     0     0     0     1
     1     8     1     0     1     1     0     0     1
     1     9     1     0     1     1     0     0     1
     1    10     0     1     0     0     1     0     1
     1    11     0     0     0     0     1     0     0  % No button
     1    12     0     0     0     0     1     0     0  % No button
     2     1     0     1     0     0     1     0     1
     2     2     1     0     1     1     0     0     1
     2     3     1     0     1     1     0     0     1
     2     4     1     1     0     1     0     0     1
     2     5     1     1     0     0     1     0     1
     2     6     1     1     0     0     1     0     1
     2     7     1     1     0     1     0     0     1
     2     8     1     0     1     1     0     0     1
     2     9     1     1     1     1     1     0     1
     2    10     0     0     0     0     1     0     0  % No button
     2    11     0     0     0     0     1     0     0  % No button
     2    12     0     0     0     0     1     0     0  % No button
     3     1     0     0     0     0     1     0     0  % No button
     3     2     1     1     1     1     1     0     1
     3     3     1     0     1     1     0     0     1  % Was broken for offset (fixed 10/2014)
     3     4     1     1     0     1     0     0     1
     3     5     1     1     0     0     1     1     1
     3     6     1     1     0     0     1     0     1
     3     7     1     1     0     1     0     0     1
     3     8     1     0     1     1     0     0     1
     3     9     1     0     1     1     0     0     1
     3    10     0     1     0     0     1     0     1
     3    11     0     1     0     0     1     0     1
     3    12     0     1     0     0     1     0     1
     4     1     0     1     0     0     1     0     1
     4     2     1     0     0     0     0     0     1  % Broken for offset (low channel C)
     4     3     1     0     1     1     0     0     1
     4     4     1     1     0     1     0     0     1
     4     5     1     1     1     1     1     0     1
     4     6     1     1     1     1     1     0     1
     4     7     1     1     0     1     0     0     1
     4     8     1     0     1     1     0     0     1
     4     9     1     0     1     1     0     0     1
     4    10     0     1     0     0     1     0     1
     4    11     0     0     0     0     1     0     0  % No button
     4    12     0     0     0     0     1     0     0  % No button
     5     1     0     1     0     0     1     0     1
     5     2     1     0     1     1     0     0     1
     5     3     1     0     1     1     0     0     1
     5     4     1     1     0     1     0     0     1
     5     5     1     1     0     0     1     0     1
     5     6     1     1     0     0     1     0     1
     5     7     1     1     0     1     0     0     1
     5     8     1     0     1     1     0     0     1
     5     9     1     0     1     1     0     0     1
     5    10     0     1     0     0     1     0     1
     5    11     0     1     0     0     1     0     1
     5    12     0     1     0     0     1     0     1
     6     1     0     1     0     0     1     0     1
     6     2     1     0     1     1     0     0     1
     6     3     1     0     1     1     0     0     1
     6     4     1     1     0     1     0     0     1
     6     5     1     1     0     0     1     1     1
     6     6     1     1     0     0     1     0     1
     6     7     1     1     0     1     0     0     1
     6     8     1     0     1     1     0     0     1
     6     9     1     0     1     1     0     0     1
     6    10     0     1     0     0     1     0     1
     6    11     0     1     0     0     1     0     1
     6    12     0     1     0     0     1     0     1
     7     1     0     1     0     0     1     0     1
     7     2     1     0     1     1     0     0     1
     7     3     1     0     1     1     0     0     1
     7     4     1     1     0     1     0     0     1
     7     5     1     1     0     0     1     0     1
     7     6     1     1     0     0     1     0     1
     7     7     1     1     0     1     0     0     1
     7     8     1     0     1     1     0     0     1
     7     9     1     0     1     1     0     0     1
     7    10     0     1     0     0     1     0     1
     7    11     0     0     0     0     1     0     0  % No button
     7    12     0     0     0     0     1     0     0  % No button
     8     1     0     1     0     0     1     0     1
     8     2     1     0     1     1     0     0     1
     8     3     1     0     1     1     0     0     1
     8     4     1     1     0     1     0     0     1
     8     5     1     1     1     1     1     0     1
     8     6     1     1     1     1     1     0     1
     8     7     1     1     0     1     0     0     1
     8     8     1     0     1     1     0     0     1
     8     9     1     0     1     1     0     0     1
     8    10     0     1     0     0     1     0     1
     8    11     0     0     0     0     1     0     0  % No button
     8    12     0     0     0     0     1     0     0  % No button
     9     1     0     1     0     0     1     0     1
     9     2     1     0     1     1     0     0     1
     9     3     1     0     1     1     0     0     1
     9     4     1     1     0     1     0     0     1
     9     5     1     1     0     0     1     1     1
     9     6     1     1     0     0     1     0     1
     9     7     1     1     0     1     0     0     1
     9     8     1     0     1     1     0     0     1  % Was broken for offset (fixed 10/2014)
     9     9     1     0     1     1     0     0     1
     9    10     0     1     0     0     1     0     1
     9    11     0     0     0     0     1     0     0  % No button
     9    12     0     0     0     0     1     0     0  % No button
    10     1     0     1     0     0     1     0     1
    10     2     1     0     1     1     0     0     1
    10     3     1     0     1     1     0     0     1
    10     4     1     1     0     1     0     0     1
    10     5     1     1     0     0     1     0     1
    10     6     1     1     0     0     1     0     1
    10     7     1     1     0     1     0     0     1
    10     8     1     0     1     1     0     0     1
    10     9     1     0     1     1     0     0     1
    10    10     0     1     0     0     1     0     1
    10    11     0     1     0     0     1     0     1
    10    12     0     1     0     0     1     0     1
    11     1     0     1     0     0     1     0     1
    11     2     1     0     1     1     0     0     1
    11     3     1     0     1     1     0     0     1
    11     4     1     1     0     1     0     0     1
    11     5     1     1     0     0     1     0     1
    11     6     1     1     0     0     1     0     1
    11     7     1     1     0     1     0     0     1
    11     8     1     0     1     1     0     0     1
    11     9     1     0     1     1     0     0     1
    11    10     0     1     0     0     1     0     1
    11    11     0     0     0     0     1     0     0  % No button
    11    12     0     0     0     0     1     0     0  % No button
    12     1     0     1     0     0     1     0     1
    12     2     1     0     1     1     0     0     1
    12     3     1     0     1     1     0     0     1
    12     4     1     1     0     1     0     0     1
    12     5     1     1     1     1     1     1     1
    12     6     1     1     1     1     1     0     1
    12     7     1     1     0     1     0     0     1
    12     8     1     0     1     1     0     0     1
    12     9     1     1     1     1     1     0     1
    12    10     0     0     0     0     1     0     0  % No button
    12    11     0     0     0     0     1     0     0  % No button
    12    12     0     0     0     0     1     0     0  % No button
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
    elseif any(strcmpi(varargin{i}, {'Straight','StraightSection','Straight Section'}))
        List = List & ~Table(:,3);
    elseif any(strcmpi(varargin{i}, {'Bergoz','bbpm'}))
        List = List & Table(:,4);
    elseif any(strcmpi(varargin{i}, {'OldBergoz','Old-Bergoz'}))
        List = List & Table(:,7);
    elseif any(strcmpi(varargin{i}, {'NotBergoz', 'nonBergoz','non-Bergoz','Hinkson'}))
        List = List & ~Table(:,4);
    elseif any(strcmpi(varargin{i}, {'libera'}))
        List = List & Table(:,8);
    elseif any(strcmpi(varargin{i}, {'Button'}))
        List = List & Table(:,9);
    elseif any(strcmpi(varargin{i}, {'No Button','NoButton'}))
        List = List & ~Table(:,9);
    elseif any(strcmpi(varargin{i}, {'XOffset','HOffset','Horizontal Offset'}))
        List = List & Table(:,5);
    elseif any(strcmpi(varargin{i}, {'YOffset','VOffset','Vertical Offset'}))
        List = List & Table(:,6);
    elseif any(strcmpi(varargin{i}, {'NoXOffset','NoHOffset','No Horizontal Offset'}))
        List = List & ~Table(:,5);
    elseif any(strcmpi(varargin{i}, {'NoYOffset','NoVOffset','No Vertical Offset'}))
        List = List & ~Table(:,6);
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
%StatusList = family2status(Family);
if StatusFlag == 1
    DeviceList = family2dev(Family);
else
    DeviceList = family2dev(Family, 0);    
end

IndexDeviceList = findrowindex(DeviceList, Table(:,1:2));
%List = List(IndexTotal) & StatusList;
List = List(IndexDeviceList);


% List w.r.t. the middle layer device list
Index = find(List);
DeviceList = DeviceList(Index, 1:2);


% BPMs to disable
if ~isempty(RemoveBPMDeviceList)
    i = findrowindex(RemoveBPMDeviceList, DeviceList);
    if ~isempty(i)
        DeviceList(i,:) = [];
    end
end

