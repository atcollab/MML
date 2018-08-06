function printelog(FigHandle, varargin)
%
% view logbook at phys1.als.lbl.gov:80

% Author, Category, ScalingFlag

% -l Controls -a Author=Greg -a Type=Other -a Category="Hardware" -a Subject="Matlab Figure" "Print from Matlab worked!"');


if nargin < 1
    if datenum(version('-date')) > datenum(2014,6,1)
        FigHandle = get(gcf, 'Number');
    else
        FigHandle = gcf;
    end
end

% Defaults ???
Logbook = 'Orbit';
Author = 'Gregory Portmann';
Category = 'BPM';
ScalingFlag = 1;
Subject = 'Matlab Figure';
DisplayFlag = 1;
TextString = 'Created with printelog from Matlab.';
NoFigFlag = 1;

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
        elseif strcmpi(varargin{i},'Fig')
            NoFigFlag = 0;
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
    [FigHandle, Logbook, Author, Category, Subject, TextString, ScalingFlag, CancelFlag] = printeloggui(FigHandle, Logbook, Author, Category, Subject, TextString, ScalingFlag);
    if strcmpi(CancelFlag, 'Cancel')
        return;
    end
end


% Temporary save directory
if ispc
    ImageDir = '\\Als-filer\als\physbase\machine\ALS\Common\Old\';
else
    [DirName, FileName]=fileparts(which('gotobase'));
    ImageDir = fullfile(DirName, 'Old', filesep);
   %ImageDir = '/home/als/physbase/machine/ALS/Common/Old/';
end

FileName = 'MatlabFigure';


% jpeg will be the same size as what is on the screen
% This could be trouble, we might want to force the position width and height???

AttachmentFiles = '';
for i = 1:length(FigHandle)
    PaperPositionMode = get(FigHandle(i), 'PaperPositionMode');
    InvertHardcopy    = get(FigHandle(i), 'InvertHardcopy');
    Units             = get(FigHandle(i), 'Units');
    Position          = get(FigHandle(i), 'Position');
    
    set(FigHandle(i), 'PaperPositionMode', 'Auto');       %  'Auto' or 'Manual'
    set(FigHandle(i), 'InvertHardcopy',    'Off');
    if ScalingFlag
        set(FigHandle(i), 'Units', 'Inches');
        PosInches = get(FigHandle(i), 'Position');
        set(FigHandle(i), 'Position', [PosInches(1:2) 8.5 5]);  % was [... 7.5 6]
    end
    
    try
        FileNames{i} = sprintf('%s%d', [ImageDir, FileName], i);
        
        %print -f1 -djpeg90 /home/als/physbase/machine/ALS/Common/Old/matlabtmpprint
        %print -f1 -dpng /home/als/physbase/machine/ALS/Common/Old/matlabtmpprint
        
        saveas(FigHandle(i), FileNames{i}, 'fig');
        print(FigHandle(i), '-dpng', '-r90', FileNames{i});  % . png
        %print(FigHandle(i), '-djpeg', FileNames{i});        % .jpg
        
        %print(FigHandle(i), '-dpng', '-r0', FileNames{i} );
        %print(FigHandle(i), '-djpeg','-loose', '-r0', FileNames{i} );
        %print(FigHandle(i), '-djpeg', '-r300', '-loose',FileNames{i} );
        %print(FigHandle(i), '-djpeg', FileNames{i} );
        %saveas(FigHandle(i),FileNames{i}, 'png');
    catch ME
        fprintf('\nError writing to %s %s \n\n', ImageDir , ME.message);
    end
    
    AttachmentFiles = [AttachmentFiles, '-f "', FileNames{i}, '.png" '];
    if ~NoFigFlag
        AttachmentFiles = [AttachmentFiles, '-f "', FileNames{i}, '.fig" '];
    end
end
if length(AttachmentFiles) > 1
    AttachmentFiles(end) = [];
end

% Save image and .fig files
%unix('/remote/apex/software/elog/elog-2-9-2/bin/elog -f /home/als/physbase/machine/ALS/Common/Old/MatlabFigure.png -f /home/als/physbase/machine/ALS/Common/Old/MatlabFigure.fig -h phys1.als -l testbench -a Author=Portmann -a Type=ddd -a Category="Catagory C" -a Subject="Matlab Test" "Print from Matlab worked!"');

% for i = 1:length(FigHandle)
%     File1 = '/home/als/physbase/machine/ALS/Common/Old/MatlabFigure.png';
%     File2 = '/home/als/physbase/machine/ALS/Common/Old/MatlabFigure.fig';
% end

%CommandString = sprintf('/home/als/alsbase/elog/elog-2.9.2/bin/elog %s -h phys1.als -l "%s" -a Author="%s" -a Type=Other -a Category="%s" -a Subject="%s" "%s"', AttachmentFiles, Logbook, Author, Category, Subject, TextString);
CommandString = sprintf('/home/als/alsbase/elog/elog-2.9.2/bin/elog %s -h phys1.als -p 80 -l "%s" -a Author="%s" -a Type=Other -a Category="%s" -a Subject="%s" "%s"', AttachmentFiles, Logbook, Author, Category, Subject, TextString);
unix(CommandString);


% Put things back the way they were
for i = 1:length(FigHandle)
    set(FigHandle(i), 'PaperPositionMode', PaperPositionMode);
    set(FigHandle(i), 'InvertHardcopy',    InvertHardcopy);
    
    if ScalingFlag
        set(FigHandle(i), 'Units',    Units);
        set(FigHandle(i), 'Position', Position);
    end
end

% Delete the tmp files?

