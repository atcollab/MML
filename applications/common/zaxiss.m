function zaxiss(x)
%ZAXISS - Sets the z-axis for all the axes in a figure
%  zaxiss(a)
%  zaxiss(a, FigureList)
%  zaxiss(a, AxesList)
%
% INPUTS
%  1. a - [Zmin Zmax]
%  2. FigList - Vector of figure or axes handles
%               if not specified, changes just the z-axis on the current plot
%
%  See also zaxis, xaxiss, yaxiss, axis

%  Written by Greg Portmann

hgca = gca;

h = get(gcf,'children');

for i = 1:length(h)
    Hprops = get(h(i));
    if isfield(Hprops, 'ZTick')
        axes(h(i));
        zaxis(x);
    end
end

axes(hgca);
