function EDMCell = EDMCircle(x, y, varargin)

Width  = 30;
Height = 18;

FileName = '';
AlarmPV = '';
LineWidth = 1;
LineColor = 14;
FillColor = 0;
VisibleIf = 0;
NotVisibleIf = 0;
Range = [0 1];
NoFill = 0;

for i = length(varargin):-1:1
    if ischar(varargin{i}) && size(varargin{i},1)==1
        if strcmpi(varargin{i},'Width')
            Width = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Height')
            Height = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'LineWidth')
            LineWidth = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'LineColor')
            LineColor = varargin{i+1};
            varargin(i:i+1) = [];
        elseif any(strcmpi(varargin{i},{'NoFill','No Fill'}))
            NoFill = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'FillColor')
            FillColor = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'AlarmPV')
            AlarmPV = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FileName')
            FileName = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'VisibleIf')
            VisibleIf = 1;
            NotVisibleIf = 0;
            VisiblePV = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'NotVisibleIf')
            VisibleIf = 0;
            NotVisibleIf = 1;
            VisiblePV = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Range')
            Range = varargin{i+1};
            varargin(i:i+1) = [];
         end
    end
end


EDMCell = {
'# (Circle)'
'object activeEDMCellClass'
'beginObjectProperties'
'major 4'
'minor 0'
'release 0'
'x 32'
'y 26'
'w 18'
'h 18'
'lineColor index 14'
'lineAlarm'
'fill'
'fillColor index 0'
'lineWidth 1'
'fillAlarm'
'alarmPv ""'
'endObjectProperties'
};

EDMCell{7}  = sprintf('x %d', x);
EDMCell{8}  = sprintf('y %d', y);
EDMCell{9}  = sprintf('w %d', Width);
EDMCell{10} = sprintf('h %d', Height);

EDMCell{11} = sprintf('lineColor index %d', LineColor);
EDMCell{14} = sprintf('fillColor index %d', FillColor);
EDMCell{15} = sprintf('lineWidth %d', LineWidth);

EDMCell{17} = sprintf('alarmPv "%s"', AlarmPV);

% "Visible if" >= visMin and < visMax
% visPv "VISPVNAME"
% visMin ".5"
% visMax ".1"
if VisibleIf
    EDMCell{18} = sprintf('visPv "%s"', VisiblePV);
    EDMCell{19} = sprintf('visMin "%f"', Range(1));
    EDMCell{20} = sprintf('visMax "%f"', Range(2));
    EDMCell{21} = 'endObjectProperties';
end

% "Not Visible if"
% visPv "VISPVNAME"
% visInvert
% visMin ".5"
% visMax ".1"
% endObjectProperties
if NotVisibleIf
    EDMCell{18} = sprintf('visPv "%s"', VisiblePV);
    EDMCell{19} = sprintf('visInvert');
    EDMCell{20} = sprintf('visMin "%f"', Range(1));
    EDMCell{21} = sprintf('visMax "%f"', Range(2));
    EDMCell{22} = 'endObjectProperties';
end


if isempty(AlarmPV)
    if NoFill
        EDMCell([12 13 16 17]) = [];
    else
        EDMCell([12 16 17]) = [];
    end
end


% Write to file or just return the cell array
if ~isempty(FileName)
    if ischar(FileName)
        fid = fopen(FileName, 'r+', 'b');
    else
        fid = FileName;
    end
        
    status = fseek(fid, 0, 'eof');
    for i = 1:length(EDMCell)
        fprintf(fid, '%s\n', EDMCell{i});
    end
    
    if ischar(FileName)
        fclose(fid);
    end
end
