%==========================================================
function varargout = screensizecm
%==========================================================
%determine size of user screen in units of cm
h = findobj('Type', 'root');
units=get(h,'Units');
set(h, 'Units', 'centimeters');
screen_position = get(findobj('Type', 'root'), 'screensize');
set(h,'Units',units);

varargout{1} = screen_position(3);
varargout{2} = screen_position(4);
