function yaxiss(x)
%YAXISS - Sets the vertical axis for all the axes in a figure
%  yaxiss(a)
%  yaxiss(a, FigList)
%  yaxiss(a, AxesList)
%
% INPUTS
%  1. a - [Ymin Ymax]
%  2. FigList - Vector of figure of axes handles
%               if not specified, changes just the y-axis on the current plot
%
%  See also yaxis, xaxiss, zaxiss, axis

%  Written by Greg Portmann

hgca = gca;

h = get(gcf,'children');

for i = 1:length(h)
    Hprops = get(h(i));
    
    % This is a clug to tell the difference between a plot and things like legends
    if isfield(Hprops, 'XTick')
        if isfield(Hprops, 'Tag')
            TagName = get(h(i), 'Tag');
            if isempty(TagName)
                %axes(h(i));
                yaxis(x, h(i));
            end
        end
    end
end
axes(hgca);
