function hFigure = plotepbitest2(FN, Options)

if nargin < 1 || isempty(FN)
    [PlotFile, DirectoryPath] = uigetfile({'*.mat','MAT-files (*.mat)'},'Pick an EPBI file', 'MultiSelect', 'off');
    if PlotFile == 0
        return
    end
    FN = [DirectoryPath, PlotFile];
end
if nargin < 2
    Options = '';
end

load(FN);

LineType = '.-';


% New figure
hFig = figure;
clf reset


if strcmpi(Options, 'html')
    %p = get(hFig, 'Position');
    %set(hFig, 'Position', FigurePosition);
    set(hFig, 'InvertHardcopy', 'Off');
end

p = get(hFig, 'Position');
p(1) = 0;
p(2) = 0;
p(3) = 1.5*p(3);
p(4) = 1.3*p(4);
set(hFig, 'Position', p);


%LegendCell = ;
%legend(iAxes, LegendCell, 'Location', 'NorthWest');
%set(handles.Legend, 'Interpreter', 'None');

h = plot(EPBIData.t-EPBIData.t(1), EPBIData.TC');

title(sprintf('Sector %d  %s', EPBIData.Sector , EPBIData.HeaterName), 'Fontsize', 16, 'FontWeight', 'Bold');
xlabel('Time [Seconds]',  'FontSize', 14, 'FontWeight', 'Bold');
ylabel('Temperature [C]', 'FontSize', 14, 'FontWeight', 'Bold');

% Trip
% EPBIData.TripIndex(i)       = size(d,2);
% EPBIData.TripDate(i)        = now;
% EPBIData.HeaterOnTime(i)    = HeaterOnTime;
% EPBIData.TripTemperature(i) = TC(i,1);

hold on
for i = 1:length(EPBIData.TripIndex)
    if ~isnan(EPBIData.TripIndex(i))
        j = EPBIData.TripIndex(i);
        LineColor = get(h(i), 'Color');
        hmarker = plot(EPBIData.t(j)-EPBIData.t(1), EPBIData.TC(i,j));
        set(hmarker, 'Marker', 'diamond');
        set(hmarker, 'MarkerSize', 10);
        set(hmarker, 'MarkerEdgeColor', LineColor);
        set(hmarker, 'MarkerFaceColor', LineColor);
    end
end

% Add line to plot
if ~isempty(EPBIData.t) && ~isempty(EPBIData.HeaterIndex) && ~isnan(EPBIData.HeaterIndex)
    t = EPBIData.t(EPBIData.HeaterIndex) - EPBIData.t(1);
    TCmin = min(EPBIData.TC(:,EPBIData.HeaterIndex));
    TCmax = max(EPBIData.TC(:,EPBIData.HeaterIndex));
    Range = TCmax - TCmin;
    plot([t t], [TCmin-.2*Range TCmax+.2*Range], 'LineWidth', 5, 'Color', [0 0 0]);
end
hold off

%axis tight;

% Add a legend
for i = 1:length(EPBIData.Limit)
    LegendCell{i,1} = sprintf('%s: %.2f Limit', deblank(EPBIData.ChannelNames(i,9:end-4)), EPBIData.Limit(i));
    
    % EPBIData.TripDate(i)        = datenum;
    % EPBIData.HeaterOnTime(i)    = HeaterOnTime;
    % EPBIData.TripTemperature(i) = TC(i,1);
    if ~isnan(EPBIData.TripTemperature)
        if EPBIData.HeaterOnTime > 0
            LegendCell{i} = sprintf('%s, %.2f (%.1f sec) Trip', LegendCell{i}, EPBIData.TripTemperature(i), EPBIData.HeaterOnTime(i));
        else
            LegendCell{i} = sprintf('%s, %.2f (Heater Off) Trip', LegendCell{i}, EPBIData.TripTemperature(i));
        end
    end
end
legend(LegendCell, 'Location', 'NorthWest');


if nargout > 0
    hFigure = hFig;
end

