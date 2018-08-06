function [OCS, OCS0] = bumpinj(varargin)
%BUMPINJ - Creates a horizontal "trapizodal" bump in sector 1
%  [OCS, OCS0] = bumpinj(DeltaX, BumpFlag)
%
%  DeltaX   - Magnitude of the bump in BPM(12,9) and BPM(1,2)
%  BumpFlag - if scalar 
%                0 -> short injection bump {Default}
%                else long bump
%             if vector, same as CMIncrementList input in setorbitbump
%  All string inputs will be passed to setorbitbump (eg. 'Display', 'FitRF')
%
%  Short bump
%  Corrector magnets used:  [12 6;
%                            12 7;
%                             1 2;
%                             1 3;
%
%  Long bump
%  Corrector magnets used:  [11 8;
%                            12 7;
%                             1 2;
%                             2 1;
%
%  See also setorbitbump

%  Written by Greg Portmann


BumpFlagDefault = 0;
InputFlags = {};
for i = length(varargin):-1:1
    if ischar(varargin{i})
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    end
end


DeltaX = [];
if length(varargin) >= 1
    if isnumeric(varargin{1})
        DeltaX = varargin{1};
        varargin(1) = [];
    end
end
if isempty(DeltaX)
    %DeltaX = input('  Horizontal injection bump size (scalar or [2 element vector]) [mm]? ');
    answer = inputdlg({'Enter the size of the bump injection bump [BPM(12,9) BPM(1,2)] [mm]'}, 'BUMPINJ', 1, {sprintf('[%d:%d]', -1, -1)});
    if ~isempty(answer)
        DeltaX = str2num(answer{1});
    else
        error('Bump size input error.');
    end
end
if DeltaX == 0
    disp('  Bump size is zero, hence no bump added.');
    return
end
if DeltaX > 0
    if menu('Are you sure you want a positive bump?','Yes','Exit') == 2
        disp('   No bump added.');
        return
    end
end

% Get BumpFlag input
BumpFlag = BumpFlagDefault;
if length(varargin) >= 1
    if isnumeric(varargin{1})
        BumpFlag = varargin{1};
        varargin(1) = [];
    end
end
if isempty(BumpFlag)
   BumpFlag = BumpFlagDefault;
end


if length(BumpFlag) > 1
    CMIncrementList = BumpFlag;
elseif BumpFlag
    % 'long' injection bump
    %       11 8;
    %       12 7;
    %       1 2;
    %       2 1;
    CMIncrementList = [-8 -1 1 8];
else
    % 'short' injection bump
    %       12 6;
    %       12 7;
    %       1 2;
    %       1 3;
    CMIncrementList = [-2 -1 1 2];
end
%              11 7;
%              12 1;
%              12 7;
%               1 2;
%               1 8;
%               2 2;


NIter = 5;

if length(DeltaX) == 1
    DeltaX = [DeltaX; DeltaX];
end
DeltaX = DeltaX(:);


% Extra flags, like 'FitRF', 'Display'
[OCS, OCS0, V, S, ErrorFlag] = setorbitbump('BPMx', [12 9; 1 2;], DeltaX, 'HCM', CMIncrementList, NIter, InputFlags{:});
disp('   Injection bump added.');

