function  mml2edm_onoff(Directory)
%MML2EDM_ONOFF -

DirStart = pwd;

if nargin < 1
    if ispc
        cd \\Als-filer\physbase\hlc\Devel
    else
        cd /home/als/physbase/hlc/Devel
    end
else
    cd(Directory);
end


% 8 10 12 14 18 24 72
FontSize = 14;

RowLabelWidth = 50;
%/home/als/physbase/hlc/Devel
BMWidth = 30;
BMHeight = 14;

xBorder = 3;
yBorder = 3;
yHeight = 20;
EyeAide = 'On';

WidthRatio = 10.5;
WindowLocation = [600 60];

xStart = 2;
yStart = 30;


% Start the EDM text file
FileName = 'MML2EDM_GTL_ONOFF.edl';
fid = fopen(FileName, 'w', 'b');

TitleBar = 'On/Off';

Header = EDMHeader('FileName', fid, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'FontSize', FontSize);


% Main title
WriteEDMFile(fid, EDMStaticText('GTL On/Off', ceil(14*WidthRatio), 10, 'Width', 200, 'FontSize',24, 'FontWeight','bold', 'HorizontalAlignment','center'));



x = xStart;
y = yStart;


%%%%%%%%%%%%%%%%
% Column Names %
%%%%%%%%%%%%%%%%
ColumnNames = {'1','2','3','4','5','6','7','8','9','10','11','12','13'};

for k=1:length(ColumnNames)    
    % Column label
    WriteEDMFile(fid, EDMStaticText(ColumnNames{k}, x+45, yStart, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', 12));
    y = yStart + 20;
    x = x + BMWidth + 3;
end


Family = {'HCM','VCM','Q','BEND','SOL'};

for j = 1:length(Family)
    DeviceList = family2dev(Family{j}, 1, 1);
    
    ChannelNames = family2channel(Family{j}, 'On', DeviceList);
    ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
    
    % Row label
    WriteEDMFile(fid, EDMStaticText(Family{j}, xStart, y-1, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
    
    % Channels
    for i = 1:length(ChannelNames)
        x = xStart + RowLabelWidth + xBorder + (i-1)*(BMWidth + xBorder) + 5;
        WriteEDMFile(fid, EDMRectangle(x, y+1, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
    end
    
    y = y + BMHeight + yBorder;
end


yBottom = y + BMHeight;


% Lay down the vertical lines (or rectangles)
if strcmpi(EyeAide, 'On')   
    x = 57;
    y = 34;
    
    for i = 1:14
        EDMRectangle(x, y, 'FileName', fid, 'Width', 0, 'Height', yBottom-(yStart+20), 'LineWidth', 1, 'LineColor', '2');
        x = x + BMWidth + xBorder;
    end
end

% Lay down the horizontal lines (or rectangles)
if strcmpi(EyeAide, 'On')   
    x = xStart;
    y = yStart + 35;
    
    for i = 1:5
        EDMRectangle(x, y, 'FileName', fid, 'Width', 452+BMWidth+xBorder, 'Height', 0, 'LineWidth', 1, 'LineColor', '2');
        y = y + BMHeight + yBorder;
    end
end


%%%%%%%%%%%%%%%
% Exit Button %
%%%%%%%%%%%%%%%
% ExitButton = EDMExitButton(450, 2, 'ExitProgram', 'Width', 40, 'FontSize', 12);
% WriteEDMFile(fid, ExitButton);
%



%%%%%%%%%%%%%%%%%%%%%
% Change the header %
%%%%%%%%%%%%%%%%%%%%%
Header = EDMHeader('FileName', fid, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', 500, 'Height', y+10);

fclose(fid);




function WriteEDMFile(fid, Header)

for i = 1:length(Header)
    fprintf(fid, '%s\n', Header{i});
end
fprintf(fid, '\n');





