function mml2edm_srmag(Directory)

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


% Setup
WindowLocation = [120 60];
FileName = 'MML2EDM_SRMAG.edl';
TitleBar = 'SR Magnet Power Supplies';
fprintf('   Building %s (%s)\n', TitleBar, FileName);

FontSize = 10;

Height = 15;
HeightBorder = 2;

WidthBorder = 2;
WidthLabel = 80;
WidthBox = 8;
WidthMonitor = 40;

HorizontalAlignment = 'right';
Precision = 2;
FieldLength = 6;

ColorOK  = 15; % Green
ColorBad = 20; % Red

x0 = 3;
y0 = 6+12;


% Output file
fid = fopen(FileName, 'w', 'b');
[Header, TitleBar] = EDMHeader('TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', 900, 'Height', 1000);
WriteEDMFile(fid, Header);



% HCM
FamilyCell{1} = 'HCM';
RowsCell{1} = {'HCM1','HCM2','HCM3','HCM4','HCM5','HCM6','HCM7','HCM8','Chicane Trim'};

FamilyCell{2} = 'VCM';
RowsCell{2} = {'VCM1','VCM2','VCM4','VCM5','VCM7','VCM8'};

FamilyCell{3} = 'SQSF';
RowsCell{3}= {'SQSF1','SQSF2'};

FamilyCell{4} = 'SQSD';
RowsCell{4}= {'SQSD1','SQSD2'};

FamilyCell{5} = 'SQEPU';
RowsCell{5}= {'SQEPU1','SQEPU2'};

FamilyCell{6} = 'SQSHF';
RowsCell{6} = {'SQSHF1','SQSHF2'};

FamilyCell{7} = 'QF';
RowsCell{7} = {'QF1','QF2'};

FamilyCell{8} = 'QD';
RowsCell{8} = {'QD1','QD2'};

FamilyCell{9} = 'SHF';
RowsCell{9} = {'SHF1','SHF2'};

FamilyCell{10} = 'SHD';
RowsCell{10} = {'SHD1','SHD2'};


y = y0;
for ii = 1:length(FamilyCell)
    Family = FamilyCell{ii};
    Rows = RowsCell{ii};
    
    if strcmpi(Family, 'QFA')
        DeviceList = family2dev(Family, 0, 0);
    else
        DeviceList = family2dev(Family, 1, 1);
    end
    
    x = x0;
    
    % Related display
    if strcmpi(Family, 'QF')
        WriteEDMFile(fid, EDMRelatedDisplay('/home/als/physbase/hlc/SR/MML2EDM_QF_QD', x, y, 'Width', WidthLabel, 'Height', Height, 'ButtonLabel', 'QF & QD', 'CommandLabel', '', 'FontSize', FontSize));
    elseif strcmpi(Family, 'QD')
    elseif strcmpi(Family, 'SHF')
        WriteEDMFile(fid, EDMRelatedDisplay('/home/als/physbase/hlc/SR/MML2EDM_SEXTUPOLES', x, y, 'Width', WidthLabel, 'Height', Height, 'ButtonLabel', 'Sextupoles', 'CommandLabel', '', 'FontSize', FontSize));
    elseif strcmpi(Family, 'SHD')
    elseif strcmpi(Family, 'SQSF')
        WriteEDMFile(fid, EDMRelatedDisplay('/home/als/physbase/hlc/SR/MML2EDM_SQSF_SQSD', x, y, 'Width', WidthLabel, 'Height', Height, 'ButtonLabel', 'Skew Quads', 'CommandLabel', '', 'FontSize', FontSize));
    elseif strcmpi(Family, 'SQSD')
    elseif strcmpi(Family, 'SQEPU')
    elseif strcmpi(Family, 'SQSHF')
    elseif strcmpi(Family, 'QFA')
        WriteEDMFile(fid, EDMRelatedDisplay('/home/als/physbase/hlc/SR/MML2EDM_QFA_SHUNTS', x, y, 'Width', WidthLabel, 'Height', Height, 'ButtonLabel', 'QFA Shunts', 'CommandLabel', '', 'FontSize', FontSize));
    else
        WriteEDMFile(fid, EDMRelatedDisplay(['/home/als/physbase/hlc/SR/MML2EDM_',Family], x, y, 'Width', WidthLabel, 'Height', Height, 'ButtonLabel', Family, 'CommandLabel', '', 'FontSize', FontSize));
    end
    x = x + WidthLabel + WidthBorder;
    
    % Sector number
    if ~any(strcmpi(Family, {'QD','SQSD','SQEPU','SQSHF','SHD'}))
        for s = 1:12
            WriteEDMFile(fid, EDMStaticText(num2str(s), x, y, 'Width', WidthMonitor+2*WidthBox, 'Height', Height, 'FontSize', FontSize, 'HorizontalAlignment','Center'));
            x = x + WidthMonitor + 2*WidthBox + 3*WidthBorder;
        end
        y = y + Height + HeightBorder;
    end
    
    for r = 1:length(Rows)
        x = x0;
        
        % Column label
        WriteEDMFile(fid, EDMStaticText(Rows{r}, x, y, 'Width', WidthLabel, 'Height', Height, 'FontSize', FontSize));
        x = x + WidthLabel + WidthBorder;
        
        for s = 1:12
            if strcmpi(Rows{r}, 'Chicane Trim')
                Dev = [s-1 10];
            else
                Dev = [s str2double(Rows{r}(end))];
            end
            iCheck = findrowindex(Dev, DeviceList);
            if ~isempty(iCheck)
                ChanName_Monitor = family2channel(Family, 'Monitor', Dev);
                ChanName_On      = family2channel(Family, 'On',      Dev);
                                
                % Monitor
                TextMonitor = EDMTextMonitor(ChanName_Monitor, x, y, 'Width', WidthMonitor, 'Height', Height, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength, 'FontSize', FontSize);
                WriteEDMFile(fid, TextMonitor);
                x = x + WidthMonitor + WidthBorder;
                
                % SP-AM - Crazy summation for ALS
                [visPV, Tol] = epicscalcrecord_sp_am(Family, Dev);
                WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'VisibleIf',    visPV, 'Range', [Tol 1000000], 'LineColor', ColorBad, 'FillColor', ColorBad));
                WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'NotVisibleIf', visPV, 'Range', [Tol 1000000], 'LineColor', ColorOK,  'FillColor', ColorOK ));
                x = x + WidthBox + WidthBorder;
                
                % On monitor - Put green on the bottom and issue condition on top
                WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'LineColor', ColorOK,  'FillColor', ColorOK));
                WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'LineColor', ColorBad, 'FillColor', ColorBad, 'VisibleIf', deblank(ChanName_On)));
                x = x + WidthBox + WidthBorder;
            else
                x = x + WidthMonitor + 2*WidthBox + 3*WidthBorder;
            end
        end
        y = y + Height + HeightBorder;
    end
    if ~any(strcmpi(Family, {'QF','SHF','SQSF','SQSD','SQEPU'}))
        y = y + 15;
    end
end


% Save the right most horizontal position
xExit = x;


% QFA Shunt
Family = 'QFA';
Rows = {'Shunt1','Shunt2'};
DeviceList = family2dev(Family, 0, 0);

x = x0;

% Related display
WriteEDMFile(fid, EDMRelatedDisplay('/home/als/physbase/hlc/SR/MML2EDM_QFA_SHUNTS', x, y, 'Width', WidthLabel, 'Height', Height, 'ButtonLabel', 'QFA Shunts', 'CommandLabel', '', 'FontSize', FontSize));
x = x + WidthLabel + WidthBorder;

% Sector number
for s = 1:12
    WriteEDMFile(fid, EDMStaticText(num2str(s), x, y, 'Width', WidthMonitor+2*WidthBox, 'Height', Height, 'FontSize', FontSize, 'HorizontalAlignment','Center'));
    x = x + WidthMonitor + 2*WidthBox + 3*WidthBorder;
end
y = y + Height + HeightBorder;

for r = 1:length(Rows)
    x = x0;
    
    % Column label
    WriteEDMFile(fid, EDMStaticText(Rows{r}, x, y, 'Width', WidthLabel, 'Height', Height, 'FontSize', FontSize));
    x = x + WidthLabel + WidthBorder;
    
    for s = 1:12
        Dev = [s str2double(Rows{r}(end))];
        iCheck = findrowindex(Dev, DeviceList);
        if ~isempty(iCheck)
            if r == 1
                ChanName_Control = family2channel(Family, 'Shunt1Control', Dev);
                ChanName_Monitor = family2channel(Family, 'Shunt1', Dev);
            else
                ChanName_Control = family2channel(Family, 'Shunt2Control', Dev);
                ChanName_Monitor = family2channel(Family, 'Shunt2', Dev);
            end
            
            % Shunt Control  - Put Red on the bottom and issue condition on top
            WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox+WidthMonitor/2, 'Height', Height-2, 'LineColor', ColorBad, 'FillColor', ColorBad));
            WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox+WidthMonitor/2, 'Height', Height-2, 'LineColor', ColorOK,  'FillColor', ColorOK, 'VisibleIf', deblank(ChanName_Control)));
            x = x + WidthMonitor/2 + WidthBox + WidthBorder;
            
            % Shunt monitor - Put Red on the bottom and issue condition on top
            WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox+WidthMonitor/2, 'Height', Height-2, 'LineColor', ColorBad, 'FillColor', ColorBad));
            WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox+WidthMonitor/2, 'Height', Height-2, 'LineColor', ColorOK,  'FillColor', ColorOK, 'VisibleIf', deblank(ChanName_Monitor)));
            x = x + WidthMonitor/2 + WidthBox + 2*WidthBorder;
        else
            x = x + WidthMonitor + 2*WidthBox + 3*WidthBorder;
        end
    end
    y = y + Height + HeightBorder;
end
y = y + 15 + 10;

y00 = y;


clear FamilyCell RowsCell
FamilyCell{1} = 'QDA';
RowsCell{1} = {'QDA1','QDA2'};

FamilyCell{2} = 'QFA';
RowsCell{2} = {'QFA'};

FamilyCell{3} = 'BEND';
RowsCell{3} = {'BEND'};

FamilyCell{4} = 'SF';
RowsCell{4} = {'SF'};

FamilyCell{5} = 'SD';
RowsCell{5} = {'SD'};

for ii = 1:length(FamilyCell)
    Family = FamilyCell{ii};
    Rows = RowsCell{ii};
    DeviceList = family2dev(Family, 1, 1);
    x = x0;
    
    if ii == 1
        % Related display
        WriteEDMFile(fid, EDMRelatedDisplay('/home/als/physbase/hlc/SR/MML2EDM_MAIN_MPS', x, y, 'Width', WidthLabel, 'Height', Height, 'ButtonLabel', 'Main PS', 'CommandLabel', '', 'FontSize', FontSize));
        x = x + WidthLabel + WidthBorder;
        
        % Sector number
        for s = [1 4 8 12]
            WriteEDMFile(fid, EDMStaticText(num2str(s), x, y, 'Width', WidthMonitor+2*WidthBox, 'Height', Height, 'FontSize', FontSize, 'HorizontalAlignment','Center'));
            x = x + WidthMonitor + 2*WidthBox + 3*WidthBorder;
        end
        y = y + Height + HeightBorder;
    end
    
    for r = 1:length(Rows)
        x = x0;
        
        % Column label
        WriteEDMFile(fid, EDMStaticText(Rows{r}, x, y, 'Width', WidthLabel, 'Height', Height, 'FontSize', FontSize));
        x = x + WidthLabel + WidthBorder;
        
        for s = [1 4 8 12]
            if any(strcmpi(Family, {'QDA'}))
                Dev = [s r];
                iCheck = findrowindex(Dev, DeviceList);
            else
                iCheck = findrowindex(s, DeviceList(:,1));
                Dev = DeviceList(iCheck,:);
            end
            if ~isempty(iCheck)
                ChanName_Monitor = family2channel(Family, 'Monitor', Dev);
                ChanName_On = family2channel(Family, 'On',      Dev);
                
                % Monitor
                TextMonitor = EDMTextMonitor(ChanName_Monitor, x, y, 'Width', WidthMonitor, 'Height', Height, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength, 'FontSize', FontSize);
                WriteEDMFile(fid, TextMonitor);
                x = x + WidthMonitor + WidthBorder;
                
                % SP-AM - Crazy summation for ALS
                [visPV, Tol] = epicscalcrecord_sp_am(Family, Dev);
                WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'VisibleIf',    visPV, 'Range', [Tol 1000000], 'LineColor', ColorBad, 'FillColor', ColorBad));
                WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'NotVisibleIf', visPV, 'Range', [Tol 1000000], 'LineColor', ColorOK,  'FillColor', ColorOK ));
                x = x + WidthBox + WidthBorder;
                
                % On monitor - Put green on the bottom and issue condition on top
                WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'LineColor', ColorOK,  'FillColor', ColorOK));
                WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'LineColor', ColorBad, 'FillColor', ColorBad, 'VisibleIf', deblank(ChanName_On)));
                x = x + WidthBox + WidthBorder;
            else
                x = x + WidthMonitor + 2*WidthBox + 3*WidthBorder;
            end
        end
        y = y + Height + HeightBorder;
    end
end

yMax = y;


clear FamilyCell RowsCell
FamilyCell{1} = 'HCMCHICANE';
RowsCell{1} = {'HCM CHICANE 1','HCM CHICANE 3'};

FamilyCell{2} = 'HCMCHICANEM';
RowsCell{2} = {'MOTOR CHICANE 2a','MOTOR CHICANE 2b'};

WidthLabel = 120;

y = y00;
x00 = x + 80;
for ii = 1:length(FamilyCell)
    Family = FamilyCell{ii};
    Rows = RowsCell{ii};
    DeviceList = family2dev(Family, 1, 1);
    x = x00;
    
    if ii == 1
        % Related display
        WriteEDMFile(fid, EDMRelatedDisplay('/home/als/physbase/hlc/SR/MML2EDM_CHICANES', x, y, 'Width', WidthLabel, 'Height', Height, 'ButtonLabel', 'Chicanes', 'CommandLabel', '', 'FontSize', FontSize));
        x = x + WidthLabel + WidthBorder;
        
        % Sector number
        for s = [4 6 11]
            WriteEDMFile(fid, EDMStaticText(num2str(s), x, y, 'Width', WidthMonitor+2*WidthBox, 'Height', Height, 'FontSize', FontSize, 'HorizontalAlignment','Center'));
            x = x + WidthMonitor + 2*WidthBox + 3*WidthBorder;
        end
        y = y + Height + HeightBorder;
    end
    
    for r = 1:length(Rows)
        x = x00;
        
        % Column label
        WriteEDMFile(fid, EDMStaticText(Rows{r}, x, y, 'Width', WidthLabel, 'Height', Height, 'FontSize', FontSize, 'HorizontalAlignment', 'Right'));
        x = x + WidthLabel + WidthBorder;
        
        for s = [4 6 7 11]
            if any(strcmpi(Family, {'HCMCHICANE'}))
                %Dev = [s r];
                Dev = [s str2double(Rows{r}(end))];
                iCheck = findrowindex(Dev, DeviceList);
                
                if ~isempty(iCheck)
                    ChanName_Monitor = family2channel(Family, 'Monitor', Dev);
                    ChanName_On = family2channel(Family, 'On',      Dev);
                    
                    % Monitor
                    TextMonitor = EDMTextMonitor(ChanName_Monitor, x, y, 'Width', WidthMonitor, 'Height', Height, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength, 'FontSize', FontSize);
                    WriteEDMFile(fid, TextMonitor);
                    x = x + WidthMonitor + WidthBorder;
                    
                    % SP-AM - Crazy summation for ALS
                    [visPV, Tol] = epicscalcrecord_sp_am(Family, Dev);
                    WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'VisibleIf',    visPV, 'Range', [Tol 1000000], 'LineColor', ColorBad, 'FillColor', ColorBad));
                    WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'NotVisibleIf', visPV, 'Range', [Tol 1000000], 'LineColor', ColorOK,  'FillColor', ColorOK ));
                    x = x + WidthBox + WidthBorder;
                    
                    % On monitor - Put green on the bottom and issue condition on top
                    WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'LineColor', ColorOK,  'FillColor', ColorOK));
                    WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'LineColor', ColorBad, 'FillColor', ColorBad, 'VisibleIf', deblank(ChanName_On)));
                    x = x + WidthBox + WidthBorder;
                else
                    x = x + WidthMonitor + 2*WidthBox + 3*WidthBorder;
                end
            elseif any(strcmpi(Family, {'HCMCHICANEM'}))
                
                if strcmpi(Rows{r},'MOTOR CHICANE 2a')
                    Dev = [s 1];
                elseif strcmpi(Rows{r},'MOTOR CHICANE 2b')
                    Dev = [s 2];
                else
                    %Dev = [s r];
                    Dev = [s str2double(Rows{r}(end))];
                end
                iCheck = findrowindex(Dev, DeviceList);
                
                if ~isempty(iCheck)
                    ChanName_Monitor = deblank(family2channel(Family, 'Monitor', Dev));
                    ChanName_On      = deblank(family2channel(Family, 'On',      Dev));
                    
                    % Monitor
                    TextMonitor = EDMTextMonitor(ChanName_Monitor, x, y, 'Width', WidthMonitor, 'Height', Height, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength, 'FontSize', FontSize);
                    WriteEDMFile(fid, TextMonitor);
                    x = x + WidthMonitor + WidthBorder;
                    
                    % SP-AM - Crazy summation for ALS
                    [visPV, Tol] = epicscalcrecord_sp_am(Family, Dev);
                    WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'VisibleIf',    visPV, 'Range', [Tol 1000000], 'LineColor', ColorBad, 'FillColor', ColorBad));
                    WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'NotVisibleIf', visPV, 'Range', [Tol 1000000], 'LineColor', ColorOK,  'FillColor', ColorOK ));
                    x = x + WidthBox + WidthBorder;
                    
                    % On monitor - Put green on the bottom and issue condition on top
                    %WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'LineColor', ColorOK,  'FillColor', ColorOK));
                    %WriteEDMFile(fid, EDMRectangle(x, y+1, 'Width', WidthBox, 'Height', Height-2, 'LineColor', ColorBad, 'FillColor', ColorBad, 'VisibleIf', deblank(ChanName_On)));
                    x = x + WidthBox + WidthBorder;
                else
                    x = x + WidthMonitor + 2*WidthBox + 3*WidthBorder;
                end
            end
        end
        y = y + Height + HeightBorder;
    end
end


%%%%%%%%%%%%%%%
% Exit Button %
%%%%%%%%%%%%%%%
%ExitButton = EDMExitButton(xExit-55, 2, 'ExitProgram', 'Width', 50, 'Height', 15, 'FontSize', FontSize);
%WriteEDMFile(fid, ExitButton);


fclose(fid);


% Update the header
xmax = max([x xExit]);
ymax = max([y yMax]);
Width  = xmax + 10;
Height = ymax + 10;
Header = EDMHeader('FileName', FileName, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', Width, 'Height', Height);



cd(DirStart);


function WriteEDMFile(fid, Header)

for i = 1:length(Header)
    fprintf(fid, '%s\n', Header{i});
end
fprintf(fid, '\n');

