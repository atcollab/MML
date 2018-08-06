function mml2edm_timing(Directory)

DirStart = pwd;

if nargin == 0
    if ispc
        cd \\Als-filer\physbase\hlc\TimingSystem
    else
        cd /home/als/physbase/hlc/TimingSystem
    end
else
    cd(Directory);
end

WindowLocation = [20 20];
FileName = 'Timing_Triggers.edl';
TitleBar = 'Timing System  -  Trigger Output & Pulser Generator Setup';
fprintf('   Building %s (%s)\n', TitleBar, FileName);

LineHeight = 20;
Height     = 16;
Boarder    =  6;
FontSize   = 14;
FontWeight = 'medium';
HorizontalAlignment = 'center';

% Start the output file
fid = fopen(FileName, 'w', 'b');
[Header, TitleBar] = EDMHeader('TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', 400, 'Height', 100);
WriteEDMFile(fid, Header);

%          1   2  3  4  5   6  7   8  9 10 11 12 13 14
Width = [180 100 60 75 75 100 60 100 60 60 60 60 60 60 60 60 60 60 60];


% Pulse Potentate On	        LI11:EVG1-SoftSeq:0:Enable-Cmd 
% Pulse Potentate Off	        LI11:EVG1-SoftSeq:0:Disable-Cmd
% Pulse Potentate (Monitor)    	LI11:EVG1-SoftSeq:0:Enable-RB
% Pulse Potentate (Old System)	GTL_____TIMING_BC01
%
% Inj Field Group Delay (IFGD)	TimInjFieldSyncDelay
% Ext Field Group Delay (EFGD)	TimExtrFieldSyncDelay
% Bucket Group Delay (BGD)	TimTargetBucketDelay
% Inj Field GD (Old)	GaussClockInjectionFieldTrigger
% Ext Field GD (Old)	GaussClockExtractionFieldTrigger

x0 = 12;
y0 = 11;

y = y0;
x = x0;

% Boxes
WriteEDMFile(fid, EDMRectangle(  5, y-5, 'Height',  110, 'Width', 800, 'No Fill'));
%WriteEDMFile(fid, EDMRectangle(730, y-5, 'Height', 125, 'Width',  80, 'No Fill'));
%WriteEDMFile(fid, EDMRectangle(  5, y+3*LineHeight+10, 'Height',  50, 'Width', 720, 'No Fill'));

WriteEDMFile(fid, EDMStaticText('SyncDelaySP                            EventDelay    = Sync (IFGD/EFGD)  FieldCount     Filtered', x+Width(1)+10, y, 'Height', Height, 'Width', 800, 'FontSize', FontSize, 'FontWeight', 'bold', 'HorizontalAlignment', 'left'));
y = y + LineHeight;

WriteEDMFile(fid, EDMStaticText('Inj Field Group Delay', x, y, 'Height', Height, 'Width', Width(1), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'right'));
x = x + Width(1) + Boarder;
WriteEDMFile(fid, EDMTextControl('TimInjFieldSyncDelaySP', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
x = x + Width(2);
%WriteEDMFile(fid, EDMTextControl('GaussClockInjectionFieldTrigger', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
WriteEDMFile(fid, EDMStaticText('*   125     -', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
x = x + Width(2);
WriteEDMFile(fid, EDMTextControl('TimInjFieldEventDelay', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
x = x + Width(2) + Boarder;
WriteEDMFile(fid, EDMStaticText('=', x, y, 'Height', Height, 'Width', 20, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'left'));
x = x + Boarder;
WriteEDMFile(fid, EDMTextMonitor('TimInjFieldSyncDelay', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
x = x + Width(2) + 20 + Boarder;
WriteEDMFile(fid, EDMTextMonitor('TimInjFieldCounterRaw', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
x = x + Width(2)-10;
WriteEDMFile(fid, EDMTextMonitor('TimInjFieldCounterFiltd', x, y, 'Height', Height, 'Width', 100, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;

% EFGD | TimExtrFieldSyncDelaySP | TimExtrFieldEventDelay | TimExtrFieldSyncDelay | TimExtrFieldCounterFiltd
x = x0;
WriteEDMFile(fid, EDMStaticText('Ext Field Group Delay', x, y, 'Height', Height, 'Width', Width(1), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'right'));
x = x + Width(1) + Boarder;
WriteEDMFile(fid, EDMTextControl('TimExtrFieldSyncDelaySP', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
x = x + Width(2);
%WriteEDMFile(fid, EDMTextControl('GaussClockExtractionFieldTrigger', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
WriteEDMFile(fid, EDMStaticText('* 10250   -', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
x = x + Width(2);
WriteEDMFile(fid, EDMTextControl('TimExtrFieldEventDelay', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
x = x + Width(2) + Boarder;
WriteEDMFile(fid, EDMStaticText('=', x, y, 'Height', Height, 'Width', 20, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'left'));
x = x + Boarder;
WriteEDMFile(fid, EDMTextMonitor('TimExtrFieldSyncDelay', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
x = x + Width(2) + 20 + Boarder;
WriteEDMFile(fid, EDMTextMonitor('TimExtrFieldCounterRaw', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
WriteEDMFile(fid, EDMStaticText('(From IRM 150 & 151)',    x-5, y + LineHeight, 'Height', Height, 'Width',  Width(2)+10, 'FontSize', 10, 'FontWeight', FontWeight, 'HorizontalAlignment', 'Center'));
x = x + Width(2)-10;
WriteEDMFile(fid, EDMTextMonitor('TimExtrFieldCounterFiltd', x, y, 'Height', Height, 'Width', 100, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));

x = x +  Width(2) -10;
HorizontalAlignment = 'left';
WriteEDMFile(fid, EDMStaticText('                Units',             x, y - 2*LineHeight, 'Height', Height, 'Width', 160, 'FontSize', FontSize, 'FontWeight', 'bold', 'HorizontalAlignment', HorizontalAlignment));
WriteEDMFile(fid, EDMStaticText('Delay -> Prescaler * 8 ns ticks',   x, y -   LineHeight, 'Height', Height, 'Width', 160, 'FontSize', 10, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
WriteEDMFile(fid, EDMStaticText('Width -> Prescaler * usec steps',        x, y               , 'Height', Height, 'Width', 160, 'FontSize', 10, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
WriteEDMFile(fid, EDMStaticText('Fine Delay -> 10 picosecond steps', x, y +   LineHeight, 'Height', Height, 'Width', 160, 'FontSize', 10, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
WriteEDMFile(fid, EDMRectangle(x-5, y - 2*LineHeight-5, 'Height', 5*LineHeight+10, 'Width', 168, 'No Fill'));

x1 = x + 100;
y = y + LineHeight;

x = x0;
WriteEDMFile(fid, EDMStaticText('Bucket Group Delay (BGD)', x, y, 'Height', Height, 'Width', Width(1), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'right'));
x = x + Width(1) + Boarder;
WriteEDMFile(fid, EDMTextControl('TimTargetBucketDelay', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'center'));
y = y + LineHeight;

x = x0;
%WriteEDMFile(fid, EDMStaticText('Pulse Potentate', x, y, 'Height', Height, 'Width', Width(1), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'right'));
WriteEDMFile(fid, EDMRelatedDisplay('PulsePotentate.edl', x+62, y-3, 'Height', Height+5, 'Width', 120, 'ButtonLabel', 'Potentate', 'FontSize', FontSize, 'FontWeight', FontWeight));
x = x + Width(1) + Boarder;
%WriteEDMFile(fid, EDMTextMonitor('LI11:EVG1-SoftSeq:0:Disable-Cmd', x, y, 'Height', Height, 'Width', 100, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
%WriteEDMFile(fid, EDMButton('LI11:EVG1-SoftSeq:0:Disable-Cmd', x, y-3, 'Height', 25, 'Width', 45, 'ButtonType', 'Push', 'OnLabel', 'Off', 'OffLabel', 'Off', 'LabelType', 'Literal'));
%x = x + 50 + Boarder;
%WriteEDMFile(fid, EDMButton('LI11:EVG1-SoftSeq:0:Enable-Cmd',  x, y-3, 'Height', 25, 'Width', 45, 'ButtonType', 'Push', 'OnLabel', 'On',  'OffLabel', 'On',  'LabelType', 'Literal'));
WriteEDMFile(fid, EDMTextMonitor('LI11:EVG1-SoftSeq:0:Enable-RB', x, y, 'Height', Height, 'Width', Width(2), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'center'));
%WriteEDMFile(fid, EDMRelatedDisplay('PulsePotentate.edl', x+Width(2)+5, y, 'Height', Height+5, 'Width', 125, 'ButtonLabel', 'Set Potentate', 'FontSize', FontSize, 'FontWeight', FontWeight));
x = x + Width(2) + Boarder + 10;

WriteEDMFile(fid, EDMStaticText('Gun Bunches', x, y, 'Height', Height, 'Width',90, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'right'));
x = x + 90 + Boarder;
WriteEDMFile(fid, EDMTextMonitor('TimGunBunchCount', x, y, 'Height', Height, 'Width', 40, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'left'));
x = x + 40 + Boarder;

WriteEDMFile(fid, EDMStaticText('Target Bucket', x, y, 'Height', Height, 'Width', 90, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'right'));
x = x + 90 + Boarder;
WriteEDMFile(fid, EDMTextMonitor('TimTargetBucket', x, y, 'Height', Height, 'Width', 50, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'left'));
x = x + 50 + Boarder;


y = y + LineHeight;

% x = x0;
% WriteEDMFile(fid, EDMStaticText('Injection Request WF', x, y, 'Height', Height, 'Width', Width(1), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'right'));
% x = x + Width(1) + Boarder;
% WriteEDMFile(fid, EDMTextControl('TimInjReq0', x, y, 'Height', Height, 'Width', 100, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
% x = x + 100 + Boarder;
% WriteEDMFile(fid, EDMTextControl('TimInjReq1', x, y, 'Height', Height, 'Width', 100, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
% x = x + 100 + Boarder;
% WriteEDMFile(fid, EDMTextControl('TimInjReq2', x, y, 'Height', Height, 'Width', 100, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
% x = x + 100 + Boarder;
% WriteEDMFile(fid, EDMTextControl('TimInjReq3', x, y, 'Height', Height, 'Width', 100, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
% x = x + 100 + Boarder;
% WriteEDMFile(fid, EDMTextControl('TimInjReq4', x, y, 'Height', Height, 'Width', 100, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
% x = x + 100 + Boarder;
% y = y + LineHeight;


% x = x0;
% WriteEDMFile(fid, EDMStaticText('Counters', x, y, 'Height', Height, 'Width', Width(1), 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'right'));
% x = x + Width(1) + Boarder;
% WriteEDMFile(fid, EDMTextMonitor('LI11:EVR1:EvtACnt-I', x, y, 'Height', Height, 'Width', 100, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
% x = x + 100 + Boarder;
% WriteEDMFile(fid, EDMTextMonitor('LI11:EVR1:EvtBCnt-I', x, y, 'Height', Height, 'Width', 100, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
% x = x + 100 + Boarder;
% WriteEDMFile(fid, EDMTextMonitor('LI11:EVR1:EvtCCnt-I', x, y, 'Height', Height, 'Width', 100, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
% x = x + 100 + Boarder;
% WriteEDMFile(fid, EDMTextMonitor('LI11:EVR1:EvtDCnt-I', x, y, 'Height', Height, 'Width', 100, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
% x = x + 100 + Boarder;
% WriteEDMFile(fid, EDMTextMonitor('LI11:EVR1:EvtECnt-I', x, y, 'Height', Height, 'Width', 100, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
% x = x + 100 + Boarder;
% y = y + LineHeight;

%x1 = x;
y = y + 12;

% Family block
DevList = family2dev('Trigger');
x = x0;

WriteEDMFile(fid, EDMStaticText('Output Port Setup',     x+250, y, 'Height', Height, 'Width', 400, 'FontSize', FontSize, 'FontWeight', 'bold', 'HorizontalAlignment', 'left'));
WriteEDMFile(fid, EDMStaticText('Pulse Generator Setup', x+620, y, 'Height', Height, 'Width', 400, 'FontSize', FontSize, 'FontWeight', 'bold', 'HorizontalAlignment', 'left'));
y = y + LineHeight;
y1 = y;

y = y1;
Text = family2common('Trigger');
Width = 220;
FontWeight = 'bold';
HorizontalAlignment = 'left';
WriteEDMFile(fid, EDMStaticText('Trigger Name', x+30, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;
FontWeight = 'medium';
for i = 1:size(DevList,1)
    WriteEDMFile(fid, EDMStaticText(sprintf('%02d.  %s',i,Text{i}), x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
    if i == 39
        y = y + 2*LineHeight;
    end
    y = y + LineHeight;
end
x = x + Width + Boarder;


y = y1;
Text = getfamilydata('Trigger','Crate');
Width = 50;
FontWeight = 'bold';
HorizontalAlignment = 'left';
WriteEDMFile(fid, EDMStaticText('Crate', x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;
FontWeight = 'medium';
for i = 1:size(DevList,1)
    if ~isempty(Text{i})
        WriteEDMFile(fid, EDMStaticText(Text{i}, x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
    end
    y = y + LineHeight;
    if i == 39
        y = y + LineHeight;
        WriteEDMFile(fid, EDMStaticText('Diagnostic Output Port Setup',     x0+235, y, 'Height', Height, 'Width', 400, 'FontSize', FontSize, 'FontWeight', 'bold', 'HorizontalAlignment', 'left'));
        WriteEDMFile(fid, EDMStaticText('Diagnostic Pulse Generator Setup', x0+580, y, 'Height', Height, 'Width', 400, 'FontSize', FontSize, 'FontWeight', 'bold', 'HorizontalAlignment', 'left'));
        y = y + LineHeight;
    end
end
x = x + Width + Boarder;

y = y1;
Value = getfamilydata('Trigger','EVR');
Width = 30;
FontWeight = 'bold';
HorizontalAlignment = 'center';
WriteEDMFile(fid, EDMStaticText('EVR', x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;
FontWeight = 'medium';
for i = 1:size(DevList,1)
    if ~isnan(Value(i))
        WriteEDMFile(fid, EDMStaticText(num2str(Value(i)), x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
    end
    if i == 39
        y = y + 2*LineHeight;
    end
    y = y + LineHeight;
end
x = x + Width + Boarder;

y = y1;
Text = getfamilydata('Trigger','Port');
Width = 50;
FontWeight = 'bold';
HorizontalAlignment = 'left';
WriteEDMFile(fid, EDMStaticText('Port', x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;
FontWeight = 'medium';
for i = 1:size(DevList,1)
    if ~isempty(Text{i})
        WriteEDMFile(fid, EDMStaticText(Text{i}, x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
    end
    if i == 39
        y = y + 2*LineHeight;
    end
    y = y + LineHeight;
end
x = x + Width + Boarder;

% Color box if the Pulser doesn't equal the 
y = y1;
Width = 65;
y = y + LineHeight;
PG = getfamilydata('Trigger','PG');
for i = 1:size(DevList,1)
    PV = deblank(family2channel('Trigger', 'Pulser', DevList(i,:)));
    if ~isempty(PV)
        if i <= 39
            WriteEDMFile(fid, EDMRectangle(x-8, y-2, 'Height', LineHeight, 'Width', 139, 'FillColor', 20, 'VisibleIf', PV, 'Range',[PG(i)+1 100], 'LineWidth', 0, 'LineColor', 20));
            WriteEDMFile(fid, EDMRectangle(x-8, y-2, 'Height', LineHeight, 'Width', 139, 'FillColor', 20, 'VisibleIf', PV, 'Range',[    0 PG(i)], 'LineWidth', 0, 'LineColor', 20));
        else
            WriteEDMFile(fid, EDMRectangle(x-8, y-2, 'Height', LineHeight, 'Width', 139, 'FillColor', 35, 'VisibleIf', PV, 'Range',[PG(i)+1 100], 'LineWidth', 0, 'LineColor', 35));
            WriteEDMFile(fid, EDMRectangle(x-8, y-2, 'Height', LineHeight, 'Width', 139, 'FillColor', 35, 'VisibleIf', PV, 'Range',[    0 PG(i)], 'LineWidth', 0, 'LineColor', 35));
        end
        if i == 39
            y = y + 2*LineHeight;
        end
    end
    y = y + LineHeight;
end


% Pulse generator number
y = y1;
Width = 65;
FontWeight = 'bold';
HorizontalAlignment = 'left';
WriteEDMFile(fid, EDMStaticText('Pulser', x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;
FontWeight = 'medium';

Value = getfamilydata('Trigger','PG');

for i = 1:size(DevList,1)
    PV = deblank(family2channel('Trigger', 'Pulser', DevList(i,:)));
    if ~isempty(PV)
        %if i <= 39
        %    WriteEDMFile(fid, EDMTextMonitor(PV, x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        %else
            Width = 90;
            WriteEDMFile(fid, EDMMenu(PV, x-5, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        %end
        if i == 39
            y = y + 2*LineHeight;
        end
    end
    y = y + LineHeight;
end

x = x + Width + Boarder/2;
WriteEDMFile(fid, EDMRectangle(x, y1-LineHeight, 'Height',  y-y1+LineHeight, 'Width', 2, 'FillColor',14));
x = x + Boarder/2;


% Pulser setup
y = y1;
Value = getfamilydata('Trigger','PG');
Width = 25;
FontWeight = 'bold';
HorizontalAlignment = 'right';
WriteEDMFile(fid, EDMStaticText('PG#', x+5, y, 'Height', Height, 'Width', Width+6, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;
FontWeight = 'medium';
HorizontalAlignment = 'right';
for i = 1:size(DevList,1)
    if ~isnan(Value(i))
        WriteEDMFile(fid, EDMStaticText(num2str(Value(i)), x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        if i == 39
            y = y + 2*LineHeight;
        end
    end
    y = y + LineHeight;
end
x = x + Width + Boarder + 10;


y = y1;
Width = 50;
FontWeight = 'bold';
HorizontalAlignment = 'center';
WriteEDMFile(fid, EDMStaticText('Evt', x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;
FontWeight = 'medium';
for i = 1:size(DevList,1)
    PV = deblank(family2channel('Trigger', 'Evt', DevList(i,:)));
    if ~isempty(PV)
        if 0 % i <= 39
            WriteEDMFile(fid, EDMTextMonitor(PV, x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        else
            WriteEDMFile(fid, EDMTextControl(PV, x, y, 'Height', Height, 'Width', Width-10, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        end
    end
    if i == 39
        y = y + 2*LineHeight;
    end
    y = y + LineHeight;
end
x = x + Width + Boarder;

y = y1;
Width = 50;
FontWeight = 'bold';
HorizontalAlignment = 'center';
WriteEDMFile(fid, EDMStaticText('Enable', x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;
FontWeight = 'medium';
for i = 1:size(DevList,1)
    PV = deblank(family2channel('Trigger', 'Enable', DevList(i,:)));
    if ~isempty(PV)
        if 0 % i <= 39
            WriteEDMFile(fid, EDMTextMonitor(PV, x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        else
            WriteEDMFile(fid, EDMMenu(PV, x-12, y, 'Height', Height, 'Width', Width+25, 'FontSize', FontSize-2, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        end
    end
    if i == 39
        y = y + 2*LineHeight;
    end
    y = y + LineHeight;
end
x = x + Width + Boarder + 8;

y = y1;
Width = 45;
FontWeight = 'bold';
HorizontalAlignment = 'Center';
WriteEDMFile(fid, EDMStaticText('Scaler', x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;
FontWeight = 'medium';
for i = 1:size(DevList,1)
    PV = deblank(family2channel('Trigger', 'Prescaler', DevList(i,:)));
    if ~isempty(PV)
        if 0 % i <= 39
            WriteEDMFile(fid, EDMTextMonitor(PV, x,    y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        else
            WriteEDMFile(fid, EDMTextControl(PV, x+5, y, 'Height', Height, 'Width', Width-10, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        end
    end
    if i == 39
        y = y + 2*LineHeight;
    end
    y = y + LineHeight;
end
x = x + Width + Boarder - 5;

y = y1;
Width = 60;
FontWeight = 'bold';
HorizontalAlignment = 'right';
WriteEDMFile(fid, EDMStaticText('Delay', x-15, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;
FontWeight = 'medium';
for i = 1:size(DevList,1)
    PV = deblank(family2channel('Trigger', 'Delay', DevList(i,:)));
    if ~isempty(PV)
        if 0 % i <= 39
            WriteEDMFile(fid, EDMTextMonitor(PV, x,    y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        else
            WriteEDMFile(fid, EDMTextControl(PV, x+2, y, 'Height', Height, 'Width', Width-10, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        end
    end
    if i == 39
        y = y + 2*LineHeight;
    end
    y = y + LineHeight;
end
x = x + Width + Boarder - 6;

% Trigger width
y = y1;
Width = 60;
FontWeight = 'bold';
HorizontalAlignment = 'center';
WriteEDMFile(fid, EDMStaticText('Width', x+5, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;
FontWeight = 'medium';
HorizontalAlignment = 'right';
for i = 1:size(DevList,1)
    PV = deblank(family2channel('Trigger', 'Width', DevList(i,:)));
    if ~isempty(PV)
        if 0 % i <= 39
            WriteEDMFile(fid, EDMTextMonitor(PV, x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment, 'Precision', 1));
        elseif any(i == [2 13 17 20 21 23 28 31 32 33 35 37 38 49])
            WriteEDMFile(fid, EDMTextControl(PV, x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment, 'Precision', 4));
        else
            WriteEDMFile(fid, EDMTextControl(PV, x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment, 'Precision', 1));
        end
    end
    if i == 39
        y = y + 2*LineHeight;
    end
    y = y + LineHeight;
end
x = x + Width + Boarder + 10;

y = y1;
Width = 85;
FontWeight = 'bold';
HorizontalAlignment = 'left';
WriteEDMFile(fid, EDMStaticText('Polarity', x+10, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;
FontWeight = 'medium';
for i = 1:size(DevList,1)
    PV = deblank(family2channel('Trigger', 'Polarity', DevList(i,:)));
    if ~isempty(PV)
        if i <= 39
            WriteEDMFile(fid, EDMTextMonitor(PV, x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        else
            WriteEDMFile(fid, EDMMenu(PV, x-15, y, 'Height', Height, 'Width', Width+15, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        end
    end
    if i == 39
        y = y + 2*LineHeight;
    end
    y = y + LineHeight;
end

x = x + Width + Boarder/2;
WriteEDMFile(fid, EDMRectangle(x, y1-LineHeight, 'Height',  y-y1+LineHeight, 'Width', 2, 'FillColor',14));
x = x + Boarder;

% Trigger Fine Delay
y = y1;
Width = 50;
FontWeight = 'bold';
HorizontalAlignment = 'center';
WriteEDMFile(fid, EDMStaticText('Fine',  x, y-LineHeight, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
WriteEDMFile(fid, EDMStaticText('Delay', x, y,            'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
y = y + LineHeight;
FontWeight = 'medium';
for i = 1:size(DevList,1)
    PV = deblank(family2channel('Trigger', 'FineDelay', DevList(i,:)));
    if ~isempty(PV)
        if 0 %i <= 39
            WriteEDMFile(fid, EDMTextMonitor(PV, x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        else
            WriteEDMFile(fid, EDMTextControl(PV, x, y, 'Height', Height, 'Width', Width, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', HorizontalAlignment));
        end
    end
    if i == 39
        y = y + 2*LineHeight;
    end
    y = y + LineHeight;
end
x = x + Width + Boarder;

y = y + 5;
WriteEDMFile(fid, EDMStaticText('Event number notes: 48 -> Often used for pre-SR injection, 68 -> Post SR Injection, 70 -> Post SR Injection (Continuous), 127 -> End of Sequence', 10, y, 'Height', Height, 'Width', 950, 'FontSize', FontSize, 'FontWeight', FontWeight, 'HorizontalAlignment', 'Left'));
y = y + LineHeight;

WriteEDMFile(fid, EDMRectangle(x0-6, y1-LineHeight-2, 'Height', y-y1+LineHeight+4, 'Width', x-x0+10, 'No Fill'));


x2 = x;
y2 = y;



% Other event numbers
% 'Post SR Injection (Gun On)'
% 'Post SR Injection (Continuous)'

%  PVcounter = [aa, ':EVR', num2str(bb), ':Evt', num2str(Evt), 'Cnt-I'];


fclose(fid);


% Update the header
FigWidth  = max([x1 x2]) + 10;
FigHeight = max([y1 y2]) + 10;
Header = EDMHeader('FileName', FileName, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', FigWidth, 'Height', FigHeight);


cd(DirStart);



function WriteEDMFile(fid, Header)

for i = 1:length(Header)
    fprintf(fid, '%s\n', Header{i});
end
fprintf(fid, '\n');
