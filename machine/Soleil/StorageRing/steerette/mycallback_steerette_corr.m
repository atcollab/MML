function mycallback_steerette_corr(arg1,arg2,hObject, eventdata, handles)

% replot correcteur H/V
h9     = get(handles.axes9,'Children');
hbar9  = findobj(h9,'-regexp','Tag','bar[1]');
h10     = get(handles.axes10,'Children');
hbar10  = findobj(h10,'-regexp','Tag','bar[2]');
liste_HCOR = getam('HCOR', handles.mode);
liste_VCOR = getam('VCOR', handles.mode); 

% bargraphes
set(hbar9(1),'YData',liste_HCOR,'Visible','On');
set(hbar10(1),'YData',liste_VCOR,'Visible','On');
