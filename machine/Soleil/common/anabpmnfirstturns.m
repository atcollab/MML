function varargout = anabpmnfirstturns(bpmdevlist,varargin)
% ANABPMFIRSTTURN - get n first turns on a list of BPMs
%
%  INPUTS
%  1. DeviceList - bpm number (scalar or vector) list
%     Element List
%  2. Number of turns {1 by default}
%  3. Number of the first turn {12 by Default}
%
%  Optional input arguments
%  2. Optional display
%     'Display'   - Plot the bpmdata {Default if no outputs exist}
%     'NoDisplay' - Bpmdata will not be plotted {Default if outputs exist}
%  3. 'MaxSum'    - First turn is where sum signal is maximum
%  4. 'Struct'    - Return out as a structure
%  5. 'File'      - Get from File (interactive)
%
%  OUTPUTS
%  structure output if 'Struct' precised
%  AM
%
%  vector output
%  1. X - Horizontal data
%  2. Z - Vertical data
%  3. Sum - Sum signal data
%  4. Index of maximum sum
%
%  EXAMPLES
%  1. anabpmfirstturn([1 1]);
%  2. anabpmfirstturn([1; 2; 3]);
%  3. all BPMs and store orbit H et V orbit in X and Z
%     [X, Z] = anabpmfirstturn([],'NoDisplay');
%
% See Also getbpmrawdata

%
% Written by Laurent S. Nadolski

% TODO: relecture d'un fichier
% Choix du nombre de tours ....


MaxSumFlag = 1; % Research of first turn using sum signal
FileFlag = 0;   % Get data from a file
ishift = 0;     % Relative turn aroud first turn
ifirstturn = 7;% index of first turn: used if MaxSumFlag = 0;
varargin2 = {};
DisplayFlag = 0;
DisplayFlag2 = 1;
NumberOfTurns = 1;
FileName = '';

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin2 = [varargin2{:} varargin{i}];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin2 = [varargin2{:} varargin{i}];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display2')
        DisplayFlag2 = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay2')
        DisplayFlag2 = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'MaxSum')
        MaxSumFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoMaxSum')
        MaxSumFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'File')
        FileFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoArchive')
        ArchiveFlag = 0;
        varargin2 = [varargin2 varargin{i}];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Struct')
        StructureFlag = 1;
        varargin2 = [varargin2 varargin{i}];
        varargin(i) = [];
    end
end

if ~iscell(varargin2)
    varargin2 = {varargin2};
end

[tmp Found] = findkeyword(varargin2,'NoDisplay');

if ~Found & (DisplayFlag == 0)
    varargin2 = [varargin2 'NoDisplay'];
end

if length(varargin) > 0
    NumberOfTurns = varargin{1};
    if length(varargin) > 1
            ifirstturn = varargin{2};
    end
end

if isempty(bpmdevlist)
    switch getsubmachinename
        case 'Booster'
            xpos = 1:22;
        case 'StorageRing'
            xpos = 1:120;
    end
else
    xpos = 1:size(bpmdevlist,1);
end

%exemple pour definir le meme tour partout
ifirstturn = ones(size(xpos))*ifirstturn;
%ifirstturn([10 123 4]) = 11;

% Get File by asking users
if FileFlag
    DirectoryName = getfamilydata('Directory','BPMData');
    Filename     = uigetfile(DirectoryName);
    if  isequal(FileName,0)
       disp('User pressed cancel')
       return;
    else
        a = load(fullfile(DirectoryName, Filename));
        AM = getfield(a, 'AM');
        bpmdevlist = dev2elem('BPMx',AM.DeviceList);
    end
    
else % Online data    
    AM = getbpmrawdata(bpmdevlist,'Struct',varargin2{:});
end

if MaxSumFlag % Maxium signal on sum signal
    [dummy idx] = max(AM.Data.Sum');
    disp('Maximum peak')
    if DisplayFlag
        idx
    end
else % Manual selection of the first turn index
    idx = ifirstturn;
end

idx2 = sub2ind(size(AM.Data.Sum), xpos, idx+ishift);

len = length(idx); % number of BPM

if NumberOfTurns > 1
    idx2 = repmat(idx2,NumberOfTurns,1) + repmat((0:NumberOfTurns-1)*len,len,1)';
end

if DisplayFlag2
    figure(101)    
    posvect = getspos('BPMx',AM.DeviceList);
    posvect = repmat(posvect', NumberOfTurns, 1);

    h4 = subplot(9,1,[1 3]);
    plot(posvect', AM.Data.Sum(idx2)','.-');
    grid on
    xlabel('s(m)')
    ylabel('Sum (a.u.)')
    title('First turn orbit')

    h1 = subplot(10,1,[4 6]);
    plot(posvect', AM.Data.X(idx2)','.-');
    grid on
    xlabel('s(m)')
    ylabel('X(mm)')
    yaxis([-8 8]);
    title('First turn orbit')

    h2 = subplot(10,1,7);
    drawlattice;

    h3  = subplot(10,1,[8 10]);
    plot(posvect', AM.Data.Z(idx2)','.-');
    grid on
    xlabel('s(m)')
    ylabel('Z(mm)')
    yaxis([-5 5]);

    linkaxes([h1,h2,h3,h4],'x');
    %xaxis([0 60]);

    addlabel(1,0,datestr(AM.TimeStamp,21));
end

% varargout{1} = reshape(AM.Data.X(idx2),len,NumberOfTurns)';
% varargout{2} = reshape(AM.Data.Z(idx2),len,NumberOfTurns)';
% varargout{3} = reshape(AM.Data.Sum(idx2),len,NumberOfTurns)';
varargout{1} = AM.Data.X(idx2);
varargout{2} = AM.Data.Z(idx2);
varargout{3} = AM.Data.Sum(idx2);
varargout{4} = idx;
