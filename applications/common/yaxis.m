function varargout = yaxis(a, FigList)
%YAXIS - Sets the vertical axis
%  yaxis(a)
%  yaxis(a, FigList)
%  yaxis(a, AxesList)
%
%  INPUTS
%  1. a - [Ymin Ymax]
%  2. FigList - Vector of figure or axes handles
%               if not specified, changes just the y-axis on the current plot
%
%  See also yaxiss, xaxis, zaxis, axis

%  Written by Greg Portmann

if nargin == 0
    a = get(gca, 'YLim');
elseif nargin == 1
    set(gca, 'YLim', a);
elseif nargin >= 2
    for i = 1:length(FigList)
        if strcmpi(get(FigList(i),'Type'), 'figure')  % isgraphics(FigList(i)) && 
            % Handle is a figure
            haxes = gca;
            %figure(FigList(i));
            set(haxes, 'YLim', a);
            %axes(haxes);
        else
            % FigList is an axes handle
            set(FigList(i), 'YLim', a);
        end
    end
end

%if nargout >= 1 || nargin == 0
    varargout{1} = a(1:2);
%end