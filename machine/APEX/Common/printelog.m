function printelog(FigHandle, varargin)
%

% Author, Category, ScalingFlag

% -l Controls -a Author=Greg -a Type=Other -a Category="Hardware" -a Subject="Matlab Figure" "Print from Matlab worked!"');

 
if nargin < 1
    FigHandle = gcf;
end

% Defaults ???
Logbook = 'Operations';
Author = 'Guest';
Category = 'Other';
ScalingFlag = 1;
Subject = 'Matlab Figure';
DisplayFlag = 1;
TextString = 'Print from Matlab worked!';
NoFigFlag = 0;

for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor cells
    elseif iscell(varargin{i})
        % Ignor cells
    elseif ischar(varargin{i})
        if strcmpi(varargin{i},'Logbook')
            Logbook = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Author')
            Author = varargin{i};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Category')
            Category = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Subject')
            Subject = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Text')
            TextString = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'NoScaling')
            ScalingFlag = 0;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Scale')
            ScalingFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'NoDisplay')
            DisplayFlag = 0;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Display')
            DisplayFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'NoFig')
            NoFigFlag = 1;
            varargin(i) = [];
        end
    elseif isnumeric(varargin{i})
        if strcmpi(varargin{i},'Author')
            Author = varargin{i};
            varargin(i) = [];
        end
    end
end


if DisplayFlag
    % Input GUI
    [Logbook, Author, Category, Subject, TextString, ScalingFlag, CancelFlag] = printeloggui(Logbook, Author, Category, Subject, TextString, ScalingFlag);
    if strcmpi(CancelFlag, 'Cancel')
        return;
    end
end


% Temporary save directory
if ispc
    ImageDir = '\\Als-filer\apex\hlc\matlab\machine\APEX\Common\Old\';
else
    ImageDir = '/remote/apex/hlc/matlab/machine/APEX/Common/Old/';
end

FileName = 'MatlabFigure';


% jpeg will be the same size as what is on the screen
% This could be trouble, we might want to force the position width and height???

PaperPositionMode = get(FigHandle, 'PaperPositionMode');
InvertHardcopy    = get(FigHandle, 'InvertHardcopy');
Units             = get(FigHandle, 'Units');
Position          = get(FigHandle, 'Position');

set(FigHandle, 'PaperPositionMode', 'Auto');       %  'Auto' or 'Manual'
set(FigHandle, 'InvertHardcopy',    'Off');
if ScalingFlag
    set(FigHandle, 'Units', 'Inches');
    PosInches = get(FigHandle, 'Position');
    set(FigHandle, 'Position', [PosInches(1:2) 7.5 6]);
end

try
    %print -f1 -djpeg90 /remote/apex/hlc/matlab/machine/APEX/Common/Old/matlabtmpprint
    %print -f1 -dpng /remote/apex/hlc/matlab/machine/APEX/Common/Old/matlabtmpprint
    
    saveas(FigHandle, [ImageDir, FileName], 'fig');
    print(FigHandle, '-dpng', '-r90', [ImageDir, FileName]);  % . png
    %print(FigHandle, '-djpeg', [ImageDir, FileName]);        % .jpg
    
    %print(FigHandle, '-dpng', '-r0', [ImageDir, FileName] );
    %print(FigHandle, '-djpeg','-loose', '-r0', [ImageDir, FileName] );
    %print(FigHandle, '-djpeg', '-r300', '-loose',[ImageDir, FileName] );
    %print(FigHandle, '-djpeg', [ImageDir, FileName] );
    %saveas(FigHandle,[ImageDir, FileName], 'png');
catch ME
    fprintf('\nError writing to %s %s \n\n', ImageDir , ME.message);
end

    

% Books: Controls

% Save image and .fig files
%unix('/remote/apex/software/elog/2.9.0/bin/elog -f /remote/apex/hlc/matlab/machine/APEX/Common/Old/MatlabFigure.png -f /remote/apex/hlc/matlab/machine/APEX/Common/Old/MatlabFigure.fig -h apex4.als -l testbench -a Author=Portmann -a Type=ddd -a Category="Catagory C" -a Subject="Matlab Test" "Print from Matlab worked!"');

File1 = '/remote/apex/hlc/matlab/machine/APEX/Common/Old/MatlabFigure.png';
File2 = '/remote/apex/hlc/matlab/machine/APEX/Common/Old/MatlabFigure.fig';

if NoFigFlag == 1
    CommandString = sprintf('/remote/apex/software/elog/2.9.0/bin/elog -f "%s" -h apex4.als -l "%s" -a Author="%s" -a Type=Other -a Category="%s" -a Subject="%s" "%s"', File1, Logbook, Author, Category, Subject, TextString);
else
    CommandString = sprintf('/remote/apex/software/elog/2.9.0/bin/elog -f "%s" -f %s -h apex4.als -l "%s" -a Author="%s" -a Type=Other -a Category="%s" -a Subject="%s" "%s"', File1, File2, Logbook, Author, Category, Subject, TextString);
end
unix(CommandString);

set(FigHandle, 'PaperPositionMode', PaperPositionMode);
set(FigHandle, 'InvertHardcopy', InvertHardcopy);

if ScalingFlag
    set(FigHandle, 'Units', Units);
    set(FigHandle, 'Position', Position);
end
