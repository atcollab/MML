function Cam = plotcam(FileName, h)
%PLOTCAM - Plot camera image
%
% To plot
% ImageData = reshape(Cam.Data, Cam.Cols, Cam.Rows)';
% imagesc(ImageData, 2^12);


ImageScaling = 2^12;


if nargin < 1
    FileName = '';
end

% Get data
if isempty(FileName) || ischar(FileName)
    if strcmpi(FileName, '.')
        [FileName, DirectoryName] = uigetfile('*.mat', 'Load Image File to ...');
        if FileName == 0
            FileName = '';
            return
        end
        FileName = [DirectoryName, FileName];
    elseif isempty(FileName)
        [FileName, DirectoryName] = uigetfile('*.mat', 'Load Image File to ...', getfamilydata('Directory','Image'));
        if FileName == 0
            FileName = '';
            return
        end
        FileName = [DirectoryName, FileName];
    end
    load(FileName);
elseif isstruct(FileName)
    Cam = FileName;
end

d = reshape(Cam.Data, Cam.Cols, Cam.Rows)';
XProjection = sum(d,1);
YProjection = sum(d,2);

if nargin < 2
    h = gcf;
else
    if isempty(h) || ischar(h)
        if strcmpi(h, 'New')
            h = figure;
        end
    end
end

clf reset

h1 = subplot(3,1,1);
hp1 = imagesc(d, [0 ImageScaling]);
%set(h1, 'PlotBoxAspectRatio',[1.3281 1 1]);
h2 = subplot(3,1,2);
h3 = subplot(3,1,3);
h = zoom;
%set(h,'ActionPreCallback', @plotcamzoomout);
set(h,'ActionPostCallback', @plotcamzoom);
%set(h,'RightClickAction', @plotcamzoom);
set(h,'Enable','on');

%set(h1,'ButtonDownFcn', @plotcamzoomout);


set(h1, 'Units', 'Normalized');
set(h2, 'Units', 'Normalized');
set(h3, 'Units', 'Normalized');

%set(h1, 'OuterPosition', [.1 -.025 .98 .87]);
%set(h1, 'OuterPosition', [.1 .05 .9 .875]);
set(h1, 'Position', [.17 .02 .82 .75]);
P1 = get(h1, 'Position');

%get(h1, 'ActivePositionProperty')

hp2 = plot(h2, 1:Cam.Cols, XProjection);
h = zoom;
setAllowAxesZoom(h, h2, false);
%set(h2, 'OuterPosition', [.1, .8 .98 .2]);
%set(h2, 'OuterPosition', [.1, .875 .94 .17]);
set(h2, 'Position', [P1(1) P1(2)+P1(4)+.01 P1(3) .19]);

hp3 = plot(h3, 1:Cam.Rows, YProjection);
h = zoom;
setAllowAxesZoom(h,h3,false);

set(h3, 'View', [90 90]);
set(h3, 'ydir', 'reverse');
set(h3, 'YAxisLocation', 'right');
%set(h3, 'OuterPosition', [-.025 -.075 .25, .88]);
set(h3, 'Position', [.005 P1(2) .15 P1(4)]);

% Store the image in the 3rd axes
set(h3, 'UserData', d);

P2 = get(h2, 'OuterPosition');
P3 = get(h3, 'OuterPosition');

set(h1, 'XTick',[]);
set(h1, 'XTickLabel','');
set(h1, 'YTick',[]);
set(h1, 'YTickLabel','');

set(h2, 'XTick',[]);
set(h2, 'XTickLabel','');
set(h3, 'XTick',[]);
set(h3, 'XTickLabel','');

set(h2, 'YTick',[]);
set(h2, 'YTickLabel','');
set(h3, 'YTick',[]);
set(h3, 'YTickLabel','');

set(h2, 'XLim', [1 Cam.Cols]);
set(h3, 'XLim', [1 Cam.Rows]);


% Set YLim very tight
YLim = [min(XProjection) max(XProjection)];
if diff(YLim) == 0
    set(h2, 'YLimMode', 'Auto');
else
    set(h2, 'YLim', YLim);
end

YLim = [min(YProjection) max(YProjection)];
if diff(YLim) == 0
    set(h3, 'YLimMode', 'Auto');
else
    set(h3, 'YLim', YLim);
end

%linkaxes([h1 h2], 'x');
%linkaxes([h1 h3], 'y');



% P3(2) = Pmin(2);
% P3(4) = Pmain(4);
% P2(1) = Pmain(1);
% P2(3) = Pmain(3);
% set(h2, 'OuterPosition', P2);
% set(h3, 'OuterPosition', P3);
% 

function [flag] = plotcamzoom(obj,event_obj)
h = get(obj,'children');
h = sort(h);
p = get(event_obj.Axes,'Position');


% Need to recompute projections
d = get(h(3), 'UserData');

XLim = floor(get(h(1),'XLim'));
YLim = floor(get(h(1),'YLim'));

if XLim(1) < 1
    XLim(1) = 1;
end
if YLim(1) < 1 
    YLim(1) = 1;
end
if XLim(1) > size(d,2)
    XLim(1) = size(d,2);
end
if YLim(1) > size(d,1)
    YLim(1) = size(d,1);
end
if diff(XLim) == 1
    XLim(2) = XLim(2)+1;
end
if diff(YLim) == 1
    YLim(2) = YLim(2)+1;
end

%dzoom = d(XLim(1):XLim(2),YLim(1):YLim(2));
dzoom = d(YLim(1):YLim(2),XLim(1):XLim(2));

XProjection = sum(dzoom, 1);
YProjection = sum(dzoom, 2);

h2 = get(h(2),'children');
h3 = get(h(3),'children');

% XLim
% YLim

set(h2,'XData', XLim(1):XLim(2), 'YData', XProjection);
set(h3,'XData', YLim(1):YLim(2), 'YData', YProjection);

set(h(1),'XLim', XLim);
set(h(1),'YLim', YLim);
set(h(2),'XLim', XLim);
set(h(3),'XLim', YLim);

% Set YLim very tight
YLim = [min(XProjection) max(XProjection)];
if diff(YLim) == 0
    set(h(2), 'YLimMode', 'Auto');
else
    set(h(2), 'YLim', YLim);
end

YLim = [min(YProjection) max(YProjection)];
if diff(YLim) == 0
    set(h(3), 'YLimMode', 'Auto');
else
    set(h(3), 'YLim', YLim);
end

fprintf('X-Projection: min = %d  max = %d  sum= %f\n',   min(XProjection), max(XProjection), sum(XProjection));
fprintf('Y-Projection: min = %d  max = %d  sum= %f\n\n', min(YProjection), max(YProjection), sum(YProjection));


%set(h(2),'YTick','auto')
%set(h(2),'YTickMode','auto')
%set(h(2),'YTickLabelMode','auto')

%function plotcamzoomout(varargin)
%a=1
