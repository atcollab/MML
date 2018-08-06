function [handle] = quad_table(title, name, value, position)
% [handle, b] =  quad_table(title, name, value) title is a string name is a
% column of strings with the names of the quads value is a column of
% strings with the values of the quads handle is handle to the mathworks
% MWFrame b is a handle to mathworks MWListbox b.getSelectedRows => gets
% you the index of the row currently selected by mouse, beginning with
% zero!!! -- example: [handle, b] = gui_sheet('nice table', qualist,
% vallist)
%
%
% requires Java runtime environment installed and mathworks components ver.
% 0.5

% GPL License (www.google.com), feel free to modify it, if you have any
% questions or interesting modifications, please send an email. there is a
% problem with some screen resolutions, you can modify it according to your
% needs, or add another input parameters you can access: cursor position,
% data in the table, visibility of the listbox or frame data. this file is
% far from complete, it is just an example on how to put a table into
% matlab gui (in this case only external window) if you have any idea on
% how to put a table into an existing gui window, i`ll be very thankful for
% hints and tips.

ncol=2;
nrows=size(name,2);
data = cell(nrows,2);

for i=1:nrows,
    data(i,:)=[name(i) value(i)] ;
end;
 t=uitable(data,[{'Name'} {'k'}]);
 set(t,'Editable',false);
 set(t,'Units','normalized')
 set(t,'Position',position);
 handle=t;