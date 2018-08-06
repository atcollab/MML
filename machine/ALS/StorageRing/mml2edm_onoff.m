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
FileName = 'MML2EDM_SR_ONOFF.edl';
fid = fopen(FileName, 'w', 'b');

TitleBar = 'On/Off';

Header = EDMHeader('FileName', fid, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'FontSize', FontSize);


% Main title
WriteEDMFile(fid, EDMStaticText('SR On/Off', ceil(14*WidthRatio), 10, 'Width', 200, 'FontSize',24, 'FontWeight','bold', 'HorizontalAlignment','center'));



x = xStart;
y = yStart;


%%%%%%%%%%%%%%%%
% Column Names %
%%%%%%%%%%%%%%%%
ColumnNames = {'SR1','SR2','SR3','SR4','SR5','SR6','SR7','SR8','SR9','SR10','SR11','SR12'};

for k=1:length(ColumnNames)
    
    % Column label
    WriteEDMFile(fid, EDMStaticText(ColumnNames{k}, x+45, yStart, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', 12));
    y = yStart + 20;
    x = x + BMWidth + 3;
end


%%%%%%%
% HCM %
%%%%%%%
Family = 'HCM';
RowNames = {'HCM1','HCM2','HCM3','HCM4','HCM5','HCM6','HCM7','HCM8'};

for j=1:length(RowNames)
    DeviceList = getcmlist(Family, RowNames{j}(4));
    ChannelNames = family2channel(Family, 'On', DeviceList);
    ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
    
    % Row label
    WriteEDMFile(fid, EDMStaticText(RowNames{j}, xStart, y-1, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
    
    % Channels
    for i = 1:length(ChannelNames)
        x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
        WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
    end
    
    y = y + BMHeight + yBorder;
end


%%%%%%%
% VCM %
%%%%%%%
Family = 'VCM';
RowNames = {'VCM1','VCM2','VCM4','VCM5','VCM7','VCM8'};

for j=1:length(RowNames)
    DeviceList = getcmlist(Family, RowNames{j}(4));
    ChannelNames = family2channel(Family, 'On', DeviceList);
    ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
    
    % Row label
    WriteEDMFile(fid, EDMStaticText(RowNames{j}, xStart, y-1, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
    
    % Channels
    for i = 1:length(ChannelNames)
        x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
        WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
    end
    
    y = y + BMHeight + yBorder;
end


%%%%%%
% QF %
%%%%%%
Family = 'QF';
RowNames = {'QF1','QF2'};

for j=1:length(RowNames)
    DeviceList = family2dev(Family, 1, 1);
    ChannelNames = family2channel(Family, 'On', DeviceList);
    ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
    
    % Row label
    WriteEDMFile(fid, EDMStaticText(RowNames{j}, xStart, y-1, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
    
    % Channels
    for i = 1:length(ChannelNames)
        x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
        WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
    end
    
    y = y + BMHeight + yBorder;
end


%%%%%%
% QD %
%%%%%%
Family = 'QD';
RowNames = {'QD1','QD2'};

for j = 1:length(RowNames)
    DeviceList = family2dev(Family, 1, 1);
    DeviceList = DeviceList(j:2:end,:);
    
    ChannelNames = family2channel(Family, 'On', DeviceList);
    ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
    
    % Row label
    WriteEDMFile(fid, EDMStaticText(RowNames{j}, xStart, y-1, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
    
    % Channels
    for i = 1:length(ChannelNames)
        x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
        WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
    end
    
    y = y + BMHeight + yBorder;
end


%%%%%%%%
% SQSF %
%%%%%%%%
Family = 'SQSF';
RowNames = {'SQSF1','SQSF2'};

for j=1:length(RowNames)
    DeviceList = family2dev(Family, 1, 1);
    DeviceList = DeviceList(j:2:end,:);
    
    ChannelNames = family2channel(Family, 'On', DeviceList);
    ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
    
    % Row label
    WriteEDMFile(fid, EDMStaticText(RowNames{j}, xStart, y-1, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
    
    % Channels
    for i = 1:length(ChannelNames)
        x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
        WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
    end
    
    y = y + BMHeight + yBorder;
end


%%%%%%%%
% SQSD %
%%%%%%%%
Family = 'SQSD';
RowNames = {'SQSD1','SQSD2'};

for j=1:length(RowNames)
    DeviceList = family2dev(Family, 1, 1);
    DeviceList = DeviceList(j:2:end,:);
    
    ChannelNames = family2channel(Family, 'On', DeviceList);
    ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
    
    % Row label
    WriteEDMFile(fid, EDMStaticText(RowNames{j}, xStart, y-1, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
    
    % Channels
    for i = 1:length(ChannelNames)
        x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
        WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
    end
    
    y = y + BMHeight + yBorder;
end


%%%%%%%%%%%%%%
% HCMCHICANE %
%%%%%%%%%%%%%%
RowNames = {'HCH1'};
DeviceList = [
    4 1
    6 1
    ];
ChannelNames = [
    family2channel('HCMCHICANE', 'On', [4 1]);
    family2channel('HCMCHICANE', 'On', [6 1]);
    ];
ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
WriteEDMFile(fid, EDMStaticText(RowNames{1}, xStart, y, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
for i = 1:length(ChannelNames)
    x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
    WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
end
y = y + BMHeight + yBorder;

RowNames = {'HCH2'};
DeviceList = [
    4 2
    6 2
    11 2
    ];
ChannelNames = [
    family2channel('HCM', 'On', [3 10]);
    family2channel('HCM', 'On', [5 10]);
    family2channel('HCM', 'On', [10 10]);
    ];
ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
WriteEDMFile(fid, EDMStaticText(RowNames{1}, xStart, y, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
for i = 1:length(ChannelNames)
    x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
    WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
end
y = y + BMHeight + yBorder;

RowNames = {'HCH3'};
DeviceList = [4 1];
ChannelNames = family2channel('HCMCHICANE', 'On', [4 1]);
ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
WriteEDMFile(fid, EDMStaticText(RowNames{1}, xStart, y, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
for i = 1:length(ChannelNames)
    x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
    WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
end
y = y + BMHeight + yBorder;


%%%%%%%%%%%%%%
% VCMCHICANE %
%%%%%%%%%%%%%%

RowNames = {'VCH2'};
DeviceList = [
    4 2
    6 2
    11 2
    ];
ChannelNames = [
    family2channel('VCM', 'On', [3 10]);
    family2channel('VCM', 'On', [5 10]);
    family2channel('VCM', 'On', [10 10]);
    ];
ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
WriteEDMFile(fid, EDMStaticText(RowNames{1}, xStart, y, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
for i = 1:length(ChannelNames)
    x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
    WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
end
y = y + BMHeight + yBorder;


%%%%%%%%%
% SQEPU %
%%%%%%%%%
Family = 'SQEPU';
RowNames = {'SQEPU1','SQEPU2'};

for j=1:length(RowNames)
    DeviceList = family2dev(Family, 1, 1);
    DeviceList = DeviceList(find(DeviceList(:,2)==j),:);
    
    ChannelNames = family2channel(Family, 'On', DeviceList);
    ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
    
    % Row label
    WriteEDMFile(fid, EDMStaticText(RowNames{j}, xStart, y-1, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
    
    % Channels
    for i = 1:length(ChannelNames)
        x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
        WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
    end
    
    y = y + BMHeight + yBorder;
end


%%%%%%%
% QDA %
%%%%%%%
Family = 'QDA';
RowNames = {'QDA1','QDA2'};

for j=1:length(RowNames)
    DeviceList = family2dev(Family, 1, 1);
    DeviceList = DeviceList(find(DeviceList(:,2)==j),:);
    
    ChannelNames = family2channel(Family, 'On', DeviceList);
    ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
    
    % Row label
    WriteEDMFile(fid, EDMStaticText(RowNames{j}, xStart, y-1, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
    
    % Channels
    for i = 1:length(ChannelNames)
        x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
        WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
    end
    
    y = y + BMHeight + yBorder;
end


%%%%%%%
% QFA %
%%%%%%%
Family = 'QFA';
RowNames = {'QFA'};

for j=1:length(RowNames)
    DeviceList = family2dev(Family, 1, 1);
    ChannelNames = family2channel(Family, 'On', DeviceList);
    ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
    
    % Row label
    WriteEDMFile(fid, EDMStaticText(RowNames{j}, xStart, y-1, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
    
    % Channels
    for i = 1:length(ChannelNames)
        x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
        WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
    end
    
    y = y + BMHeight + yBorder;
end


%%%%%%%%
% BEND %
%%%%%%%%
Family = 'BEND';
RowNames = {'BEND'};

for j=1:length(RowNames)
    DeviceList = family2dev(Family, 1, 1);
    ChannelNames = family2channel(Family, 'On', DeviceList);
    ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
    
    % Row label
    WriteEDMFile(fid, EDMStaticText(RowNames{j}, xStart, y-1, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
    
    % Channels
    for i = 1:length(ChannelNames)
        x = xStart + RowLabelWidth + xBorder + (DeviceList(i,1)-1)*(BMWidth + xBorder) + 5;
        WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{i}, 'Width', BMWidth-4, 'Height', BMHeight-2));
    end
    
    y = y + BMHeight + yBorder;
end


%%%%%%
% SF %
%%%%%%
Family = 'SF';
RowNames = {'SF'};
DeviceList = family2dev(Family, 1, 1);
ChannelNames = family2channel(Family, 'On', DeviceList);
ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
WriteEDMFile(fid, EDMStaticText(RowNames{1}, xStart, y-1, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
x = xStart + RowLabelWidth + xBorder + (DeviceList(1,1)-1)*(BMWidth + xBorder) + 5;
WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{1}, 'Width', BMWidth-4, 'Height', BMHeight-2));
y = y + BMHeight + yBorder;

%%%%%%
% SD %
%%%%%%
Family = 'SD';
RowNames = {'SD'};
DeviceList = family2dev(Family, 1, 1);
ChannelNames = family2channel(Family, 'On', DeviceList);
ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
WriteEDMFile(fid, EDMStaticText(RowNames{1}, xStart, y-1, 'HorizontalAlignment', 'center', 'Width', RowLabelWidth, 'Height', yHeight, 'FontSize', FontSize));
x = xStart + RowLabelWidth + xBorder + (DeviceList(1,1)-1)*(BMWidth + xBorder) + 5;
WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', ChannelNames{1}, 'Width', BMWidth-4, 'Height', BMHeight-2));
y = y + BMHeight + yBorder;


yBottom = y + BMHeight;

% Lay down the vertical lines (or rectangles)
if strcmpi(EyeAide, 'On')
    
    x = 57;
    y = 34;
    
    for i = 1:13
            EDMRectangle(x, y, 'FileName', fid, 'Width', 0, 'Height', yBottom-(yStart+20), 'LineWidth', 1, 'LineColor', '2');
        x = x + BMWidth + xBorder;
    end
end

% Lay down the horizontal lines (or rectangles)
if strcmpi(EyeAide, 'On')
    
    x = xStart;
    y = yStart + 35;
    
    for i = 1:33
            EDMRectangle(x, y, 'FileName', fid, 'Width', 452, 'Height', 0, 'LineWidth', 1, 'LineColor', '2');
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





