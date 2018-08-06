function [DeviceList, Index] = getcmlist(varargin)
%GETBPMLIST - Return a corrector magnet list based on key words and sector numbers 
%  [DeviceList, Index] = getbpmlist(KeyWord1, KeyWord2, ...)
%
%  INPUTS
%  1. KeyWord - 'Horizontal' {Default} or 'Vertical'
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
     1     3     1     1     0     0     0
     1     4     1     1     0     0     0
     1     5     1     1     0     0     0
     1     6     1     1     0     0     0
     1     7     1     1     0     0     0
     1     8     1     1     0     0     0
     1     9     1     1     0     0     0
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

