function EDMCommand = EDMGraph(PVName, x, y, varargin)

% Defaults
FontSize = 14;
FontWeight = 'bold';  % 'medium', 'bold'
HorizontalAlignment = 'center';  % 'left', 'center', 'right'
FontName = 'helvetica';
%FontAngle = ???
Precision = '';
FieldLength = '';
XLabel = '';
YLabel = '';

Width  = 70;
Height = 20;


for i = length(varargin):-1:1
    if ischar(varargin{i}) && size(varargin{i},1)==1
        if strcmpi(varargin{i},'FontSize')
            FontSize = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FontWeight')
            FontWeight = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FontName')
            FontName = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Width')
            Width = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Height')
            Height = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'XLabel')
            XLabel = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'YLabel')
            YLabel = varargin{i+1};
            varargin(i:i+1) = [];
        end
    end
end






EDMCommand = {
'# (X-Y Graph)'
'object xyGraphClass'
'beginObjectProperties'
'major 4'
'minor 8'
'release 0'
'# Geometry'
'x 8'
'y 320'
'w 520'
'h 276'
'# Appearance'
'autoScaleBothDirections'
'graphTitle "Vertical"'
'yLabel "Vertical mm"'
'fgColor index 14'
'bgColor index 3'
'gridColor index 6'
'font "helvetica-medium-r-10.0"'
'# Operating Modes'
'plotMode "plotLastNPts"'
'nPts 250'
'updateTimerMs 100'
'# X axis properties'
'showXAxis'
'xAxisSrc "AutoScale"'
'xMax 1'
'# Y axis properties'
'showYAxis'
'yAxisSrc "AutoScale"'
'yMax 1'
'yLabelIntervals 4'
'yShowLabelGrid'
'yAxisFormat "g"'
'yAxisPrecision 2'
'# Y2 axis properties'
'y2AxisSrc "AutoScale"'
'y2Max 1'
'# Trace Properties'
'numTraces 1'
'yPv {'
'  0 "SR01S___IBPM2Y_AM03"'
'}'
'xSigned {'
'  0 2818219'
'}'
'plotColor {'
'  0 index 14'
'}'
'endObjectProperties'
};

EDMCommand{8}  = sprintf('x %d', x);
EDMCommand{9}  = sprintf('y %d', y);
EDMCommand{10} = sprintf('w %d', Width);
EDMCommand{11} = sprintf('h %d', Height);
EDMCommand{15} = sprintf('yLabel "%s"', YLabel);
EDMCommand{42} = sprintf('  0 "%s"', PVName);
EDMCommand{18} = sprintf('font "%s-%s-r-%.1f"', lower(FontName), lower(FontWeight), FontSize);


