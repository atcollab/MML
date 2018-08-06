function mml2edm_bpmgraphs(Directory)

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
FileName = 'bpm_graphs.edl';
TitleBar = 'SR BPM Graph Launcher';
fprintf('   Building %s (%s)\n', TitleBar, FileName);

FontSize = 12;
ButtonWidth = 120;
ButtonHeight = 20;


% Start the output file
fid = fopen(FileName, 'w', 'b');
[Header, TitleBar] = EDMHeader('TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', 400, 'Height', 100);
WriteEDMFile(fid, Header);

xmax = 20;
ymax = 20;

% Row labels
x = 0;
y = 4;
WriteEDMFile(fid, EDMStaticText('PV:',  x, y, 'Width',  30, 'Height', ButtonHeight, 'FontSize', FontSize, 'FontWeight', 'Bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
y = 4 + ButtonHeight;
WriteEDMFile(fid, EDMStaticText('MML:', x, y, 'Width',  40, 'Height', ButtonHeight, 'FontSize', FontSize, 'FontWeight', 'Bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'left'));
y = 4 + 2*ButtonHeight;
for s = 1:12
    y = y + 4;
    WriteEDMFile(fid, EDMStaticText(sprintf('%d', s), x, y, 'Width',  15, 'Height', ButtonHeight, 'FontSize', FontSize, 'FontWeight', 'Bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
    y = y + ButtonHeight;
end

% Column labels
sname = {'IDBPM(s,2)','BPM(s,1)','BPM(s,2)','BPM(s,3)','BPM(s,4)','BPM(s,5)','BPM(s,6)','BPM(s,7)','BPM(s,8)', 'IDBPM(s+1,1)', 'IDBPM(s+1,3)', 'IDBPM(s+1,4)'};
x = 20;
for s = 1:12
    x = x + 3;
    y = 4;
    WriteEDMFile(fid, EDMStaticText(sprintf('%s', sname{s}), x, y, 'Width',  ButtonWidth, 'Height', ButtonHeight, 'FontSize', FontSize, 'FontWeight', 'Bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
    y = 4 + ButtonHeight;
    WriteEDMFile(fid, EDMStaticText(sprintf('BPM(s,%d)', s), x, y, 'Width',  ButtonWidth, 'Height', ButtonHeight, 'FontSize', FontSize, 'FontWeight', 'Bold', 'FontName', 'helvetica', 'HorizontalAlignment', 'center'));
    x = x + ButtonWidth;
end

%y = ButtonHeight + 4;
y = 2*ButtonHeight + 4;
for s = 1:12
    Dev = getbpmlist('BPMx',s);
    y = y + 4;
    
    for j = 1:size(Dev,1)
        
        x = 20 + (Dev(j,2)-1)*(ButtonWidth+3);
                
        nx = deblank(family2channel('BPMx','Monitor',Dev(j,:)));
        ny = deblank(family2channel('BPMy','Monitor',Dev(j,:)));
        
        if ~isempty(nx)
            Name = sprintf('SR%02dS:BPM%d', Dev(j,:));
            % '/home/als/physbase/hlc/BPM/bpm_plot_xy.edl'
            % Label was sprintf('%s', Name)
            
            if strfind(nx, 'SA')
                BackgroundColor = 63;
            else
                BackgroundColor = 61;
            end
            
            WriteEDMFile(fid, EDMRelatedDisplay('bpm_plot_xy.edl', x,  y, 'Macro', sprintf('P=%s,R=%s', nx, ny), 'Width',  ButtonWidth, 'Height', ButtonHeight, 'FontSize', FontSize, 'FontWeight', 'bold', 'FontName', 'helvetica', 'ButtonLabel', sprintf('BPM(%d,%d)', Dev(j,:)), 'BackgroundColor', BackgroundColor, 'CommandLabel', ''));
            
            xmax = max([x xmax]);
        end
    end
    
    y = y + ButtonHeight;
    ymax = max([y ymax]);
end

xmax = xmax + ButtonWidth;


%WriteEDMFile(fid, EDMRectangle(x, y, 'AlarmPV', sprintf('irm:%03d:PowerGood',i), 'Width', 15, 'Height', 15));
%WriteEDMFile(fid, EDMTextMonitor(sprintf('irm:%03d:Temperature',i), x+17, y, 'Width' ,35, 'Height', 15, 'Precision', 1));

fclose(fid);


% Update the header
FigWidth  = xmax + 10;
FigHeight = ymax + 10;
Header = EDMHeader('FileName', FileName, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', FigWidth, 'Height', FigHeight);


cd(DirStart);



function WriteEDMFile(fid, Header)

for i = 1:length(Header)
    fprintf(fid, '%s\n', Header{i});
end
fprintf(fid, '\n');

