function mml2edm_bpm_pilot_tones(Directory)

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
FileName = 'bpm_pilot_tones_main.edl';
TitleBar = 'SR BPM Pilot Tones';
fprintf('   Building %s (%s)\n', TitleBar, FileName);

Height = 20;
FontSize = 12;

% Start the output file
fid = fopen(FileName, 'w', 'b');
[Header, TitleBar] = EDMHeader('TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', 400, 'Height', 100);
WriteEDMFile(fid, Header);

Dev  = getfamilydata('BPM','DeviceList');
Name = getfamilydata('BPM','BaseName');
%Name = cell2mat(Name);
Name = strcat(Name, ':');

n = 0;

% Column 1
x = 3;
y = 3+20;

WriteEDMFile(fid, EDMStaticText('PT-Low',  x+100,      3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('RF',      x+160,      3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('PT-High', x+220,      3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));

WriteEDMFile(fid, EDMStaticText('RF-A', x+255+ 20,     3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('RF-B', x+255+ 30+ 60, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('RF-C', x+255+ 40+120, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('RF-D', x+255+ 50+180, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));

WriteEDMFile(fid, EDMStaticText('LO-A', x+555+ 20,     3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('LO-B', x+555+ 30+ 60, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('LO-C', x+555+ 40+120, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('LO-D', x+555+ 50+180, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));

WriteEDMFile(fid, EDMStaticText('HI-A', x+855+ 20,     3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('HI-B', x+855+ 30+ 60, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('HI-C', x+855+ 40+120, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('HI-D', x+855+ 50+180, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));

WriteEDMFile(fid, EDMStaticText('Gain-A', x+1155+ 20,     3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('Gain-B', x+1155+ 30+ 60, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('Gain-C', x+1155+ 40+120, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('Gain-D', x+1155+ 50+180, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));

WriteEDMFile(fid, EDMStaticText('PT-A',    x+1455, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('PT-B',    x+1535, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('PT-Attn', x+1625, 3, 'Width', 60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));

WriteEDMFile(fid, EDMStaticText('BPM State', x+1680, 3, 'Width', 120, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('BPM Auto Trim Control', x+1780, 3, 'Width', 200, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('PLL A', x+2010, 3, 'Width', 80, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('PLL B', x+2100, 3, 'Width', 80, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));

s = 1;
for i = 1:size(Dev,1)
    n = n + 1;

    ii = strfind(Name{i},':');
    WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrDisplay.edl',   x,      y, 'Macro', sprintf('P=%s,R=%s', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2))), 'Width',  100, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('BPM(%d,%d)', Dev(i,1),Dev(i,2)), 'CommandLabel', ''));
   %WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrControls.edl',  x+105,  y, 'Macro', sprintf('P=%s,R=%s', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2))), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Ctrl', 'CommandLabel', ''));
   %WriteEDMFile(fid, EDMRelatedDisplay('BPM_saStripcharts.edl', x+105,  y, 'Macro', sprintf('P=%s,R=%s', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2))), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Ctrl', 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot_pt_lo.edl', x+105,  y, 'Macro', sprintf('P=%s,R=%s,S=BPM([%d %d])', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2)),Dev(i,:)), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Plot',   'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot.edl',       x+160,  y, 'Macro', sprintf('P=%s,R=%s,S=BPM([%d %d])', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2)),Dev(i,:)), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Plot',   'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot_pt_hi.edl', x+215,  y, 'Macro', sprintf('P=%s,R=%s,S=BPM([%d %d])', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2)),Dev(i,:)), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Plot',   'CommandLabel', ''));
    
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC3:rfMag',    deblank(Name{i})), x+255+20,     y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC1:rfMag',    deblank(Name{i})), x+255+30+ 60, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC2:rfMag',    deblank(Name{i})), x+255+40+120, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC0:rfMag',    deblank(Name{i})), x+255+50+180, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC3:ptLoMag',  deblank(Name{i})), x+555+20,     y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC1:ptLoMag',  deblank(Name{i})), x+555+30+ 60, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC2:ptLoMag',  deblank(Name{i})), x+555+40+120, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC0:ptLoMag',  deblank(Name{i})), x+555+50+180, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC3:ptHiMag',  deblank(Name{i})),x+855+20,     y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC1:ptHiMag',  deblank(Name{i})),x+855+30+ 60, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC2:ptHiMag',  deblank(Name{i})),x+855+40+120, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC0:ptHiMag',  deblank(Name{i})),x+855+50+180, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC3:gainFactor',  deblank(Name{i})),x+1155+20,     y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC1:gainFactor',  deblank(Name{i})),x+1155+30+ 60, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC2:gainFactor',  deblank(Name{i})),x+1155+40+120, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC0:gainFactor',  deblank(Name{i})),x+1155+50+180, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
    
    WriteEDMFile(fid, EDMMenu(family2channel('BPM','PTA', Dev(i,:)),           x+1450+0,     y, 'Width', 80, 'Height', Height));
    WriteEDMFile(fid, EDMMenu(family2channel('BPM','PTB', Dev(i,:)),           x+1535+0,     y, 'Width', 80, 'Height', Height));

    WriteEDMFile(fid, EDMTextControl(family2channel('BPM','PTAttn', Dev(i,:)), x+1620+0,     y, 'Width', 80, 'Height', Height));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sautotrim:status',   deblank(Name{i})), x+1703+0, y, 'Width', 74, 'Height', Height, 'HorizontalAlignment', 'Center', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
    WriteEDMFile(fid, EDMChoiceButton(sprintf('%sautotrim:control', deblank(Name{i})), x+1780+0, y, 'Width', 220, 'Height', Height, 'HorizontalAlignment', 'Center', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
    
    if Dev(i,1) == s
        % Sector control
        ns = sum(Dev(:,1)==s);
        WriteEDMFile(fid, EDMMenu(sprintf('SR%02d:CC:ptA:Frequency', s), x+2010, y, 'Width', 85, 'Height', round(1.15*ns*Height), 'HorizontalAlignment', 'Center', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
        WriteEDMFile(fid, EDMMenu(sprintf('SR%02d:CC:ptB:Frequency', s), x+2100, y, 'Width', 85, 'Height', round(1.15*ns*Height), 'HorizontalAlignment', 'Center', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
        s = s + 1;
    end
    y = y + 24;

end
y1 = y;


% Test BPMs
Dev  = getfamilydata('BPMTest','DeviceList');
Name = getfamilydata('BPMTest','BaseName');
%Name = cell2mat(Name);
Name = strcat(Name, ':');

y = y + 40;

for i = 1:size(Dev,1)
    n = n + 1;

    ii = strfind(Name{i},':');
    WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrDisplay.edl',   x,      y, 'Macro', sprintf('P=%s,R=%s', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2))), 'Width',  100, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('BPM(%d,%d)', Dev(i,1),Dev(i,2)), 'CommandLabel', ''));
   %WriteEDMFile(fid, EDMRelatedDisplay('BPM_engrControls.edl',  x+105,  y, 'Macro', sprintf('P=%s,R=%s', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2))), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Ctrl', 'CommandLabel', ''));
   %WriteEDMFile(fid, EDMRelatedDisplay('BPM_saStripcharts.edl', x+105,  y, 'Macro', sprintf('P=%s,R=%s', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2))), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Ctrl', 'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot_pt_lo.edl', x+105,  y, 'Macro', sprintf('P=%s,R=%s,S=BPM([%d %d])', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2)),Dev(i,:)), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Plot',   'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot.edl',       x+160,  y, 'Macro', sprintf('P=%s,R=%s,S=BPM([%d %d])', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2)),Dev(i,:)), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Plot',   'CommandLabel', ''));
    WriteEDMFile(fid, EDMRelatedDisplay('bpm_sa_plot_pt_hi.edl', x+215,  y, 'Macro', sprintf('P=%s,R=%s,S=BPM([%d %d])', Name{i}(1:ii(1)), Name{i}(ii(1)+1:ii(2)),Dev(i,:)), 'Width',   50, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Plot',   'CommandLabel', ''));
    
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC3:rfMag',    deblank(Name{i})), x+255+20,     y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC1:rfMag',    deblank(Name{i})), x+255+30+ 60, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC2:rfMag',    deblank(Name{i})), x+255+40+120, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC0:rfMag',    deblank(Name{i})), x+255+50+180, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC3:ptLoMag',  deblank(Name{i})), x+555+20,     y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC1:ptLoMag',  deblank(Name{i})), x+555+30+ 60, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC2:ptLoMag',  deblank(Name{i})), x+555+40+120, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC0:ptLoMag',  deblank(Name{i})), x+555+50+180, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC3:ptHiMag',  deblank(Name{i})),x+855+20,     y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC1:ptHiMag',  deblank(Name{i})),x+855+30+ 60, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC2:ptHiMag',  deblank(Name{i})),x+855+40+120, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC0:ptHiMag',  deblank(Name{i})),x+855+50+180, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));

    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC3:gainFactor',  deblank(Name{i})),x+1155+20,     y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC1:gainFactor',  deblank(Name{i})),x+1155+30+ 60, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC2:gainFactor',  deblank(Name{i})),x+1155+40+120, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('%sADC0:gainFactor',  deblank(Name{i})),x+1155+50+180, y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'right', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
    
    WriteEDMFile(fid, EDMMenu(family2channel('BPMTest','PTA', Dev(i,:)),           x+1450+0,     y, 'Width', 80, 'Height', Height));
    WriteEDMFile(fid, EDMMenu(family2channel('BPMTest','PTB', Dev(i,:)),           x+1535+0,     y, 'Width', 80, 'Height', Height));

    WriteEDMFile(fid, EDMTextControl(family2channel('BPMTest','PTAttn', Dev(i,:)), x+1620+0,     y, 'Width', 80, 'Height', Height));

    WriteEDMFile(fid, EDMTextMonitor( sprintf('%sautotrim:status',  deblank(Name{i})), x+1703+0, y, 'Width', 74, 'Height', Height, 'HorizontalAlignment', 'Center', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
    WriteEDMFile(fid, EDMChoiceButton(sprintf('%sautotrim:control', deblank(Name{i})), x+1780+0, y, 'Width', 220, 'Height', Height, 'HorizontalAlignment', 'Center', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
    
    if Dev(i,1) == s
        % Sector control
        ns = sum(Dev(:,1)==s);
        WriteEDMFile(fid, EDMMenu(sprintf('SR%02d:CC:ptA:Frequency', s), x+2010, y, 'Width', 85, 'Height', round(1.15*ns*Height), 'HorizontalAlignment', 'Center', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
        WriteEDMFile(fid, EDMMenu(sprintf('SR%02d:CC:ptB:Frequency', s), x+2100, y, 'Width', 85, 'Height', round(1.15*ns*Height), 'HorizontalAlignment', 'Center', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',5));
        s = s + 1;
    end    
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

fclose(fid);


% Update the header
FigWidth  = 255+255+755+940+20;
FigHeight = max([y1 y2]) + 10;
Header = EDMHeader('FileName', FileName, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', FigWidth, 'Height', FigHeight);



%
% Cell controller main page
%

WindowLocation = [20 20];
FileName = 'cell_controller_main.edl';
TitleBar = 'SR BPM Pilot Tone Generators (Cell Contoller)';
fprintf('   Building %s (%s)\n', TitleBar, FileName);

Height = 20;
FontSize = 12;

% Start the output file
fid = fopen(FileName, 'w', 'b');
[Header, TitleBar] = EDMHeader('TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', 400, 'Height', 100);
WriteEDMFile(fid, Header);

Dev  = getfamilydata('BPM','DeviceList');
Name = getfamilydata('BPM','BaseName');
%Name = cell2mat(Name);
Name = strcat(Name, ':');

% Column 1
x = 2;
y = 3+20;

WriteEDMFile(fid, EDMStaticText('Eng. Panel',       x,      3, 'Width', 100, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('PLL A Freq',       x+ 100, 3, 'Width', 120, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('PLL B Freq',       x+ 200, 3, 'Width', 120, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('BPM & Cell Links', x+ 315, 3, 'Width', 105, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('PT Lock',          x+ 430, 3, 'Width', 105, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
WriteEDMFile(fid, EDMStaticText('BPM Link       CC Link', x+ 495, 3, 'Width', 155, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
WriteEDMFile(fid, EDMStaticText('FPGA',                   x+ 490+140, 3, 'Width',  60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('Kintex',                 x+ 530+140, 3, 'Width',  60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
WriteEDMFile(fid, EDMStaticText('Err Count',              x+ 530+200, 3, 'Width',  70, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
%WriteEDMFile(fid, EDMStaticText('GTX',                    x+ 530+270, 3, 'Width',  60, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));



for i = 1:12
   
    WriteEDMFile(fid, EDMRelatedDisplay('BPMCC_sysmon.edl',                    x,           y, 'Macro', sprintf('P=SR%02d:,R=%s', i, 'CC:'), 'Width',  100, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', sprintf('Sector %d', i), 'CommandLabel', ''));
    WriteEDMFile(fid, EDMMenu(sprintf('SR%02d:CC:ptA:Frequency', i),           x+ 105,  y, 'Width', 100, 'Height', Height));
    WriteEDMFile(fid, EDMMenu(sprintf('SR%02d:CC:ptB:Frequency', i),           x+ 210,  y, 'Width', 100, 'Height', Height));

    WriteEDMFile(fid, EDMRectangle(x+ 320, y, 'AlarmPV', sprintf('SR%02d:CC:BPM:CCW:linkIsUp',  i), 'Width', Height, 'Height', Height, 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMRectangle(x+ 345, y, 'AlarmPV', sprintf('SR%02d:CC:BPM:CW:linkIsUp',   i), 'Width', Height, 'Height', Height, 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMRectangle(x+ 370, y, 'AlarmPV', sprintf('SR%02d:CC:CELL:CCW:linkIsUp', i), 'Width', Height, 'Height', Height, 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
    WriteEDMFile(fid, EDMRectangle(x+ 395, y, 'AlarmPV', sprintf('SR%02d:CC:CELL:CW:linkIsUp',  i), 'Width', Height, 'Height', Height, 'AlarmBorder', 'On', 'AlarmSensitive', 'On'));
       
    WriteEDMFile(fid, EDMRectangle(x+ 430, y, 'Width', Height, 'Height', Height, 'AlarmBorder', 'On', 'FillColor',20, 'LineColor',18));
    WriteEDMFile(fid, EDMRectangle(x+ 430, y, 'VisibleIf', sprintf('CALC\\\\{A&1}(SR%02d:CC:ptA:PLLr01F)', i), 'Width', Height, 'Height', Height, 'Range',[1 2], 'FillColor',18, 'LineColor',18));

    WriteEDMFile(fid, EDMRectangle(x+ 455, y, 'Width', Height, 'Height', Height, 'AlarmBorder', 'On', 'FillColor',20, 'LineColor',18));
    WriteEDMFile(fid, EDMRectangle(x+ 455, y, 'VisibleIf', sprintf('CALC\\\\{A&1}(SR%02d:CC:ptB:PLLr01F)', i), 'Width', Height, 'Height', Height, 'Range',[1 2], 'FillColor',18, 'LineColor',18));
       
    WriteEDMFile(fid, EDMTextMonitor(sprintf('SR%02d:CC:BPMnodeNchk', i),  x+490,   y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'center', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',1, 'FontSize',12));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('SR%02d:CC:CELLnodeNchk', i), x+570,   y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'center', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',1, 'FontSize',12));
  
    WriteEDMFile(fid, EDMTextMonitor(sprintf('SR%02d:CC:FPGA:temperature', i), x+630,   y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'center', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',1));
    WriteEDMFile(fid, EDMTextMonitor(sprintf('SR%02d:CC:K7:temperature',   i), x+670,   y, 'Width', 60, 'Height', Height, 'HorizontalAlignment', 'center', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',1));
   
    WriteEDMFile(fid, EDMTextMonitor(sprintf('CALC\\\\{ABS(A+B)}(%s,%s)',sprintf('SR%02d:CC:CELL:CW:badHeader', i),sprintf('SR%02d:CC:CELL:CCW:badHeader',i)), x+730,   y, 'Width', 70, 'Height', Height, 'HorizontalAlignment', 'center', 'AlarmBorder', 'On', 'AlarmSensitive', 'On', 'Precision',0));

 %   WriteEDMFile(fid, EDMResetButton(sprintf('SR%02d:CC:resetGTX', i), x+800, y, 'Width', 60, 'Height', Height));
    y = y + 24;
end
WriteEDMFile(fid, EDMRelatedDisplay('bpm_main.edl',              660, y+ 5, 'Width',  130, 'Height', 25, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'BPM Display', 'CommandLabel', ''));
WriteEDMFile(fid, EDMRelatedDisplay('bpm_pilot_tones_main.edl',  660, y+35, 'Width',  130, 'Height', 25, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Pilot Tones', 'CommandLabel', ''));
WriteEDMFile(fid, EDMRelatedDisplay('bpm_graphs.edl',            450, y+35, 'Width',  200, 'Height', 25, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'BPM Graphs',  'CommandLabel', ''));
WriteEDMFile(fid, EDMRelatedDisplay('cell_controller_reset.edl', 450, y+ 5, 'Width',  200, 'Height', 25, 'FontSize', FontSize, 'FontWeight', 'bold',   'FontName', 'helvetica', 'ButtonLabel', 'Cell Controller Reset Panel', 'CommandLabel', ''));

y = y + 5;
WriteEDMFile(fid, EDMStaticText('Warning: 1. A PLL Frequency on RF will compromise the orbit calculation', x+5, y, 'Width', 500, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
y = y + 20;
WriteEDMFile(fid, EDMStaticText('                 with beam.  It should only be done without beam!',       x+5, y, 'Width', 500, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
y = y + 20;
WriteEDMFile(fid, EDMStaticText('             2. The pilot tone on will compromise turn-by-turn data.',    x+5, y, 'Width', 500, 'Height', Height, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
y = y + 10;

y1 = y;

fclose(fid);


% Update the header
FigWidth  = 200+200+185+150+70;
FigHeight = max([y1 y2]) + 10;
Header = EDMHeader('FileName', FileName, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', FigWidth, 'Height', FigHeight);


cd(DirStart);



function WriteEDMFile(fid, Header)

for i = 1:length(Header)
    fprintf(fid, '%s\n', Header{i});
end
fprintf(fid, '\n');


   

