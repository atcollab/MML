function mml2edm_bpm(Directory)

DirStart = pwd;

if nargin < 1
    if ispc
        cd \\Als-filer\physbase\hlc\BPM
    else
        cd /home/als/physbase/hlc/BPM
    end
else
    cd(Directory);
end

WindowLocation = [20 20];
FileName = 'bpm_main_br.edl';
TitleBar = 'Booster BPM Engineering Panel Launcher';
fprintf('   Building %s (%s)\n', TitleBar, FileName);

Height = 20;
FontSize = 12;

% Start the output file
fid = fopen(FileName, 'w', 'b');
[Header, TitleBar] = EDMHeader('TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', 400, 'Height', 100);
WriteEDMFile(fid, Header);

[Dev, Name] = getbpmlist_local;

n = 0;

% Column 1
x = 3;
y = 3+20;

WriteEDMFile(fid, EDMStaticText('A/ADC3',    x+200+ 20,     3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('B/ADC1',    x+200+ 30+60,  3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('C/ADC2',    x+200+ 40+120, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('D/ADC0',    x+200+ 50+180, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('Attn',      x+200+ 60+240, 3, 'Width', 40, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('X',         x+200+ 70+290, 3, 'Width', 40, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('Y',         x+200+ 80+325, 3, 'Width', 40, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('Q',         x+200+ 90+395, 3, 'Width', 40, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('S',         x+200+100+435, 3, 'Width', 40, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('AFE PLL   (Latch)', x+200+130+460, 3, 'Width', 120, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
WriteEDMFile(fid, EDMStaticText('Armed',             x+200+140+568, 3, 'Width',  60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
for i = 1:size(Dev,1)
    n = n + 1;
    % /home/crconfs1/prod/siocsrbpm/head/opi/ needs to be on the edm path
    %WriteEDMFile(fid, EDMStaticText(sprintf('%s', Name{i}), x+150+2, y, 'Width', 250, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'medium', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
    %WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', sprintf('irm:%03d:PowerGood',i), 'Width', 15, 'Height', 15));
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('irm:%03d:Temperature',i), x+17, y, 'Width' ,35, 'Height', 15, 'Precision', 1));
    
   %WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrControls.edl',      x,      y, 'Macro', sprintf('P=BR%d:,R=BPM%d:', Dev(i,1), Dev(i,2)), 'Width',  100, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('BPM(%d,%d)', Dev(i,1),Dev(i,2)), 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrDisplay.edl',       x,      y, 'Macro', sprintf('P=BR%d:,R=BPM%d:', Dev(i,1), Dev(i,2)), 'Width',  100, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('BPM(%d,%d)', Dev(i,1),Dev(i,2)), 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot.edl',           x+105,  y, 'Macro', sprintf('P=BR%d:,R=BPM%d:', Dev(i,1), Dev(i,2)), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'SA', 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot_xy.edl',        x+160,  y, 'Macro', sprintf('P=BR%d:,R=BPM%d:', Dev(i,1), Dev(i,2)), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'xy', 'CommandLabel', ''));

    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC3:rfMag',    deblank(Name(i,:))), x+200+20,     y, 'Width', 60, 'Height', Height));
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC1:rfMag',    deblank(Name(i,:))), x+200+30+ 60, y, 'Width', 60, 'Height', Height));
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC2:rfMag',    deblank(Name(i,:))), x+200+40+120, y, 'Width', 60, 'Height', Height));
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC0:rfMag',    deblank(Name(i,:))), x+200+50+180, y, 'Width', 60, 'Height', Height));
    
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC3:peak',    deblank(Name(i,:))), x+200+20,     y, 'Width', 60, 'Height', Height, 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC1:peak',    deblank(Name(i,:))), x+200+30+ 60, y, 'Width', 60, 'Height', Height, 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC2:peak',    deblank(Name(i,:))), x+200+40+120, y, 'Width', 60, 'Height', Height, 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC0:peak',    deblank(Name(i,:))), x+200+50+180, y, 'Width', 60, 'Height', Height, 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sattenuation',   deblank(Name(i,:))), x+200+60+235, y, 'Width', 45, 'Height', Height));
 
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sSA:X', deblank(Name(i,:))), x+200+ 70+280, y, 'Width', 45, 'Height', Height, 'Precision', 3, 'HorizontalAlignment', 'right'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sSA:X', deblank(Name(i,:))), x+200+ 80+320, y, 'Width', 45, 'Height', Height, 'Precision', 3, 'HorizontalAlignment', 'right'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sSA:Q', deblank(Name(i,:))), x+200+ 90+380, y, 'Width', 45, 'Height', Height, 'Precision', 0, 'HorizontalAlignment', 'right'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sSA:S', deblank(Name(i,:))), x+200+100+430, y, 'Width', 45, 'Height', Height, 'Precision', 0, 'HorizontalAlignment', 'right'));
 
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sAFE:pllStatus', deblank(Name(i,:))), x+200+70+300, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment','Left'));
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sEVR:AFEref:sync', deblank(Name(i,:))), x+200+70+275, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment', 'Left', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sAFE:pllStatus',      deblank(Name(i,:))), x+200+120+470, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment','Left'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sAFE:pllStatusLatch', deblank(Name(i,:))), x+200+130+520, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment','Left', 'AlarmSensitive', 'On'));
    
%     WriteEDMFile(fid, EDMButton(sprintf('%swfr:ADC:arm', deblank(Name(i,:))), x+200+130+550, y, sprintf('%swfr:ADC:arm', deblank(Name(i,:))), 'ButtonType', 'Push', 'Width', 15, 'Height', 18));
    
    WriteEDMFile(fid, EDMRectangle(x+200+130+580, y, 'NotVisibleIf', sprintf('%swfr:ADC:armed', deblank(Name(i,:))), 'Width', 15, 'Height', 18, 'FillColor', 18));
    WriteEDMFile(fid, EDMRectangle(x+200+130+580, y, 'VisibleIf',    sprintf('%swfr:ADC:armed', deblank(Name(i,:))), 'Width', 15, 'Height', 18, 'FillColor', 23));
    WriteEDMFile(fid, EDMRectangle(x+200+130+600, y, 'NotVisibleIf', sprintf('%swfr:TBT:armed', deblank(Name(i,:))), 'Width', 15, 'Height', 18, 'FillColor', 18));
    WriteEDMFile(fid, EDMRectangle(x+200+130+600, y, 'VisibleIf',    sprintf('%swfr:TBT:armed', deblank(Name(i,:))), 'Width', 15, 'Height', 18, 'FillColor', 23));
    WriteEDMFile(fid, EDMRectangle(x+200+130+620, y, 'NotVisibleIf', sprintf('%swfr:FA:armed',  deblank(Name(i,:))), 'Width', 15, 'Height', 18, 'FillColor', 18));
    WriteEDMFile(fid, EDMRectangle(x+200+130+620, y, 'VisibleIf',    sprintf('%swfr:FA:armed',  deblank(Name(i,:))), 'Width', 15, 'Height', 18, 'FillColor', 23));

    WriteEDMFile(fid, EDMRelatedDisplay('BPM_recorderControls.edl', x+200+120+650, y, 'Macro', sprintf('P=BR%d:,R=BPM%d:', Dev(i,1), Dev(i,2)), 'Width', 85, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Trigger', 'CommandLabel', ''));
    y = y + 24;
end
y1 = y;

% Add temperatures
Name = getfamilydata('BPM','BaseName');

x = 1100;
y = 3;
WriteEDMFile(fid, EDMStaticText('FPGA     DFE0    DFE1     DFE2    DFE3      AFE0     AFE1     AFE2    AFE3     AFE4     AFE5     AFE6     AFE7', x, y, 'Width', 3000, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'Bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));

x = x - 220;
y = 3 + Height;
for i = 1:size(Dev,1)
    n = n + 1;

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:FPGA:temperature',  deblank(Name{i})), x+180+10,     y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));
    
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:DFE:0:temperature', deblank(Name{i})), x+180+40+ 20, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:DFE:1:temperature', deblank(Name{i})), x+180+50+ 60, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:DFE:2:temperature', deblank(Name{i})), x+180+60+100, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:DFE:3:temperature', deblank(Name{i})), x+180+70+140, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:AFE:0:temperature', deblank(Name{i})), x+440+  0, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:AFE:1:temperature', deblank(Name{i})), x+440+ 50, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:AFE:2:temperature', deblank(Name{i})), x+440+100, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:AFE:3:temperature', deblank(Name{i})), x+440+150, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:AFE:4:temperature', deblank(Name{i})), x+440+200, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:AFE:5:temperature', deblank(Name{i})), x+440+250, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:AFE:6:temperature', deblank(Name{i})), x+440+300, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:AFE:7:temperature', deblank(Name{i})), x+440+350, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));
    
    y = y + 24;
end
y2 = y;


fclose(fid);


% Update the header
FigWidth  = 200+200+10*60+120 + 630;
FigHeight = max([y1 y2]);
Header = EDMHeader('FileName', FileName, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', FigWidth, 'Height', FigHeight);


cd(DirStart);



function WriteEDMFile(fid, Header)

for i = 1:length(Header)
    fprintf(fid, '%s\n', Header{i});
end
fprintf(fid, '\n');


function [Dev, Name] = getbpmlist_local

if 1
    Dev  = getfamilydata('BPM','DeviceList');
    Name = getfamilydata('BPM','BaseName');
    Name = cell2mat(Name);
    Name = strcat(Name, ':');
   
else
    Name = family2channel('BPMx');
    Dev  = getbpmlist('BPMx');
    
    iNewBPM = [];
    for i = 1:size(Dev,1)
        ii = strfind(Name(i,:), ':');
        if ~isempty(ii)
            iNewBPM = [iNewBPM; i];
        end
    end
    
    
    Name = Name(iNewBPM,1:11);
    Dev  = Dev(iNewBPM,:);
end

