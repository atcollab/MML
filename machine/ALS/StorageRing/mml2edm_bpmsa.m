function mml2edm_bpmsa(Directory)

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
FileName = 'bpm_sa.edl';
TitleBar = 'SR BPM Engineering Panel Launcher';
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

% Column 1
x = 3;
y = 3;
for i = 1:size(Dev,1)
    n = n + 1;
    % /home/crconfs1/prod/siocsrbpm/head/opi/ needs to be on the edm path
    %WriteEDMFile(fid, EDMStaticText(sprintf('%s', Name{i}), x+150+2, y, 'Width', 250, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'medium', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
    %WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', sprintf('irm:%03d:PowerGood',i), 'Width', 15, 'Height', 15));
    %WriteEDMFile(fid, EDMTextMonitor(sprintf('irm:%03d:Temperature',i), x+17, y, 'Width' ,35, 'Height', 15, 'Precision', 1));

   %WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrControls.edl',      x,      y, 'Macro', sprintf('P=SR%02dC:,R=BPM%d:', Dev(i,1), Dev(i,2)-1), 'Width',  100, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('BPM(%d,%d)', Dev(i,1),Dev(i,2)), 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrDisplay.edl',       x,      y, 'Macro', sprintf('P=SR%02dC:,R=BPM%d:', Dev(i,1), Dev(i,2)-1), 'Width',  100, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('BPM(%d,%d)', Dev(i,1),Dev(i,2)), 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot.edl',           x+105,  y, 'Macro', sprintf('P=SR%02dC:,R=BPM%d:', Dev(i,1), Dev(i,2)-1), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'SA', 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot_xy.edl',        x+160,  y, 'Macro', sprintf('P=SR%02dC:,R=BPM%d:', Dev(i,1), Dev(i,2)-1), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'xy', 'CommandLabel', ''));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:ADC3:rfMag', deblank(Name{i})), x+200+20,     y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:ADC1:rfMag', deblank(Name{i})), x+200+30+ 60, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:ADC2:rfMag', deblank(Name{i})), x+200+40+120, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:ADC0:rfMag', deblank(Name{i})), x+200+50+180, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right'));
    
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:ADC3:ptLoMag', deblank(Name{i})), x+510+20,     y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:ADC1:ptLoMag', deblank(Name{i})), x+510+30+ 60, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:ADC2:ptLoMag', deblank(Name{i})), x+510+40+120, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:ADC0:ptLoMag', deblank(Name{i})), x+510+50+180, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right'));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:ADC3:ptHiMag', deblank(Name{i})), x+830+20,     y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:ADC1:ptHiMag', deblank(Name{i})), x+830+30+ 60, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:ADC2:ptHiMag', deblank(Name{i})), x+830+40+120, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%s:ADC0:ptHiMag', deblank(Name{i})), x+830+50+180, y, 'Width' , 60, 'Height', Height, 'HorizontalAlignment', 'Right'));
    
    y = y + 28;
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
FigWidth  = 4*200+4*60+4*20 + 20;
FigHeight = max([y1 y2]) + 10;
Header = EDMHeader('FileName', FileName, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', FigWidth, 'Height', FigHeight);


cd(DirStart);



function WriteEDMFile(fid, Header)

for i = 1:length(Header)
    fprintf(fid, '%s\n', Header{i});
end
fprintf(fid, '\n');

