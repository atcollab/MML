function varargout = zaxis(a, FigList)
%ZAXISS - Sets the z-axis
%  zaxis(a)
%  zaxis(a, FigureList)
%  zaxis(a, AxesList)
%
% INPUTS
%  1. a - [Zmin Zmax]
%  2. FigList - Vector of figure or axes handles
%               if not specified, changes just the z-axis on the current plot
%
%  See also zaxiss, xaxis, yaxis, axis

%  Written by Greg Portmann


if nargin == 0
    a = get(gca, 'ZLim');
elseif nargin == 1
    set(gca, 'ZLim', a);
elseif nargin >= 2
    for i = 1:length(FigList)
        if strcmpi(get(FigList(i),'Type'), 'figure')  % isgraphics(FigList(i)) && 
            % Handle is a figure
            haxes = gca;
            %figure(FigList(i));
            set(haxes, 'ZLim', a);
            %axes(haxes);
        else
            % FigList is an axes handle
            set(FigList(i), 'ZLim', a);
        end
    end
end

%if nargout >= 1 || nargin == 0
    varargout{1} = a(1:2);
%end
