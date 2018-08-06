function mml2edm_scrapers(Directory)

DirStart = pwd;

if nargin < 1
    if ispc
        cd \\Als-filer\physbase\hlc\SR
    else
        cd /home/als/physbase/hlc/SR
    end
else
    cd(Directory);
end


EyeAide = 'On';
WindowLocation = [120 60];
GoldenSetpoints = 'On';
MotifWidget = 'Off';
UpDownButton = 'Off';

FileName = 'MML2EDM_SCRAPERS.edl';
TitleBar = 'Scrapers';
fprintf('   Building %s (%s)\n', TitleBar, FileName);



% Scraper names from Rick Steele
% 1. DeviceList
% 2. T/B/R/L
% 3. positive limit
% 4. negative limit 
% 5. home_status 
% 6. moving status 
% 7. readback value 
% 8. home command 
% 9. move to position command


% Other fields: .ACCL, .REP (encoder), .STOP, 

BTSNames = getnames_scrapers('BTS');
%LeftNames  = getnames_scrapers('BTS', 'left');


% TitleBar
% TableTitle
% FileName
%
% ChannelNames  - Cell array of channel names (cell matrix for multiple columns)
%                 (family2channel(Family, Field, DeviceList))
% ChannelLabels = family2common(Family, DeviceList);
% ChannelLabelWidth
% ChannelType - Cell array of types ('Monitor', 'Boolean Control', 'Boolean Monitor')
% ColumnLabels

ChannelNames{1} = BTSNames{9};
ChannelNames{2} = BTSNames{7};
ChannelNames{3} = strcat(BTSNames{9}, '.VELO');
ChannelNames{4} = BTSNames{6};
ChannelNames{5} = BTSNames{3};
ChannelNames{6} = BTSNames{4};
ChannelNames{7} = BTSNames{5};
ChannelNames{8} = BTSNames{8};

%ChannelType = {'Control',   'Monitor', 'Monitor', 'Boolean Monitor','Boolean Monitor','Boolean Monitor','Boolean Monitor','Boolean Control'};
ChannelType = {'Control',   'Monitor', 'Monitor', 'Monitor','Monitor','Monitor','Monitor','Boolean Control'};
ColumnLabels = {'Setpoint', 'Monitor', 'Velocity','Moving',         '+Limit',         '-Limit',         'Homed',           'Home'};
ChannelLabels = {'BTS1 (Left)','BTS1 (Right)','BTS2 (Left)', 'BTS2 (Right)'};


BMWidth = 50;
BCWidth = 50;
MonitorWidth = 70;
ControlWidth = 70;
ColumnWidth = {ControlWidth, MonitorWidth, MonitorWidth, BMWidth, BMWidth, BMWidth, BMWidth, BCWidth};

ChannelLabelWidthBTS = 132;
ChannelLabelWidthSR  = 60;

[x11, y11] = mml2edm(...
    ChannelNames, ...
    'ChannelType', ChannelType, ...
    'ColumnLabels', ColumnLabels, ...
    'ColumnWidth', ColumnWidth, ...
    'ChannelLabels', ChannelLabels, ...
    'ChannelLabelWidth', ChannelLabelWidthBTS, ...
    'UpDownButton', UpDownButton, ...
    'BCButtonType', 'Reset', ...
    'ScaleColumnWidth', 1., ...
    'EyeAide', EyeAide, ...
    'FileName', FileName, ...
    'xStart', 0, ...
    'yStart', 0, ...
    'WindowLocation', WindowLocation, ...
    'MotifWidget', MotifWidget, ...
    'TableTitle', 'BTS Scrapers', ...
    'TitleBar', TitleBar);
y11 = y11 + 20;  % Just to push the SR scrapers lower



%DeviceList = family2dev('TOPSCRAPER', 0, 0);
DeviceList = [
     1     1
     2     1
     2     6
    12     6
     3     1
    ];
    
[x21, y21] = mml2edm(...
    'TOPSCRAPER', ...
    'Append', ...
    'Fields', {'Setpoint', 'Monitor', 'Velocity','RunFlag', 'PositiveLimit', 'NegativeLimit', 'Home', 'HomeControl'}, ...
    'ChannelType', ChannelType, ...
    'ColumnLabels', {'Setpoint', 'Monitor', 'Velocity','Moving', '+Limit', '-Limit', 'Homed', 'Home'}, ...
    'ColumnWidth', ColumnWidth, ...
    'ChannelLabelWidth', ChannelLabelWidthSR, ...
    'UpDownButton', UpDownButton, ...
    'BCButtonType', 'Reset', ...
    'DeviceList', DeviceList, ...
    'ScaleColumnWidth', 1., ...
    'EyeAide', EyeAide, ...
    'FileName', FileName, ...
    'xStart', 0, ...
    'yStart', y11, ...
    'WindowLocation', WindowLocation, ...
    'GoldenSetpoints', GoldenSetpoints, ...
    'MotifWidget', MotifWidget, ...
    'TableTitle', 'SR Top Scraper', ...
    'TitleBar', TitleBar);


DeviceList = family2dev('BOTTOMSCRAPER', 0, 0);

[x31, y31] = mml2edm(...
    'BOTTOMSCRAPER', ...
    'Append', ...
    'Fields', {'Setpoint', 'Monitor', 'Velocity','RunFlag', 'PositiveLimit', 'NegativeLimit', 'Home', 'HomeControl'}, ...
    'ChannelType', ChannelType, ...
    'ColumnLabels', {'Setpoint', 'Monitor', 'Velocity','Moving', '+Limit', '-Limit', 'Homed', 'Home'}, ...
    'ColumnWidth', ColumnWidth, ...
    'ChannelLabelWidth', ChannelLabelWidthSR, ...
    'UpDownButton', UpDownButton, ...
    'BCButtonType', 'Reset', ...
    'DeviceList', DeviceList, ...
    'ScaleColumnWidth', 1., ...
    'EyeAide', EyeAide, ...
    'FileName', FileName, ...
    'xStart', 0, ...
    'yStart', y21, ...
    'WindowLocation', WindowLocation, ...
    'GoldenSetpoints', GoldenSetpoints, ...
    'MotifWidget', MotifWidget, ...
    'TableTitle', 'SR Bottom Scraper', ...
    'TitleBar', TitleBar);


DeviceList = family2dev('INSIDESCRAPER', 0, 0);

GoldenSetpoints = 'Off';  % Presently there is a problem here
SP_SetAllButton = 'Off';
[x41, y41] = mml2edm(...
    'INSIDESCRAPER', ...
    'Append', ...
    'Fields', {'Setpoint', 'Monitor', 'Velocity','RunFlag', 'PositiveLimit', 'NegativeLimit', 'Home', 'HomeControl'}, ...
    'ChannelType', ChannelType, ...
    'ColumnLabels', {'Setpoint', 'Monitor', 'Velocity','Moving', '+Limit', '-Limit', 'Homed', 'Home'}, ...
    'ColumnWidth', ColumnWidth, ...
    'ChannelLabelWidth', ChannelLabelWidthSR, ...
    'UpDownButton', UpDownButton, ...
    'BCButtonType', 'Reset', ...
    'SP_SetAllButton', SP_SetAllButton, ...
    'DeviceList', DeviceList, ...
    'ScaleColumnWidth', 1., ...
    'EyeAide', EyeAide, ...
    'FileName', FileName, ...
    'xStart', 0, ...
    'yStart', y31, ...
    'WindowLocation', WindowLocation, ...
    'GoldenSetpoints', GoldenSetpoints, ...
    'MotifWidget', MotifWidget, ...
    'TableTitle', 'SR Right Scraper', ...
    'TitleBar', TitleBar);

y41 = y41 + 20;  % Just to push the note lower


%%%%%%%%%%%%%%%
% Exit Button %
%%%%%%%%%%%%%%%
%ExitButton = EDMExitButton(x11-68, 3, 'FileName', FileName,'ExitProgram');
       

% Notes
FontSize = 12;         %  8 10 12 14 18 24 72
FontWeight = 'medium';  % 'medium', 'bold'
HorizontalAlignment = 'left';  % 'left', 'center', 'right'
StaticText = EDMStaticText('Note:  SR(3,1) scrapers are in microns and the rest are mm!', 250, y41-10, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment);
fid = fopen(FileName, 'r+', 'b');
status = fseek(fid, 0, 'eof');
for i = 1:length(StaticText)
    fprintf(fid, '%s\n', StaticText{i});
end
fprintf(fid, '\n');
fclose(fid);


% Update the header
xmax = max([x11 x21 x21 x31 x41]);
ymax = max([y11 y21 y21 y31 y41]);
Width  = xmax + 10;
Height = ymax + 10;
Header = EDMHeader('FileName', FileName, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', Width, 'Height', Height);


cd(DirStart);



% if  ymax > 1200 %  I'm not sure when the slider appears
%     % To account for a window slider
%     Width  = xmax+30;
%     Height = 1220;
% else
%     Width  = xmax + 10;
%     Height = ymax + 10;
% end


