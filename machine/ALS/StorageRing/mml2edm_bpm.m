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
FileName = 'bpm_main.edl';
TitleBar = 'SR BPM Engineering Panel Launcher';
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
WriteEDMFile(fid, EDMStaticText('X',         x+200+ 70+280, 3, 'Width', 40, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('Y',         x+200+ 80+320, 3, 'Width', 40, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('X10K',      x+200+ 90+360, 3, 'Width', 40, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('X200',      x+200+100+395, 3, 'Width', 40, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('Y10K',      x+200+110+425, 3, 'Width', 40, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('Y200',      x+200+120+465, 3, 'Width', 40, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('AFE PLL   (Latch)', x+200+130+510, 3, 'Width', 120, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
WriteEDMFile(fid, EDMStaticText('Armed',             x+200+140+620, 3, 'Width',  70, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
for i = 1:size(Dev,1)
    n = n + 1;
    % /home/crconfs1/prod/siocsrbpm/head/opi/ needs to be on the edm path
    %WriteEDMFile(fid, EDMStaticText(sprintf('%s', Name{i}), x+150+2, y, 'Width', 250, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'medium', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
    %WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', sprintf('irm:%03d:PowerGood',i), 'Width', 15, 'Height', 15));
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('irm:%03d:Temperature',i), x+17, y, 'Width' ,35, 'Height', 15, 'Precision', 1));

    ii = strfind(Name{i},':');
    WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrDisplay.edl',  x,      y, 'Macro', sprintf('P=%s,R=%s', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2))), 'Width',  100, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('BPM(%d,%d)', Dev(i,1),Dev(i,2)), 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrControls.edl', x+105,  y, 'Macro', sprintf('P=%s,R=%s', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2))), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Ctrl', 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot.edl',      x+160,  y, 'Macro', sprintf('P=%s,R=%s,S=BPM([%d %d])', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2)),Dev(i,:)), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'SA',   'CommandLabel', ''));

   %WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrDisplay.edl',   x,      y, 'Macro', sprintf('P=SR%02dC:,R=BPM%d:', Dev(i,1), Dev(i,2)-1), 'Width',  100, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('BPM(%d,%d)', Dev(i,1),Dev(i,2)), 'CommandLabel', ''));
   %WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrControls.edl',  x+105,  y, 'Macro', sprintf('P=SR%02dC:,R=BPM%d:', Dev(i,1), Dev(i,2)-1), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Ctrl', 'CommandLabel', ''));
   %WriteEDMFile(fid, EDMRelatedDisplay('BPM_saStripcharts.edl', x+160,  y, 'Macro', sprintf('P=SR%02dC:,R=BPM%d:', Dev(i,1), Dev(i,2)-1), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'SA',   'CommandLabel', ''));
   %WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot.edl',       x+160,  y, 'Macro', sprintf('P=SR%02dC:,R=BPM%d:', Dev(i,1), Dev(i,2)-1), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'SA',   'CommandLabel', ''));
   %WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot_xy.edl',    x+160,  y, 'Macro', sprintf('P=SR%02dC:,R=BPM%d:', Dev(i,1), Dev(i,2)-1), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'xy',   'CommandLabel', ''));

    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC3:rfMag',    deblank(Name{i})), x+200+20,     y, 'Width', 60, 'Height', Height));
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC1:rfMag',    deblank(Name{i})), x+200+30+ 60, y, 'Width', 60, 'Height', Height));
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC2:rfMag',    deblank(Name{i})), x+200+40+120, y, 'Width', 60, 'Height', Height));
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC0:rfMag',    deblank(Name{i})), x+200+50+180, y, 'Width', 60, 'Height', Height));
    
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC3:peak',    deblank(Name{i})), x+200+20,     y, 'Width', 60, 'Height', Height, 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC1:peak',    deblank(Name{i})), x+200+30+ 60, y, 'Width', 60, 'Height', Height, 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC2:peak',    deblank(Name{i})), x+200+40+120, y, 'Width', 60, 'Height', Height, 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC0:peak',    deblank(Name{i})), x+200+50+180, y, 'Width', 60, 'Height', Height, 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sattenuation',   deblank(Name{i})), x+200+60+235, y, 'Width', 45, 'Height', Height));

    XlessGolden = sprintf('CALC\\\\{ABS(A-B)}(%s,%f)', sprintf('%sSA:X', deblank(Name{i})), getgolden('BPM','X',Dev(i,:)));
    WriteEDMFile(fid, EDMTextMonitor(XlessGolden, x+200+ 70+270, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment','Right', 'Precision', 3));
    YlessGolden = sprintf('CALC\\\\{ABS(A-B)}(%s,%f)', sprintf('%sSA:Y', deblank(Name{i})), getgolden('BPM','Y',Dev(i,:)));
    WriteEDMFile(fid, EDMTextMonitor(YlessGolden, x+200+ 80+310, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment','Right', 'Precision', 3));
    
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sSA:X',   deblank(Name{i})), x+200+ 70+270, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment','Right', 'Precision', 3));
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sSA:Y',   deblank(Name{i})), x+200+ 80+310, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment','Right', 'Precision', 3));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sSA:RMS:wide:X',   deblank(Name{i})), x+200+ 90+360, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment', 'center', 'Precision', 3));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sSA:RMS:narrow:X', deblank(Name{i})), x+200+100+395, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment', 'center', 'Precision', 3));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sSA:RMS:wide:Y',   deblank(Name{i})), x+200+110+425, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment', 'center', 'Precision', 3));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sSA:RMS:narrow:Y', deblank(Name{i})), x+200+120+465, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment', 'center', 'Precision', 3));
 
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sAFE:pllStatus', deblank(Name{i})), x+200+70+300, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment','Left'));
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('%sEVR:AFEref:sync', deblank(Name{i})), x+200+70+275, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment', 'Left', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sAFE:pllStatus',      deblank(Name{i})), x+200+130+510, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment','Left'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sAFE:pllStatusLatch', deblank(Name{i})), x+200+140+560, y, 'Width', 45, 'Height', Height, 'HorizontalAlignment','Left', 'AlarmSensitive', 'On'));
    
    WriteEDMFile(fid, EDMRectangle(x+200+150+610, y, 'NotVisibleIf', sprintf('%swfr:ADC:armed', deblank(Name{i})), 'Width', 15, 'Height', 18, 'FillColor', 18));
    WriteEDMFile(fid, EDMRectangle(x+200+150+610, y, 'VisibleIf',    sprintf('%swfr:ADC:armed', deblank(Name{i})), 'Width', 15, 'Height', 18, 'FillColor', 23));
    WriteEDMFile(fid, EDMRectangle(x+200+150+630, y, 'NotVisibleIf', sprintf('%swfr:TBT:armed', deblank(Name{i})), 'Width', 15, 'Height', 18, 'FillColor', 18));
    WriteEDMFile(fid, EDMRectangle(x+200+150+630, y, 'VisibleIf',    sprintf('%swfr:TBT:armed', deblank(Name{i})), 'Width', 15, 'Height', 18, 'FillColor', 23));
    WriteEDMFile(fid, EDMRectangle(x+200+150+650, y, 'NotVisibleIf', sprintf('%swfr:FA:armed',  deblank(Name{i})), 'Width', 15, 'Height', 18, 'FillColor', 18));
    WriteEDMFile(fid, EDMRectangle(x+200+150+650, y, 'VisibleIf',    sprintf('%swfr:FA:armed',  deblank(Name{i})), 'Width', 15, 'Height', 18, 'FillColor', 23));

    WriteEDMFile(fid, EDMRelatedDisplay('BPM_recorderControls.edl', x+200+160+660, y, 'Macro', sprintf('P=%s,R=%s', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2))), 'Width', 85, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Trigger', 'CommandLabel', ''));
    y = y + 24;
end
y1 = y;

% Column 2
y2 = 0;
% x = 380;
% y = 3;
% for i = 59:size(Dev,1)
%     n = n + 1;
%     if ~any(i==RemoveIRM)
%         WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', sprintf('irm:%03d:PowerGood',Dev(i,1)), 'Width', 15, 'Height', 15));
%         WriteEDMFile(fid, EDMTextMonitor(sprintf('irm:%03d:Temperature',Dev(i,1)), x+17, y, 'Width' ,35, 'Height', 15, 'Precision', 1));
%         WriteEDMFile(fid, EDMRelatedDisplay('/vxboot/siocirm/boot/opi/IRM_Overall.edl', x+17+37,  y, 'Macro', sprintf('P=irm:,R=%03d:', Dev(i,1)), 'Width',  75, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('IRM %03d', Dev(i,1)), 'CommandLabel', ''));
%         WriteEDMFile(fid, EDMStaticText(sprintf('%s', Name{i}), x+17+37+77, y, 'Width', 250, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'medium', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
%         y = y + 22;
%     end
% end
% y2 = y;

y = y + 5;
WriteEDMFile(fid, EDMRelatedDisplay('bpm_temperature.edl',       10, y, 'Width',  140, 'Height', 25, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'BPM Temperatures',       'CommandLabel', ''));
WriteEDMFile(fid, EDMRelatedDisplay('bpm_graphs.edl',           160, y, 'Width',  140, 'Height', 25, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'BPM Graphs', 'CommandLabel', ''));
WriteEDMFile(fid, EDMRelatedDisplay('bpm_pilot_tones_main.edl', 310, y, 'Width',  140, 'Height', 25, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Pilot Tones', 'CommandLabel', ''));
WriteEDMFile(fid, EDMRelatedDisplay('cell_controller_main.edl', 460, y, 'Width',  140, 'Height', 25, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Cell Controller', 'CommandLabel', ''));
y2 = y + 24;

fclose(fid);


% Update the header
FigWidth  = 200+200+12*60+20;
FigHeight = max([y1 y2]) + 10;
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
    %Name = cell2mat(Name);
    Name = strcat(Name, ':');
   
else
    Name = family2channel('BPMx');
    Dev  = getbpmlist('BPMx');
    
    iNewBPM = [];
    for i = 1:size(Dev,1)
        ii = strfind(Name{i}, ':');
        if ~isempty(ii)
            iNewBPM = [iNewBPM; i];
        end
    end
    
    
    Name = Name(iNewBPM,1:11);
    Dev  = Dev(iNewBPM,:);
end

