function Line = EDMLine(x, y, varargin)

Width  = 30;
Height = 0;

FileName = '';
LineWidth = 1;
LineColor = 14;
FillColor = 0;

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
        elseif strcmpi(varargin{i},'FillColor')
            FillColor = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'AlarmPV')
            AlarmPV = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FileName')
            FileName = varargin{i+1};
            varargin(i:i+1) = [];
        end
    end
end


Line = {
'# (Lines)'
'object activeLineClass'
'beginObjectProperties'
'major 4'
'minor 0'
'release 1'
'x 731'
'y 538'
'w 164'
'h 0'
'lineColor index 26'
'fillColor index 26'
'lineWidth 1'
'numPoints 2'
'xPoints {'
% '  0 731'
% '  1 895'
% '}'
% 'yPoints {'
% '  0 538'
% '  1 538'
% '}'
%'endObjectProperties'
};

Line{7}  = sprintf('x %d', x(1));
Line{8}  = sprintf('y %d', y(1));
Line{9}  = sprintf('w %d', Width);
Line{10} = sprintf('h %d', Height);

Line{11} = sprintf('lineColor index %d', LineColor);
Line{12} = sprintf('fillColor index %d', FillColor);
Line{13} = sprintf('lineWidth %d', LineWidth);
Line{14} = sprintf('numPoints %d', length(x));

for i = 1:length(x)
    Line{15+i} = sprintf('  %d %d', i-1, x(i));
end
Line{end+1} = '}';
Line{end+1} = 'yPoints {';
for i = 1:length(x)
    Line{end+1} = sprintf('  %d %d', i-1, y(i));
end
Line{end+1} = '}';

Line{end+1} = 'endObjectProperties';


% Write to file or just return the cell array
if ~isempty(FileName)
    if ischar(FileName)
        fid = fopen(FileName, 'r+', 'b');
    else
        fid = FileName;
    end
        
    status = fseek(fid, 0, 'eof');
    for i = 1:length(Line)
        fprintf(fid, '%s\n', Line{i});
    end
    
    if ischar(FileName)
        fclose(fid);
    end
end

