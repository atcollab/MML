function varargout = anabpmfirstturn(bpmdevlist,varargin)
% ANABPMFIRSTTURN - Analyses first turn BPM
%
%  INPUTS
%  1. DeviceList - bpm number (scalar or vector) list
%  2. Element List
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
DisplayFlag = 1;

FileName = '';

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
ifirstturn = ones(size(xpos))*12;
%ifirstturn([10 123 4]) = 11;

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin2 = {varargin2{:} varargin{i}};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin2 = {varargin2{:} varargin{i}};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'MaxSum')
        MaxSumFlag = 1;
        ManualFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoMaxSum')
        MaxSumFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Manual')
        ManualFlag = 1;
        MaxSumFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoManual')
        ManualFlag = 0;
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

% Get File by asking users
if FileFlag
    DirectoryName = getfamilydata('Directory','BPMData');
    FileName     = uigetfile(DirectoryName);
    if  isequal(FileName,0)
       disp('User pressed cancel')
       return;
    else
        a = load(fullfile(DirectoryName, FileName));
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

if DisplayFlag
    figure(101)
    
    posvect = getspos('BPMx',AM.DeviceList);

    h1 = subplot(7,1,[1 3]);
    plot(posvect, AM.Data.X(idx2),'b.-');
    grid on
    xlabel('s(m)')
    ylabel('X(mm)')
    axis([0 getcircumference -20 20]);
    title('First turn orbit')

    h2 = subplot(7,1,4);
    drawlattice;

    h3  = subplot(7,1,[5 7]);
    plot(posvect, AM.Data.Z(idx2),'r.-');
    grid on
    xlabel('s(m)')
    ylabel('Z(mm)')
    axis([0 getcircumference -11 11]);

    linkaxes([h1,h2,h3],'x');

    addlabel(1,0,datestr(AM.TimeStamp,21));
end

varargout{1} = AM.Data.X(idx2);
varargout{2} = AM.Data.Z(idx2);
varargout{3} = AM.Data.Sum(idx2);
varargout{4} = idx;
