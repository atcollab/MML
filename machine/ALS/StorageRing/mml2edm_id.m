function  mml2edm_id(Directory)
%MML2EDM_ID - Insertion device control EDM application builder

DirStart = pwd;

if nargin < 1
    if ispc
        cd \\Als-filer\physbase\hlc\SR\ID
    else
        cd /home/als/physbase/hlc/SR/ID
    end
else
    cd(Directory);
end


% 8 10 12 14 18 24 72
FontSize = 18;   % 14 or 18

if FontSize == 14
    FontSizep1 = 18;
    FontSizem1 = 12;
    WidthRatio = 9;
elseif FontSize == 18
    FontSizep1 = 18;  %24;
    FontSizem1 = 14;
    WidthRatio = 12;  %10.5;
else
    error('FontSize unknown');
end


xBorder = 3;
yBorder = 4;   % was 3
yHeight = 20;
EyeAide = 'On';

WindowLocation = [600 60];


% Start the EDM text file
FileName = 'MML2EDM_ID.edl';
fid = fopen(FileName, 'w', 'b');

TitleBar = 'SR - Insertion Device Control';

Header = EDMHeader('FileName', fid, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'FontSize', FontSize);


% Main title
WriteEDMFile(fid, EDMStaticText('INSERTION DEVICE CONTROL', ceil(14*WidthRatio), 10, 'Width', 600, 'FontSize',24, 'FontWeight','bold', 'HorizontalAlignment','center'));
xStart = 7;
yStart = 40 + yBorder;


%%%%%%%%%%%%%%%%%
% Vertical Gaps %
%%%%%%%%%%%%%%%%%

CommonNames = family2common('ID');
CommonNames = deblank(mat2cell(CommonNames, ones(1,size(CommonNames,1)),size(CommonNames,2)));


WriteEDMFile(fid, EDMStaticText('Vertical Gaps', xStart, yStart, 'Width', 300, 'Height',25, 'FontSize', FontSizep1, 'FontWeight','bold', 'HorizontalAlignment','left'));
yStart = yStart + 30 + yBorder;


% First lay down the lines (or rectangles)
if strcmpi(EyeAide, 'On')
    Width = ceil(ceil(10*8*WidthRatio) + 65 + 2*30 + 13*xBorder + 70);
    
    x = xStart;
    y = yStart;
    y = y + 2*yHeight + yBorder;
    for i = 1:length(CommonNames)+1
        EDMLine([x x+Width], [y-round(yBorder/2) y-round(yBorder/2)], 'FileName', fid, 'Width', Width, 'Height', 0, 'LineWidth', 1, 'LineColor', 2, 'FillColor', 2);
        %if rem(i,2) == 1
        %    EDMRectangle(x, y, 'FileName', fid, 'Width', Width, 'Height', yHeight, 'LineWidth', 1, 'LineColor', 2, 'FillColor', 2);
        %end
        y = y + yHeight + yBorder;
    end
end


%%%%%%%%%%%%%%%%%%%%%%
% Common Name Column %
%%%%%%%%%%%%%%%%%%%%%%
x = xStart;
y = yStart;
WriteEDMFile(fid, EDMStaticText({'Device','Name'}, x+1, y, 'HorizontalAlignment', 'left', 'Width', ceil(7*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;
for i = 1:length(CommonNames)
    if ~isempty(CommonNames{i})
        WriteEDMFile(fid, EDMStaticText(CommonNames{i}, x, y, 'HorizontalAlignment', 'left', 'Width', ceil(7*WidthRatio), 'FontSize', FontSize));
    end
    y = y + yHeight + yBorder;
end
x = x + ceil(8*WidthRatio) + xBorder;


%%%%%%%%%%%%%%%
% Gap Monitor %
%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('ID', 'Monitor');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Gap AM';'[mm]'}, x, y, 'HorizontalAlignment', 'center', 'Width', ceil(7*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        %TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'Precision', 3, 'FontSize', FontSize);
        TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'HorizontalAlignment', 'right', 'Width', ceil(7*WidthRatio), 'Precision',3, 'FontSize', FontSize);
        WriteEDMFile(fid, TextMonitor);
    end
    y = y + yHeight + yBorder;
end
x = x + ceil(8*WidthRatio) + xBorder;


%%%%%%%%%%%%%%%%
% Gap Setpoint %
%%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('ID', 'Setpoint');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Gap SP';'[mm]'}, x, y, 'HorizontalAlignment', 'center', 'Width', ceil(7*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        TextControl = EDMTextControl(PVCell{i}, x, y, 'HorizontalAlignment','right', 'Width', ceil(7*WidthRatio), 'Precision',3, 'FontSize', FontSize);
        WriteEDMFile(fid, TextControl);
    end
    y = y + yHeight + yBorder;
end

% Shell command - Max Gap, Min Gap, Open, User Gap
FileNameMax = mml2caput({'ID','ID','ID','ID','EPU'}, {'GapEnableControl','VelocityControl','VelocityProfile','Setpoint','Setpoint'}, {0,'Max',0,'Max',0}, {[],[],[],[],[]}, 'ID_Setpoint_Max.sh', 0, .2);
FileNameMin = mml2caput({'ID','ID'}, {'GapEnableControl', 'Setpoint'}, {0,'Min'}, {[],[]}, 'ID_Setpoint_Min.sh', 0, .25);
% ID_Setpoint_Open.sh     % Edit this script by hand
% ID_Setpoint_UserGap.sh  % Comes from a Matlab save
%     sprintf('/home/als/physbase/hlc/SR/ID/%s',FileNameMax), ... 
%     sprintf('/home/als/physbase/hlc/SR/ID/ID_Setpoint_Open.sh'), ...
%     sprintf('/home/als/physbase/hlc/SR/ID/ID_Setpoint_UserGap.sh'), ...
%     sprintf('/home/als/physbase/hlc/SR/ID/%s',FileNameMin), ...
WriteEDMFile(fid, EDMShellCommand({ ...
    sprintf('sh %s',FileNameMax), ... 
    sprintf('sh ID_Setpoint_Open.sh'), ...
    sprintf('sh ID_Setpoint_UserGap.sh'), ...
    sprintf('sh %s',FileNameMin), ...
    }, x, y, 'ButtonLabel', 'ALL', ...
    'CommandLabel', {'Maximum gap', 'Open gap fill position', 'Last user gap save', 'Minimum gap'}));
x = x + ceil(8*WidthRatio) + xBorder;
y = y + yHeight + yBorder;
ymax = y;


%%%%%%%%%%%%%%%%%%%%%
% User Gap Setpoint %
%%%%%%%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('ID', 'UserGap');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'User Req.';'[mm]'}, x, y, 'HorizontalAlignment', 'center', 'Width', ceil(8*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        TextControl = EDMTextControl(PVCell{i}, x, y, 'HorizontalAlignment','right', 'Width', ceil(7*WidthRatio), 'Precision',3, 'FontSize', FontSize);
        WriteEDMFile(fid, TextControl);
    end
    y = y + yHeight + yBorder;
end

% Shell command - User Gap
%FileName = mml2caput('ID', 'UserGap', getpv('ID', 'UserGap'));
FileName = 'ID_UserGap.sh';     % Comes from a Matlab save 
WriteEDMFile(fid, EDMShellCommand({ ...
    %sprintf('sh /home/als/physbase/hlc/SR/ID/%s',FileName), ... 
    sprintf('sh %s',FileName), ... 
    ' ', ...
    }, x, y, 'ButtonLabel', 'ALL', ...
    'CommandLabel', {'Restore the last user gap save',' '}));
x = x + ceil(8*WidthRatio) + xBorder;
y = y + yHeight + yBorder;


%%%%%%%%%%%%%%%%%%%%
% Velocity Monitor %
%%%%%%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('ID', 'Velocity');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Vel AM';'[mm/sec]'}, x, y, 'HorizontalAlignment', 'center', 'Width', ceil(7*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        %TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'Precision', 3);
        TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'HorizontalAlignment','right', 'Width', ceil(7*WidthRatio), 'Precision',3, 'FontSize', FontSize);  % 55 for FontSize 14
        WriteEDMFile(fid, TextMonitor);
    end
    y = y + yHeight + yBorder;
end
x = x + ceil(8*WidthRatio) + xBorder;


%%%%%%%%%%%%%%%%%%%%%
% Velocity Setpoint %
%%%%%%%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('ID', 'VelocityControl');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Vel SP';'[mm/sec]'}, x, y, 'HorizontalAlignment','center', 'Width', ceil(7*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        TextControl = EDMTextControl(PVCell{i}, x, y, 'HorizontalAlignment','right', 'Width', ceil(7*WidthRatio), 'Precision',3, 'FontSize', FontSize);
        WriteEDMFile(fid, TextControl);
    end
    y = y + yHeight + yBorder;
end

% Shell command
FileNameMax = mml2caput('ID', 'VelocityControl', 'Max');
WriteEDMFile(fid, EDMShellCommand({ ...
    %sprintf('/home/als/physbase/hlc/SR/ID/%s',FileNameMax), ... 
    sprintf('%s',FileNameMax), ... 
    ' ', ...
    }, x, y, 'ButtonLabel', 'ALL', ...
    'CommandLabel', {'Maximum velocity',' '}));
x = x + ceil(8*WidthRatio) + xBorder;
y = y + yHeight + yBorder;


%%%%%%%%%%%%%%%%%%%%
% Velocity Profile %
%%%%%%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('ID', 'VelocityProfile');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Velocity';'Profile'}, x, y, 'HorizontalAlignment','center', 'Width', ceil(7*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        %WriteEDMFile(fid, EDMButton(PVCell{i}, x, y));
        WriteEDMFile(fid, EDMChoiceButton(PVCell{i}, x, y, 'Orientation','Horizontal', 'FontSize', FontSizem1));
    end
    y = y + yHeight + yBorder;
end

% Shell command
FileName = mml2caput('ID', 'VelocityProfile');
WriteEDMFile(fid, EDMShellCommand({ ...
    %sprintf('sh /home/als/physbase/hlc/SR/ID/%s 1',FileName), ... 
    %sprintf('sh /home/als/physbase/hlc/SR/ID/%s 0',FileName), ... 
    sprintf('sh %s 1',FileName), ... 
    sprintf('sh %s 0',FileName), ... 
    }, x, y, 'ButtonLabel', 'ALL', ...
    'CommandLabel', {'Velocity profile on', 'Velocity profile off'}));
x = x + ceil(8*WidthRatio) + xBorder;
y = y + yHeight + yBorder;


%%%%%%%%%%%
% RunFlag %
%%%%%%%%%%%
y = yStart;
BMWidth = 65;
PVCell = family2channel('ID', 'RunFlag'); 
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Run';'Flag'}, x, y, 'Width', BMWidth, 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
       %WriteEDMFile(fid, EDMRectangle('AlarmPV', PVCell{i}, x+6, y+1, 'Width', BMWidth-12, 'Height', 18, 'FontSize', FontSize));
        WriteEDMFile(fid, EDMTextMonitor(PVCell{i}, x, y, 'Width', BMWidth, 'Height', 20, 'FontSize', FontSizem1));  % ???
    end
    y = y + yHeight + yBorder;
end
x = x + BMWidth + xBorder;


%%%%%%%%%%%%%
% FF Enable %
%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('ID', 'FFEnable');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
%WriteEDMFile(fid, EDMStaticText({'Feed-Forward';'BM    Control'}, x+2, y, 'Width', 100, 'Height',2*yHeight, 'FontSize', FontSizem1));
%y = y + 2*yHeight + yBorder;
WriteEDMFile(fid, EDMStaticText('Feed-Forward',  x-5, y, 'HorizontalAlignment', 'center', 'Width', ceil(12*WidthRatio), 'Height',yHeight, 'FontSize', FontSize));
y = y + yHeight + yBorder;
WriteEDMFile(fid, EDMStaticText('BM    Control', x-5, y, 'HorizontalAlignment', 'center', 'Width', ceil(9*WidthRatio), 'Height',yHeight, 'FontSize', FontSizem1));
y = y + yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        BMWidth = 30;
        WriteEDMFile(fid, EDMRectangle(x+6, y+1, 'AlarmPV', PVCell{i}, 'Width', BMWidth-12, 'Height', 18, 'FontSize', FontSizem1));
        %BMWidth = 40;
        %WriteEDMFile(fid, EDMTextMonitor(PVCell{i}, x, y, 'Width', BMWidth, 'Height', 20, 'FontSize', FontSize, 'AlarmBorder', 'On'));
    end
    y = y + yHeight + yBorder;
end
x = x + BMWidth + xBorder;


%%%%%%%%%%%%%%
% FF Control %
%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('ID', 'FFEnableControl');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
%WriteEDMFile(fid, EDMStaticText({'FF';'Enable'}, x, y, 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        %WriteEDMFile(fid, EDMButton(PVCell{i}, x, y));
        WriteEDMFile(fid, EDMChoiceButton(PVCell{i}, x, y, 'Orientation','Horizontal', 'FontSize', FontSizem1));
    end
    y = y + yHeight + yBorder;
end

% Shell command - On/Off
FileName = mml2caput('ID', 'FFEnableControl');
WriteEDMFile(fid, EDMShellCommand({ ...
    %sprintf('/home/als/physbase/hlc/SR/ID/%s 1',FileName), ... 
    %sprintf('/home/als/physbase/hlc/SR/ID/%s 0',FileName), ... 
    sprintf('sh %s 1',FileName), ... 
    sprintf('sh %s 0',FileName), ... 
    }, x, y, 'ButtonLabel', 'ALL', ...
    'CommandLabel', {'Feed forward on', 'Feed forward off'}));
y = y + yHeight + yBorder;


% Related Display for FF Info
yFFRD = y + 3;
WriteEDMFile(fid, EDMRelatedDisplay({ ...
    %'/home/als/physbase/hlc/SR/ID/FFHeaderInfo.edl', ... 
    'FFHeaderInfo.edl', ... 
    ' '
    }, x-30, yFFRD, 'Width', ceil(11*WidthRatio), 'Height', 22, 'FontSize', FontSizem1, 'ButtonLabel', 'FF Table Info'));
%'CommandLabel', {'Read new feed forward tables', ' '}));


 
% Create the related display FFHeaderInfo.edl
createFFHeaderInfo;

y = y + yHeight + yBorder;


x = x + ceil(8*WidthRatio) + xBorder;


%%%%%%%%%%%%%%
% Gap Enable %
%%%%%%%%%%%%%%
y = yStart;
BMWidth = 30;
PVCell = family2channel('ID', 'GapEnable');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
%WriteEDMFile(fid, EDMStaticText({'User Gap';'BM    Control'}, x, y, 'Width', ceil(7*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSizem1));
%y = y + 2*yHeight + yBorder;
WriteEDMFile(fid, EDMStaticText('User Gap',      x, y, 'HorizontalAlignment', 'center', 'Width', ceil(9*WidthRatio), 'Height',yHeight, 'FontSize', FontSize));
y = y + yHeight + yBorder;
WriteEDMFile(fid, EDMStaticText('BM    Control', x-3, y, 'HorizontalAlignment', 'center', 'Width', ceil(9*WidthRatio), 'Height',yHeight, 'FontSize', FontSizem1));
y = y + yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        WriteEDMFile(fid, EDMRectangle(x+6, y+1, 'AlarmPV', PVCell{i}, 'Width', BMWidth-12, 'Height', 18));
    end
    y = y + yHeight + yBorder;
end
x = x + BMWidth + xBorder;


%%%%%%%%%%%%%%%%%%%%%%
% Gap Enable Control %
%%%%%%%%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('ID', 'GapEnableControl');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
%WriteEDMFile(fid, EDMStaticText({'User Gap';'Control'}, x, y, 'Height',2*yHeight));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        %WriteEDMFile(fid, EDMButton(PVCell{i}, x, y));
        WriteEDMFile(fid, EDMChoiceButton(PVCell{i}, x, y, 'Orientation','Horizontal', 'FontSize', FontSizem1));
    end
    y = y + yHeight + yBorder;
end

% Shell command - On/Off
FileName = mml2caput('ID', 'GapEnableControl');
WriteEDMFile(fid, EDMShellCommand({ ...
    %sprintf('/home/als/physbase/hlc/SR/ID/%s 1',FileName), ... 
    %sprintf('/home/als/physbase/hlc/SR/ID/%s 0',FileName), ... 
    sprintf('sh %s 1',FileName), ... 
    sprintf('sh %s 0',FileName), ... 
    }, x, y, 'Width', 70, 'ButtonLabel', 'ALL', ...
    'CommandLabel', {'User gap control on', 'User gap control off'}));

x = x + ceil(8*WidthRatio) + xBorder;
y = y + yHeight + yBorder;


%%%%%%%%%%%%%%%%
% Amplifier BM %
%%%%%%%%%%%%%%%%
x = x - 1;
y = yStart;
BMWidth = 30;
PVCell = family2channel('ID', 'Amp');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText('Amp', x-7, y, 'HorizontalAlignment', 'left', 'Width', ceil(9*WidthRatio), 'Height',yHeight, 'FontSize', FontSize));
y = y + yHeight + yBorder;
%WriteEDMFile(fid, EDMStaticText('BM  BC',  x, y, 'HorizontalAlignment', 'left', 'Width', ceil(9*WidthRatio), 'Height',yHeight, 'FontSize', FontSizem1));
WriteEDMFile(fid, EDMStaticText('BM',  x, y, 'HorizontalAlignment', 'left', 'Width', ceil(9*WidthRatio), 'Height',yHeight, 'FontSize', FontSizem1));
y = y + yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        WriteEDMFile(fid, EDMRectangle(x, y-3, 'AlarmPV', PVCell{i}, 'Width', BMWidth-12, 'Height', 18));
    end
    y = y + yHeight + yBorder;
end
x = x + BMWidth + xBorder;


%%%%%%%%%%%%%%%%
% Amplifier BC %
%%%%%%%%%%%%%%%%
% y = yStart;
% PVCell = family2channel('ID', 'AmpReset');
% PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
%        
% % Column title
% y = y + 2*yHeight + yBorder;
% 
% % Channels
% for i = 1:length(PVCell)
%     if ~isempty(PVCell{i})
%         WriteEDMFile(fid, EDMResetButton(PVCell{i}, x, y, 'Width', BMWidth-10, 'Height', 20, 'OnLabel',' ', 'OffLabel', ' '));
%         %WriteEDMFile(fid, EDMChoiceButton(PVCell{i}, x, y, 'Orientation','Horizontal', 'FontSize', FontSizem1));
%     end
%     y = y + yHeight + yBorder;
% end
% x = x + BMWidth + xBorder;


% More info button (related display)
y = yStart;
y = y + yHeight + yBorder;
y = y + yHeight + yBorder;
WriteEDMFile(fid, EDMRelatedDisplay({ ...
    '/home/als/physbase/hlc/SR/ID/SR04EPU1.edl', ... 
    ' '
    }, x, y-3, 'Width', 80, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'More ...'));
y = y + yHeight + yBorder;
WriteEDMFile(fid, EDMRelatedDisplay({ ...
    '/home/als/physbase/hlc/SR/ID/SR04EPU2.edl', ... 
    ' '
    }, x, y-3, 'Width', 80, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'More ...'));
y = y + yHeight + yBorder;
WriteEDMFile(fid, EDMRelatedDisplay({ ...
    '/home/als/physbase/hlc/SR/ID/SR05Wiggler.edl', ... 
    ' '
    }, x, y-3, 'Width', 80, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'More ...'));
y = y + yHeight + yBorder;
WriteEDMFile(fid, EDMRelatedDisplay({ ...
    '/home/als/physbase/hlc/SR/ID/SR06IVID.edl', ... 
    ' '
    }, x, y-3, 'Width', 80, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'More ...'));
y = y + yHeight + yBorder;
WriteEDMFile(fid, EDMRelatedDisplay({ ...
    '/home/als/physbase/hlc/SR/ID/SR06EPU2.edl', ... 
    ' '
    }, x, y-3, 'Width', 80, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'More ...'));
y = y + yHeight + yBorder;
if getpv('ID','Status',[7 1])
    WriteEDMFile(fid, EDMRelatedDisplay({ ...
        '/home/als/physbase/hlc/SR/ID/SR07EPU1.edl', ...
        ' '
        }, x, y-3, 'Width', 80, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'More ...'));
    y = y + yHeight + yBorder;
end
if getpv('ID','Status',[7 2])
    WriteEDMFile(fid, EDMRelatedDisplay({ ...
        '/home/als/physbase/hlc/SR/ID/SR07EPU2.edl', ...
        ' '
        }, x, y-3, 'Width', 80, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'More ...'));
    y = y + yHeight + yBorder;
end
WriteEDMFile(fid, EDMRelatedDisplay({ ...
    '/home/als/physbase/hlc/SR/ID/SR08ID.edl', ... 
    ' '
    }, x, y-3, 'Width', 80, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'More ...'));
y = y + yHeight + yBorder;
WriteEDMFile(fid, EDMRelatedDisplay({ ...
    '/home/als/physbase/hlc/SR/ID/SR09ID.edl', ... 
    ' '
    }, x, y-3, 'Width', 80, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'More ...'));
y = y + yHeight + yBorder;
WriteEDMFile(fid, EDMRelatedDisplay({ ...
    '/home/als/physbase/hlc/SR/ID/SR10ID.edl', ... 
    ' '
    }, x, y-3, 'Width', 80, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'More ...'));
y = y + yHeight + yBorder;
WriteEDMFile(fid, EDMRelatedDisplay({ ...
    '/home/als/physbase/hlc/SR/ID/SR11EPU1.edl', ... 
    ' '
    }, x, y-3, 'Width', 80, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'More ...'));
y = y + yHeight + yBorder;
WriteEDMFile(fid, EDMRelatedDisplay({ ...
    '/home/als/physbase/hlc/SR/ID/SR11EPU2.edl', ... 
    ' '
    }, x, y-3, 'Width', 80, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'More ...'));
y = y + yHeight + yBorder;
WriteEDMFile(fid, EDMRelatedDisplay({ ...
    '/home/als/physbase/hlc/SR/ID/SR12ID.edl', ... 
    ' '
    }, x, y-3, 'Width', 80, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'More ...'));

% Chicanes
WriteEDMFile(fid, EDMRelatedDisplay({ ...
    '/home/als/physbase/hlc/SR/ID/MotorChicanes.edl', ... 
    ' '
    }, x-65, yFFRD, 'Width', 150, 'Height', 20, 'FontSize', FontSizem1, 'ButtonLabel', 'Motor Chicanes'));


x = x + 80 + xBorder;

xmax = x;
% Done with the vertical gap control




%%%%%%%%%%%%%%%
% Exit Button %
%%%%%%%%%%%%%%%
%ExitButton = EDMExitButton(xmax-68, 3, 'ExitProgram');
%WriteEDMFile(fid, ExitButton);
                    


%%%%%%%
% EPU %
%%%%%%%
DeviceList = family2dev('EPU');

CommonNames = family2common('EPU');
CommonNames = deblank(mat2cell(CommonNames, ones(1,size(CommonNames,1)),size(CommonNames,2)));

x = xStart;
yStart = ymax + 30;

% Horizontal gaps
WriteEDMFile(fid, EDMStaticText('EPU Horizontal Translation (Offset)', xStart, yStart, 'Width', ceil(44.5*WidthRatio), 'Height',25, 'FontSize', FontSizep1, 'FontWeight','bold', 'HorizontalAlignment','left'));
yStart = yStart + 30 + yBorder;
y = yStart;


% First lay down the lines (or rectangles)
if strcmpi(EyeAide, 'On')
    Width = 9*ceil(8*WidthRatio) + 65 + BMWidth + 11*xBorder;
    y = y + 2*yHeight + yBorder;
    for i = 1:length(CommonNames)+1
        EDMLine([x x+Width], [y-round(yBorder/2) y-round(yBorder/2)], 'FileName', fid, 'Width', Width, 'Height', 0, 'LineWidth', 1, 'LineColor', 2, 'FillColor', 2);
        %if rem(i,2) == 1
        %    EDMRectangle(x, y, 'FileName', fid, 'Width', Width, 'Height', yHeight, 'LineWidth', 1, 'LineColor', 2, 'FillColor', 2);
        %end
        y = y + yHeight + yBorder;
    end
end


%%%%%%%%%%%%%%%%%%%%%%
% Common Name Column %
%%%%%%%%%%%%%%%%%%%%%%
x = xStart;
y = yStart;
WriteEDMFile(fid, EDMStaticText({'Device','Name'}, x+1, y, 'HorizontalAlignment', 'left', 'Width', ceil(7*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;
for i = 1:length(CommonNames)
    if ~isempty(CommonNames{i})
        WriteEDMFile(fid, EDMStaticText(CommonNames{i}, x, y, 'HorizontalAlignment', 'left', 'Width', ceil(8*WidthRatio), 'FontSize', FontSize));
    end
    y = y + yHeight + yBorder;
end
x = x + ceil(8*WidthRatio) + xBorder;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Horizontal Translation Monitor %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('EPU', 'Monitor');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Offset';'AM [mm]'}, x, y, 'HorizontalAlignment', 'left', 'Width', ceil(7*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        %TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'Precision', 3);
        TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'HorizontalAlignment','right', 'Width', 60, 'Precision',3, 'FontSize', FontSize);
        WriteEDMFile(fid, TextMonitor);
    end
    y = y + yHeight + yBorder;
end
x = x + ceil(8*WidthRatio) + xBorder;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Horizontal Translation Setpoint %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('EPU', 'Setpoint');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Offset';'SP [mm]'}, x, y, 'HorizontalAlignment', 'left', 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        TextControl = EDMTextControl(PVCell{i}, x, y, 'HorizontalAlignment','right', 'Precision',3, 'FontSize', FontSize);
        WriteEDMFile(fid, TextControl);
    end
    y = y + yHeight + yBorder;
end

% Shell command - Max Gap, Min Gap, Open, User Gap
FileNameMax = mml2caput('EPU', 'Setpoint', 'Max');
FileNameMin = mml2caput('EPU', 'Setpoint', 'Min');
ZeroGap = zeros(size(DeviceList,1),1);
FileNameZero = mml2caput('EPU', 'Setpoint', ZeroGap, DeviceList, 'EPU_Setpoint_Zero.sh');
% EPU_Setpoint_User.sh -> comes from saveusergaps
WriteEDMFile(fid, EDMShellCommand({ ...
%     sprintf('/home/als/physbase/hlc/SR/ID/%s',FileNameMax), ... 
%     sprintf('/home/als/physbase/hlc/SR/ID/EPU_Setpoint_User.sh'), ...
%     sprintf('/home/als/physbase/hlc/SR/ID/%s',FileNameZero), ... 
%     sprintf('/home/als/physbase/hlc/SR/ID/%s',FileNameMin), ...
    sprintf('sh %s',FileNameMax), ... 
    sprintf('sh EPU_Setpoint_User.sh'), ...
    sprintf('sh %s',FileNameZero), ... 
    sprintf('sh %s',FileNameMin), ...
    }, x, y, 'ButtonLabel', 'ALL', ...
    'CommandLabel', {'Maximum offset', 'Last user save', 'Zero offset','Minimum offset'}));
x = x + ceil(8*WidthRatio) + xBorder;
y = y + yHeight + yBorder;
ymax = y;


%%%%%%%%%%%%%%%%%%%%%
% User Gap Setpoint %
%%%%%%%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('EPU', 'UserGap');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'User Req.';'[mm]'}, x, y, 'HorizontalAlignment', 'center', 'Width', ceil(8*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        TextControl = EDMTextControl(PVCell{i}, x, y, 'HorizontalAlignment','right', 'Precision',3, 'FontSize', FontSize);
        WriteEDMFile(fid, TextControl);
    end
    y = y + yHeight + yBorder;
end

% Shell command - User Gap
FileName = 'EPU_UserGap.sh'; %  -> comes from saveusergaps
ZeroGap = zeros(size(DeviceList,1),1);
FileNameZero = mml2caput('EPU', 'UserGap', ZeroGap, DeviceList, 'EPU_UserGap_Zero.sh');
WriteEDMFile(fid, EDMShellCommand({ ...
    %sprintf('/home/als/physbase/hlc/SR/ID/%s',FileName), ... 
    %sprintf('/home/als/physbase/hlc/SR/ID/%s',FileNameZero), ... 
    sprintf('sh %s',FileName), ... 
    sprintf('sh %s',FileNameZero), ... 
    }, x, y, 'ButtonLabel', 'ALL', ...
    'CommandLabel', {'Last user save', 'Zero offset'}));
x = x + ceil(8*WidthRatio) + xBorder;
y = y + yHeight + yBorder;


%%%%%%%%%%%%%%%%%%%%
% Velocity Monitor %
%%%%%%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('EPU', 'Velocity');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Vel AM';'[mm/sec]'}, x, y, 'HorizontalAlignment', 'center', 'Width', ceil(8*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        %TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'Precision', 3);
        TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'HorizontalAlignment', 'right', 'Width', 55, 'Precision',3, 'FontSize', FontSize);
        WriteEDMFile(fid, TextMonitor);
    end
    y = y + yHeight + yBorder;
end
x = x + ceil(8*WidthRatio) + xBorder;


%%%%%%%%%%%%%%%%%%%%%
% Velocity Setpoint %
%%%%%%%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('EPU', 'VelocityControl');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Vel SP';'[mm/sec]'}, x, y, 'HorizontalAlignment', 'center', 'Width', ceil(8*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        TextControl = EDMTextControl(PVCell{i}, x, y, 'HorizontalAlignment','right', 'Precision',3, 'FontSize', FontSize);
        WriteEDMFile(fid, TextControl);
    end
    y = y + yHeight + yBorder;
end

% Shell command
FileNameMax = mml2caput('EPU', 'VelocityControl', 'Max');
VelUserOp = 16.7 * ones(size(DeviceList,1),1);
FileNameTypical = mml2caput('EPU', 'VelocityControl', VelUserOp, DeviceList, 'EPU_VelocityControl_UserTime.sh');
WriteEDMFile(fid, EDMShellCommand({ ...
    %sprintf('/home/als/physbase/hlc/SR/ID/%s',FileNameMax), ... 
    %sprintf('/home/als/physbase/hlc/SR/ID/%s',FileNameTypical), ... 
    sprintf('sh %s',FileNameMax), ... 
    sprintf('sh %s',FileNameTypical), ... 
    ' ', ...
    }, x, y, 'ButtonLabel', 'ALL', ...
    'CommandLabel', {'Maximum velocity', 'Maximum user operations velocity'}));
x = x + ceil(8*WidthRatio) + xBorder;
y = y + yHeight + yBorder;


%%%%%%%%%%%
% RunFlag %
%%%%%%%%%%%
y = yStart;
%BMWidth = 30;
BMWidth = 65;
PVCell = family2channel('EPU', 'RunFlag');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Run';'Flag'}, x, y, 'Width', BMWidth, 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
       %WriteEDMFile(fid, EDMRectangle(x+6, y+1, 'AlarmPV', PVCell{i}, 'Width', BMWidth-12, 'Height', 18));
        WriteEDMFile(fid, EDMTextMonitor(PVCell{i}, x, y, 'Width', BMWidth, 'Height', 20, 'FontSize', FontSizem1));
    end
    y = y + yHeight + yBorder;
end
x = x + BMWidth + xBorder;


%%%%%%%%%%%%%%%%%%%%%%%%
% OffsetA as a Monitor %
%%%%%%%%%%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('EPU', 'OffsetA');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Offset A';'[mm]'}, x, y, 'HorizontalAlignment', 'center', 'Width', ceil(8*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        %TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'Precision', 3);
        TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'HorizontalAlignment', 'right', 'Width', 60, 'Precision',3, 'FontSize', FontSize);
        WriteEDMFile(fid, TextMonitor);
    end
    y = y + yHeight + yBorder;
end
x = x + ceil(8*WidthRatio) + xBorder;


%%%%%%%%%%%%%%%%%%%%%%%%
% OffsetB as a Monitor %
%%%%%%%%%%%%%%%%%%%%%%%%
y = yStart;
PVCell = family2channel('EPU', 'OffsetB');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Offset B';'[mm]'}, x, y, 'HorizontalAlignment', 'center', 'Width', ceil(8*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        %TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'Precision', 3);
        TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'HorizontalAlignment', 'right', 'Width', 60, 'Precision',3, 'FontSize', FontSize);
        WriteEDMFile(fid, TextMonitor);
    end
    y = y + yHeight + yBorder;
end
x = x + ceil(8*WidthRatio) + xBorder;


%%%%%%%%%%
% Z-Mode %
%%%%%%%%%%
y = yStart;
PVCell = family2channel('EPU', 'ZMode');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText({'Z';'Mode'}, x, y, 'HorizontalAlignment', 'center', 'Width', ceil(7*WidthRatio), 'Height',2*yHeight, 'FontSize', FontSize));
y = y + 2*yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        %WriteEDMFile(fid, EDMStaticText(PVCell{i}, x, y, 'HorizontalAlignment', 'center', 'Width', ceil(7*WidthRatio), 'FontSize', FontSize));
        TextControl = EDMTextControl(PVCell{i}, x, y, 'HorizontalAlignment','center', 'Width', ceil(7*WidthRatio), 'FontSize', FontSize);
        WriteEDMFile(fid, TextControl);
    end
    y = y + yHeight + yBorder;
end

% Shell command - On/Off
% FileName = mml2caput('ID', 'GapEnableControl');
% WriteEDMFile(fid, EDMShellCommand({ ...
%     sprintf('/home/als/physbase/hlc/SR/ID/%s 1',FileName), ... 
%     sprintf('/home/als/physbase/hlc/SR/ID/%s 0',FileName), ... 
%     }, x, y, 'ButtonLabel', 'ALL', ...
%     'CommandLabel', {'User Gap Control ON', 'User Gap Control OFF'}));

x = x + ceil(8*WidthRatio) + xBorder;


%%%%%%%%%%%%%%%%
% Amplifier BM %
%%%%%%%%%%%%%%%%
x = x - 1;
y = yStart;
BMWidth = 30;
PVCell = family2channel('EPU', 'Amp');
PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
       
% Column title
WriteEDMFile(fid, EDMStaticText('Amp', x-7, y, 'HorizontalAlignment', 'left', 'Width', ceil(9*WidthRatio), 'Height',yHeight, 'FontSize', FontSize));
y = y + yHeight + yBorder;
WriteEDMFile(fid, EDMStaticText('BM',  x,   y, 'HorizontalAlignment', 'left', 'Width', ceil(9*WidthRatio), 'Height',yHeight, 'FontSize', FontSizem1));
y = y + yHeight + yBorder;

% Channels
for i = 1:length(PVCell)
    if ~isempty(PVCell{i})
        WriteEDMFile(fid, EDMRectangle(x, y-3, 'AlarmPV', PVCell{i}, 'Width', BMWidth-12, 'Height', 18));
    end
    y = y + yHeight + yBorder;
end
x = x + BMWidth + xBorder;


%%%%%%%%%%%%%%%%%%%%% 
% Change the header %
%%%%%%%%%%%%%%%%%%%%%
Header = EDMHeader('FileName', fid, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', xmax+10, 'Height', ymax+10);

fclose(fid);

cd(DirStart);



% Create the related display FFHeaderInfo.edl
function createFFHeaderInfo


% 8 10 12 14 18 24 72
FontSize = 14;

if FontSize == 14
    FontSizep1 = 18;
    FontSizem1 = 12;
    WidthRatio = 9;
elseif FontSize == 18
    FontSizep1 = 24;
    FontSizem1 = 14;
    WidthRatio = 10.5;
else
    error('FontSize unknown');
end


TitleBar = 'SR - Feed Forward Table Info';
WindowLocation = [700 60];

IDDeviceList  = family2dev('ID');
EPUDeviceList = family2dev('EPU');

% Start the EDM text file
fid = fopen('FFHeaderInfo.edl', 'w', 'b');

Header = EDMHeader('FileName', fid, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation);

% Main title
WriteEDMFile(fid, EDMStaticText('ID Feed Forward Table Info', 175, 10, 'Width', 450, 'FontSize', FontSizep1, 'FontWeight','bold', 'HorizontalAlignment','center'));


% % Shell command - ID_FFReadTable
% FileName = mml2caput('ID', 'FFReadTable');
% WriteEDMFile(fid, EDMShellCommand({ ...
%     sprintf('/home/als/physbase/hlc/SR/ID/%s 1',FileName), ...
%     }, 465, 9, 'Height', 23, 'Width', 175, 'FontSize', FontSize, 'ButtonLabel', 'Read New FF Tables', ...
%     'CommandLabel', {'Read new feed forward tables'}));

% ID headers
x = 5;
y = 40;

WriteEDMFile(fid, EDMStaticText('Vertical Table Headers', x+166, y, 'Width', 300, 'FontSize', FontSize, 'FontWeight','bold', 'HorizontalAlignment','left'));
y = y + 25;


ChannelNames = family2channel('ID','FFTableHeader');
ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));

for i = 1:length(ChannelNames)
    WriteEDMFile(fid, EDMResetButton(deblank(family2channel('ID','FFReadTable',IDDeviceList(i,:))), x, y, 'FontSize', FontSizem1, 'Width', 145, 'OnLabel', 'Loading Table', 'OffLabel', sprintf('ID(%2d,%2d) Table Load', IDDeviceList(i,:))));
    WriteEDMFile(fid, EDMTextMonitor(ChannelNames{i}, x+166, y, 'HorizontalAlignment', 'left', 'Width', 300, 'FontSize', FontSize));
    y = y + 25;
end
ymax = y;


% EPU headers
x = 500;
y = 40;

WriteEDMFile(fid, EDMStaticText('Horizontal Table Headers', x+4, y, 'Width', 300, 'FontSize', FontSize, 'FontWeight','bold', 'HorizontalAlignment','left'));
y = y + 25;

ChannelNames = family2channel('EPU','FFTableHeader');
ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));

for i = 1:size(IDDeviceList,1)
    j = findrowindex(IDDeviceList(i,:), EPUDeviceList);
    if ~isempty(j)
        %ChannelNames{j}
        WriteEDMFile(fid, EDMTextMonitor(ChannelNames{j}, x, y, 'HorizontalAlignment', 'left', 'Width', 300, 'FontSize', FontSize));
    end
    y = y + 25;
end


%%%%%%%%%%%%%%%%%%%%% 
% Change the header %
%%%%%%%%%%%%%%%%%%%%%
Header = EDMHeader('FileName', fid, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', 810, 'Height', ymax+10);

fclose(fid);




function WriteEDMFile(fid, Header)

for i = 1:length(Header)
    fprintf(fid, '%s\n', Header{i});
end
fprintf(fid, '\n');





