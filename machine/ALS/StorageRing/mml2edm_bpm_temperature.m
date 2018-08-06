function mml2edm_bpm_temperature(Directory)

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
FileName = 'bpm_temperature.edl';
TitleBar = 'SR BPM - Temperatures';
fprintf('   Building %s (%s)\n', TitleBar, FileName);

Height = 20;
FontSize = 12;

% Start the output file
fid = fopen(FileName, 'w', 'b');
[Header, TitleBar] = EDMHeader('TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', 400, 'Height', 100);
WriteEDMFile(fid, Header);

Dev  = family2dev('BPM');
Name = getfamilydata('BPM','BaseName');

n = 0;

WriteEDMFile(fid, EDMStaticText('FPGA     DFE0    DFE1     DFE2    DFE3      AFE0     AFE1     AFE2    AFE3     AFE4     AFE5     AFE6     AFE7', 3+200+20, 1, 'Width', 3000, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'Bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));


% Column 1
x = 3;
y = 4 + Height;
for i = 1:size(Dev,1)
    n = n + 1;
    % /home/crconfs1/prod/siocsrbpm/head/opi/ needs to be on the edm path
    %WriteEDMFile(fid, EDMStaticText(sprintf('%s', Name{i}), x+150+2, y, 'Width', 250, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'medium', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
    %WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', sprintf('irm:%03d:PowerGood',i), 'Width', 15, 'Height', 15));
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('irm:%03d:Temperature',i), x+17, y, 'Width' ,35, 'Height', 15, 'Precision', 1));

    ii = strfind(Name{i},':');
    WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrDisplay.edl',   x,      y, 'Macro', sprintf('P=%s,R=%s:', Name{i}(1:ii(1)), Name{i}(ii(1)+1:end)), 'Width',  100, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('BPM(%d,%d)', Dev(i,1),Dev(i,2)), 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrControls.edl',  x+105,  y, 'Macro', sprintf('P=%s,R=%s:', Name{i}(1:ii(1)), Name{i}(ii(1)+1:end)), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Ctrl', 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('BPM_saStripcharts.edl', x+160,  y, 'Macro', sprintf('P=%s,R=%s:', Name{i}(1:ii(1)), Name{i}(ii(1)+1:end)), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'SA',   'CommandLabel', ''));


   %WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrControls.edl',      x,      y, 'Macro', sprintf('P=SR%02dC:,R=BPM%d:', Dev(i,1), Dev(i,2)-1), 'Width',  100, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('BPM(%d,%d)', Dev(i,1),Dev(i,2)), 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrDisplay.edl',       x,      y, 'Macro', sprintf('P=SR%02dC:,R=BPM%d:', Dev(i,1), Dev(i,2)-1), 'Width',  100, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('BPM(%d,%d)', Dev(i,1),Dev(i,2)), 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot.edl',           x+105,  y, 'Macro', sprintf('P=SR%02dC:,R=BPM%d:', Dev(i,1), Dev(i,2)-1), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'SA', 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot_xy.edl',        x+160,  y, 'Macro', sprintf('P=SR%02dC:,R=BPM%d:', Dev(i,1), Dev(i,2)-1), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'xy', 'CommandLabel', ''));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:FPGA:temperature', deblank(Name{i})),  x+180+10,     y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right', 'Precision', 1));
    
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
    
    y = y + 22;
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
%         WriteEDMFile(fid, EDMStaticText(sprintf(':%s', Name{i}), x+17+37+77, y, 'Width', 250, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'medium', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
%         y = y + 22;
%     end
% end
% y2 = y;

fclose(fid);


% Update the header
FigWidth  = 4*217;
FigHeight = max([y1 y2]) + 10;
Header = EDMHeader('FileName', FileName, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', FigWidth, 'Height', FigHeight);


cd(DirStart);



function WriteEDMFile(fid, Header)

for i = 1:length(Header)
    fprintf(fid, '%s\n', Header{i});
end
fprintf(fid, '\n');

