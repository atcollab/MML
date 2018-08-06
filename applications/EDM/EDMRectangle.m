function Rectangle = EDMRectangle(x, y, varargin)

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


% lineColor index 26
% fill
% fillColor index 2
% lineWidth 2

Rectangle = {
'# (Rectangle)'
'object activeRectangleClass'
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

Rectangle{7}  = sprintf('x %d', round(x));
Rectangle{8}  = sprintf('y %d', round(y));
Rectangle{9}  = sprintf('w %d', round(Width));
Rectangle{10} = sprintf('h %d', round(Height));

Rectangle{11} = sprintf('lineColor index %d', LineColor);
Rectangle{14} = sprintf('fillColor index %d', FillColor);
Rectangle{15} = sprintf('lineWidth %d', LineWidth);

Rectangle{17} = sprintf('alarmPv "%s"', AlarmPV);

% "Visible if" >= visMin and < visMax
% visPv "VISPVNAME"
% visMin ".5"
% visMax ".1"
if VisibleIf
    Rectangle{18} = sprintf('visPv "%s"', VisiblePV);
    Rectangle{19} = sprintf('visMin "%f"', Range(1));
    Rectangle{20} = sprintf('visMax "%f"', Range(2));
    Rectangle{21} = 'endObjectProperties';
end

% "Not Visible if"
% visPv "VISPVNAME"
% visInvert
% visMin ".5"
% visMax ".1"
% endObjectProperties
if NotVisibleIf
    Rectangle{18} = sprintf('visPv "%s"', VisiblePV);
    Rectangle{19} = sprintf('visInvert');
    Rectangle{20} = sprintf('visMin "%f"', Range(1));
    Rectangle{21} = sprintf('visMax "%f"', Range(2));
    Rectangle{22} = 'endObjectProperties';
end


if isempty(AlarmPV)
    if NoFill
        Rectangle([12 13 16 17]) = [];
    else
        Rectangle([12 16 17]) = [];
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
    for i = 1:length(Rectangle)
        fprintf(fid, '%s\n', Rectangle{i});
    end
    
    if ischar(FileName)
        fclose(fid);
    end
end